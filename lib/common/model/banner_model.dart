// 'CommonBannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class CommonBannerImage {
  // 'imageUrl'은 배너 이미지의 URL을 저장하는 변수로, String 타입임.
  // 'final' 키워드는 이 변수가 초기화 이후 변경될 수 없음을 의미함.
  final String imageUrl;

  // 생성자에서 'imageUrl'을 필수로 받기 위해 'required' 키워드를 사용함.
  // 이는 호출 시 imageUrl 인자를 반드시 제공해야 함을 강제함.
  CommonBannerImage({required this.imageUrl});

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'CommonBannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory CommonBannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'CommonBannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return CommonBannerImage(imageUrl: json['imageUrl']);
  }
}

// 'AllLargeBannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'AllLargeBannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class AllLargeBannerImage extends CommonBannerImage {

  // URL을 저장할 url 필드를 nullable로 선언.
  final String? url;
  // product_id를 저장할 productId 필드를 nullable(AllLargeBannerImage 클래스를 재사용하는 곳에서 해당 변수값이 선택적으로 있어도 되도록 하는 방법)로 선언.
  final String? productId;
  // category를 저장할 category 필드를 nullable로 선언.
  final String? category;
  // subCategory를 저장할 subCategory 필드를 nullable로 선언.
  final String? subCategory;

  AllLargeBannerImage({required String imageUrl, this.url, this.productId, this.category, this.subCategory,}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'AllLargeBannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory AllLargeBannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl', 'url', 'productId', 'category' 키의 값을 읽어서 새로운 'AllLargeBannerImage' 객체를 생성.
    // url, productId, category 필드는 nullable로 설정하여, 값이 없을 경우 null로 처리.
    return AllLargeBannerImage(imageUrl: json['imageUrl'], url: json['url'] as String?, productId: json['productId'] as String?, category: json['category'] as String?, subCategory: json['subCategory'] as String?,);
  }
}

// 'AllSmallBannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'AllSmallBannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class AllSmallBannerImage extends CommonBannerImage {

  // URL을 저장할 url 필드를 nullable로 선언.
  final String? url;
  // product_id를 저장할 productId 필드를 nullable(AllSmallBannerImage 클래스를 재사용하는 곳에서 해당 변수값이 선택적으로 있어도 되도록 하는 방법)로 선언.
  final String? productId;
  // category를 저장할 category 필드를 nullable로 선언.
  final String? category;

  AllSmallBannerImage({required String imageUrl, this.url, this.productId, this.category,}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'AllSmallBannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory AllSmallBannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl', 'url', 'productId', 키의 값을 읽어서 새로운 'AllSmallBannerImage' 객체를 생성.
    // url, productId, category 필드는 nullable로 설정하여, 값이 없을 경우 null로 처리.
    return AllSmallBannerImage(imageUrl: json['imageUrl'], url: json['url'] as String?, productId: json['productId'] as String?, category: json['category'] as String?,);
  }
}