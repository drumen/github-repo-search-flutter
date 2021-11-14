import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'github/search_bloc/search_bloc.dart';
import 'github/view/github_search_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => SearchBloc(),
        child: const GitHubSearchPage(),
      ),
    );
  }
}