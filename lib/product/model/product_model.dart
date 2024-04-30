
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore 라이브러리를 임포트.

// 상품의 상세 정보를 관리하는 클래스를 정의.
class ProductContent {
  final String docId; // Firestore에서의 문서 ID를 저장하는 필드.
  final String? thumbnail; // 제품의 썸네일 이미지 URL을 저장하는 필드.
  final List<String>? colors; // 제품의 색상 목록을 저장하는 필드.
  final String? briefIntroduction; // 제품의 간단한 소개를 저장하는 필드.
  final String? originalPrice; // 제품의 원래 가격을 저장하는 필드.
  final String? discountPrice; // 제품의 할인 가격을 저장하는 필드.
  final List<Map<String, dynamic>>? colorOptions; // 추가된 색상 옵션을 저장하는 필드.
  final List<String>? sizes; // 제품의 사이즈 옵션을 저장하는 필드.

  // 클래스의 생성자입니다. 모든 필드를 초기화.
  ProductContent({
    required this.docId,
    this.thumbnail,
    this.colors,
    this.briefIntroduction,
    this.originalPrice,
    this.discountPrice,
    this.colorOptions,
    this.sizes,
  });

  // Firestore 문서 스냅샷으로부터 ProductContent 객체를 생성하는 팩토리 생성자.
  factory ProductContent.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // 문서의 데이터를 맵으로 변환.
    List<String> colors = []; // 색상을 저장할 리스트.
    List<Map<String, dynamic>> colorOptions = []; // 색상 옵션을 저장할 리스트.
    List<String> sizes = []; // 사이즈를 저장할 리스트.

    for (int i = 1; i <= 5; i++) { // 5개의 색상 옵션을 반복하여 처리.
      var color = data['clothes_color$i']; // 색상 데이터를 가져옴.
      var colorText = data['color${i}_text']; // 색상의 텍스트 설명을 가져옴.
      if (color is String) { // 색상 데이터가 문자열인 경우
        colors.add(color); // 색상 리스트에 추가.
        if (colorText is String) { // 색상의 텍스트 설명도 문자열인 경우
          colorOptions.add({'text': colorText, 'url': color}); // 색상 옵션 리스트에 추가.
        }
      }
    }

    for (int i = 1; i <= 4; i++) { // 4개의 사이즈 옵션을 반복하여 처리.
      var size = data['clothes_size$i']; // 사이즈 데이터를 가져옴.
      if (size is String) { // 사이즈 데이터가 문자열인 경우
        sizes.add(size); // 사이즈 리스트에 추가.
      }
    }

    // 모든 필드를 사용하여 ProductContent 객체를 생성 및 반환.
    return ProductContent(
      docId: doc.id, // 문서 ID
      thumbnail: data['thumbnails'] as String?, // 썸네일 URL
      colors: colors.isEmpty ? null : colors, // 색상 목록
      colorOptions: colorOptions.isEmpty ? null : colorOptions, // 색상 옵션
      sizes: sizes.isEmpty ? null : sizes, // 사이즈 목록
      briefIntroduction: data['brief_introduction'] as String?, // 제품 소개
      originalPrice: data['original_price'] as String?, // 원래 가격
      discountPrice: data['discount_price'] as String?, // 할인 가격
    );
  }
}
