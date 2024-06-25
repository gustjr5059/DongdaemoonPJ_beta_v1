import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore 라이브러리를 임포트함.

// 상품의 상세 정보를 관리하는 클래스.
class ProductContent {
  final String docId; // Firestore에서의 문서 ID를 저장하는 필드.
  final String? thumbnail; // 제품의 썸네일 이미지 URL을 저장하는 필드.
  final List<String>? colors; // 제품의 색상 목록을 저장하는 필드.
  final String? briefIntroduction; // 제품의 간단한 소개를 저장하는 필드.
  final double? originalPrice; // 제품의 원래 가격을 저장하는 필드.
  final double? discountPrice; // 제품의 할인 가격을 저장하는 필드.
  final double? discountPercent; // 제품의 할인율을 저장하는 필드.
  final List<Map<String, dynamic>>? colorOptions; // 추가된 색상 옵션을 저장하는 필드.
  final List<String>? sizes; // 제품의 사이즈 옵션을 저장하는 필드.
  final DocumentSnapshot?
      documentSnapshot; // 홈 화면 내 섹션에서 데이터 불러올 때, 4개 단위로 분할하여 가져오기 위해 필요한 필드.

  // 클래스의 생성자입니다. 모든 필드를 초기화함.
  ProductContent({
    required this.docId,
    this.thumbnail,
    this.colors,
    this.briefIntroduction,
    this.originalPrice,
    this.discountPrice,
    this.discountPercent,
    this.colorOptions,
    this.sizes,
    this.documentSnapshot,
  });

  // Firestore 문서 스냅샷으로부터 ProductContent 객체를 생성하는 팩토리 생성자임.
  factory ProductContent.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data =
        doc.data() as Map<String, dynamic>?; // 문서의 데이터를 맵으로 변환함.
    if (data == null) {
      // 데이터가 null일 경우 기본값을 반환함.
      return ProductContent(
        docId: doc.id,
        thumbnail: null,
        colors: null,
        briefIntroduction: null,
        originalPrice: null,
        discountPrice: null,
        discountPercent: null,
        colorOptions: null,
        sizes: null,
        documentSnapshot: doc,
      );
    }

    // 색상과 색상 옵션을 저장할 리스트를 초기화함.
    List<String> colors = [];
    List<Map<String, dynamic>> colorOptions = [];

    // Firestore에서 최대 5개의 색상 옵션을 가져옴.
    for (int i = 1; i <= 5; i++) {
      var color = data['clothes_color$i'];
      var colorText = data['color${i}_text'];
      if (color is String) {
        colors.add(color); // 색상 데이터를 리스트에 추가함.
        if (colorText is String) {
          colorOptions
              .add({'text': colorText, 'url': color}); // 색상 옵션 데이터를 리스트에 추가함.
        }
      }
    }

    // 사이즈 옵션을 저장할 리스트를 초기화함.
    List<String> sizes = [];

    // Firestore에서 최대 4개의 사이즈 옵션을 가져옴.
    for (int i = 1; i <= 4; i++) {
      var size = data['clothes_size$i'];
      if (size is String) {
        sizes.add(size); // 사이즈 데이터를 리스트에 추가함.
      }
    }

    // 다양한 타입의 데이터를 double로 변환하는 헬퍼 함수.
    double? parseDouble(dynamic value) {
      if (value is double) {
        return value;
      } else if (value is int) {
        return value.toDouble();
      } else if (value is String) {
        return double.tryParse(value);
      }
      return null;
    }

    // 모든 필드를 사용하여 ProductContent 객체를 생성 및 반환함.
    return ProductContent(
      docId: doc.reference.path,
      // 전체 경로를 포함하는 문서 ID.
      thumbnail: data['thumbnails'] as String?,
      // 썸네일 URL.
      colors: colors.isEmpty ? null : colors,
      // 색상 목록.
      colorOptions: colorOptions.isEmpty ? null : colorOptions,
      // 색상 옵션.
      sizes: sizes.isEmpty ? null : sizes,
      // 사이즈 목록.
      briefIntroduction: data['brief_introduction'] as String?,
      // 제품 소개.
      originalPrice: parseDouble(data['original_price']),
      // 원래 가격.
      discountPrice: parseDouble(data['discount_price']),
      // 할인 가격.
      discountPercent: parseDouble(data['discount_percent']),
      // 할인율.
      documentSnapshot: doc, // 문서 스냅샷.
    );
  }
}
