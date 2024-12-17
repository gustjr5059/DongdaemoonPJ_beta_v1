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
import '../../common/repository/aao_banner_repository.dart';
import '../repository/aao_product_repository.dart';


// Firestore로부터 티셔츠 ~ 가디건의 1차 카테고리와 신상 ~ 겨울의 2차 카테고리 상품 정보를 불러오는 각 레퍼지토 인스턴스를 생성하는 프로바이더
// 메인 화면 관련 ProductMainListNotifier용 CategoryProductsRepository Provider
final aaoMainProductRepositoryProvider = Provider<AaoMainCategoryProductsRepository>((ref) {
  return AaoMainCategoryProductsRepository(FirebaseFirestore.instance);
});

// 섹션 더보기 화면 관련 SectionMoreProductListNotifier용 CategoryProductsRepository Provider
final aaoSectionProductRepositoryProvider = Provider<AaoSectionCategoryProductsRepository>((ref) {
  return AaoSectionCategoryProductsRepository(FirebaseFirestore.instance);
});

// ------ 신상, 최고, 할인, 봄, 여름, 가을, 겨울 관련 홈 화면에 보여줄 섹션 부분 - 파이어베이스의 데이터를 불러올 때 사용할 provider 시작
// aaoNewProdFirestoreDataProvider 등의 여러 문서 데이터를 가져오는 FutureProvider는 현재 사용 안되고 있음-추후,사용 가능성이 있어 우선 놧두기!!
// ----- 신상 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aaoNewProductRepositoryProvider = Provider<AaoNewProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoNewProductRepository 객체를 생성
  return AaoNewProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aaoNewProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aaoNewProductRepositoryProvider로부터 AaoNewProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aaoNewProductRepositoryProvider);
  // AaoNewProductRepository 인스턴스의 fetchNewProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchNewProductContents();
});
// ----- 신상 부분 끝

// ----- 최고 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aaoBestProductRepositoryProvider = Provider<AaoBestProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoBestProductRepository 객체를 생성
  return AaoBestProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aaoBestProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aaoBestProductRepositoryProvider로부터 AaoBestProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aaoBestProductRepositoryProvider);
  // AaoBestProductRepository 인스턴스의 fetchBestProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchBestProductContents();
});
// ----- 최고 부분 끝

// ----- 할인 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aaoSaleProductRepositoryProvider = Provider<AaoSaleProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoSaleProductRepository 객체를 생성
  return AaoSaleProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aaoSaleProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aaoSaleProductRepositoryProvider로부터 AaoSaleProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aaoSaleProductRepositoryProvider);
  // AaoSaleProductRepository 인스턴스의 fetchSaleProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchSaleProductContents();
});
// ----- 할인 부분 끝

// ----- 봄 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aaoSpringProductRepositoryProvider =
    Provider<AaoSpringProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoSpringProductRepository 객체를 생성
  return AaoSpringProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aaoSpringProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aaoSpringProductRepositoryProvider로부터 AaoSpringProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aaoSpringProductRepositoryProvider);
  // AaoSpringProductRepository 인스턴스의 fetchSpringProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchSpringProductContents();
});
// ----- 봄 부분 끝

// ----- 여름 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aaoSummerProductRepositoryProvider =
    Provider<AaoSummerProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoSummerProductRepository 객체를 생성
  return AaoSummerProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aaoSummerProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aaoSummerProductRepositoryProvider로부터 AaoSummerProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aaoSummerProductRepositoryProvider);
  // AaoSummerProductRepository 인스턴스의 fetchSummerProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchSummerProductContents();
});
// ----- 여름 부분 끝

// ----- 가을 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aaoAutumnProductRepositoryProvider =
    Provider<AaoAutumnProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoAutumnProductRepository 객체를 생성
  return AaoAutumnProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aaoAutumnProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aaoAutumnProductRepositoryProvider로부터 AaoAutumnProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aaoAutumnProductRepositoryProvider);
  // AaoAutumnProductRepository 인스턴스의 fetchAutumnProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchAutumnProductContents();
});
// ----- 가을 부분 끝

// ----- 겨울 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final aaoWinterProductRepositoryProvider =
    Provider<AaoWinterProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoWinterProductRepository 객체를 생성
  return AaoWinterProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final aaoWinterProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // aaoWinterProductRepositoryProvider로부터 AaoWinterProductRepository 인스턴스를 가져옴
  final repository = ref.watch(aaoWinterProductRepositoryProvider);
  // AaoWinterProductRepository 인스턴스의 fetchWinterProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchWinterProductContents();
});
// ----- 겨울 부분 끝
// ------ 신상, 최고, 할인, 봄, 여름, 가을, 겨울 관련 홈 화면에 보여줄 섹션 부분 - 파이어베이스의 데이터를 불러올 때 사용할 provider 끝

// ------ 블라우스, 가디건, 코트, 청바지, 맨투맨, 니트, 원피스, 패딩, 팬츠, 폴라티, 티셔츠, 스커트 관련 상품 상세 화면에 보여줄 상품 데이터 부분 -파이어베이스의 데이터를 불러올 때 사용할 provider 시작
// 블라우스 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aaoBlouseDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aao2B1', 'Aao2B2', 'Aao2B3', 'Aao2B4', 'Aao2B5', 'Aao2B6', 'Aao2B7'],
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
final aaoCardiganDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': [
      'Aao12B1',
      'Aao12B2',
      'Aao12B3',
      'Aao12B4',
      'Aao12B5',
      'Aao12B6',
      'Aao12B7'
    ], // 가디건 관련 컬렉션 목록
    'fullPath': fullPath, // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 가디건 끝

// 코트 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aaoCoatDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': [
      'Aao11B1',
      'Aao11B2',
      'Aao11B3',
      'Aao11B4',
      'Aao11B5',
      'Aao11B6',
      'Aao11B7'
    ], // 코트 관련 컬렉션 목록
    'fullPath': fullPath, // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 코트 끝

// 청바지 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aaoJeanDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aao8B1', 'Aao8B2', 'Aao8B3', 'Aao8B4', 'Aao8B5', 'Aao8B6', 'Aao8B7'],
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
final aaoMtmDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aao3B1', 'Aao3B2', 'Aao3B3', 'Aao3B4', 'Aao3B5', 'Aao3B6', 'Aao3B7'],
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
final aaoNeatDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aao4B1', 'Aao4B2', 'Aao4B3', 'Aao4B4', 'Aao4B5', 'Aao4B6', 'Aao4B7'],
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
final aaoOnepieceDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aao6B1', 'Aao6B2', 'Aao6B3', 'Aao6B4', 'Aao6B5', 'Aao6B6', 'Aao6B7'],
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
final aaoPaedingDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': [
      'Aao10B1',
      'Aao10B2',
      'Aao10B3',
      'Aao10B4',
      'Aao10B5',
      'Aao10B6',
      'Aao10B7'
    ], // 패딩 관련 컬렉션 목록
    'fullPath': fullPath, // 전체 경로 설정
  };
  return ref.watch(productDetailFirestoreDataProvider(params)
      .future); // 상품 상세 데이터를 비동기적으로 반환
});
// 패딩 끝

// 팬츠 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final aaoPantsDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aao7B1', 'Aao7B2', 'Aao7B3', 'Aao7B4', 'Aao7B5', 'Aao7B6', 'Aao7B7'],
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
final aaoPolaDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aao5B1', 'Aao5B2', 'Aao5B3', 'Aao5B4', 'Aao5B5', 'Aao5B6', 'Aao5B7'],
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
final aaoShirtDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aao1B1', 'Aao1B2', 'Aao1B3', 'Aao1B4', 'Aao1B5', 'Aao1B6', 'Aao1B7'],
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
final aaoSkirtDetailProdFirestoreDataProvider =
    FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  final params = {
    'collections': ['Aao9B1', 'Aao9B2', 'Aao9B3', 'Aao9B4', 'Aao9B5', 'Aao9B6', 'Aao9B7'],
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
final aaoShirtMainSmall1BannerRepositoryProvider =
Provider<AaoShirtMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoShirtMainSmall1BannerRepository 객체를 생성함.
  // AaoShirtMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoShirtMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoShirtMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoShirtMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoShirtMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<ShirtMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 티셔츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 블라우스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoBlouseMainSmall1BannerRepositoryProvider =
Provider<AaoBlouseMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoBlouseMainSmall1BannerRepository 객체를 생성함.
  // AaoBlouseMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoBlouseMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoBlouseMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoBlouseMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoBlouseMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<BlouseMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 블라우스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 맨투맨 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoMtmMainSmall1BannerRepositoryProvider =
Provider<AaoMtmMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoMtmMainSmall1BannerRepository 객체를 생성함.
  // AaoMtmMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoMtmMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoMtmMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoMtmMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoMtmMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<MtmMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 맨투맨 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 니트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoNeatMainSmall1BannerRepositoryProvider =
Provider<AaoNeatMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoNeatMainSmall1BannerRepository 객체를 생성함.
  // AaoNeatMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoNeatMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoNeatMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoNeatMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoNeatMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<NeatMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 니트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 폴라티 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoPolaMainSmall1BannerRepositoryProvider =
Provider<AaoPolaMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoPolaMainSmall1BannerRepository 객체를 생성함.
  // AaoPolaMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoPolaMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoPolaMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoPolaMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoPolaMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<PolaMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 폴라티 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 원피스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoOnepieceMainSmall1BannerRepositoryProvider =
Provider<AaoOnepieceMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoOnepieceMainSmall1BannerRepository 객체를 생성함.
  // AaoOnepieceMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoOnepieceMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoOnepieceMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoOnepieceMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoOnepieceMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<OnepieceMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 원피스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 팬츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoPantsMainSmall1BannerRepositoryProvider =
Provider<AaoPantsMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoPantsMainSmall1BannerRepository 객체를 생성함.
  // AaoPantsMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoPantsMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoPantsMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoPantsMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoPantsMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<PantsMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 팬츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 청바지 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoJeanMainSmall1BannerRepositoryProvider =
Provider<AaoJeanMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoJeanMainSmall1BannerRepository 객체를 생성함.
  // AaoJeanMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoJeanMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoJeanMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoJeanMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoJeanMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<JeanMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 청바지 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 스커트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoSkirtMainSmall1BannerRepositoryProvider =
Provider<AaoSkirtMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoSkirtMainSmall1BannerRepository 객체를 생성함.
  // AaoSkirtMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoSkirtMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoSkirtMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoSkirtMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoSkirtMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<SkirtMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 스커트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 패딩 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoPaedingMainSmall1BannerRepositoryProvider =
Provider<AaoPaedingMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoPaedingMainSmall1BannerRepository 객체를 생성함.
  // AaoPaedingMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoPaedingMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoPaedingMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoPaedingMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoPaedingMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<BlouseMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 패딩 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 코트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoCoatMainSmall1BannerRepositoryProvider =
Provider<AaoCoatMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoCoatMainSmall1BannerRepository 객체를 생성함.
  // AaoCoatMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoCoatMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoCoatMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoCoatMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoCoatMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<CoatMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 코트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 가디건 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoCardiganMainSmall1BannerRepositoryProvider =
Provider<AaoCardiganMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoCardiganMainSmall1BannerRepository 객체를 생성함.
  // AaoCardiganMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoCardiganMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoCardiganMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoCardiganMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoCardiganMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<CardiganMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 가디건 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝
// ------ 블라우스, 가디건, 코트, 청바지, 맨투맨, 니트, 원피스, 패딩, 팬츠, 폴라티, 티셔츠, 스커트 관련 2차 메인 화면에 보여줄 소배너 부분 -파이어베이스의 데이터를 불러올 때 사용할 provider 끝

// ------- 각 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// ------- 신상 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoNewSubMainSmall1BannerRepositoryProvider =
Provider<AaoNewSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoNewSubMainSmall1BannerRepository 객체를 생성함.
  // AaoNewSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoNewSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoNewSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoNewSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoNewSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<NewSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 신상 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 스테디 셀러 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoBestSubMainSmall1BannerRepositoryProvider =
Provider<AaoBestSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoBestSubMainSmall1BannerRepository 객체를 생성함.
  // AaoBestSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoBestSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoBestSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoBestSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoBestSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<BestSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 스테디 셀러 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 특가 상품 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoSaleSubMainSmall1BannerRepositoryProvider =
Provider<AaoSaleSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoSaleSubMainSmall1BannerRepository 객체를 생성함.
  // AaoSaleSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoSaleSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoSaleSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoSaleSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoSaleSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<SaleSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 특가 상품 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 봄 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoSpringSubMainSmall1BannerRepositoryProvider =
Provider<AaoSpringSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoSpringSubMainSmall1BannerRepository 객체를 생성함.
  // AaoSpringSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoSpringSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoSpringSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoSpringSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoSpringSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<SpringSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 봄 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 여름 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoSummerSubMainSmall1BannerRepositoryProvider =
Provider<AaoSummerSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoSummerSubMainSmall1BannerRepository 객체를 생성함.
  // AaoSummerSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoSummerSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoSummerSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoSummerSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoSummerSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<SummerSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 여름 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 가을 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoAutumnSubMainSmall1BannerRepositoryProvider =
Provider<AaoAutumnSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoAutumnSubMainSmall1BannerRepository 객체를 생성함.
  // AaoAutumnSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoAutumnSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoAutumnSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoAutumnSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoAutumnSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<AutumnSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 가을 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 겨울 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final aaoWinterSubMainSmall1BannerRepositoryProvider =
Provider<AaoWinterSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AaoWinterSubMainSmall1BannerRepository 객체를 생성함.
  // AaoWinterSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AaoWinterSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final aaoWinterSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 aaoWinterSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(aaoWinterSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<WinterSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_15');
});
// ------- 겨울 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝
// ------- 각 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝
