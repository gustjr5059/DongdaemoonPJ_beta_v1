
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
import '../model/product_model.dart'; // 상품 데이터 모델 정의 파일의 임포트
// 제품 데이터를 Firestore 데이터베이스에서 가져오는 로직이 구현된 저장소 클래스를 임포트합니다.
// 이 레포지토리는 Firestore와의 직접적인 상호작용을 캡슐화하며, 데이터를 가져오거나 업데이트하는 메서드를 제공합니다.
import '../repository/product_repository.dart'; // 상품 데이터를 Firestore에서 가져오는 로직이 구현된 레포지토리 클래스의 임포트


// ------ 신상, 최고, 할인, 봄, 여름, 가을, 겨울 관련 상품 상세 화면에 보여줄 파이어베이스의 데이터를 불러올 때 사용할 provider 시작

// Firestore로부터 상품 정보를 가져오는 레포지토리의 인스턴스를 생성하는 프로바이더
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  // Firebase Firestore의 인스턴스를 생성자에 전달하여 ProductRepository 객체를 생성
  return ProductRepository(FirebaseFirestore.instance);
});

// 특정 문서 ID를 사용하여 Firestore로부터 상품 데이터를 비동기적으로 가져오는 FutureProvider
final prodFirestoreDataProvider = FutureProvider.family<ProductContent, String>((ref, docId) async {
  // 상품 레포지토리 프로바이더를 통해 생성된 레포지토리 객체의 참조를 얻음
  final repository = ref.watch(productRepositoryProvider);
  // 레포지토리의 getProduct 메소드를 사용하여 특정 문서 ID에 해당하는 상품 정보를 가져옴
  return repository.getProduct(docId);
});

// ------ 신상, 최고, 할인, 봄, 여름, 가을, 겨울 관련 상품 상세 화면에 보여줄 파이어베이스의 데이터를 불러올 때 사용할 provider 끝

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