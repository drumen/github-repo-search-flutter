import 'package:flutter/material.dart';
import 'package:github_repo_search/github/models/github_user.dart';

class GitHubUserDetailsWidget extends StatelessWidget {
  const GitHubUserDetailsWidget(this._gitHubUser, {Key? key}) : super(key: key);

  final GitHubUser? _gitHubUser;

  @override
  Widget build(BuildContext context) {
    if (_gitHubUser == null) {
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
                        _gitHubUser!.profilePicture,
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

            // USERNAME
            const SizedBox(width: 0, height: 15),
            const Text(
              'Username:',
               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 0, height: 5),
            Text(
              _gitHubUser!.userName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 0, height: 30),

            // TYPE
            const Text(
              'Type:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 0, height: 5),
            Text(
              _gitHubUser!.type,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 0, height: 30),

            const SizedBox(width: 0, height: 30),
          ],
        ),
    );
  }
}