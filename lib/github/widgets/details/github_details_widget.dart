import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repo_search/github/bloc_user/user_bloc.dart';
import 'package:github_repo_search/github/common/common.dart';
import 'package:github_repo_search/github/models/github_code.dart';
import 'package:github_repo_search/github/models/github_repository.dart';
import 'package:github_repo_search/github/models/github_user.dart';
import 'package:github_repo_search/github/models/search_type.dart';
import 'package:github_repo_search/github/widgets/details/build_details_widget.dart';

class GitHubDetailsWidget extends StatefulWidget {
  const GitHubDetailsWidget(this._searchType, this._gitHubObject, {Key? key}) : super(key: key);

  final Object? _gitHubObject;
  final SearchType _searchType;

  @override
  _GitHubDetailsWidgetState createState() => _GitHubDetailsWidgetState();
}

class _GitHubDetailsWidgetState extends State<GitHubDetailsWidget> {

  late UserBloc _postBloc;
  String _oldName = '';
  String? _userName = '';

  @override
  void initState() {
    super.initState();
    _postBloc = context.read<UserBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (widget._gitHubObject == null) {
            return Container();
          }

          _userName = Common.getUserName(widget._searchType, widget._gitHubObject);

          if ( _oldName != _userName) {
            _postBloc.add(FetchUser(_userName!));
            _oldName = _userName!;
          }

          switch (widget._searchType) {
            case SearchType.repositories:
              return BuildDetailsWidget().buildRepositoryDetails(
                  context,
                  (widget._gitHubObject) as GitHubRepository,
                  state.realName
              );
            case SearchType.users:
              return BuildDetailsWidget().buildUserDetails(
                  context,
                  (widget._gitHubObject) as GitHubUser,
                  state.realName
              );
            case SearchType.code:
              return BuildDetailsWidget().buildCodeDetails(
                  context,
                  (widget._gitHubObject) as GitHubCode,
                  state.realName
              );
          }
        }
    );
  }
}