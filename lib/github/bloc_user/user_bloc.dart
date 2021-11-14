import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'user_event.dart';
part 'user_state.dart';

// GitHub Personal Access Token
String gitHubPublicAccessToken = dotenv.get('GITHUB_PERSONAL_ACCESS_TOKEN');

const _host = 'https://api.github.com';
const _realNameRoot = '/users/';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {

    httpClient = Dio();

    httpClient.options.baseUrl = _host;
    httpClient.options.headers[HttpHeaders.authorizationHeader] = 'token $gitHubPublicAccessToken';
    httpClient.options.connectTimeout = 5000;
    httpClient.options.receiveTimeout = 3000;

    on<FetchUser>(
      _onGitHubUserFetched,
    );
  }

  late Dio httpClient;

  Future<void> _onGitHubUserFetched(
    FetchUser event,
    Emitter<UserState> emit,
  ) async {
    try {
      final userResult = await _fetchGitHubUser(event.userName);
        return emit(state.copyWith(
          realName: userResult,
        ));
    } catch (_) {
      emit(state.copyWith(realName: ''));
    }
  }

  Future<String> _fetchGitHubUser(String userName) async {

    log('Sending GitHub user query: $userName');

    String realName = '';
    Response? userResponse;

    try {
      userResponse = await httpClient.get(
          _realNameRoot + userName
      );
    } on DioError catch (e) {
      if (e.response != null) {
        log('Received GitHub user query response with status code: ${e.response!.statusCode.toString()} '
            '(${e.response!.statusMessage.toString()})');
      } else {
        log('Something happened in setting up or sending the user query request that triggered an Error. '
            'Status message: ${e.response!.statusMessage.toString()} and Message: ${e.message}');
      }
    }

    log('Received GitHub query response with status code: ${userResponse!.statusCode.toString()} '
        '(${userResponse.statusMessage.toString()})');

    if (userResponse.data['name'] != null) {
      realName = userResponse.data['name'];
    } else {
      realName = '<no name>';
    }

    log('Fetched real name: $realName for username: $userName');

    return realName;
  }
}
