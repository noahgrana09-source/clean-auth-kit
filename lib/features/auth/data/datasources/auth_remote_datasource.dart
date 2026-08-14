import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:clean_auth_kit/features/auth/data/models/user_model.dart';

/// Abstract interface for the authentication remote data source.
///
/// Defines all remote authentication operations that interact with
/// Firebase Auth and Google Sign-In services.

class AuthDataSourceException implements Exception {
  /// A stable identifier for the specific invariant that was violated,
  /// assigned here at the throw site since this is the layer that
  /// actually knows why it happened.
  final String code;
  final String message;
  const AuthDataSourceException({required this.code, required this.message});

  @override
  String toString() => 'AuthDataSourceException: $message';
}

/// Thrown when reading or writing the user's profile document fails.
///
/// Kept separate from [AuthDataSourceException] so the repository can
/// tell "the profile persistence step failed" apart from other
/// datasource-level errors, even though in both cases Firebase Auth
/// itself already succeeded.
class UserPersistenceException implements Exception {
  final String code;
  final String message;
  const UserPersistenceException({required this.code, required this.message});

  @override
  String toString() => 'UserPersistenceException: $message';
}

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

  /// The Firestore instance for persisting user data.
  final FirebaseFirestore _firestore;

  /// The Google Sign-In instance.
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _googleSignIn = googleSignIn;

  @override
  Future<UserModel> signInWithGoogle() async {
    // Initialize Google Sign-In (required before any usage in 7.2.0)
    await _googleSignIn.initialize();

    // Start the Google Sign-In flow using authenticate() (NOT signIn())
    // In 7.2.0, authenticate() returns GoogleSignInAccount directly
    // and throws GoogleSignInException on failure/cancellation.
    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

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

    final UserCredential userCredential = await _firebaseAuth
        .signInWithCredential(credential);

    final User? user = userCredential.user;
    if (user == null) {
      throw const AuthDataSourceException(
        code: 'null-user',
        message: 'Firebase sign-in returned null user',
      );
    }

    final userModel = UserModel.fromFirebaseUser(user);

    try {
      await _saveUserToFirestore(userModel);
    } catch (e) {
      // Only roll back if this sign-in just created the account: an
      // existing user must never be deleted over a transient failure
      // reading/writing its profile.
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _deleteUser(user);
      }
      rethrow;
    }

    return userModel;
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
      throw const AuthDataSourceException(
        code: 'null-user',
        message: 'Firebase sign-in returned null user',
      );
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
      throw const AuthDataSourceException(
        code: 'null-user',
        message: 'Firebase sign-up returned null user',
      );
    }

    await user.updateDisplayName(name);
    await user.reload();

    final User? updatedUser = _firebaseAuth.currentUser;
    if (updatedUser == null) {
      throw const AuthDataSourceException(
        code: 'profile-update-failed',
        message: 'User not found after profile update',
      );
    }

    final userModel = UserModel.fromFirebaseUser(updatedUser);
    try {
      await _saveUserToFirestore(userModel);
    } catch (e) {
      // This account was just created in this same call, so it is
      // always safe to roll it back: undo the sign-up rather than
      // leaving an orphaned Firebase Auth account with no profile,
      // which would block retrying with the same email.
      await _deleteUser(updatedUser);
      rethrow;
    }
    return userModel;
  }

  @override
  Future<void> signOut() async {
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  @override
  UserModel? getCurrentUser() {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  }

  /// Best-effort rollback: deletes [user] if the account was left
  /// without a persisted profile. Swallows any secondary failure so
  /// the original persistence error is what gets surfaced regardless.
  Future<void> _deleteUser(User user) async {
    try {
      await user.delete();
    } catch (_) {
      // Ignored: nothing more we can do here.
    }
  }

  Future<void> _saveUserToFirestore(UserModel model) async {
    try {
      final userDoc = await _firestore.collection('users').doc(model.uid).get();
      if (!userDoc.exists) {
        await _firestore
            .collection('users')
            .doc(model.uid)
            .set(model.toFirestore(), SetOptions(merge: false));
      }
    } on FirebaseException catch (e) {
      throw UserPersistenceException(
        code: e.code,
        message: e.message ?? 'Failed to persist user profile',
      );
    }
  }
}
