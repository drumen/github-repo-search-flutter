import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repo_search/github/github.dart';
import 'package:github_repo_search/github/view/github_repo_details_page.dart';
import 'package:github_repo_search/github/widgets/github_repo_details.dart';

class GitHubSearchPage extends StatefulWidget {
  const GitHubSearchPage({Key? key}) : super(key: key);

  @override
  _GitHubSearchPageState createState() => _GitHubSearchPageState();
}

class _GitHubSearchPageState extends State<GitHubSearchPage> {

  String _currentQuery = '';
  bool _isLargeScreen = false;
  GitHubRepository? _selectedRepo;
  SearchType _searchType = SearchType.repo;

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
                    _currentQuery = query;
                    context.read<SearchBloc>().add(FetchQuery(
                        query, _searchType, true));
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Search for:'),
                  Radio(
                    value: SearchType.repo,
                    groupValue: _searchType,
                    onChanged: (value) {
                      _searchType = value as SearchType;
                      setState(() {});
                      context.read<SearchBloc>().add(FetchQuery(
                          _currentQuery, _searchType, true));
                    }
                  ),
                  const Text('Repo'),
                  Radio(
                    value: SearchType.owner,
                    groupValue: _searchType,
                    onChanged: (value) {
                      _searchType = value as SearchType;
                      setState(() {});
                      context.read<SearchBloc>().add(FetchQuery(
                          _currentQuery, _searchType, true));
                    }
                  ),
                  const Text('User'),
                  Radio(
                    value: SearchType.code,
                    groupValue: _searchType,
                    onChanged: (value) {
                      _searchType = value as SearchType;
                      setState(() {});
                      context.read<SearchBloc>().add(FetchQuery(
                          _currentQuery, _searchType, true));
                    }
                  ),
                  const Text('Code'),
                ],
              ),

              Expanded(
               child: OrientationBuilder(builder: (context, orientation) {

                 if (MediaQuery.of(context).size.width > 700) {
                   _isLargeScreen = true;
                 } else {
                   _isLargeScreen = false;
                 }

                 return Row(children: <Widget>[
                   Expanded(
                     child: GitHubSearchList(
                       _currentQuery, _searchType, (gitHubRepo) {
                         if (_isLargeScreen) {
                           _selectedRepo = gitHubRepo;
                           setState(() {});
                         } else {
                           Navigator.push(context, MaterialPageRoute(
                             builder: (context) {
                               return GitHubRepoDetailsPage(gitHubRepo);
                             },
                           ));
                         }
                     }),
                   ),
                   _isLargeScreen ?
                     Expanded(child: GitHubRepoDetailsWidget(
                        gitHubRepo: _selectedRepo
                      )
                    ) : Container(),
                 ]);
               }),
              ),
            ],
          ),
      ),
    );
  }
}
