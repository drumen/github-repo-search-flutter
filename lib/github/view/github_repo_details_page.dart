import 'package:flutter/material.dart';
import 'package:github_repo_search/github/models/github_repository.dart';
import 'package:github_repo_search/github/widgets/github_repo_details.dart';

class GitHubRepoDetailsPage extends StatefulWidget {

  final GitHubRepository gitHubRepo;

  const GitHubRepoDetailsPage(this.gitHubRepo, {Key? key}) : super(key: key);

  @override
  _GitHubRepoDetailsPageState createState() => _GitHubRepoDetailsPageState();
}

class _GitHubRepoDetailsPageState extends State<GitHubRepoDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.gitHubRepo.name)),
      body: GitHubRepoDetailsWidget(widget.gitHubRepo),
    );
  }
}
