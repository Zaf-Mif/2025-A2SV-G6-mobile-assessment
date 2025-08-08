part of 'auth_bloc.dart';


@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoggedIn extends AuthEvent {
  final String userId;

  const AuthLoggedIn(this.userId);


  @override
  List<Object?> get props => [userId];
}

// Triggered when app starts
class AppStarted extends AuthEvent {}

// Triggered when user submits login form
class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

// Triggered when user submits sign-up form
class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const SignUpEvent(this.name, this.email, this.password);

  @override
  List<Object?> get props => [name, email, password];
}

// Triggered when user presses logout
class LoggedOutEvent extends AuthEvent {}

// Check if user is already logged in
class CheckAuthStatusEvent extends AuthEvent {}