
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


// ------ 신상, 최고, 할인, 봄, 여름, 가을, 겨울 관련 홈 화면에 보여줄 섹션 부분 - 파이어베이스의 데이터를 불러올 때 사용할 provider 시작
// newProdFirestoreDataProvider 등의 여러 문서 데이터를 가져오는 FutureProvider는 현재 사용 안되고 있음-추후,사용 가능성이 있어 우선 놧두기!!

// ----- 신상 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final newProductRepositoryProvider = Provider<NewProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 NewProductRepository 객체를 생성
  return NewProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final newProdFirestoreDataProvider = FutureProvider.autoDispose<List<ProductContent>>((ref) async {
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
final bestProdFirestoreDataProvider = FutureProvider.autoDispose<List<ProductContent>>((ref) async {
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
final saleProdFirestoreDataProvider = FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // saleProductRepositoryProvider로부터 SaleProductRepository 인스턴스를 가져옴
  final repository = ref.watch(saleProductRepositoryProvider);
  // SaleProductRepository 인스턴스의 fetchSaleProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchSaleProductContents();
});
// ----- 할인 부분 끝

// ----- 봄 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final springProductRepositoryProvider = Provider<SpringProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 SpringProductRepository 객체를 생성
  return SpringProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final springProdFirestoreDataProvider = FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // springProductRepositoryProvider로부터 SpringProductRepository 인스턴스를 가져옴
  final repository = ref.watch(springProductRepositoryProvider);
  // SpringProductRepository 인스턴스의 fetchSpringProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchSpringProductContents();
});
// ----- 봄 부분 끝

// ----- 여름 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final summerProductRepositoryProvider = Provider<SummerProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 SummerProductRepository 객체를 생성
  return SummerProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final summerProdFirestoreDataProvider = FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // summerProductRepositoryProvider로부터 SummerProductRepository 인스턴스를 가져옴
  final repository = ref.watch(summerProductRepositoryProvider);
  // SummerProductRepository 인스턴스의 fetchSummerProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchSummerProductContents();
});
// ----- 여름 부분 끝

// ----- 가을 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final autumnProductRepositoryProvider = Provider<AutumnProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 AutumnProductRepository 객체를 생성
  return AutumnProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final autumnProdFirestoreDataProvider = FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // autumnProductRepositoryProvider로부터 AutumnProductRepository 인스턴스를 가져옴
  final repository = ref.watch(autumnProductRepositoryProvider);
  // AutumnProductRepository 인스턴스의 fetchAutumnProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchAutumnProductContents();
});
// ----- 가을 부분 끝

// ----- 겨울 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final winterProductRepositoryProvider = Provider<WinterProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 WinterProductRepository 객체를 생성
  return WinterProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 여러 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final winterProdFirestoreDataProvider = FutureProvider.autoDispose<List<ProductContent>>((ref) async {
  // winterProductRepositoryProvider로부터 WinterProductRepository 인스턴스를 가져옴
  final repository = ref.watch(winterProductRepositoryProvider);
  // WinterProductRepository 인스턴스의 fetchWinterProductContents 메서드를 호출하여 상품 데이터를 가져옴
  return repository.fetchWinterProductContents();
});
// ----- 겨울 부분 끝

// ------ 신상, 최고, 할인, 봄, 여름, 가을, 겨울 관련 홈 화면에 보여줄 섹션 부분 - 파이어베이스의 데이터를 불러올 때 사용할 provider 끝


// ------ 블라우스, 가디건, 코트, 청바지, 맨투맨, 니트, 원피스, 패딩, 팬츠, 폴라티, 티셔츠, 스커트
// 관련 상세 화면 부분에 적용-파이어베이스의 데이터를 불러올 때 사용할 provider 시작
// ----- 블라우스 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final blouseProductRepositoryProvider = Provider<BlouseProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ProductRepository 객체를 생성
  return BlouseProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 단일 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final blouseProdDetailFirestoreDataProvider = FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  // 상품 레포지토리 프로바이더를 통해 생성된 레포지토리 객체의 참조를 얻음
  final repository = ref.watch(blouseProductRepositoryProvider);
  // 레포지토리의 getProduct 메소드를 사용하여 특정 문서의 상품 정보를 가져옴
  return repository.getProduct(fullPath);
});
// ----- 블라우스 부분 끝

// ----- 가디건 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final cardiganProductRepositoryProvider = Provider<CardiganProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ProductRepository 객체를 생성
  return CardiganProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 단일 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final cardiganProdDetailFirestoreDataProvider = FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  // 상품 레포지토리 프로바이더를 통해 생성된 레포지토리 객체의 참조를 얻음
  final repository = ref.watch(cardiganProductRepositoryProvider);
  // 레포지토리의 getProduct 메소드를 사용하여 특정 문서의 상품 정보를 가져옴
  return repository.getProduct(fullPath);
});
// ----- 가디건 부분 끝

// ----- 코트 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final coatProductRepositoryProvider = Provider<CoatProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ProductRepository 객체를 생성
  return CoatProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 단일 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final coatProdDetailFirestoreDataProvider = FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  // 상품 레포지토리 프로바이더를 통해 생성된 레포지토리 객체의 참조를 얻음
  final repository = ref.watch(coatProductRepositoryProvider);
  // 레포지토리의 getProduct 메소드를 사용하여 특정 문서의 상품 정보를 가져옴
  return repository.getProduct(fullPath);
});
// ----- 코트 부분 끝

// ----- 청바지 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final jeanProductRepositoryProvider = Provider<JeanProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ProductRepository 객체를 생성
  return JeanProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 단일 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final jeanProdDetailFirestoreDataProvider = FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  // 상품 레포지토리 프로바이더를 통해 생성된 레포지토리 객체의 참조를 얻음
  final repository = ref.watch(jeanProductRepositoryProvider);
  // 레포지토리의 getProduct 메소드를 사용하여 특정 문서의 상품 정보를 가져옴
  return repository.getProduct(fullPath);
});
// ----- 청바지 부분 끝

// ----- 맨투맨 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final mtmProductRepositoryProvider = Provider<MtmProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ProductRepository 객체를 생성
  return MtmProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 단일 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final mtmProdDetailFirestoreDataProvider = FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  // 상품 레포지토리 프로바이더를 통해 생성된 레포지토리 객체의 참조를 얻음
  final repository = ref.watch(mtmProductRepositoryProvider);
  // 레포지토리의 getProduct 메소드를 사용하여 특정 문서의 상품 정보를 가져옴
  return repository.getProduct(fullPath);
});
// ----- 맨투맨 부분 끝

// ----- 니트 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final neatProductRepositoryProvider = Provider<NeatProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ProductRepository 객체를 생성
  return NeatProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 단일 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final neatProdDetailFirestoreDataProvider = FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  // 상품 레포지토리 프로바이더를 통해 생성된 레포지토리 객체의 참조를 얻음
  final repository = ref.watch(neatProductRepositoryProvider);
  // 레포지토리의 getProduct 메소드를 사용하여 특정 문서의 상품 정보를 가져옴
  return repository.getProduct(fullPath);
});
// ----- 니트 부분 끝

// ----- 원피스 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final onepieceProductRepositoryProvider = Provider<OnepieceProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ProductRepository 객체를 생성
  return OnepieceProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 단일 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final onepieceProdDetailFirestoreDataProvider = FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  // 상품 레포지토리 프로바이더를 통해 생성된 레포지토리 객체의 참조를 얻음
  final repository = ref.watch(onepieceProductRepositoryProvider);
  // 레포지토리의 getProduct 메소드를 사용하여 특정 문서의 상품 정보를 가져옴
  return repository.getProduct(fullPath);
});
// ----- 원피스 부분 끝

// ----- 패딩 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final paedingProductRepositoryProvider = Provider<PaedingProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ProductRepository 객체를 생성
  return PaedingProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 단일 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final paedingProdDetailFirestoreDataProvider = FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  // 상품 레포지토리 프로바이더를 통해 생성된 레포지토리 객체의 참조를 얻음
  final repository = ref.watch(paedingProductRepositoryProvider);
  // 레포지토리의 getProduct 메소드를 사용하여 특정 문서의 상품 정보를 가져옴
  return repository.getProduct(fullPath);
});
// ----- 패딩 부분 끝

// ----- 팬츠 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final pantsProductRepositoryProvider = Provider<PantsProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ProductRepository 객체를 생성
  return PantsProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 단일 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final pantsProdDetailFirestoreDataProvider = FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  // 상품 레포지토리 프로바이더를 통해 생성된 레포지토리 객체의 참조를 얻음
  final repository = ref.watch(pantsProductRepositoryProvider);
  // 레포지토리의 getProduct 메소드를 사용하여 특정 문서의 상품 정보를 가져옴
  return repository.getProduct(fullPath);
});
// ----- 팬츠 부분 끝

// ----- 폴라티 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final polaProductRepositoryProvider = Provider<PolaProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ProductRepository 객체를 생성
  return PolaProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 단일 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final polaProdDetailFirestoreDataProvider = FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  // 상품 레포지토리 프로바이더를 통해 생성된 레포지토리 객체의 참조를 얻음
  final repository = ref.watch(polaProductRepositoryProvider);
  // 레포지토리의 getProduct 메소드를 사용하여 특정 문서의 상품 정보를 가져옴
  return repository.getProduct(fullPath);
});
// ----- 폴라티 부분 끝

// ----- 티셔츠 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final shirtProductRepositoryProvider = Provider<ShirtProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ProductRepository 객체를 생성
  return ShirtProductRepository(FirebaseFirestore.instance);
});

// // Firestore에서 단일 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final shirtProdDetailFirestoreDataProvider = FutureProvider.family<ProductContent, String>((ref, fullPath) async {
  // 상품 레포지토리 프로바이더를 통해 생성된 레포지토리 객체의 참조를 얻음
  final repository = ref.watch(shirtProductRepositoryProvider);
  // 레포지토리의 getProduct 메소드를 사용하여 특정 문서의 상품 정보를 가져옴
  return repository.getProduct(fullPath);
});
// ----- 티셔츠 부분 끝

// ----- 스커트 부분 시작
// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final skirtProductRepositoryProvider = Provider<SkirtProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ProductRepository 객체를 생성
  return SkirtProductRepository(FirebaseFirestore.instance);
});

// Firestore에서 단일 문서의 상품 데이터를 비동기적으로 가져오는 FutureProvider
final skirtProdDetailFirestoreDataProvider = FutureProvider.family<ProductContent, String>((ref, docId) async {
  // 상품 레포지토리 프로바이더를 통해 생성된 레포지토리 객체의 참조를 얻음
  final repository = ref.watch(skirtProductRepositoryProvider);
  // 레포지토리의 getProduct 메소드를 사용하여 특정 문서의 상품 정보를 가져옴
  return repository.getProduct(docId);
});
// ----- 스커트 부분 끝
// ------ 블라우스, 가디건, 코트, 청바지, 맨투맨, 니트, 원피스, 패딩, 팬츠, 폴라티, 티셔츠, 스커트
// 관련 상세 화면 부분에 적용-파이어베이스의 데이터를 불러올 때 사용할 provider 끝

// ------- 티셔츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작

// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final shirtMainSmall1BannerRepositoryProvider = Provider<ShirtMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ShirtMainSmall1BannerRepository 객체를 생성함.
  // ShirtMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return ShirtMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final shirtMainSmall1BannerImagesProvider = FutureProvider<List<ShirtMainSmall1BannerImage>>((ref) async {
  // 위에서 정의한 shirtMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(shirtMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<ShirtMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImages();
});

// ------- 티셔츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 블라우스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작

// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final blouseMainSmall1BannerRepositoryProvider = Provider<BlouseMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 BlouseMainSmall1BannerRepository 객체를 생성함.
  // BlouseMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return BlouseMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final blouseMainSmall1BannerImagesProvider = FutureProvider<List<BlouseMainSmall1BannerImage>>((ref) async {
  // 위에서 정의한 blouseMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(blouseMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<BlouseMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImages();
});

// ------- 블라우스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 맨투맨 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작

// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final mtmMainSmall1BannerRepositoryProvider = Provider<MtmMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 MtmMainSmall1BannerRepository 객체를 생성함.
  // MtmMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return MtmMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final mtmMainSmall1BannerImagesProvider = FutureProvider<List<MtmMainSmall1BannerImage>>((ref) async {
  // 위에서 정의한 mtmMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(mtmMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<MtmMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImages();
});

// ------- 맨투맨 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 니트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작

// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final neatMainSmall1BannerRepositoryProvider = Provider<NeatMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 NeatMainSmall1BannerRepository 객체를 생성함.
  // NeatMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return NeatMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final neatMainSmall1BannerImagesProvider = FutureProvider<List<NeatMainSmall1BannerImage>>((ref) async {
  // 위에서 정의한 neatMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(neatMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<NeatMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImages();
});

// ------- 니트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 폴라티 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작

// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final polaMainSmall1BannerRepositoryProvider = Provider<PolaMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 PolaMainSmall1BannerRepository 객체를 생성함.
  // PolaMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return PolaMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final polaMainSmall1BannerImagesProvider = FutureProvider<List<PolaMainSmall1BannerImage>>((ref) async {
  // 위에서 정의한 polaMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(polaMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<PolaMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImages();
});

// ------- 폴라티 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 원피스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작

// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final onepieceMainSmall1BannerRepositoryProvider = Provider<OnepieceMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 OnepieceMainSmall1BannerRepository 객체를 생성함.
  // OnepieceMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return OnepieceMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final onepieceMainSmall1BannerImagesProvider = FutureProvider<List<OnepieceMainSmall1BannerImage>>((ref) async {
  // 위에서 정의한 onepieceMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(onepieceMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<OnepieceMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImages();
});

// ------- 원피스 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 팬츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작

// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final pantsMainSmall1BannerRepositoryProvider = Provider<PantsMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 PantsMainSmall1BannerRepository 객체를 생성함.
  // PantsMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return PantsMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final pantsMainSmall1BannerImagesProvider = FutureProvider<List<PantsMainSmall1BannerImage>>((ref) async {
  // 위에서 정의한 pantsMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(pantsMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<PantsMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImages();
});

// ------- 팬츠 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 청바지 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작

// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final jeanMainSmall1BannerRepositoryProvider = Provider<JeanMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 JeanMainSmall1BannerRepository 객체를 생성함.
  // JeanMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return JeanMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final jeanMainSmall1BannerImagesProvider = FutureProvider<List<JeanMainSmall1BannerImage>>((ref) async {
  // 위에서 정의한 jeanMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(jeanMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<JeanMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImages();
});

// ------- 청바지 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 스커트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작

// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final skirtMainSmall1BannerRepositoryProvider = Provider<SkirtMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 SkirtMainSmall1BannerRepository 객체를 생성함.
  // SkirtMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return SkirtMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final skirtMainSmall1BannerImagesProvider = FutureProvider<List<SkirtMainSmall1BannerImage>>((ref) async {
  // 위에서 정의한 skirtMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(skirtMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<SkirtMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImages();
});

// ------- 스커트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 패딩 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작

// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final paedingMainSmall1BannerRepositoryProvider = Provider<PaedingMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 PaedingMainSmall1BannerRepository 객체를 생성함.
  // PaedingMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return PaedingMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final paedingMainSmall1BannerImagesProvider = FutureProvider<List<PaedingMainSmall1BannerImage>>((ref) async {
  // 위에서 정의한 paedingMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(paedingMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<BlouseMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImages();
});

// ------- 패딩 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 코트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작

// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final coatMainSmall1BannerRepositoryProvider = Provider<CoatMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 CoatMainSmall1BannerRepository 객체를 생성함.
  // CoatMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return CoatMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final coatMainSmall1BannerImagesProvider = FutureProvider<List<CoatMainSmall1BannerImage>>((ref) async {
  // 위에서 정의한 coatMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(coatMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<CoatMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImages();
});

// ------- 코트 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// ------- 가디건 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 시작

// Firestore에서 작은 배너1 이미지 정보를 가져오기 위한 레포지토리 클래스의 인스턴스를 생성하는 프로바이더.
final cardiganMainSmall1BannerRepositoryProvider = Provider<CardiganMainSmall1BannerRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 CardiganMainSmall1BannerRepository 객체를 생성함.
  // CardiganMainSmall1BannerRepository Firestore에서 배너 데이터를 가져오는 기능을 담당함.
  return CardiganMainSmall1BannerRepository(FirebaseFirestore.instance);
});

// 비동기적으로 작은 배너1 이미지를 가져오는 FutureProvider.
// 이 프로바이더는 앱에서 사용되는 여러 배너 이미지들을 Firestore로부터 받아와서 리스트 형태로 제공함.
final cardiganMainSmall1BannerImagesProvider = FutureProvider<List<CardiganMainSmall1BannerImage>>((ref) async {
  // 위에서 정의한 cardiganMainSmall1BannerImagesProvider를 사용하여 리포지토리 인스턴스를 가져옴.
  final repository = ref.watch(cardiganMainSmall1BannerRepositoryProvider);
  // 리포지토리를 통해 Firestore에서 배너 이미지 데이터를 비동기적으로 가져옴.
  // fetchBannerImages 메소드는 배너 이미지 정보를 포함하는 List<CardiganMainSmall1BannerImage>를 반환함.
  return await repository.fetchBannerImages();
});

// ------- 가디건 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝