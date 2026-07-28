import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_searcher/core/error/failures.dart';
import 'package:product_searcher/features/auth/data/models/user_model.dart';
import 'package:product_searcher/features/auth/data/repositories/auth_repository_impl.dart';

import '../auth_data_mocks.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(remoteDataSource: mockDataSource);
  });

  final tUserModel = UserModel(
    uid: '123',
    email: 'test@example.com',
    displayName: 'Test User',
    photoUrl: 'https://photo.url',
    isEmailVerified: true,
    createdAt: DateTime(2024, 1, 1),
  );

  final tUserEntity = tUserModel.toEntity();

  group('signInWithGoogle', () {
    test('should return UserEntity when data source succeeds', () async {
      when(
        () => mockDataSource.signInWithGoogle(),
      ).thenAnswer((_) async => tUserModel);

      final result = await repository.signInWithGoogle();

      expect(result, Right(tUserEntity));
      verify(() => mockDataSource.signInWithGoogle()).called(1);
    });

    test(
      'should return AuthFailure when FirebaseAuthException is thrown',
      () async {
        when(() => mockDataSource.signInWithGoogle()).thenThrow(
          FirebaseAuthException(
            code: 'account-exists-with-different-credential',
          ),
        );

        final result = await repository.signInWithGoogle();

        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<AuthFailure>());
          expect(
            (failure as AuthFailure).code,
            'account-exists-with-different-credential',
          );
        }, (_) => fail('Should be Left'));
      },
    );

    test('should return GoogleSignInFailure on generic Exception', () async {
      when(
        () => mockDataSource.signInWithGoogle(),
      ).thenThrow(Exception('Sign in cancelled'));

      final result = await repository.signInWithGoogle();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<GoogleSignInFailure>()),
        (_) => fail('Should be Left'),
      );
    });
  });

  group('signInWithEmailAndPassword', () {
    test('should return UserEntity when data source succeeds', () async {
      when(
        () => mockDataSource.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => tUserModel);

      final result = await repository.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result, Right(tUserEntity));
      verify(
        () => mockDataSource.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).called(1);
    });

    test('should return AuthFailure on FirebaseAuthException', () async {
      when(
        () => mockDataSource.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      final result = await repository.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'wrong',
      );

      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<AuthFailure>());
        expect((failure as AuthFailure).code, 'wrong-password');
      }, (_) => fail('Should be Left'));
    });

    test('should return ServerFailure on generic Exception', () async {
      when(
        () => mockDataSource.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('Unexpected error'));

      final result = await repository.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should be Left'),
      );
    });
  });

  group('signUpWithEmailAndPassword', () {
    test('should return UserEntity when data source succeeds', () async {
      when(
        () => mockDataSource.signUpWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => tUserModel);

      final result = await repository.signUpWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
      );

      expect(result, Right(tUserEntity));
      verify(
        () => mockDataSource.signUpWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        ),
      ).called(1);
    });

    test('should return AuthFailure on FirebaseAuthException', () async {
      when(
        () => mockDataSource.signUpWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      final result = await repository.signUpWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
      );

      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<AuthFailure>());
        expect((failure as AuthFailure).code, 'email-already-in-use');
      }, (_) => fail('Should be Left'));
    });

    test('should return ServerFailure on generic Exception', () async {
      when(
        () => mockDataSource.signUpWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenThrow(Exception('Server error'));

      final result = await repository.signUpWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should be Left'),
      );
    });
  });

  group('signOut', () {
    test('should return Right(unit) when sign out succeeds', () async {
      when(() => mockDataSource.signOut()).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result, const Right(unit));
      verify(() => mockDataSource.signOut()).called(1);
    });

    test('should return ServerFailure when sign out fails', () async {
      when(
        () => mockDataSource.signOut(),
      ).thenThrow(Exception('Sign out failed'));

      final result = await repository.signOut();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should be Left'),
      );
    });
  });

  group('getCurrentUser', () {
    test('should return UserEntity when user is authenticated', () {
      when(() => mockDataSource.getCurrentUser()).thenReturn(tUserModel);

      final result = repository.getCurrentUser();

      expect(result, tUserEntity);
      verify(() => mockDataSource.getCurrentUser()).called(1);
    });

    test('should return null when no user is authenticated', () {
      when(() => mockDataSource.getCurrentUser()).thenReturn(null);

      final result = repository.getCurrentUser();

      expect(result, isNull);
      verify(() => mockDataSource.getCurrentUser()).called(1);
    });
  });
}
