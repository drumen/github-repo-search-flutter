import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:github_repo_search/github/github.dart';
import 'package:http/http.dart' as http;

part 'search_event.dart';
part 'search_state.dart';

// public access token
const publicAccessToken = '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';

const _host = 'api.github.com';
const _contextRoot = '/search/repositories';

class Exception403 implements Exception {
  Exception403();
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.httpClient}) : super(const SearchState()) {
    on<FetchQuery>(
      _onGitHubSearchFetched,
    );
  }

  final http.Client httpClient;

  Future<void> _onGitHubSearchFetched(
    FetchQuery event,
    Emitter<SearchState> emit,
  ) async {
    if (state.hasReachedMax && !event.resetSearch) return;
    try {
      if (state.status == SearchStatus.initial || event.resetSearch) {
        final searchResults = await _fetchGitHubRepos(event.query);
        if (searchResults.length < 30) {
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
            state.searchResults.length ~/ 30 + 1
        );
        searchResults.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: SearchStatus.success,
                searchResults:
                    List.of(state.searchResults)..addAll(searchResults),
                hasReachedMax: false,
              ),
            );
    } on Exception403 {
      emit(state.copyWith(status: SearchStatus.queryRateExceeded));
    } catch (_) {
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }

  Future<List<GitHubRepository>> _fetchGitHubRepos(
      String query,
      [int page = 1]) async {

    var queryParameters =
      <String, dynamic>{
        'accept': 'application/vnd.github.v3+json',
        'q': query,
        'in': 'name',
        'sort': 'updated',
        'per_page': '30',
        'page': '$page'
      };

    log('Sending GitHub query: $queryParameters');

    final response = await httpClient.get(
      Uri.https(
        _host,
        _contextRoot,
        queryParameters,
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'token $publicAccessToken',
      },
    );

    log('Received GitHub response with status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map;
      final items = body['items'] as List;
      final searchList = items.map((dynamic json) {
        return GitHubRepository.fromJson(json as Map<String, dynamic>);
      }).toList();
      return searchList;
    } else if (response.statusCode == 403) {
      throw Exception403();
    }

    throw Exception('error fetching github');
  }
}
