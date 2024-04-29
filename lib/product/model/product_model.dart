import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore 라이브러리의 임포트

// 상품의 상세 정보를 관리하는 클래스 정의
class ProductContent {
  final String docId; // 문서 ID
  final String? thumbnail; // 썸네일 이미지 URL
  final List<String>? colors; // 제품 색상 목록
  final String? briefIntroduction; // 제품의 간단한 소개
  final String? originalPrice; // 원래 가격
  final String? discountPrice; // 할인 가격

  // 생성자에서 모든 필드를 초기화
  ProductContent({
    required this.docId,
    this.thumbnail,
    this.colors,
    this.briefIntroduction,
    this.originalPrice,
    this.discountPrice,
  });

  // Firestore 문서 스냅샷으로부터 ProductContent 객체를 생성하는 팩토리 생성자
  factory ProductContent.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // 문서의 데이터를 맵 형태로 가져옴
    List<String> colors = []; // 색상을 저장할 리스트 초기화
    for (int i = 1; i <= 5; i++) { // 최대 5개의 색상 정보를 파싱
      var color = data['clothes_color$i']; // 각 색상 필드의 데이터를 가져옴
      if (color is String) { // 색상 값이 문자열 타입인 경우 리스트에 추가
        colors.add(color);
      }
    }
    // 모든 필드를 사용하여 ProductContent 객체를 생성 및 반환
    return ProductContent(
      docId: doc.id,
      thumbnail: data['thumbnails'] as String?, // 썸네일 URL 추출
      colors: colors.isEmpty ? null : colors, // 색상 목록이 비어있는 경우 null로 설정
      briefIntroduction: data['brief_introduction'] as String?, // 간단한 소개 추출
      originalPrice: data['original_price'] as String?, // 원래 가격 추출
      discountPrice: data['discount_price'] as String?, // 할인 가격 추출
    );
  }
}
