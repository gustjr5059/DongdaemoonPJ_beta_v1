
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
// import 'package:flutter_naver_login/interface/types/naver_login_result.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../model/sns_login_model.dart';


// ----- SNSLoginRepository: 실제 FirebaseAuth, Firestore, Apple 로그인 API, 구글 로그인 API, 네이버 로그인 API 등을 다루는 로직 시작 부분
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
      // 사용자가 로그인 창을 취소했을 시, 로그인 실패 에러 메시지가 나오는 이슈 해결 포인트!!
    } on SignInWithAppleAuthorizationException catch (e) {
      // 사용자가 로그인 창을 취소했을 경우 (canceled 상태)
      if (e.code == AuthorizationErrorCode.canceled) {
        print('Apple 로그인 취소됨.');
        return null; // 단순히 null 반환, 추가 처리 없음
      }
      // 다른 에러는 처리
      print('Apple 로그인 중 오류 발생: $e');
      throw Exception('Apple 로그인 중 오류 발생: ${e.toString()}');
    } catch (e) {
      print('Apple 로그인 중 예상치 못한 오류 발생: $e');
      throw Exception('Apple 로그인 중 오류 발생: ${e.toString()}');
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

      // 2. Google 로그인 프로세스 실행
      final googleUser = await googleSignIn.signIn();
      // 로그인 취소 처리
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

  // Firestore 'users' 컬렉션에서 사용자 문서를 조회 (앱 실행 시, 로그인 계정으로 users 컬렉션 하위 문서가 존재하는지 유무 체크 -> 없을 시 자동 로그아웃)
  Future<bool> checkIfUserDocumentExists(String? email) async {
    if (email == null) return false; // 이메일이 null인 경우 false 반환
    try {
      final userDoc = await firestore.collection('users').doc(email).get();
      return userDoc.exists; // 문서가 존재하면 true 반환
    } catch (e) {
      print('Firestore 사용자 문서 조회 중 오류 발생: $e');
      return false; // 오류 발생 시 false 반환
    }
  }

// ——— 네이버 로그인 처리 함수 시작 부분
  Future<NaverSignInResultModel?> signInWithNaver() async {
    try {
      print('네이버 로그인 시작.'); // 네이버 로그인을 시작한다는 디버그 메시지 출력

      // 네이버 로그인 실행
      NaverLoginResult loginResult = await FlutterNaverLogin
          .logIn(); // 네이버 로그인 호출

      // 로그인이 정상적으로 된 경우
      if (loginResult.status == NaverLoginStatus.loggedIn) { // 로그인 상태 확인
        // 1) 액세스 토큰 획득
        // await FlutterNaverLogin.logIn();  // 네이버 로그인 시도
        NaverAccessToken token = await FlutterNaverLogin
            .currentAccessToken; // 네이버 액세스 토큰 가져오기
        final String accessToken = token.accessToken; // 액세스 토큰 문자열로 저장

        print('네이버 계정으로 로그인 성공 ${token.accessToken}'); // 성공 메시지 출력

        // 2) Firebase Functions 호출하여 커스텀 토큰 생성
        final functions = FirebaseFunctions.instanceFor(
            region: 'asia-northeast3'); // Firebase Functions 인스턴스 생성
        final naverCustomToken = await functions
            .httpsCallable('createNaverCustomToken_V2')
            .call(
            {'naverAccessToken': accessToken}); // Functions 호출 및 커스텀 토큰 생성

        print('커스텀 토큰 생성 성공. Firebase 인증 요청 중.'); // 토큰 생성 성공 메시지 출력

        // 3) Firebase 인증
        final userCredential = await auth.signInWithCustomToken(
            naverCustomToken.data['customToken']); // 커스텀 토큰을 사용한 Firebase 인증

        // 4) Firestore에서 기존 회원 여부 확인
        final user = userCredential.user; // Firebase 사용자 정보 가져오기
        if (user == null) { // 사용자 정보가 없는 경우
          print('Firebase 사용자 정보 없음.'); // 오류 메시지 출력
          return null; // null 반환
        }

        print(
            'Firestore에서 UID 기반 기존 회원 여부 확인 중.'); // Firestore에서 기존 회원 여부 확인 메시지 출력
        final userDoc = await firestore
            .collection('users')
            .doc('${user.uid}') // 사용자 UID로 문서명 저장
            .get(); // Firestore 문서 조회

        bool isExistingUser = userDoc.exists; // 기존 회원 여부 확인
        print('기존 회원 여부 확인 완료: $isExistingUser'); // 결과 출력

        return NaverSignInResultModel(
          userCredential: userCredential, // 사용자 인증 정보
          isExistingUser: isExistingUser, // 기존 회원 여부
        );
      }
      // 로그인이 아닌 다른 status(canceled, error 등)인 경우
      else {
        print('네이버 로그인 실패(혹은 취소) 상태입니다. status: ${loginResult
            .status}'); // 실패 또는 취소 상태 메시지 출력
        return null; // null 반환
      }
    } catch (e) {
      print('네이버 로그인 중 오류 발생: $e'); // 오류 발생 메시지 출력
      throw Exception('네이버 로그인 중 오류 발생: $e'); // 예외 발생
    }
  }
}
// ——— SNSLoginRepository: 실제 FirebaseAuth, Firestore, Apple 로그인 API, 구글 로그인 API, 네이버 로그인 API 등을 다루는 로직 끝 부분

// ----- 회원가입 관련 정보 처리를 다루는 레퍼지토리인 SnsSignUpInfoRepository 로직 시작 부분
// --- 회원가입 정보 레퍼지토리 클래스 시작 부분
// Firestore에 회원 정보를 저장하는 로직을 처리하는 클래스
class SnsSignUpInfoRepository {
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
      final docRef = _firestore.collection('users').doc(snsId);  // UID형태를 문서명으로 저장
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
// ----- 회원가입 관련 정보 처리를 다루는 레퍼지토리인 SnsSignUpInfoRepository 로직 끝 부분