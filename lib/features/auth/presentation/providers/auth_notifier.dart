import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:product_searcher/features/auth/domain/entities/user_entity.dart';
import 'package:product_searcher/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:product_searcher/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:product_searcher/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:product_searcher/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:product_searcher/features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:product_searcher/features/auth/presentation/providers/auth_providers.dart';
import 'package:product_searcher/features/auth/presentation/providers/auth_state.dart';
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

  @override
  AuthState build() {
    _signInWithGoogle = ref.watch(signInWithGoogleUseCaseProvider);
    _signInWithEmail = ref.watch(signInWithEmailUseCaseProvider);
    _signUpWithEmail = ref.watch(signUpWithEmailUseCaseProvider);
    _signOut = ref.watch(signOutUseCaseProvider);
    _getCurrentUser = ref.watch(getCurrentUserUseCaseProvider);

    // Check for existing authenticated user on initialization
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
    result.fold(
      (failure) => state = AuthState.error(failure.message, code: failure.code),
      (user) => state = AuthState.authenticated(user),
    );
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
