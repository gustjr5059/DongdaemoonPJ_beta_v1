import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../common/model/banner_model.dart';
import '../repository/abd_home_repository.dart';


// ------- Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final abdHomeSmall1BannerRepositoryProvider =
Provider<AbdHomeSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AbdHomeSmall1BannerRepository 객체를 생성함.
  // AbdHomeSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AbdHomeSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final abdHomeSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 abdHomeSmall1BannerRepositoryProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(abdHomeSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<AbdHomeSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_30');
});
// ------- Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- Firestore로부터 두 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너2 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final abdHomeSmall2BannerRepositoryProvider =
Provider<AbdHomeSmall2BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AbdHomeSmall2BannerRepository 객체를 생성함.
  // AbdHomeSmall2BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AbdHomeSmall2BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너2 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final abdHomeSmall2BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 abdHomeSmall2BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(abdHomeSmall2BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<AbdHomeSmall2BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_30');
});
// ------- Firestore로부터 두 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- Firestore로부터 세 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너3 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final abdHomeSmall3BannerRepositoryProvider =
Provider<AbdHomeSmall3BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AbdHomeSmall3BannerRepository 객체를 생성함.
  // AbdHomeSmall3BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AbdHomeSmall3BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너3 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final abdHomeSmall3BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 abdHomeSmall3BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(abdHomeSmall3BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<AbdHomeSmall3BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_30');
});
// ------- Firestore로부터 세 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝