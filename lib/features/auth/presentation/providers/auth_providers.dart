import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_searcher/core/usecases/usecase.dart';
import 'package:product_searcher/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:product_searcher/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:product_searcher/features/auth/domain/entities/user_entity.dart';
import 'package:product_searcher/features/auth/domain/repositories/auth_repository.dart';
import 'package:product_searcher/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:product_searcher/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:product_searcher/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:product_searcher/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:product_searcher/features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:product_searcher/features/auth/domain/usecases/watch_auth_state_usecase.dart';
import 'package:product_searcher/features/auth/presentation/providers/auth_notifier.dart';
import 'package:product_searcher/features/auth/presentation/providers/auth_state.dart';

// ---------------------------------------------------------------------------
// Data layer providers
// ---------------------------------------------------------------------------

/// Provides the [FirebaseAuth] singleton instance.
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

/// Provides the [FirebaseFirestore] singleton instance.
final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

/// Provides the [AuthRemoteDataSource] implementation.
///
/// Depends on [firebaseAuthProvider] and [firestoreProvider].
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  ),
);

// ---------------------------------------------------------------------------
// Repository providers
// ---------------------------------------------------------------------------

/// Provides the [AuthRepository] implementation.
///
/// Depends on [authRemoteDataSourceProvider] for remote operations.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  ),
);

// ---------------------------------------------------------------------------
// Use case providers
// ---------------------------------------------------------------------------

/// Provides the [SignInWithGoogleUseCase].
final signInWithGoogleUseCaseProvider = Provider<SignInWithGoogleUseCase>(
  (ref) => SignInWithGoogleUseCase(ref.watch(authRepositoryProvider)),
);

/// Provides the [SignInWithEmailUseCase].
final signInWithEmailUseCaseProvider = Provider<SignInWithEmailUseCase>(
  (ref) => SignInWithEmailUseCase(ref.watch(authRepositoryProvider)),
);

/// Provides the [SignUpWithEmailUseCase].
final signUpWithEmailUseCaseProvider = Provider<SignUpWithEmailUseCase>(
  (ref) => SignUpWithEmailUseCase(ref.watch(authRepositoryProvider)),
);

/// Provides the [SignOutUseCase].
final signOutUseCaseProvider = Provider<SignOutUseCase>(
  (ref) => SignOutUseCase(ref.watch(authRepositoryProvider)),
);

/// Provides the [WatchAuthStateUseCase].
final watchAuthStateUseCaseProvider = Provider<WatchAuthStateUseCase>(
  (ref) => WatchAuthStateUseCase(ref.watch(authRepositoryProvider)),
);

/// Provides the [GetCurrentUserUseCase].
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>(
  (ref) => GetCurrentUserUseCase(ref.watch(authRepositoryProvider)),
);

// ---------------------------------------------------------------------------
// State management providers
// ---------------------------------------------------------------------------

/// Provides the [AuthNotifier] as a [NotifierProvider].
///
/// This is the main provider for managing authentication state.
/// Widgets should watch this provider to react to auth state changes.
/// Access the notifier via `ref.read(authNotifierProvider.notifier)`.
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// Provides a [Stream] of [UserEntity] reflecting real-time auth state changes.
///
/// Use this provider for reactive widgets that need to respond to
/// authentication state changes, such as an auth wrapper or route guard.
final authStateStreamProvider = StreamProvider<UserEntity?>((ref) {
  final watchAuthState = ref.watch(watchAuthStateUseCaseProvider);
  return watchAuthState(const NoParams());
});

/// Convenience provider that exposes the current [AuthState].
///
/// Useful for route guards and redirection logic.
final authStateProvider = Provider<AuthState>((ref) {
  return ref.watch(authNotifierProvider);
});
