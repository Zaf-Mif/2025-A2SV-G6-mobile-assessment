import 'package:bloc_test/bloc_test.dart';
import 'package:chat_app/features/authentication/core/error/failures.dart';
import 'package:chat_app/features/authentication/core/usecases/usecases.dart';
import 'package:chat_app/features/authentication/data/models/user_model.dart';
import 'package:chat_app/features/authentication/domain/usecases/check_authenticated_user.dart';
import 'package:chat_app/features/authentication/domain/usecases/login.dart';
import 'package:chat_app/features/authentication/domain/usecases/logout.dart';
import 'package:chat_app/features/authentication/domain/usecases/sign_up.dart';
import 'package:chat_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/authentication/presentation/bloc/auth_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLogin extends Mock implements Login {}

class MockSignup extends Mock implements SignUp {}

class MockLogout extends Mock implements Logout {}

class MockCheckAuthenticated extends Mock implements CheckAuthenticatedUser {}

void main() {
  late AuthBloc bloc;
  late MockLogin mockLogin;
  late MockSignup mockSignup;
  late MockLogout mockLogout;
  late MockCheckAuthenticated mockCheckAuthenticated;

  setUpAll(() {
    registerFallbackValue(const LoginParams(email: '', password: ''));
    registerFallbackValue(
      const SignUpParams(id: '', name: '', email: '', password: ''),
    );
    registerFallbackValue(NoParams());
  });
  setUp(() {
    mockLogin = MockLogin();
    mockSignup = MockSignup();
    mockLogout = MockLogout();
    mockCheckAuthenticated = MockCheckAuthenticated();
    bloc = AuthBloc(
      login: mockLogin,
      signUp: mockSignup,
      logout: mockLogout,
      checkAuthenticatedUser: mockCheckAuthenticated,
    );
  });

  group('AuthBloc- AppStarted', () {
    blocTest<AuthBloc, AuthState>(
      'should emits [AuthLoading(), Authenticated()] when AppStarted is added.',
      // Arrange
      build: () {
        when(
          () => mockCheckAuthenticated(),
        ).thenAnswer((_) async => const Right(true));
        return bloc;
      },
      // Act
      act: (bloc) => bloc.add(AppStarted()),
      // Assert
      expect: () => <AuthState>[AuthLoading(), Authenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'should emits [AuthLoading(), Unauthenticated()] when AppStarted is added.',
      // Arrange
      build: () {
        when(
          () => mockCheckAuthenticated(),
        ).thenAnswer((_) async => const Right(false));
        return bloc;
      },
      // Act
      act: (bloc) => bloc.add(AppStarted()),
      // Assert
      expect: () => <AuthState>[AuthLoading(), Unauthenticated()],
    );
  });

  group('AuthBloc SignInEvent', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tUser = UserModel(id: '1', name: 'Test User', email: tEmail);

    blocTest<AuthBloc, AuthState>(
      'should emits [AuthLoading(), Authenticated()] when SignInEvent is added and login succeeds.',
      // Arrange
      build: () {
        when(
          () => mockLogin(any()),
        ).thenAnswer((_) async => const Right(tUser));
        return bloc;
      },
      // Act
      act: (bloc) => bloc.add(const SignInEvent(tEmail, tPassword)),
      // Assert
      expect: () => <AuthState>[AuthLoading(), Authenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'should emits [AuthLoading(), Unauthenticated()] when SignInEvent is added and login fails.',
      // Arrange
      build: () {
        when(
          () => mockLogin(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Login failed')));
        return bloc;
      },
      // Act
      act: (bloc) => bloc.add(const SignInEvent(tEmail, tPassword)),
      // Assert
      expect: () => <AuthState>[AuthLoading(), const AuthError('Login Failed')],
    );
  });
  group('Sign Up', () {
    const tName = 'Test User';
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    test(
      'Should emit [AuthLoading(), AuthError()] when SignUpEvent is added and sign up fails.',
      // Arrange
      () {
        when(
          () => mockSignup(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Sign up failed')));
        return bloc;
      },
    );
    // Act
    (bloc) => bloc.add(const SignUpEvent(tName, tEmail, tPassword));
    // Assert
    () => <AuthState>[AuthLoading(), const AuthError('Sign up Failed')];
  });
  group('AuthBloc - LoggedOutEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading(), Unauthenticated()] when logout succeeds',
      build: () {
        when(
          () => mockLogout.call(any()),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(LoggedOutEvent()),
      expect: () => [AuthLoading(), Unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading(), AuthError()] when logout fails',
      build: () {
        when(
          () => mockLogout.call(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Logout failed')));
        return bloc;
      },
      act: (bloc) => bloc.add(LoggedOutEvent()),
      expect: () => [AuthLoading(), const AuthError('Logout Failed')],
    );
  });
}
