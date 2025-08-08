// test/features/auth/domain/usecases/sign_up_test.dart

import 'package:chat_app/features/authentication/domain/entities/user.dart';
import 'package:chat_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:chat_app/features/authentication/domain/usecases/sign_up.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignUp usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignUp(mockAuthRepository);
  });

  const tName = 'John Doe';
  const tEmail = 'john@example.com';
  const tPassword = 'securepassword';
  const tUser = User(id: '123', name: tName, email: tEmail);

  test('should return User when signup is successful', () async {
    // arrange
    when(() => mockAuthRepository.signUp(tName, tEmail, tPassword))
        .thenAnswer((_) async => const Right(tUser));

    // act
    final result = await usecase(
        const SignUpParams(id: '', name: tName, email: tEmail, password: tPassword));

    // assert
    expect(result, equals(const Right(tUser)));
    verify(() => mockAuthRepository.signUp(tName, tEmail, tPassword)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
