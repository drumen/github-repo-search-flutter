import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:github_repo_search/github/models/github_repository.dart';

class GitHubRepoListItem extends StatelessWidget {
  GitHubRepoListItem(
      this._index,
      this._gitHubRepo,
      this._clickedRepo,
      {Key? key}
      ) : super(key: key);

  final Function(GitHubRepository) _clickedRepo;
  final GitHubRepository _gitHubRepo;
  final int _index;

  late final _lastUpdated = DateTime.parse(_gitHubRepo.lastUpdateTime);
  final _df = DateFormat('yyyy-MM-dd HH:mm:ss');

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: Text(
          '${_index + 1}.',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        title: RichText(
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: 'repoName: '.tr(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: _gitHubRepo.name,
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
            text: 'updated: '.tr(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: '${_df.format(_lastUpdated)} UTC',
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
          _clickedRepo(_gitHubRepo);
        },
      ),
    );
  }
}
