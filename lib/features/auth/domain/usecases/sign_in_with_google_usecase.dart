import 'package:dartz/dartz.dart';
import 'package:clean_auth_kit/core/error/failures.dart';
import 'package:clean_auth_kit/core/usecases/usecase.dart';
import 'package:clean_auth_kit/features/auth/domain/entities/user_entity.dart';
import 'package:clean_auth_kit/features/auth/domain/repositories/auth_repository.dart';

/// Use case for signing in with Google authentication.
///
/// Delegates to [AuthRepository.signInWithGoogle] and returns the
/// authenticated [UserEntity] on success.
class SignInWithGoogleUseCase extends UseCase<UserEntity, NoParams> {
  /// The authentication repository.
  final AuthRepository _repository;

  /// Creates a [SignInWithGoogleUseCase] with the given [repository].
  SignInWithGoogleUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return _repository.signInWithGoogle();
  }
}
