import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_searcher/features/auth/data/models/user_model.dart';
import 'package:product_searcher/features/auth/domain/entities/user_entity.dart';

import '../auth_data_mocks.dart';

void main() {
  group('UserModel', () {
    const tUserModel = UserModel(
      uid: '123',
      email: 'test@example.com',
      displayName: 'Test User',
      photoUrl: 'https://photo.url',
      isEmailVerified: true,
    );

    group('fromFirebaseUser', () {
      test('should create UserModel from Firebase User with all fields', () {
        final mockUser = MockFirebaseUser();
        when(() => mockUser.uid).thenReturn('123');
        when(() => mockUser.email).thenReturn('test@example.com');
        when(() => mockUser.displayName).thenReturn('Test User');
        when(() => mockUser.photoURL).thenReturn('https://photo.url');
        when(() => mockUser.emailVerified).thenReturn(true);

        final result = UserModel.fromFirebaseUser(mockUser);

        expect(result.uid, '123');
        expect(result.email, 'test@example.com');
        expect(result.displayName, 'Test User');
        expect(result.photoUrl, 'https://photo.url');
        expect(result.isEmailVerified, true);
      });

      test('should handle null optional fields from Firebase User', () {
        final mockUser = MockFirebaseUser();
        when(() => mockUser.uid).thenReturn('456');
        when(() => mockUser.email).thenReturn('user@example.com');
        when(() => mockUser.displayName).thenReturn(null);
        when(() => mockUser.photoURL).thenReturn(null);
        when(() => mockUser.emailVerified).thenReturn(false);

        final result = UserModel.fromFirebaseUser(mockUser);

        expect(result.uid, '456');
        expect(result.email, 'user@example.com');
        expect(result.displayName, isNull);
        expect(result.photoUrl, isNull);
        expect(result.isEmailVerified, false);
      });

      test(
        'should default email to empty string when Firebase email is null',
        () {
          final mockUser = MockFirebaseUser();
          when(() => mockUser.uid).thenReturn('789');
          when(() => mockUser.email).thenReturn(null);
          when(() => mockUser.displayName).thenReturn(null);
          when(() => mockUser.photoURL).thenReturn(null);
          when(() => mockUser.emailVerified).thenReturn(false);

          final result = UserModel.fromFirebaseUser(mockUser);

          expect(result.email, '');
        },
      );
    });

    group('toEntity', () {
      test('should convert UserModel to UserEntity with all fields', () {
        final entity = tUserModel.toEntity();

        expect(entity, isA<UserEntity>());
        expect(entity.uid, tUserModel.uid);
        expect(entity.email, tUserModel.email);
        expect(entity.displayName, tUserModel.displayName);
        expect(entity.photoUrl, tUserModel.photoUrl);
        expect(entity.isEmailVerified, tUserModel.isEmailVerified);
      });

      test('should preserve null optional fields in entity conversion', () {
        const model = UserModel(uid: '456', email: 'user@example.com');

        final entity = model.toEntity();

        expect(entity.displayName, isNull);
        expect(entity.photoUrl, isNull);
        expect(entity.isEmailVerified, false);
      });
    });

    group('fromJson / toJson', () {
      test('should serialize and deserialize correctly', () {
        final json = tUserModel.toJson();
        final fromJson = UserModel.fromJson(json);

        expect(fromJson, tUserModel);
      });

      test('should produce correct JSON keys', () {
        final json = tUserModel.toJson();

        expect(json['uid'], '123');
        expect(json['email'], 'test@example.com');
        expect(json['displayName'], 'Test User');
        expect(json['photoUrl'], 'https://photo.url');
        expect(json['isEmailVerified'], true);
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        const model1 = UserModel(
          uid: '123',
          email: 'test@example.com',
          displayName: 'Test User',
        );
        const model2 = UserModel(
          uid: '123',
          email: 'test@example.com',
          displayName: 'Test User',
        );
        expect(model1, equals(model2));
      });

      test('should not be equal when fields differ', () {
        const model1 = UserModel(uid: '123', email: 'test@example.com');
        const model2 = UserModel(uid: '456', email: 'test@example.com');
        expect(model1, isNot(equals(model2)));
      });
    });
  });
}
