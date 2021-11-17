import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repo_search/github/bloc_user/user_bloc.dart';
import 'package:github_repo_search/github/common/common.dart';
import 'package:github_repo_search/github/models/github_code.dart';
import 'package:github_repo_search/github/models/github_repository.dart';
import 'package:github_repo_search/github/models/github_user.dart';
import 'package:github_repo_search/github/models/search_type.dart';
import 'package:github_repo_search/github/widgets/details/github_details_widget.dart';

bool _wasLargeScreen = false;

class GitHubDetailsPage extends StatelessWidget {
  const GitHubDetailsPage(this._searchType, this._gitHubObject, {Key? key}) : super(key: key);

  final Object _gitHubObject;
  final SearchType _searchType;

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery.of(context).size.width > Common.largeScreenSize;

    if (isLargeScreen && !_wasLargeScreen) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }

    _wasLargeScreen = isLargeScreen;

    return Scaffold(
      appBar: AppBar(title: Text(_getDetailsPageTitle(_searchType, _gitHubObject))),
      body: BlocProvider(
        create: (_) => UserBloc(),
        child: GitHubDetailsWidget(_searchType, _gitHubObject),
      ),
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
