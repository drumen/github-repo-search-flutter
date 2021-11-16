import 'package:github_repo_search/github/models/github_code.dart';
import 'package:github_repo_search/github/models/github_repository.dart';
import 'package:github_repo_search/github/models/github_user.dart';
import 'package:github_repo_search/github/models/search_type.dart';

class Common {

  static String getUserName(SearchType searchType, Object? gitHubObject) {
    switch (searchType) {
      case SearchType.repositories:
        return (gitHubObject as GitHubRepository).owner['login'];
      case SearchType.users:
        return (gitHubObject as GitHubUser).userName;
      case SearchType.code:
        return (gitHubObject as GitHubCode).repository['owner']['login'];
    }
  }

  static int getSecondsTillReset(int reset) {
    Duration difference = DateTime.fromMillisecondsSinceEpoch(reset * 1000).difference(DateTime.now());
    return difference.inSeconds >= 0 ? difference.inSeconds : 0;
  }
}