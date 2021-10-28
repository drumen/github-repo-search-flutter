import 'package:flutter/material.dart';
import 'package:github_repo_search/github/models/github_code.dart';
import 'package:github_repo_search/github/widgets/github_code_details.dart';

class GitHubCodeDetailsPage extends StatefulWidget {

  final GitHubCode _gitHubCode;

  const GitHubCodeDetailsPage(this._gitHubCode, {Key? key}) : super(key: key);

  @override
  _GitHubCodeDetailsPageState createState() => _GitHubCodeDetailsPageState();
}

class _GitHubCodeDetailsPageState extends State<GitHubCodeDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget._gitHubCode.name)),
      body: GitHubCodeDetailsWidget(widget._gitHubCode),
    );
  }
}
