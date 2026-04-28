import 'package:dartz/dartz.dart';
import 'package:product_searcher/core/error/failures.dart';
import 'package:product_searcher/core/usecases/usecase.dart';
import 'package:product_searcher/features/auth/domain/repositories/auth_repository.dart';

/// Use case for signing out the currently authenticated user.
///
/// Delegates to [AuthRepository.signOut] and returns [Unit] on success.
class SignOutUseCase extends UseCase<Unit, NoParams> {
  /// The authentication repository.
  final AuthRepository _repository;

  /// Creates a [SignOutUseCase] with the given [repository].
  SignOutUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.signOut();
  }
}
