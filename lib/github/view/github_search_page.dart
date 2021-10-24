import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repo_search/github/github.dart';

String currentQuery = '';

class GitHubSearchPage extends StatelessWidget {
  const GitHubSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Repository Search')),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) =>
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter GitHub repository name...'),
                  onChanged: (query) {
                    currentQuery = query;
                    context.read<SearchBloc>().add(FetchQuery(query, true));
                  },
                ),
              ),
              Expanded(
               child: GitHubSearchList(currentQuery),
              ),
            ],
          ),
      ),
    );
  }
}
