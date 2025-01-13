
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/sns_login_and_sign_up_repository.dart';


// SNSLoginRepository Provider인 snsLoginRepositoryProvider
final snsLoginRepositoryProvider = Provider<SNSLoginRepository>((ref) {
  return SNSLoginRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

// 사용자 문서 존재 여부를 확인하는 FutureProvider (앱 실행 시, 로그인 계정으로 users 컬렉션 하위 문서가 존재하는지 유무 체크 -> 없을 시 자동 로그아웃)
final userDocumentExistsProvider = FutureProvider.family<bool, String?>((ref, email) async {
  final userRepository = ref.read(snsLoginRepositoryProvider);
  return await userRepository.checkIfUserDocumentExists(email);
});

// 회원가입 Repository Provider인 snsSignUpInfoRepositoryProvider
final snsSignUpInfoRepositoryProvider = Provider<SnsSignUpInfoRepository>((ref) {
  return SnsSignUpInfoRepository();
});