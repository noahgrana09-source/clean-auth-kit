import 'package:product_searcher/core/usecases/usecase.dart';
import 'package:product_searcher/features/auth/domain/entities/user_entity.dart';
import 'package:product_searcher/features/auth/domain/repositories/auth_repository.dart';

/// Use case for watching authentication state changes.
///
/// Returns a [Stream] that emits [UserEntity] when a user is authenticated,
/// or `null` when the user is signed out.
class WatchAuthStateUseCase extends StreamUseCase<UserEntity?, NoParams> {
  /// The authentication repository.
  final AuthRepository _repository;

  /// Creates a [WatchAuthStateUseCase] with the given [repository].
  WatchAuthStateUseCase(AuthRepository repository) : _repository = repository;

  @override
  Stream<UserEntity?> call(NoParams params) {
    return _repository.watchAuthState();
  }
}
