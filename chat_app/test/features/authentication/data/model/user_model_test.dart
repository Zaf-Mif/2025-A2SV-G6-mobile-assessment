import 'dart:convert';

import 'package:chat_app/features/authentication/data/models/user_model.dart';
import 'package:chat_app/features/authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures/fixture_reader.dart';

void main() {
  late UserModel userModel;
  setUp(() {
    userModel = const UserModel(
      id: '1',
      name: 'Test User',
      email: 'test@example.com',
    );
  });

  group('UserModel', () {
    test('should be a subclass of User entity', () {
      expect(userModel, isA<User>());
    });

    test('fromJson should return a valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('user.json'));

      // act
      final result = UserModel.fromJson(jsonMap);

      // assert
      expect(result, equals(userModel));
    });

    test('toJson should return a map containing the proper data', () {
      // act
      final result = userModel.toJson();

      // assert
      final expectedMap = {'user': {
        'id': '1',
        'name': 'Test User',
        'email': 'test@example.com',
      }};
      expect(result, equals(expectedMap));
    });
  });
}
