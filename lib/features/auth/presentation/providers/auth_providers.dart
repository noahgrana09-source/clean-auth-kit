import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:product_searcher/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:product_searcher/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:product_searcher/features/auth/domain/repositories/auth_repository.dart';
import 'package:product_searcher/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:product_searcher/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:product_searcher/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:product_searcher/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:product_searcher/features/auth/domain/usecases/sign_up_with_email_usecase.dart';

part 'auth_providers.g.dart';

// ---------------------------------------------------------------------------
// Data layer providers
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

@Riverpod(keepAlive: true)
FirebaseFirestore firestore(Ref ref) => FirebaseFirestore.instance;

@Riverpod(keepAlive: true)
GoogleSignIn googleSignIn(Ref ref) => GoogleSignIn.instance;

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) => AuthRemoteDataSourceImpl(
  firebaseAuth: ref.watch(firebaseAuthProvider),
  firestore: ref.watch(firestoreProvider),
  googleSignIn: ref.watch(googleSignInProvider),
);

// ---------------------------------------------------------------------------
// Repository providers
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
  remoteDataSource: ref.watch(authRemoteDataSourceProvider),
);

// ---------------------------------------------------------------------------
// Use case providers
// ---------------------------------------------------------------------------

@riverpod
SignInWithGoogleUseCase signInWithGoogleUseCase(Ref ref) =>
    SignInWithGoogleUseCase(ref.watch(authRepositoryProvider));

@riverpod
SignInWithEmailUseCase signInWithEmailUseCase(Ref ref) =>
    SignInWithEmailUseCase(ref.watch(authRepositoryProvider));

@riverpod
SignUpWithEmailUseCase signUpWithEmailUseCase(Ref ref) =>
    SignUpWithEmailUseCase(ref.watch(authRepositoryProvider));

@riverpod
SignOutUseCase signOutUseCase(Ref ref) =>
    SignOutUseCase(ref.watch(authRepositoryProvider));

@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) =>
    GetCurrentUserUseCase(ref.watch(authRepositoryProvider));

// ---------------------------------------------------------------------------
// UI configuration
// ---------------------------------------------------------------------------

/// Si `true`, las pantallas de auth muestran la ilustración propia (el
/// candado animado) en vez de la animación de Rive.
///
/// Se define en tiempo de compilación. Por defecto es `false` (se usa
/// Rive); para probar la ilustración propia:
/// `flutter run --dart-define=USE_APP_ILLUSTRATION=true`
@Riverpod(keepAlive: true)
bool useAppIllustration(Ref ref) =>
    const bool.fromEnvironment('USE_APP_ILLUSTRATION', defaultValue: false);
