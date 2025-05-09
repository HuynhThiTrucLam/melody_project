import 'dart:async';
import 'dart:convert';
import 'package:MELODY/auth/auth_service.dart';
import 'package:MELODY/config/env_config.dart';
import 'package:MELODY/core/services/audio_download_service.dart';
import 'package:MELODY/data/models/BE/music_data.dart';
import 'package:MELODY/data/models/UI/music_display.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MusicService {
  final AuthService _authService = AuthService();
  final String _backendUrl = EnvConfig.apiBaseUrl;
  final AudioDownloadService _audioDownloadService = AudioDownloadService();

  Future<MusicData> getMusicById(String id) async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$_backendUrl/api/v1/music/get-detail/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint('data: $data');
      return MusicData.fromJson(data);
    } else {
      throw Exception('Failed to load music data');
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
  Future<MusicData> getPreviousMusic(String currentId) async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('$_backendUrl/api/v1/music/get-previous/$currentId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MusicData.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception("No previous music found");
      } else {
        throw Exception(
          "Failed to get previous music: HTTP ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint('Error getting previous music: $e');
      throw Exception("Error getting previous music: $e");
    }
  }

  //Get next music
  Future<MusicData> getNextMusic(String currentId) async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('$_backendUrl/api/v1/music/get-next/$currentId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MusicData.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception("No next music found");
      } else {
        throw Exception(
          "Failed to get next music: HTTP ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint('Error getting next music: $e');
      throw Exception("Error getting next music: $e");
    }
  }

  Future<List<MusicDisplay>> getTopTrendingMusicsByRegion(String region) async {
    try {
      debugPrint('Fetching trending music by region: $region');

      // Get the token from AuthService
      final token = await _authService.getToken();
      debugPrint(
        // '$_backendUrl/api/v1/music/top-trending?country=$region&period=daily',
        '$_backendUrl/api/v1/music/popular-songs?country=$region',
      );

      final response = await http.get(
        Uri.parse(
          // '$_backendUrl/api/v1/music/top-trending?country=$region&period=daily',
          '$_backendUrl/api/v1/music/popular-songs?country=$region',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<MusicDisplay> musicList = [];

        // Check if response is an array (new Spotify API format)
        if (data is List) {
          // Use the utility method we created for parsing Spotify lists
          return MusicDisplay.fromSpotifyList(data);
        }
        // Check if response has 'tracks' property (old format)
        else if (data is Map && data.containsKey('tracks')) {
          for (var item in data['tracks']) {
            musicList.add(MusicDisplay.fromJson(item));
          }
          debugPrint('musicList: $musicList');
          return musicList;
        } else {
          debugPrint('Unrecognized response format');
          return [];
        }
      } else {
        // Handle error response
        debugPrint('Error fetching trending music: ${response.body}');
        return [];
      }
    } catch (e) {
      // Handle exceptions (network issues, parsing errors, etc.)
      print('Error fetching trending music by region: $e');
      return [];
    }
  }

  // Download audio file and return the local path
  Future<String> downloadMusicFile(
    String songId,
    String audioUrl, {
    Function(double)? onProgress,
  }) async {
    try {
      // Check if the file already exists
      if (await _audioDownloadService.doesFileExist(songId)) {
        return await _audioDownloadService.getLocalFilePath(songId);
      }

      // Download the file
      final localPath = await _audioDownloadService.downloadAudio(
        songId,
        audioUrl,
        onProgress: onProgress,
      );

      return localPath;
    } catch (e) {
      debugPrint('Error downloading music file: $e');
      throw Exception('Failed to download music file: $e');
    }
  }

  // Get cached audio file path if it exists
  Future<String?> getCachedAudioPath(String songId) async {
    if (await _audioDownloadService.doesFileExist(songId)) {
      return await _audioDownloadService.getLocalFilePath(songId);
    }
    return null;
  }

  // Clear audio cache
  Future<void> clearAudioCache() async {
    await _audioDownloadService.clearCache();
  }
}
