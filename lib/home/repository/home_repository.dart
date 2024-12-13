import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/model/banner_model.dart';


// ------ 홈 화면 내 배너 관련 로직 시작 부분
// ------ HomeLargeBannerRepository 클래스 시작
// 'HomeLargeBannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class HomeLargeBannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  HomeLargeBannerRepository(this.firestore);

  // 'fetchBannerImagesAndLink' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllLargeBannerImage> 타입의 Future를 반환함.
  Future<List<AllLargeBannerImage>> fetchBannerImagesAndLink() async {
    print('Firestore에서 큰 배너 이미지를 가져오는 중...'); // Firestore에서 큰 배너 이미지 가져오기 시작 메시지 출력
    // 'banners' 컬렉션 내의 'large_banner' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot = await firestore
        .collection('banners')
        .doc('wearcano')
        .collection('main_home_banner')
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
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 2를 생성하기 위한 데이터 모델링
        AllLargeBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 3을 생성하기 위한 데이터 모델링
        AllLargeBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_3']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 4를 생성하기 위한 데이터 모델링
        AllLargeBannerImage.fromJson({
          'imageUrl': data['ad_img_4'],  // 이미지 URL로 사용할 데이터 'ad_img_4'
          'url': data['ad_url_4']  // 연결 URL 정보 포함
        }),
        // 광고 배너 이미지 5를 생성하기 위한 데이터 모델링
        AllLargeBannerImage.fromJson({
          'imageUrl': data['ad_img_5'],  // 이미지 URL로 사용할 데이터 'ad_img_5'
          'url': data['ad_url_5']  // 연결 URL 정보 포함
        }),
      ].whereType<AllLargeBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('큰 배너 이미지를 가져오지 못함: 문서가 존재하지 않음.'); // 문서가 존재하지 않을 때 메시지 출력
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다.');
  }
}
// ------ HomeLargeBannerRepository 클래스 끝

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
  Future<List<AllSmallBannerImage>> fetchBannerImagesAndLink() async {
    print('Firestore에서 작은 배너 1 이미지를 가져오는 중...'); // Firestore에서 작은 배너 1 이미지 가져오기 시작 메시지 출력
    // 'banners' 컬렉션 내의 'home_small_banner_1' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('banners').doc('wearcano').collection('main_home_banner').doc('home_small_banner_1').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('문서가 존재하여 데이터를 처리 중...'); // 문서가 존재할 때 데이터 처리 시작 메시지 출력
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 Small1BannerImage 객체로 변환함.
      return [
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_1'],  // 이미지 URL로 사용할 데이터 'ad_img_1'
          'url': data['ad_url_1']  // 연결 URL 정보 포함
        }),
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_2'],  // 이미지 URL로 사용할 데이터 'ad_img_2'
          'url': data['ad_url_2']  // 연결 URL 정보 포함
        }),
        AllSmallBannerImage.fromJson({
          'imageUrl': data['ad_img_3'],  // 이미지 URL로 사용할 데이터 'ad_img_3'
          'url': data['ad_url_3']  // 연결 URL 정보 포함
        })
      ].whereType<AllSmallBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('작은 배너 1 이미지를 가져오지 못함: 문서가 존재하지 않음.'); // 문서가 존재하지 않을 때 메시지 출력
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('배너 이미지를 가져오지 못했습니다.');
  }
}
// ------ HomeSmall1BannerRepository 클래스 끝
// ------ 홈 화면 내 배너 관련 로직 끝 부분

// ------ 메인 홈 화면 내 마켐 버튼 관련 데이터 처리 로직인 MarketBtnRepository 클래스 시작
class MarketBtnRepository {
  final FirebaseFirestore firestore;

  MarketBtnRepository({required this.firestore});

  // Firestore에서 boolExistence가 true이고 sequence 필드로 정렬된 모든 문서를 가져옴
  Future<List<Map<String, dynamic>>> fetchAllMarketButtons() async {
    print("Firestore에서 모든 중간 카테고리 버튼 데이터를 불러옵니다.");

    Query query = firestore
        .collection('market_data')
        .doc('wearcano')
        .collection('market')
        .where('boolExistence', isEqualTo: true) // 필터 조건: boolExistence가 true인 문서만 가져옴
        .orderBy('sequence', descending: false); // 오름차순 정렬

    final querySnapshot = await query.get();
    print("가져온 문서 수: ${querySnapshot.docs.length}");

    if (querySnapshot.docs.isEmpty) {
      print("불러올 데이터가 없습니다.");
      return [];
    }

    return querySnapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // 문서 ID 추가
      print("중간 카테고리 버튼 데이터 처리: id=${doc.id}, name=${data['name']}, step=${data['step']}");
      return data;
    }).toList();
  }
}
// ------ 메인 홈 화면 내 마켐 버튼 관련 데이터 처리 로직인 MarketBtnRepository 클래스 끝
