import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_searcher/features/auth/data/datasources/auth_remote_datasource.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockFirebaseUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUserMetadata extends Mock implements UserMetadata {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
