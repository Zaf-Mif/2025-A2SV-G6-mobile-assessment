import 'package:bloc_test/bloc_test.dart';
import 'package:chat_app/features/authentication/core/error/failures.dart';
import 'package:chat_app/features/authentication/core/usecases/usecases.dart';
import 'package:chat_app/features/authentication/domain/entities/user.dart';
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

  // Register fallback values for usecase parameters
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

  group('AuthBloc - AppStarted', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when user is authenticated',
      build: () {
        when(() => mockCheckAuthenticated())
            .thenAnswer((_) async => const Right(true));
        return bloc;
      },
      act: (bloc) => bloc.add(AppStarted()),
      expect: () => [AuthLoading(), Authenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] when user is not authenticated',
      build: () {
        when(() => mockCheckAuthenticated())
            .thenAnswer((_) async => const Right(false));
        return bloc;
      },
      act: (bloc) => bloc.add(AppStarted()),
      expect: () => [AuthLoading(), Unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] when checkAuthenticatedUser fails',
      build: () {
        when(() => mockCheckAuthenticated())
            .thenAnswer((_) async => const Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(AppStarted()),
      expect: () => [AuthLoading(), Unauthenticated()],
    );
  });

  group('AuthBloc - SignInEvent', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when login succeeds',
      build: () {
        when(() => mockLogin.call(any())).thenAnswer((_) async => const Right('token'));
        return bloc;
      },
      act: (bloc) => bloc.add(const SignInEvent(tEmail, tPassword)),
      expect: () => [AuthLoading(), Authenticated()],
      verify: (_) {
        verify(() => mockLogin.call(const LoginParams(email: tEmail, password: tPassword))).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(() => mockLogin.call(any())).thenAnswer(
          (_) async => const Left(ServerFailure('Login failed')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const SignInEvent(tEmail, tPassword)),
      expect: () => [AuthLoading(), const AuthError('Login Failed')],
      verify: (_) {
        verify(() => mockLogin.call(const LoginParams(email: tEmail, password: tPassword))).called(1);
      },
    );
  });

group('AuthBloc - SignUpEvent', () {
  const tName = 'Test User';
  const tEmail = 'test@example.com';
  const tPassword = 'password123';

  const tUser = User(id: '1', name: tName, email: tEmail);

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, Authenticated] when sign up succeeds',
    build: () {
      when(() => mockSignup.call(any())).thenAnswer((_) async => const Right(tUser));
      return bloc;
    },
    act: (bloc) => bloc.add(const SignUpEvent(tName, tEmail, tPassword, )),
    expect: () => [AuthLoading(), Authenticated()],
    verify: (_) {
      verify(() => mockSignup.call(const SignUpParams(id: '', name: tName, email: tEmail, password: tPassword))).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthError] when sign up fails',
    build: () {
      when(() => mockSignup.call(any())).thenAnswer(
        (_) async => const Left(ServerFailure('Sign up failed')),
      );
      return bloc;
    },
    act: (bloc) => bloc.add(const SignUpEvent(tName, tEmail, tPassword)),
    expect: () => [AuthLoading(), const AuthError('Sign Up Failed')],
    verify: (_) {
      verify(() => mockSignup.call(const SignUpParams(id: '', name: tName, email: tEmail, password: tPassword))).called(1);
    },
  );
});

  group('AuthBloc - LoggedOutEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] when logout succeeds',
      build: () {
        when(() => mockLogout.call(any())).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(LoggedOutEvent()),
      expect: () => [AuthLoading(), Unauthenticated()],
      verify: (_) {
        verify(() => mockLogout.call(NoParams())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when logout fails',
      build: () {
        when(() => mockLogout.call(any())).thenAnswer(
          (_) async => const Left(ServerFailure('Logout failed')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(LoggedOutEvent()),
      expect: () => [AuthLoading(), const AuthError('Logout Failed')],
      verify: (_) {
        verify(() => mockLogout.call(NoParams())).called(1);
      },
    );
  });
}
