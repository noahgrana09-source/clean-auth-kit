import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:product_searcher/core/error/failures.dart';
import 'package:product_searcher/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:product_searcher/features/auth/domain/entities/user_entity.dart';
import 'package:product_searcher/features/auth/domain/repositories/auth_repository.dart';

/// Concrete implementation of [AuthRepository].
///
/// Delegates operations to [AuthRemoteDataSource] and maps exceptions
/// to domain [Failure] types using [Either] from dartz.
class AuthRepositoryImpl implements AuthRepository {
  /// The remote data source for authentication operations.
  final AuthRemoteDataSource _remoteDataSource;

  /// Creates an [AuthRepositoryImpl] with the given [remoteDataSource].
  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final userModel = await _remoteDataSource.signInWithGoogle();
      return Right(userModel.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(code: e.code, message: e.message ?? ''));
    } on GoogleSignInException catch (e) {
      return Left(
        GoogleSignInFailure(message: 'Error at Google Sign In ${e.code}'),
      );
    } on AuthDataSourceException catch (e) {
      return Left(GoogleSignInFailure(message: e.message));
    } on FormatException catch (e) {
      return Left(GoogleSignInFailure(message: e.toString()));
    } on Exception catch (e) {
      return Left(GoogleSignInFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(userModel.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(code: e.code, message: e.message ?? ''));
    } on FormatException catch (e) {
      return Left(ServerFailure(message: e.toString()));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userModel = await _remoteDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
      return Right(userModel.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(code: e.code, message: e.message ?? ''));
    } on FormatException catch (e) {
      return Left(ServerFailure(message: e.toString()));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(unit);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  UserEntity? getCurrentUser() {
    return _remoteDataSource.getCurrentUser()?.toEntity();
  }
}
