// lib/features/authentication/domain/entities/user.dart
// lib/features/auth/domain/usecases/login.dart

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecases.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}