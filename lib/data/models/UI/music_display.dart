class MusicDisplay {
  final String id;
  final String title;
  final String artists;
  final String imageUrl;
  final String rank;
  final int listener;
  // Add other fields as needed

  MusicDisplay({
    required this.id,
    required this.title,
    required this.artists,
    required this.imageUrl,
    required this.rank,
    required this.listener,
  });

  // Parse a list of Spotify tracks from the API response
  static List<MusicDisplay> fromSpotifyList(List<dynamic> jsonList) {
    return jsonList.map((item) => MusicDisplay.fromJson(item)).toList();
  }

  factory MusicDisplay.fromJson(Map<String, dynamic> json) {
    // Handle the new Spotify API format with data field
    if (json.containsKey('data')) {
      final data = json['data'];

      // Extract artists names and join them
      final artistsList = <String>[];
      if (data['artists'] != null && data['artists']['items'] is List) {
        for (var artist in data['artists']['items']) {
          if (artist['profile'] != null && artist['profile']['name'] != null) {
            artistsList.add(artist['profile']['name']);
          }
        }
      }
      final artistsStr = artistsList.join(' x ');

      // Get the highest resolution image URL
      String imageUrl = '';
      if (data['albumOfTrack'] != null &&
          data['albumOfTrack']['coverArt'] != null &&
          data['albumOfTrack']['coverArt']['sources'] is List &&
          data['albumOfTrack']['coverArt']['sources'].isNotEmpty) {
        // Find the largest image (typically the last one in the array)
        final sources = data['albumOfTrack']['coverArt']['sources'];
        var maxWidth = 0;
        for (var source in sources) {
          if (source['width'] != null && source['width'] > maxWidth) {
            maxWidth = source['width'];
            imageUrl = source['url'];
          }
        }
      }

      return MusicDisplay(
        id: data['id'] ?? '',
        title: data['name'] ?? '',
        artists: artistsStr,
        imageUrl: imageUrl,
        rank: '0', // Default rank as it's not in the API response
        listener:
            data['duration'] != null
                ? (data['duration']['totalMilliseconds'] ?? 0) ~/ 1000
                : 0, // Use duration as proxy for listener
      );
    }
    // Handle different API response formats from the previous implementation
    else if (json.containsKey('trackMetadata')) {
      // Spotify API format
      final trackMetadata = json['trackMetadata'];
      final chartEntryData = json['chartEntryData'];

      // Handle artists list
      List<String> artistNames = [];
      for (var artist in trackMetadata['artists']) {
        artistNames.add(artist['name']);
      }
      String artists = artistNames.join('x ');

      return MusicDisplay(
        id: trackMetadata['trackUri'].split(':').last,
        title: trackMetadata['trackName'],
        artists: artists,
        imageUrl: trackMetadata['displayImageUri'],
        rank: chartEntryData['currentRank'].toString(),
        listener: 3000000000,
      );
    } else {
      // Direct API format (without nested trackMetadata)
      // Handle artist that could be a string or an array
      String artistText;
      if (json['artist'] is List) {
        artistText = (json['artist'] as List).join(', ');
      } else {
        artistText = json['artist']?.toString() ?? '';
      }

      return MusicDisplay(
        id: json['id'] ?? '',
        title: json['name'] ?? '',
        artists: artistText,
        imageUrl: json['albumArt'] ?? '',
        rank: json['rank']?.toString() ?? '0',
        listener: json['listener'] ?? 0,
      );
    }
  }
}
