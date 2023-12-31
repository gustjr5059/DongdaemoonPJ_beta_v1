import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class UserModelBase {}

class UserModelLoading implements UserModelBase {}

class UserModel implements UserModelBase {
  String? id;
  String? email;

  UserModel({this.id, this.email});

  // Correctly defined method within the UserModel class
  static UserModel fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      email: user.email,
    );
  }
}

final userMeProvider = StateNotifierProvider<UserMeStateNotifier, UserModelBase?>(
      (ref) {
    return UserMeStateNotifier();
  },
);

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  UserMeStateNotifier() : super(null) {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        state = null;
      } else {
        state = UserModel.fromFirebaseUser(user);
      }
    });
  }


  Future<void> login({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        state = UserModel.fromFirebaseUser(user);
      }
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다.');
    }
  }
}

class UserModelError implements UserModelBase {
  final String message;

  UserModelError({required this.message});
}