// Cloud Firestore는 Firebase의 NoSQL 클라우드 데이터베이스로, 데이터를 저장하고 동기화하는 데 사용됩니다.
// 이 데이터베이스는 실시간 데이터 동기화를 지원하여 앱의 모든 사용자에게 즉각적인 업데이트를 제공합니다.
// Firestore 패키지를 임포트하여 Flutter 앱에서 Firestore 서비스를 사용할 수 있게 합니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongdaemoon_beta_v1/common/repository/banner_repository.dart';

// Riverpod는 Flutter에서 사용할 수 있는 외부 상태 관리 라이브러리입니다.
// 이 라이브러리는 상태를 보다 선언적으로 관리할 수 있게 해주며, 앱의 다양한 부분에서 상태를 쉽게 공유하고 접근할 수 있도록 도와줍니다.
// Riverpod를 임포트하여 애플리케이션의 상태 관리를 간편하고 효과적으로 할 수 있습니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';

// '../model/banner_model.dart' 파일을 현재 파일로 가져옵니다.
// 'banner_model.dart' 파일에는 대형 배너 이미지에 관련된 데이터 모델 클래스들이 정의되어 있습니다.
// 이 클래스들을 사용하여 배너 이미지 데이터를 관리하고 조작할 수 있습니다.
import '../model/banner_model.dart';
import '../repository/event_data_repository.dart';

// ------- Firestore로부터 공통 배너 데이터 가져오는 로직 관련 provider 시작

// Firestore에서 공통 배너 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final commonBannerRepositoryProvider = Provider<CommonBannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 CommonBannerRepository 객체를 생성함.
  // CommonBannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return CommonBannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 공통 배너 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final commonBannerImagesProvider =
    FutureProvider<List<CommonBannerImage>>((ref) async {
  // 위에서 정의한 commonBannerRepositoryProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(commonBannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<CommonBannerImage>를 반환함.
  return await repository.fetchBannerImages();
});

// ------- Firestore로부터 공통 배너 데이터 가져오는 로직 관련 provider 끝

// ------- Firestore로부터 큰 배너 데이터 가져오는 로직 관련 provider 시작

// Firestore에서 큰 배너 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final allLargeBannerRepositoryProvider =
Provider<AllLargeBannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AllLargeBannerRepository 객체를 생성함.
  // AllLargeBannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AllLargeBannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 큰 배너 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final allLargeBannerImagesProvider =
FutureProvider<List<AllLargeBannerImage>>((ref) async {
  // 위에서 정의한 allLargeBannerRepositoryProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(allLargeBannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<AllLargeBannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});

// ------- Firestore로부터 큰 배너 데이터 가져오는 로직 관련 provider 끝

// 앱 바에 나올 이벤트 이미지 관련 데이터를 불러오는 EventRepository 인스턴스 provider
final eventImageProvider = FutureProvider<String?>((ref) async {
  final repository = EventRepository(firestore: FirebaseFirestore.instance);
  return repository.fetchEventImage();
});

// 앱 바에 나올 타이틀 이미지 관련 데이터를 불러오는 EventRepository 인스턴스 provider
final titleImageProvider = FutureProvider<String?>((ref) async {
  final repository = EventRepository(firestore: FirebaseFirestore.instance);
  return repository.fetchTitleImage();
});

// eventPosterImgItemRepositoryProvider 클래스를 제공하기 위한 Provider 정의
final eventPosterImgItemRepositoryProvider = Provider((ref) => EventRepository(
  firestore: FirebaseFirestore.instance, // Firebase Firestore 인스턴스를 전달
));
