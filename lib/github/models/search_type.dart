enum SearchType { repositories, users, code}

extension ParseToString on SearchType {
  String toShortString() {
    return toString().split('.').last;
  }
}

extension SearchTypeShortPrint on SearchType {
  static const shortSearchTypeMap = {
    SearchType.repositories: 'enterRepoShort',
    SearchType.users: 'enterUserShort',
    SearchType.code: 'enterCodeShort'
  };

  String? get shortPrintingString => shortSearchTypeMap[this];
}

extension SearchTypeLongPrint on SearchType {
   static const longSearchTypeMap = {
    SearchType.repositories: 'enterRepoLong',
    SearchType.users: 'enterUserLong',
    SearchType.code: 'enterCodeLong'
  };

  String? get longPrintingString => longSearchTypeMap[this];
}
