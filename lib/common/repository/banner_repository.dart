
// 필요한 패키지와 모듈을 가져옴.
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore를 사용하기 위한 패키지
import '../model/banner_model.dart'; // 배너 이미지 데이터 모델 정의 파일

// 'LargeBannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class LargeBannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  LargeBannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<LargeBannerImage> 타입의 Future를 반환함.
  Future<List<LargeBannerImage>> fetchBannerImages() async {
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot = await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 LargeBannerImage 객체로 변환함.
      return [
        LargeBannerImage.fromJson({'imageUrl': data['dongdaemoon1']}),
        LargeBannerImage.fromJson({'imageUrl': data['dongdaemoon2']}),
        LargeBannerImage.fromJson({'imageUrl': data['dongdaemoon3']})
      ].whereType<LargeBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}


// 'Small1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class Small1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  Small1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<Small1BannerImage> 타입의 Future를 반환함.
  Future<List<Small1BannerImage>> fetchBannerImages() async {
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot = await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 Small1BannerImage 객체로 변환함.
      return [
        Small1BannerImage.fromJson({'imageUrl': data['ad_image1']}),
        Small1BannerImage.fromJson({'imageUrl': data['ad_image2']}),
        Small1BannerImage.fromJson({'imageUrl': data['ad_image3']})
      ].whereType<Small1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}


// 'Small2BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class Small2BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  Small2BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<Small2BannerImage> 타입의 Future를 반환함.
  Future<List<Small2BannerImage>> fetchBannerImages() async {
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot = await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 Small2BannerImage 객체로 변환함.
      return [
        Small2BannerImage.fromJson({'imageUrl': data['ad_image4']}),
        Small2BannerImage.fromJson({'imageUrl': data['ad_image5']}),
        Small2BannerImage.fromJson({'imageUrl': data['ad_image6']})
      ].whereType<Small2BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}


// 'Small3BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class Small3BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  Small3BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<Small3BannerImage> 타입의 Future를 반환함.
  Future<List<Small3BannerImage>> fetchBannerImages() async {
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot = await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 Small3BannerImage 객체로 변환함.
      return [
        Small3BannerImage.fromJson({'imageUrl': data['ad_image7']}),
        Small3BannerImage.fromJson({'imageUrl': data['ad_image8']}),
        Small3BannerImage.fromJson({'imageUrl': data['ad_image9']})
      ].whereType<Small3BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

