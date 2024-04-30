
// Firestore의 'Product' 데이터와 상호작용하는 클래스와 프로바이더 설정
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore를 사용하기 위한 라이브러리의 임포트
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리 라이브러리 Riverpod를 사용하기 위한 임포트
import '../model/product_model.dart'; // 상품 데이터 모델 정의 파일의 임포트
import '../repository/product_repository.dart'; // 상품 데이터를 Firestore에서 가져오는 로직이 구현된 레포지토리 클래스의 임포트

// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ProductRepository 객체를 생성
  return ProductRepository(FirebaseFirestore.instance);
});

// 특정 문서 ID를 사용하여 Firestore로부터 상품 데이터를 비동기적으로 가져오는 FutureProvider
final prodFirestoreDataProvider = FutureProvider.family<ProductContent, String>((ref, docId) async {
  // 상품 레포지토리 프로바이더를 통해 생성된 레포지토리 객체의 참조를 얻음
  final repository = ref.watch(productRepositoryProvider);
  // 레포지토리의 getProduct 메소드를 사용하여 특정 문서 ID에 해당하는 상품 정보를 가져옴
  return repository.getProduct(docId);
});
