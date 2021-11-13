import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:github_repo_search/github/models/github_repository.dart';
import 'package:github_repo_search/github/widgets/github_repo_details.dart';

bool _wasLargeScreen = false;

class GitHubRepoDetailsPage extends StatelessWidget {
  const GitHubRepoDetailsPage(this._gitHubRepo, {Key? key}) : super(key: key);

  final GitHubRepository _gitHubRepo;

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
      appBar: AppBar(title: Text(_gitHubRepo.name)),
      body: GitHubRepoDetailsWidget(_gitHubRepo),
    );
  }
}
