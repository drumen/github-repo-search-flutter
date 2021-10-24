part of 'search_bloc.dart';

abstract class SearchEvent {
}

class FetchQuery extends SearchEvent {
  FetchQuery(this.query, this.resetSearch);
  final String query;
  final bool resetSearch;
}
