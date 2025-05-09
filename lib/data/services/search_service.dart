import 'dart:convert';

import 'package:MELODY/auth/auth_service.dart';
import 'package:MELODY/config/env_config.dart';
import 'package:MELODY/core/services/audio_download_service.dart';
import 'package:MELODY/data/models/BE/music_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SearchService {
  final AuthService _authService = AuthService();
  final String _backendUrl = EnvConfig.apiBaseUrl;

  Future<List<MusicData>> searchMusic(String query) async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse(
        '$_backendUrl/api/v1/music/search?query=$query&limit=10&offset=0',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint('Search data: $data');
      final result = <MusicData>[];
      for (var item in data['items']) {
        result.add(MusicSearch.fromSpotifyJson(item));
      }
      return result;
    } else {
      throw Exception('Failed to load music data');
    }
  }
}
