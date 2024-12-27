
import 'package:firebase_auth/firebase_auth.dart';


// Apple 로그인 후, 기존 회원 여부 + UserCredential + fullName 등을 담아 전달하기 위한 구조체
class AppleSignInResult {
  final UserCredential userCredential;
  final bool isExistingUser;
  final String fullName;

  AppleSignInResult({
    required this.userCredential,
    required this.isExistingUser,
    required this.fullName,
  });
}