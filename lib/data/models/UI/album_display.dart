class AlbumDisplay {
  final String id;
  final String title;
  final String artist;
  final String coverImage;
  final int songCount;
  final String releaseDate;

  AlbumDisplay({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverImage,
    required this.songCount,
    required this.releaseDate,
  });

  factory AlbumDisplay.fromJson(Map<String, dynamic> json) {
    return AlbumDisplay(
      id: json['id'] ?? '',
      title: json['title'] ?? json['name'] ?? 'Untitled Album',
      artist: json['artist'] ?? '',
      coverImage: json['coverImage'] ?? json['cover'] ?? json['image'] ?? '',
      songCount: json['songCount'] ?? json['tracks_count'] ?? 0,
      releaseDate: json['releaseDate'] ?? json['release_date'] ?? '',
    );
  }
}
