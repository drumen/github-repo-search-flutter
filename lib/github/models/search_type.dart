enum SearchType { repositories, users, code }

extension ParseToString on SearchType {
  String toShortString() {
    return toString().split('.').last;
  }
}
