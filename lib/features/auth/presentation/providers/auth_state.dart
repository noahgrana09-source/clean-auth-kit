import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:product_searcher/features/auth/domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

/// Represents the possible states of authentication in the application.
///
/// Uses freezed sealed unions for exhaustive pattern matching.
/// Each state variant represents a distinct phase of the authentication flow.
@freezed
abstract class AuthState with _$AuthState {
  /// Initial state before any authentication check has been performed.
  const factory AuthState.initial() = AuthInitial;

  /// Authentication operation is in progress.
  const factory AuthState.loading() = AuthLoading;

  /// User is authenticated successfully.
  ///
  /// Contains the [user] entity with the authenticated user's information.
  const factory AuthState.authenticated(UserEntity user) = AuthAuthenticated;

  /// User is not authenticated.
  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  /// An error occurred during authentication.
  ///
  /// Contains a [message] describing the error.
  const factory AuthState.error(String message) = AuthError;
}
