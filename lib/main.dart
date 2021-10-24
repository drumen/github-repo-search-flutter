import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:github_repo_search/app.dart';
import 'package:github_repo_search/simple_bloc_observer.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  Bloc.observer = SimpleBlocObserver();
  runApp(const App());
}
