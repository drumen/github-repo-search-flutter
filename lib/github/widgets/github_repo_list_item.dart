import 'package:flutter/material.dart';
import 'package:github_repo_search/github/github.dart';
import 'package:intl/intl.dart';

class GitHubRepoListItem extends StatelessWidget {
  GitHubRepoListItem(
      this.index,
      {Key? key,
       required this.gitHubRepo,
       required this.clickedRepo
      }
   ) : super(key: key);

  final Function(GitHubRepository) clickedRepo;

  final GitHubRepository gitHubRepo;
  final int index;

  late final lastUpdated = DateTime.parse(gitHubRepo.lastUpdateTime);
  final df = DateFormat('yyyy-MM-dd HH:mm:ss');

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: Text(
          '${index + 1}.',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        title: RichText(
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: 'Repo name: ',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: gitHubRepo.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        isThreeLine: true,
        subtitle: RichText(
          text: TextSpan(
            text: 'Updated: ',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: '${df.format(lastUpdated)} UTC',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0x22000000)),
        dense: true,
        onTap: () {
          clickedRepo(gitHubRepo);
        },
      ),
    );
  }
}
