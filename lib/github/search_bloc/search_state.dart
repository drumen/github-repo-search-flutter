part of 'search_bloc.dart';

enum SearchStatus { initial, success, failure, resetList }

class SearchState {
  const SearchState({
    this.status = SearchStatus.initial,
    this.searchResults = const Tuple2(SearchType.repositories, []),
    this.hasReachedMax = false,
    this.rateLimits = const GitHubRateLimit(limit: 0, used: 0, remaining: 0, reset: 0),
    this.realName = '',
  });

  final SearchStatus status;
  final Tuple2<SearchType, List<Object>> searchResults;
  final bool hasReachedMax;
  final GitHubRateLimit rateLimits;
  final String realName;

  SearchState copyWith({
    SearchStatus? status,
    Tuple2<SearchType, List<Object>>? searchResults,
    bool? hasReachedMax,
    GitHubRateLimit? rateLimits,
    String? realName,
  }) {
    return SearchState(
      status: status ?? this.status,
      searchResults: searchResults ?? this.searchResults,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      rateLimits: rateLimits ?? this.rateLimits,
      realName: realName ?? this.realName,
    );
  }

  @override
  String toString() {
    return '''SearchState { status: $status, hasReachedMax: $hasReachedMax, results: ${searchResults.item2.length} }''';
  }
}
