import 'package:dartz/dartz.dart';
import 'package:product_searcher/core/error/failures.dart';
import 'package:product_searcher/core/usecases/usecase.dart';
import 'package:product_searcher/features/auth/domain/repositories/auth_repository.dart';

/// Use case for signing out the currently authenticated user.
///
/// Delegates to [AuthRepository.signOut] and returns [void] on success.
class SignOutUseCase extends UseCase<void, NoParams> {
  /// The authentication repository.
  final AuthRepository _repository;

  /// Creates a [SignOutUseCase] with the given [repository].
  SignOutUseCase(AuthRepository repository) : _repository = repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.signOut();
  }
}
