import 'package:MELODY/auth/auth_service.dart';
import 'package:MELODY/data/models/BE/user_data.dart';
import 'package:flutter/foundation.dart';

class UserService {
  final AuthService _authService = AuthService();
  UserData? _cachedUserData;

  // Get user data from token
  Future<UserData?> getUserDataFromToken() async {
    // Return cached data if available
    if (_cachedUserData != null) {
      return _cachedUserData;
    }

    try {
      final tokenInfo = await _authService.getUserInfo();
      if (tokenInfo == null) return null;

      debugPrint('Token info: $tokenInfo');

      // Map token claims to UserData model
      final userData = UserData(
        id: tokenInfo['sub'] ?? tokenInfo['id'] ?? '',
        name: tokenInfo['name'] ?? tokenInfo['username'] ?? 'User',
        email: tokenInfo['email'] ?? '',
        phone: tokenInfo['phone'] ?? '',
        membership: tokenInfo['membership'] ?? 'Free',
        address: tokenInfo['address'] ?? '',
        profilePictureUrl:
            tokenInfo['profile_picture'] ?? 'assets/images/Avatar.png',
      );

      // Cache the data
      _cachedUserData = userData;
      return userData;
    } catch (e) {
      debugPrint('Error getting user data from token: $e');
      return null;
    }
  }

  // Clear cached user data (call when logging out)
  void clearCachedUserData() {
    _cachedUserData = null;
  }
}
