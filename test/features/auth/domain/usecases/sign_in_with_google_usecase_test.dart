import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_searcher/core/error/failures.dart';
import 'package:product_searcher/core/usecases/usecase.dart';
import 'package:product_searcher/features/auth/domain/entities/user_entity.dart';
import 'package:product_searcher/features/auth/domain/usecases/sign_in_with_google_usecase.dart';

import '../auth_domain_mocks.dart';

void main() {
  late SignInWithGoogleUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInWithGoogleUseCase(mockRepository);
  });

  const tUser = UserEntity(
    uid: '123',
    email: 'test@example.com',
    displayName: 'Test User',
    photoUrl: 'https://photo.url',
    isEmailVerified: true,
  );

  group('SignInWithGoogleUseCase', () {
    test('should return UserEntity when sign in is successful', () async {
      when(
        () => mockRepository.signInWithGoogle(),
      ).thenAnswer((_) async => const Right(tUser));

      final result = await useCase(const NoParams());

      expect(result, const Right(tUser));
      verify(() => mockRepository.signInWithGoogle()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return GoogleSignInFailure when sign in fails', () async {
      const failure = GoogleSignInFailure(message: 'Sign in cancelled');
      when(
        () => mockRepository.signInWithGoogle(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(const NoParams());

      expect(result, const Left(failure));
      verify(() => mockRepository.signInWithGoogle()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure on server error', () async {
      const failure = ServerFailure(message: 'Server error');
      when(
        () => mockRepository.signInWithGoogle(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(const NoParams());

      expect(result, const Left(failure));
      verify(() => mockRepository.signInWithGoogle()).called(1);
    });
  });
}
