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
  Future<Either<Failure, String>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await remoteDataSource.login(email: email, password: password);
        await localDataSource.cacheToken(token);
        return Right(token);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signUp(String name, String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signUp(name: name, email: email, password: password);
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearToken();
      await localDataSource.clearUser();
      return const Right(null);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  // @override
  // Future<Either<Failure, User>> getMe() async {
  //   try {
  //     final user = await localDataSource.getCachedUser();
  //     return Right(user);
  //   } on CacheException {
  //     return const Left(CacheFailure());
  //   }
  // }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final hasToken = await localDataSource.hasToken();
      return Right(hasToken);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }
  
  @override
  Future<Either<Failure, User>> getCurrentUser(String token) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getCurrentUser(token);
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      try {
        final cachedUser = await localDataSource.getCachedUser();
        return Right(cachedUser);
      } on CacheException {
        return const Left(CacheFailure());
      }
    }
  }
}
