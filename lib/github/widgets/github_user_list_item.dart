import 'package:flutter/material.dart';
import 'package:github_repo_search/github/github.dart';

class GitHubUserListItem extends StatelessWidget {
  const GitHubUserListItem(
      this._index,
      this._gitHubUser,
      this._clickedUser,
      {Key? key}
   ) : super(key: key);

  final Function(GitHubUser) _clickedUser;
  final GitHubUser _gitHubUser;
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
            text: 'Username: ',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: _gitHubUser.userName,
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
            text: 'Type: ',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: _gitHubUser.type,
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
          _clickedUser(_gitHubUser);
        },
      ),
    );
  }
}
