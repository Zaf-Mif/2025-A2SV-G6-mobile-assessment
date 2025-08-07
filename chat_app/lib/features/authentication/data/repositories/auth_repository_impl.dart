import 'package:dartz/dartz.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/platform/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_local_data_source.dart';
import '../datasource/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.login(email: email, password: password);
        await localDataSource.cacheUser(remoteUser);
        return Right(remoteUser);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      try {
        final localUser = await localDataSource.getCachedUser();
        return Right(localUser);
      } on CacheException {
        return const Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, User>> signUp(String name, String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.signUp(
          name: name,
          email: email,
          password: password,
        );
        await localDataSource.cacheUser(remoteUser);
        return Right(remoteUser);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return  const Left( NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
