

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

  AllLargeBannerImage({required String imageUrl}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'AllLargeBannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory AllLargeBannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'AllLargeBannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return AllLargeBannerImage(imageUrl: json['imageUrl']);
  }
}

// 'HomeSmall1BannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'HomeSmall1BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class HomeSmall1BannerImage extends CommonBannerImage {

  HomeSmall1BannerImage({required String imageUrl}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'HomeSmall1BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory HomeSmall1BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'HomeSmall1BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return HomeSmall1BannerImage(imageUrl: json['imageUrl']);
  }
}

// 'HomeSmall2BannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'HomeSmall2BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class HomeSmall2BannerImage extends CommonBannerImage {

  HomeSmall2BannerImage({required String imageUrl}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'HomeSmall2BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory HomeSmall2BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'HomeSmall2BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return HomeSmall2BannerImage(imageUrl: json['imageUrl']);
  }
}

// 'HomeSmall3BannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'HomeSmall3BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class HomeSmall3BannerImage extends CommonBannerImage {

  HomeSmall3BannerImage({required String imageUrl}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'HomeSmall3BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory HomeSmall3BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'HomeSmall3BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return HomeSmall3BannerImage(imageUrl: json['imageUrl']);
  }
}

// ----- 각 카테고리 메인 화면 작은 배너 관련 클래스 내용 시작

// 'ShirtMainSmall1BannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'ShirtMainSmall1BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class ShirtMainSmall1BannerImage extends CommonBannerImage {

  ShirtMainSmall1BannerImage({required String imageUrl}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'ShirtMainSmall1BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory ShirtMainSmall1BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'ShirtMainSmall1BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return ShirtMainSmall1BannerImage(imageUrl: json['imageUrl']);
  }
}

// 'BlouseMainSmall1BannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'BlouseMainSmall1BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class BlouseMainSmall1BannerImage extends CommonBannerImage {

  BlouseMainSmall1BannerImage({required String imageUrl}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'BlouseMainSmall1BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory BlouseMainSmall1BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'BlouseMainSmall1BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return BlouseMainSmall1BannerImage(imageUrl: json['imageUrl']);
  }
}

// 'MtmMainSmall1BannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'MtmMainSmall1BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class MtmMainSmall1BannerImage extends CommonBannerImage {

  MtmMainSmall1BannerImage({required String imageUrl}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'MtmMainSmall1BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory MtmMainSmall1BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'MtmMainSmall1BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return MtmMainSmall1BannerImage(imageUrl: json['imageUrl']);
  }
}

// 'NeatMainSmall1BannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'NeatMainSmall1BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class NeatMainSmall1BannerImage extends CommonBannerImage {

  NeatMainSmall1BannerImage({required String imageUrl}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'NeatMainSmall1BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory NeatMainSmall1BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'NeatMainSmall1BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return NeatMainSmall1BannerImage(imageUrl: json['imageUrl']);
  }
}

// 'PolaMainSmall1BannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'PolaMainSmall1BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class PolaMainSmall1BannerImage extends CommonBannerImage {

  PolaMainSmall1BannerImage({required String imageUrl}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'PolaMainSmall1BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory PolaMainSmall1BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'PolaMainSmall1BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return PolaMainSmall1BannerImage(imageUrl: json['imageUrl']);
  }
}

// 'OnepieceMainSmall1BannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'OnepieceMainSmall1BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class OnepieceMainSmall1BannerImage extends CommonBannerImage {

  OnepieceMainSmall1BannerImage({required String imageUrl}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'OnepieceMainSmall1BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory OnepieceMainSmall1BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'OnepieceMainSmall1BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return OnepieceMainSmall1BannerImage(imageUrl: json['imageUrl']);
  }
}

// 'PantsMainSmall1BannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'PantsMainSmall1BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class PantsMainSmall1BannerImage extends CommonBannerImage {

  PantsMainSmall1BannerImage({required String imageUrl}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'PantsMainSmall1BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory PantsMainSmall1BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'PantsMainSmall1BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return PantsMainSmall1BannerImage(imageUrl: json['imageUrl']);
  }
}

// 'JeanMainSmall1BannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'JeanMainSmall1BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class JeanMainSmall1BannerImage extends CommonBannerImage {

  JeanMainSmall1BannerImage({required String imageUrl}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'JeanMainSmall1BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory JeanMainSmall1BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'JeanMainSmall1BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return JeanMainSmall1BannerImage(imageUrl: json['imageUrl']);
  }
}

// 'SkirtMainSmall1BannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'SkirtMainSmall1BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class SkirtMainSmall1BannerImage extends CommonBannerImage {

  SkirtMainSmall1BannerImage({required String imageUrl}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'SkirtMainSmall1BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory SkirtMainSmall1BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'SkirtMainSmall1BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return SkirtMainSmall1BannerImage(imageUrl: json['imageUrl']);
  }
}

// 'PaedingMainSmall1BannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'PaedingMainSmall1BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class PaedingMainSmall1BannerImage extends CommonBannerImage {

  PaedingMainSmall1BannerImage({required String imageUrl}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'PaedingMainSmall1BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory PaedingMainSmall1BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'PaedingMainSmall1BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return PaedingMainSmall1BannerImage(imageUrl: json['imageUrl']);
  }
}

// 'CoatMainSmall1BannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'CoatMainSmall1BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class CoatMainSmall1BannerImage extends CommonBannerImage {

  CoatMainSmall1BannerImage({required String imageUrl}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'CoatMainSmall1BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory CoatMainSmall1BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'CoatMainSmall1BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return CoatMainSmall1BannerImage(imageUrl: json['imageUrl']);
  }
}

// 'CardiganMainSmall1BannerImage' 클래스는 'CommonBannerImage'를 상속받아 배너 이미지의 URL을 저장하기 위한 모델 클래스.
// 'CardiganMainSmall1BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class CardiganMainSmall1BannerImage extends CommonBannerImage {

  CardiganMainSmall1BannerImage({required String imageUrl}) : super(imageUrl: imageUrl);

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'CardiganMainSmall1BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory CardiganMainSmall1BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'CardiganMainSmall1BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return CardiganMainSmall1BannerImage(imageUrl: json['imageUrl']);
  }
}

// ----- 각 카테고리 메인 화면 작은 배너 관련 클래스 내용 끝