import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clean_auth_kit/core/error/failures.dart';
import 'package:clean_auth_kit/core/usecases/usecase.dart';
import 'package:clean_auth_kit/features/auth/domain/usecases/sign_out_usecase.dart';

import '../auth_domain_mocks.dart';

void main() {
  late SignOutUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignOutUseCase(mockRepository);
  });

  group('SignOutUseCase', () {
    test('should return void when sign out is successful', () async {
      when(
        () => mockRepository.signOut(),
      ).thenAnswer((_) async => const Right(unit));

      final result = await useCase(const NoParams());

      expect(result, const Right(unit));
      verify(() => mockRepository.signOut()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return the Failure from the repository unchanged', () async {
      const failure = ServerFailure(
        code: 'unknown-error',
        message: 'Sign out failed',
      );
      when(
        () => mockRepository.signOut(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(const NoParams());

      expect(result, const Left(failure));
      verify(() => mockRepository.signOut()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
