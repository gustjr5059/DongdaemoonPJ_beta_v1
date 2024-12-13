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
  return await repository.fetchBannerImagesAndLink();
});
// ------- 마이페이지 메인 화면 내 Firestore로부터 첫 번째 작은 배너 데이터 가져오는 로직 관련 provider 끝

// 상품 상세 화면 내 상품 정보등의 탭 화면 내 데이터 처리 로직인 ProductDtTabRepository 인스턴스 생성 프로바이더
final productDtTabRepositoryProvider = Provider<ProductDtTabRepository>((ref) {
  return ProductDtTabRepository(FirebaseFirestore.instance);
});