import 'package:flutter/cupertino.dart';
import 'package:github_repo_search/github/models/github_code.dart';
import 'package:github_repo_search/github/models/github_repository.dart';
import 'package:github_repo_search/github/models/github_user.dart';
import 'package:github_repo_search/github/models/search_type.dart';
import 'package:github_repo_search/github/widgets/github_code_details.dart';
import 'package:github_repo_search/github/widgets/github_repo_details.dart';
import 'package:github_repo_search/github/widgets/github_user_details.dart';

class Common {
  static Widget getDetailsWidget(SearchType searchType, Object? gitHubObject) {
    switch (searchType) {
      case SearchType.repositories:
        return gitHubObject == null ?
        GitHubRepoDetailsWidget(null) :
        GitHubRepoDetailsWidget(gitHubObject as GitHubRepository);
      case SearchType.users:
        return gitHubObject == null ?
        const GitHubUserDetailsWidget(null) :
        GitHubUserDetailsWidget(gitHubObject as GitHubUser);
      case SearchType.code:
        return gitHubObject == null ?
        const GitHubCodeDetailsWidget(null) :
        GitHubCodeDetailsWidget(gitHubObject as GitHubCode);
    }
  }
}