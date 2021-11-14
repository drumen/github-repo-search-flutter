import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'github/bloc_search/search_bloc.dart';
import 'github/bloc_user/user_bloc.dart';
import 'github/view/github_search_page.dart';


class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<SearchBloc>(
            create: (BuildContext context) => SearchBloc(),
          ),
          BlocProvider<UserBloc>(
            create: (BuildContext context) => UserBloc(),
          ),
        ],
        child: const GitHubSearchPage(),
      ),
    );
  }
}
