import 'package:MELODY/config/env_config.dart';
import 'package:MELODY/core/models/authen.dart';
import 'package:MELODY/data/models/BE/user_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  final String _backendUrl = EnvConfig.apiBaseUrl;

  Future<Authen?> signIn(String username, String password) async {
    try {
      debugPrint('Signing in with username: $username and password: $password');
      final response = await http.post(
        Uri.parse('$_backendUrl/api/v1/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final authen = Authen.fromJson(data);
        await _storage.write(key: 'jwt_token', value: authen.accessToken);
        return authen;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error signing in: $e');
      return null;
    }
  }

  Future<Authen?> signUp(String username, String password, String phone) async {
    try {
      debugPrint(
        'Signing up with username: $username and password: $password and phone: $phone',
      );
      final response = await http.post(
        Uri.parse('$_backendUrl/api/v1/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'phone': phone,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final authen = Authen.fromJson(data);
        await _storage.write(key: 'jwt_token', value: authen.accessToken);
        return authen;
      } else {
        throw Exception('Error signing up: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error signing up: $e');
      throw Exception('Error signing up');
    }
  }

  Future<void> signOut() async {
    try {
      await _storage.delete(key: 'jwt_token');
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Get user infor from decode the token
  Future<Map<String, dynamic>?> getUserTokenInfo() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final payload = token.split('.')[1];
      final normalizedPayload = base64Url.normalize(payload);
      final decodedBytes = base64Url.decode(normalizedPayload);
      final decodedString = utf8.decode(decodedBytes);
      return jsonDecode(decodedString);
    } catch (e) {
      debugPrint('Error getting user info: $e');
      return null;
    }
  }

  // call api get user info
  Future<UserData?> getUserInfo() async {
    final tokenInfo = await getUserTokenInfo();
    final userId = tokenInfo?['user_id'];
    debugPrint('User ID: $userId');
    final token = await getToken();

    final response = await http.get(
      Uri.parse('$_backendUrl/api/v1/users/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint('User data: $data');
      final userData = UserData.fromJson(data);
      debugPrint('User data: $userData');
      return userData;
    } else {
      return null;
    }
  }
}
