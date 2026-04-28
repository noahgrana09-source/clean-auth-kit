import 'package:dartz/dartz.dart';
import 'package:product_searcher/core/error/failures.dart';
import 'package:product_searcher/features/auth/domain/entities/user_entity.dart';

/// Abstract contract for the authentication repository.
///
/// Defines all authentication operations available in the domain layer.
/// The data layer must provide a concrete implementation of this interface.
/// All methods return [Either<Failure, T>] for functional error handling.
abstract class AuthRepository {
  /// Signs in the user using Google authentication.
  ///
  /// Returns [UserEntity] on success or a [Failure] on error.
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  /// Signs in the user with email and password credentials.
  ///
  /// Returns [UserEntity] on success or a [Failure] on error.
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Creates a new user account with email, password, and display name.
  ///
  /// Returns [UserEntity] on success or a [Failure] on error.
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  /// Signs out the currently authenticated user.
  ///
  /// Returns [Unit] on success or a [Failure] on error.
  Future<Either<Failure, Unit>> signOut();

  /// Watches the authentication state and emits [UserEntity] or null.
  ///
  /// Emits a [UserEntity] when a user is signed in, or `null` when signed out.
  Stream<UserEntity?> watchAuthState();

  /// Returns the currently authenticated user, or `null` if not signed in.
  UserEntity? getCurrentUser();
}
