import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:github_repo_search/github/common/common.dart';
import 'package:github_repo_search/github/models/github_code.dart';
import 'package:github_repo_search/github/models/github_repository.dart';
import 'package:github_repo_search/github/models/github_user.dart';
import 'package:github_repo_search/github/models/search_type.dart';

bool _wasLargeScreen = false;

class GitHubDetailsPage extends StatelessWidget {
  const GitHubDetailsPage(this._searchType, this._gitHubObject, {Key? key}) : super(key: key);

  final Object _gitHubObject;
  final SearchType _searchType;

  @override
  Widget build(BuildContext context) {
    bool _isLargeScreen = MediaQuery.of(context).size.width > 700;

    if (_isLargeScreen && !_wasLargeScreen) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }

    _wasLargeScreen = _isLargeScreen;

    return Scaffold(
      appBar: AppBar(title: Text(_getDetailsPageTitle(_searchType, _gitHubObject))),
      body: Common.getDetailsWidget(_searchType, _gitHubObject),
    );
  }

  String _getDetailsPageTitle(SearchType searchType, Object gitHubObject) {
    switch (searchType) {
      case SearchType.repositories:
        return (gitHubObject as GitHubRepository).name;
      case SearchType.users:
        return (gitHubObject as GitHubUser).userName;
      case SearchType.code:
        return (gitHubObject as GitHubCode).name;
    }
  }

}
