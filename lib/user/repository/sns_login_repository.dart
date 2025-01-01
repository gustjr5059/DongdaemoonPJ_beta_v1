import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../model/sns_login_model.dart';


// ----- SNSLoginRepository: 실제 FirebaseAuth, Firestore, Apple 로그인 API 등을 다루는 로직 시작 부분
// --- SNS 로그인 레퍼지토리 클래스 시작 부분
// FirebaseAuth와 Firestore를 활용하여 SNS 로그인을 처리하는 클래스
class SNSLoginRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  SNSLoginRepository({
    required this.auth,
    required this.firestore,
  });

  // --- Apple 로그인 처리 함수 시작 부분
  // Apple ID를 사용해 로그인 처리함
  // 성공 시 AppleSignInResult를 반환하며, 실패 시 null을 반환함
  Future<AppleSignInResultModel?> signInWithApple() async {
    try {
      print('Apple 로그인 시작. Apple ID 자격 증명 요청 중.');
      // 1. Apple ID 자격 증명을 얻음
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print('Apple ID 자격 증명 획득 성공. Firebase 인증 정보 생성 중.');
      // 2. Firebase 인증에 필요한 OAuthCredential을 생성함
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      print('Firebase 인증 정보로 로그인 요청 중.');
      // 3. FirebaseAuth를 사용해 로그인 시도함
      final userCredential = await auth.signInWithCredential(oauthCredential);
      final User? user = userCredential.user;
      if (user == null) {
        print('Apple 로그인 실패. 사용자 정보 없음.');
        return null; // 로그인 실패 시 null 반환
      }

      print('Firebase 로그인 성공. Firestore에서 회원 여부 확인 중.');
      // 4. Firestore에서 기존 회원 여부를 확인함
      final userDoc = await firestore
          .collection('users')
          .doc(user.email)
          .get();

      bool isExistingUser = userDoc.exists;
      print('회원 여부 확인 완료. 기존 회원 여부: $isExistingUser');

      // 5. 결과 객체 반환함
      return AppleSignInResultModel(
        userCredential: userCredential,
        isExistingUser: isExistingUser,
      );
    } catch (e) {
      print('Apple 로그인 중 오류 발생: $e');
      throw Exception('Apple 로그인 중 오류 발생: ${e.toString()}'); // 디버깅용 메시지
    }
  }

  // --- Google 로그인 처리 함수 시작 부분
  // Google ID를 사용해 로그인 처리함
  // 성공 시 GoogleSignInResult를 반환하며, 실패 시 null을 반환함
  Future<GoogleSignInResultModel?> signInWithGoogle() async {
    try {
      print('Google 로그인 시작. Google Sign-In 요청 중.');
      // 1. Google 로그인 객체를 생성함
      final googleSignIn = GoogleSignIn();

      // 기존 세션 로그아웃 (구글 로그인 버튼 클릭할 때마다 구글 계정 선택 화면이 나오도록 로그아웃하도록 함)
      await googleSignIn.signOut();
      print('기존 Google 로그인 세션 초기화 완료.');

      // 2. Google 로그인 프로세스를 실행하여 계정을 얻음
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print('Google 로그인 취소됨.');
        return null; // 사용자가 로그인 취소 시 null 반환
      }

      print('Google 계정 정보 획득 성공. 인증 정보 요청 중.');
      // 3. Google 인증 정보를 획득함
      final googleAuth = await googleUser.authentication;

      print('Firebase 인증 정보로 Google 로그인 요청 중.');
      // 4. FirebaseAuth에서 Credential을 생성 후 로그인함
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await auth.signInWithCredential(credential);

      // 5. Firestore에서 기존 회원 여부를 확인함
      final user = userCredential.user;
      if (user == null) {
        print('Google 로그인 실패. 사용자 정보 없음.');
        return null;
      }

      print('Firebase 로그인 성공. Firestore에서 회원 여부 확인 중.');
      final userDoc = await firestore.collection('users').doc(user.email).get();
      bool isExistingUser = userDoc.exists;
      print('회원 여부 확인 완료. 기존 회원 여부: $isExistingUser');

      // 6. 결과 객체 반환함
      return GoogleSignInResultModel(
        userCredential: userCredential,
        isExistingUser: isExistingUser,
      );
    } catch (e) {
      print('Google 로그인 중 오류 발생: $e');
      throw Exception('Google 로그인 중 오류 발생: ${e.toString()}'); // 디버깅용 메시지
    }
  }
}
// ----- SNSLoginRepository: 실제 FirebaseAuth, Firestore, Apple 로그인 API 등을 다루는 로직 끝 부분

// ----- 회원가입 관련 정보 처리를 다루는 레퍼지토리인 SignUpInfoRepository 로직 시작 부분
// --- 회원가입 정보 레퍼지토리 클래스 시작 부분
// Firestore에 회원 정보를 저장하는 로직을 처리하는 클래스
class SignUpInfoRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- 회원가입 처리 함수 시작 부분
  // SNS를 통해 얻은 사용자 정보를 Firestore에 저장함
  Future<void> signUpUser({
    required String snsType, // SNS 유형 (애플 또는 구글)
    required String snsId, // SNS에서 제공한 사용자 ID
    required String name, // 사용자 이름
    required String email, // 사용자 이메일
    required String phoneNumber, // 사용자 전화번호
  }) async {
    try {
      print('회원가입 요청 시작. Firebase 사용자 인증 정보 확인 중.');
      // 1. 현재 Firebase 사용자 인증 정보를 확인함
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        print('회원가입 실패. 사용자 인증 정보 없음.');
        throw Exception('사용자 인증 정보가 없습니다.'); // 디버깅용 메시지
      }

      print('Firestore에 회원 정보 저장 중.');
      // 2. Firestore의 'users' 컬렉션에 사용자 문서를 생성하거나 업데이트함
      final docRef = _firestore.collection('users').doc(snsId);
      await docRef.set({
        'sns_type': snsType, // SNS 유형 ('apple' 또는 'google')
        'registration_id': snsId, // SNS 사용자 ID
        'name': name, // 사용자 이름
        'email': email, // 사용자 이메일
        'phone_number': phoneNumber, // 사용자 전화번호
      });
      print('회원 정보 저장 완료.');
    } catch (e) {
      print('회원가입 중 오류 발생: $e');
      throw Exception('회원가입에 실패했습니다: ${e.toString()}'); // 디버깅용 메시지
    }
  }
}
// ----- 회원가입 관련 정보 처리를 다루는 레퍼지토리인 SignUpInfoRepository 로직 끝 부분