import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_searcher/features/auth/data/datasources/auth_remote_datasource.dart';

import '../auth_data_mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocRef;
  late MockDocumentSnapshot mockSnapshot;
  late MockUserCredential mockUserCredential;
  late MockFirebaseUser mockUser;
  late MockUserMetadata mockMetadata;
  late AuthRemoteDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(SetOptions(merge: false));
  });

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();
    mockSnapshot = MockDocumentSnapshot();
    mockUserCredential = MockUserCredential();
    mockUser = MockFirebaseUser();
    mockMetadata = MockUserMetadata();

    dataSource = AuthRemoteDataSourceImpl(
      firebaseAuth: mockFirebaseAuth,
      firestore: mockFirestore,
    );

    when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
    when(() => mockCollection.doc(any())).thenReturn(mockDocRef);

    when(() => mockUser.uid).thenReturn('uid-123');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.displayName).thenReturn('Test User');
    when(() => mockUser.photoURL).thenReturn(null);
    when(() => mockUser.emailVerified).thenReturn(false);
    when(() => mockUser.metadata).thenReturn(mockMetadata);
    when(() => mockMetadata.creationTime).thenReturn(DateTime(2024, 1, 1));

    when(() => mockUserCredential.user).thenReturn(mockUser);
  });

  group('signUpWithEmailAndPassword', () {
    void stubSuccessfulAccountCreation() {
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockUserCredential);
      when(() => mockUser.updateDisplayName(any())).thenAnswer((_) async {});
      when(() => mockUser.reload()).thenAnswer((_) async {});
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
    }

    test(
      'creates the profile document when it does not already exist',
      () async {
        stubSuccessfulAccountCreation();
        when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
        when(() => mockSnapshot.exists).thenReturn(false);
        when(() => mockDocRef.set(any(), any())).thenAnswer((_) async {});

        final result = await dataSource.signUpWithEmailAndPassword(
          email: 'test@example.com',
          password: 'Password1!',
          name: 'Test User',
        );

        expect(result.uid, 'uid-123');
        verify(() => mockDocRef.set(any(), any())).called(1);
        verifyNever(() => mockUser.delete());
      },
    );

    test(
      'deletes the just-created user and rethrows when persisting the profile fails',
      () async {
        stubSuccessfulAccountCreation();
        when(() => mockDocRef.get()).thenThrow(
          FirebaseException(
            plugin: 'cloud_firestore',
            code: 'permission-denied',
            message: 'Missing or insufficient permissions',
          ),
        );
        when(() => mockUser.delete()).thenAnswer((_) async {});

        await expectLater(
          () => dataSource.signUpWithEmailAndPassword(
            email: 'test@example.com',
            password: 'Password1!',
            name: 'Test User',
          ),
          throwsA(
            isA<UserPersistenceException>().having(
              (e) => e.code,
              'code',
              'permission-denied',
            ),
          ),
        );
        verify(() => mockUser.delete()).called(1);
      },
    );

    test(
      'still surfaces the original persistence error even if the rollback delete itself fails',
      () async {
        stubSuccessfulAccountCreation();
        when(() => mockDocRef.get()).thenThrow(
          FirebaseException(
            plugin: 'cloud_firestore',
            code: 'permission-denied',
            message: 'Missing or insufficient permissions',
          ),
        );
        when(
          () => mockUser.delete(),
        ).thenThrow(FirebaseAuthException(code: 'requires-recent-login'));

        await expectLater(
          () => dataSource.signUpWithEmailAndPassword(
            email: 'test@example.com',
            password: 'Password1!',
            name: 'Test User',
          ),
          throwsA(isA<UserPersistenceException>()),
        );
        verify(() => mockUser.delete()).called(1);
      },
    );

    test(
      'throws AuthDataSourceException with a null-user code when account creation returns no user',
      () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(null);

        await expectLater(
          () => dataSource.signUpWithEmailAndPassword(
            email: 'test@example.com',
            password: 'Password1!',
            name: 'Test User',
          ),
          throwsA(
            isA<AuthDataSourceException>().having(
              (e) => e.code,
              'code',
              'null-user',
            ),
          ),
        );
      },
    );
  });

  group('signInWithEmailAndPassword', () {
    test('returns the UserModel when sign-in succeeds', () async {
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockUserCredential);

      final result = await dataSource.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'Password1!',
      );

      expect(result.uid, 'uid-123');
    });

    test(
      'throws AuthDataSourceException with a null-user code when the credential has no user',
      () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(null);

        await expectLater(
          () => dataSource.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'Password1!',
          ),
          throwsA(
            isA<AuthDataSourceException>().having(
              (e) => e.code,
              'code',
              'null-user',
            ),
          ),
        );
      },
    );
  });

  group('getCurrentUser', () {
    test('returns null when there is no signed-in user', () {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      expect(dataSource.getCurrentUser(), isNull);
    });

    test('returns the UserModel when there is a signed-in user', () {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

      final result = dataSource.getCurrentUser();

      expect(result?.uid, 'uid-123');
    });
  });
}
