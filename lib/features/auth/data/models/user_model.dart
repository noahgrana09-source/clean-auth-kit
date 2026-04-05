import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:product_searcher/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Data model representing a user from Firebase Authentication.
///
/// Maps between Firebase's [firebase.User] and the domain [UserEntity].
/// Uses [freezed] for immutability and [json_serializable] for serialization.
@freezed
abstract class UserModel with _$UserModel {
  /// Creates a [UserModel] with the user's authentication data.
  const factory UserModel({
    /// The unique identifier of the user.
    required String uid,

    /// The user's email address.
    required String email,

    /// The user's display name.
    String? displayName,

    /// The URL of the user's profile photo.
    String? photoUrl,

    /// Whether the user's email has been verified.
    @Default(false) bool isEmailVerified,
  }) = _UserModel;

  /// Private constructor required for adding custom methods to freezed classes.
  const UserModel._();

  /// Creates a [UserModel] from a Firebase [firebase.User].
  ///
  /// Maps Firebase user properties to the corresponding model fields.
  factory UserModel.fromFirebaseUser(firebase.User firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      isEmailVerified: firebaseUser.emailVerified,
    );
  }

  /// Creates a [UserModel] from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts this [UserModel] to a domain [UserEntity].
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      isEmailVerified: isEmailVerified,
    );
  }
}
