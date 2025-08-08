import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class CheckAuthenticatedUser {
  final AuthRepository repository;

  CheckAuthenticatedUser(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.isAuthenticated();
  }
}
