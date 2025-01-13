
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


// ----- 회원가입 관련 정보 처리를 다루는 레퍼지토리인 EmailSignUpInfoRepository 로직 시작 부분
// --- 회원가입 정보 레퍼지토리 클래스 시작 부분
// Firestore에 회원 정보를 저장하는 로직을 처리하는 클래스
class EmailSignUpInfoRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- 회원가입 처리 함수 시작 부분
  // SNS를 통해 얻은 사용자 정보를 Firestore에 저장함
  Future<void> signUpUser({
    required String name, // 사용자 이름
    required String email, // 사용자 아이디(이메일)
    required String phoneNumber, // 사용자 전화번호
    required String password, // 사용자 비밀번호
  }) async {
    try {
      print('회원가입 요청 시작. Firebase Authentication에 사용자 등록을 시도합니다.');

      // 1. Firebase Authentication으로 사용자 계정 생성
      UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 회원가입에 성공하면 FirebaseAuth에서 해당 사용자 객체를 반환
      final User? user = userCredential.user;
      if (user == null) {
        print('회원가입 실패. 사용자 인증 정보 없음.');
        throw Exception('사용자 인증 정보가 없습니다.'); // 디버깅용 메시지
      }

      print('Firebase Authentication 회원가입 성공. user UID: ${user.uid}');

      // 2. Firestore의 'users' 컬렉션에 사용자 정보 저장
      //    문서 ID: 이메일 (문서 이름 = email)
      final docRef = _firestore.collection('users').doc(email);
      await docRef.set({
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        // // 필요에 따라 가입일, 회원 상태 등의 추가 정보를 넣을 수 있습니다.
        // 'created_at': FieldValue.serverTimestamp(),
      });
      print('Firestore에 회원 정보 저장 완료.');
    } catch (e) {
      print('회원가입 중 오류 발생: $e');
      throw Exception('회원가입에 실패했습니다: ${e.toString()}');
    }
  }
}
// ----- 회원가입 관련 정보 처리를 다루는 레퍼지토리인 EmailSignUpInfoRepository 로직 끝 부분