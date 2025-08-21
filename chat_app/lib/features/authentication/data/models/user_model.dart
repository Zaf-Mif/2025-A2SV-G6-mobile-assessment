import '../../domain/entities/user.dart';

class UserModel extends User {

  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'].toString(),
      name: json['user']['name'],
      email: json['user']['email'],
    );
  }

  factory UserModel.fromMeJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return UserModel(
      id: data['_id']?.toString() ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': id,
        'name': name,
        'email': email,
      },  // token saved here 
    };
  }
}
