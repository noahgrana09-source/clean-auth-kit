import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:clean_auth_kit/core/error/failures.dart';
import 'package:clean_auth_kit/features/auth/domain/entities/user_entity.dart';
import 'package:clean_auth_kit/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:clean_auth_kit/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:clean_auth_kit/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:clean_auth_kit/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:clean_auth_kit/features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:clean_auth_kit/features/auth/domain/usecases/watch_google_sign_in_events_usecase.dart';
import 'package:clean_auth_kit/features/auth/presentation/providers/auth_providers.dart';
import 'package:clean_auth_kit/features/auth/presentation/providers/auth_state.dart';
import '../../../../core/usecases/usecase.dart';

part 'auth_notifier.g.dart';

/// Manages the authentication state of the application.
///
/// Uses Riverpod generator [Notifier] to emit [AuthState] changes in response
/// to authentication operations. Each method delegates to the corresponding
/// use case and maps the result to the appropriate state.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  late final SignInWithGoogleUseCase _signInWithGoogle;
  late final SignInWithEmailUseCase _signInWithEmail;
  late final SignUpWithEmailUseCase _signUpWithEmail;
  late final SignOutUseCase _signOut;
  late final GetCurrentUserUseCase _getCurrentUser;
  late final WatchGoogleSignInEventsUseCase _watchGoogleSignInEvents;

  @override
  AuthState build() {
    _signInWithGoogle = ref.watch(signInWithGoogleUseCaseProvider);
    _signInWithEmail = ref.watch(signInWithEmailUseCaseProvider);
    _signUpWithEmail = ref.watch(signUpWithEmailUseCaseProvider);
    _signOut = ref.watch(signOutUseCaseProvider);
    _getCurrentUser = ref.watch(getCurrentUserUseCaseProvider);
    _watchGoogleSignInEvents = ref.watch(watchGoogleSignInEventsUseCaseProvider);

    // On web, the Google button is rendered and driven entirely by
    // Google's own JS — there's no onPressed of ours to call
    // signInWithGoogle from, so the result only ever arrives here.
    final subscription = _watchGoogleSignInEvents(
      const NoParams(),
    ).listen(_applyGoogleSignInResult);
    ref.onDispose(subscription.cancel);

    final UserEntity? user = _getCurrentUser();
    if (user != null) {
      return AuthState.authenticated(user);
    }
    return const AuthState.unauthenticated();
  }

  /// Signs in the user using Google authentication.
  Future<void> signInWithGoogle() async {
    state = const AuthState.loading();
    final result = await _signInWithGoogle(const NoParams());
    _applyGoogleSignInResult(result);
  }

  /// Shared by [signInWithGoogle] and the [_watchGoogleSignInEvents]
  /// subscription set up in [build] — both report a Google sign-in
  /// outcome the same way, they just differ in how the sign-in itself
  /// was triggered.
  void _applyGoogleSignInResult(Either<Failure, UserEntity> result) {
    result.fold((failure) {
      if (failure.code == 'canceled') {
        state = const AuthState.unauthenticated();
        return;
      }
      state = AuthState.error(failure.message, code: failure.code);
    }, (user) => state = AuthState.authenticated(user));
  }

  /// Signs in the user with email and password credentials.
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    final result = await _signInWithEmail(
      SignInWithEmailParams(email: email, password: password),
    );
    result.fold(
      (failure) => state = AuthState.error(failure.message, code: failure.code),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// Creates a new user account with email, password, and display name.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AuthState.loading();
    final result = await _signUpWithEmail(
      SignUpWithEmailParams(email: email, password: password, name: name),
    );
    result.fold(
      (failure) => state = AuthState.error(failure.message, code: failure.code),
      (user) => state = AuthState.authenticated(user),
    );
  }

  void clearError() {
    if (state is AuthError) state = const AuthState.unauthenticated();
  }

  /// Signs out the currently authenticated user.
  Future<void> signOut() async {
    state = const AuthState.loading();
    final result = await _signOut(const NoParams());
    result.fold(
      (failure) => state = AuthState.error(failure.message, code: failure.code),
      (_) => state = const AuthState.unauthenticated(),
    );
  }
}
