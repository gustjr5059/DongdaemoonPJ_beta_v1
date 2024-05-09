
// Firebase Firestore 라이브러리의 임포트
// Firestore는 Google Firebase 플랫폼의 일부로 제공되는 NoSQL 클라우드 데이터베이스입니다.
// 이 데이터베이스를 사용하면 데이터를 실시간으로 저장하고 동기화할 수 있어서, 멀티 사용자 앱에서 데이터의 일관성을 유지할 수 있습니다.
// Firestore는 문서와 컬렉션으로 데이터를 구성하며, 강력한 쿼리 기능과 실시간 업데이트 기능을 제공합니다.
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore 라이브러리의 임포트
// ProductContent 모델 정의 파일의 임포트
// 이 파일은 애플리케이션에서 사용될 제품 데이터의 구조를 정의하는 클래스를 포함하고 있습니다.
// 제품 모델은 제품의 이름, 가격, 설명, 이미지 URL 등과 같은 속성을 가질 수 있으며,
// Firestore 데이터베이스와의 상호작용을 통해 이러한 데이터를 쉽게 저장하고 검색할 수 있습니다.
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
