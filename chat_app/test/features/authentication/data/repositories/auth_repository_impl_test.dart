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
  const User testUser = testUserModel;

  const testToken = 'test_token';

  group('login', () {
    test('should check if device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => testToken);
      when(() => mockLocalDataSource.cacheToken(any())).thenAnswer((_) async => Future.value());

      final result = await repository.login(testEmail, testPassword);

      verify(() => mockNetworkInfo.isConnected).called(1);
      expect(result.isRight(), true);
    });

    group('device online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return token when remote login is successful', () async {
        when(() => mockRemoteDataSource.login(email: testEmail, password: testPassword))
            .thenAnswer((_) async => testToken);
        when(() => mockLocalDataSource.cacheToken(testToken))
            .thenAnswer((_) async => Future.value());

        final result = await repository.login(testEmail, testPassword);

        verify(() => mockRemoteDataSource.login(email: testEmail, password: testPassword)).called(1);
        verify(() => mockLocalDataSource.cacheToken(testToken)).called(1);
        expect(result, equals(Right(testToken)));
      });

      test('should return ServerFailure when remote login throws ServerException', () async {
        when(() => mockRemoteDataSource.login(email: testEmail, password: testPassword))
            .thenThrow(ServerException());

        final result = await repository.login(testEmail, testPassword);

        verify(() => mockRemoteDataSource.login(email: testEmail, password: testPassword)).called(1);
        verifyNever(() => mockLocalDataSource.cacheToken(any()));
        expect(result, equals(const Left(ServerFailure())));
      });
    });

    group('device offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return NetworkFailure when device is offline', () async {
        final result = await repository.login(testEmail, testPassword);

        verifyNever(() => mockRemoteDataSource.login(email: any(named: 'email'), password: any(named: 'password')));
        expect(result, equals(const Left(NetworkFailure())));
      });
    });
  });

  group('signUp', () {
    test('should check if device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.signUp(name: any(named: 'name'), email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => testUserModel);
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async => Future.value());

      final result = await repository.signUp(testName, testEmail, testPassword);

      verify(() => mockNetworkInfo.isConnected).called(1);
      expect(result.isRight(), true);
    });

    group('device online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return user when remote signUp is successful', () async {
        when(() => mockRemoteDataSource.signUp(name: testName, email: testEmail, password: testPassword))
            .thenAnswer((_) async => testUserModel);
        when(() => mockLocalDataSource.cacheUser(testUserModel))
            .thenAnswer((_) async => Future.value());

        final result = await repository.signUp(testName, testEmail, testPassword);

        verify(() => mockRemoteDataSource.signUp(name: testName, email: testEmail, password: testPassword)).called(1);
        verify(() => mockLocalDataSource.cacheUser(testUserModel)).called(1);
        expect(result, equals(Right(testUser)));
      });

      test('should return ServerFailure when remote signUp throws ServerException', () async {
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

        verifyNever(() => mockRemoteDataSource.signUp(name: any(named: 'name'), email: any(named: 'email'), password: any(named: 'password')));
        expect(result, equals(const Left(NetworkFailure())));
      });
    });
  });

  group('logout', () {
    test('should clear cached user and token and return Right(null) on success', () async {
      when(() => mockLocalDataSource.clearToken()).thenAnswer((_) async => Future.value());
      when(() => mockLocalDataSource.clearUser()).thenAnswer((_) async => Future.value());

      final result = await repository.logout();

      verify(() => mockLocalDataSource.clearToken()).called(1);
      verify(() => mockLocalDataSource.clearUser()).called(1);
      expect(result, equals(const Right(null)));
    });

    test('should return CacheFailure when clearToken throws exception', () async {
      when(() => mockLocalDataSource.clearToken()).thenThrow(Exception());

      final result = await repository.logout();

      verify(() => mockLocalDataSource.clearToken()).called(1);
      // It might or might not call clearUser depending on implementation flow. Adjust if needed
      expect(result, equals(const Left(CacheFailure())));
    });

    test('should return CacheFailure when clearUser throws exception', () async {
      when(() => mockLocalDataSource.clearToken()).thenAnswer((_) async => Future.value());
      when(() => mockLocalDataSource.clearUser()).thenThrow(Exception());

      final result = await repository.logout();

      verify(() => mockLocalDataSource.clearToken()).called(1);
      verify(() => mockLocalDataSource.clearUser()).called(1);
      expect(result, equals(const Left(CacheFailure())));
    });
  });

  group('getCurrentUser', () {
    test('should get user from remote when online and cache it', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getCurrentUser(testToken))
          .thenAnswer((_) async => testUserModel);
      when(() => mockLocalDataSource.cacheUser(testUserModel))
          .thenAnswer((_) async => Future.value());

      final result = await repository.getCurrentUser(testToken);

      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemoteDataSource.getCurrentUser(testToken)).called(1);
      verify(() => mockLocalDataSource.cacheUser(testUserModel)).called(1);
      expect(result, equals(Right(testUser)));
    });

    test('should get cached user when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => testUserModel);

      final result = await repository.getCurrentUser(testToken);

      verify(() => mockNetworkInfo.isConnected).called(1);
      verifyNever(() => mockRemoteDataSource.getCurrentUser(any()));
      verify(() => mockLocalDataSource.getCachedUser()).called(1);
      expect(result, equals(Right(testUser)));
    });

    test('should return ServerFailure when remote throws ServerException', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getCurrentUser(testToken))
          .thenThrow(ServerException());

      final result = await repository.getCurrentUser(testToken);

      verify(() => mockRemoteDataSource.getCurrentUser(testToken)).called(1);
      expect(result, equals(const Left(ServerFailure())));
    });

    test('should return CacheFailure when no cached user is present', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getCachedUser()).thenThrow(CacheException());

      final result = await repository.getCurrentUser(testToken);

      verify(() => mockLocalDataSource.getCachedUser()).called(1);
      expect(result, equals(const Left(CacheFailure())));
    });
  });
}
