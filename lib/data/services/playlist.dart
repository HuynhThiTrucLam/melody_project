// import 'dart:async';
// import 'package:MELODY/data/models/UI/music_data.dart';

// class Playlist {
//   //Add music to my playlist
//   Future<void> addMusicToPlaylist(String musicId, String playlistId) async {
//     // Simulate network delay
//     await Future.delayed(const Duration(milliseconds: 800));

//     // Add the music to the playlist (mockdata)
//     // In a real app, you would send this update by call api
//     final music = MusicDataList.musics.firstWhere(
//       (music) => music.id == musicId,
//     );
//     final playlist = MusicDataList.playlists.firstWhere(
//       (playlist) => playlist.id == playlistId,
//     );
//     playlist.musicList.add(music);
//   }
// }
