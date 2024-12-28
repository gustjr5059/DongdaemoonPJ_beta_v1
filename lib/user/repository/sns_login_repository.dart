import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../model/sns_login_model.dart';


// SNSLoginRepository: 실제 FirebaseAuth, Firestore, Apple 로그인 API 등을 다루는 로직
class SNSLoginRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  SNSLoginRepository({
    required this.auth,
    required this.firestore,
  });

  // Apple 로그인 로직
  // 성공 시 AppleSignInResult를 리턴, 실패 시 null
  Future<AppleSignInResult?> signInWithApple() async {
    try {
      // 1. Apple ID 자격 증명 얻기
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // 2. Firebase 인증에 필요한 OAuthCredential 생성
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      // 3. FirebaseAuth로 로그인 시도
      final userCredential = await auth.signInWithCredential(oauthCredential);
      final User? user = userCredential.user;
      if (user == null) {
        return null;
      }

      // 4. Firestore에서 기존 회원 여부 확인
      final userDoc = await firestore
          .collection('users')
          .doc(user.email)
          .get();

      bool isExistingUser = userDoc.exists;

      // 5. 결과 객체 리턴
      return AppleSignInResult(
        userCredential: userCredential,
        isExistingUser: isExistingUser,
        fullName: '',
      );
    } catch (e) {
      rethrow; // 상위(catch)에서 처리
    }
  }
}

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 회원가입 처리
  Future<void> signUpUser({
    required String appleId,
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('사용자 인증 정보가 없습니다.');
      }
      // Firestore 'users' 컬렉션에 문서 생성/업데이트
      final docRef = _firestore.collection('users').doc(appleId);
      await docRef.set({
        'apple_id': appleId,
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
      });
    } catch (e) {
      throw Exception('회원가입에 실패했습니다: ${e.toString()}');
    }
  }
}