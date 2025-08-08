import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

// Initial loading state (e.g., while checking cache)
class AuthInitial extends AuthState {}

// While loading login/signup/logout
class AuthLoading extends AuthState {}

// If user is authenticated
class Authenticated extends AuthState {}

// If user is not authenticated
class Unauthenticated extends AuthState {}

// If there's an error (login/signup failure)
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
