import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:github_repo_search/github/models/github_code.dart';
import 'package:github_repo_search/github/models/github_repository.dart';
import 'package:github_repo_search/github/models/github_user.dart';
import 'package:github_repo_search/github/models/search_type.dart';
import 'package:tuple/tuple.dart';

part 'search_event.dart';
part 'search_state.dart';

// GitHub Personal Access Token
String gitHubPublicAccessToken = dotenv.get('GITHUB_PERSONAL_ACCESS_TOKEN');

const _host = 'https://api.github.com';
const _contextRoot = '/search/';

class Exception403 implements Exception {
  Exception403();
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {

    httpClient = Dio();

    httpClient.options.baseUrl = _host + _contextRoot;
    httpClient.options.headers[HttpHeaders.authorizationHeader] = 'token $gitHubPublicAccessToken';
    httpClient.options.connectTimeout = 5000;
    httpClient.options.receiveTimeout = 3000;

    on<FetchQuery>(
      _onGitHubSearchFetched,
    );
  }

  late Dio httpClient;

  Future<void> _onGitHubSearchFetched(
    FetchQuery event,
    Emitter<SearchState> emit,
  ) async {
    if (state.hasReachedMax && !event.resetSearch) return;
    try {
      if (event.resetSearch) {
        emit(state.copyWith(
          status: SearchStatus.resetList,
          searchResults: Tuple2(event.searchType, []),
          hasReachedMax: true,
        ));
      }
      if (state.status == SearchStatus.initial || event.resetSearch) {
        final searchResults =
            await _fetchGitHubRepos(event.query, event.searchType);
        if (searchResults.item2.length < 30) {
          return emit(state.copyWith(
            status: SearchStatus.success,
            searchResults: searchResults,
            hasReachedMax: true,
          ));
        } else {
          return emit(state.copyWith(
            status: SearchStatus.success,
            searchResults: searchResults,
            hasReachedMax: false,
          ));
        }
      }
      final searchResults =
        await _fetchGitHubRepos(
            event.query,
            event.searchType,
            state.searchResults.item2.length ~/ 30 + 1
        );
        searchResults.item2.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: SearchStatus.success,
                searchResults:
                    Tuple2(
                        searchResults.item1,
                        List.of(state.searchResults.item2)..addAll(searchResults.item2)),
                hasReachedMax: false,
              ),
            );
    } on Exception403 {
      emit(state.copyWith(status: SearchStatus.queryRateExceeded));
    } catch (_) {
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }

  Future<Tuple2<SearchType, List<Object>>> _fetchGitHubRepos(
      String query,
      SearchType searchType,
      [int page = 1]) async {

    var queryParameters = _getQueryParameters(query, searchType, page);

    log('Sending GitHub query: $queryParameters');

    Response? response;

    try {
      response = await httpClient.get(
          searchType.toShortString(),
          queryParameters: queryParameters
      );
    } on DioError catch (e) {
      if (e.response != null) {
        log('Received GitHub response with status code: ${e.response!.statusCode.toString()} '
            '(${e.response!.statusMessage.toString()})');

        if (e.response!.statusCode == 403) {
          throw Exception403();
        }
      } else {
        log('Something happened in setting up or sending the request that triggered an Error. '
            'Status message: ${e.response!.statusMessage.toString()} and Message: ${e.message}');
      }
    }

    log('Received GitHub response with status code: ${response!.statusCode.toString()} '
        '(${response.statusMessage.toString()})');

    if (response.statusCode == 200) {
      final items = response.data['items'] as List;
      List<Object> searchList = [];

      switch (searchType) {
        case SearchType.repositories:
          searchList = items.map((dynamic json) {
            return GitHubRepository.fromJson(json as Map<String, dynamic>);
          }).toList();
          break;
        case SearchType.users:
          searchList = items.map((dynamic json) {
            return GitHubUser.fromJson(json as Map<String, dynamic>);
          }).toList();
          break;
        case SearchType.code:
          searchList = items.map((dynamic json) {
            return GitHubCode.fromJson(json as Map<String, dynamic>);
          }).toList();
          break;
      }

      return Tuple2(searchType, searchList);
    }

    throw Exception('error fetching github');
  }

  Map<String, dynamic> _getQueryParameters(
      String query,
      SearchType searchType,
      int page
  ) {
    switch (searchType) {
      case SearchType.repositories:
        return <String, dynamic>{
          'accept': 'application/vnd.github.v3+json',
          'q': query,
          'in': 'name',
          'sort': 'updated',
          'per_page': '30',
          'page': '$page'
        };
      case SearchType.users:
        return <String, dynamic>{
          'accept': 'application/vnd.github.v3+json',
          'q': query,
          'in': 'name',
          'sort': 'repositories',
          'per_page': '30',
          'page': '$page'
        };
      case SearchType.code:
        return <String, dynamic>{
          'accept': 'application/vnd.github.v3+json',
          'q': query,
          'per_page': '30',
          'page': '$page'
        };
    }
  }
}
