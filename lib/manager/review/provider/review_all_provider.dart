import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/review_repository.dart';

// Firebase Firestore 인스턴스를 사용하여 ReviewRepository를 생성하는 Provider
final adminReviewRepositoryProvider = Provider((ref) => AdminReviewRepository(firestore: FirebaseFirestore.instance));
// Firebase Firestore 인스턴스를 이용하여 AdminReviewRepository 객체를 생성함. 
// 이 Provider는 다른 Provider에서 사용됨.


// 모든 사용자 이메일을 가져오는 FutureProvider
final adminUsersEmailProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.read(adminReviewRepositoryProvider);
  return await repository.fetchAllUserEmails();
});
// Firestore에서 모든 사용자 이메일을 가져오는 FutureProvider임.
// 이 Provider는 비동기적으로 데이터를 가져오며, 
// AdminReviewRepository의 fetchAllUserEmails() 함수를 호출하여 이메일 목록을 반환함.