
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/sns_login_repository.dart';


// SNSLoginRepository Provider
final snsLoginRepositoryProvider = Provider<SNSLoginRepository>((ref) {
  return SNSLoginRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

// 회원가입 Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});