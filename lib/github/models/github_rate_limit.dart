class GitHubRateLimit {
  const GitHubRateLimit({
  required this.limit,
  required this.used,
  required this.remaining,
  required this.reset,
  });

  final int limit;
  final int used;
  final int remaining;
  final int reset;
}