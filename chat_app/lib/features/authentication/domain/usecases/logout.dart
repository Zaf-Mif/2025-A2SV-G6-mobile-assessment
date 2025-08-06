// lib/features/auth/domain/usecases/logout.dart

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecases.dart';
import '../repositories/auth_repository.dart';

class Logout implements UseCase<void, NoParams> {
  final AuthRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.logout();
  }
}
