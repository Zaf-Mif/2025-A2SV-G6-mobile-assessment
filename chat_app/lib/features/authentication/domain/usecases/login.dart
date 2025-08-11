import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecases.dart';
import '../repositories/auth_repository.dart';

class Login implements UseCase<String, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, String>> call(LoginParams params) {
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
