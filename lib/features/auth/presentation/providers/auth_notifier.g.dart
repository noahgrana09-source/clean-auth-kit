// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the authentication state of the application.
///
/// Uses Riverpod generator [Notifier] to emit [AuthState] changes in response
/// to authentication operations. Each method delegates to the corresponding
/// use case and maps the result to the appropriate state.

@ProviderFor(AuthNotifier)
final authProvider = AuthNotifierProvider._();

/// Manages the authentication state of the application.
///
/// Uses Riverpod generator [Notifier] to emit [AuthState] changes in response
/// to authentication operations. Each method delegates to the corresponding
/// use case and maps the result to the appropriate state.
final class AuthNotifierProvider
    extends $NotifierProvider<AuthNotifier, AuthState> {
  /// Manages the authentication state of the application.
  ///
  /// Uses Riverpod generator [Notifier] to emit [AuthState] changes in response
  /// to authentication operations. Each method delegates to the corresponding
  /// use case and maps the result to the appropriate state.
  AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$authNotifierHash() => r'1a7da5508db7d93b8dffae8aaabcaa9136660505';

/// Manages the authentication state of the application.
///
/// Uses Riverpod generator [Notifier] to emit [AuthState] changes in response
/// to authentication operations. Each method delegates to the corresponding
/// use case and maps the result to the appropriate state.

abstract class _$AuthNotifier extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
