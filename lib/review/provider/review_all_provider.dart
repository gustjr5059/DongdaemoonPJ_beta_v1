import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../product/layout/product_body_parts_layout.dart';
import '../repository/review_repository.dart';


// Firestore 인스턴스를 사용하여 PrivateReviewRepository를 생성하는 Provider
final privateReviewRepositoryProvider = Provider((ref) => PrivateReviewRepository(firestore: FirebaseFirestore.instance));

// 특정 사용자의 'name' 필드값을 가져오는 Provider
final userNameProvider = FutureProvider.family<String, String>((ref, email) async { // email을 입력으로 받아 사용자의 이름을 제공하는 FutureProvider 선언
  final repository = ref.read(privateReviewRepositoryProvider); // reviewRepositoryProvider를 통해 Repository 인스턴스를 가져옴
  return await repository.fetchUserNameByEmail(email); // 이메일을 사용하여 사용자 이름을 비동기적으로 가져옴
});

// 리뷰 데이터를 파이어스토어에 저장하는 함수 호출을 위한 Provider
final submitPrivateReviewProvider = Provider((ref) {  // 리뷰 제출 기능을 제공하는 프로바이더를 생성함
  final repository = ref.read(privateReviewRepositoryProvider);  // 리뷰 저장소 프로바이더를 읽어옴
  return repository.submitReview;  // 저장소의 리뷰 제출 함수를 반환함
});

// 특정 상품에 대한 리뷰 데이터를 제공하는 Provider 정의
final productReviewProvider = FutureProvider.family<List<ProductReviewContents>, String>((ref, productId) async {
  // 디버깅 목적으로, 특정 상품 ID에 대한 리뷰를 가져오는 작업이 시작되었음을 출력함
  print("Provider: Fetching reviews for product ID: $productId");

  // 리뷰 저장소(repository)를 참조함
  final repository = ref.read(privateReviewRepositoryProvider);
  // 해당 저장소에서 특정 상품 ID에 대한 리뷰를 비동기로 가져옴
  final reviews = await repository.fetchProductReviews(productId);

  // 디버깅 목적으로, 가져온 리뷰의 개수를 출력함
  print("Provider: Fetched ${reviews.length} reviews for product ID: $productId");

  // 가져온 리뷰 리스트를 반환함
  return reviews;
});
