// Firestore의 'Product' 데이터와 상호작용하는 클래스와 프로바이더 설정
// Firebase의 Firestore 서비스를 사용하여 클라우드 기반의 NoSQL 데이터베이스에서 데이터를 읽고 쓸 수 있도록 해주는 라이브러리를 임포트합니다.
// Firestore를 사용하면 실시간 데이터 동기화가 가능하며, 애플리케이션의 여러 사용자 간에 데이터의 일관성을 유지할 수 있습니다.
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore를 사용하기 위한 라이브러리의 임포트
// Riverpod는 상태 관리를 위한 현대적인 라이브러리로, 애플리케이션 전반의 상태를 효과적으로 관리하도록 돕습니다.
// 이를 통해 앱의 데이터 흐름과 상태 변화를 감시하고, 필요에 따라 UI를 자동으로 업데이트합니다.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리 라이브러리 Riverpod를 사용하기 위한 임포트
// 제품 데이터 모델 파일을 임포트합니다.
// 이 파일은 제품의 속성과 메서드를 정의하여, 제품 데이터를 객체로 관리하는 데 사용됩니다.
// 제품 모델은 Firestore에서 가져온 데이터를 애플리케이션 내에서 사용하기 쉬운 형태로 변환하는 역할을 합니다.
import '../../../../common/model/banner_model.dart';
import '../../../../product/model/product_model.dart';
import '../../../../product/provider/product_all_providers.dart';
import '../../common/repository/aaf_banner_repository.dart';
import '../repository/aaf_product_repository.dart';


// Firestore로부터 티셔츠 ~ 가디건의 1차 카테고리와 신상 ~ 겨울의 2차 카테고리 상품 정보를 불러오는 각 레퍼지토 인스턴스를 생성하는 프로바이더
// 메인 화면 관련 ProductMainListNotifier용 CategoryProductsRepository Provider
final aafMainProductRepositoryProvider = Provider<AafMainCategoryProductsRepository>((ref) {
  return AafMainCategoryProductsRepository(FirebaseFirestore.instance);
});

// 섹션 더보기 화면 관련 SectionMoreProductListNotifier용 CategoryProductsRepository Provider
final aafSectionProductRepositoryProvider = Provider<AafSectionCategoryProductsRepository>((ref) {
  return AafSectionCategoryProductsRepository(FirebaseFirestore.instance);
});

// ------ 신상, 최고, 할인, 봄, 여름, 가을, 겨울 관련 홈 화면에 보여줄 섹션 부분 - 파이어베이스의 데이터를 불러올 때 사용할 provider 시작
// aafNewProdFirestoreDataProvider 등의 여러 문서 데이터를 가져오는 FutureProvider는 현재 사용 안되고 있음-추후,사용 가능성이 있어 우선 놧두기!!
// ----- 신상 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aafNewProductRepositoryProvider = Provider<AafNewProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafNewProductRepository 객체를 생성
  return AafNewProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aafNewProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aafNewProductRepositoryProvider로부터 AafNewProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aafNewProductRepositoryProvider);
  // AafNewProductRepository 인스턴스의 fetchNewProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchNewProductContents();
});
// ----- 신상 부분 끝

// ----- 최고 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aafBestProductRepositoryProvider = Provider<AafBestProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafBestProductRepository 객체를 생성
  return AafBestProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aafBestProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aafBestProductRepositoryProvider로부터 AafBestProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aafBestProductRepositoryProvider);
  // AafBestProductRepository 인스턴스의 fetchBestProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchBestProductContents();
});
// ----- 최고 부분 끝

// ----- 할인 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aafSaleProductRepositoryProvider = Provider<AafSaleProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafSaleProductRepository 객체를 생성
  return AafSaleProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aafSaleProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aafSaleProductRepositoryProvider로부터 AafSaleProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aafSaleProductRepositoryProvider);
  // AafSaleProductRepository 인스턴스의 fetchSaleProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchSaleProductContents();
});
// ----- 할인 부분 끝

// ----- 봄 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aafSpringProductRepositoryProvider =
    Provider<AafSpringProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafSpringProductRepository 객체를 생성
  return AafSpringProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aafSpringProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aafSpringProductRepositoryProvider로부터 AafSpringProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aafSpringProductRepositoryProvider);
  // AafSpringProductRepository 인스턴스의 fetchSpringProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchSpringProductContents();
});
// ----- 봄 부분 끝

// ----- 여름 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aafSummerProductRepositoryProvider =
    Provider<AafSummerProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafSummerProductRepository 객체를 생성
  return AafSummerProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aafSummerProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aafSummerProductRepositoryProvider로부터 AafSummerProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aafSummerProductRepositoryProvider);
  // AafSummerProductRepository 인스턴스의 fetchSummerProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchSummerProductContents();
});
// ----- 여름 부분 끝

// ----- 가을 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aafAutumnProductRepositoryProvider =
    Provider<AafAutumnProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafAutumnProductRepository 객체를 생성
  return AafAutumnProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aafAutumnProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aafAutumnProductRepositoryProvider로부터 AafAutumnProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aafAutumnProductRepositoryProvider);
  // AafAutumnProductRepository 인스턴스의 fetchAutumnProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchAutumnProductContents();
});
// ----- 가을 부분 끝

// ----- 겨울 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aafWinterProductRepositoryProvider =
    Provider<AafWinterProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafWinterProductRepository 객체를 생성
  return AafWinterProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aafWinterProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aafWinterProductRepositoryProvider로부터 AafWinterProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aafWinterProductRepositoryProvider);
  // AafWinterProductRepository 인스턴스의 fetchWinterProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchWinterProductContents();
});
// ----- 겨울 부분 끝
// ------ 신상, 최고, 할인, 봄, 여름, 가을, 겨울 관련 홈 화면에 보여줄 섹션 부분 - 파이어베이스의 데이터를 불러올 때 사용할 provider 끝

// ------ 블라우스, 가디건, 코트, 청바지, 맨투맨, 니트, 원피스, 패딩, 팬츠, 폴라티, 티셔츠, 스커트 관련 상품 상세 화면에 보여줄 상품 데이터 부분 -파이어베이스의 데이터를 불러올 때 사용할 provider 시작
// 블라우스 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aafBlouseDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaf2B1', 'Aaf2B2', 'Aaf2B3', 'Aaf2B4', 'Aaf2B5', 'Aaf2B6', 'Aaf2B7'],
    // 블라우스 관련 컬렉션 목록
    'fullPath': fullPath,
    // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 블라우스 끝

// 가디건 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aafCardiganDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': [
      'Aaf12B1',
      'Aaf12B2',
      'Aaf12B3',
      'Aaf12B4',
      'Aaf12B5',
      'Aaf12B6',
      'Aaf12B7'
    ], // 가디건 관련 컬렉션 목록
    'fullPath': fullPath, // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 가디건 끝

// 코트 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aafCoatDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': [
      'Aaf11B1',
      'Aaf11B2',
      'Aaf11B3',
      'Aaf11B4',
      'Aaf11B5',
      'Aaf11B6',
      'Aaf11B7'
    ], // 코트 관련 컬렉션 목록
    'fullPath': fullPath, // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 코트 끝

// 청바지 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aafJeanDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaf8B1', 'Aaf8B2', 'Aaf8B3', 'Aaf8B4', 'Aaf8B5', 'Aaf8B6', 'Aaf8B7'],
    // 청바지 관련 컬렉션 목록
    'fullPath': fullPath,
    // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 청바지 끝

// 맨투맨 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aafMtmDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaf3B1', 'Aaf3B2', 'Aaf3B3', 'Aaf3B4', 'Aaf3B5', 'Aaf3B6', 'Aaf3B7'],
    // 맨투맨 관련 컬렉션 목록
    'fullPath': fullPath,
    // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 맨투맨 끝

// 니트 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aafNeatDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaf4B1', 'Aaf4B2', 'Aaf4B3', 'Aaf4B4', 'Aaf4B5', 'Aaf4B6', 'Aaf4B7'],
    // 니트 관련 컬렉션 목록
    'fullPath': fullPath,
    // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 니트 끝

// 원피스 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aafOnepieceDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaf6B1', 'Aaf6B2', 'Aaf6B3', 'Aaf6B4', 'Aaf6B5', 'Aaf6B6', 'Aaf6B7'],
    // 원피스 관련 컬렉션 목록
    'fullPath': fullPath,
    // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 원피스 끝

// 패딩 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aafPaedingDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': [
      'Aaf10B1',
      'Aaf10B2',
      'Aaf10B3',
      'Aaf10B4',
      'Aaf10B5',
      'Aaf10B6',
      'Aaf10B7'
    ], // 패딩 관련 컬렉션 목록
    'fullPath': fullPath, // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 패딩 끝

// 팬츠 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aafPantsDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaf7B1', 'Aaf7B2', 'Aaf7B3', 'Aaf7B4', 'Aaf7B5', 'Aaf7B6', 'Aaf7B7'],
    // 팬츠 관련 컬렉션 목록
    'fullPath': fullPath,
    // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 팬츠 끝

// 폴라티 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aafPolaDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaf5B1', 'Aaf5B2', 'Aaf5B3', 'Aaf5B4', 'Aaf5B5', 'Aaf5B6', 'Aaf5B7'],
    // 폴라티 관련 컬렉션 목록
    'fullPath': fullPath,
    // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 폴라티 끝

// 티셔츠 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aafShirtDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaf1B1', 'Aaf1B2', 'Aaf1B3', 'Aaf1B4', 'Aaf1B5', 'Aaf1B6', 'Aaf1B7'],
    // 티셔츠 관련 컬렉션 목록
    'fullPath': fullPath,
    // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 티셔츠 끝

// 스커트 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aafSkirtDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaf9B1', 'Aaf9B2', 'Aaf9B3', 'Aaf9B4', 'Aaf9B5', 'Aaf9B6', 'Aaf9B7'],
    // 스커트 관련 컬렉션 목록
    'fullPath': fullPath,
    // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 스커트 끝
// ------ 블라우스, 가디건, 코트, 청바지, 맨투맨, 니트, 원피스, 패딩, 팬츠, 폴라티, 티셔츠, 스커트 관련 상품 상세 화면에 보여줄 상품 데이터 부분 -파이어베이스의 데이터를 불러올 때 사용할 provider 끝

// ------ 블라우스, 가디건, 코트, 청바지, 맨투맨, 니트, 원피스, 패딩, 팬츠, 폴라티, 티셔츠, 스커트 관련 2차 메인 화면에 보여줄 소배너 부분 -파이어베이스의 데이터를 불러올 때 사용할 provider 시작
// ------- 티셔츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafShirtMainSmall1BannerRepositoryProvider =
Provider<AafShirtMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafShirtMainSmall1BannerRepository 객체를 생성함.
  // AafShirtMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafShirtMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafShirtMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafShirtMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafShirtMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<ShirtMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 티셔츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 블라우스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafBlouseMainSmall1BannerRepositoryProvider =
Provider<AafBlouseMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafBlouseMainSmall1BannerRepository 객체를 생성함.
  // AafBlouseMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafBlouseMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafBlouseMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafBlouseMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafBlouseMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<BlouseMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 블라우스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 맨투맨 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafMtmMainSmall1BannerRepositoryProvider =
Provider<AafMtmMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafMtmMainSmall1BannerRepository 객체를 생성함.
  // AafMtmMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafMtmMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafMtmMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafMtmMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafMtmMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<MtmMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 맨투맨 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 니트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafNeatMainSmall1BannerRepositoryProvider =
Provider<AafNeatMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafNeatMainSmall1BannerRepository 객체를 생성함.
  // AafNeatMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafNeatMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafNeatMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafNeatMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafNeatMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<NeatMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 니트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 폴라티 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafPolaMainSmall1BannerRepositoryProvider =
Provider<AafPolaMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafPolaMainSmall1BannerRepository 객체를 생성함.
  // AafPolaMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafPolaMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafPolaMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafPolaMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafPolaMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<PolaMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 폴라티 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 원피스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafOnepieceMainSmall1BannerRepositoryProvider =
Provider<AafOnepieceMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafOnepieceMainSmall1BannerRepository 객체를 생성함.
  // AafOnepieceMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafOnepieceMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafOnepieceMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafOnepieceMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafOnepieceMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<OnepieceMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 원피스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 팬츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafPantsMainSmall1BannerRepositoryProvider =
Provider<AafPantsMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafPantsMainSmall1BannerRepository 객체를 생성함.
  // AafPantsMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafPantsMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafPantsMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafPantsMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafPantsMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<PantsMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 팬츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 청바지 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafJeanMainSmall1BannerRepositoryProvider =
Provider<AafJeanMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafJeanMainSmall1BannerRepository 객체를 생성함.
  // AafJeanMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafJeanMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafJeanMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafJeanMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafJeanMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<JeanMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 청바지 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 스커트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafSkirtMainSmall1BannerRepositoryProvider =
Provider<AafSkirtMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafSkirtMainSmall1BannerRepository 객체를 생성함.
  // AafSkirtMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafSkirtMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafSkirtMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafSkirtMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafSkirtMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<SkirtMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 스커트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 패딩 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafPaedingMainSmall1BannerRepositoryProvider =
Provider<AafPaedingMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafPaedingMainSmall1BannerRepository 객체를 생성함.
  // AafPaedingMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafPaedingMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafPaedingMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafPaedingMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafPaedingMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<BlouseMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 패딩 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 코트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafCoatMainSmall1BannerRepositoryProvider =
Provider<AafCoatMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafCoatMainSmall1BannerRepository 객체를 생성함.
  // AafCoatMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafCoatMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafCoatMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafCoatMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafCoatMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<CoatMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 코트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 가디건 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafCardiganMainSmall1BannerRepositoryProvider =
Provider<AafCardiganMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafCardiganMainSmall1BannerRepository 객체를 생성함.
  // AafCardiganMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafCardiganMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafCardiganMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafCardiganMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafCardiganMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<CardiganMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 가디건 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝
// ------ 블라우스, 가디건, 코트, 청바지, 맨투맨, 니트, 원피스, 패딩, 팬츠, 폴라티, 티셔츠, 스커트 관련 2차 메인 화면에 보여줄 소배너 부분 -파이어베이스의 데이터를 불러올 때 사용할 provider 끝

// ------- 각 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// ------- 신상 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafNewSubMainSmall1BannerRepositoryProvider =
Provider<AafNewSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafNewSubMainSmall1BannerRepository 객체를 생성함.
  // AafNewSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafNewSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafNewSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafNewSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafNewSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<NewSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 신상 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 스테디 셀러 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafBestSubMainSmall1BannerRepositoryProvider =
Provider<AafBestSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafBestSubMainSmall1BannerRepository 객체를 생성함.
  // AafBestSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafBestSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafBestSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafBestSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafBestSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<BestSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 스테디 셀러 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 특가 상품 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafSaleSubMainSmall1BannerRepositoryProvider =
Provider<AafSaleSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafSaleSubMainSmall1BannerRepository 객체를 생성함.
  // AafSaleSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafSaleSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafSaleSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafSaleSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafSaleSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<SaleSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 특가 상품 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 봄 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafSpringSubMainSmall1BannerRepositoryProvider =
Provider<AafSpringSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafSpringSubMainSmall1BannerRepository 객체를 생성함.
  // AafSpringSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafSpringSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafSpringSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafSpringSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafSpringSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<SpringSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 봄 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 여름 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafSummerSubMainSmall1BannerRepositoryProvider =
Provider<AafSummerSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafSummerSubMainSmall1BannerRepository 객체를 생성함.
  // AafSummerSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafSummerSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafSummerSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafSummerSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafSummerSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<SummerSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 여름 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 가을 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafAutumnSubMainSmall1BannerRepositoryProvider =
Provider<AafAutumnSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafAutumnSubMainSmall1BannerRepository 객체를 생성함.
  // AafAutumnSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafAutumnSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafAutumnSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafAutumnSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafAutumnSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<AutumnSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 가을 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 겨울 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aafWinterSubMainSmall1BannerRepositoryProvider =
Provider<AafWinterSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AafWinterSubMainSmall1BannerRepository 객체를 생성함.
  // AafWinterSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AafWinterSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aafWinterSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aafWinterSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aafWinterSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<WinterSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_6');
});
// ------- 겨울 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝
// ------- 각 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝
