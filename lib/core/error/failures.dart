import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
///
/// Follows the functional error handling pattern using dartz [Either].
/// Each failure type represents a specific category of error that can
/// occur during the execution of use cases.
abstract class Failure extends Equatable {
  /// Optional message describing the failure.
  final String message;

  /// Creates a [Failure] with an optional [message].
  const Failure({this.message = ''});

  @override
  List<Object?> get props => [message];
}

/// Failure originating from a server or remote service.
class ServerFailure extends Failure {
  /// Creates a [ServerFailure] with an optional [message].
  const ServerFailure({super.message});
}

/// Failure originating from Firebase Authentication.
class AuthFailure extends Failure {
  /// The Firebase error code associated with this failure.
  final String code;

  /// Creates an [AuthFailure] with a [code] and optional [message].
  const AuthFailure({required this.code, super.message});
}

/// Failure when Google Sign-In is cancelled or fails.
class GoogleSignInFailure extends Failure {
  /// Creates a [GoogleSignInFailure] with an optional [message].
  const GoogleSignInFailure({super.message});
}

/// Failure due to network connectivity issues.
class NetworkFailure extends Failure {
  /// Creates a [NetworkFailure] with an optional [message].
  const NetworkFailure({super.message});
}
