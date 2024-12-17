
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/model/banner_model.dart';
import '../repository/aar_banner_repository.dart';


// ------- Firestore로부터 큰 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 큰 배너 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aarAllLargeBannerRepositoryProvider =
Provider<AarAllLargeBannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AarAllLargeBannerRepository 객체를 생성함.
  // AarAllLargeBannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AarAllLargeBannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 큰 배너 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aarAllLargeBannerImagesProvider =
FutureProvider<List<AllLargeBannerImage>>((ref) async {
  // 위에서 정의한 aarAllLargeBannerRepositoryProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aarAllLargeBannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<AllLargeBannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_18');
});
// ------- Firestore로부터 큰 배너 데이터 가져오는 로직 관련 provider 끝