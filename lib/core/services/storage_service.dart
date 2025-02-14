import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences sharedPreferences;
  static const String _authTokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userRoleKey = 'user_role';

  StorageService({required this.sharedPreferences});

  Future<void> saveAuthToken(String token) async {
    await sharedPreferences.setString(_authTokenKey, token);
  }

  Future<String?> getAuthToken() async {
    return sharedPreferences.getString(_authTokenKey);
  }

  Future<void> saveUserId(String userId) async {
    await sharedPreferences.setString(_userIdKey, userId);
  }

  Future<String?> getUserId() async {
    return sharedPreferences.getString(_userIdKey);
  }

  Future<void> saveUserRole(String role) async {
    await sharedPreferences.setString(_userRoleKey, role);
  }

  Future<String?> getUserRole() async {
    return sharedPreferences.getString(_userRoleKey);
  }

  Future<void> clearAll() async {
    await sharedPreferences.clear();
  }
}
