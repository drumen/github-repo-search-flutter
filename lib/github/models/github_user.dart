class GitHubUser {
  GitHubUser({
  required this.userName,
  required this.profilePicture,
  required this.type,
  });

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    return GitHubUser(
      userName: json['login'] as String,
      profilePicture: json['avatar_url'] as String,
      type: json['type'] as String,
    );
  }

  final String userName;
  final String profilePicture;
  final String type;
}