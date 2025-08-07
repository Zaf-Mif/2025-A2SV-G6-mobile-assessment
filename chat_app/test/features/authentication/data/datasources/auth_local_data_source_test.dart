import 'dart:convert';

import 'package:chat_app/features/authentication/core/error/exceptions.dart';
import 'package:chat_app/features/authentication/data/datasource/auth_local_data_source.dart';
import 'package:chat_app/features/authentication/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/auth_repository_impl_test.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = AuthLocalDataSourceImpl(mockSharedPreferences);
  });

  const tUserModel = UserModel(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
  );
  final cachedUserJsonString = json.encode(tUserModel.toJson());

  group('cacheUser', () {
    test('should call SharedPreferences to cache the user', () async {
      // arrange
      when(
        () => mockSharedPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);

      // act
      await dataSource.cacheUser(tUserModel);

      // assert
      verify(
        () => mockSharedPreferences.setString(
          'CACHED_USER',
          cachedUserJsonString,
        ),
      );
    });
  });
    group('getCachedUser', () {
    test('should return UserModel when there is one in the cache', () async {
      // arrange
      when(() => mockSharedPreferences.getString('CACHED_USER'))
          .thenReturn(cachedUserJsonString);

      // act
      final result = await dataSource.getCachedUser();

      // assert
      expect(result, equals(tUserModel));
    });

    test('should throw CacheException when no cached user', () {
      // arrange
      when(() => mockSharedPreferences.getString('CACHED_USER'))
          .thenReturn(null);

      // act
      final call = dataSource.getCachedUser;

      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });
    group('clearUser', () {
    test('should remove CACHED_USER from shared preferences', () async {
      // arrange
      when(() => mockSharedPreferences.remove('CACHED_USER'))
          .thenAnswer((_) async => true);

      // act
      await dataSource.clearUser();

      // assert
      verify(() => mockSharedPreferences.remove('CACHED_USER'));
    });
  });
    group('logout', () {
    test('should remove both user and token', () async {
      // arrange
      when(() => mockSharedPreferences.remove('CACHED_USER'))
          .thenAnswer((_) async => true);
      when(() => mockSharedPreferences.remove('AUTH_TOKEN'))
          .thenAnswer((_) async => true);

      // act
      await dataSource.logout();

      // assert
      verify(() => mockSharedPreferences.remove('CACHED_USER'));
      verify(() => mockSharedPreferences.remove('AUTH_TOKEN'));
    });

    test('should throw CacheException if any removal fails', () async {
      // arrange
      when(() => mockSharedPreferences.remove('CACHED_USER'))
          .thenAnswer((_) async => false); // simulate failure
      when(() => mockSharedPreferences.remove('AUTH_TOKEN'))
          .thenAnswer((_) async => true);

      // act
      final call = dataSource.logout;

      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });
}

