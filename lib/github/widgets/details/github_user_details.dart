import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repo_search/github/models/github_user.dart';
import 'package:github_repo_search/github/bloc_user/user_bloc.dart';

class GitHubUserDetailsWidget extends StatefulWidget {
  const GitHubUserDetailsWidget(this._gitHubUser, {Key? key}) : super(key: key);

  final GitHubUser? _gitHubUser;

  @override
  _GitHubUserDetailsWidgetState createState() => _GitHubUserDetailsWidgetState();
}

class _GitHubUserDetailsWidgetState extends State<GitHubUserDetailsWidget> {

  late UserBloc _postBloc;
  String _oldName = '';

  @override
  void initState() {
    super.initState();
    _postBloc = context.read<UserBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (widget._gitHubUser == null) {
          return Container();
        } else if ( _oldName != widget._gitHubUser!.userName) {
          _postBloc.add(FetchUser(widget._gitHubUser!.userName));
          _oldName = widget._gitHubUser!.userName;
        }
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
                          widget._gitHubUser!.profilePicture,
                        ),
                        radius: 95.0,
                      ),
                    ),
                  ),
                  _buildDetails(context, state.realName),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildDetails(BuildContext context, String realName) {
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
              widget._gitHubUser!.userName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 0, height: 30),

            // REAL NAME
            const Text(
              'Real name:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 0, height: 5),
            Text(
              realName,
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
              widget._gitHubUser!.type,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 0, height: 30),

            const SizedBox(width: 0, height: 30),
          ],
        ),
    );
  }
}