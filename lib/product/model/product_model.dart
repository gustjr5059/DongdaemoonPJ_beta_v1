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
  final String? category; // 제품의 카테고리를 저장하는 필드.
  final List<String>? detailPageImages; // 제품의 상세화면 내 이미지를 저장하는 필드.
  final List<String>? detailColorImages; // detail_color_image1 ~ detail_color_image5를 저장하는 필드.
  final String? detailDetailsImage; // detail_details_image1을 저장하는 필드.
  final String? detailFabricImage; // detail_fabric_image1을 저장하는 필드.
  final List<String>? detailIntroImages; // detail_intro_image1 ~ detail_intro_image5를 저장하는 필드.
  final String? detailSizeImage; // detail_size_image1을 저장하는 필드.
  final String? detailWashingImage; // detail_washing_image1을 저장하는 필드.
  final DocumentSnapshot?
      documentSnapshot; // 홈 화면 내 섹션에서 데이터 불러올 때, 4개 단위로 분할하여 가져오기 위해 필요한 필드.
  final int? selectedCount; // 선택된 수량을 저장하는 필드.
  final String? selectedColorImage; // 선택된 색상 이미지를 저장하는 필드.
  final String? selectedColorText; // 선택된 색상 텍스트를 저장하는 필드.
  final String? selectedSize; // 선택된 사이즈를 저장하는 필드.
  final String? productNumber; // 제품 번호를 저장하는 필드.
  final String? eventPosterImg; // 이벤트 포스터 이미지 저장하는 필드.
  final int maxStockQuantity; // maxStockQuantity 필드 추가

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
    this.category,
    this.detailPageImages,
    this.detailColorImages,
    this.detailDetailsImage,
    this.detailFabricImage,
    this.detailIntroImages,
    this.detailSizeImage,
    this.detailWashingImage,
    this.documentSnapshot,
    this.selectedCount,
    this.selectedColorImage,
    this.selectedColorText,
    this.selectedSize,
    this.productNumber,
    this.eventPosterImg,
    this.maxStockQuantity = 10001, // 기본값을 설정하거나 외부에서 전달받은 값을 사용
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
        category: null,
        detailPageImages: null,
        detailColorImages: null,
        detailDetailsImage: null,
        detailFabricImage: null,
        detailIntroImages: null,
        detailSizeImage: null,
        detailWashingImage: null,
        documentSnapshot: doc,
        selectedCount: null,
        selectedColorImage: null,
        selectedColorText: null,
        selectedSize: null,
        productNumber: null,
        eventPosterImg: null,
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

    // 상품 상세 화면 내 이미지 페이지 뷰의 이미지 데이터를 저장할 리스트를 초기화함.
    List<String> detailPageImages = [];
    // Firestore에서 최대 5개의 이미지 옵션을 가져옴.
    for (int i = 1; i <= 5; i++) {
      var imageUrl = data['detail_page_image$i'];
      if (imageUrl is String) {
        detailPageImages.add(imageUrl);
      }
    }

    // 상품 상세 화면 내 상품 정보의 색상 이미지 데이터를 저장할 리스트를 초기화함.
    List<String> detailColorImages = [];
    // Firestore에서 최대 5개의 이미지 옵션을 가져옴.
    for (int i = 1; i <= 5; i++) {
      var imageUrl = data['detail_color_image$i'];
      if (imageUrl is String) {
        detailColorImages.add(imageUrl);
      }
    }

    // 상품 상세 화면 내 상품 정보의 소개 이미지 데이터를 저장할 리스트를 초기화함.
    List<String> detailIntroImages = [];
    // Firestore에서 최대 5개의 이미지 옵션을 가져옴.
    for (int i = 1; i <= 5; i++) {
      var imageUrl = data['detail_intro_image$i'];
      if (imageUrl is String) {
        detailIntroImages.add(imageUrl);
      }
    }

    // 상품 상세 화면 내 상품 정보의 상세정보 이미지 데이터를 저장할 정보를 가져옴.
    var detailDetailsImage = data['detail_details_image1'] as String?;

    // 상품 상세 화면 내 상품 정보의 섬유정보 이미지 데이터를 저장할 정보를 가져옴.
    var detailFabricImage = data['detail_fabric_image1'] as String?;

    // 상품 상세 화면 내 상품 정보의 사이즈 정보 이미지 데이터를 저장할 정보를 가져옴.
    var detailSizeImage = data['detail_size_image1'] as String?;

    // 상품 상세 화면 내 상품 정보의 세탁 정보 이미지 데이터를 저장할 정보를 가져옴.
    var detailWashingImage = data['detail_washing_image1'] as String?;

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
      category: data['category'] as String?,
      // 제품의 카테고리.
      detailPageImages: detailPageImages.isEmpty ? null : detailPageImages,
      // 제품의 상세화면 내 이미지.
      detailColorImages: detailColorImages.isEmpty ? null : detailColorImages,
      // 상세 색상 이미지.
      detailDetailsImage: detailDetailsImage,
      // 상세 설명 이미지.
      detailFabricImage: detailFabricImage,
      // 상세 원단 이미지.
      detailIntroImages: detailIntroImages.isEmpty ? null : detailIntroImages,
      // 상세 소개 이미지.
      detailSizeImage: detailSizeImage,
      // 상세 사이즈 이미지.
      detailWashingImage: detailWashingImage,
      // 상세 세탁 이미지.
      documentSnapshot: doc, // 문서 스냅샷.
      selectedCount: data['selected_count'] as int?, // 선택된 수량
      selectedColorImage: data['selected_color_image'] as String?, // 선택된 색상 이미지
      selectedColorText: data['selected_color_text'] as String?, // 선택된 색상 텍스트
      selectedSize: data['selected_size'] as String?, // 선택된 사이즈
      productNumber: data['product_number'] as String?, // 제품 번호
      eventPosterImg: data['event_poster_img'] as String?, // 이벤트 포스터 이미지
    );
  }

  // ProductContent 객체를 맵으로 변환하는 toMap 메서드
  // 클라이언트 관점의 이메일 보내기 기능 관련 코드
  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'thumbnail': thumbnail,
      'colors': colors,
      'briefIntroduction': briefIntroduction,
      'originalPrice': originalPrice,
      'discountPrice': discountPrice,
      'discountPercent': discountPercent,
      'colorOptions': colorOptions,
      'sizes': sizes,
      'category': category,
      'detailPageImages': detailPageImages,
      'detailColorImages': detailColorImages,
      'detailDetailsImage': detailDetailsImage,
      'detailFabricImage': detailFabricImage,
      'detailIntroImages': detailIntroImages,
      'detailSizeImage': detailSizeImage,
      'detailWashingImage': detailWashingImage,
      'selectedCount': selectedCount,
      'selectedColorImage': selectedColorImage,
      'selectedColorText': selectedColorText,
      'selectedSize': selectedSize,
      'productNumber': productNumber,
    };
  }

  // fromMap 메서드 추가
  factory ProductContent.fromMap(Map<String, dynamic> map) {
    return ProductContent(
      docId: map['docId'] as String,
      category: map['category'] as String,
      productNumber: map['productNumber'] as String,
      thumbnail: map['thumbnail'] as String?,
      briefIntroduction: map['briefIntroduction'] as String?,
      originalPrice: map['originalPrice'] as double?,
      discountPrice: map['discountPrice'] as double?,
      discountPercent: map['discountPercent'] as double?,
      selectedCount: map['selectedCount'] as int?,
      selectedColorImage: map['selectedColorImage'] as String?,
      selectedColorText: map['selectedColorText'] as String?,
      selectedSize: map['selectedSize'] as String?,
    );
  }
}
