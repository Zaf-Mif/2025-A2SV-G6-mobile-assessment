import 'package:chat_app/features/authentication/core/error/exceptions.dart';
import 'package:chat_app/features/authentication/core/error/failures.dart';
import 'package:chat_app/features/authentication/core/platform/network_info.dart';
import 'package:chat_app/features/authentication/data/datasource/auth_local_data_source.dart';
import 'package:chat_app/features/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:chat_app/features/authentication/data/models/user_model.dart';
import 'package:chat_app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:chat_app/features/authentication/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockLocalDataSource extends Mock implements AuthLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

class FakeUserModel extends Fake implements UserModel {}
void main() {
  late AuthRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testName = 'Test User';

  const testUserModel = UserModel(id: '1', name: testName, email: testEmail);
  const User testUser = testUserModel; // Since UserModel extends User

  group('login', () {
    test('should check if device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => testUserModel);
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async => Future.value());

      await repository.login(testEmail, testPassword);

      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    group('device online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data when call to remote datasource is successful', () async {
        when(() => mockRemoteDataSource.login(email: testEmail, password: testPassword))
            .thenAnswer((_) async => testUserModel);
        when(() => mockLocalDataSource.cacheUser(testUserModel))
            .thenAnswer((_) async => Future.value());

        final result = await repository.login(testEmail, testPassword);

        verify(() => mockRemoteDataSource.login(email: testEmail, password: testPassword)).called(1);
        verify(() => mockLocalDataSource.cacheUser(testUserModel)).called(1);
        expect(result, equals(const Right(testUser)));
      });

      test('should return ServerFailure when call to remote datasource throws ServerException', () async {
        when(() => mockRemoteDataSource.login(email: testEmail, password: testPassword))
            .thenThrow(ServerException());

        final result = await repository.login(testEmail, testPassword);

        verify(() => mockRemoteDataSource.login(email: testEmail, password: testPassword)).called(1);
        verifyNever(() => mockLocalDataSource.cacheUser(any()));
        expect(result, equals(const Left(ServerFailure())));
      });
    });

    group('device offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when cached data is present', () async {
        when(() => mockLocalDataSource.getCachedUser())
            .thenAnswer((_) async => testUserModel);

        final result = await repository.login(testEmail, testPassword);

        verifyNever(() => mockRemoteDataSource.login(email: testEmail, password: testPassword));
        verify(() => mockLocalDataSource.getCachedUser()).called(1);
        expect(result, equals(const Right(testUser)));
      });

      test('should return CacheFailure when there is no cached data', () async {
        when(() => mockLocalDataSource.getCachedUser())
            .thenThrow(CacheException());

        final result = await repository.login(testEmail, testPassword);

        verifyNever(() => mockRemoteDataSource.login(email: testEmail, password: testPassword));
        verify(() => mockLocalDataSource.getCachedUser()).called(1);
        expect(result, equals(const Left(CacheFailure())));
      });
    });
  });

  group('signUp', () {
    test('should check if device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.signUp(name: any(named: 'name'), email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => testUserModel);
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async => Future.value());

      await repository.signUp(testName, testEmail, testPassword);

      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    group('device online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data when call to remote datasource is successful', () async {
        when(() => mockRemoteDataSource.signUp(name: testName, email: testEmail, password: testPassword))
            .thenAnswer((_) async => testUserModel);
        when(() => mockLocalDataSource.cacheUser(testUserModel))
            .thenAnswer((_) async => Future.value());

        final result = await repository.signUp(testName, testEmail, testPassword);

        verify(() => mockRemoteDataSource.signUp(name: testName, email: testEmail, password: testPassword)).called(1);
        verify(() => mockLocalDataSource.cacheUser(testUserModel)).called(1);
        expect(result, equals(const Right(testUser)));
      });

      test('should return ServerFailure when call to remote datasource throws ServerException', () async {
        when(() => mockRemoteDataSource.signUp(name: testName, email: testEmail, password: testPassword))
            .thenThrow(ServerException());

        final result = await repository.signUp(testName, testEmail, testPassword);

        verify(() => mockRemoteDataSource.signUp(name: testName, email: testEmail, password: testPassword)).called(1);
        verifyNever(() => mockLocalDataSource.cacheUser(any()));
        expect(result, equals(const Left(ServerFailure())));
      });
    });

    group('device offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return NetworkFailure when device is offline', () async {
        final result = await repository.signUp(testName, testEmail, testPassword);

        verifyNever(() => mockRemoteDataSource.signUp(name: testName, email: testEmail, password: testPassword));
        expect(result, equals(const Left(NetworkFailure())));
      });
    });
  });

  group('logout', () {
    test('should clear cached user and return Right(null) on success', () async {
      when(() => mockLocalDataSource.clearUser()).thenAnswer((_) async => Future.value());

      final result = await repository.logout();

      verify(() => mockLocalDataSource.clearUser()).called(1);
      expect(result, equals(const Right(null)));
    });

    test('should return CacheFailure when clearUser throws an exception', () async {
      when(() => mockLocalDataSource.clearUser()).thenThrow(Exception());

      final result = await repository.logout();

      verify(() => mockLocalDataSource.clearUser()).called(1);
      expect(result, equals(const Left(CacheFailure())));
    });
  });
}
