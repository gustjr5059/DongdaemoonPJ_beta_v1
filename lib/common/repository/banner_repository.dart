// 필요한 패키지와 모듈을 가져옴.
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore를 사용하기 위한 패키지
import '../model/banner_model.dart'; // 배너 이미지 데이터 모델 정의 파일

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
    print('Fetching common banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 CommonBannerImage 객체로 변환함.
      return [
        CommonBannerImage.fromJson({'imageUrl': data['commsmallbanner1']}),
        CommonBannerImage.fromJson({'imageUrl': data['commsmallbanner2']}),
        CommonBannerImage.fromJson({'imageUrl': data['commsmallbanner3']})
      ].whereType<CommonBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch common banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'AllLargeBannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AllLargeBannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AllLargeBannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AllLargeBannerImage> 타입의 Future를 반환함.
  Future<List<AllLargeBannerImage>> fetchBannerImages() async {
    print('Fetching large banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AllLargeBannerImage 객체로 변환함.
      return [
        AllLargeBannerImage.fromJson({'imageUrl': data['bb_test_5']}),
        AllLargeBannerImage.fromJson({'imageUrl': data['bb_test_2']}),
        AllLargeBannerImage.fromJson({'imageUrl': data['bb_test_3']})
      ].whereType<AllLargeBannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch large banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'HomeSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class HomeSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  HomeSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<HomeSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<HomeSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching small banner 1 images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 Small1BannerImage 객체로 변환함.
      return [
        HomeSmall1BannerImage.fromJson({'imageUrl': data['hsb_test_1']}),
        HomeSmall1BannerImage.fromJson({'imageUrl': data['hsb_test_2']}),
        HomeSmall1BannerImage.fromJson({'imageUrl': data['ad_image3']})
      ].whereType<HomeSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch small banner 1 images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'HomeSmall2BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class HomeSmall2BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  HomeSmall2BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<HomeSmall2BannerImage> 타입의 Future를 반환함.
  Future<List<HomeSmall2BannerImage>> fetchBannerImages() async {
    print('Fetching small banner 2 images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 HomeSmall2BannerImage 객체로 변환함.
      return [
        HomeSmall2BannerImage.fromJson({'imageUrl': data['ad_image4']}),
        HomeSmall2BannerImage.fromJson({'imageUrl': data['ad_image5']}),
        HomeSmall2BannerImage.fromJson({'imageUrl': data['ad_image6']})
      ].whereType<HomeSmall2BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch small banner 2 images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'HomeSmall3BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class HomeSmall3BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  HomeSmall3BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<HomeSmall3BannerImage> 타입의 Future를 반환함.
  Future<List<HomeSmall3BannerImage>> fetchBannerImages() async {
    print('Fetching small banner 3 images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 HomeSmall3BannerImage 객체로 변환함.
      return [
        HomeSmall3BannerImage.fromJson({'imageUrl': data['ad_image7']}),
        HomeSmall3BannerImage.fromJson({'imageUrl': data['ad_image8']}),
        HomeSmall3BannerImage.fromJson({'imageUrl': data['ad_image9']})
      ].whereType<HomeSmall3BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch small banner 3 images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// -------- 각 카테고리 메인 화면 작은 배너 관련 레퍼지토리 내용 시작

// 'ShirtMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class ShirtMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  ShirtMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<ShirtMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<ShirtMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching shirt main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 ShirtMainSmall1BannerImage 객체로 변환함.
      return [
        ShirtMainSmall1BannerImage.fromJson({'imageUrl': data['sb_test_1']}),
        ShirtMainSmall1BannerImage.fromJson({'imageUrl': data['mb2']}),
        ShirtMainSmall1BannerImage.fromJson({'imageUrl': data['mb3']})
      ].whereType<ShirtMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch shirt main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'BlouseMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class BlouseMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  BlouseMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<BlouseMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<BlouseMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching blouse main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 BlouseMainSmall1BannerImage 객체로 변환함.
      return [
        BlouseMainSmall1BannerImage.fromJson({'imageUrl': data['mb4']}),
        BlouseMainSmall1BannerImage.fromJson({'imageUrl': data['mb5']}),
        BlouseMainSmall1BannerImage.fromJson({'imageUrl': data['mb6']})
      ].whereType<BlouseMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch blouse main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'MtmMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class MtmMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  MtmMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<MtmMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<MtmMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching mtm main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 MtmMainSmall1BannerImage 객체로 변환함.
      return [
        MtmMainSmall1BannerImage.fromJson({'imageUrl': data['mb7']}),
        MtmMainSmall1BannerImage.fromJson({'imageUrl': data['mb8']}),
        MtmMainSmall1BannerImage.fromJson({'imageUrl': data['mb9']})
      ].whereType<MtmMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch mtm main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'NeatMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class NeatMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  NeatMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<NeatMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<NeatMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching neat main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 NeatMainSmall1BannerImage 객체로 변환함.
      return [
        NeatMainSmall1BannerImage.fromJson({'imageUrl': data['mb10']}),
        NeatMainSmall1BannerImage.fromJson({'imageUrl': data['mb11']}),
        NeatMainSmall1BannerImage.fromJson({'imageUrl': data['mb12']})
      ].whereType<NeatMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch neat main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'PolaMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class PolaMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  PolaMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<PolaMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<PolaMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching pola main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 PolaMainSmall1BannerImage 객체로 변환함.
      return [
        PolaMainSmall1BannerImage.fromJson({'imageUrl': data['mb13']}),
        PolaMainSmall1BannerImage.fromJson({'imageUrl': data['mb14']}),
        PolaMainSmall1BannerImage.fromJson({'imageUrl': data['mb15']})
      ].whereType<PolaMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch pola main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'OnepieceMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class OnepieceMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  OnepieceMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<OnepieceMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<OnepieceMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching onepiece main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 OnepieceMainSmall1BannerImage 객체로 변환함.
      return [
        OnepieceMainSmall1BannerImage.fromJson({'imageUrl': data['mb16']}),
        OnepieceMainSmall1BannerImage.fromJson({'imageUrl': data['mb17']}),
        OnepieceMainSmall1BannerImage.fromJson({'imageUrl': data['mb18']})
      ].whereType<OnepieceMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch onepiece main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'PantsMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class PantsMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  PantsMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<PantsMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<PantsMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching pants main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 PantsMainSmall1BannerImage 객체로 변환함.
      return [
        PantsMainSmall1BannerImage.fromJson({'imageUrl': data['mb19']}),
        PantsMainSmall1BannerImage.fromJson({'imageUrl': data['mb20']}),
        PantsMainSmall1BannerImage.fromJson({'imageUrl': data['mb21']})
      ].whereType<PantsMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch pants main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'JeanMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class JeanMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  JeanMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<JeanMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<JeanMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching jean main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 JeanMainSmall1BannerImage 객체로 변환함.
      return [
        JeanMainSmall1BannerImage.fromJson({'imageUrl': data['mb22']}),
        JeanMainSmall1BannerImage.fromJson({'imageUrl': data['mb23']}),
        JeanMainSmall1BannerImage.fromJson({'imageUrl': data['mb24']})
      ].whereType<JeanMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch jean main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'SkirtMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class SkirtMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  SkirtMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<SkirtMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<SkirtMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching skirt main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 SkirtMainSmall1BannerImage 객체로 변환함.
      return [
        SkirtMainSmall1BannerImage.fromJson({'imageUrl': data['mb25']}),
        SkirtMainSmall1BannerImage.fromJson({'imageUrl': data['mb26']}),
        SkirtMainSmall1BannerImage.fromJson({'imageUrl': data['mb27']})
      ].whereType<SkirtMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch skirt main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'PaedingMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class PaedingMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  PaedingMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<PaedingMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<PaedingMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching paeding main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 PaedingMainSmall1BannerImage 객체로 변환함.
      return [
        PaedingMainSmall1BannerImage.fromJson({'imageUrl': data['mb28']}),
        PaedingMainSmall1BannerImage.fromJson({'imageUrl': data['mb29']}),
        PaedingMainSmall1BannerImage.fromJson({'imageUrl': data['mb30']})
      ].whereType<PaedingMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch paeding main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'CoatMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class CoatMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  CoatMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<CoatMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<CoatMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching coat main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 CoatMainSmall1BannerImage 객체로 변환함.
      return [
        CoatMainSmall1BannerImage.fromJson({'imageUrl': data['mb31']}),
        CoatMainSmall1BannerImage.fromJson({'imageUrl': data['mb32']}),
        CoatMainSmall1BannerImage.fromJson({'imageUrl': data['mb33']})
      ].whereType<CoatMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch coat main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'CardiganMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class CardiganMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  CardiganMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<CardiganMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<CardiganMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching cardigan main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 CardiganMainSmall1BannerImage 객체로 변환함.
      return [
        CardiganMainSmall1BannerImage.fromJson({'imageUrl': data['mb34']}),
        CardiganMainSmall1BannerImage.fromJson({'imageUrl': data['mb35']}),
        CardiganMainSmall1BannerImage.fromJson({'imageUrl': data['mb36']})
      ].whereType<CardiganMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch cardigan main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
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

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<ProfileMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<ProfileMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching profile main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 ProfileMainSmall1BannerImage 객체로 변환함.
      return [
        ProfileMainSmall1BannerImage.fromJson({'imageUrl': data['mb34']}),
        ProfileMainSmall1BannerImage.fromJson({'imageUrl': data['mb35']}),
        ProfileMainSmall1BannerImage.fromJson({'imageUrl': data['mb36']})
      ].whereType<ProfileMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch profile main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// -------- 각 카테고리 메인 화면 작은 배너 관련 레퍼지토리 내용 끝

// -------- 각 섹션 더보기 화면 작은 배너 관련 레퍼지토리 내용 시작

// 'NewSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class NewSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  NewSubMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<NewSubMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<NewSubMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching newSub main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 NewSubMainSmall1BannerImage 객체로 변환함.
      return [
        NewSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb37']}),
        NewSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb38']}),
        NewSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb39']})
      ].whereType<NewSubMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch newSub main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'BestSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class BestSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  BestSubMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<BestSubMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<BestSubMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching bestSub main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 BestSubMainSmall1BannerImage 객체로 변환함.
      return [
        BestSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb40']}),
        BestSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb41']}),
        BestSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb42']})
      ].whereType<BestSubMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch bestSub main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'SaleSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class SaleSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  SaleSubMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<SaleSubMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<SaleSubMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching saleSub main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 SaleSubMainSmall1BannerImage 객체로 변환함.
      return [
        SaleSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb43']}),
        SaleSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb44']}),
        SaleSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb45']})
      ].whereType<SaleSubMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch saleSub main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'SpringSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class SpringSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  SpringSubMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<SpringSubMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<SpringSubMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching springSub main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 SpringSubMainSmall1BannerImage 객체로 변환함.
      return [
        SpringSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb46']}),
        SpringSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb47']}),
        SpringSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb48']})
      ].whereType<SpringSubMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch springSub main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'SummerSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class SummerSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  SummerSubMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<SummerSubMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<SummerSubMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching summerSub main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 NewSubMainSmall1BannerImage 객체로 변환함.
      return [
        SummerSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb49']}),
        SummerSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb50']}),
        SummerSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb51']})
      ].whereType<SummerSubMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch summerSub main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'AutumnSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class AutumnSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  AutumnSubMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<AutumnSubMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<AutumnSubMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching autumnSub main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 AutumnSubMainSmall1BannerImage 객체로 변환함.
      return [
        AutumnSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb52']}),
        AutumnSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb53']}),
        AutumnSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb54']})
      ].whereType<AutumnSubMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch autumnSub main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// 'WinterSubMainSmall1BannerRepository' 클래스는 Firestore 데이터베이스에서 배너 이미지 데이터를 가져오는 기능을 제공함.
class WinterSubMainSmall1BannerRepository {
  // 'firestore' 변수는 FirebaseFirestore의 인스턴스를 저장함.
  // 이 인스턴스를 통해 Firestore 데이터베이스에 접근함.
  final FirebaseFirestore firestore;

  // 생성자에서는 FirebaseFirestore의 인스턴스를 받아 'firestore' 변수에 할당함.
  WinterSubMainSmall1BannerRepository(this.firestore);

  // 'fetchBannerImages' 메서드는 Firestore로부터 배너 이미지를 비동기적으로 가져옴.
  // 이 메서드는 List<WinterSubMainSmall1BannerImage> 타입의 Future를 반환함.
  Future<List<WinterSubMainSmall1BannerImage>> fetchBannerImages() async {
    print('Fetching winterSub main small banner images from Firestore...');
    // 'item' 컬렉션 내의 'banners' 문서에 접근하여 데이터를 가져옴.
    DocumentSnapshot snapshot =
    await firestore.collection('item').doc('banners').get();

    // 문서가 존재하는 경우 실행됨.
    if (snapshot.exists) {
      print('Document exists, processing data...');
      // 문서의 데이터를 Map<String, dynamic> 형태로 추출함.
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // 데이터 맵에서 특정 키를 사용하여 이미지 URL을 가져온 후 WinterSubMainSmall1BannerImage 객체로 변환함.
      return [
        WinterSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb55']}),
        WinterSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb56']}),
        WinterSubMainSmall1BannerImage.fromJson({'imageUrl': data['mb57']})
      ].whereType<WinterSubMainSmall1BannerImage>().toList(); // 생성된 객체들을 List로 변환하여 반환함.
    }
    print('Failed to fetch winterSub main small banner images: Document does not exist.');
    // 문서가 존재하지 않는 경우 예외를 발생시킴.
    throw Exception('Failed to fetch banner images');
  }
}

// -------- 각 섹션 더보기 화면 작은 배너 관련 레퍼지토리 내용 끝