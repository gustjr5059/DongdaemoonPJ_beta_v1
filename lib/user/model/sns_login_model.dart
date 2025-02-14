
import 'package:firebase_auth/firebase_auth.dart';


// ----- 애플 로그인 완료 후 결과 정보를 담는 클래스 시작 부분
// Apple 로그인 후, 기존 회원 여부 + UserCredential + fullName 등을 담아 전달하기 위한 구조체
class AppleSignInResultModel {
  final UserCredential userCredential;
  final bool isExistingUser;
  final String? signUpFullName;
  final String? signUpEmail;

  AppleSignInResultModel({
    required this.userCredential,
    required this.isExistingUser,
    this.signUpFullName,
    this.signUpEmail,
  });
}
// ----- 애플 로그인 완료 후 결과 정보를 담는 클래스 끝 부분

// ----- 구글 로그인 완료 후 결과 정보를 담는 클래스 시작 부분
class GoogleSignInResultModel {
  final UserCredential userCredential;
  final bool isExistingUser;
  final String? name;

  GoogleSignInResultModel({
    required this.userCredential,
    required this.isExistingUser,
    this.name,
  });
}
// ----- 구글 로그인 완료 후 결과 정보를 담는 클래스 끝 부분

// ----- 네이버 로그인 완료 후 결과 정보를 담는 클래스 시작 부분
class NaverSignInResultModel {
  final UserCredential userCredential;
  final bool isExistingUser;
  final String? name;
  final String? email;

  NaverSignInResultModel({
    required this.userCredential,
    required this.isExistingUser,
    this.name,
    this.email,
  });
}
// ----- 네이버 로그인 완료 후 결과 정보를 담는 클래스 끝 부분