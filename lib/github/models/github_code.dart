class GitHubCode {
  GitHubCode({
  required this.name,
  required this.path,
  required this.repository,
  });

  factory GitHubCode.fromJson(Map<String, dynamic> json) {
    return GitHubCode(
      name: json['name'] as String,
      path: json['path'] as String,
      repository: json['repository'] as Map,
    );
  }

  final String name;
  final String path;
  final Map repository;
}