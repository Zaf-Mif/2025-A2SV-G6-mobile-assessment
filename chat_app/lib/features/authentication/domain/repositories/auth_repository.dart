// // lib/features/auth/domain/repositories/auth_repository.dart

// import 'package:dartz/dartz.dart';
// import '../../core/error/failures.dart';
// import '../entities/user.dart';

// abstract class AuthRepository {
//   Future<Either<Failure, void>> login(String email, String password);
//   Future<Either<Failure, User>> signUp(String name, String email, String password,);
//   Future<Either<Failure, void>> logout();
//   Future<Either<Failure, bool>> isAuthenticated();
//   Future<Either<Failure, User>> getMe();
// }

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login(String email, String password); // returns token
  Future<Either<Failure, User>> getCurrentUser(String token);             // fetch user by token
  Future<Either<Failure, User>> signUp(String name, String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, bool>> isAuthenticated();
}