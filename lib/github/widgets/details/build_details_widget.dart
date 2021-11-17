import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

import 'package:github_repo_search/github/models/github_code.dart';
import 'package:github_repo_search/github/models/github_repository.dart';
import 'package:github_repo_search/github/models/github_user.dart';

class BuildDetailsWidget {

  final _df = DateFormat('yyyy-MM-dd HH:mm:ss');

  Widget buildUserDetails(BuildContext context, GitHubUser gitHubUser, String realName) {
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
                    backgroundImage: NetworkImage(gitHubUser.profilePicture),
                    radius: 95.0,
                  ),
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    // USERNAME
                    const SizedBox(width: 0, height: 15),
                    Text(
                      'username:'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 0, height: 5),
                    Text(
                      gitHubUser.userName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 0, height: 30),

                    // REAL NAME
                    Text(
                      'realName:'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 0, height: 5),
                    Text(
                      realName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 0, height: 30),

                    // TYPE
                    Text(
                      'type:'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 0, height: 5),
                    Text(
                      gitHubUser.type,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 0, height: 30),

                    const SizedBox(width: 0, height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRepositoryDetails(BuildContext context, GitHubRepository gitHubRepo, String realName) {
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
                  radius: 70.0,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      gitHubRepo.owner['avatar_url'] as String,
                    ),
                    radius: 65.0,
                  ),
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    // REPOSITORY NAME
                    const SizedBox(width: 0, height: 15),
                    Text(
                      'repositoryName:'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 0, height: 5),
                    Text(
                      gitHubRepo.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 0, height: 30),

                    // LAST UPDATED TIME
                    Text(
                      'lastUpdatedTime:'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 0, height: 5),
                    Text(
                      '${_df.format(DateTime.parse(gitHubRepo.lastUpdateTime))} UTC',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 0, height: 30),

                    // OWNER NAME
                    Text(
                      'ownerName:'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 0, height: 5),
                    Text(
                      gitHubRepo.owner['login'] as String,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 0, height: 30),

                    // REAL NAME
                    Text(
                      'ownersRealName:'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 0, height: 5),
                    Text(
                      realName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 0, height: 30),

                    // DESCRIPTION
                    Text(
                      'description:'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 0, height: 5),
                    Text(
                      gitHubRepo.description ?? '[no description]'.tr(),
                      style: const TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    const SizedBox(width: 0, height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCodeDetails(BuildContext context, GitHubCode gitHubCode, String realName) {
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
                      gitHubCode.repository['owner']['avatar_url'] as String,
                    ),
                    radius: 95.0,
                  ),
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    // REPOSITORY NAME
                    const SizedBox(width: 0, height: 15),
                    Text(
                      'repositoryName:'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 0, height: 5),
                    Text(
                      gitHubCode.repository['name'],
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 0, height: 30),

                    // OWNER NAME
                    Text(
                      'ownerName:'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 0, height: 5),
                    Text(
                      gitHubCode.repository['owner']['login'],
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 0, height: 30),

                    // REAL NAME
                    Text(
                      'ownersRealName:'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 0, height: 5),
                    Text(
                      realName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 0, height: 30),

                    // FILE PATH
                    Text(
                      'filePath:'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 0, height: 5),
                    Text(
                      gitHubCode.path,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 0, height: 30),

                    const SizedBox(width: 0, height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}