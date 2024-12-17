// Riverpod 라이브러리를 임포트합니다.
// 이 라이브러리는 상태 관리를 위한 강력하고 유연한 프레임워크로, 애플리케이션의 다양한 상태를 관리하는데 도움을 줍니다.
// Riverpod는 기존 Provider 라이브러리를 기반으로 하여 더욱 발전된 기능을 제공하며,
// 각종 상태 관리 요구 사항을 보다 세밀하고 효과적으로 다룰 수 있도록 설계되었습니다.
// 이를 통해 앱의 상태를 전역적으로 또는 로컬적으로 제어하고, 상태 변화에 따라 UI를 자동으로 업데이트하는 구조를 구현할 수 있습니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongdaemoon_beta_v1/market/aay/product/provider/aay_product_all_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../product/model/product_model.dart';
import '../../../../product/provider/product_state_provider.dart';
import '../../../../product/repository/product_repository.dart';

// 티셔츠 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aayShirtMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 블라우스 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aayBlouseMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 맨투맨 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aayMtmMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 니트 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aayNeatMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 폴라티 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aayPolaMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 원피스 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aayOnepieceMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 팬츠 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aayPantsMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 청바지 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aayJeanMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 스커트 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaySkirtMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 패딩 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aayPaedingMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 코트 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aayCoatMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 가디건 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aayCardiganMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);

// 티셔츠 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aayShirtMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 블라우스 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aayBlouseMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 맨투맨 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aayMtmMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 니트 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aayNeatMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 폴라티 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aayPolaMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 원피스 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aayOnepieceMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 팬츠 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aayPantsMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 청바지 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aayJeanMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 스커트 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaySkirtMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 패딩 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aayPaedingMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 코트 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aayCoatMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 가디건 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aayCardiganMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);

// 신상 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aayNewSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 최고 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aayBestSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 할인 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaySaleSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 봄 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaySpringSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 여름 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaySummerSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 가을 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aayAutumnSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 겨울 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aayWinterSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);

// 신상 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aayNewSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 최고 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aayBestSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 할인 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaySaleSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 봄 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaySpringSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 여름 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaySummerSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 가을 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aayAutumnSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 겨울 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aayWinterSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);

// 각 카테고리별 상세화면에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final aayBlouseDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayCardiganDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayCoatDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayJeanDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayMtmDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayNeatDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayOnepieceDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayPaedingDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayPantsDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayPolaDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayShirtDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaySkirtDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
// ------- 상품 상세 화면 관련 StateProvider 끝

// 현재 선택된 상단 탭 바 관련 탭의 인덱스 상태 관리를 위한 StateProvider
final aayBlouseCurrentTabProvider = StateProvider<int>((ref) => 0);
final aayCardiganCurrentTabProvider = StateProvider<int>((ref) => 0);
final aayCoatCurrentTabProvider = StateProvider<int>((ref) => 0);
final aayJeanCurrentTabProvider = StateProvider<int>((ref) => 0);
final aayMtmCurrentTabProvider = StateProvider<int>((ref) => 0);
final aayNeatCurrentTabProvider = StateProvider<int>((ref) => 0);
final aayOnepieceCurrentTabProvider = StateProvider<int>((ref) => 0);
final aayPaedingCurrentTabProvider = StateProvider<int>((ref) => 0);
final aayPantsCurrentTabProvider = StateProvider<int>((ref) => 0);
final aayPolaCurrentTabProvider = StateProvider<int>((ref) => 0);
final aayShirtCurrentTabProvider = StateProvider<int>((ref) => 0);
final aaySkirtCurrentTabProvider = StateProvider<int>((ref) => 0);

// 각 카테고리별 메인화면에서 각 상단 탭 바 관련 섹션의 스크롤 위치와 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final aayBlouseMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayCardiganMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayCoatMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayJeanMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayMtmMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayNeatMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayOnepieceMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayPaedingMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayPantsMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayPolaMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayShirtMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaySkirtMainScrollPositionProvider = StateProvider<double>((ref) => 0);

// 각 섹션별 서브 메인 화면(섹션 더보기 화면)에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final aayNewSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayBestSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaySaleSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaySpringSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaySummerSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayAutumnSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aayWinterSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);

// 2차 메인 화면 내 가격순, 할인순 버튼 관련 상태 관리 함수인 StateProvider
final aayBlouseMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aayCardiganMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aayCoatMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aayJeanMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aayMtmMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aayNeatMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aayOnepieceMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aayPaedingMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aayPantsMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aayPolaMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aayShirtMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaySkirtMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정

// 섹션 더보기 화면 내 가격순, 할인순 버튼 관련 상태 관리 함수인 StateProvider
final aayNewSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aayBestSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaySaleSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaySpringSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaySummerSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aayAutumnSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aayWinterSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정

// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트)과 섹션 더보기 화면 (신상, ~ 겨울)) 상품 데이터 불러오고 상태를 관리하는 기본 추상 클래스 시작
// ------- AayBaseProductListNotifier 클래스 내용 구현 시작
// 해당 내용은 추상 클래스이며, 해당 클래스를 다른 클래스에 오버라이드(extends 사용)를 하면 해당 클래스 기능은 그대로 사용하면서 추가되는 내용을 각기 적용 가능하므로, 이렇게 구성

// 상태 관리 추상 클래스 AayBaseProductListNotifier를 정의 (상품 데이터 관리)
abstract class AayBaseProductListNotifier
    extends StateNotifier<List<ProductContent>> {
  // 생성자를 정의, ref와 baseCollection을 초기화
  AayBaseProductListNotifier(this.ref, this.baseCollection) : super([]);

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
    debugPrint('정렬 타입 설정됨: $_sortType');
    _sortProducts();
  }

  // 상품 데이터를 정렬하는 메서드 정의
  void _sortProducts() {
    // 상태를 복사하여 새로운 리스트에 저장
    List<ProductContent> sortedProducts = [...state];
    debugPrint('정렬 시작. 현재 상태의 상품 수: ${state.length}');

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

    debugPrint('정렬 완료. 정렬된 상품 목록: $sortedProducts');
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
    if (_isFetching) {
      debugPrint('현재 페칭 중이므로 새로운 페칭을 중단합니다.');
      return;
    }
    // 페칭 상태를 true로 설정
    _isFetching = true;
    debugPrint('상품 데이터 페칭 시작. 초기화 여부: $isInitial');

    try {
      for (String fullCollection in collectionNames) {
        // 한 자리 숫자는 substring(1, 4), 두 자리 숫자는 substring(1, 5) 사용
        String mainCollection = fullCollection.length == 7
            ? 'A' + fullCollection.substring(1, 5)
            : 'A' + fullCollection.substring(1, 4);

        String subCollection = fullCollection;

        debugPrint('현재 컬렉션: $mainCollection, 서브 컬렉션: $subCollection');

        // CategoryProductsRepository 타입으로 분기하여 메인화면인 ProductMainListNotifier인 경우에는
        // AayMainCategoryProductsRepository 인스턴스를 제공하는 aayMainProductRepositoryProvider를 불러오도록 함
        // 섹션 더보기 화면인 AaySectionMoreProductListNotifier인 경우에는 AaySectionCategoryProductsRepository 인스턴스를 제공하는 aaySectionProductRepositoryProvider를 불러오도록 함
        final CategoryProductsRepository repository = this is AayProductMainListNotifier
            ? ref.read(aayMainProductRepositoryProvider)
            : ref.read(aaySectionProductRepositoryProvider);

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
          debugPrint('가져온 문서 수: ${products.length}, 마지막 문서 ID: ${_lastDocument?.id}');
          // 상태를 초기화 또는 기존 상태에 추가
          state = isInitial ? products : [...state, ...products];
          break; // 원하는 개수만큼 가져왔으면 중지
        } else {
          debugPrint('컬렉션 $fullCollection 에서 더 이상 가져올 데이터가 없습니다.');
          // 초기화 시 비어있는 상태로 설정
          if (isInitial) state = [];
        }
      }
      // 상품 데이터를 정렬
      _sortProducts();
    } catch (e) {
      // 에러 발생 시 디버깅 출력
      debugPrint('products 불러오는 중 에러 발생: $e');
    } finally {
      // 페칭 상태를 false로 설정
      _isFetching = false;
      debugPrint('상품 데이터 페칭 완료.');
    }
  }

  // 초기 상품 데이터를 페칭하는 메서드 정의
  Future<void> fetchInitialProducts(String category) async {
    debugPrint('초기 상품 데이터 페칭 시작. 카테고리: $category');
    // 마지막 문서와 상태를 초기화
    _lastDocument = null;
    state = [];
    // 카테고리에 따른 컬렉션 이름 리스트를 얻음
    List<String> collectionNames = _getCollectionNames(category);
    reset(); // 상태 초기화
    // 초기 상품 데이터를 페칭
    await _fetchProducts(isInitial: true, collectionNames: collectionNames);
    debugPrint('초기 상품 데이터 페칭 완료. 상태의 상품 수: ${state.length}');
  }

  // 더 많은 상품 데이터를 페칭하는 메서드 정의
  Future<void> fetchMoreProducts(String category) async {
    // 이미 페칭 중이거나 마지막 문서가 없으면 리턴
    if (_isFetching || _lastDocument == null) {
      debugPrint('추가 상품 데이터를 불러올 수 없는 상태입니다.');
      return;
    }
    debugPrint('추가 상품 데이터 페칭 시작. 카테고리: $category');
    // 카테고리에 따른 컬렉션 이름 리스트를 얻음
    List<String> collectionNames = _getCollectionNames(category);
    // 추가 상품 데이터를 페칭
    await _fetchProducts(collectionNames: collectionNames);
    debugPrint('추가 상품 데이터 페칭 완료. 상태의 상품 수: ${state.length}');
  }

  // 상태와 변수들을 초기화하는 메서드 정의
  void reset() {
    debugPrint('상태 초기화 시작.');
    state = [];
    _lastDocument = null;
    _sortType = '';
    // 현재 사용하는 레퍼지토리의 상태 초기화
    final CategoryProductsRepository repository = this is AayProductMainListNotifier
    // 만약 현재 클래스가 AayProductMainListNotifier 타입이라면,
        ? ref.read(aayMainProductRepositoryProvider)
    // aayMainProductRepositoryProvider를 사용하여 메인 제품 레퍼지토리를 불러옴.
        : ref.read(aaySectionProductRepositoryProvider);
    // 그렇지 않다면 aaySectionProductRepositoryProvider를 사용하여 섹션별 제품 레퍼지토리를 불러옴.
    repository.reset();
    // 불러온 레퍼지토리의 상태를 reset() 함수를 호출하여 초기화.
    debugPrint('상태 초기화 완료.');
  }

  // 카테고리에 따른 컬렉션 이름 리스트를 반환하는 추상 메서드
  List<String> _getCollectionNames(String category);
}
// ------- AayBaseProductListNotifier 클래스 내용 구현 끝
// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트)과 섹션 더보기 화면 (신상, ~ 겨울)) 상품 데이터 불러오고 상태를 관리하는 기본 추상 클래스 끝

// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트) 상품 데이터 불러오고 상태를 관리하는 클래스 (BaseProductListNotifier 추상 클래스를 오버라이드함-기능 상속받는 구조) 시작
// ------- AayProductMainListNotifier 클래스 내용 구현 시작
// AayBaseProductListNotifier 클래스를 상속받는 AayProductMainListNotifier 클래스 정의
class AayProductMainListNotifier extends AayBaseProductListNotifier {

  // 생성자를 정의, ref와 baseCollection을 부모 클래스에 전달
  AayProductMainListNotifier(Ref ref, String baseCollection)
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

// 2차 메인 화면 관련 AayProductMainListNotifier 인스턴스를 생성하는 프로바이더 정의
// UI 코드에서 category 값을 인자로 전달하여 fetchInitialProducts와 fetchMoreProducts를 호출할 수 있음
final aayBlouseMainProductListProvider =
    StateNotifierProvider<AayProductMainListNotifier, List<ProductContent>>((ref) {
  // 블라우스 컬렉션
  return AayProductMainListNotifier(ref, 'Aay2B');
});

final aayCardiganMainProductListProvider =
    StateNotifierProvider<AayProductMainListNotifier, List<ProductContent>>((ref) {
  // 가디건 컬렉션
  return AayProductMainListNotifier(ref, 'Aay12B');
});

final aayCoatMainProductListProvider =
    StateNotifierProvider<AayProductMainListNotifier, List<ProductContent>>((ref) {
  // 코트 컬렉션
  return AayProductMainListNotifier(ref, 'Aay11B');
});

final aayJeanMainProductListProvider =
    StateNotifierProvider<AayProductMainListNotifier, List<ProductContent>>((ref) {
  // 청바지 컬렉션
  return AayProductMainListNotifier(ref, 'Aay8B');
});

final aayMtmMainProductListProvider =
    StateNotifierProvider<AayProductMainListNotifier, List<ProductContent>>((ref) {
  // 맨투맨 컬렉션
  return AayProductMainListNotifier(ref, 'Aay3B');
});

final aayNeatMainProductListProvider =
    StateNotifierProvider<AayProductMainListNotifier, List<ProductContent>>((ref) {
  // 니트 컬렉션
  return AayProductMainListNotifier(ref, 'Aay4B');
});

final aayOnepieceMainProductListProvider =
    StateNotifierProvider<AayProductMainListNotifier, List<ProductContent>>((ref) {
  // 원피스 컬렉션
  return AayProductMainListNotifier(ref, 'Aay6B');
});

final aayPaedingMainProductListProvider =
    StateNotifierProvider<AayProductMainListNotifier, List<ProductContent>>((ref) {
  // 패딩 컬렉션
  return AayProductMainListNotifier(ref, 'Aay10B');
});

final aayPantsMainProductListProvider =
    StateNotifierProvider<AayProductMainListNotifier, List<ProductContent>>((ref) {
  // 바지 컬렉션
  return AayProductMainListNotifier(ref, 'Aay7B');
});

final aayPolaMainProductListProvider =
    StateNotifierProvider<AayProductMainListNotifier, List<ProductContent>>((ref) {
  // 폴라티 컬렉션
  return AayProductMainListNotifier(ref, 'Aay5B');
});

final aayShirtMainProductListProvider =
    StateNotifierProvider<AayProductMainListNotifier, List<ProductContent>>((ref) {
  // 셔츠 컬렉션
  return AayProductMainListNotifier(ref, 'Aay1B');
});

final aaySkirtMainProductListProvider =
    StateNotifierProvider<AayProductMainListNotifier, List<ProductContent>>((ref) {
  // 스커트 컬렉션
  return AayProductMainListNotifier(ref, 'Aay9B');
});
// ------- AayProductMainListNotifier 클래스 내용 구현 끝
// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트) 상품 데이터 불러오고 상태를 관리하는 클래스 (BaseProductListNotifier 추상 클래스를 오버라이드함-기능 상속받는 구조) 끝

// ------- 섹션 더보기 화면 (신상, ~ 겨울)) 상품 데이터 불러오고 상태를 관리하는 클래스 (BaseProductListNotifier 추상 클래스를 오버라이드함-기능 상속받는 구조) 시작
// ------- AaySectionMoreProductListNotifier 클래스 내용 구현 시작
// AayBaseProductListNotifier 클래스를 상속받는 AaySectionMoreProductListNotifier 클래스 정의
class AaySectionMoreProductListNotifier extends AayBaseProductListNotifier {
  // 생성자를 정의, ref와 baseCollection을 부모 클래스에 전달
  AaySectionMoreProductListNotifier(Ref ref, String baseCollection)
      : super(ref, baseCollection);

  // 카테고리에 따른 컬렉션 이름 리스트를 반환하는 메서드 구현
  @override
  List<String> _getCollectionNames(String category) {
    // 카테고리별로 다른 컬렉션 이름 반환 (12개의 서브 컬렉션)
    switch (category) {
      case '신상':
        return List.generate(12, (index) => '${baseCollection}${index + 1}B1');
      case '스테디 셀러':
        return List.generate(12, (index) => '${baseCollection}${index + 1}B2');
      case '특가 상품':
        return List.generate(12, (index) => '${baseCollection}${index + 1}B3');
      case '봄':
        return List.generate(12, (index) => '${baseCollection}${index + 1}B4');
      case '여름':
        return List.generate(12, (index) => '${baseCollection}${index + 1}B5');
      case '가을':
        return List.generate(12, (index) => '${baseCollection}${index + 1}B6');
      case '겨울':
        return List.generate(12, (index) => '${baseCollection}${index + 1}B7');
    // 기본적으로 신상 컬렉션 반환
      default:
        return List.generate(12, (index) => '${baseCollection}${index + 1}B1');
    }
  }
}

// 섹션 더보기 화면 관련 AaySectionMoreProductListNotifier 인스턴스를 생성하는 프로바이더 정의
// UI 코드에서 category 값을 인자로 전달하여 fetchInitialProducts와 fetchMoreProducts를 호출할 수 있음
final aayNewSubMainProductListProvider =
    StateNotifierProvider<AaySectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 신상 섹션
  return AaySectionMoreProductListNotifier(ref, 'Aay');
});

final aayBestSubMainProductListProvider =
    StateNotifierProvider<AaySectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 최고 섹션
  return AaySectionMoreProductListNotifier(ref, 'Aay');
});

final aaySaleSubMainProductListProvider =
    StateNotifierProvider<AaySectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 할인 섹션
  return AaySectionMoreProductListNotifier(ref, 'Aay');
});

final aaySpringSubMainProductListProvider =
    StateNotifierProvider<AaySectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 봄 섹션
  return AaySectionMoreProductListNotifier(ref, 'Aay');
});

final aaySummerSubMainProductListProvider =
    StateNotifierProvider<AaySectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 여름 섹션
  return AaySectionMoreProductListNotifier(ref, 'Aay');
});

final aayAutumnSubMainProductListProvider =
    StateNotifierProvider<AaySectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 가을 섹션
  return AaySectionMoreProductListNotifier(ref, 'Aay');
});

final aayWinterSubMainProductListProvider =
    StateNotifierProvider<AaySectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 겨울 섹션
  return AaySectionMoreProductListNotifier(ref, 'Aay');
});
// ------- SectionMoreProductListNotifier 클래스 내용 구현 끝
// ------- 섹션 더보기 화면 (신상, ~ 겨울)) 상품 데이터 불러오고 상태를 관리하는 클래스 (BaseProductListNotifier 추상 클래스를 오버라이드함-기능 상속받는 구조) 끝