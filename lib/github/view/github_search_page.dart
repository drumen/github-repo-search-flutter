import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:github_repo_search/github/bloc_search/search_bloc.dart';
import 'package:github_repo_search/github/common/common.dart';
import 'package:github_repo_search/github/models/github_rate_limit.dart';
import 'package:github_repo_search/github/models/search_type.dart';
import 'package:github_repo_search/github/widgets/details/github_details_widget.dart';
import 'package:github_repo_search/github/widgets/github_search_list.dart';

import 'github_details_page.dart';

class GitHubSearchPage extends StatefulWidget {
  const GitHubSearchPage({Key? key}) : super(key: key);

  @override
  _GitHubSearchPageState createState() => _GitHubSearchPageState();
}

class _GitHubSearchPageState extends State<GitHubSearchPage> {

  String _currentQuery = '';
  Object? _selectedObject;
  SearchType _searchType = SearchType.repositories;
  late Timer _timer;
  late int _resetTime;
  FocusNode _textFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery.of(context).size.width > Common.largeScreenSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text('appName').tr(),
        actions: [ _getLanguageSelectionAction() ],
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) =>
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: OrientationBuilder(builder: (context, orientation) {
                  return Flex(
                    direction: isLargeScreen ? Axis.horizontal : Axis.vertical,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.loose,
                        child:TextField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: _searchType.shortPrintingString!.tr(),
                          ),
                          textInputAction: TextInputAction.search,
                          focusNode: _textFocusNode,
                          onSubmitted: (query) {
                            if (_currentQuery != query) {
                              _currentQuery = query;
                              context.read<SearchBloc>().add(FetchQuery(
                                  query, _searchType, true)
                              );
                            }
                            _textFocusNode.requestFocus();
                          },
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('searchFor:').tr(),
                              Radio(
                                  value: SearchType.repositories,
                                  groupValue: _searchType,
                                  onChanged: (value) {
                                    _searchType = value as SearchType;
                                    _selectedObject = null;
                                    setState(() {
                                      context.read<SearchBloc>().add(FetchQuery(
                                          _currentQuery, _searchType, true));
                                    });
                                  }
                              ),
                              const Text('repo').tr(),
                              Radio(
                                  value: SearchType.users,
                                  groupValue: _searchType,
                                  onChanged: (value) {
                                    _searchType = value as SearchType;
                                    _selectedObject = null;
                                    setState(() {
                                      context.read<SearchBloc>().add(FetchQuery(
                                        _currentQuery, _searchType, true));
                                    });
                                  }
                              ),
                              const Text('user').tr(),
                              Radio(
                                  value: SearchType.code,
                                  groupValue: _searchType,
                                  onChanged: (value) {
                                    _searchType = value as SearchType;
                                    _selectedObject = null;
                                    setState(() {
                                      context.read<SearchBloc>().add(FetchQuery(
                                          _currentQuery, _searchType, true));
                                    });
                                  }
                              ),
                              const Text('code').tr(),
                            ],
                          ),
                        ),
                     ],
                  );
                }),
              ),
              Expanded(
               child: OrientationBuilder(builder: (context, orientation) {
                 return Row(children: <Widget>[
                   Expanded(
                     child: GitHubSearchList(
                       _currentQuery, _searchType, (gitHubObject) {
                         if (isLargeScreen) {
                           _selectedObject = gitHubObject;
                           setState(() {});
                         }
                         else {
                           _selectedObject = gitHubObject;
                           Navigator.push(context, MaterialPageRoute(
                             builder: (context) {
                               return GitHubDetailsPage(_searchType, gitHubObject);
                             },
                           ));
                         }
                     }),
                   ),
                   isLargeScreen ?
                     Expanded(child: GitHubDetailsWidget(_searchType, _selectedObject)) :
                     Container(),
                  ]);
                }),
              ),
              _buildRateLimitsTextBox(state.rateLimits),
            ],
          ),
      ),
    );
  }

  Widget _buildRateLimitsTextBox(GitHubRateLimit rateLimits) {
    _resetTime = Common.getSecondsTillReset(rateLimits.reset);
    _startTimer();
    bool isLargeScreen = MediaQuery.of(context).size.width > Common.largeScreenSize;

    return Container(
      padding: isLargeScreen ?
      const EdgeInsets.symmetric() : const EdgeInsets.symmetric(horizontal: 25.0),
      height: 42,
      width: double.infinity,
      color: Theme.of(context).primaryColor,

      child: Row(
        children: [
          _buildPerScreenSize(isLargeScreen),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQueryRatesTexts(
                        'queryLimitPerMinute: ', rateLimits.limit),
                    _buildQueryRatesTexts('queriesUsed: ', rateLimits.used),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'resettingIn: '.tr() +
                          _resetTime.toString() +
                          ' seconds'.tr(),
                      style:
                      const TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    _buildQueryRatesTexts('queriesLeft: ', rateLimits.remaining),
                  ],
                ),
              ],
            ),
          ),
          _buildPerScreenSize(isLargeScreen),
        ],
      ),
    );
  }

  _buildQueryRatesTexts(String text, int value) {
    return Text(
      text.tr() + value.toString(),
      style: const TextStyle(color: Colors.white, fontSize: 15),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPerScreenSize(bool isLargeScreen) {
    return isLargeScreen ? Expanded( child: Container() ) : Container();
  }

  Widget _getLanguageSelectionAction() {
    return  PopupMenuButton<String>(
      offset: Offset.fromDirection(pi/2, 50),
      icon: const Icon(Icons.language),
      tooltip: 'selectLanguage'.tr(),
      onSelected: (String result) {
        switch (result) {
          case 'en':
            dev.log('English language selected');
            context.setLocale(const Locale('en'));
            break;
          case 'hr':
            dev.log('Croatian language selected');
            context.setLocale(const Locale('hr'));
            break;
          default:
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'en',
          child: Text('English'),
        ),
        const PopupMenuItem<String>(
          value: 'hr',
          child: Text('Hrvatski'),
        ),
      ],
    );
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_resetTime == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _resetTime--;
          });
        }
      },
    );
  }
}
