import 'package:dartz/dartz.dart';
import 'package:clean_auth_kit/core/error/failures.dart';
import 'package:clean_auth_kit/core/usecases/usecase.dart';
import 'package:clean_auth_kit/features/auth/domain/entities/user_entity.dart';
import 'package:clean_auth_kit/features/auth/domain/repositories/auth_repository.dart';

/// Watches for Google sign-ins completed outside an explicit
/// [AuthRepository.signInWithGoogle] call (the web rendered button).
///
/// Delegates to [AuthRepository.googleSignInEvents].
class WatchGoogleSignInEventsUseCase
    extends StreamUseCase<Either<Failure, UserEntity>, NoParams> {
  /// The authentication repository.
  final AuthRepository _repository;

  /// Creates a [WatchGoogleSignInEventsUseCase] with the given [repository].
  WatchGoogleSignInEventsUseCase(this._repository);

  @override
  Stream<Either<Failure, UserEntity>> call(NoParams params) {
    return _repository.googleSignInEvents;
  }
}
