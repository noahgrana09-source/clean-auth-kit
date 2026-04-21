import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// Contrato base para todos los casos de uso de la aplicación.
///
/// Sigue el patrón Command: cada caso de uso encapsula
/// una única operación de negocio bien definida.
///
/// [Type] es el tipo del resultado exitoso.
/// [Params] son los parámetros de entrada.
///
/// Ejemplo de implementación:
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
  /// Ejecuta el caso de uso con los [params] dados.
  ///
  /// Retorna [Right] con el resultado si la operación fue exitosa,
  /// o [Left] con un [Failure] descriptivo si falló.
  Future<Either<Failure, T>> call(Params params);
}

/// Contrato base para casos de uso que retornan un [Stream].
///
/// Usado para operaciones reactivas como observar el estado de autenticación.
///
/// Ejemplo:
/// ```dart
/// class WatchAuthStateUseCase implements StreamUseCase<UserEntity?, NoParams> {
///   @override
///   Stream<UserEntity?> call(NoParams params) => _repository.watchAuthState();
/// }
/// ```
abstract class StreamUseCase<T, Params> {
  /// Retorna un [Stream] del tipo [T] en función de [params].
  Stream<T> call(Params params);
}

/// Parámetros vacíos para casos de uso que no requieren entrada.
///
/// Uso:
/// ```dart
/// final result = await signOutUseCase(NoParams());
/// ```
class NoParams {
  /// Instancia reutilizable para evitar allocations innecesarios.
  const NoParams();

  @override
  bool operator ==(Object other) => identical(this, other) || other is NoParams;

  @override
  int get hashCode => 0;
}
