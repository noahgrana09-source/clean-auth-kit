import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:product_searcher/features/auth/data/models/user_model.dart';

/// Abstract interface for the authentication remote data source.
///
/// Defines all remote authentication operations that interact with
/// Firebase Auth and Google Sign-In services.
abstract class AuthRemoteDataSource {
  /// Signs in the user using Google authentication.
  ///
  /// Uses Google Sign-In 7.2.0 with the new reactive API.
  /// Throws [Exception] if the sign-in is cancelled or fails.
  Future<UserModel> signInWithGoogle();

  /// Signs in the user with email and password.
  ///
  /// Throws [FirebaseAuthException] on authentication failure.
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Creates a new user account with email, password, and display name.
  ///
  /// Throws [FirebaseAuthException] on account creation failure.
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  /// Signs out the currently authenticated user from all providers.
  Future<void> signOut();

  /// Returns a stream of [UserModel] reflecting authentication state changes.
  ///
  /// Emits `null` when the user signs out.
  Stream<UserModel?> authStateChanges();

  /// Returns the currently authenticated user, or `null` if not signed in.
  UserModel? getCurrentUser();
}

/// Implementation of [AuthRemoteDataSource] using Firebase Auth and Google Sign-In.
///
/// Uses Google Sign-In 7.2.0 with the new singleton API:
/// - [GoogleSignIn.instance] for accessing the singleton
/// - [GoogleSignIn.instance.initialize] for initialization
/// - [GoogleSignIn.instance.authenticate] for the sign-in flow
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// The Firebase Authentication instance.
  final FirebaseAuth _firebaseAuth;

  /// Creates an [AuthRemoteDataSourceImpl] with the given [firebaseAuth] instance.
  AuthRemoteDataSourceImpl({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  @override
  Future<UserModel> signInWithGoogle() async {
    // Initialize Google Sign-In (required before any usage in 7.2.0)
    await GoogleSignIn.instance.initialize();

    // Start the Google Sign-In flow using authenticate() (NOT signIn())
    // In 7.2.0, authenticate() returns GoogleSignInAccount directly
    // and throws GoogleSignInException on failure/cancellation.
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance
        .authenticate();

    // Obtain auth tokens from the Google account.
    // In 7.2.0, authentication is a synchronous getter returning
    // GoogleSignInAuthentication which only contains idToken.
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    // Create Firebase credential using the idToken.
    // In Google Sign-In 7.2.0, accessToken is no longer part of
    // GoogleSignInAuthentication — it lives in GoogleSignInClientAuthorization.
    // Firebase Auth only requires idToken for credential creation.
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    final UserCredential userCredential = await _firebaseAuth
        .signInWithCredential(credential);

    final User? user = userCredential.user;
    if (user == null) {
      throw Exception('Firebase sign-in returned null user');
    }

    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    final User? user = userCredential.user;
    if (user == null) {
      throw Exception('Firebase sign-in returned null user');
    }

    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    final UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    final User? user = userCredential.user;
    if (user == null) {
      throw Exception('Firebase sign-up returned null user');
    }

    // Update the display name after account creation
    await user.updateDisplayName(name);
    await user.reload();

    // Get the updated user with the display name
    final User? updatedUser = _firebaseAuth.currentUser;
    if (updatedUser == null) {
      throw Exception('User not found after profile update');
    }

    return UserModel.fromFirebaseUser(updatedUser);
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      GoogleSignIn.instance.signOut(),
    ]);
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((User? user) {
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    });
  }

  @override
  UserModel? getCurrentUser() {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  }
}
