part of 'search_bloc.dart';

abstract class SearchEvent {
}

class FetchQuery extends SearchEvent {
  FetchQuery(this.query, this.searchType, this.resetSearch);
  final String query;
  final SearchType searchType;
  final bool resetSearch;
}
