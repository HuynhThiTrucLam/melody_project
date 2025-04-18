import 'package:MELODY/config/env_config.dart';
import 'package:MELODY/core/models/authen.dart';
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
}
