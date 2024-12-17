// 필요한 패키지와 모듈을 가져옴.
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore를 사용하기 위한 패키지
import '../../../../common/model/banner_model.dart';


// ------ AamAllLargeBannerRepository 클래스 시작
// 'AamAllLargeBannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamAllLargeBannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamAllLargeBannerRepository(this.firestore);

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
// ------ AamAllLargeBannerRepository 클래스 끝

// -------- 각 카테고리 메인 화면 작은 배너 관련 레퍼지토리 내용 시작
// 'AamShirtMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamShirtMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamShirtMainSmall1BannerRepository(this.firestore);

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

// 'AamBlouseMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamBlouseMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamBlouseMainSmall1BannerRepository(this.firestore);

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

// 'AamMtmMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamMtmMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamMtmMainSmall1BannerRepository(this.firestore);

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

// 'AamNeatMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamNeatMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamNeatMainSmall1BannerRepository(this.firestore);

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

// 'AamPolaMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamPolaMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamPolaMainSmall1BannerRepository(this.firestore);

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

// 'AamOnepieceMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamOnepieceMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamOnepieceMainSmall1BannerRepository(this.firestore);

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

// 'AamPantsMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamPantsMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamPantsMainSmall1BannerRepository(this.firestore);

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

// 'AamJeanMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamJeanMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamJeanMainSmall1BannerRepository(this.firestore);

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

// 'AamSkirtMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamSkirtMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamSkirtMainSmall1BannerRepository(this.firestore);

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

// 'AamPaedingMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamPaedingMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamPaedingMainSmall1BannerRepository(this.firestore);

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

// 'AamCoatMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamCoatMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamCoatMainSmall1BannerRepository(this.firestore);

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

// 'AamCardiganMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamCardiganMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamCardiganMainSmall1BannerRepository(this.firestore);

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
// 'AamProfileMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamProfileMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamProfileMainSmall1BannerRepository(this.firestore);

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
// 'AamNewSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamNewSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamNewSubMainSmall1BannerRepository(this.firestore);

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

// 'AamBestSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamBestSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamBestSubMainSmall1BannerRepository(this.firestore);

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

// 'AamSaleSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamSaleSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamSaleSubMainSmall1BannerRepository(this.firestore);

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

// 'AamSpringSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamSpringSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamSpringSubMainSmall1BannerRepository(this.firestore);

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

// 'AamSummerSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamSummerSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamSummerSubMainSmall1BannerRepository(this.firestore);

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

// 'AamAutumnSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamAutumnSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamAutumnSubMainSmall1BannerRepository(this.firestore);

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

// 'AamWinterSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AamWinterSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AamWinterSubMainSmall1BannerRepository(this.firestore);

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