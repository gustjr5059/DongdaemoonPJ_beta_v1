
// Firebase의 사용자 인증 기능을 제공하는 FirebaseAuth 패키지를 임포트합니다.
// FirebaseAuth는 Firebase 서비스의 일부로, 애플리케이션에 사용자 인증 기능을 쉽게 추가할 수 있도록 해줍니다.
// 이 패키지를 통해 개발자는 이메일 및 비밀번호를 통한 로그인, 소셜 미디어 계정을 통한 로그인,
// 전화번호 인증, 익명 사용자 인증 등 다양한 인증 방식을 구현할 수 있습니다.
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
