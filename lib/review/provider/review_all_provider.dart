import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/review_repository.dart';

// ReviewScreenTab enum 정의
enum ReviewScreenTab { create, list }

// Firestore 인스턴스를 사용하여 ReviewRepository를 생성하는 Provider
final reviewRepositoryProvider = Provider((ref) => ReviewRepository(firestore: FirebaseFirestore.instance));

// 특정 사용자의 발주 데이터를 가져오는 Provider
final reviewUserOrdersProvider = FutureProvider.family((ref, String userEmail) async {
  // reviewRepositoryProvider를 읽어서 ReviewRepository 인스턴스를 가져옴
  final repository = ref.read(reviewRepositoryProvider);
  // fetchOrdersByEmail 함수를 호출하여 특정 사용자의 발주 데이터를 가져옴
  return await repository.fetchOrdersByEmail(userEmail);
});

// 특정 사용자의 'name' 필드값을 가져오는 Provider
final userNameProvider = FutureProvider.family<String, String>((ref, email) async { // email을 입력으로 받아 사용자의 이름을 제공하는 FutureProvider 선언
  final repository = ref.read(reviewRepositoryProvider); // reviewRepositoryProvider를 통해 Repository 인스턴스를 가져옴
  return await repository.fetchUserNameByEmail(email); // 이메일을 사용하여 사용자 이름을 비동기적으로 가져옴
});

// 리뷰 데이터를 파이어스토어에 저장하는 함수 호출을 위한 Provider
final submitReviewProvider = Provider((ref) {  // 리뷰 제출 기능을 제공하는 프로바이더를 생성함
  final repository = ref.read(reviewRepositoryProvider);  // 리뷰 저장소 프로바이더를 읽어옴
  return repository.submitReview;  // 저장소의 리뷰 제출 함수를 반환함
});