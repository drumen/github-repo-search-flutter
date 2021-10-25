part of 'search_bloc.dart';

enum SearchStatus { initial, success, failure, queryRateExceeded, resetList }

class SearchState {
  const SearchState({
    this.status = SearchStatus.initial,
    this.searchResults = const Tuple2(SearchType.repositories, []),
    this.hasReachedMax = false,
  });

  final SearchStatus status;
  final Tuple2<SearchType, List<Object>> searchResults;
  final bool hasReachedMax;

  SearchState copyWith({
    SearchStatus? status,
    Tuple2<SearchType, List<Object>>? searchResults,
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
    return '''SearchState { status: $status, hasReachedMax: $hasReachedMax, results: ${searchResults.item2.length} }''';
  }
}
