import 'dart:async';
import 'package:MELODY/data/models/UI/music_data.dart';

class MusicService {
  // Simulate API delay
  Future<MusicData> getMusicById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return the music data if found, or throw exception
    if (MusicDataList.musics.any((music) => music.id == id)) {
      return MusicDataList.musics.firstWhere((music) => music.id == id);
    } else {
      throw Exception("Song with ID $id not found");
    }
  }
}
