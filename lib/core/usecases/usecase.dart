import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// Base contract for all use cases in the application.
///
/// Follows the Command pattern: each use case encapsulates
/// a single, well-defined business operation.
///
/// [Type] is the type of the successful result.
/// [Params] are the input parameters.
///
/// Implementation example:
/// ```dart
/// class SignInWithEmailUseCase implements UseCase<UserEntity, SignInParams> {
///   @override
///   Future<Either<Failure, UserEntity>> call(SignInParams params) async {
///     return _repository.signInWithEmailAndPassword(
///       email: params.email,
///       password: params.password,
///     );
///   }
/// }
/// ```
abstract class UseCase<T, Params> {
  /// Executes the use case with the given [params].
  ///
  /// Returns [Right] with the result if the operation succeeded,
  /// or [Left] with a descriptive [Failure] if it failed.
  Future<Either<Failure, T>> call(Params params);
}

/// Base contract for use cases that return a [Stream].
abstract class StreamUseCase<T, Params> {
  /// Returns a [Stream] of type [T] based on [params].
  Stream<T> call(Params params);
}

/// Empty parameters for use cases that require no input.
///
/// Usage:
/// ```dart
/// final result = await signOutUseCase(NoParams());
/// ```
class NoParams {
  /// Reusable instance to avoid unnecessary allocations.
  const NoParams();

  @override
  bool operator ==(Object other) => identical(this, other) || other is NoParams;

  @override
  int get hashCode => 0;
}
