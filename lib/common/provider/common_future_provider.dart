
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


// Firestore에서 대형 배너 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final largeBannerRepositoryProvider = Provider<LargeBannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 LargeBannerRepository 객체를 생성함.
  // LargeBannerRepository는 Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return LargeBannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 대형 배너 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final largeBannerImagesProvider = FutureProvider<List<LargeBannerImage>>((ref) async {
  // 위에서 정의한 largeBannerRepositoryProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(largeBannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<LargeBannerImage>를 반환함.
  return await repository.fetchBannerImages();
});

// Firestore에서 대형 배너 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final small1BannerRepositoryProvider = Provider<Small1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 Small1BannerRepository 객체를 생성함.
  // Small1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return Small1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 대형 배너 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final small1BannerImagesProvider = FutureProvider<List<Small1BannerImage>>((ref) async {
  // 위에서 정의한 small1BannerRepositoryProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(small1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<Small1BannerImage>를 반환함.
  return await repository.fetchBannerImages();
});

// Firestore에서 대형 배너 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final small2BannerRepositoryProvider = Provider<Small2BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 Small2BannerRepository 객체를 생성함.
  // Small2BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return Small2BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 대형 배너 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final small2BannerImagesProvider = FutureProvider<List<Small2BannerImage>>((ref) async {
  // 위에서 정의한 small2BannerRepositoryProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(small2BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<Small2BannerImage>를 반환함.
  return await repository.fetchBannerImages();
});

// Firestore에서 대형 배너 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final small3BannerRepositoryProvider = Provider<Small3BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 Small3BannerRepository 객체를 생성함.
  // Small3BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return Small3BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 대형 배너 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final small3BannerImagesProvider = FutureProvider<List<Small3BannerImage>>((ref) async {
  // 위에서 정의한 small3BannerRepositoryProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(small3BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<Small3BannerImage>를 반환함.
  return await repository.fetchBannerImages();
});