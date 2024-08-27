import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/review_repository.dart';

// Firebase Firestore 인스턴스를 사용하여 ReviewRepository를 생성하는 Provider
final reviewRepositoryProvider = Provider((ref) => AdminReviewRepository(firestore: FirebaseFirestore.instance));
// Firebase Firestore 인스턴스를 이용하여 AdminReviewRepository 객체를 생성함. 
// 이 Provider는 다른 Provider에서 사용됨.


// 모든 사용자 이메일을 가져오는 FutureProvider
final adminUsersEmailProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.read(reviewRepositoryProvider);
  return await repository.fetchAllUserEmails();
});
// Firestore에서 모든 사용자 이메일을 가져오는 FutureProvider임.
// 이 Provider는 비동기적으로 데이터를 가져오며, 
// AdminReviewRepository의 fetchAllUserEmails() 함수를 호출하여 이메일 목록을 반환함.


// 선택된 사용자의 리뷰 데이터를 실시간으로 가져오는 StreamProvider
final adminReviewListProvider = StreamProvider.family<List<Map<String, dynamic>>, String?>((ref, userEmail) {
  if (userEmail == null) return Stream.value([]); // 이메일이 선택되지 않은 경우 빈 리스트 반환
  final repository = ref.read(reviewRepositoryProvider);
  return repository.streamAllReviewsByEmail(userEmail);
});
// 특정 사용자의 리뷰 데이터를 실시간으로 가져오는 StreamProvider임.
// 이 Provider는 사용자의 이메일을 매개변수로 받아, 
// 이메일이 null인 경우 빈 스트림을 반환하고, 
// 그렇지 않은 경우 AdminReviewRepository의 streamAllReviewsByEmail() 함수를 호출하여 리뷰 데이터를 스트리밍함.


// 리뷰 삭제를 위한 FutureProvider
final adminDeleteReviewProvider = FutureProvider.family<void, Map<String, String>>((ref, params) async {
  final repository = ref.read(reviewRepositoryProvider);
  final userEmail = params['userEmail']!;
  final separatorKey = params['separatorKey']!;

  await repository.deleteReview(userEmail: userEmail, separatorKey: separatorKey);
});
// 특정 리뷰를 삭제하기 위한 FutureProvider임.
// 이 Provider는 사용자 이메일과 리뷰의 고유 키를 매개변수로 받아, 
// AdminReviewRepository의 deleteReview() 함수를 호출하여 해당 리뷰를 삭제함.