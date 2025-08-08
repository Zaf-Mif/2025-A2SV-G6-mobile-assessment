import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel> getCachedUser();
  Future<void> clearUser();
  Future<String> getToken();
  Future<bool> hasToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const cachedUserKey = 'CACHED_USER';

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheUser(UserModel user) {
    return sharedPreferences.setString(
      cachedUserKey,
      jsonEncode(user.toJson()),
    );
  }

  @override
  Future<UserModel> getCachedUser() {
    final jsonString = sharedPreferences.getString(cachedUserKey);
    if (jsonString != null) {
      return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> clearUser() {
    return sharedPreferences.remove(cachedUserKey);
  }
  
  Future<void> logout() async {
     final userRemoved = await sharedPreferences.remove('CACHED_USER');
    final tokenRemoved = await sharedPreferences.remove('AUTH_TOKEN');

    if (!userRemoved || !tokenRemoved) {
      throw CacheException();
    }
  }

  @override
  Future<bool> hasToken() async {
    final jsonString = sharedPreferences.getString(cachedUserKey);
    if (jsonString == null) return false;

    final jsonMap = json.decode(jsonString);
    final token = jsonMap['token']; 
    return token != null && token is String && token.isNotEmpty;
  }

  @override
  Future<String> getToken() async {
    final jsonString = sharedPreferences.getString('CACHED_USER');
    if (jsonString == null) throw CacheException();

    final jsonMap = json.decode(jsonString);
    final token = jsonMap['token'];
    if (token == null || token is! String || token.isEmpty) {
      throw CacheException();
    }

    return token;
  }
}
