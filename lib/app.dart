import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repo_search/github/github.dart';
import 'package:http/http.dart' as http;

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => SearchBloc(httpClient: http.Client()),
        child: const GitHubSearchPage(),
      ),
    );
  }
}