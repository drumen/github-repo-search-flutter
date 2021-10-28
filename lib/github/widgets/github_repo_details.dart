import 'package:flutter/material.dart';
import 'package:github_repo_search/github/models/github_repository.dart';
import 'package:intl/intl.dart';

class GitHubRepoDetailsWidget extends StatelessWidget {
  GitHubRepoDetailsWidget(this._gitHubRepo, {Key? key}) : super(key: key);

  final GitHubRepository? _gitHubRepo;

  late final DateTime _lastUpdated;
  final _df = DateFormat('yyyy-MM-dd HH:mm:ss');

  @override
  Widget build(BuildContext context) {
    if (_gitHubRepo == null) {
      return Container();
    } else {
      _lastUpdated = DateTime.parse(_gitHubRepo!.lastUpdateTime);
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
                        _gitHubRepo!.owner['avatar_url'] as String,
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
              _gitHubRepo!.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 0, height: 30),

            // LAST UPDATED TIME
            const Text(
              'Last updated time:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 0, height: 5),
            Text(
              '${_df.format(_lastUpdated)} UTC',
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
              _gitHubRepo!.owner['login'] as String,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 0, height: 30),

            // DESCRIPTION
            const Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 0, height: 5),
            Text(
              _gitHubRepo!.description ?? '[no description]',
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700
              ),
            ),
            const SizedBox(width: 0, height: 30),
          ],
        ),
    );
  }
}