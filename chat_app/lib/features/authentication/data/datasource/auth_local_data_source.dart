import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel> getCachedUser();

  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<bool> hasToken();

  Future<void> clearUser();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const cachedUserKey = 'CACHED_USER';
  static const cachedTokenKey = 'CACHED_TOKEN';

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
  Future<void> cacheToken(String token) {
    return sharedPreferences.setString(cachedTokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final token = sharedPreferences.getString(cachedTokenKey);
    if (token == null || token.isEmpty) {
      throw CacheException();
    }
    return token;
  }

  @override
  Future<void> clearUser() {
    // Removes cached user and token because token is inside cached user JSON
    return sharedPreferences.remove(cachedUserKey);
  }

  @override
  Future<bool> hasToken() async {
    final token = sharedPreferences.getString(cachedTokenKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> clearToken() {
    return sharedPreferences.remove(cachedTokenKey);
  }

  Future<void> logout() async {
    final userRemoved = await sharedPreferences.remove(cachedUserKey);
    final tokenRemoved = await sharedPreferences.remove('AUTH_TOKEN');

    if (!userRemoved || !tokenRemoved) {
      throw CacheException();
    }
  }
  
}
  // @override
  // Future<String> getToken() async {
  //   final jsonString = sharedPreferences.getString(cachedUserKey);
  //   if (jsonString == null) throw CacheException();

  //   final jsonMap = json.decode(jsonString);
  //   final token = jsonMap['token'];
  //   if (token == null || token is! String || token.isEmpty) {
  //     throw CacheException();
  //   }

  //   return token;
  // }
  
