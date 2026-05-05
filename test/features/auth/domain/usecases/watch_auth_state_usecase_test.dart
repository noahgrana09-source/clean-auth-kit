import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_searcher/core/usecases/usecase.dart';
import 'package:product_searcher/features/auth/domain/entities/user_entity.dart';
import 'package:product_searcher/features/auth/domain/usecases/watch_auth_state_usecase.dart';

import '../auth_domain_mocks.dart';

void main() {
  late WatchAuthStateUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = WatchAuthStateUseCase(mockRepository);
  });

  final tUser = UserEntity(
    uid: '123',
    email: 'test@example.com',
    displayName: 'Test User',
    isEmailVerified: true,
    createdAt: DateTime(2024, 1, 1),
  );

  group('WatchAuthStateUseCase', () {
    test('should emit UserEntity when user is authenticated', () {
      when(
        () => mockRepository.watchAuthState(),
      ).thenAnswer((_) => Stream.fromIterable([tUser]));

      final stream = useCase(const NoParams());

      expect(stream, emitsInOrder([tUser]));
      verify(() => mockRepository.watchAuthState()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should emit null when user is signed out', () {
      when(
        () => mockRepository.watchAuthState(),
      ).thenAnswer((_) => Stream.fromIterable([null]));

      final stream = useCase(const NoParams());

      expect(stream, emitsInOrder([null]));
      verify(() => mockRepository.watchAuthState()).called(1);
    });

    test('should emit sequence of auth state changes', () {
      when(
        () => mockRepository.watchAuthState(),
      ).thenAnswer((_) => Stream.fromIterable([null, tUser, null]));

      final stream = useCase(const NoParams());

      expect(stream, emitsInOrder([null, tUser, null]));
      verify(() => mockRepository.watchAuthState()).called(1);
    });

    test('should forward errors from the repository stream', () {
      when(
        () => mockRepository.watchAuthState(),
      ).thenAnswer((_) => Stream.error(Exception('Connection lost')));

      final stream = useCase(const NoParams());

      expect(stream, emitsError(isA<Exception>()));
      verify(() => mockRepository.watchAuthState()).called(1);
    });
  });
}
