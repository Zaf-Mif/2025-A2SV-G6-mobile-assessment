// lib/features/auth/data/models/user_model.dart

import '../../domain/entities/user.dart';

class UserModel extends User {
  final String token;

  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'].toString(),
      name: json['user']['name'],
      email: json['user']['email'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    };
  }
}
