
// Firebase의 사용자 인증 기능을 제공하는 FirebaseAuth 패키지를 임포트합니다.
// FirebaseAuth는 Firebase 플랫폼의 일부로, 사용자 로그인 및 계정 관리 기능을 쉽게 구현할 수 있게 해줍니다.
// 이를 통해 이메일 및 비밀번호 인증, 소셜 미디어 로그인, 전화번호 인증 등 다양한 인증 방법을 애플리케이션에 통합할 수 있습니다.
import 'package:firebase_auth/firebase_auth.dart';
// Riverpod는 Flutter 애플리케이션에서 상태 관리를 위한 현대적인 라이브러리입니다.
// 이 라이브러리는 애플리케이션 전반의 상태를 효과적으로 관리할 수 있도록 도와주며,
// 상태 변경에 따라 자동으로 UI를 업데이트하도록 설정할 수 있습니다.
// Riverpod는 Provider 패키지를 발전시킨 것으로, 더욱 강력하고 유연한 상태 관리 기능을 제공합니다.
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