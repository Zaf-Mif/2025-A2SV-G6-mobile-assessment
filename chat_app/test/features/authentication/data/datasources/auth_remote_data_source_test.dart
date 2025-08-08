import 'dart:convert';

import 'package:chat_app/features/authentication/core/error/exceptions.dart';
import 'package:chat_app/features/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:chat_app/features/authentication/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  const baseUrl =
      'https://g5-flutter-learning-path-be.onrender.com/api/v2/';

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = AuthRemoteDataSourceImpl(client: mockHttpClient);
    registerFallbackValue(Uri.parse(baseUrl));
  });
  group('login', () {
    const email = 'test@example.com';
    const password = 'password123';

    final userModel = UserModel.fromJson(
      json.decode(fixture('login_response.json')),
    );

    test(
      'should return UserModel when the response code is 200 (success).', 
      () async {
        // arrange
        when(
          () => mockHttpClient.post(
            Uri.parse(
              '$baseUrl/auth/login',
            ),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture('login_response.json'), 201),
        );

        // act
        final result = await dataSource.login(email: email, password: password);

        // assert
        expect(result, equals(userModel));
      },
    );

    test(
      'should throw a ServerException when the response code is not 201',
      () async {
        // arrange
        when(
          () => mockHttpClient.post(
            Uri.parse(
              '$baseUrl/auth/login',
            ),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          ),
        ).thenAnswer((_) async => http.Response('Unauthorized', 401));

        // act
        final call = dataSource.login;

        // assert
        expect(() => call(email: email, password: password), throwsA(isA<ServerException>()));
      },
    );
  });

  group('signUp', () {
    const name = 'Test User';
    const email = 'test@example.com';
    const password = 'password123';

    final userModel = UserModel.fromJson(
      json.decode(fixture('register_response.json')),
    );

    test(
      'should return UserModel when the response code is 201 (success)',
      () async {  
        // arrange
        when(
          () => mockHttpClient.post(
            Uri.parse('$baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'name': name, 'email': email, 'password': password}),
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture('register_response.json'), 200),
        );

        // act
        final result = await dataSource.signUp(name: name, email: email, password: password);

        // assert
        expect(result, equals(userModel));
        
      },
    );

    test(
      'should throw a ServerException when the response code is not 201',
      () async {
        // arrange
        when(
          () => mockHttpClient.post(
            Uri.parse('$baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'name': name, 'email': email, 'password': password}),
          ),
        ).thenAnswer((_) async => http.Response('Bad Request', 400));

        // act
        final call = dataSource.signUp;

        // assert
        expect(
          () => call(name: name, email: email, password: password),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });
  group('getCurrentUser', () {
    const token = 'valid_token';

    final userModel = UserModel.fromJson(
      json.decode(fixture('get_me_response.json')),
    );

    test('should return UserModel when the response code is 200 (success)', () async {
      // arrange
      when(() => mockHttpClient.get(
            Uri.parse('$baseUrl/users/me'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )).thenAnswer(
        (_) async => http.Response(fixture('get_me_response.json'), 200),
      );

      // act
      final result = await dataSource.getCurrentUser(token);

      // assert
      expect(result, equals(userModel));
    });

    test('should throw ServerException when the response code is not 200', () async {
      // arrange
      when(() => mockHttpClient.get(
            Uri.parse('$baseUrl/users/me'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )).thenAnswer(
        (_) async => http.Response('Unauthorized', 401),
      );

      // act
      final call = dataSource.getCurrentUser;

      // assert
      expect(() => call(token), throwsA(isA<ServerException>()));
    });
  });
}
