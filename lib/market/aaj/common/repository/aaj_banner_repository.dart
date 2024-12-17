// 필요한 패키지와 모듈을 가져옴.
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore를 사용하기 위한 패키지
import '../../../../common/model/banner_model.dart';


// ------ AajAllLargeBannerRepository 클래스 시작
// 'AajAllLargeBannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajAllLargeBannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajAllLargeBannerRepository(this.firestore);

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
// ------ AajAllLargeBannerRepository 클래스 끝

// -------- 각 카테고리 메인 화면 작은 배너 관련 레퍼지토리 내용 시작
// 'AajShirtMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajShirtMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajShirtMainSmall1BannerRepository(this.firestore);

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

// 'AajBlouseMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajBlouseMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajBlouseMainSmall1BannerRepository(this.firestore);

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

// 'AajMtmMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajMtmMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajMtmMainSmall1BannerRepository(this.firestore);

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

// 'AajNeatMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajNeatMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajNeatMainSmall1BannerRepository(this.firestore);

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

// 'AajPolaMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajPolaMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajPolaMainSmall1BannerRepository(this.firestore);

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

// 'AajOnepieceMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajOnepieceMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajOnepieceMainSmall1BannerRepository(this.firestore);

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

// 'AajPantsMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajPantsMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajPantsMainSmall1BannerRepository(this.firestore);

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

// 'AajJeanMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajJeanMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajJeanMainSmall1BannerRepository(this.firestore);

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

// 'AajSkirtMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajSkirtMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajSkirtMainSmall1BannerRepository(this.firestore);

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

// 'AajPaedingMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajPaedingMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajPaedingMainSmall1BannerRepository(this.firestore);

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

// 'AajCoatMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajCoatMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajCoatMainSmall1BannerRepository(this.firestore);

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

// 'AajCardiganMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajCardiganMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajCardiganMainSmall1BannerRepository(this.firestore);

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
// 'AajProfileMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajProfileMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajProfileMainSmall1BannerRepository(this.firestore);

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
// 'AajNewSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajNewSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajNewSubMainSmall1BannerRepository(this.firestore);

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

// 'AajBestSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajBestSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajBestSubMainSmall1BannerRepository(this.firestore);

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

// 'AajSaleSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajSaleSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajSaleSubMainSmall1BannerRepository(this.firestore);

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

// 'AajSpringSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajSpringSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajSpringSubMainSmall1BannerRepository(this.firestore);

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

// 'AajSummerSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajSummerSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajSummerSubMainSmall1BannerRepository(this.firestore);

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

// 'AajAutumnSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajAutumnSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajAutumnSubMainSmall1BannerRepository(this.firestore);

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

// 'AajWinterSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AajWinterSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AajWinterSubMainSmall1BannerRepository(this.firestore);

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