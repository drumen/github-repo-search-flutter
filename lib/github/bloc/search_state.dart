part of 'search_bloc.dart';

enum SearchStatus { initial, success, failure, queryRateExceeded }

class SearchState {
  const SearchState({
    this.status = SearchStatus.initial,
    this.searchResults = const <GitHubRepository>[],
    this.hasReachedMax = false,
  });

  final SearchStatus status;
  final List<GitHubRepository> searchResults;
  final bool hasReachedMax;

  SearchState copyWith({
    SearchStatus? status,
    List<GitHubRepository>? searchResults,
    bool? hasReachedMax,
  }) {
    return SearchState(
      status: status ?? this.status,
      searchResults: searchResults ?? this.searchResults,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''SearchState { status: $status, hasReachedMax: $hasReachedMax, results: ${searchResults.length} }''';
  }
}
