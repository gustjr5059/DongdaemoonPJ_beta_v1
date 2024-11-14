// 필요한 패키지와 모듈을 가져옴.
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore를 사용하기 위한 패키지
import '../model/banner_model.dart'; // 배너 이미지 데이터 모델 정의 파일

// ------ CommonBannerRepository 클래스 시작
// 'CommonBannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class CommonBannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  CommonBannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<CommonBannerImage> 타입의 Future를 반환함.
  Future<List<CommonBannerImage>> fetchBannerImages() async {
    print('Firestore에서 공통 배너 이미지를 가져오는 중...'); // Firestore에서 공통 배너 이미지 가져오기 시작 메시지 출력
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재하여 데이터를 처리 중...'); // 문서가 존재할 때 데이터 처리 시작 메시지 출력
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 CommonBannerImage 객체로 변환함.
      return [
        CommonBannerImage.fromJson({'imageUrl': data['commsmallbanner1']}),
        CommonBannerImage.fromJson({'imageUrl': data['commsmallbanner2']}),
        CommonBannerImage.fromJson({'imageUrl': data['commsmallbanner3']}),
        CommonBannerImage.fromJson({'imageUrl': data['commsmallbanner3']}),
        CommonBannerImage.fromJson({'imageUrl': data['commsmallbanner3']})
      ].whereType<CommonBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('공통 배너 이미지를 가져오지 못함: 문서가 존재하지 않음.'); // 문서가 존재하지 않을 때 메시지 출력
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다.');
  }
}
// ------ CommonBannerRepository 클래스 끝

// ------ AllLargeBannerRepository 클래스 시작
// 'AllLargeBannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AllLargeBannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AllLargeBannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllLargeBannerImage> 타입의 Future를 반환함.
  Future<List<AllLargeBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 큰 배너 이미지를 가져오는 중...'); // Firestore에서 큰 배너 이미지 가져오기 시작 메시지 출력
    // 'banners' 컬렉션 내의 'large_banner' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot = await firestore
        .collection('banners')
        .doc('wearcano')
        .collection(bannerId)
        .doc('large_banner')
        .get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재하여 데이터를 처리 중...'); // 문서가 존재할 때 데이터 처리 시작 메시지 출력
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllLargeBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllLargeBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllLargeBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllLargeBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 4를 생성하기 위한 데이터 모델링
        AllLargeBannerImage.fromJson({
          'imageUrl': data['ad_img_4'],  // 이미지 URL로 사용할 데이터 'ad_img_4'
          'url': data['ad_url_3']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 5를 생성하기 위한 데이터 모델링
        AllLargeBannerImage.fromJson({
          'imageUrl': data['ad_img_5'],  // 이미지 URL로 사용할 데이터 'ad_img_5'
          'subCategory': data['sub_category']  // 하위 카테고리 정보 포함
        })
      ].whereType<AllLargeBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('큰 배너 이미지를 가져오지 못함: 문서가 존재하지 않음.'); // 문서가 존재하지 않을 때 메시지 출력
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다.');
  }
}
// ------ AllLargeBannerRepository 클래스 끝

// ------ HomeSmall1BannerRepository 클래스 시작
// 'HomeSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class HomeSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  HomeSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 작은 배너 1 이미지를 가져오는 중...'); // Firestore에서 작은 배너 1 이미지 가져오기 시작 메시지 출력
    // 'banners' 컬렉션 내의 'home_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('home_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재하여 데이터를 처리 중...'); // 문서가 존재할 때 데이터 처리 시작 메시지 출력
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 Small1BannerImage 객체로 변환함.
      return [
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('작은 배너 1 이미지를 가져오지 못함: 문서가 존재하지 않음.'); // 문서가 존재하지 않을 때 메시지 출력
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다.');
  }
}
// ------ HomeSmall1BannerRepository 클래스 끝

// ------ HomeSmall2BannerRepository 클래스 시작
// 'HomeSmall2BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class HomeSmall2BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  HomeSmall2BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 작은 배너 2 이미지를 가져오는 중...'); // Firestore에서 작은 배너 2 이미지 가져오기 시작 메시지 출력
    // 'banners' 컬렉션 내의 'home_small_banner_2' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('home_small_banner_2').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재하여 데이터를 처리 중...'); // 문서가 존재할 때 데이터 처리 시작 메시지 출력
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('작은 배너 2 이미지를 가져오지 못함: 문서가 존재하지 않음.'); // 문서가 존재하지 않을 때 메시지 출력
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다.');
  }
}
// ------ HomeSmall2BannerRepository 클래스 끝

// ------ HomeSmall3BannerRepository 클래스 시작
// 'HomeSmall3BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class HomeSmall3BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  HomeSmall3BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 작은 배너 3 이미지를 가져오는 중...'); // Firestore에서 작은 배너 3 이미지 가져오기 시작 메시지 출력
    // 'banners' 컬렉션 내의 'home_small_banner_3' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('home_small_banner_3').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재하여 데이터를 처리 중...'); // 문서가 존재할 때 데이터 처리 시작 메시지 출력
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('작은 배너 3 이미지를 가져오지 못함: 문서가 존재하지 않음.'); // 문서가 존재하지 않을 때 메시지 출력
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다.');
  }
}
// ------ HomeSmall3BannerRepository 클래스 끝

// -------- 각 카테고리 메인 화면 작은 배너 관련 레퍼지토리 내용 시작
// 'ShirtMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class ShirtMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  ShirtMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 셔츠 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'shirt_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('shirt_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('셔츠 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'BlouseMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class BlouseMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  BlouseMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 블라우스 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'blouse_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('blouse_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('블라우스 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'MtmMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class MtmMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  MtmMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 맨투맨 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'mtm_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('mtm_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('맨투맨 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'NeatMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class NeatMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  NeatMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 니트 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'neat_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('neat_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('니트 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'PolaMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class PolaMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  PolaMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 폴라 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'pola_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('pola_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('폴라티 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'OnepieceMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class OnepieceMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  OnepieceMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 원피스 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'onepiece_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('onepiece_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('원피스 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'PantsMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class PantsMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  PantsMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 바지 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'pants_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('pants_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('바지 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'JeanMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class JeanMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  JeanMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 청바지 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'jean_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('jean_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('청바지 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'SkirtMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class SkirtMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  SkirtMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 스커트 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'skirt_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('skirt_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('스커트 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'PaedingMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class PaedingMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  PaedingMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 패딩 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'paeding_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('paeding_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('패딩 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'CoatMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class CoatMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  CoatMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 코트 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'coat_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('coat_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('코트 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'CardiganMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class CardiganMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  CardiganMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 가디건 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'cardigan_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('cardigan_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('가디건 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}
// -------- 각 카테고리 메인 화면 작은 배너 관련 레퍼지토리 내용 끝

// -------- 마이페이지 메인 화면 작은 배너 관련 레퍼지토리 내용 시작
// 'ProfileMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class ProfileMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  ProfileMainSmall1BannerRepository(this.firestore);

  // ------ 'fetchBannerImagesAndLink' 메서드 시작 부분
  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    // 'Firestore에서 프로필 메인 작은 배너 이미지를 가져오는 중...'이라는 메시지를 출력함.
    print('Firestore에서 프로필 메인 작은 배너 이미지를 가져오는 중...');

    // 'banners' 컬렉션 내의 'profile_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('profile_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      // '문서가 존재합니다. 데이터를 처리하는 중...'이라는 메시지를 출력함.
      print('문서가 존재합니다. 데이터를 처리하는 중...');

      // 문서의 데이터를 Map<String, dynamic> 형태로 변환함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }

    // '프로필 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.'라는 메시지를 출력함.
    print('프로필 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');

    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}
// -------- 마이페이지 메인 화면 작은 배너 관련 레퍼지토리 내용 끝
// -------- 각 카테고리 메인 화면 작은 배너 관련 레퍼지토리 내용 끝

// -------- 각 섹션 더보기 화면 작은 배너 관련 레퍼지토리 내용 시작
// 'NewSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class NewSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  NewSubMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 newSub 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'new_sub_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('new_sub_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('newSub 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'BestSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class BestSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  BestSubMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 bestSub 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'best_sub_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('best_sub_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('bestSub 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'SaleSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class SaleSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  SaleSubMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 saleSub 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'sale_sub_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('sale_sub_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('saleSub 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'SpringSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class SpringSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  SpringSubMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 springSub 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'spring_sub_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('spring_sub_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('springSub 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'SummerSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class SummerSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  SummerSubMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 summerSub 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'summer_sub_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('summer_sub_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('summerSub 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'AutumnSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AutumnSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AutumnSubMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 autumnSub 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'autumn_sub_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('autumn_sub_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('autumnSub 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}

// 'WinterSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class WinterSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  WinterSubMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllSmallBannerImage> 타입의 Future를 반환함.
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink(String bannerId) async {
    print('Firestore에서 winterSub 메인 작은 배너 이미지를 가져오는 중...');
    // 'banners' 컬렉션 내의 'winter_sub_main_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection(bannerId).doc('winter_sub_main_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재합니다. 데이터를 처리하는 중...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllSmallBannerImage 객체로 변환함.
      return [
        // 광고 배너 이미지 1을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'productId': data['product_id'],  // 제품 ID 정보 포함
          'category': data['category']  // 카테고리 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('winterSub 메인 작은 배너 이미지를 가져오지 못했습니다: 문서가 존재하지 않습니다.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다');
  }
}
// -------- 각 섹션 더보기 화면 작은 배너 관련 레퍼지토리 내용 끝