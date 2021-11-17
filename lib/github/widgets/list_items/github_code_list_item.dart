import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:github_repo_search/github/models/github_code.dart';

class GitHubCodeListItem extends StatelessWidget {
  const GitHubCodeListItem(
      this._index,
      this._gitHubCode,
      this._clickedCode,
      {Key? key}
   ) : super(key: key);

  final Function(GitHubCode) _clickedCode;
  final GitHubCode _gitHubCode;
  final int _index;

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
            text: 'fileName: '.tr(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: _gitHubCode.name,
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
            text: 'repository: '.tr(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: _gitHubCode.repository['name'],
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
          _clickedCode(_gitHubCode);
        },
      ),
    );
  }
}
