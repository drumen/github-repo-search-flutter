class GitHubRepository {
  GitHubRepository({
  required this.name,
  required this.lastUpdateTime,
  required this.owner,
  required this.description,
  });

  factory GitHubRepository.fromJson(Map<String, dynamic> json) {
    return GitHubRepository(
      name: json['name'] as String,
      lastUpdateTime: json['updated_at'] as String,
      owner: json['owner'] as Map,
      description: json['description'] as String?,
    );
  }

  final String name;
  final String lastUpdateTime;
  final Map owner;
  final String? description;
}