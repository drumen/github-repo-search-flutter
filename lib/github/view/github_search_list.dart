import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repo_search/github/github.dart';

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
          return const Center(
            child: Text(
              'Enter the name of GitHub repository\nyou are searching for...',
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        }
        switch (state.status) {
          case SearchStatus.queryRateExceeded:
            return const Center(
              child: Text(
                'Slow down there a bit fellow...\nQuery rate limit was '
                'exceeded.\nHold on a bit and you will\nbe able '
                'to search again.',
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                ),
              ),
            );
          case SearchStatus.failure:
            return const Center(
              child: Text(
                'Enter the name of GitHub repository\nyou are searching for...',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          case SearchStatus.success:
            if (state.searchResults.item2.isEmpty) {
              return const Center(
                child: Text(
                  'No results found.',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                )
              );
            }
            return ListView.builder(
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
            );
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
        return GitHubRepoListItem(
            index,
            searchResult as GitHubRepository,
            itemSelectedCallback
        );
      default:
        return Container();
    }
  }
}
