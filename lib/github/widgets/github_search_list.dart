import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:github_repo_search/github/bloc_search/search_bloc.dart';
import 'package:github_repo_search/github/common/common.dart';
import 'package:github_repo_search/github/models/github_code.dart';
import 'package:github_repo_search/github/models/github_rate_limit.dart';
import 'package:github_repo_search/github/models/github_repository.dart';
import 'package:github_repo_search/github/models/github_user.dart';
import 'package:github_repo_search/github/models/search_type.dart';

import 'bottom_loader.dart';
import 'list_items/github_code_list_item.dart';
import 'list_items/github_repo_list_item.dart';
import 'list_items/github_user_list_item.dart';

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
  late Timer _timer;
  late int _resetTime;

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
        if (state.rateLimits.remaining == 0 && state.rateLimits.reset != 0) {
          String message = 'exceeded'.tr();
          return _getHintAndInfoMessage(state, message: message);
        }
        switch (state.status) {
          case SearchStatus.failure:
            return _getHintAndInfoMessage(state);
          case SearchStatus.success:
            if (state.searchResults.item2.isEmpty) {
              return _getHintAndInfoMessage(state, message: 'noResultsFound'.tr());
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
    _timer.cancel();
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
    return currentScroll >= maxScroll;
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
    _resetTime = Common.getSecondsTillReset(rateLimits.reset);
    _startTimer();
    bool isLargeScreen = MediaQuery.of(context).size.width > Common.largeScreenSize;

    return Container(
      padding: isLargeScreen ?
        const EdgeInsets.symmetric(horizontal: 20.0) : const EdgeInsets.symmetric(),
      height: 42,
      width: double.infinity,
      color: Theme.of(context).primaryColorDark,
      child: Row(
        children: [
          _buildPerScreenSize(isLargeScreen),
          Expanded(
            flex: 15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQueryRatesTexts(
                        'queryLimitPerMinute: ', rateLimits.limit),
                    _buildQueryRatesTexts('queriesUsed: ', rateLimits.used),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'resettingIn: '.tr() +
                          _resetTime.toString() +
                          ' seconds'.tr(),
                      style:
                      const TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    _buildQueryRatesTexts('queriesLeft: ', rateLimits.remaining),
                  ],
                ),
              ],
            ),
          ),
          _buildPerScreenSize(isLargeScreen),
        ],
      ),
    );
  }

  _buildQueryRatesTexts(String text, int value) {
    return Text(
      text.tr() + value.toString(),
      style: const TextStyle(color: Colors.white, fontSize: 15),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPerScreenSize(bool isLargeScreen) {
    return isLargeScreen ?
      Container() :
      Expanded(
        child: Container(),
      );
  }

  Widget _getHintAndInfoMessage(SearchState state, {String? message}) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            child: Center(
              child: Text(
                message ?? state.searchResults.item1.longPrintingString?.tr() ?? '',
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

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_resetTime == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _resetTime--;
          });
        }
      },
    );
  }
}
