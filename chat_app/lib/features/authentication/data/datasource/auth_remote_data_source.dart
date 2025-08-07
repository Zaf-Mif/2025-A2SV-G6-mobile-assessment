import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Calls the POST /login endpoint.
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> login({required String email, required String password});

  /// Calls the POST /register endpoint.
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Calls the GET /me endpoint.
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> getCurrentUser(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});
  static const _baseUrl =
      'https://g5-flutter-learning-path-be.onrender.com/api/v2/';

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getCurrentUser(String token) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw ServerException();
    }
  }
}
