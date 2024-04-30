
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore 라이브러리의 임포트
import '../model/product_model.dart'; // ProductContent 모델 정의 파일의 임포트

// Firestore 데이터베이스로부터 상품 정보를 조회하는 기능을 제공하는 클래스
class ProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  ProductRepository(this.firestore);

  // 주어진 문서 ID를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String docId) async {
    // Firestore에서 특정 문서 ID를 가진 'item' 컬렉션의 문서를 조회
    final snapshot = await firestore.collection('item').doc(docId).get();
    // 조회된 문서 데이터를 ProductContent 모델로 변환하여 반환
    return ProductContent.fromFirestore(snapshot);
  }
}
