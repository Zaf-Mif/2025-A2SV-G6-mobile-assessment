import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/usecases/usecases.dart';
import '../../domain/usecases/check_authenticated_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/sign_up.dart';
import 'auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final SignUp signUp;
  final Logout logout;
  final CheckAuthenticatedUser checkAuthenticatedUser;

  AuthBloc({
    required this.login,
    required this.signUp,
    required this.logout,
    required this.checkAuthenticatedUser,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<LoggedOutEvent>(_onLogout);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await checkAuthenticatedUser();

    result.fold(
      (failure) => emit(Unauthenticated()),
      (isloggedin) {
        if (isloggedin) {
          emit(Authenticated());
        } else {
          emit(Unauthenticated());
        }
      }
    );
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  final result = await login(LoginParams(email: event.email, password: event.password));
  result.fold(
    (failure) => emit(const AuthError('Login Failed')),
    (user) => emit(Authenticated()),
  );
}


  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signUp(SignUpParams(id: '', name: event.name, email: event.email, password: event.password));
    result.fold(
      (failure) => emit(const AuthError('Sign Up Failed')),
      (user) => emit(Authenticated()),
    );
  }

  Future<void> _onLogout(LoggedOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logout(NoParams());
    result.fold(
      (failure) => emit(const AuthError('Logout Failed')),
      (_) => emit(Unauthenticated()),
    );
  }
}
