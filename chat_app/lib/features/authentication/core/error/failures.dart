import 'package:equatable/equatable.dart';

/// Abstract class for all kinds of Failures
abstract class Failure extends Equatable {
  final String? message;

  const Failure([this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'Failure(message: $message)';
}

// General failures

/// Represents a failure due to a server issue
class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

/// Represents a failure due to network
class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

/// Represents a failure due to invalid cache or no local data
class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}

// failure due to no internet
class NoInternetFailure extends Failure {
  const NoInternetFailure([super.message]);
}
