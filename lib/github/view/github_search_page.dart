import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repo_search/github/github.dart';
import 'package:github_repo_search/github/view/github_repo_details_page.dart';
import 'package:github_repo_search/github/widgets/github_repo_details.dart';

class GitHubSearchPage extends StatefulWidget {
  const GitHubSearchPage({Key? key}) : super(key: key);

  @override
  _GitHubSearchPageState createState() => _GitHubSearchPageState();
}

class _GitHubSearchPageState extends State<GitHubSearchPage> {

  String currentQuery = '';
  bool isLargeScreen = false;
  GitHubRepository? selectedRepo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Repository Search')),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) =>
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter GitHub repository name...'),
                  onChanged: (query) {
                    currentQuery = query;
                    context.read<SearchBloc>().add(FetchQuery(query, true));
                  },
                ),
              ),
              Expanded(
               child: OrientationBuilder(builder: (context, orientation) {

                 if (MediaQuery.of(context).size.width > 700) {
                   isLargeScreen = true;
                 } else {
                   isLargeScreen = false;
                 }

                 return Row(children: <Widget>[
                   Expanded(
                     child: GitHubSearchList(currentQuery, (gitHubRepo) {
                       if (isLargeScreen) {
                         selectedRepo = gitHubRepo;
                         setState(() {});
                       } else {
                         Navigator.push(context, MaterialPageRoute(
                           builder: (context) {
                             return GitHubRepoDetailsPage(gitHubRepo);
                           },
                         ));
                       }
                     }),
                   ),
                   isLargeScreen ?
                    Expanded(child: GitHubRepoDetailsWidget(
                        gitHubRepo: selectedRepo
                      )
                    ) : Container(),
                 ]);
               }),
              ),
            ],
          ),
      ),
    );
  }
}
