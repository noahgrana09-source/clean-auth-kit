import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_searcher/features/auth/data/models/user_model.dart';
import 'package:product_searcher/features/auth/domain/entities/user_entity.dart';

import '../auth_data_mocks.dart';

void main() {
  final tCreatedAt = DateTime(2024, 1, 1);

  final tUserModel = UserModel(
    uid: '123',
    email: 'test@example.com',
    displayName: 'Test User',
    photoUrl: 'https://photo.url',
    isEmailVerified: true,
    createdAt: tCreatedAt,
  );

  group('UserModel', () {
    group('fromFirebaseUser', () {
      test('should create UserModel from Firebase User with all fields', () {
        final mockUser = MockFirebaseUser();
        final mockMetadata = MockUserMetadata();
        when(() => mockUser.uid).thenReturn('123');
        when(() => mockUser.email).thenReturn('test@example.com');
        when(() => mockUser.displayName).thenReturn('Test User');
        when(() => mockUser.photoURL).thenReturn('https://photo.url');
        when(() => mockUser.emailVerified).thenReturn(true);
        when(() => mockUser.metadata).thenReturn(mockMetadata);
        when(() => mockMetadata.creationTime).thenReturn(tCreatedAt);

        final result = UserModel.fromFirebaseUser(mockUser);

        expect(result.uid, '123');
        expect(result.email, 'test@example.com');
        expect(result.displayName, 'Test User');
        expect(result.photoUrl, 'https://photo.url');
        expect(result.isEmailVerified, true);
        expect(result.createdAt, tCreatedAt);
      });

      test('should handle null optional fields from Firebase User', () {
        final mockUser = MockFirebaseUser();
        final mockMetadata = MockUserMetadata();
        when(() => mockUser.uid).thenReturn('456');
        when(() => mockUser.email).thenReturn('user@example.com');
        when(() => mockUser.displayName).thenReturn(null);
        when(() => mockUser.photoURL).thenReturn(null);
        when(() => mockUser.emailVerified).thenReturn(false);
        when(() => mockUser.metadata).thenReturn(mockMetadata);
        when(() => mockMetadata.creationTime).thenReturn(tCreatedAt);

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
          final mockMetadata = MockUserMetadata();
          when(() => mockUser.uid).thenReturn('789');
          when(() => mockUser.email).thenReturn(null);
          when(() => mockUser.displayName).thenReturn(null);
          when(() => mockUser.photoURL).thenReturn(null);
          when(() => mockUser.emailVerified).thenReturn(false);
          when(() => mockUser.metadata).thenReturn(mockMetadata);
          when(() => mockMetadata.creationTime).thenReturn(tCreatedAt);

          final result = UserModel.fromFirebaseUser(mockUser);

          expect(result.email, '');
        },
      );

      test(
        'should fallback to DateTime.now() when Firebase creationTime is null',
        () {
          final mockUser = MockFirebaseUser();
          final mockMetadata = MockUserMetadata();
          when(() => mockUser.uid).thenReturn('999');
          when(() => mockUser.email).thenReturn('user@example.com');
          when(() => mockUser.displayName).thenReturn(null);
          when(() => mockUser.photoURL).thenReturn(null);
          when(() => mockUser.emailVerified).thenReturn(false);
          when(() => mockUser.metadata).thenReturn(mockMetadata);
          when(() => mockMetadata.creationTime).thenReturn(null);

          final before = DateTime.now();
          final result = UserModel.fromFirebaseUser(mockUser);
          final after = DateTime.now();

          expect(
            result.createdAt.isAfter(before) ||
                result.createdAt.isAtSameMomentAs(before),
            true,
          );
          expect(
            result.createdAt.isBefore(after) ||
                result.createdAt.isAtSameMomentAs(after),
            true,
          );
        },
      );
    });

    group('fromFirestore', () {
      test('should create UserModel from Firestore uid and data', () {
        final result = UserModel.fromFirestore('123', {
          'email': 'test@example.com',
          'displayName': 'Test User',
          'photoUrl': 'https://photo.url',
          'isEmailVerified': true,
          'createdAt': Timestamp.fromDate(tCreatedAt),
        });

        expect(result.uid, '123');
        expect(result.email, 'test@example.com');
        expect(result.displayName, 'Test User');
        expect(result.photoUrl, 'https://photo.url');
        expect(result.isEmailVerified, true);
        expect(result.createdAt, tCreatedAt);
      });

      test('should handle null optional fields from Firestore', () {
        final result = UserModel.fromFirestore('456', {
          'email': 'user@example.com',
          'displayName': null,
          'photoUrl': null,
          'isEmailVerified': false,
          'createdAt': Timestamp.fromDate(tCreatedAt),
        });

        expect(result.displayName, isNull);
        expect(result.photoUrl, isNull);
        expect(result.isEmailVerified, false);
      });
    });

    group('toFirestore', () {
      test('should serialize to Firestore format with Timestamp', () {
        final result = tUserModel.toFirestore();

        expect(result['email'], 'test@example.com');
        expect(result['displayName'], 'Test User');
        expect(result['photoUrl'], 'https://photo.url');
        expect(result['isEmailVerified'], true);
        expect(result['createdAt'], Timestamp.fromDate(tCreatedAt));
      });

      test('should not include uid in Firestore map', () {
        final result = tUserModel.toFirestore();
        expect(result.containsKey('uid'), false);
      });
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
        expect(entity.createdAt, tUserModel.createdAt);
      });

      test('should preserve null optional fields in entity conversion', () {
        final model = UserModel(
          uid: '456',
          email: 'user@example.com',
          createdAt: tCreatedAt,
        );

        final entity = model.toEntity();

        expect(entity.displayName, isNull);
        expect(entity.photoUrl, isNull);
        expect(entity.isEmailVerified, false);
        expect(entity.createdAt, tCreatedAt);
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
        expect(json.containsKey('createdAt'), true);
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        final model1 = UserModel(
          uid: '123',
          email: 'test@example.com',
          displayName: 'Test User',
          createdAt: tCreatedAt,
        );
        final model2 = UserModel(
          uid: '123',
          email: 'test@example.com',
          displayName: 'Test User',
          createdAt: tCreatedAt,
        );
        expect(model1, equals(model2));
      });

      test('should not be equal when fields differ', () {
        final model1 = UserModel(
          uid: '123',
          email: 'test@example.com',
          createdAt: tCreatedAt,
        );
        final model2 = UserModel(
          uid: '456',
          email: 'test@example.com',
          createdAt: tCreatedAt,
        );
        expect(model1, isNot(equals(model2)));
      });
    });
  });
}
