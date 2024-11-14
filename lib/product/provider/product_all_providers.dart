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
import '../../common/model/banner_model.dart';
import '../../common/repository/banner_repository.dart';
import '../layout/product_body_parts_layout.dart';
import '../model/product_model.dart'; // 상품 데이터 모델 정의 파일의 임포트
// 제품 데이터를 Firestore 데이터베이스에서 가져오는 로직이 구현된 저장소 클래스를 임포트합니다.
// 이 레포지토리는 Firestore와의 직접적인 상호작용을 캡슐화하며, 데이터를 가져오거나 업데이트하는 메서드를 제공합니다.
import '../repository/product_repository.dart'; // 상품 데이터를 Firestore에서 가져오는 로직이 구현된 레포지토리 클래스의 임포트


// Firestore로부터 티셔츠 ~ 가디건의 1차 카테고리와 신상 ~ 겨울의 2차 카테고리 상품 정보를 불러오는 각 레퍼지토 인스턴스를 생성하는 프로바이더
// 메인 화면 관련 ProductMainListNotifier용 CategoryProductsRepository Provider
final mainProductRepositoryProvider = Provider<MainCategoryProductsRepository>((ref) {
  return MainCategoryProductsRepository(FirebaseFirestore.instance);
});

// 섹션 더보기 화면 관련 SectionMoreProductListNotifier용 CategoryProductsRepository Provider
final sectionProductRepositoryProvider = Provider<SectionCategoryProductsRepository>((ref) {
  return SectionCategoryProductsRepository(FirebaseFirestore.instance);
});

// ------ 신상, 최고, 할인, 봄, 여름, 가을, 겨울 관련 홈 화면에 보여줄 섹션 부분 - 파이어베이스의 데이터를 불러올 때 사용할 provider 시작
// newProdFirestoreDataProvider 등의 여러 문서 데이터를 가져오는 FutureProvider는 현재 사용 안되고 있음-추후,사용 가능성이 있어 우선 놧두기!!
// ----- 신상 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final newProductRepositoryProvider = Provider<NewProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 NewProductRepository 객체를 생성
  return NewProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final newProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // newProductRepositoryProvider로부터 NewProductRepository 인스턴스를 가져옴
  final repository = ref.watch(newProductRepositoryProvider);
  // NewProductRepository 인스턴스의 fetchNewProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchNewProductContents();
});
// ----- 신상 부분 끝

// ----- 최고 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final bestProductRepositoryProvider = Provider<BestProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 BestProductRepository 객체를 생성
  return BestProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final bestProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // bestProductRepositoryProvider로부터 BestProductRepository 인스턴스를 가져옴
  final repository = ref.watch(bestProductRepositoryProvider);
  // BestProductRepository 인스턴스의 fetchBestProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchBestProductContents();
});
// ----- 최고 부분 끝

// ----- 할인 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final saleProductRepositoryProvider = Provider<SaleProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 SaleProductRepository 객체를 생성
  return SaleProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final saleProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // saleProductRepositoryProvider로부터 SaleProductRepository 인스턴스를 가져옴
  final repository = ref.watch(saleProductRepositoryProvider);
  // SaleProductRepository 인스턴스의 fetchSaleProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchSaleProductContents();
});
// ----- 할인 부분 끝

// ----- 봄 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final springProductRepositoryProvider =
    Provider<SpringProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 SpringProductRepository 객체를 생성
  return SpringProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final springProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // springProductRepositoryProvider로부터 SpringProductRepository 인스턴스를 가져옴
  final repository = ref.watch(springProductRepositoryProvider);
  // SpringProductRepository 인스턴스의 fetchSpringProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchSpringProductContents();
});
// ----- 봄 부분 끝

// ----- 여름 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final summerProductRepositoryProvider =
    Provider<SummerProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 SummerProductRepository 객체를 생성
  return SummerProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final summerProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // summerProductRepositoryProvider로부터 SummerProductRepository 인스턴스를 가져옴
  final repository = ref.watch(summerProductRepositoryProvider);
  // SummerProductRepository 인스턴스의 fetchSummerProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchSummerProductContents();
});
// ----- 여름 부분 끝

// ----- 가을 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final autumnProductRepositoryProvider =
    Provider<AutumnProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AutumnProductRepository 객체를 생성
  return AutumnProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final autumnProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // autumnProductRepositoryProvider로부터 AutumnProductRepository 인스턴스를 가져옴
  final repository = ref.watch(autumnProductRepositoryProvider);
  // AutumnProductRepository 인스턴스의 fetchAutumnProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchAutumnProductContents();
});
// ----- 가을 부분 끝

// ----- 겨울 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final winterProductRepositoryProvider =
    Provider<WinterProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 WinterProductRepository 객체를 생성
  return WinterProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final winterProdFirestoreDataProvider =
    FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // winterProductRepositoryProvider로부터 WinterProductRepository 인스턴스를 가져옴
  final repository = ref.watch(winterProductRepositoryProvider);
  // WinterProductRepository 인스턴스의 fetchWinterProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchWinterProductContents();
});
// ----- 겨울 부분 끝
// ------ 신상, 최고, 할인, 봄, 여름, 가을, 겨울 관련 홈 화면에 보여줄 섹션 부분 - 파이어베이스의 데이터를 불러올 때 사용할 provider 끝

// ------ 블라우스, 가디건, 코트, 청바지, 맨투맨, 니트, 원피스, 패딩, 팬츠, 폴라티, 티셔츠, 스커트 관련 2차 메인 화면과
// 섹션 더보기 화면(신상, 최고, 할인, 봄, 여름, 가을, 겨울), 상품 상세 화면에 보여줄 상품 데이터 부분 -파이어베이스의 데이터를 불러올 때 사용할 provider 시작
// 2차 메인 화면과 섹션 더보기 화면, 상품 상세 화면 부분에 적용 1차 provider(범용성)-파이어베이스의 데이터를 불러올 때 사용할 provider
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance; // FirebaseFirestore 인스턴스를 반환
});
// 2차 메인 화면과 섹션 더보기 화면 , 상품 상세 화면 부분에 적용 2차 provider(범용성)-파이어베이스의 데이터를 불러올 때 사용할 provider
final productRepositoryProvider =
    Provider.family<GeneralProductRepository<ProductContent>, List<String>>(
        (ref, collections) {
  return GeneralProductRepository<ProductContent>(
      ref.watch(firebaseFirestoreProvider),
      collections); // 주어진 컬렉션 목록을 이용하여 GeneralProductRepository 인스턴스를 반환
});
// ------ 블라우스, 가디건, 코트, 청바지, 맨투맨, 니트, 원피스, 패딩, 팬츠, 폴라티, 티셔츠, 스커트 관련 2차 메인 화면과
// 섹션 더보기 화면(신상, 최고, 할인, 봄, 여름, 가을, 겨울), 상품 상세 화면에 보여줄 상품 데이터 부분 -파이어베이스의 데이터를 불러올 때 사용할 provider 끝

// ------ 블라우스, 가디건, 코트, 청바지, 맨투맨, 니트, 원피스, 패딩, 팬츠, 폴라티, 티셔츠, 스커트 관련 상품 상세 화면에 보여줄 상품 데이터 부분 -파이어베이스의 데이터를 불러올 때 사용할 provider 시작
// 상품 상세 화면 데이터를 가져오는 FutureProvider(범용성)
final productDetailFirestoreDataProvider =
    FutureProvider.family<ProductContent, Map<String, dynamic>>(
        (ref, params) async {
  final collections = params['collections'] as List<String>; // 필요한 컬렉션 목록을 설정
  final fullPath = params['fullPath'] as String; // 전체 경로 설정
  final repository = ref.watch(productRepositoryProvider(
      collections)); // repository provider를 통해 인스턴스 생성
  return repository.getProduct(fullPath); // 지정된 경로의 상품 데이터 반환
});

// 블라우스 시작
// Firestore로부터 상품 정보를 가져오는 프로바이더
final blouseDetailProdFirestoreDataProvider =
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
final cardiganDetailProdFirestoreDataProvider =
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
final coatDetailProdFirestoreDataProvider =
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
final jeanDetailProdFirestoreDataProvider =
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
final mtmDetailProdFirestoreDataProvider =
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
final neatDetailProdFirestoreDataProvider =
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
final onepieceDetailProdFirestoreDataProvider =
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
final paedingDetailProdFirestoreDataProvider =
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
final pantsDetailProdFirestoreDataProvider =
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
final polaDetailProdFirestoreDataProvider =
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
final shirtDetailProdFirestoreDataProvider =
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
final skirtDetailProdFirestoreDataProvider =
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
final shirtMainSmall1BannerRepositoryProvider =
Provider<ShirtMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ShirtMainSmall1BannerRepository 객체를 생성함.
  // ShirtMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return ShirtMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final shirtMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 shirtMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(shirtMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<ShirtMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 티셔츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 블라우스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final blouseMainSmall1BannerRepositoryProvider =
Provider<BlouseMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 BlouseMainSmall1BannerRepository 객체를 생성함.
  // BlouseMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return BlouseMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final blouseMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 blouseMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(blouseMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<BlouseMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 블라우스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 맨투맨 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final mtmMainSmall1BannerRepositoryProvider =
Provider<MtmMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 MtmMainSmall1BannerRepository 객체를 생성함.
  // MtmMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return MtmMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final mtmMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 mtmMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(mtmMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<MtmMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 맨투맨 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 니트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final neatMainSmall1BannerRepositoryProvider =
Provider<NeatMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 NeatMainSmall1BannerRepository 객체를 생성함.
  // NeatMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return NeatMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final neatMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 neatMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(neatMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<NeatMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 니트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 폴라티 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final polaMainSmall1BannerRepositoryProvider =
Provider<PolaMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 PolaMainSmall1BannerRepository 객체를 생성함.
  // PolaMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return PolaMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final polaMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 polaMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(polaMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<PolaMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 폴라티 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 원피스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final onepieceMainSmall1BannerRepositoryProvider =
Provider<OnepieceMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 OnepieceMainSmall1BannerRepository 객체를 생성함.
  // OnepieceMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return OnepieceMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final onepieceMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 onepieceMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(onepieceMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<OnepieceMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 원피스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 팬츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final pantsMainSmall1BannerRepositoryProvider =
Provider<PantsMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 PantsMainSmall1BannerRepository 객체를 생성함.
  // PantsMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return PantsMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final pantsMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 pantsMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(pantsMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<PantsMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 팬츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 청바지 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final jeanMainSmall1BannerRepositoryProvider =
Provider<JeanMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 JeanMainSmall1BannerRepository 객체를 생성함.
  // JeanMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return JeanMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final jeanMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 jeanMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(jeanMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<JeanMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 청바지 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 스커트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final skirtMainSmall1BannerRepositoryProvider =
Provider<SkirtMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 SkirtMainSmall1BannerRepository 객체를 생성함.
  // SkirtMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return SkirtMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final skirtMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 skirtMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(skirtMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<SkirtMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 스커트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 패딩 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final paedingMainSmall1BannerRepositoryProvider =
Provider<PaedingMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 PaedingMainSmall1BannerRepository 객체를 생성함.
  // PaedingMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return PaedingMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final paedingMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 paedingMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(paedingMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<BlouseMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 패딩 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 코트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final coatMainSmall1BannerRepositoryProvider =
Provider<CoatMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 CoatMainSmall1BannerRepository 객체를 생성함.
  // CoatMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return CoatMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final coatMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 coatMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(coatMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<CoatMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 코트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 가디건 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final cardiganMainSmall1BannerRepositoryProvider =
Provider<CardiganMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 CardiganMainSmall1BannerRepository 객체를 생성함.
  // CardiganMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return CardiganMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final cardiganMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 cardiganMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(cardiganMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<CardiganMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 가디건 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝
// ------ 블라우스, 가디건, 코트, 청바지, 맨투맨, 니트, 원피스, 패딩, 팬츠, 폴라티, 티셔츠, 스커트 관련 2차 메인 화면에 보여줄 소배너 부분 -파이어베이스의 데이터를 불러올 때 사용할 provider 끝


// ------- 마이페이지 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final profileMainSmall1BannerRepositoryProvider =
Provider<ProfileMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ProfileMainSmall1BannerRepository 객체를 생성함.
  // ProfileMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return ProfileMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final profileMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 profileMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(profileMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<ProfileMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 마이페이지 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 각 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작

// ------- 신상 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final newSubMainSmall1BannerRepositoryProvider =
Provider<NewSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 NewSubMainSmall1BannerRepository 객체를 생성함.
  // NewSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return NewSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final newSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 newSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(newSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<NewSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 신상 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 스테디 셀러 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final bestSubMainSmall1BannerRepositoryProvider =
Provider<BestSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 BestSubMainSmall1BannerRepository 객체를 생성함.
  // BestSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return BestSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final bestSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 bestSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(bestSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<BestSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 스테디 셀러 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 특가 상품 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final saleSubMainSmall1BannerRepositoryProvider =
Provider<SaleSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 SaleSubMainSmall1BannerRepository 객체를 생성함.
  // SaleSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return SaleSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final saleSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 saleSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(saleSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<SaleSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 특가 상품 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 봄 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final springSubMainSmall1BannerRepositoryProvider =
Provider<SpringSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 SpringSubMainSmall1BannerRepository 객체를 생성함.
  // SpringSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return SpringSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final springSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 springSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(springSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<SpringSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 봄 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 여름 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final summerSubMainSmall1BannerRepositoryProvider =
Provider<SummerSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 SummerSubMainSmall1BannerRepository 객체를 생성함.
  // SummerSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return SummerSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final summerSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 summerSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(summerSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<SummerSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 여름 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 가을 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final autumnSubMainSmall1BannerRepositoryProvider =
Provider<AutumnSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AutumnSubMainSmall1BannerRepository 객체를 생성함.
  // AutumnSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return AutumnSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final autumnSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 autumnSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(autumnSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<AutumnSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 가을 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 겨울 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작
// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final winterSubMainSmall1BannerRepositoryProvider =
Provider<WinterSubMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 WinterSubMainSmall1BannerRepository 객체를 생성함.
  // WinterSubMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return WinterSubMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final winterSubMainSmall1BannerImagesProvider =
FutureProvider<List<AllSmallBannerImage>>((ref) async {
  // 위에서 정의한 winterSubMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(winterSubMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImagesAndLink 메소드는 배너 이미지 정보를 포함하는 List<WinterSubMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImagesAndLink('banner_1');
});
// ------- 겨울 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 각 섹션 더보기 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// 상품 상세 화면 내 상품 정보등의 탭 화면 내 데이터 처리 로직인 ProductDtTabRepository 인스턴스 생성 프로바이더
final productDtTabRepositoryProvider = Provider<ProductDtTabRepository>((ref) {
  return ProductDtTabRepository(FirebaseFirestore.instance);
});