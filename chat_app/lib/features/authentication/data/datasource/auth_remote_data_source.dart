import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 2));
    return User(id: '1', name: 'Test User', email: email);
  }
}
