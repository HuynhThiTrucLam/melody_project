class ArtistDisplay {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isVerified;
  final int followers;

  ArtistDisplay({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isVerified,
    required this.followers,
  });

  factory ArtistDisplay.fromJson(Map<String, dynamic> json) {
    return ArtistDisplay(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Artist',
      avatarUrl:
          json['avatarUrl'] ??
          json['avatar'] ??
          json['image'] ??
          json['picture'] ??
          '',
      isVerified: json['isVerified'] ?? json['verified'] ?? false,
      followers: json['followers'] ?? json['follower_count'] ?? 0,
    );
  }
}
