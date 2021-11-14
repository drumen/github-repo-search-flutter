import 'package:flutter/material.dart';
import 'package:github_repo_search/github/models/github_code.dart';

class GitHubCodeDetailsWidget extends StatelessWidget {
  const GitHubCodeDetailsWidget(this._gitHubCode, {Key? key}) : super(key: key);

  final GitHubCode? _gitHubCode;

  @override
  Widget build(BuildContext context) {
    if (_gitHubCode == null) {
      return Container();
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: CircleAvatar(
                    backgroundColor: Theme
                        .of(context)
                        .primaryColor,
                    radius: 100.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        _gitHubCode!.repository['owner']['avatar_url'] as String,
                      ),
                      radius: 95.0,
                    ),
                  ),
                ),
                _buildDetails(context),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildDetails(BuildContext context) {
    return Center(
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            // REPOSITORY NAME
            const SizedBox(width: 0, height: 15),
            const Text(
              'Repository name:',
               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 0, height: 5),
            Text(
              _gitHubCode!.repository['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 0, height: 30),

            // OWNER NAME
            const Text(
              'Owner name:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 0, height: 5),
            Text(
              _gitHubCode!.repository['owner']['login'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 0, height: 30),

            // FILE PATH
            const Text(
              'File path:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 0, height: 5),
            Text(
              _gitHubCode!.path,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 0, height: 30),

            const SizedBox(width: 0, height: 30),
          ],
        ),
    );
  }
}