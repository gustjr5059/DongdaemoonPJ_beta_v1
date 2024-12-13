import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../common/model/banner_model.dart';
import '../repository/aaa_home_repository.dart';


// ------- Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaHomeSmall1BannerRepositoryProvider =
Provider<AaaHomeSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaHomeSmall1BannerRepository 객체를 생성함.
  // AaaHomeSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaHomeSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaHomeSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaHomeSmall1BannerRepositoryProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaHomeSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<AaaHomeSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- Firestore로부터 두 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너2 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaHomeSmall2BannerRepositoryProvider =
Provider<AaaHomeSmall2BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaHomeSmall2BannerRepository 객체를 생성함.
  // AaaHomeSmall2BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaHomeSmall2BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너2 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaHomeSmall2BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaHomeSmall2BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaHomeSmall2BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<AaaHomeSmall2BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- Firestore로부터 두 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- Firestore로부터 세 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너3 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaHomeSmall3BannerRepositoryProvider =
Provider<AaaHomeSmall3BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaHomeSmall3BannerRepository 객체를 생성함.
  // AaaHomeSmall3BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaHomeSmall3BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너3 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaHomeSmall3BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaHomeSmall3BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaHomeSmall3BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<AaaHomeSmall3BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- Firestore로부터 세 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝