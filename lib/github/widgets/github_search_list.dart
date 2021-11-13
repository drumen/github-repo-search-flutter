import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repo_search/github/bloc/search_bloc.dart';
import 'package:github_repo_search/github/common/common.dart';
import 'package:github_repo_search/github/models/github_code.dart';
import 'package:github_repo_search/github/models/github_rate_limit.dart';
import 'package:github_repo_search/github/models/github_repository.dart';
import 'package:github_repo_search/github/models/github_user.dart';
import 'package:github_repo_search/github/models/search_type.dart';

import 'bottom_loader.dart';
import 'github_code_list_item.dart';
import 'github_repo_list_item.dart';
import 'github_user_list_item.dart';

typedef ObjectSelectedCallback = Null Function(Object gitHubResult);

class GitHubSearchList extends StatefulWidget {
  const GitHubSearchList(
      this._query,
      this._searchType,
      this._onItemSelected,
      {Key? key}) : super(key: key);

  final String _query;
  final SearchType _searchType;
  final ObjectSelectedCallback _onItemSelected;

  @override
  _GitHubSearchListState createState() => _GitHubSearchListState();
}

class _GitHubSearchListState extends State<GitHubSearchList> {

  final _scrollController = ScrollController();
  late SearchBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _postBloc = context.read<SearchBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (widget._query == '') {
          return _getHintAndInfoMessage(state);
        }
        if (state.rateLimits.remaining == 0) {
          String message = 'Slow down there a bit fellow...\n'
                           'Query rate limit was exceeded.\n'
                           'Hold on a bit and you will\n'
                           'be able to search again.';
          return _getHintAndInfoMessage(state, message: message);
        }
        switch (state.status) {
          case SearchStatus.queryRateExceeded:
            return const Center(
              child: Text(
                'Slow down there a bit fellow...\nThere is a 99.9% chance that\n'
                'query rate limit was exceeded.\nHold on a bit and you will\n'
                'be able to search again.',
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                ),
              ),
            );
          case SearchStatus.failure:
            return _getHintAndInfoMessage(state);
          case SearchStatus.success:
            if (state.searchResults.item2.isEmpty) {
              return _getHintAndInfoMessage(state, message: 'No results found.');
            } else {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return index >= state.searchResults.item2.length
                            ? const BottomLoader()
                            : _searchTypeListItem(
                            state.searchResults.item1,
                            index,
                            state.searchResults.item2[index],
                                (selectedGitHubObject) {
                              widget._onItemSelected(selectedGitHubObject);
                            }
                        );
                      },
                      itemCount: state.hasReachedMax
                          ? state.searchResults.item2.length
                          : state.searchResults.item2.length + 1,
                      controller: _scrollController,
                    ),
                  ),
                  _buildRateLimitsTextBox(state.rateLimits),
                ]
              );
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _postBloc.add(FetchQuery(widget._query, widget._searchType, false));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Widget _searchTypeListItem(
      SearchType searchType,
      int index,
      Object searchResult,
      Null Function(Object) itemSelectedCallback
  ) {
    switch (searchType) {
      case SearchType.repositories:
        return GitHubRepoListItem(
            index,
            searchResult as GitHubRepository,
            itemSelectedCallback
        );
      case SearchType.users:
        return GitHubUserListItem(
            index,
            searchResult as GitHubUser,
            itemSelectedCallback
        );
      case SearchType.code:
        return GitHubCodeListItem(
            index,
            searchResult as GitHubCode,
            itemSelectedCallback
        );
      default:
        return Container();
    }
  }

  Widget _buildRateLimitsTextBox(GitHubRateLimit rateLimits) {
    return Container(
      height: 42,
      width: double.infinity,
      color: Colors.lightBlue[800],
      child: Text(
        'Query limit per minute: ${rateLimits.limit}     Queries used: ${rateLimits.used}\n'
            'Queries left: ${rateLimits.remaining}     Reseting in: '
            '${Common.getSecondsTillReset(rateLimits.reset)}',
        style: const TextStyle(color: Colors.white, fontSize: 17),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _getHintAndInfoMessage(SearchState state, {String? message}) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            child: Center(
              child: Text(
                message ?? state.searchResults.item1.longPrintingString ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          _buildRateLimitsTextBox(state.rateLimits),
        ]
    );
  }
}