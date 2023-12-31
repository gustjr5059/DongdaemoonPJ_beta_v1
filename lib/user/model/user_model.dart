import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String email;
  final String? photoURL;
  final String? displayName;

  UserModel({required this.id, required this.email, this.photoURL, this.displayName});

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      photoURL: user.photoURL,
      displayName: user.displayName,
    );
  }
}
