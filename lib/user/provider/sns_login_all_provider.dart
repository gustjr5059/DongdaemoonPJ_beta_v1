
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/sns_login_repository.dart';


// SNSLoginRepository Provider인 snsLoginRepositoryProvider
final snsLoginRepositoryProvider = Provider<SNSLoginRepository>((ref) {
  return SNSLoginRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

// 회원가입 Repository Provider인 signUpInfoRepositoryProvider
final signUpInfoRepositoryProvider = Provider<SignUpInfoRepository>((ref) {
  return SignUpInfoRepository();
});