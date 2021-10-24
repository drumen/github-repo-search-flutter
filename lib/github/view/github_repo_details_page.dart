import 'package:flutter/material.dart';
import 'package:github_repo_search/github/models/github_repository.dart';
import 'package:intl/intl.dart';

class GitHubRepoDetailsPage extends StatelessWidget {

  GitHubRepoDetailsPage({Key? key, required this.gitHubRepo}) : super(key: key);
  final GitHubRepository gitHubRepo;

  late final lastUpdated = DateTime.parse(gitHubRepo.lastUpdateTime);
  final df = DateFormat('yyyy-MM-dd HH:mm:ss');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(gitHubRepo.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 100.0,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      gitHubRepo.owner['avatar_url'] as String,
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
              gitHubRepo.name,
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
              '${df.format(lastUpdated)} UTC',
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
              gitHubRepo.owner['login'] as String,
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
              gitHubRepo.description ?? '[no description]',
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