
// 'LargeBannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class LargeBannerImage {
  // 'imageUrl'은 배너 이미지의 URL을 저장하는 변수로, String 타입임.
  // 'final' 키워드는 이 변수가 초기화 이후 변경될 수 없음을 의미함.
  final String imageUrl;

  // 생성자에서 'imageUrl'을 필수로 받기 위해 'required' 키워드를 사용함.
  // 이는 호출 시 imageUrl 인자를 반드시 제공해야 함을 강제함.
  LargeBannerImage({required this.imageUrl});

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'LargeBannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory LargeBannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'LargeBannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return LargeBannerImage(imageUrl: json['imageUrl']);
  }
}


// 'Small1BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class Small1BannerImage {
  // 'imageUrl'은 배너 이미지의 URL을 저장하는 변수로, String 타입임.
  // 'final' 키워드는 이 변수가 초기화 이후 변경될 수 없음을 의미함.
  final String imageUrl;

  // 생성자에서 'imageUrl'을 필수로 받기 위해 'required' 키워드를 사용함.
  // 이는 호출 시 imageUrl 인자를 반드시 제공해야 함을 강제함.
  Small1BannerImage({required this.imageUrl});

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'Small1BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory Small1BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'Small1BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return Small1BannerImage(imageUrl: json['imageUrl']);
  }
}


// 'Small2BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class Small2BannerImage {
  // 'imageUrl'은 배너 이미지의 URL을 저장하는 변수로, String 타입임.
  // 'final' 키워드는 이 변수가 초기화 이후 변경될 수 없음을 의미함.
  final String imageUrl;

  // 생성자에서 'imageUrl'을 필수로 받기 위해 'required' 키워드를 사용함.
  // 이는 호출 시 imageUrl 인자를 반드시 제공해야 함을 강제함.
  Small2BannerImage({required this.imageUrl});

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'Small2BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory Small2BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'Small2BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return Small2BannerImage(imageUrl: json['imageUrl']);
  }
}


// 'Small3BannerImage' 클래스는 배너 이미지의 URL을 저장하기 위한 모델 클래스.
class Small3BannerImage {
  // 'imageUrl'은 배너 이미지의 URL을 저장하는 변수로, String 타입임.
  // 'final' 키워드는 이 변수가 초기화 이후 변경될 수 없음을 의미함.
  final String imageUrl;

  // 생성자에서 'imageUrl'을 필수로 받기 위해 'required' 키워드를 사용함.
  // 이는 호출 시 imageUrl 인자를 반드시 제공해야 함을 강제함.
  Small3BannerImage({required this.imageUrl});

  // 'fromJson' 팩토리 생성자는 JSON 형태의 맵에서 데이터를 읽어 'Small3BannerImage' 인스턴스를 생성함.
  // 이 생성자는 데이터를 외부 API나 데이터베이스로부터 받아 객체로 변환할 때 유용함.
  factory Small3BannerImage.fromJson(Map<String, dynamic> json) {
    // JSON 맵에서 'imageUrl' 키에 해당하는 값을 읽어서 새 'Small3BannerImage' 객체를 생성함.
    // 객체 생성 시, 'imageUrl' 파라미터에 JSON의 'imageUrl' 값을 할당함.
    return Small3BannerImage(imageUrl: json['imageUrl']);
  }
}
