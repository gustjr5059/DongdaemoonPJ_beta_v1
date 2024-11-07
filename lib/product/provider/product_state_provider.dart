// Riverpod 라이브러리를 임포트합니다.
// 이 라이브러리는 상태 관리를 위한 강력하고 유연한 프레임워크로, 애플리케이션의 다양한 상태를 관리하는데 도움을 줍니다.
// Riverpod는 기존 Provider 라이브러리를 기반으로 하여 더욱 발전된 기능을 제공하며,
// 각종 상태 관리 요구 사항을 보다 세밀하고 효과적으로 다룰 수 있도록 설계되었습니다.
// 이를 통해 앱의 상태를 전역적으로 또는 로컬적으로 제어하고, 상태 변화에 따라 UI를 자동으로 업데이트하는 구조를 구현할 수 있습니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongdaemoon_beta_v1/product/provider/product_all_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/product_model.dart';
import '../repository/product_repository.dart';

// 티셔츠 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final shirtMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 블라우스 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final blouseMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 맨투맨 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final mtmMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 니트 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final neatMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 폴라티 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final polaMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 원피스 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final onepieceMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 팬츠 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final pantsMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 청바지 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final jeanMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 스커트 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final skirtMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 패딩 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final paedingMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 코트 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final coatMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 가디건 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final cardiganMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);

// 티셔츠 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final shirtMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 블라우스 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final blouseMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 맨투맨 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final mtmMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 니트 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final neatMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 폴라티 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final polaMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 원피스 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final onepieceMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 팬츠 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final pantsMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 청바지 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final jeanMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 스커트 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final skirtMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 패딩 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final paedingMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 코트 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final coatMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 가디건 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final cardiganMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);

// 신상 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final newSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 최고 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final bestSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 할인 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final saleSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 봄 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final springSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 여름 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final summerSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 가을 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final autumnSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 겨울 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final winterSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);

// 신상 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final newSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 최고 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final bestSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 할인 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final saleSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 봄 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final springSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 여름 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final summerSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 가을 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final autumnSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 겨울 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final winterSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);

// ------- 상품 상세 화면 관련 StateProvider 시작

// 각 카테고리별 상세화면에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final blouseDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final cardiganDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final coatDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final jeanDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final mtmDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final neatDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final onepieceDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final paedingDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final pantsDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final polaDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final shirtDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final skirtDetailScrollPositionProvider = StateProvider<double>((ref) => 0);

// ------ 상세 화면마다의 각 id를 통해서 이미지 상태관리하는 provider를 케이스로 나눠서 개별적으로 사용하도록 한 로직 부분 시작
// _imagePageProviders라는 Map을 선언함. 키는 문자열이고 값은 StateProvider<int>임.
final Map<String, StateProvider<int>> _imagePageProviders = {};

// productId를 받아서 해당하는 StateProvider<int>를 반환하는 함수.
StateProvider<int> getImagePageProvider(String productId) {
  // _imagePageProviders에 productId가 존재하지 않으면 새 StateProvider<int>를 생성하여 추가하고, 존재하면 기존 값을 반환함.
  return _imagePageProviders.putIfAbsent(
      productId, () => StateProvider<int>((ref) => 0));
}
// ------ 상세 화면마다의 각 id를 통해서 이미지 상태관리하는 provider를 케이스로 나눠서 개별적으로 사용하도록 한 로직 부분 끝

// 상품 상세 화면에서 이미지 클릭 시, 상세 이미지 화면으로 이동하는 데 해당 화면 내 이미지 페이지 인덱스 상태관리 관련 StateProvider
final detailImagePageProvider = StateProvider<int>((ref) => 0);
// 색상 선택을 위한 상태 관리용 StateProvider
final colorSelectionUrlProvider = StateProvider<String?>((ref) => null);
final colorSelectionTextProvider = StateProvider<String?>((ref) => null);
final colorSelectionIndexProvider = StateProvider<int>((ref) => 0);
// 사이즈 선택을 위한 상태 관리용 StateProvider
final sizeSelectionIndexProvider = StateProvider<String?>((ref) => null);
// 상품 상세 화면에서 '상품 정보', '문의' 탭으로 각 탭이 선택될 때마다 각 내용이 나오도록 하는 ProductDetailScreenTabs 클래스
// 관련 탭 섹션 상수 부분
enum ProdDetailScreenTabSection { productInfo, inquiry }
// 상품 상세 화면에서 '상품 정보', '리뷰', '문의' 탭으로 각 탭이 선택될 때마다 각 내용이 나오도록 하는 ProductDetailScreenTabs 클래스
// 관련 탭 섹션 상태관리 관련 StateProvider
final prodDetailScreenTabSectionProvider = StateProvider<ProdDetailScreenTabSection>((ref) => ProdDetailScreenTabSection.productInfo);

// ------- 상품 상세 화면 관련 StateProvider 끝

// 현재 선택된 상단 탭 바 관련 탭의 인덱스 상태 관리를 위한 StateProvider
final blouseCurrentTabProvider = StateProvider<int>((ref) => 0);
final cardiganCurrentTabProvider = StateProvider<int>((ref) => 0);
final coatCurrentTabProvider = StateProvider<int>((ref) => 0);
final jeanCurrentTabProvider = StateProvider<int>((ref) => 0);
final mtmCurrentTabProvider = StateProvider<int>((ref) => 0);
final neatCurrentTabProvider = StateProvider<int>((ref) => 0);
final onepieceCurrentTabProvider = StateProvider<int>((ref) => 0);
final paedingCurrentTabProvider = StateProvider<int>((ref) => 0);
final pantsCurrentTabProvider = StateProvider<int>((ref) => 0);
final polaCurrentTabProvider = StateProvider<int>((ref) => 0);
final shirtCurrentTabProvider = StateProvider<int>((ref) => 0);
final skirtCurrentTabProvider = StateProvider<int>((ref) => 0);

// 각 카테고리별 메인화면에서 각 상단 탭 바 관련 섹션의 스크롤 위치와 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final blouseMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final cardiganMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final coatMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final jeanMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final mtmMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final neatMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final onepieceMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final paedingMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final pantsMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final polaMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final shirtMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final skirtMainScrollPositionProvider = StateProvider<double>((ref) => 0);

// 각 섹션별 서브 메인 화면(섹션 더보기 화면)에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final newSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final bestSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final saleSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final springSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final summerSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final autumnSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final winterSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);

// 2차 메인 화면 내 가격순, 할인순 버튼 관련 상태 관리 함수인 StateProvider
final blouseMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final cardiganMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final coatMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final jeanMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final mtmMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final neatMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final onepieceMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final paedingMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final pantsMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final polaMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final shirtMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final skirtMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정

// 섹션 더보기 화면 내 가격순, 할인순 버튼 관련 상태 관리 함수인 StateProvider
final newSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final bestSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final saleSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final springSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final summerSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final autumnSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final winterSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정

// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트)과 섹션 더보기 화면 (신상, ~ 겨울)) 상품 데이터 불러오고 상태를 관리하는 기본 추상 클래스 시작
// ------- BaseProductListNotifier 클래스 내용 구현 시작
// 해당 내용은 추상 클래스이며, 해당 클래스를 다른 클래스에 오버라이드(extends 사용)를 하면 해당 클래스 기능은 그대로 사용하면서 추가되는 내용을 각기 적용 가능하므로, 이렇게 구성

// 상태 관리 추상 클래스 BaseProductListNotifier를 정의 (상품 데이터 관리)
abstract class BaseProductListNotifier
    extends StateNotifier<List<ProductContent>> {
  // 생성자를 정의, ref와 baseCollection을 초기화
  BaseProductListNotifier(this.ref, this.baseCollection) : super([]);

  // Ref 객체 선언
  final Ref ref;

  // 기본 컬렉션 이름 선언
  final String baseCollection;

  // 데이터 페칭 상태를 관리하는 변수 선언
  bool _isFetching = false;

  // 마지막 문서 스냅샷을 저장하는 변수 선언
  DocumentSnapshot? _lastDocument;

  // 데이터 페칭 상태를 반환하는 getter 정의
  bool get isFetching => _isFetching;

  // 정렬 타입을 저장하는 변수 선언
  String _sortType = '';

  // 정렬 타입을 설정하는 setter 정의
  set sortType(String value) {
    _sortType = value;
    _sortProducts();
  }

  // 상품 데이터를 정렬하는 메서드 정의
  void _sortProducts() {
    // 상태를 복사하여 새로운 리스트에 저장
    List<ProductContent> sortedProducts = [...state];
    // 가격 높은 순 정렬
    if (_sortType == '가격 높은 순') {
      sortedProducts
          .sort((a, b) => b.discountPrice!.compareTo(a.discountPrice!));
      // 가격 낮은 순 정렬
    } else if (_sortType == '가격 낮은 순') {
      sortedProducts
          .sort((a, b) => a.discountPrice!.compareTo(b.discountPrice!));
      // 할인율 높은 순 정렬
    } else if (_sortType == '할인율 높은 순') {
      sortedProducts
          .sort((a, b) => b.discountPercent!.compareTo(a.discountPercent!));
      // 할인율 낮은 순 정렬
    } else if (_sortType == '할인율 낮은 순') {
      sortedProducts
          .sort((a, b) => a.discountPercent!.compareTo(b.discountPercent!));
    }
    // 상태를 정렬된 리스트로 업데이트
    state = sortedProducts;
  }

  // 상품 데이터를 페칭하는 비동기 메서드 정의
  Future<void> _fetchProducts({
    // 초기 페칭 여부를 나타내는 매개변수
    bool isInitial = false,
    // 컬렉션 이름 리스트를 매개변수로 받음
    required List<String> collectionNames,
  }) async {
    // 이미 페칭 중이면 리턴
    if (_isFetching) return;
    // 페칭 상태를 true로 설정
    _isFetching = true;

    try {
      for (String fullCollection in collectionNames) {
        String mainCollection = 'a' + fullCollection.substring(1, 3);
        String subCollection = fullCollection;

        // CategoryProductsRepository 타입으로 분기하여 메인화면인 ProductMainListNotifier인 경우에는
        // MainCategoryProductsRepository 인스턴스를 제공하는 mainProductRepositoryProvider를 불러오도록 함
        // 섹션 더보기 화면인 SectionMoreProductListNotifier인 경우에는 SectionCategoryProductsRepository 인스턴스를 제공하는 sectionProductRepositoryProvider를 불러오도록 함
        final CategoryProductsRepository repository = this is ProductMainListNotifier
            ? ref.read(mainProductRepositoryProvider)
            : ref.read(sectionProductRepositoryProvider);


        final products = await repository.fetchProductContents(
          mainCollection: mainCollection,
          subCollection: subCollection,
          limit: 3,
          startAfter: isInitial ? null : _lastDocument,
          boolExistence: true,
        );

        // 페칭된 상품 데이터가 비어있지 않으면
        if (products.isNotEmpty) {
          // 마지막 문서를 업데이트
          _lastDocument = products.last.documentSnapshot;
          // debugPrint('Last document after fetch: ${_lastDocument!.id}');
          // 상태를 초기화 또는 기존 상태에 추가
          state = isInitial ? products : [...state, ...products];
          break; // 원하는 개수만큼 가져왔으면 중지
        } else {
          // 초기화 시 비어있는 상태로 설정
          if (isInitial) state = [];
        }
      }
      // 상품 데이터를 정렬
      _sortProducts();
    } catch (e) {
      // 에러 발생 시 디버깅 출력
      debugPrint('Error fetching products: $e');
    } finally {
      // 페칭 상태를 false로 설정
      _isFetching = false;
    }
  }

  // 초기 상품 데이터를 페칭하는 메서드 정의
  Future<void> fetchInitialProducts(String category) async {
    // 마지막 문서와 상태를 초기화
    _lastDocument = null;
    state = [];
    // 카테고리에 따른 컬렉션 이름 리스트를 얻음
    List<String> collectionNames = _getCollectionNames(category);
    reset(); // 상태 초기화
    // 초기 상품 데이터를 페칭
    await _fetchProducts(isInitial: true, collectionNames: collectionNames);
  }

  // 더 많은 상품 데이터를 페칭하는 메서드 정의
  Future<void> fetchMoreProducts(String category) async {
    // 이미 페칭 중이거나 마지막 문서가 없으면 리턴
    if (_isFetching || _lastDocument == null) return;
    // 카테고리에 따른 컬렉션 이름 리스트를 얻음
    List<String> collectionNames = _getCollectionNames(category);
    // 추가 상품 데이터를 페칭
    await _fetchProducts(collectionNames: collectionNames);
  }

  // 상태와 변수들을 초기화하는 메서드 정의
  void reset() {
    state = [];
    _lastDocument = null;
    _sortType = '';
    // 현재 사용하는 레퍼지토리의 상태 초기화
    final CategoryProductsRepository repository = this is ProductMainListNotifier
    // 만약 현재 클래스가 ProductMainListNotifier 타입이라면,
        ? ref.read(mainProductRepositoryProvider)
    // mainProductRepositoryProvider를 사용하여 메인 제품 레퍼지토리를 불러옴.
        : ref.read(sectionProductRepositoryProvider);
    // 그렇지 않다면 sectionProductRepositoryProvider를 사용하여 섹션별 제품 레퍼지토리를 불러옴.
    repository.reset();
    // 불러온 레퍼지토리의 상태를 reset() 함수를 호출하여 초기화.
  }

  // 카테고리에 따른 컬렉션 이름 리스트를 반환하는 추상 메서드
  List<String> _getCollectionNames(String category);
}
// ------- BaseProductListNotifier 클래스 내용 구현 끝
// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트)과 섹션 더보기 화면 (신상, ~ 겨울)) 상품 데이터 불러오고 상태를 관리하는 기본 추상 클래스 끝

// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트) 상품 데이터 불러오고 상태를 관리하는 클래스 (BaseProductListNotifier 추상 클래스를 오버라이드함-기능 상속받는 구조) 시작
// ------- ProductMainListNotifier 클래스 내용 구현 시작
// BaseProductListNotifier 클래스를 상속받는 ProductMainListNotifier 클래스 정의
class ProductMainListNotifier extends BaseProductListNotifier {

  // 생성자를 정의, ref와 baseCollection을 부모 클래스에 전달
  ProductMainListNotifier(Ref ref, String baseCollection)
      : super(ref, baseCollection);

  // 카테고리에 따른 컬렉션 이름 리스트를 반환하는 메서드 구현
  @override
  List<String> _getCollectionNames(String category) {
    // 카테고리별로 다른 컬렉션 이름 반환
    switch (category) {
      case '신상':
        return ['${baseCollection}1'];
      case '스테디 셀러':
        return ['${baseCollection}2'];
      case '특가 상품':
        return ['${baseCollection}3'];
      case '봄':
        return ['${baseCollection}4'];
      case '여름':
        return ['${baseCollection}5'];
      case '가을':
        return ['${baseCollection}6'];
      case '겨울':
        return ['${baseCollection}7'];
    // 기본적으로 모든 컬렉션 반환
      default:
        return [
          '${baseCollection}1',
          '${baseCollection}2',
          '${baseCollection}3',
          '${baseCollection}4',
          '${baseCollection}5',
          '${baseCollection}6',
          '${baseCollection}7'
        ];
    }
  }
}

// 2차 메인 화면 관련 ProductMainListNotifier 인스턴스를 생성하는 프로바이더 정의
// UI 코드에서 category 값을 인자로 전달하여 fetchInitialProducts와 fetchMoreProducts를 호출할 수 있음
final blouseMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 블라우스 컬렉션
  return ProductMainListNotifier(ref, 'a2b');
});

final cardiganMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 가디건 컬렉션
  return ProductMainListNotifier(ref, 'a12b');
});

final coatMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 코트 컬렉션
  return ProductMainListNotifier(ref, 'a11b');
});

final jeanMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 청바지 컬렉션
  return ProductMainListNotifier(ref, 'a8b');
});

final mtmMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 맨투맨 컬렉션
  return ProductMainListNotifier(ref, 'a3b');
});

final neatMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 니트 컬렉션
  return ProductMainListNotifier(ref, 'a4b');
});

final onepieceMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 원피스 컬렉션
  return ProductMainListNotifier(ref, 'a6b');
});

final paedingMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 패딩 컬렉션
  return ProductMainListNotifier(ref, 'a10b');
});

final pantsMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 바지 컬렉션
  return ProductMainListNotifier(ref, 'a7b');
});

final polaMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 폴라티 컬렉션
  return ProductMainListNotifier(ref, 'a5b');
});

final shirtMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 셔츠 컬렉션
  return ProductMainListNotifier(ref, 'a1b');
});

final skirtMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 스커트 컬렉션
  return ProductMainListNotifier(ref, 'a9b');
});
// ------- ProductMainListNotifier 클래스 내용 구현 끝
// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트) 상품 데이터 불러오고 상태를 관리하는 클래스 (BaseProductListNotifier 추상 클래스를 오버라이드함-기능 상속받는 구조) 끝

// ------- 섹션 더보기 화면 (신상, ~ 겨울)) 상품 데이터 불러오고 상태를 관리하는 클래스 (BaseProductListNotifier 추상 클래스를 오버라이드함-기능 상속받는 구조) 시작
// ------- SectionMoreProductListNotifier 클래스 내용 구현 시작
// BaseProductListNotifier 클래스를 상속받는 SectionMoreProductListNotifier 클래스 정의
class SectionMoreProductListNotifier extends BaseProductListNotifier {

  // 생성자를 정의, ref와 baseCollection을 부모 클래스에 전달
  SectionMoreProductListNotifier(Ref ref, String baseCollection)
      : super(ref, baseCollection);

  // 카테고리에 따른 컬렉션 이름 리스트를 반환하는 메서드 구현
  @override
  List<String> _getCollectionNames(String category) {
    // 카테고리별로 다른 컬렉션 이름 반환 (12개의 서브 컬렉션)
    switch (category) {
      case '신상':
        return List.generate(12, (index) => '${baseCollection}${index + 1}b1');
      case '스테디 셀러':
        return List.generate(12, (index) => '${baseCollection}${index + 1}b2');
      case '특가 상품':
        return List.generate(12, (index) => '${baseCollection}${index + 1}b3');
      case '봄':
        return List.generate(12, (index) => '${baseCollection}${index + 1}b4');
      case '여름':
        return List.generate(12, (index) => '${baseCollection}${index + 1}b5');
      case '가을':
        return List.generate(12, (index) => '${baseCollection}${index + 1}b6');
      case '겨울':
        return List.generate(12, (index) => '${baseCollection}${index + 1}b7');
    // 기본적으로 신상 컬렉션 반환
      default:
        return List.generate(12, (index) => '${baseCollection}${index + 1}b1');
    }
  }
}

// 섹션 더보기 화면 관련 SectionMoreProductListNotifier 인스턴스를 생성하는 프로바이더 정의
// UI 코드에서 category 값을 인자로 전달하여 fetchInitialProducts와 fetchMoreProducts를 호출할 수 있음
final newSubMainProductListProvider =
    StateNotifierProvider<SectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 신상 섹션
  return SectionMoreProductListNotifier(ref, 'a');
});

final bestSubMainProductListProvider =
    StateNotifierProvider<SectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 스테디 셀러 섹션
  return SectionMoreProductListNotifier(ref, 'a');
});

final saleSubMainProductListProvider =
    StateNotifierProvider<SectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 특가 상품 섹션
  return SectionMoreProductListNotifier(ref, 'a');
});

final springSubMainProductListProvider =
    StateNotifierProvider<SectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 봄 섹션
  return SectionMoreProductListNotifier(ref, 'a');
});

final summerSubMainProductListProvider =
    StateNotifierProvider<SectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 여름 섹션
  return SectionMoreProductListNotifier(ref, 'a');
});

final autumnSubMainProductListProvider =
    StateNotifierProvider<SectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 가을 섹션
  return SectionMoreProductListNotifier(ref, 'a');
});

final winterSubMainProductListProvider =
    StateNotifierProvider<SectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 겨울 섹션
  return SectionMoreProductListNotifier(ref, 'a');
});
// ------- SectionMoreProductListNotifier 클래스 내용 구현 끝
// ------- 섹션 더보기 화면 (신상, ~ 겨울)) 상품 데이터 불러오고 상태를 관리하는 클래스 (BaseProductListNotifier 추상 클래스를 오버라이드함-기능 상속받는 구조) 끝

// 상품 상세화면 내 상품정보 안에서 이미지의 전체 이미지로 보이도록하는 확장 유무 상태관리인 showFullImageProvider
final showFullImageProvider = StateProvider<bool>((ref) => false);

// ------ 이미지 리스트의 상태를 관리하며, 이미지를 페이징 처리하여 불러오는 로직인 ImageNotifier 클래스 시작 부분
class ImageNotifier extends StateNotifier<List<String>> {
  final ProductDtTabRepository repository; // 상품 데이터를 불러오는 레포지토리
  final Ref ref; // Provider에서 사용할 참조 객체
  final String fullPath; // Firestore 경로를 저장
  int currentIndex = 0;  // 현재까지 불러온 마지막 이미지 인덱스를 저장
  bool isLoadingMore = false; // 이미지 로드 중 여부를 저장
  bool hasMore = true; // 추가 이미지를 로드할 수 있는지 여부를 저장
  bool showCollapseButton = false; // '접기' 버튼을 표시할지 여부

  // 생성자에서 초기 값을 설정함.
  ImageNotifier({
    required this.repository,
    required this.ref,
    required this.fullPath,
  }) : super([]) {
    // 첫 번째 이미지를 로드함.
    print("ImageNotifier: 첫 번째 이미지 로드 시작.");
    loadMoreImages(); // 생성 시 처음에 1개의 이미지를 로드함.
  }

  // 이미지 리스트를 유지하면서 상태만 초기화하는 함수
  void resetButtonState() {
    showCollapseButton = false;  // '접기' 버튼을 초기화
  }

  // 추가 이미지를 로드하는 함수
  Future<void> loadMoreImages() async {
    // 이미 로드 중이거나 더 이상 로드할 이미지가 없을 경우, 로드를 중단함.
    if (isLoadingMore || !hasMore) {
      print("ImageNotifier: 이미 로드 중이거나 더 이상 로드할 이미지가 없습니다.");
      return;
    }

    print("ImageNotifier: 이미지 로드 시작 (currentIndex: $currentIndex)");
    isLoadingMore = true; // 로드 중 상태로 설정함.

    try {
      // 현재 인덱스를 기반으로 Firestore에서 이미지를 불러옴.
      final images = await repository.fetchProductDetailImages(
        fullPath: fullPath,  // Firestore 경로를 전달함.
        startIndex: currentIndex,  // 현재 인덱스를 전달함.
      );

      if (images.isNotEmpty) {
        currentIndex++;  // 이미지가 로드되면 인덱스를 증가시킴.
        state = [...state, ...images]; // 새로 불러온 이미지를 기존 상태에 추가함.

        // 두 번째 페이지일 때 바로 '접기' 버튼을 표시하도록 설정
        if (currentIndex == 2) {
          showCollapseButton = true;
        }
        print("ImageNotifier: 이미지 로드 성공, 현재 이미지 수: ${state.length}, 현재 인덱스: $currentIndex");
      } else {
        hasMore = false; // 불러올 이미지가 없으면 더 이상 로드하지 않도록 설정함.
        print("ImageNotifier: 더 이상 불러올 이미지가 없습니다.");
      }
    } catch (e) {
      print("ImageNotifier: 이미지 로드 중 에러 발생 - $e"); // 에러 발생 시 출력함.
    } finally {
      isLoadingMore = false;  // 이미지 로드가 완료되면 로드 중 상태를 해제함.
      // 상태가 변경되었음을 알리기 위해 상태 변화를 알림.
      ref.notifyListeners();
      print("ImageNotifier: 이미지 로드 완료.");
    }
  }

  // 이미지 리스트를 초기화하고 첫 번째 이미지를 다시 로드하는 함수
  void reset() {
    print("ImageNotifier: 이미지 리스트 초기화 및 첫 번째 이미지 로드 시작.");
    state = []; // 이미지 리스트를 초기화함.
    currentIndex = 0; // 인덱스를 초기화함.
    hasMore = true; // 추가 로드를 가능하게 설정함.
    loadMoreImages(); // 첫 번째 이미지를 다시 로드함.
  }
}

// imagesProvider는 ImageNotifier를 제공하며, fullPath를 매개변수로 받음.
// Provider를 통해 ImageNotifier를 상태로 관리함.
final imagesProvider = StateNotifierProvider.family<ImageNotifier, List<String>, String>((ref, fullPath) {
  final repository = ref.read(productDtTabRepositoryProvider); // 레포지토리를 읽어옴.
  return ImageNotifier(repository: repository, ref: ref, fullPath: fullPath); // ImageNotifier를 생성하여 반환함.
});
