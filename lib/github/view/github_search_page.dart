import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repo_search/github/common/common.dart';
import 'package:github_repo_search/github/models/search_type.dart';
import 'package:github_repo_search/github/bloc_search/search_bloc.dart';
import 'package:github_repo_search/github/widgets/github_search_list.dart';

import 'github_details_page.dart';

class GitHubSearchPage extends StatefulWidget {
  const GitHubSearchPage({Key? key}) : super(key: key);

  @override
  _GitHubSearchPageState createState() => _GitHubSearchPageState();
}

class _GitHubSearchPageState extends State<GitHubSearchPage> {

  String _currentQuery = '';
  bool _isLargeScreen = false;
  Object? _selectedObject;
  SearchType _searchType = SearchType.repositories;

  @override
  Widget build(BuildContext context) {
    _isLargeScreen = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Search')),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) =>
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: OrientationBuilder(builder: (context, orientation) {
                  return Flex(
                    direction: _isLargeScreen ? Axis.horizontal : Axis.vertical,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.loose,
                        child:TextField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: _searchType.shortPrintingString,
                          ),
                          onChanged: (query) {
                            if (_currentQuery != query) {
                              _currentQuery = query;
                              context.read<SearchBloc>().add(FetchQuery(
                                  query, _searchType, true)
                              );
                            }
                          },
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('Search for:'),
                              Radio(
                                  value: SearchType.repositories,
                                  groupValue: _searchType,
                                  onChanged: (value) {
                                    _searchType = value as SearchType;
                                    _selectedObject = null;
                                    setState(() {
                                      context.read<SearchBloc>().add(FetchQuery(
                                          _currentQuery, _searchType, true));
                                    });
                                  }
                              ),
                              const Text('Repo'),
                              Radio(
                                  value: SearchType.users,
                                  groupValue: _searchType,
                                  onChanged: (value) {
                                    _searchType = value as SearchType;
                                    _selectedObject = null;
                                    setState(() {
                                      context.read<SearchBloc>().add(FetchQuery(
                                        _currentQuery, _searchType, true));
                                    });
                                  }
                              ),
                              const Text('User'),
                              Radio(
                                  value: SearchType.code,
                                  groupValue: _searchType,
                                  onChanged: (value) {
                                    _searchType = value as SearchType;
                                    _selectedObject = null;
                                    setState(() {
                                      context.read<SearchBloc>().add(FetchQuery(
                                          _currentQuery, _searchType, true));
                                    });
                                  }
                              ),
                              const Text('Code'),
                            ],
                          ),
                        ),
                     ],
                  );
                }),
              ),
              Expanded(
               child: OrientationBuilder(builder: (context, orientation) {
                 return Row(children: <Widget>[
                   Expanded(
                     child: GitHubSearchList(
                       _currentQuery, _searchType, (gitHubObject) {
                         if (_isLargeScreen) {
                           _selectedObject = gitHubObject;
                           setState(() {});
                         }
                         else {
                           _selectedObject = gitHubObject;
                           Navigator.push(context, MaterialPageRoute(
                             builder: (context) {
                               return GitHubDetailsPage(_searchType, gitHubObject);
                             },
                           ));
                         }
                     }),
                   ),
                   _isLargeScreen ?
                     Expanded(child: Common.getDetailsWidget(_searchType, _selectedObject)) :
                     Container(),
                  ]);
                }),
              ),
            ],
          ),
      ),
    );
  }
}
