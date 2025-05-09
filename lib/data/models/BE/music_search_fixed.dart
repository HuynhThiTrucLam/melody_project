import 'package:MELODY/data/models/BE/music_data.dart';

class MusicSearchFixed {
  static MusicData fromSpotifyJson(Map<String, dynamic> json) {
    final data = json['data'];

    // Extract highest resolution image
    String albumArt = '';
    try {
      final sources = data['albumOfTrack']['coverArt']['sources'];
      int maxWidth = 0;

      for (var source in sources) {
        final width = source['width'] as int;
        if (width > maxWidth) {
          maxWidth = width;
          albumArt = source['url'];
        }
      }
    } catch (e) {
      albumArt =
          'https://i.scdn.co/image/ab67616d0000b273d52fd56d03776396bb440624';
    }

    // Extract artist
    String artist = '';
    try {
      artist = data['artists']['items'][0]['profile']['name'];
    } catch (e) {
      artist = 'Unknown Artist';
    }

    // Extract name
    String name = '';
    try {
      name = data['name'];
    } catch (e) {
      name = 'Unknown Track';
    }

    // Extract duration
    int durationMs = 0;
    try {
      durationMs = data['duration']['totalMilliseconds'];
    } catch (e) {
      durationMs = 0;
    }

    return MusicData(
      id: data['id'] ?? '',
      name: name,
      artist: artist,
      albumArt: albumArt,
      audioUrl: 'https://example.com/audio/${data['id'] ?? 'unknown'}.mp3',
      lyrics: '',
      duration: Duration(milliseconds: durationMs),
      listener:
          durationMs ~/ 1000, // Use duration as a proxy for listener count
      isFavorite: false,
      genre: '',
      releaseDate: DateTime.now(),
      nation: determineNation(name, artist),
    );
  }

  // Helper to determine probable nation based on track/artist name
  static String determineNation(String name, String artist) {
    final vietnamesePattern = RegExp(
      r'[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]',
      caseSensitive: false,
    );

    if (vietnamesePattern.hasMatch(name) ||
        vietnamesePattern.hasMatch(artist)) {
      return 'vietnam';
    }

    if (artist.toLowerCase().contains('bts') ||
        artist.toLowerCase().contains('blackpink') ||
        artist.toLowerCase().contains('twice')) {
      return 'kpop';
    }

    return 'usuk';
  }
}
