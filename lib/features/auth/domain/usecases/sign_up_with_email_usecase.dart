import 'package:dartz/dartz.dart';
import 'package:product_searcher/core/error/failures.dart';
import 'package:product_searcher/core/usecases/usecase.dart';
import 'package:product_searcher/features/auth/domain/entities/user_entity.dart';
import 'package:product_searcher/features/auth/domain/repositories/auth_repository.dart';

/// Use case for creating a new user account with email and password.
///
/// Delegates to [AuthRepository.signUpWithEmailAndPassword] and returns
/// the newly created [UserEntity] on success.
class SignUpWithEmailUseCase
    extends UseCase<UserEntity, SignUpWithEmailParams> {
  /// The authentication repository.
  final AuthRepository _repository;

  /// Creates a [SignUpWithEmailUseCase] with the given [repository].
  SignUpWithEmailUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignUpWithEmailParams params) {
    return _repository.signUpWithEmailAndPassword(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}

/// Parameters required for signing up with email, password, and name.
class SignUpWithEmailParams {
  /// The user's email address.
  final String email;

  /// The user's password.
  final String password;

  /// The user's display name.
  final String name;

  /// Creates [SignUpWithEmailParams] with the given [email], [password], and [name].
  const SignUpWithEmailParams({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignUpWithEmailParams &&
          email == other.email &&
          password == other.password &&
          name == other.name;

  @override
  int get hashCode => Object.hash(email, password, name);
}
