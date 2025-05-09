import 'dart:convert';
import 'package:MELODY/auth/auth_service.dart';
import 'package:MELODY/config/env_config.dart';
import 'package:MELODY/data/models/BE/playlist_data.dart';
import 'package:MELODY/data/models/UI/album_display.dart';
import 'package:MELODY/data/models/UI/music_display.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PlaylistService {
  final AuthService _authService = AuthService();
  final String _backendUrl = EnvConfig.apiBaseUrl;

  Future<List<PlaylistData>> getPlaylists(String userId) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        debugPrint('No token available');
        return [];
      }

      final response = await http.get(
        Uri.parse('$_backendUrl/api/v1/playlist/user/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        debugPrint('Playlists data: $data');

        return data.map((json) => PlaylistData.fromJson(json)).toList();
      } else {
        debugPrint('Failed to load playlists: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching playlists: $e');
      return [];
    }
  }

  // create playlist
  Future<PlaylistData?> createPlaylist(
    String userId,
    String name,
    List<String>? trackIds,
  ) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        debugPrint('No token available');
        return null;
      }

      // Create body with the exact API expected format
      final Map<String, dynamic> body = {'name': name, 'user_id': userId};

      // Add tracks only if provided
      if (trackIds != null && trackIds.isNotEmpty) {
        body['tracks'] = trackIds;
      }

      final response = await http.post(
        Uri.parse('$_backendUrl/api/v1/playlist/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Playlist created successfully: $data');

        return PlaylistData.fromJson(data);
      } else {
        debugPrint('Failed to create playlist: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error creating playlist: $e');
      return null;
    }
  }

  Future<List<MusicDisplay>> getFavoriteSongs(String userId) async {
    try {
      // Get playlists first
      final playlists = await getPlaylists(userId);

      // Flatten the list of lists to a single list of MusicDisplay
      return playlists.expand((playlist) => playlist.favoriteSongs).toList();
    } catch (e) {
      debugPrint('Error fetching favorite songs: $e');
      return [];
    }
  }

  Future<List<AlbumDisplay>> getFavoriteAlbums(String userId) async {
    try {
      // Get playlists first
      final playlists = await getPlaylists(userId);

      // Flatten the list of lists to a single list of AlbumDisplay
      return playlists.expand((playlist) => playlist.favoriteAlbums).toList();
    } catch (e) {
      debugPrint('Error fetching favorite albums: $e');
      return [];
    }
  }
}
