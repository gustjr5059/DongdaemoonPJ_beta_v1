// Riverpod 라이브러리를 임포트합니다.
// 이 라이브러리는 상태 관리를 위한 강력하고 유연한 프레임워크로, 애플리케이션의 다양한 상태를 관리하는데 도움을 줍니다.
// Riverpod는 기존 Provider 라이브러리를 기반으로 하여 더욱 발전된 기능을 제공하며,
// 각종 상태 관리 요구 사항을 보다 세밀하고 효과적으로 다룰 수 있도록 설계되었습니다.
// 이를 통해 앱의 상태를 전역적으로 또는 로컬적으로 제어하고, 상태 변화에 따라 UI를 자동으로 업데이트하는 구조를 구현할 수 있습니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongdaemoon_beta_v1/market/aai/product/provider/aai_product_all_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../product/model/product_model.dart';
import '../../../../product/provider/product_state_provider.dart';
import '../../../../product/repository/product_repository.dart';

// 티셔츠 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiShirtMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 블라우스 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiBlouseMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 맨투맨 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiMtmMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 니트 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiNeatMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 폴라티 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiPolaMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 원피스 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiOnepieceMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 팬츠 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiPantsMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 청바지 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiJeanMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 스커트 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiSkirtMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 패딩 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiPaedingMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 코트 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiCoatMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 가디건 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiCardiganMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);

// 티셔츠 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiShirtMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 블라우스 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiBlouseMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 맨투맨 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiMtmMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 니트 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiNeatMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 폴라티 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiPolaMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 원피스 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiOnepieceMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 팬츠 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiPantsMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 청바지 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiJeanMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 스커트 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiSkirtMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 패딩 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiPaedingMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 코트 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiCoatMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 가디건 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiCardiganMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);

// 신상 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiNewSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 최고 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiBestSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 할인 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiSaleSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 봄 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiSpringSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 여름 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiSummerSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 가을 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiAutumnSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 겨울 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final aaiWinterSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);

// 신상 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiNewSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 최고 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiBestSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 할인 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiSaleSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 봄 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiSpringSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 여름 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiSummerSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 가을 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiAutumnSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 겨울 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final aaiWinterSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);

// 각 카테고리별 상세화면에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final aaiBlouseDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiCardiganDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiCoatDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiJeanDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiMtmDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiNeatDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiOnepieceDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiPaedingDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiPantsDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiPolaDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiShirtDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiSkirtDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
// ------- 상품 상세 화면 관련 StateProvider 끝

// 현재 선택된 상단 탭 바 관련 탭의 인덱스 상태 관리를 위한 StateProvider
final aaiBlouseCurrentTabProvider = StateProvider<int>((ref) => 0);
final aaiCardiganCurrentTabProvider = StateProvider<int>((ref) => 0);
final aaiCoatCurrentTabProvider = StateProvider<int>((ref) => 0);
final aaiJeanCurrentTabProvider = StateProvider<int>((ref) => 0);
final aaiMtmCurrentTabProvider = StateProvider<int>((ref) => 0);
final aaiNeatCurrentTabProvider = StateProvider<int>((ref) => 0);
final aaiOnepieceCurrentTabProvider = StateProvider<int>((ref) => 0);
final aaiPaedingCurrentTabProvider = StateProvider<int>((ref) => 0);
final aaiPantsCurrentTabProvider = StateProvider<int>((ref) => 0);
final aaiPolaCurrentTabProvider = StateProvider<int>((ref) => 0);
final aaiShirtCurrentTabProvider = StateProvider<int>((ref) => 0);
final aaiSkirtCurrentTabProvider = StateProvider<int>((ref) => 0);

// 각 카테고리별 메인화면에서 각 상단 탭 바 관련 섹션의 스크롤 위치와 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final aaiBlouseMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiCardiganMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiCoatMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiJeanMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiMtmMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiNeatMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiOnepieceMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiPaedingMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiPantsMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiPolaMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiShirtMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiSkirtMainScrollPositionProvider = StateProvider<double>((ref) => 0);

// 각 섹션별 서브 메인 화면(섹션 더보기 화면)에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final aaiNewSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiBestSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiSaleSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiSpringSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiSummerSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiAutumnSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final aaiWinterSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);

// 2차 메인 화면 내 가격순, 할인순 버튼 관련 상태 관리 함수인 StateProvider
final aaiBlouseMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiCardiganMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiCoatMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiJeanMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiMtmMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiNeatMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiOnepieceMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiPaedingMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiPantsMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiPolaMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiShirtMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiSkirtMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정

// 섹션 더보기 화면 내 가격순, 할인순 버튼 관련 상태 관리 함수인 StateProvider
final aaiNewSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiBestSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiSaleSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiSpringSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiSummerSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiAutumnSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final aaiWinterSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정

// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트)과 섹션 더보기 화면 (신상, ~ 겨울)) 상품 데이터 불러오고 상태를 관리하는 기본 추상 클래스 시작
// ------- AaiBaseProductListNotifier 클래스 내용 구현 시작
// 해당 내용은 추상 클래스이며, 해당 클래스를 다른 클래스에 오버라이드(extends 사용)를 하면 해당 클래스 기능은 그대로 사용하면서 추가되는 내용을 각기 적용 가능하므로, 이렇게 구성

// 상태 관리 추상 클래스 AaiBaseProductListNotifier를 정의 (상품 데이터 관리)
abstract class AaiBaseProductListNotifier
    extends StateNotifier<List<ProductContent>> {
  // 생성자를 정의, ref와 baseCollection을 초기화
  AaiBaseProductListNotifier(this.ref, this.baseCollection) : super([]);

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
        // AaiMainCategoryProductsRepository 인스턴스를 제공하는 aaiMainProductRepositoryProvider를 불러오도록 함
        // 섹션 더보기 화면인 AaiSectionMoreProductListNotifier인 경우에는 AaiSectionCategoryProductsRepository 인스턴스를 제공하는 aaiSectionProductRepositoryProvider를 불러오도록 함
        final CategoryProductsRepository repository = this is AaiProductMainListNotifier
            ? ref.read(aaiMainProductRepositoryProvider)
            : ref.read(aaiSectionProductRepositoryProvider);

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
    final CategoryProductsRepository repository = this is AaiProductMainListNotifier
    // 만약 현재 클래스가 AaiProductMainListNotifier 타입이라면,
        ? ref.read(aaiMainProductRepositoryProvider)
    // aaiMainProductRepositoryProvider를 사용하여 메인 제품 레퍼지토리를 불러옴.
        : ref.read(aaiSectionProductRepositoryProvider);
    // 그렇지 않다면 aaiSectionProductRepositoryProvider를 사용하여 섹션별 제품 레퍼지토리를 불러옴.
    repository.reset();
    // 불러온 레퍼지토리의 상태를 reset() 함수를 호출하여 초기화.
    debugPrint('상태 초기화 완료.');
  }

  // 카테고리에 따른 컬렉션 이름 리스트를 반환하는 추상 메서드
  List<String> _getCollectionNames(String category);
}
// ------- AaiBaseProductListNotifier 클래스 내용 구현 끝
// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트)과 섹션 더보기 화면 (신상, ~ 겨울)) 상품 데이터 불러오고 상태를 관리하는 기본 추상 클래스 끝

// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트) 상품 데이터 불러오고 상태를 관리하는 클래스 (BaseProductListNotifier 추상 클래스를 오버라이드함-기능 상속받는 구조) 시작
// ------- AaiProductMainListNotifier 클래스 내용 구현 시작
// AaiBaseProductListNotifier 클래스를 상속받는 AaiProductMainListNotifier 클래스 정의
class AaiProductMainListNotifier extends AaiBaseProductListNotifier {

  // 생성자를 정의, ref와 baseCollection을 부모 클래스에 전달
  AaiProductMainListNotifier(Ref ref, String baseCollection)
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

// 2차 메인 화면 관련 AaiProductMainListNotifier 인스턴스를 생성하는 프로바이더 정의
// UI 코드에서 category 값을 인자로 전달하여 fetchInitialProducts와 fetchMoreProducts를 호출할 수 있음
final aaiBlouseMainProductListProvider =
    StateNotifierProvider<AaiProductMainListNotifier, List<ProductContent>>((ref) {
  // 블라우스 컬렉션
  return AaiProductMainListNotifier(ref, 'Aai2B');
});

final aaiCardiganMainProductListProvider =
    StateNotifierProvider<AaiProductMainListNotifier, List<ProductContent>>((ref) {
  // 가디건 컬렉션
  return AaiProductMainListNotifier(ref, 'Aai12B');
});

final aaiCoatMainProductListProvider =
    StateNotifierProvider<AaiProductMainListNotifier, List<ProductContent>>((ref) {
  // 코트 컬렉션
  return AaiProductMainListNotifier(ref, 'Aai11B');
});

final aaiJeanMainProductListProvider =
    StateNotifierProvider<AaiProductMainListNotifier, List<ProductContent>>((ref) {
  // 청바지 컬렉션
  return AaiProductMainListNotifier(ref, 'Aai8B');
});

final aaiMtmMainProductListProvider =
    StateNotifierProvider<AaiProductMainListNotifier, List<ProductContent>>((ref) {
  // 맨투맨 컬렉션
  return AaiProductMainListNotifier(ref, 'Aai3B');
});

final aaiNeatMainProductListProvider =
    StateNotifierProvider<AaiProductMainListNotifier, List<ProductContent>>((ref) {
  // 니트 컬렉션
  return AaiProductMainListNotifier(ref, 'Aai4B');
});

final aaiOnepieceMainProductListProvider =
    StateNotifierProvider<AaiProductMainListNotifier, List<ProductContent>>((ref) {
  // 원피스 컬렉션
  return AaiProductMainListNotifier(ref, 'Aai6B');
});

final aaiPaedingMainProductListProvider =
    StateNotifierProvider<AaiProductMainListNotifier, List<ProductContent>>((ref) {
  // 패딩 컬렉션
  return AaiProductMainListNotifier(ref, 'Aai10B');
});

final aaiPantsMainProductListProvider =
    StateNotifierProvider<AaiProductMainListNotifier, List<ProductContent>>((ref) {
  // 바지 컬렉션
  return AaiProductMainListNotifier(ref, 'Aai7B');
});

final aaiPolaMainProductListProvider =
    StateNotifierProvider<AaiProductMainListNotifier, List<ProductContent>>((ref) {
  // 폴라티 컬렉션
  return AaiProductMainListNotifier(ref, 'Aai5B');
});

final aaiShirtMainProductListProvider =
    StateNotifierProvider<AaiProductMainListNotifier, List<ProductContent>>((ref) {
  // 셔츠 컬렉션
  return AaiProductMainListNotifier(ref, 'Aai1B');
});

final aaiSkirtMainProductListProvider =
    StateNotifierProvider<AaiProductMainListNotifier, List<ProductContent>>((ref) {
  // 스커트 컬렉션
  return AaiProductMainListNotifier(ref, 'Aai9B');
});
// ------- AaiProductMainListNotifier 클래스 내용 구현 끝
// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트) 상품 데이터 불러오고 상태를 관리하는 클래스 (BaseProductListNotifier 추상 클래스를 오버라이드함-기능 상속받는 구조) 끝

// ------- 섹션 더보기 화면 (신상, ~ 겨울)) 상품 데이터 불러오고 상태를 관리하는 클래스 (BaseProductListNotifier 추상 클래스를 오버라이드함-기능 상속받는 구조) 시작
// ------- AaiSectionMoreProductListNotifier 클래스 내용 구현 시작
// AaiBaseProductListNotifier 클래스를 상속받는 AaiSectionMoreProductListNotifier 클래스 정의
class AaiSectionMoreProductListNotifier extends AaiBaseProductListNotifier {
  // 생성자를 정의, ref와 baseCollection을 부모 클래스에 전달
  AaiSectionMoreProductListNotifier(Ref ref, String baseCollection)
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

// 섹션 더보기 화면 관련 AaiSectionMoreProductListNotifier 인스턴스를 생성하는 프로바이더 정의
// UI 코드에서 category 값을 인자로 전달하여 fetchInitialProducts와 fetchMoreProducts를 호출할 수 있음
final aaiNewSubMainProductListProvider =
    StateNotifierProvider<AaiSectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 신상 섹션
  return AaiSectionMoreProductListNotifier(ref, 'Aai');
});

final aaiBestSubMainProductListProvider =
    StateNotifierProvider<AaiSectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 최고 섹션
  return AaiSectionMoreProductListNotifier(ref, 'Aai');
});

final aaiSaleSubMainProductListProvider =
    StateNotifierProvider<AaiSectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 할인 섹션
  return AaiSectionMoreProductListNotifier(ref, 'Aai');
});

final aaiSpringSubMainProductListProvider =
    StateNotifierProvider<AaiSectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 봄 섹션
  return AaiSectionMoreProductListNotifier(ref, 'Aai');
});

final aaiSummerSubMainProductListProvider =
    StateNotifierProvider<AaiSectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 여름 섹션
  return AaiSectionMoreProductListNotifier(ref, 'Aai');
});

final aaiAutumnSubMainProductListProvider =
    StateNotifierProvider<AaiSectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 가을 섹션
  return AaiSectionMoreProductListNotifier(ref, 'Aai');
});

final aaiWinterSubMainProductListProvider =
    StateNotifierProvider<AaiSectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 겨울 섹션
  return AaiSectionMoreProductListNotifier(ref, 'Aai');
});
// ------- SectionMoreProductListNotifier 클래스 내용 구현 끝
// ------- 섹션 더보기 화면 (신상, ~ 겨울)) 상품 데이터 불러오고 상태를 관리하는 클래스 (BaseProductListNotifier 추상 클래스를 오버라이드함-기능 상속받는 구조) 끝