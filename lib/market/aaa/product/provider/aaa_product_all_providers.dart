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
import '../../common/repository/aaa_banner_repository.dart';
import '../repository/aaa_product_repository.dart';


// Firestore로부터 티셔츠 ~ 가디건의 1차 카테고리와 신상 ~ 겨울의 2차 카테고리 상품 정보를 불러오는 각 레퍼지토 인스턴스를 생성하는 프로바이더
// 메인 화면 관련 ProductMainListNotifier용 CategoryProductsRepository Provider
final aaaMainProductRepositoryProvider = Provider<AaaMainCategoryProductsRepository>((ref) {
  return AaaMainCategoryProductsRepository(FirebaseFirestore.instance);
});

// 섹션 더보기 화면 관련 SectionMoreProductListNotifier용 CategoryProductsRepository Provider
final aaaSectionProductRepositoryProvider = Provider<AaaSectionCategoryProductsRepository>((ref) {
  return AaaSectionCategoryProductsRepository(FirebaseFirestore.instance);
});

// ------ 신상, 최고, 할인, 봄, 여름, 가을, 겨울 관련 홈 화면에 보여줄 섹션 부분 - 파이어베이스의 데이터를 불러올 때 사용할 provider 시작
// aaaNewProdFirestoreDataProvider 등의 여러 문서 데이터를 가져오는 FutureProvider는 현재 사용 안되고 있음-추후,사용 가능성이 있어 우선 놧두기!!
// ----- 신상 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aaaNewProductRepositoryProvider = Provider<AaaNewProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaNewProductRepository 객체를 생성
  return AaaNewProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aaaNewProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aaaNewProductRepositoryProvider로부터 AaaNewProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aaaNewProductRepositoryProvider);
  // AaaNewProductRepository 인스턴스의 fetchNewProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchNewProductContents();
});
// ----- 신상 부분 끝

// ----- 최고 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aaaBestProductRepositoryProvider = Provider<AaaBestProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaBestProductRepository 객체를 생성
  return AaaBestProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aaaBestProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aaaBestProductRepositoryProvider로부터 AaaBestProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aaaBestProductRepositoryProvider);
  // AaaBestProductRepository 인스턴스의 fetchBestProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchBestProductContents();
});
// ----- 최고 부분 끝

// ----- 할인 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aaaSaleProductRepositoryProvider = Provider<AaaSaleProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaSaleProductRepository 객체를 생성
  return AaaSaleProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aaaSaleProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aaaSaleProductRepositoryProvider로부터 AaaSaleProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aaaSaleProductRepositoryProvider);
  // AaaSaleProductRepository 인스턴스의 fetchSaleProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchSaleProductContents();
});
// ----- 할인 부분 끝

// ----- 봄 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aaaSpringProductRepositoryProvider =
    Provider<AaaSpringProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaSpringProductRepository 객체를 생성
  return AaaSpringProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aaaSpringProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aaaSpringProductRepositoryProvider로부터 AaaSpringProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aaaSpringProductRepositoryProvider);
  // AaaSpringProductRepository 인스턴스의 fetchSpringProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchSpringProductContents();
});
// ----- 봄 부분 끝

// ----- 여름 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aaaSummerProductRepositoryProvider =
    Provider<AaaSummerProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaSummerProductRepository 객체를 생성
  return AaaSummerProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aaaSummerProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aaaSummerProductRepositoryProvider로부터 AaaSummerProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aaaSummerProductRepositoryProvider);
  // AaaSummerProductRepository 인스턴스의 fetchSummerProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchSummerProductContents();
});
// ----- 여름 부분 끝

// ----- 가을 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aaaAutumnProductRepositoryProvider =
    Provider<AaaAutumnProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaAutumnProductRepository 객체를 생성
  return AaaAutumnProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aaaAutumnProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aaaAutumnProductRepositoryProvider로부터 AaaAutumnProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aaaAutumnProductRepositoryProvider);
  // AaaAutumnProductRepository 인스턴스의 fetchAutumnProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchAutumnProductContents();
});
// ----- 가을 부분 끝

// ----- 겨울 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aaaWinterProductRepositoryProvider =
    Provider<AaaWinterProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaWinterProductRepository 객체를 생성
  return AaaWinterProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aaaWinterProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aaaWinterProductRepositoryProvider로부터 AaaWinterProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aaaWinterProductRepositoryProvider);
  // AaaWinterProductRepository 인스턴스의 fetchWinterProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchWinterProductContents();
});
// ----- 겨울 부분 끝
// ------ 신상, 최고, 할인, 봄, 여름, 가을, 겨울 관련 홈 화면에 보여줄 섹션 부분 - 파이어베이스의 데이터를 불러올 때 사용할 provider 끝

// ------ 블라우스, 가디건, 코트, 청바지, 맨투맨, 니트, 원피스, 패딩, 팬츠, 폴라티, 티셔츠, 스커트 관련 상품 상세 화면에 보여줄 상품 데이터 부분 -파이어베이스의 데이터를 불러올 때 사용할 provider 시작
// 블라우스 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aaaBlouseDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaa2B1', 'Aaa2B2', 'Aaa2B3', 'Aaa2B4', 'Aaa2B5', 'Aaa2B6', 'Aaa2B7'],
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
final aaaCardiganDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': [
      'Aaa12B1',
      'Aaa12B2',
      'Aaa12B3',
      'Aaa12B4',
      'Aaa12B5',
      'Aaa12B6',
      'Aaa12B7'
    ], // 가디건 관련 컬렉션 목록
    'fullPath': fullPath, // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 가디건 끝

// 코트 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aaaCoatDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': [
      'Aaa11B1',
      'Aaa11B2',
      'Aaa11B3',
      'Aaa11B4',
      'Aaa11B5',
      'Aaa11B6',
      'Aaa11B7'
    ], // 코트 관련 컬렉션 목록
    'fullPath': fullPath, // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 코트 끝

// 청바지 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aaaJeanDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaa8B1', 'Aaa8B2', 'Aaa8B3', 'Aaa8B4', 'Aaa8B5', 'Aaa8B6', 'Aaa8B7'],
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
final aaaMtmDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaa3B1', 'Aaa3B2', 'Aaa3B3', 'Aaa3B4', 'Aaa3B5', 'Aaa3B6', 'Aaa3B7'],
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
final aaaNeatDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaa4B1', 'Aaa4B2', 'Aaa4B3', 'Aaa4B4', 'Aaa4B5', 'Aaa4B6', 'Aaa4B7'],
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
final aaaOnepieceDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaa6B1', 'Aaa6B2', 'Aaa6B3', 'Aaa6B4', 'Aaa6B5', 'Aaa6B6', 'Aaa6B7'],
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
final aaaPaedingDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': [
      'Aaa10B1',
      'Aaa10B2',
      'Aaa10B3',
      'Aaa10B4',
      'Aaa10B5',
      'Aaa10B6',
      'Aaa10B7'
    ], // 패딩 관련 컬렉션 목록
    'fullPath': fullPath, // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 패딩 끝

// 팬츠 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aaaPantsDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaa7B1', 'Aaa7B2', 'Aaa7B3', 'Aaa7B4', 'Aaa7B5', 'Aaa7B6', 'Aaa7B7'],
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
final aaaPolaDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaa5B1', 'Aaa5B2', 'Aaa5B3', 'Aaa5B4', 'Aaa5B5', 'Aaa5B6', 'Aaa5B7'],
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
final aaaShirtDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaa1B1', 'Aaa1B2', 'Aaa1B3', 'Aaa1B4', 'Aaa1B5', 'Aaa1B6', 'Aaa1B7'],
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
final aaaSkirtDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aaa9B1', 'Aaa9B2', 'Aaa9B3', 'Aaa9B4', 'Aaa9B5', 'Aaa9B6', 'Aaa9B7'],
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
final aaaShirtMainSmall1BannerRepositoryProvider =
Provider<AaaShirtMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaShirtMainSmall1BannerRepository 객체를 생성함.
  // AaaShirtMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaShirtMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaShirtMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaShirtMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaShirtMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<ShirtMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 티셔츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 블라우스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaBlouseMainSmall1BannerRepositoryProvider =
Provider<AaaBlouseMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaBlouseMainSmall1BannerRepository 객체를 생성함.
  // AaaBlouseMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaBlouseMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaBlouseMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaBlouseMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaBlouseMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<BlouseMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 블라우스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 맨투맨 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaMtmMainSmall1BannerRepositoryProvider =
Provider<AaaMtmMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaMtmMainSmall1BannerRepository 객체를 생성함.
  // AaaMtmMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaMtmMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaMtmMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaMtmMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaMtmMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<MtmMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 맨투맨 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 니트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaNeatMainSmall1BannerRepositoryProvider =
Provider<AaaNeatMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaNeatMainSmall1BannerRepository 객체를 생성함.
  // AaaNeatMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaNeatMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaNeatMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaNeatMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaNeatMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<NeatMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 니트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 폴라티 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaPolaMainSmall1BannerRepositoryProvider =
Provider<AaaPolaMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaPolaMainSmall1BannerRepository 객체를 생성함.
  // AaaPolaMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaPolaMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaPolaMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaPolaMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaPolaMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<PolaMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 폴라티 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 원피스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaOnepieceMainSmall1BannerRepositoryProvider =
Provider<AaaOnepieceMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaOnepieceMainSmall1BannerRepository 객체를 생성함.
  // AaaOnepieceMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaOnepieceMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaOnepieceMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaOnepieceMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaOnepieceMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<OnepieceMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 원피스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 팬츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaPantsMainSmall1BannerRepositoryProvider =
Provider<AaaPantsMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaPantsMainSmall1BannerRepository 객체를 생성함.
  // AaaPantsMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaPantsMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaPantsMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaPantsMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaPantsMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<PantsMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 팬츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 청바지 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaJeanMainSmall1BannerRepositoryProvider =
Provider<AaaJeanMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaJeanMainSmall1BannerRepository 객체를 생성함.
  // AaaJeanMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaJeanMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaJeanMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaJeanMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaJeanMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<JeanMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 청바지 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 스커트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaSkirtMainSmall1BannerRepositoryProvider =
Provider<AaaSkirtMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaSkirtMainSmall1BannerRepository 객체를 생성함.
  // AaaSkirtMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaSkirtMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaSkirtMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaSkirtMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaSkirtMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<SkirtMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 스커트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 패딩 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaPaedingMainSmall1BannerRepositoryProvider =
Provider<AaaPaedingMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaPaedingMainSmall1BannerRepository 객체를 생성함.
  // AaaPaedingMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaPaedingMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaPaedingMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaPaedingMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaPaedingMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<BlouseMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 패딩 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 코트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaCoatMainSmall1BannerRepositoryProvider =
Provider<AaaCoatMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaCoatMainSmall1BannerRepository 객체를 생성함.
  // AaaCoatMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaCoatMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaCoatMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaCoatMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaCoatMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<CoatMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 코트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 가디건 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaCardiganMainSmall1BannerRepositoryProvider =
Provider<AaaCardiganMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaCardiganMainSmall1BannerRepository 객체를 생성함.
  // AaaCardiganMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaCardiganMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaCardiganMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaCardiganMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaCardiganMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<CardiganMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 가디건 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝
// ------ 블라우스, 가디건, 코트, 청바지, 맨투맨, 니트, 원피스, 패딩, 팬츠, 폴라티, 티셔츠, 스커트 관련 2차 메인 화면에 보여줄 소배너 부분 -파이어베이스의 데이터를 불러올 때 사용할 provider 끝

// ------- 각 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// ------- 신상 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaNewSubMainSmall1BannerRepositoryProvider =
Provider<AaaNewSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaNewSubMainSmall1BannerRepository 객체를 생성함.
  // AaaNewSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaNewSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaNewSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaNewSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaNewSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<NewSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 신상 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 스테디 셀러 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaBestSubMainSmall1BannerRepositoryProvider =
Provider<AaaBestSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaBestSubMainSmall1BannerRepository 객체를 생성함.
  // AaaBestSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaBestSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaBestSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaBestSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaBestSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<BestSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 스테디 셀러 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 특가 상품 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaSaleSubMainSmall1BannerRepositoryProvider =
Provider<AaaSaleSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaSaleSubMainSmall1BannerRepository 객체를 생성함.
  // AaaSaleSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaSaleSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaSaleSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaSaleSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaSaleSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<SaleSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 특가 상품 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 봄 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaSpringSubMainSmall1BannerRepositoryProvider =
Provider<AaaSpringSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaSpringSubMainSmall1BannerRepository 객체를 생성함.
  // AaaSpringSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaSpringSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaSpringSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaSpringSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaSpringSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<SpringSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 봄 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 여름 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaSummerSubMainSmall1BannerRepositoryProvider =
Provider<AaaSummerSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaSummerSubMainSmall1BannerRepository 객체를 생성함.
  // AaaSummerSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaSummerSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaSummerSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaSummerSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaSummerSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<SummerSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 여름 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 가을 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaAutumnSubMainSmall1BannerRepositoryProvider =
Provider<AaaAutumnSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaAutumnSubMainSmall1BannerRepository 객체를 생성함.
  // AaaAutumnSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaAutumnSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaAutumnSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaAutumnSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaAutumnSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<AutumnSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 가을 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 겨울 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaaWinterSubMainSmall1BannerRepositoryProvider =
Provider<AaaWinterSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaaWinterSubMainSmall1BannerRepository 객체를 생성함.
  // AaaWinterSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaaWinterSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaaWinterSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaaWinterSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaaWinterSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<WinterSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 겨울 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝
// ------- 각 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝
