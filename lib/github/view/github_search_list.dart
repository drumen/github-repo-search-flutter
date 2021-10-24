import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repo_search/github/github.dart';

class GitHubSearchList extends StatefulWidget {
  const GitHubSearchList(this.query, {Key? key}) : super(key: key);
  final String query;

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
        if (widget.query == '') {
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
            if (state.searchResults.isEmpty) {
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
                return index >= state.searchResults.length
                    ? const BottomLoader()
                    : GitHubRepoListItem(
                          index,
                          gitHubRepo: state.searchResults[index]
                      );
              },
              itemCount: state.hasReachedMax
                  ? state.searchResults.length
                  : state.searchResults.length + 1,
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
    if (_isBottom)  _postBloc.add(FetchQuery(widget.query, false));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
