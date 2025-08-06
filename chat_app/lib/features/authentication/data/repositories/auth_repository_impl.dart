import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/platform/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_local_data_source.dart';
import '../datasource/auth_remote_data_source.dart';

class  AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  /// Constructor for [AuthRepositoryImpl].
  /// Takes [remoteDataSource], [localDataSource], and [networkInfo] as parameters.
  /// These dependencies are used to interact with remote and local data sources
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, User>> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> signUp(String name, String email, String password) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}