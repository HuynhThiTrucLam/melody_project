import 'dart:async';
import 'package:MELODY/data/models/BE/music_data.dart';

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

  Future<List<MusicData>> getAllMusics() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return the list of all music data (mockdata)
    return MusicDataList.musics;
  }

  Future<List<MusicData>> getFavoriteMusics() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return the list of favorite music data (mockdata)
    return MusicDataList.musics.where((music) => music.isFavorite).toList();
  }

  //Set favorite music
  //If use api then not pass isFavorite
  Future<void> setFavoriteMusic(String id, bool isFavorite) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Find the music and update its favorite status (mockdata)
    // In a real app, you would send this update by call api
    final music = MusicDataList.musics.firstWhere((music) => music.id == id);
    music.isFavorite = isFavorite;
  }

  //Get previous music
  Future<MusicData> getPreviousMusic(String preventId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Find the current music and get the previous one (mockdata)
    final currentIndex = MusicDataList.musics.indexWhere(
      (music) => music.id == preventId,
    );
    if (currentIndex > 0) {
      return MusicDataList.musics[currentIndex - 1];
    } else {
      throw Exception("No previous music found");
    }
  }

  //Get next music
  Future<MusicData> getNextMusic(String preventId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Find the current music and get the next one (mockdata)
    final currentIndex = MusicDataList.musics.indexWhere(
      (music) => music.id == preventId,
    );
    if (currentIndex != -1 && currentIndex < MusicDataList.musics.length - 1) {
      return MusicDataList.musics[currentIndex + 1];
    } else {
      throw Exception("No next music found");
    }
  }

  //Get top trending music
  Future<List<MusicData>> getTopTrendingMusics() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return the list of top trending music data (mockdata)
    return MusicDataList.topTrending;
  }

  Future<List<MusicData>> getTopTrendingMusicsByRegion(String region) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return the list of top trending music data by region (mockdata)
    return MusicDataList.topTrending
        .where((music) => music.nation.toLowerCase() == region)
        .toList();
  }
}
