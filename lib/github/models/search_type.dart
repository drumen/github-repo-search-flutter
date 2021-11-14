enum SearchType { repositories, users, code}

extension ParseToString on SearchType {
  String toShortString() {
    return toString().split('.').last;
  }
}

extension SearchTypeShortPrint on SearchType {
  static const shortSearchTypeMap = {
    SearchType.repositories: "Enter GitHub repository name...",
    SearchType.users: "Enter name of GitHub user...",
    SearchType.code: "Enter part of GitHub code..."
  };

  String? get shortPrintingString => shortSearchTypeMap[this];
}

extension SearchTypeLongPrint on SearchType {
  static const longSearchTypeMap = {
    SearchType.repositories: "Enter GitHub repository name\nyou are searching for...",
    SearchType.users: "Enter name of GitHub user\nyou are searching for...",
    SearchType.code: "Enter part of GitHub code\nyou are searching for..."
  };

  String? get longPrintingString => longSearchTypeMap[this];
}
