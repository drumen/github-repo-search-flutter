import 'package:flutter/material.dart';
import 'package:github_repo_search/github/models/github_user.dart';
import 'package:github_repo_search/github/widgets/github_user_details.dart';

class GitHubUserDetailsPage extends StatefulWidget {

  final GitHubUser _gitHubUser;

  const GitHubUserDetailsPage(this._gitHubUser, {Key? key}) : super(key: key);

  @override
  _GitHubUserDetailsPageState createState() => _GitHubUserDetailsPageState();
}

class _GitHubUserDetailsPageState extends State<GitHubUserDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget._gitHubUser.userName)),
      body: GitHubUserDetailsWidget(widget._gitHubUser),
    );
  }
}
