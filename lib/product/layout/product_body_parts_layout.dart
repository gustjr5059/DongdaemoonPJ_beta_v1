
import 'dart:io' show Platform;
// iOS 스타일의 인터페이스 요소를 사용하기 위해 Cupertino 디자인 패키지를 임포트합니다.
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

// Android 및 기본 플랫폼 스타일의 인터페이스 요소를 사용하기 위해 Material 디자인 패키지를 임포트합니다.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 상태 관리를 위해 사용되는 Riverpod 패키지를 임포트합니다.
// Riverpod는 애플리케이션의 다양한 상태를 관리하는 데 도움을 주는 강력한 도구입니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// 애플리케이션에서 사용할 색상 상수들을 정의한 파일을 임포트합니다.
import '../../announcement/provider/announce_state_provider.dart';
import '../../cart/provider/cart_state_provider.dart';
import '../../common/const/colors.dart';

// 제품 데이터 모델을 정의한 파일을 임포트합니다.
// 이 모델은 제품의 속성을 정의하고, 애플리케이션에서 제품 데이터를 구조화하는 데 사용됩니다.
import '../../common/layout/common_body_parts_layout.dart';
import '../../common/provider/common_state_provider.dart';
import '../../home/provider/home_state_provider.dart';
import '../../inquiry/provider/inquiry_state_provider.dart';
import '../../manager/message/provider/message_all_provider.dart';
import '../../manager/message/provider/message_state_provider.dart';
import '../../manager/orderlist/provider/orderlist_all_provider.dart';
import '../../manager/orderlist/provider/orderlist_state_provider.dart';
import '../../manager/review/provider/review_state_provider.dart';
import '../../message/provider/message_all_provider.dart';
import '../../message/provider/message_state_provider.dart';
import '../../order/provider/complete_payment_provider.dart';
import '../../order/provider/order_all_providers.dart';
import '../../order/provider/order_state_provider.dart';
import '../../review/provider/review_all_provider.dart';
import '../../review/provider/review_state_provider.dart';
import '../../user/provider/profile_state_provider.dart';
import '../../wishlist/layout/wishlist_body_parts_layout.dart';
import '../../wishlist/provider/wishlist_state_provider.dart';
import '../model/product_model.dart';

// 제품 상태 관리를 위한 StateProvider 파일을 임포트합니다.
import '../provider/product_state_provider.dart';

// 각 의류 카테고리에 대한 상세 화면 구현 파일들을 임포트합니다.
// 이 파일들은 각 카테고리별 제품의 상세 정보를 표시하는 화면을 정의합니다.
import '../view/detail_screen/blouse_detail_screen.dart'; // 블라우스 상세 화면
import '../view/detail_screen/cardigan_detail_screen.dart'; // 가디건 상세 화면
import '../view/detail_screen/coat_detail_screen.dart'; // 코트 상세 화면
import '../view/detail_screen/jean_detail_screen.dart'; // 청바지 상세 화면
import '../view/detail_screen/mtm_detail_screen.dart'; // 맨투맨 상세 화면
import '../view/detail_screen/neat_detail_screen.dart'; // 니트 상세 화면
import '../view/detail_screen/onepiece_detail_screen.dart'; // 원피스 상세 화면
import '../view/detail_screen/paeding_detail_screen.dart'; // 패딩 상세 화면
import '../view/detail_screen/pants_detail_screen.dart'; // 바지 상세 화면
import '../view/detail_screen/pola_detail_screen.dart'; // 폴라(터틀넥) 상세 화면
import '../view/detail_screen/product_detail_original_image_screen.dart';
import '../view/detail_screen/shirt_detail_screen.dart'; // 셔츠 상세 화면
import '../view/detail_screen/skirt_detail_screen.dart'; // 스커트 상세 화면

// ------ pageViewWithArrows 위젯 내용 구현 시작
// PageView와 화살표 버튼을 포함하는 위젯
// 사용자가 페이지를 넘길 수 있도록 함.
Widget pageViewWithArrows(
  BuildContext context,
  PageController pageController, // 페이지 전환을 위한 컨트롤러
  WidgetRef ref, // Riverpod 상태 관리를 위한 ref
  StateProvider<int> currentPageProvider, {
  // 현재 페이지 인덱스를 관리하기 위한 StateProvider
  required IndexedWidgetBuilder itemBuilder, // 각 페이지를 구성하기 위한 함수
  required int itemCount, // 전체 페이지 수
}) {
  int currentPage = ref.watch(currentPageProvider); // 현재 페이지 인덱스를 관찰
  return Stack(
    alignment: Alignment.center,
    children: [
      PageView.builder(
        controller: pageController, // 페이지 컨트롤러 할당
        itemCount: itemCount, // 페이지 수 설정
        onPageChanged: (index) {
          ref.read(currentPageProvider.notifier).state =
              index; // 페이지가 변경될 때마다 인덱스 업데이트
        },
        itemBuilder: itemBuilder, // 페이지를 구성하는 위젯을 생성
      ),
      // 왼쪽 화살표 버튼. 첫 페이지가 아닐 때만 활성화됩니다.
      arrowButton(
          context,
          Icons.arrow_back_ios,
          currentPage > 0,
          () => pageController.previousPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut),
          currentPageProvider,
          ref),
      // 오른쪽 화살표 버튼. 마지막 페이지가 아닐 때만 활성화됩니다.
      // 현재 페이지 < 전체 페이지 수 - 1 의 조건으로 변경하여 마지막 페이지 검사를 보다 정확하게 합니다.
      arrowButton(
          context,
          Icons.arrow_forward_ios,
          currentPage < itemCount - 1,
          () => pageController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut),
          currentPageProvider,
          ref),
    ],
  );
}
// ------ pageViewWithArrows 위젯 내용 구현 끝

// ------ arrowButton 위젯 내용 구현 시작
// 화살표 버튼을 생성하는 위젯(함수)
// 화살표 버튼을 통해 사용자는 페이지를 앞뒤로 넘길 수 있음.
Widget arrowButton(
    BuildContext context,
    IconData icon,
    bool isActive,
    VoidCallback onPressed,
    StateProvider<int> currentPageProvider,
    WidgetRef ref) {
  return Positioned(
    left: icon == Icons.arrow_back_ios ? 10 : null, // 왼쪽 화살표 위치 조정
    right: icon == Icons.arrow_forward_ios ? 10 : null, // 오른쪽 화살표 위치 조정
    child: IconButton(
      icon: Icon(icon),
      color: isActive ? Colors.black : Colors.grey, // 활성화 여부에 따라 색상 변경
      onPressed: isActive ? onPressed : null, // 활성화 상태일 때만 동작
    ),
  );
}
// ------ arrowButton 위젯 내용 구현 끝

// ------ 가격 순, 할인율 순 관련 분류가능하도록 하는 버튼인 PriceAndDiscountPercentSortButtons 클래스 내용 구현 시작
class PriceAndDiscountPercentSortButtons<T extends BaseProductListNotifier>
    extends ConsumerWidget {
  // StateNotifierProvider와 StateProvider를 필드로 선언
  final StateNotifierProvider<T, List<ProductContent>> productListProvider;
  final StateProvider<String> sortButtonProvider;

  // 생성자: 필수 인자 productListProvider와 sortButtonProvider를 받아서 초기화
  PriceAndDiscountPercentSortButtons({
    required this.productListProvider,
    required this.sortButtonProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 선택된 정렬 타입을 감시
    final selectedSortType = ref.watch(sortButtonProvider);
    // print("현재 정렬 상태: $selectedSortType");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      // 좌우 및 상하 패딩 설정
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // 자식 위젯 사이의 공간을 고르게 분배
        children: [
          _buildExpandedSortButton(context, '가격 높은 순', ref, selectedSortType),
          // 가격 높은 순 버튼 생성
          _buildExpandedSortButton(context, '가격 낮은 순', ref, selectedSortType),
          // 가격 낮은 순 버튼 생성
          _buildExpandedSortButton(context, '할인율 높은 순', ref, selectedSortType),
          // 할인율 높은 순 버튼 생성
          _buildExpandedSortButton(context, '할인율 낮은 순', ref, selectedSortType),
          // 할인율 낮은 순 버튼 생성
        ],
      ),
    );
  }

  // 버튼 세부 내용인 _buildExpandedSortButton 위젯
  Widget _buildExpandedSortButton(BuildContext context, String title,
      WidgetRef ref, String selectedSortType) {
    // 현재 버튼이 선택된 상태인지 여부를 결정
    final bool isSelected = selectedSortType == title;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0), // 좌우 패딩 설정
        child: ElevatedButton(
          onPressed: () {
            ref.read(sortButtonProvider.notifier).state =
                title; // 버튼 클릭 시 정렬 상태 업데이트
            ref.read(productListProvider.notifier).sortType =
                title; // 상품 데이터 정렬 상태 업데이트
            // print("정렬 버튼 클릭: $title");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: BUTTON_COLOR,
            // 버튼 배경 색상 설정
            foregroundColor: isSelected ? GOLD_COLOR : INPUT_BORDER_COLOR,
            // 선택된 버튼의 텍스트 색상 설정
            minimumSize: Size(0, 40),
            // 최소 버튼 크기 설정
            padding: EdgeInsets.symmetric(horizontal: 8.0), // 버튼 내 패딩 설정
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown, // 텍스트 크기를 버튼 크기에 맞게 조절
            child: Text(
              title,
              textAlign: TextAlign.center, // 텍스트 가운데 정렬
              style: TextStyle(fontSize: 14), // 텍스트 크기를 14로 설정
            ),
          ),
        ),
      ),
    );
  }
}
// ------ 가격 순, 할인율 순 관련 분류가능하도록 하는 버튼인 PriceAndDiscountPercentSortButtons 클래스 내용 구현 끝

// ------- ProductsSectionList 클래스 내용 구현 시작
// 주로, 홈 화면 내 2차 카테고리별 섹션 내 데이터를 4개 단위로 스크롤뷰로 UI 구현하는 부분 관련 로직
class ProductsSectionList extends ConsumerStatefulWidget {
  final String category; // 카테고리 이름을 저장하는 필드
  final Future<List<ProductContent>> Function(
      int limit, DocumentSnapshot? startAfter) fetchProducts; // 제품을 가져오는 비동기 함수

  // 생성자
  ProductsSectionList({required this.category, required this.fetchProducts});

  @override
  _ProductsSectionListState createState() =>
      _ProductsSectionListState(); // 상태 객체 생성
}

class _ProductsSectionListState extends ConsumerState<ProductsSectionList> {
  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러 초기화
  bool _isFetching = false; // 데이터 가져오는 중인지 확인하는 플래그
  DocumentSnapshot? _lastDocument; // 마지막 문서 스냅샷 저장

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener); // 스크롤 리스너 추가
    // 이미 저장된 홈 화면 내 섹션 데이터를 로드
    final savedProducts = ref
        .read(homeSectionDataStateProvider.notifier)
        .getSectionProducts(widget.category);
    if (savedProducts.isNotEmpty) {
      setState(() {
        _lastDocument = savedProducts.last.documentSnapshot; // 마지막 문서 스냅샷 업데이트
      });
    } else {
      _fetchInitialProducts(); // 초기 데이터를 가져오는 함수 호출
    }

    // 저장된 홈 화면 내 섹션 스크롤 위치를 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final savedScrollPosition =
          ref.read(homeSectionScrollPositionsProvider)[widget.category] ?? 0;
      _scrollController.jumpTo(savedScrollPosition); // 스크롤 위치 설정
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener); // 스크롤 리스너 제거
    _scrollController.dispose(); // 스크롤 컨트롤러 해제
    super.dispose();
  }

  // 스크롤 리스너 함수
  void _scrollListener() {
    // 스크롤이 끝에 도달하고 데이터를 가져오는 중이 아닐 때
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetching) {
      _fetchMoreProducts(); // 추가 제품 데이터 가져오기 호출
    }

    // 현재 홈 화면 내 섹션 스크롤 위치를 저장
    ref.read(homeSectionScrollPositionsProvider.notifier).state = {
      ...ref.read(homeSectionScrollPositionsProvider),
      widget.category: _scrollController.position.pixels,
    };
  }

  // 초기 제품 데이터를 가져오는 함수
  Future<void> _fetchInitialProducts() async {
    setState(() {
      _isFetching = true; // 데이터 가져오는 중 상태로 설정
    });
    try {
      final products = await widget.fetchProducts(4, null); // 초기 4개 제품 데이터 가져오기
      setState(() {
        ref
            .read(homeSectionDataStateProvider.notifier)
            .updateSection(widget.category, products); // 섹션 내 제품 데이터 상태 업데이트
        if (products.isNotEmpty) {
          _lastDocument = products.last.documentSnapshot; // 마지막 문서 스냅샷 업데이트
        }
      });
    } catch (e) {
      debugPrint('Error fetching initial products: $e'); // 에러 출력
    } finally {
      setState(() {
        _isFetching = false; // 데이터 가져오기 완료 상태로 설정
      });
    }
  }

  // 추가 제품 데이터를 가져오는 함수
  Future<void> _fetchMoreProducts() async {
    if (_isFetching) return; // 이미 데이터를 가져오는 중이면 반환
    setState(() {
      _isFetching = true; // 데이터 가져오는 중 상태로 설정
    });
    try {
      final products =
          await widget.fetchProducts(4, _lastDocument); // 추가 4개 제품 데이터 가져오기
      setState(() {
        final currentProducts = ref
            .read(homeSectionDataStateProvider.notifier)
            .getSectionProducts(widget.category); // 현재 섹션 내 제품 리스트 가져오기
        final updatedProducts =
            currentProducts + products; // 새로운 섹션 내 제품 리스트와 병합
        ref.read(homeSectionDataStateProvider.notifier).updateSection(
            widget.category, updatedProducts); // 섹션 내 제품 데이터 상태 업데이트
        if (products.isNotEmpty) {
          _lastDocument = products.last.documentSnapshot; // 마지막 문서 스냅샷 업데이트
        }
      });
    } catch (e) {
      debugPrint('Error fetching more products: $e'); // 에러 출력
    } finally {
      setState(() {
        _isFetching = false; // 데이터 가져오기 완료 상태로 설정
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(homeSectionDataStateProvider)[widget.category] ??
        []; // 현재 카테고리의 제품 리스트 가져오기
    return Column(
      children: [
        buildHorizontalDocumentsList(
            ref, products, context, widget.category, _scrollController),
        // 가로 스크롤 문서 리스트 빌드
        if (_isFetching) CircularProgressIndicator(),
        // 데이터 가져오는 중일 때 로딩 인디케이터 표시
      ],
    );
  }
}
// ------- ProductsSectionList 클래스 내용 구현 끝

// ------- provider로부터 데이터 받아와서 UI에 구현하는 3개씩 열로 데이터를 보여주는 UI 구현 관련
// GeneralProductList 클래스 내용 구현 시작
class GeneralProductList<T extends BaseProductListNotifier>
    extends ConsumerStatefulWidget {
  final ScrollController scrollController; // 스크롤 컨트롤러 선언
  final StateNotifierProvider<T, List<ProductContent>>
      productListProvider; // 제품 목록 provider 선언
  final String category; // 카테고리 선언

  GeneralProductList({
    required this.scrollController,
    required this.productListProvider,
    required this.category,
  }); // 생성자 정의

  @override
  _ProductListState createState() => _ProductListState(); // 상태 생성 메소드 정의
}

class _ProductListState extends ConsumerState<GeneralProductList> {
  @override
  void initState() {
    super.initState(); // 부모 클래스의 initState 호출
    widget.scrollController.addListener(_scrollListener); // 스크롤 리스너 추가
    // 위젯이 완전히 빌드된 후에 초기 데이터 로드 작업을 수행하기 위해 Future.delayed(Duration.zero)를 사용
    Future.delayed(Duration.zero, () {
      if (ref.read(widget.productListProvider).isEmpty) {
        // 제품 목록이 비어있다면
        ref
            .read(widget.productListProvider.notifier)
            .fetchInitialProducts(widget.category); // 초기 제품 가져오기 호출
      }
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener); // 스크롤 리스너 제거
    super.dispose(); // 부모 클래스의 dispose 호출
  }

  // 스크롤 리스너 함수
  void _scrollListener() {
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent - 200) {
      // 스크롤이 끝에 가까워지면
      ref
          .read(widget.productListProvider.notifier)
          .fetchMoreProducts(widget.category); // 더 많은 제품 가져오기 호출
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(widget.productListProvider); // 제품 목록 상태 감시
    final isFetching = ref.watch(widget.productListProvider.notifier
        .select((notifier) => notifier.isFetching)); // 가져오는 중인지 상태 감시

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          // 높이 제한
          physics: NeverScrollableScrollPhysics(),
          // 스크롤 비활성화
          padding: EdgeInsets.symmetric(vertical: 10.0),
          // 상하 패딩 설정
          itemCount: (products.length / 3).ceil(),
          // 행의 개수 계산
          itemBuilder: (context, index) {
            int startIndex = index * 3; // 시작 인덱스 계산
            int endIndex = startIndex + 3; // 끝 인덱스 계산
            if (endIndex > products.length) {
              // 끝 인덱스가 제품 개수보다 많으면
              endIndex = products.length; // 끝 인덱스를 제품 개수로 조정
            }
            List<ProductContent> productRow =
                products.sublist(startIndex, endIndex); // 행에 들어갈 제품들 추출
            return buildGeneralProductRow(
                ref, productRow, context); // 행 빌드 함수 호출
          },
        ),
        if (isFetching) // 가져오는 중이라면
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(), // 로딩 표시
          ),
      ],
    );
  }
}
// ------- provider로부터 데이터 받아와서 UI에 구현하는 3개씩 열로 데이터를 보여주는 UI 구현 관련
// GeneralProductList 클래스 내용 구현 끝

// ------- 데이터를 열로 나열하는 UI 구현 관련 buildGeneralProductRow 위젯 내용 구현 시작
Widget buildGeneralProductRow(
    WidgetRef ref, List<ProductContent> products, BuildContext context) {
  final productInfo =
      ProductInfoDetailScreenNavigation(ref); // 제품 정보 상세 화면 내비게이션 객체 생성

  return Row(
    children: products
        .map((product) => Expanded(
              // 각 제품을 확장된 위젯으로 변환
              child: Padding(
                padding: const EdgeInsets.all(2.0), // 패딩 설정
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬 설정
                  children: [
                    productInfo.buildProdFirestoreDetailDocument(
                        context, product, ref),
                    // 제품 정보 상세 화면 빌드 함수 호출
                  ],
                ),
              ),
            ))
        .toList(), // 리스트로 변환
  );
}
// ------- 데이터를 열로 나열하는 UI 구현 관련 buildGeneralProductRow 위젯 내용 구현 끝

// 로그아웃 및 자동로그인 체크 상태에서 앱 종료 후 재실행 시,
// 홈 내 섹션의 데이터 초기화 / 홈 화면 내 섹션의 스크롤 위치 초기화
// / 홈,장바구니,발주내역,마이페이지,2차 메인 화면 등 모든 화면화면 자체의 스크롤 위치 초기화 관련 함수
Future<void> logoutAndLoginAfterProviderReset(WidgetRef ref) async {
  // 로그아웃 기능 수행
  await FirebaseAuth.instance.signOut(); // Firebase 인증 로그아웃
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // 자동 로그인 정보 삭제 및 비활성화
  prefs.setBool('autoLogin', false); // 자동 로그인 체크박스 비활성화
  // prefs.remove('autoLogin'); // 자동 로그인 정보 삭제
  prefs.remove('username'); // 저장된 사용자명 삭제
  prefs.remove('password'); // 저장된 비밀번호 삭제

  // 로그아웃했다가 재로그인 시, 초가화하려면 여기에 적용시켜야 반영이 됨
  // 모든 화면에서 로그아웃 버튼을 클릭했을 때 모든 화면의 상태를 초기화하는 로직-앱 종료 후 재실행할 때인 경우에도 여기 포함됨
  // 각 화면마다의 FirebaseAuth.instance.authStateChanges().listen((user) 여기에도 provider 구현하고, 여기에도 구현하는 두 곳 다 구현해야함.
  // 홈 화면 관련 초기화 부분 시작
  // 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(homeScrollPositionProvider.notifier).state =
      0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(homeCurrentTabProvider.notifier).state =
      0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(homeSectionScrollPositionsProvider.notifier).state =
      {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
  ref.read(midCategoryViewBoolExpandedProvider.notifier).state =
      false; // 홈 화면 내 카테고리 버튼 뷰 확장 상태 관련 provider를 초기화
  ref.read(homeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(homeSmall1BannerPageProvider.notifier).state = 0; // 홈 소배너1 페이지뷰 초기화
  ref.read(homeSmall2BannerPageProvider.notifier).state = 0; // 홈 소배너2 페이지뷰 초기화
  ref.read(homeSmall3BannerPageProvider.notifier).state = 0; // 홈 소배너3 페이지뷰 초기화
  // 홈 화면 관련 초기화 부분 끝

  // 장바구니 화면 관련 초기화 부분 시작
  // 장바구니 화면에서 단순 화면 스크롤 초기화
  ref.read(cartScrollPositionProvider.notifier).state =
  0.0;
  ref.invalidate(cartItemsProvider); // 장바구니 데이터 초기화
  // 장바구니 화면 관련 초기화 부분 끝

  // 발주 내역 화면 관련 초기화 부분 시작
  // 발주 내역 화면에서 단순 화면 스크롤 초기화
  ref.read(orderListScrollPositionProvider.notifier).state =
  0.0;
  // 발주 목록 내 데이터를 불러오는 orderListProvider 초기화
  ref.invalidate(orderListProvider);
  // 발주 내역 화면 관련 초기화 부분 끝

  // 발주 내역 상세 화면 관련 초기화 부분 시작
  // 발주 화면에서 로그아웃 이벤트를 실시간으로 감지하고 처리하는 로직 (여기에도 발주 화면 내 프로바이더 중 초기화해야하는 것을 로직 구현)
  ref.read(orderListDetailScrollPositionProvider.notifier).state =
  0.0; // 발주 화면 자체의 스크롤 위치 인덱스를 초기화
  // 발주 목록 상세 화면 내 발주내역 데이터를 불러오는 로직 초기화
  ref.invalidate(orderListDetailProvider);
  // 발주 목록 상세 화면 내 '환불' 버튼과 '리뷰 작성' 버튼 활성도 관련 데이터를 불러오는 로직 초기화
  ref.invalidate(buttonInfoProvider);
  // 발주 내역 상세 화면 관련 초기화 부분 끝

  // 발주 화면 관련 초기화 부분 시작
  // 발주 화면에서 단순 화면 스크롤 초기화
  ref.read(orderMainScrollPositionProvider.notifier).state =
  0.0;
  // 발주 화면 관련 초기화 부분 끝

  // 발주 완료 화면 관련 초기화 부분 시작
  // 발주 완료 화면에서 단순 화면 스크롤 초기화
  ref.read(completePaymentScrollPositionProvider.notifier).state =
  0.0;
  // 발주 완료 화면 관련 초기화 부분 끝

  // 찜 목록 화면 관련 초기화 부분 시작
  // 찜 목록 화면에서 단순 화면 스크롤 초기화
  ref.read(wishlistScrollPositionProvider.notifier).state =
  0.0;
  ref.invalidate(wishlistItemProvider); // 찜 목록 데이터 초기화
  // 찜 목록 화면 관련 초기화 부분 끝

  // 마이페이지 화면 관련 초기화 부분 시작
  ref.read(profileMainScrollPositionProvider.notifier).state =
  0.0; // 마이페이지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(profileMainSmall1BannerPageProvider.notifier).state = 0; // 마이페이지 소배너 페이지뷰 초기화
  // 머아패아자 화면 관련 초기화 부분 끝

  // 공지사항 화면 관련 초기화 부분 시작
  ref.read(announceScrollPositionProvider.notifier).state =
  0.0; // 공지사항 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  // 공지사항 화면 관련 초기화 부분 끝

  // 문의하기 화면 관련 초기화 부분 시작
  ref.read(inquiryScrollPositionProvider.notifier).state =
  0.0; // 문의하기 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  // 문의하기 화면 관련 초기화 부분 끝

  // 쪽지 관리 화면 관련 초기화 부분 시작
  ref.read(privateMessageScrollPositionProvider.notifier).state =
  0.0; // 쪽지 관리 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.invalidate(currentUserEmailProvider); // 현재 사용자 이메일 데이터 초기화
  // 계정별로 불러오는 마이페이지용 쪽지함 내 메시지 데이터 불러오는 로직 초기화
  ref.invalidate(fetchMinutesMessagesProvider); // 1분 이내 타임의 메시지 데이터 불러오는 로직 초기화
  ref.invalidate(fetchDaysMessagesProvider); // 30일 이내 타임의 메시지 데이터 불러오는 로직 초기화
  ref.invalidate(fetchYearMessagesProvider); // 1년 이내 타임의 메시지 데이터 불러오는 로직 초기화
  ref.invalidate(paymentCompleteDateProvider); // 결제완료일 데이터 초기화
  ref.invalidate(deliveryStartDateProvider); // 배송시작일 데이터 초기화
  // 쪽지 관리 화면 관련 초기화 부분 끝

  // 리뷰 관리 화면 관련 초기화 부분 시작
  ref.read(privateReviewScrollPositionProvider.notifier).state =
  0.0; // 리뷰 관리 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.invalidate(reviewUserOrdersProvider); // 리뷰 작성 데이터를 초기화
  ref.read(privateReviewScreenTabProvider.notifier).state = ReviewScreenTab.create; // 리뷰 작성/목록 탭 초기화
  // 리뷰 관리 화면 중 리뷰 작성 탭 화면 내 '환불' 버튼과 '리뷰 작성' 버튼 활성도 관련 데이터를 불러오는 로직 초기화
  ref.invalidate(buttonInfoProvider);
  ref.invalidate(reviewListProvider); // 리뷰 목록 초기화
  ref.invalidate(deleteReviewProvider); // 리뷰 삭제 관련 데이터 초기화
  // 리뷰 관리 화면 관련 초기화 부분 끝

  // ------ 관리자용 화면인 리뷰관리, 쪽지관리, 발주내역 관리, 찜 목록 괸리, 공지사항 관리 관련 초기화 부분 시작
  // 리뷰 관리 화면 초기화 시작
  ref.read(adminReviewScrollPositionProvider.notifier).state = 0.0;
  // 리뷰 관리 화면 초기화 끝

  // 쪽지 관리 화면 초기화 시작
  ref.read(adminMessageScrollPositionProvider.notifier).state = 0.0;
  // 쪽지 관리 화면 내 발신자 관련 로그인한 이메일 계정 데이터 불러오는 로직 초기화
  ref.invalidate(currentUserProvider);
  // 쪽지 관리 화면 내 users에 있는 이메일 계정 데이터 불러오는 로직 초기화
  ref.invalidate(receiversProvider);
  // 쪽지 관리 화면 내 선택된 이메일 계정 관련 발주번호 데이터 불러오는 로직 초기화
  ref.invalidate(orderNumbersProvider);
  // 쪽지 관리 화면 초기화 시, 내용 선택 관려 드롭다운 메뉴 선택 상태 초기화
  ref.read(adminMessageContentProvider.notifier).state = null;
  // 쪽지 관리 화면 초기화 시, 선택한 메뉴 관려 텍스트 노출 입력칸 노출 상태 초기화
  ref.read(adminCustomMessageProvider.notifier).state = null;
  // 쪽지 관리 화면 초기화 시, 탭 선택 상태 초기화
  ref.read(adminMessageScreenTabProvider.notifier).state = MessageScreenTab.create;
  // 관리자용 쪽지 관리 화면 내 '쪽지 목록' 탭 화면에서 선택된 수신자 이메일 상태 초기화
  ref.read(selectedReceiverProvider.notifier).state = null;
  // 쪽지 관리 화면 초기화 시, 모든 계정의 쪽지 목록 상태 초기화
  ref.invalidate(fetchMinutesAllMessagesProvider); // 1분 이내 타임의 쪽지 목록 불러옴
  ref.invalidate(fetchDaysAllMessagesProvider); // 30일 이내 타임의 쪽지 목록 불러옴
  ref.invalidate(fetchYearsAllMessagesProvider); // 1년(365일) 이내 타임의 쪽지 목록 불러옴

  // 쪽지 관리 화면 초기화 끝

  // 발주내역 관리 화면 초기화 시작
  // 발주내역 관리 화면 자체의 스크롤 초기화
  ref.read(adminOrderlistScrollPositionProvider.notifier).state = 0.0;
  // 발주내역 관리 화면 초기화
  ref.read(selectedUserEmailProvider.notifier).state = '';
  // 발주내역 관리 화면 내 모든 사용자 이메일 계정 데이터 불러오는 로직 초기화
  ref.invalidate(allUserEmailsProvider);
  // 발주내역 관리 화면 내 선택된 이메일 계정 관련 발주 데이터 불러오는 로직 초기화
  ref.invalidate(userOrdersProvider);
  // 발주내역 관리 화면 내 발주데이터에서 발주상태 드롭다운 메뉴 버튼 내 메뉴 선택 초기화
  ref.read(orderStatusStateProvider.notifier).state = '발주신청 완료';
  // 발주내역 관리 화면 초기화 끝

  // ------ 관리자용 화면인 리뷰관리, 쪽지관리, 발주내역 관리, 찜 목록 괸리, 공지사항 관리 관련 초기화 부분 끝

  // ------ 2차 메인 화면 관련 부분 시작
  // 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(blouseMainScrollPositionProvider.notifier).state =
      0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(blouseCurrentTabProvider.notifier).state =
      0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(blouseMainLargeBannerPageProvider.notifier).state = 0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(blouseMainSmall1BannerPageProvider.notifier).state = 0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(blouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(blouseMainSortButtonProvider.notifier).state =
      ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 블라우스 메인 화면 관련 초기화 부분 끝

  // 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(cardiganMainScrollPositionProvider.notifier).state =
      0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(cardiganCurrentTabProvider.notifier).state =
      0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(cardiganMainLargeBannerPageProvider.notifier).state = 0; // 가디건 대배너 페이지뷰 초기화
  ref.read(cardiganMainSmall1BannerPageProvider.notifier).state = 0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(cardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(cardiganMainSortButtonProvider.notifier).state =
      ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 가디건 메인 화면 관련 초기화 부분 끝

  // 코트 메인 화면 관련 초기화 부분 시작
  ref.read(coatMainScrollPositionProvider.notifier).state =
      0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(coatCurrentTabProvider.notifier).state =
      0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(coatMainLargeBannerPageProvider.notifier).state = 0; // 코트 대배너 페이지뷰 초기화
  ref.read(coatMainSmall1BannerPageProvider.notifier).state = 0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(coatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(coatMainSortButtonProvider.notifier).state =
      ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 코트 메인 화면 관련 초기화 부분 끝

  // 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(jeanMainScrollPositionProvider.notifier).state =
      0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(jeanCurrentTabProvider.notifier).state =
      0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(jeanMainLargeBannerPageProvider.notifier).state = 0; // 청바지 대배너 페이지뷰 초기화
  ref.read(jeanMainSmall1BannerPageProvider.notifier).state = 0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(jeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(jeanMainSortButtonProvider.notifier).state =
      ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 청바지 메인 화면 관련 초기화 부분 끝

  // 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(mtmMainScrollPositionProvider.notifier).state =
      0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(mtmCurrentTabProvider.notifier).state =
      0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(mtmMainLargeBannerPageProvider.notifier).state = 0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(mtmMainSmall1BannerPageProvider.notifier).state = 0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(mtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(mtmMainSortButtonProvider.notifier).state =
      ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 맨투맨 메인 화면 관련 초기화 부분 끝

  // 니트 메인 화면 관련 초기화 부분 시작
  ref.read(neatMainScrollPositionProvider.notifier).state =
      0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(neatCurrentTabProvider.notifier).state =
      0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(neatMainLargeBannerPageProvider.notifier).state = 0; // 니트 대배너 페이지뷰 초기화
  ref.read(neatMainSmall1BannerPageProvider.notifier).state = 0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(neatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(neatMainSortButtonProvider.notifier).state =
      ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 니트 메인 화면 관련 초기화 부분 끝

  // 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(onepieceMainScrollPositionProvider.notifier).state =
      0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(onepieceCurrentTabProvider.notifier).state =
      0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(onepieceMainLargeBannerPageProvider.notifier).state = 0; // 원피스 대배너 페이지뷰 초기화
  ref.read(onepieceMainSmall1BannerPageProvider.notifier).state = 0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(onepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(onepieceMainSortButtonProvider.notifier).state =
      ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 원피스 메인 화면 관련 초기화 부분 끝

  // 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(paedingMainScrollPositionProvider.notifier).state =
      0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(paedingCurrentTabProvider.notifier).state =
      0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(paedingMainLargeBannerPageProvider.notifier).state = 0; // 패딩 대배너 페이지뷰 초기화
  ref.read(paedingMainSmall1BannerPageProvider.notifier).state = 0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(paedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(paedingMainSortButtonProvider.notifier).state =
      ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 패딩 메인 화면 관련 초기화 부분 끝

  // 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(pantsMainScrollPositionProvider.notifier).state =
      0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(pantsCurrentTabProvider.notifier).state =
      0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(pantsMainLargeBannerPageProvider.notifier).state = 0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(pantsMainSmall1BannerPageProvider.notifier).state = 0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(pantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(pantsMainSortButtonProvider.notifier).state =
      ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 팬츠 메인 화면 관련 초기화 부분 끝

  // 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(polaMainScrollPositionProvider.notifier).state =
      0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(polaCurrentTabProvider.notifier).state =
      0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(polaMainLargeBannerPageProvider.notifier).state = 0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(polaMainSmall1BannerPageProvider.notifier).state = 0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(polaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(polaMainSortButtonProvider.notifier).state =
      ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 폴라티 메인 화면 관련 초기화 부분 끝

  // 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(shirtMainScrollPositionProvider.notifier).state =
      0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(shirtCurrentTabProvider.notifier).state =
      0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(shirtMainLargeBannerPageProvider.notifier).state = 0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(shirtMainSmall1BannerPageProvider.notifier).state = 0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(shirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(shirtMainSortButtonProvider.notifier).state =
      ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 티셔츠 메인 화면 관련 초기화 부분 끝

  // 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(skirtMainScrollPositionProvider.notifier).state =
      0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(skirtCurrentTabProvider.notifier).state =
      0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(skirtMainLargeBannerPageProvider.notifier).state = 0; // 스커트 대배너 페이지뷰 초기화
  ref.read(skirtMainSmall1BannerPageProvider.notifier).state = 0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(skirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(skirtMainSortButtonProvider.notifier).state =
      ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 스커트 메인 화면 관련 초기화 부분 끝
  // ------ 2차 메인 화면 관련 부분 끝

  // ------ 섹션 더보기 화면 관련 부분 시작
  // 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(newSubMainScrollPositionProvider.notifier).state =
      0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(newSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(newSubMainSortButtonProvider.notifier).state =
      ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(newSubMainLargeBannerPageProvider.notifier).state = 0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(newSubMainSmall1BannerPageProvider.notifier).state = 0; // 신상 더보기 화면 소배너 페이지뷰 초기화
  // 신상 더보기 화면 관련 초기화 부분 끝

  // 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(bestSubMainScrollPositionProvider.notifier).state =
      0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(bestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(bestSubMainSortButtonProvider.notifier).state =
      ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(bestSubMainLargeBannerPageProvider.notifier).state = 0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(bestSubMainSmall1BannerPageProvider.notifier).state = 0; // 최고 더보기 화면 소배너 페이지뷰 초기화
  // 최고 더보기 화면 관련 초기화 부분 끝

  // 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(saleSubMainScrollPositionProvider.notifier).state =
      0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(saleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(saleSubMainSortButtonProvider.notifier).state =
      ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(saleSubMainLargeBannerPageProvider.notifier).state = 0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(saleSubMainSmall1BannerPageProvider.notifier).state = 0; // 할인 더보기 화면 소배너 페이지뷰 초기화
  // 할인 더보기 화면 관련 초기화 부분 끝

  // 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(springSubMainScrollPositionProvider.notifier).state =
      0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(springSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(springSubMainSortButtonProvider.notifier).state =
      ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(springSubMainLargeBannerPageProvider.notifier).state = 0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(springSubMainSmall1BannerPageProvider.notifier).state = 0; // 봄 더보기 화면 소배너 페이지뷰 초기화
  // 봄 더보기 화면 관련 초기화 부분 끝

  // 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(summerSubMainScrollPositionProvider.notifier).state =
      0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(summerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(summerSubMainSortButtonProvider.notifier).state =
      ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(summerSubMainLargeBannerPageProvider.notifier).state = 0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(summerSubMainSmall1BannerPageProvider.notifier).state = 0; // 여름 더보기 화면 소배너 페이지뷰 초기화
  // 여름 더보기 화면 관련 초기화 부분 끝

  // 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(autumnSubMainScrollPositionProvider.notifier).state =
      0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(autumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(autumnSubMainSortButtonProvider.notifier).state =
      ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(autumnSubMainLargeBannerPageProvider.notifier).state = 0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(autumnSubMainSmall1BannerPageProvider.notifier).state = 0; // 가을 더보기 화면 소배너 페이지뷰 초기화
  // 가을 더보기 화면 관련 초기화 부분 끝

  // 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(winterSubMainScrollPositionProvider.notifier).state =
      0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(winterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(winterSubMainSortButtonProvider.notifier).state =
      ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(winterSubMainLargeBannerPageProvider.notifier).state = 0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(winterSubMainSmall1BannerPageProvider.notifier).state = 0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
  // 겨울 더보기 화면 관련 초기화 부분 끝
  // ------ 섹션 더보기 화면 관련 부분 끝

  // // ------ 상품 상세 화면 관련 초기화 부분 시작
  // 화면을 돌아왔을 때 선택된 색상과 사이즈의 상태를 초기화함
  ref.read(colorSelectionIndexProvider.notifier).state = 0;
  ref.read(colorSelectionTextProvider.notifier).state = null;
  ref.read(colorSelectionUrlProvider.notifier).state = null;
  ref.read(sizeSelectionIndexProvider.notifier).state = null;
  // 화면을 돌아왔을 때 수량과 총 가격의 상태를 초기화함
  ref.read(detailQuantityIndexProvider.notifier).state = 1;
  // ref.read(blouseDetailImagePageProvider.notifier).state = 0; // 블라우스 상세 화면 내 이미지 부분 관련 초기화
  // ref.read(cardiganDetailImagePageProvider.notifier).state = 0; // 가디건 상세 화면 내 이미지 부분 관련 초기화
  // ref.read(coatDetailImagePageProvider.notifier).state = 0; // 코트 상세 화면 내 이미지 부분 관련 초기화
  // ref.read(jeanDetailImagePageProvider.notifier).state = 0; // 청바지 상세 화면 내 이미지 부분 관련 초기화
  // ref.read(mtmDetailImagePageProvider.notifier).state = 0; // 맨투맨 상세 화면 내 이미지 부분 관련 초기화
  // ref.read(neatDetailImagePageProvider.notifier).state = 0; // 니트 상세 화면 내 이미지 부분 관련 초기화
  // ref.read(onepieceDetailImagePageProvider.notifier).state = 0; // 원피스 상세 화면 내 이미지 부분 관련 초기화
  // ref.read(paedingDetailImagePageProvider.notifier).state = 0; // 패딩 상세 화면 내 이미지 부분 관련 초기화
  // ref.read(pantsDetailImagePageProvider.notifier).state = 0; // 팬츠 상세 화면 내 이미지 부분 관련 초기화
  // ref.read(polaDetailImagePageProvider.notifier).state = 0; // 폴라티 상세 화면 내 이미지 부분 관련 초기화
  // ref.read(shirtDetailImagePageProvider.notifier).state = 0; // 티셔츠 상세 화면 내 이미지 부분 관련 초기화
  // ref.read(skirtDetailImagePageProvider.notifier).state = 0; // 스커트 상세 화면 내 이미지 부분 관련 초기화
  // // ------ 상품 상세 화면 관련 초기화 부분 끝
}

// ------ buildHorizontalDocumentsList 위젯 내용 구현 시작
// 주로, 홈 화면 내 2차 카테고리별 섹션 내 데이터를 스크롤뷰로 UI 구현하는 부분 관련 로직
// buildHorizontalDocumentsList 함수에서 Document 클릭 시 동작 추가
// 가로로 스크롤 가능한 문서 리스트를 생성하는 함수. 문서 클릭 시 설정된 동작을 실행함.
Widget buildHorizontalDocumentsList(
    WidgetRef ref,
    List<ProductContent> products,
    BuildContext context,
    String category,
    ScrollController horizontalScrollViewScrollController) {
  // ProductInfoDetailScreenNavigation 클래스 인스턴스를 생성하여 제품 정보 상세 화면 네비게이션을 설정함.
  final productInfo = ProductInfoDetailScreenNavigation(ref);

  return NotificationListener<ScrollNotification>(
    // 스크롤 알림 리스너를 추가함
    onNotification: (scrollNotification) {
      // debugPrint('Scroll notification: ${scrollNotification.metrics.pixels}');
      return false; // 스크롤 알림 수신시 false 반환하여 기본 동작 유지
    },
    child: SingleChildScrollView(
      // SingleChildScrollView를 사용하여 스크롤 가능한 영역을 생성함
      controller: horizontalScrollViewScrollController, // 가로 스크롤 컨트롤러 설정
      scrollDirection: Axis.horizontal, // 스크롤 방향을 가로로 설정
      child: Row(
        // Row 위젯을 사용하여 가로로 나열된 문서 리스트를 생성함
        children: products
            .map((product) => productInfo.buildProdFirestoreDetailDocument(
                context, product, ref))
            .toList(),
        // 각 제품에 대해 buildProdFirestoreDetailDocument 함수를 호출하여 위젯을 생성하고 리스트에 추가함
      ),
    ),
  );
}
// ------ buildHorizontalDocumentsList 위젯 내용 구현 끝

// -------- ProductInfoDetailScreenNavigation 클래스 내용 구현 시작
// 홈 화면과 2차 메인화면(1차 카테고리별 메인화면)에 주로 사용될 예정
// 상품별 간단하게 데이터를 보여주는 UI 부분과 해당 상품 클릭 시, 상품 상세화면으로 이동하도록 하는 로직
class ProductInfoDetailScreenNavigation {
  final WidgetRef ref; // ref 변수는 상태 관리를 위해 사용.

  // 생성자에서 ref와 category를 초기화함.
  ProductInfoDetailScreenNavigation(this.ref);

  // 상세 화면으로 이동하고 화면을 뒤로 돌아왔을 때 선택된 색상과 사이즈의 상태를 초기화하는 함수.
  void navigateToDetailScreen(BuildContext context, ProductContent product) {
    Widget detailScreen; // 상세 화면 위젯
    String appBarTitle; // 앱바 타이틀

    // 상품의 카테고리에 따라 적절한 상세 화면 위젯과 타이틀을 선택.
    switch (product.category) {
      case "티셔츠":
        appBarTitle = '티셔츠 상세';
        detailScreen = ShirtDetailProductScreen(
          fullPath: product.docId,
          title: appBarTitle,
        );
        break;
      case "블라우스":
        appBarTitle = '블라우스 상세';
        detailScreen = BlouseDetailProductScreen(
          fullPath: product.docId,
          title: appBarTitle,
        );
        break;
      case "가디건":
        appBarTitle = '가디건 상세';
        detailScreen = CardiganDetailProductScreen(
          fullPath: product.docId,
          title: appBarTitle,
        );
        break;
      case "코트":
        appBarTitle = '코트 상세';
        detailScreen = CoatDetailProductScreen(
          fullPath: product.docId,
          title: appBarTitle,
        );
        break;
      case "청바지":
        appBarTitle = '청바지 상세';
        detailScreen = JeanDetailProductScreen(
          fullPath: product.docId,
          title: appBarTitle,
        );
        break;
      case "맨투맨":
        appBarTitle = '맨투맨 상세';
        detailScreen = MtmDetailProductScreen(
          fullPath: product.docId,
          title: appBarTitle,
        );
        break;
      case "니트":
        appBarTitle = '니트 상세';
        detailScreen = NeatDetailProductScreen(
          fullPath: product.docId,
          title: appBarTitle,
        );
        break;
      case "원피스":
        appBarTitle = '원피스 상세';
        detailScreen = OnepieceDetailProductScreen(
          fullPath: product.docId,
          title: appBarTitle,
        );
        break;
      case "패딩":
        appBarTitle = '패딩 상세';
        detailScreen = PaedingDetailProductScreen(
          fullPath: product.docId,
          title: appBarTitle,
        );
        break;
      case "팬츠":
        appBarTitle = '팬츠 상세';
        detailScreen = PantsDetailProductScreen(
          fullPath: product.docId,
          title: appBarTitle,
        );
        break;
      case "폴라티":
        appBarTitle = '폴라티 상세';
        detailScreen = PolaDetailProductScreen(
          fullPath: product.docId,
          title: appBarTitle,
        );
        break;
      case "스커트":
        appBarTitle = '스커트 상세';
        detailScreen = SkirtDetailProductScreen(
          fullPath: product.docId,
          title: appBarTitle,
        );
        break;
      default:
        appBarTitle = '티셔츠 상세';
        detailScreen = ShirtDetailProductScreen(
          fullPath: product.docId,
          title: appBarTitle,
        );
    }

    // 디버그 출력으로 타이틀 확인
    debugPrint(
        'Navigating to $appBarTitle screen for document: ${product.docId}');

    // 네비게이션을 사용하여 상세 화면으로 이동함
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => detailScreen),
    ).then((_) {
      ref.read(colorSelectionIndexProvider.notifier).state = 0;
      // 화면을 돌아왔을 때 선택된 색상 텍스트 인덱스의 상태를 초기화함
      ref.read(colorSelectionTextProvider.notifier).state = null;
      // 화면을 돌아왔을 때 선택된 색상 이미지 Url의 상태를 초기화함
      ref.read(colorSelectionUrlProvider.notifier).state = null;
      // 화면을 돌아왔을 때 선택된 사이즈의 상태를 초기화함
      ref.read(sizeSelectionIndexProvider.notifier).state = null;
      // 화면을 돌아왔을 때 수량과 총 가격의 상태를 초기화함
      ref.read(detailQuantityIndexProvider.notifier).state = 1;
      // 화면을 돌아왔을 때 '상품정보', '리뷰', '문의'탭 상태를 초기화함
      ref.read(prodDetailScreenTabSectionProvider.notifier).state = ProdDetailScreenTabSection.productInfo;
    });
  }

  // Firestore에서 상세한 문서 정보를 빌드하여 UI에 구현하는 위젯.
  Widget buildProdFirestoreDetailDocument(
      BuildContext context, ProductContent product, WidgetRef ref) {
    return GestureDetector(
      // 문서 클릭 시 navigateToDetailScreen 함수를 호출함.
      onTap: () {
        navigateToDetailScreen(
            context, product); // product.docId를 사용하여 해당 문서로 이동함.
      },
      child: Container(
        // 높이를 명시적으로 지정하여 충분한 공간 확보
        width: 175,
        padding: EdgeInsets.all(4.0),
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          // 컨테이너의 배경색을 흰색으로 설정하고 둥근 모서리 및 그림자 효과를 추가함
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // 그림자의 위치를 설정함
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제품 썸네일을 표시함.
                // 썸네일이 null이 아니고 빈 문자열이 아닐 때만 실행
                if (product.thumbnail != null && product.thumbnail!.isNotEmpty)
                // 썸네일을 가운데 정렬
                  Center(
                    // 썸네일 이미지와 좋아요 아이콘을 겹쳐서 표시
                    child: Stack(
                      children: [
                        // 네트워크에서 이미지를 가져와서 표시
                        // 아이콘 버튼을 이미지 위에 겹쳐서 위치시킴
                        Image.network(product.thumbnail!,
                            width: 100, fit: BoxFit.cover),
                        // 위젯을 위치시키는 클래스, 상위 위젯의 특정 위치에 자식 위젯을 배치함
                        Positioned(
                          top: -10,  // 자식 위젯을 상위 위젯의 위쪽 경계에서 -10 만큼 떨어뜨림 (위로 10 이동)
                          right: -10, // 자식 위젯을 상위 위젯의 오른쪽 경계에서 -10 만큼 떨어뜨림 (왼쪽으로 10 이동)
                          // 찜 목록 아이콘 동작 로직 관련 클래스인 WishlistIconButton 재사용하여 구현
                          child: WishlistIconButton(
                              product: product, // 'product' 파라미터를 전달
                            ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 5),
                // 제품 간단한 소개를 표시함.
                if (product.briefIntroduction != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      product.briefIntroduction!,
                      style: TextStyle(fontSize: 14),
                      maxLines: 2, // 최대 2줄까지 표시함.
                      overflow: TextOverflow.visible, // 넘치는 텍스트는 '...'으로 표시함.
                    ),
                  ),
                // 원래 가격을 표시함. 소수점은 표시하지 않음.
                if (product.originalPrice != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      '${product.originalPrice!.toStringAsFixed(0)}원',
                      style: TextStyle(
                          fontSize: 12, decoration: TextDecoration.lineThrough),
                    ),
                  ),
                // 할인된 가격을 표시함. 소수점은 표시하지 않음.
                if (product.discountPrice != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Row(
                      children: [
                        Text(
                          '${product.discountPrice!.toStringAsFixed(0)}원',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        // 할인율을 빨간색으로 표시함.
                        if (product.discountPercent != null)
                          Text(
                            '${product.discountPercent!.toStringAsFixed(0)}%',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                SizedBox(height: 10),
                // 제품 색상 옵션을 표시함.
                if (product.colors != null)
                  Row(
                    children: product.colors!
                        .map((color) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child:
                                  Image.network(color, width: 13, height: 13),
                            ))
                        .toList(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} // -------- ProductInfoDetailScreenNavigation 클래스 내용 구현 끝

// ------ 상품 상세 화면 내 UI 관련 위젯 공통 코드 내용 시작
// ------ buildProdDetailScreenContents 위젯 시작: 상품 상세 정보를 구성하는 위젯을 정의.
Widget buildProdDetailScreenContents(BuildContext context, WidgetRef ref,
    ProductContent product, PageController pageController) {
  // print('buildProductDetails 호출');
  // print('상품 소개: ${product.briefIntroduction}');
  return SingleChildScrollView(
    // 스크롤이 가능하도록 SingleChildScrollView 위젯을 사용.
    child: Column(
      // 세로 방향으로 위젯들을 나열하는 Column 위젯을 사용.
      crossAxisAlignment: CrossAxisAlignment.start,
      // 자식 위젯들을 왼쪽 정렬로 배치.
      children: [
        buildProductImageSliderSection(product, ref, pageController, product.docId), // 이미지 슬라이더 섹션
        SizedBox(height: 10),
        // 상단 여백을 10으로 설정.
        CommonCardView(
          content: buildProductBriefIntroAndPriceInfoSection(context, ref, product), // 제품 소개 및 가격 정보 부분 섹션
          backgroundColor: BEIGE_COLOR, // 앱 배경색과 구분되는 흰색 계열
          elevation: 4.0, // 그림자 효과
          margin: const EdgeInsets.symmetric(horizontal: 0.0), // 좌우 여백을 0으로 설정.
          padding: const EdgeInsets.all(1.0), // 카드 내부 여백을 1.0으로 설정.
        ),
        // 제품 소개 부분과 가격 부분을 표시하는 위젯을 호출.
        SizedBox(height: 10),
        // 제품 소개와 가격 부분 다음 섹션 사이의 여백을 10으로 설정.
        CommonCardView(
          content: ProductColorAndSizeSelection(product: product), // 색상과 사이즈 선택 관련 섹션
          backgroundColor: BEIGE_COLOR, // 앱 배경색과 구분되는 연한 회색 계열
          elevation: 4.0, // 그림자 효과
          margin: const EdgeInsets.symmetric(horizontal: 0.0), // 좌우 여백을 0으로 설정.
          padding: const EdgeInsets.all(1.0), // 카드 내부 여백을 1.0으로 설정.
        ),
        SizedBox(height: 10),
        CommonCardView(
          content: buildProductAllCountAndPriceSelection(context, ref, product), // 총 선택 내용이 나오는 섹션
          backgroundColor: BEIGE_COLOR,
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(horizontal: 0.0),
          padding: const EdgeInsets.all(1.0),
        ),
      ],
    ),
  );
}
// ------ buildProdDetailScreenContents 위젯의 구현 끝

// ------ buildProductImageSlider 위젯 시작: 제품 이미지 부분을 구현.
Widget buildProductImageSliderSection(ProductContent product, WidgetRef ref,
    PageController pageController, String productId) {
  // productId를 사용하여 pageProvider를 가져옴.
  final pageProvider = getImagePageProvider(productId);

  return Column(
    children: [
      // CarouselSlider 위젯을 사용하여 이미지를 슬라이드 형태로 보여줌.
      CarouselSlider(
        options: CarouselOptions(
          height: 400.0,
          viewportFraction: 1.0,
          // 페이지가 변경될 때 호출되는 함수.
          onPageChanged: (index, reason) {
            // pageProvider의 상태를 변경.
            ref.read(pageProvider.notifier).state = index;
          },
        ),
        // product.detailPageImages를 반복하여 이미지 위젯을 생성.
        items: product.detailPageImages?.map((image) { // product.detailPageImages 리스트를 map 함수로 반복
          return Builder(
            builder: (BuildContext context) { // 각 항목에 대한 빌더 함수 정의
              return GestureDetector( // 터치 제스처를 감지하는 위젯
                onTap: () { // 터치 시 동작할 함수 정의
                  Navigator.push( // 새로운 화면으로 이동
                    context,
                    MaterialPageRoute( // 페이지 라우트 정의
                      builder: (_) => ProductDetailOriginalImageScreen( // ProductDetailOriginalImageScreen 화면으로 이동
                        images: product.detailPageImages!, // 이미지 리스트 전달
                        initialPage: ref.read(pageProvider), // 초기 페이지 인덱스 전달
                      ),
                    ),
                  );
                },
                child: Image.network( // 네트워크 이미지를 보여주는 위젯
                  image, // 이미지 URL 설정
                  fit: BoxFit.cover, // 이미지가 컨테이너를 가득 채우도록 설정
                  width: MediaQuery.of(context).size.width, // 화면의 너비에 맞게 설정
                ),
              );
            },
          );
        }).toList(), // 리스트로 변환
      ),
      // 페이지 인디케이터를 Row 위젯으로 생성.
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // product.detailPageImages의 각 항목을 반복하여 인디케이터를 생성함.
        children: product.detailPageImages?.asMap().entries.map((entry) {
          return GestureDetector(
            // 인디케이터를 클릭하면 해당 페이지로 이동함.
            onTap: () => pageController.jumpToPage(entry.key),
            child: Container(
              width: 12.0,
              height: 12.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // 현재 페이지를 기준으로 인디케이터 색상을 변경함.
                color: ref.watch(pageProvider) == entry.key
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            ),
          );
        }).toList() ??
            [],
      ),
    ],
  );
}
// ------ buildProductImageSlider 위젯 끝: 제품 이미지 부분을 구현.

// ------ buildProductBriefIntroAndPriceInfoSection 위젯 시작: 제품 소개 및 가격 정보 부분을 구현.
Widget buildProductBriefIntroAndPriceInfoSection(
    BuildContext context, WidgetRef ref, ProductContent product) {
  final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'); // 정규식을 사용하여 천 단위로 쉼표를 추가.
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0), // 수평 패딩을 20.0으로 설정
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
      children: [
        // 제품 번호를 표시함.
        if (product.productNumber != null) // productNumber가 null이 아닌 경우에만 표시
          Padding(
            padding: const EdgeInsets.only(top: 8.0), // 상단 패딩을 8.0으로 설정
            child: Text(
              '상품번호: ${product.productNumber}', // productNumber 내용을 표시
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // 글자 크기를 14로 설정
            ),
          ),
        // 제품 간단한 소개를 표시함.
        if (product.briefIntroduction != null) // briefIntroduction이 null이 아닌 경우에만 표시
          Padding(
            padding: const EdgeInsets.only(top: 8.0), // 상단 패딩을 8.0으로 설정
            child: Text(
              product.briefIntroduction!, // briefIntroduction 내용을 표시
              style: TextStyle(fontSize: 23), // 글자 크기를 23으로 설정
              maxLines: 2, // 최대 2줄로 표시
              overflow: TextOverflow.visible, // 넘치는 텍스트를 표시
            ),
          ),
        SizedBox(height: 15), // 높이 15의 간격을 추가
        // 원래 가격을 표시함. 소수점은 표시하지 않음.
        if (product.originalPrice != null) // originalPrice가 null이 아닌 경우에만 표시
          Padding(
            padding: const EdgeInsets.only(top: 2.0), // 상단 패딩을 2.0으로 설정
            child: Text(
              '${product.originalPrice!.toStringAsFixed(0).replaceAllMapped(reg, (match) => '${match[1]},')}원', // 원래 가격을 표시, 소수점 없음
              style: TextStyle(
                fontSize: 18, // 글자 크기를 18로 설정
                decoration: TextDecoration.lineThrough, // 취소선을 추가
                color: Colors.grey[500], // 색상을 연한 회색으로 설정
                decorationColor: Colors.grey[500], // 취소선 색상을 연한 회색으로 설정
              ),
            ),
          ),
        // 할인된 가격을 표시함. 소수점은 표시하지 않음.
        if (product.discountPrice != null) // discountPrice가 null이 아닌 경우에만 표시
          Padding(
            padding: const EdgeInsets.only(top: 2.0), // 상단 패딩을 2.0으로 설정
            child: Row(
              children: [
                Text(
                  '${product.discountPrice!.toStringAsFixed(0).replaceAllMapped(reg, (match) => '${match[1]},')}원', // 할인된 가격을 표시, 소수점 없음
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // 글자 크기를 25로 설정하고 볼드체 적용
                ),
                SizedBox(width: 8), // 너비 8의 간격을 추가
                // 할인율을 빨간색으로 표시함.
                if (product.discountPercent != null) // discountPercent가 null이 아닌 경우에만 표시
                  Text(
                    '${product.discountPercent!.toStringAsFixed(0)}%', // 할인율을 표시, 소수점 없음
                    style: TextStyle(
                        fontSize: 25, color: Colors.red, fontWeight: FontWeight.bold), // 글자 크기를 25로 설정하고, 색상을 빨간색으로 설정, 볼드체 적용
                  ),
                Spacer(), // 할인율과의 간격 공간 생성
                // 찜 목록 아이콘 동작 로직 관련 클래스인 WishlistIconButton 재사용하여 구현
                WishlistIconButton(
                  product: product, // 'product' 파라미터를 전달
                ),
              ],
            ),
          ),
        SizedBox(height: 10), // 높이 10의 간격을 추가
      ],
    ),
  );
}
// ------ buildProductBriefIntroAndPriceInfoSection 위젯의 구현 끝: 제품 소개 및 가격 정보 부분을 구현.

// ------ buildColorAndSizeSelection 클래스 시작: 색상 및 사이즈 선택 부분을 구현.
class ProductColorAndSizeSelection extends ConsumerStatefulWidget {
  final ProductContent product;

  const ProductColorAndSizeSelection({Key? key, required this.product}) : super(key: key);

  @override
  _ProductColorAndSizeSelectionState createState() => _ProductColorAndSizeSelectionState();
}

class _ProductColorAndSizeSelectionState extends ConsumerState<ProductColorAndSizeSelection> {
  @override
  void initState() {
    super.initState();

    // 초기값 설정을 위해 첫 번째 옵션을 가져옴
    final initialColorImage = widget.product.colorOptions?.isNotEmpty ?? false
        ? widget.product.colorOptions!.first['url']
        : null;
    final initialColorText = widget.product.colorOptions?.isNotEmpty ?? false
        ? widget.product.colorOptions!.first['text']
        : null;
    final initialSize = widget.product.sizes?.isNotEmpty ?? false
        ? widget.product.sizes!.first
        : null;

    // 초기값으로 상태를 업데이트
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(colorSelectionUrlProvider.notifier).state ??= initialColorImage; // 선택된 색상 이미지
      ref.read(colorSelectionTextProvider.notifier).state ??= initialColorText; // 선택된 색상 텍스트
      ref.read(sizeSelectionIndexProvider.notifier).state ??= initialSize; // 선택된 사이즈
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), // 좌우 여백을 20으로 설정.
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // 자식 위젯들을 왼쪽 정렬로 배치.
            children: [
              Text('색상', style: TextStyle(fontSize: 16)), // '색상' 라벨을 표시.
              SizedBox(width: 63), // '색상' 라벨과 드롭다운 버튼 사이의 간격을 63으로 설정.
              Expanded(
                // 드롭다운 버튼을 화면 너비에 맞게 확장.
                child: DropdownButton<String>(
                  isExpanded: true,
                  // 드롭다운 버튼의 너비를 최대로 확장.
                  value: ref.watch(colorSelectionUrlProvider),
                  // 선택된 색상 값을 가져옴.
                  onChanged: (newValue) {
                    final selectedIndex = product.colorOptions?.indexWhere((option) => option['url'] == newValue) ?? -1;
                    final selectedText = product.colorOptions?.firstWhere((option) => option['url'] == newValue)?['text'];
                    // 새로운 값과 일치하는 색상 옵션의 인덱스를 찾음.
                    ref.read(colorSelectionIndexProvider.notifier).state = selectedIndex;
                    ref.read(colorSelectionTextProvider.notifier).state = selectedText; // 색상 텍스트 업데이트
                    // 색상 인덱스를 업데이트.
                    ref.read(colorSelectionUrlProvider.notifier).state = newValue;
                    // 선택된 색상 URL을 업데이트.
                  },
                  items: product.colorOptions
                      ?.map((option) => DropdownMenuItem<String>(
                    value: option['url'], // 각 옵션의 URL을 값으로 사용.
                    child: Row(
                      children: [
                        Image.network(option['url'],
                            width: 20, height: 20), // 색상을 나타내는 이미지를 표시.
                        SizedBox(width: 8), // 이미지와 텍스트 사이의 간격을 8로 설정.
                        Text(option['text']), // 색상의 텍스트 설명을 표시.
                      ],
                    ),
                  ))
                      .toList(), // 드롭다운 메뉴 아이템 목록을 생성.
                ),
              ),
            ],
          ),
          SizedBox(height: 10), // 색상 선택과 사이즈 선택 사이의 수직 간격을 10으로 설정.
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // 자식 위젯들을 왼쪽 정렬로 배치.
            children: [
              Text('사이즈', style: TextStyle(fontSize: 16)), // '사이즈' 라벨을 표시.
              SizedBox(width: 52), // '사이즈' 라벨과 드롭다운 버튼 사이의 간격을 52로 설정.
              Expanded(
                // 드롭다운 버튼을 화면 너비에 맞게 확장.
                child: DropdownButton<String>(
                  isExpanded: true,
                  // 드롭다운 버튼의 너비를 최대로 확장.
                  value: ref.watch(sizeSelectionIndexProvider),
                  // 선택된 사이즈 값을 가져옴.
                  onChanged: (newValue) {
                    ref.read(sizeSelectionIndexProvider.notifier).state = newValue!;
                    // 새로운 사이즈가 선택되면 상태를 업데이트.
                  },
                  items: product.sizes
                      ?.map((size) => DropdownMenuItem<String>(
                    value: size, // 각 사이즈를 값으로 사용.
                    child: Text(size), // 사이즈 텍스트를 표시.
                  ))
                      .toList(), // 드롭다운 메뉴 아이템 목록을 생성.
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// ------ buildColorAndSizeSelection 클래스 끝: 색상 및 사이즈 선택 부분을 구현.

// ------ buildProductAllCountAndPriceSelection 위젯 시작: 선택한 색상, 선택한 사이즈, 수량 및 총 가격 부분을 구현.
// 선택한 색상, 사이즈, 수량, 총 가격을 표시하는 위젯을 생성하는 함수.
Widget buildProductAllCountAndPriceSelection(BuildContext context, WidgetRef ref, ProductContent product) {
  // 선택한 색상 URL을 가져옴.
  final selectedColorUrl = ref.watch(colorSelectionUrlProvider);
  // 선택한 색상 텍스트를 가져옴.
  final selectedColorText = ref.watch(colorSelectionTextProvider);
  // 선택한 사이즈를 가져옴.
  final selectedSize = ref.watch(sizeSelectionIndexProvider);
  // 선택한 수량을 가져옴.
  final quantity = ref.watch(detailQuantityIndexProvider);

  // 할인된 가격을 가져오고, 없으면 0을 설정.
  double discountPrice = product.discountPrice ?? 0;
  // 총 가격을 계산.
  double totalPrice = discountPrice * quantity;

  // 선택한 색상 정보를 가져옴.
  final selectedColorOption = product.colorOptions?.firstWhere(
        (option) => option['url'] == selectedColorUrl,
    orElse: () => {'url': '', 'text': ''}, // 기본 값 설정.
  );

  // 정규식을 사용하여 천 단위로 쉼표를 추가.
  final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 색상과 사이즈가 선택되었을 때만 보여줌.
      if (selectedColorUrl != null && selectedSize != null)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          // 좌우 여백 20, 수직 여백 8로 설정.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 선택한 색상을 텍스트로 표시함.
                  Text('선택한 색상:', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8), // 텍스트와 이미지 사이의 간격을 8로 설정.
                  // 선택한 색상이 존재하면 이미지를 표시함.
                  if (selectedColorUrl != null)
                    Image.network(
                      selectedColorUrl,
                      width: 20,
                      height: 20,
                    ),
                  SizedBox(width: 8), // 이미지와 텍스트 사이의 간격을 8로 설정.
                  // 선택한 색상 이름을 텍스트로 표시함.
                  Text(selectedColorText ?? '', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 8), // 색상과 사이즈 사이의 수직 간격을 8로 설정.
              // 선택한 사이즈를 텍스트로 표시함.
              Text('선택한 사이즈: $selectedSize', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        // 좌우 여백 20, 수직 여백 8로 설정.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // 자식 위젯들을 좌우로 배치.
          children: [
            // '수량' 텍스트를 표시함.
            Text('수량', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                // 수량 감소 버튼. 수량이 1보다 클 때만 작동함.
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: quantity > 1 ? () {
                    ref.read(detailQuantityIndexProvider.notifier).state--;
                  } : null,
                ),
                // 현재 수량을 표시하는 컨테이너.
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: Text('$quantity', style: TextStyle(fontSize: 16)),
                ),
                // 수량 증가 버튼.
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    ref.read(detailQuantityIndexProvider.notifier).state++;
                  },
                ),
                // 수량을 직접 입력할 수 있는 버튼.
                TextButton(
                  onPressed: () {
                    // 수량 입력을 위한 다이얼로그를 표시.
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final TextEditingController controller = TextEditingController();
                        // 텍스트 입력 컨트롤러를 생성.
                        String input = ''; // 입력 값을 저장할 변수.
                        return AlertDialog(
                          // 다이얼로그 제목.
                          title: Text('수량 입력', style: TextStyle(color: Colors.black)), // 색상 수정
                          content: TextField(
                            controller: controller, // 컨트롤러 연결.
                            keyboardType: TextInputType.number,
                            // 숫자만 입력 가능하게 설정.
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            autofocus: true, // 자동으로 포커스.
                            onChanged: (value) {
                              input = value;
                            },
                            decoration: InputDecoration(
                              // 포커스된 상태의 밑줄 색상을 검정으로 변경.
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black), // 밑줄 색상 변경
                              ),
                            ),
                          ),
                          actions: <TextButton>[
                            // 확인 버튼을 누르면 수량을 설정하고 다이얼로그를 닫음.
                            TextButton(
                              child: Text('확인', style: TextStyle(color: Colors.black)), // 색상 수정
                              onPressed: () {
                                if (input.isNotEmpty) {
                                  ref.read(detailQuantityIndexProvider.notifier).state = int.parse(input);
                                  // 입력된 값을 정수로 변환하여 상태를 업데이트.
                                }
                                Navigator.of(context).pop();
                                // 다이얼로그 닫기.
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('직접 입력', style: TextStyle(fontSize: 16, color: Colors.black)), // 색상 수정
                ),
              ],
            ),
          ],
        ),
      ),
      // 총 가격을 표시.
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Text('총 가격: ${totalPrice.toStringAsFixed(0).replaceAllMapped(reg, (match) => '${match[1]},')}원', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    ],
  );
}
// ------ buildProductAllCountAndPriceSelection 위젯 끝: 선택한 색상, 선택한 사이즈, 수량 및 총 가격 부분을 구현.
// ------ 상품 상세 화면 내 UI 관련 위젯 공통 코드 내용 끝

// ------ 상품 상세 화면에서 '상품 정보', '리뷰', '문의' 탭으로 각 탭이 선택될 때마다 각 내용이 나오도록 하는 ProductDetailScreenTabs 클래스 구현 부분 시작
class ProductDetailScreenTabs extends ConsumerWidget {
  final Widget productInfoContent; // '상품 정보' 탭의 내용을 담는 위젯
  final List<ProductReviewContents> reviewsContent; // '리뷰' 탭의 내용을 담는 리스트
  final Widget inquiryContent; // '문의' 탭의 내용을 담는 위젯

  // 생성자, 각 탭의 내용을 받음.
  ProductDetailScreenTabs({
    required this.productInfoContent,
    required this.reviewsContent,
    required this.inquiryContent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 선택된 탭 섹션을 가져옴.
    final currentTabSection = ref.watch(prodDetailScreenTabSectionProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabButtons(ref, currentTabSection), // 탭 버튼들을 빌드
        SizedBox(height: 20), // 탭과 컨텐츠 사이에 간격을 추가
        _buildSectionContent(currentTabSection), // 현재 선택된 탭의 내용을 빌드
      ],
    );
  }

  // 탭 버튼들을 빌드하는 위젯인 _buildTabButtons
  Widget _buildTabButtons(WidgetRef ref, ProdDetailScreenTabSection currentTabSection) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // '상품정보' 탭 버튼을 빌드
        _buildTabButton(ref, ProdDetailScreenTabSection.productInfo, currentTabSection, '상품정보'),
        // '리뷰' 탭 버튼을 빌드
        _buildTabButton(ref, ProdDetailScreenTabSection.reviews, currentTabSection, '리뷰'),
        // '문의' 탭 버튼을 빌드
        _buildTabButton(ref, ProdDetailScreenTabSection.inquiry, currentTabSection, '문의'),
      ],
    );
  }

  // 개별 탭 버튼을 빌드하는 위젯인 _buildTabButton
  Widget _buildTabButton(WidgetRef ref, ProdDetailScreenTabSection section, ProdDetailScreenTabSection currentTabSection, String text) {
    final isSelected = section == currentTabSection; // 현재 선택된 탭인지 확인
    return GestureDetector(
      onTap: () {
        // 탭 버튼 클릭 시 선택된 탭 섹션을 변경
        ref.read(prodDetailScreenTabSectionProvider.notifier).state = section;
      },
      child: Column(
        children: [
          // 탭 버튼 텍스트
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey, // 선택된 탭이면 검정색, 아니면 회색
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, // 선택된 탭이면 굵게, 아니면 일반
            ),
          ),
          if (isSelected) // 선택된 탭이면 밑줄 표시
            Container(
              width: 60,
              height: 2,
              color: Colors.black, // 밑줄 색상 검정
            ),
        ],
      ),
    );
  }

  // 선택된 탭 섹션의 내용을 빌드하는 위젯인 _buildSectionContent
  Widget _buildSectionContent(ProdDetailScreenTabSection section) {
    switch (section) {
      case ProdDetailScreenTabSection.productInfo: // '상품정보' 섹션이면
        return productInfoContent; // '상품정보' 내용을 반환
      case ProdDetailScreenTabSection.reviews: // '리뷰' 섹션이면
        return Column(children: reviewsContent); // '리뷰' 내용을 반환
      case ProdDetailScreenTabSection.inquiry: // '문의' 섹션이면
        return ProductInquiryContents(); // '문의' 내용을 반환
      default:
        return Container(); // 기본적으로 빈 컨테이너 반환
    }
  }
}
// ------ 상품 상세 화면에서 '상품 정보', '리뷰', '문의' 탭으로 각 탭이 선택될 때마다 각 내용이 나오도록 하는 ProductDetailScreenTabs 클래스 구현 부분 끝

// -------- 상품 상세 화면 내 상품정보에서 UI로 구현되는 내용 관련 ProductInfoContents 클래스 부분 시작
class ProductInfoContents extends StatefulWidget {
  // ProductContent 타입의 product를 인자로 받는 ProductInfoContents 위젯 클래스 정의
  final ProductContent product;

  // 생성자: product를 필수 인자로 받고, key는 선택적으로 받음
  const ProductInfoContents({Key? key, required this.product}) : super(key: key);

  @override
  _ProductInfoContentsState createState() => _ProductInfoContentsState();
}

class _ProductInfoContentsState extends State<ProductInfoContents> {
  // 추가 이미지를 표시할지 여부를 저장하는 변수, 초기값은 false
  bool showMoreImages = false;

  // 이미지 URL을 받아서 이미지를 좌우로 꽉 차도록 원본비율을 유지하며 표시하는 위젯을 생성하는 함수인 buildProdInfoImage
  Widget buildProdInfoImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      // 이미지 URL이 null이거나 비어있으면 빈 컨테이너 반환
      return Container();
    }
    return Image.network(
      imageUrl,
      fit: BoxFit.fitWidth, // 원본 비율 유지하며 좌우로 꽉 차도록 설정
      width: MediaQuery.of(context).size.width, // 화면 너비에 맞춤
    );
  }

  // 밑줄과 텍스트를 포함하는 위젯 생성하는 함수인 buildSectionTitle
  Widget buildSectionTitle(String title) {
    return Column(
      children: [
        SizedBox(height: 20), // 위쪽 여백 설정
        Row(
          children: [
            Expanded(child: Divider(thickness: 2, color: Colors.grey)), // 좌측 선
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0), // 좌우 여백 설정
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold, // 글자 굵게 설정
                  fontSize: 16, // 글자 크기 설정
                  color: Colors.grey, // 글자 색상 설정
                ),
              ),
            ),
            Expanded(child: Divider(thickness: 2, color: Colors.grey)), // 우측 선
          ],
        ),
        SizedBox(height: 10), // 아래쪽 여백 설정
      ],
    );
  }

  // 내용 확장 관련 버튼을 빌드하는 위젯인 buildExpandButton
  Widget buildExpandButton(String text, IconData icon) {
    return Container(
      width: double.infinity, // 버튼을 화면의 좌우로 꽉 차게 설정
      margin: EdgeInsets.symmetric(vertical: 10), // 위아래 여백 설정
      child: ElevatedButton.icon(
        onPressed: () {
          // 버튼 클릭 시 showMoreImages 값 토글
          setState(() {
            showMoreImages = !showMoreImages;
          });
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: BUTTON_COLOR, // 텍스트 색상
          backgroundColor: BACKGROUND_COLOR, // 배경 색상
          side: BorderSide(color: BUTTON_COLOR), // 테두리 색상
          padding: EdgeInsets.symmetric(vertical: 15), // 버튼 높이 조절
        ),
        icon: Icon(icon, color: BUTTON_COLOR), // 아이콘 색상 설정
        label: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold), // 텍스트를 굵게 설정
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 이미지가 세로로 나열되도록 설정
      children: [
        SizedBox(height: 20), // 위쪽 여백 설정
        buildSectionTitle('INTRO INFO'), // 섹션 제목 설정
        if (widget.product.detailIntroImages != null)
        // product의 detailIntroImages가 null이 아니면
          ...widget.product.detailIntroImages!.take(2).map(buildProdInfoImage).toList(), // 처음 두 개의 이미지를 표시
        if (!showMoreImages && widget.product.detailIntroImages != null && widget.product.detailIntroImages!.length > 2)
        // 추가 이미지를 표시하지 않는 상태에서 이미지가 2개 이상일 경우
          buildExpandButton('상품 정보 펼쳐보기', Icons.arrow_downward), // 확장 버튼 표시
        if (showMoreImages) ...[
          // 추가 이미지를 표시하는 상태일 경우
          if (widget.product.detailIntroImages != null)
          // product의 detailIntroImages가 null이 아니면
            ...widget.product.detailIntroImages!.skip(2).map(buildProdInfoImage).toList(), // 나머지 이미지를 표시
          SizedBox(height: 20), // 여백 설정
          buildSectionTitle('COLOR INFO'), // 섹션 제목 설정
          ...?widget.product.detailColorImages?.map(buildProdInfoImage).toList(), // 색상 정보 이미지 표시
          SizedBox(height: 20), // 여백 설정
          buildSectionTitle('SIZE INFO'), // 섹션 제목 설정
          buildProdInfoImage(widget.product.detailSizeImage), // 사이즈 정보 이미지 표시
          SizedBox(height: 20), // 여백 설정
          buildSectionTitle('DETAILS INFO'), // 섹션 제목 설정
          buildProdInfoImage(widget.product.detailDetailsImage), // 상세 정보 이미지 표시
          SizedBox(height: 20), // 여백 설정
          buildSectionTitle('FABRIC INFO'), // 섹션 제목 설정
          buildProdInfoImage(widget.product.detailFabricImage), // 원단 정보 이미지 표시
          SizedBox(height: 20), // 여백 설정
          buildSectionTitle('WASHING INFO'), // 섹션 제목 설정
          buildProdInfoImage(widget.product.detailWashingImage), // 세탁 정보 이미지 표시
          buildExpandButton('접기', Icons.arrow_upward), // 접기 버튼 표시
        ],
      ],
    );
  }
}
// -------- 상품 상세 화면 내 상품정보에서 UI로 구현되는 내용 관련 ProductInfoContents 클래스 부분 끝

// ------ 상품 상세 화면 내 리뷰에서 UI로 구현되는 내용 관련 ProductReviewContents 클래스 시작
// ProductReviewContents 클래스는 StatelessWidget을 상속받아 정의됨
// 해당 리뷰 부분은 리뷰 작성 화면에서 작성한 내용을 파이어베이스에 저장 후 저장된 내용을 불러오도록 로직을 재설계해야함!!
class ProductReviewContents extends StatelessWidget {
  // 클래스의 필드들을 final로 선언
  final String thumbnailUrl;
  final String productName;
  final String orderNumber;
  final String orderDate;
  final String reviewerName;
  final String reviewDate;
  final String reviewImageUrl;
  final String reviewContent;

  // 생성자를 통해 필드들을 초기화
  const ProductReviewContents({
    required this.thumbnailUrl, // 상품 썸네일 URL
    required this.productName, // 상품명
    required this.orderNumber, // 발주 번호
    required this.orderDate, // 발주 일자
    required this.reviewerName, // 작성자 이름
    required this.reviewDate, // 리뷰 등록 일자
    required this.reviewImageUrl, // 리뷰 이미지 URL
    required this.reviewContent, // 리뷰 내용
  });

  // build 메서드를 오버라이드하여 UI를 구성
  @override
  Widget build(BuildContext context) {
    // CommonCardView 위젯을 반환, content에 Column 위젯을 사용하여 여러 위젯을 세로로 배치
    return CommonCardView(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 좌측 정렬
        children: [
          SizedBox(height: 10), // 위쪽 여백 설정
          // 상품 썸네일
          Image.network(thumbnailUrl, height: 100, width: 100, fit: BoxFit.cover),
          const SizedBox(height: 8), // 여백
          // 상품 정보
          Text('상품명: $productName', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4), // 여백
          Text('발주 번호: $orderNumber'),
          const SizedBox(height: 4), // 여백
          Text('발주 일자: $orderDate'),
          const SizedBox(height: 4), // 여백
          Text('작성자: $reviewerName'),
          const SizedBox(height: 4), // 여백
          Text('리뷰 등록 일자: $reviewDate'),
          const SizedBox(height: 8), // 여백
          // 리뷰 이미지가 있을 경우만 이미지 위젯을 표시
          if (reviewImageUrl.isNotEmpty)
            Image.network(reviewImageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
          const SizedBox(height: 8), // 여백
          // 리뷰 내용
          Text(reviewContent),
        ],
      ),
      backgroundColor: BEIGE_COLOR, // 카드의 배경색 설정
    );
  }
}
// ------ 상품 상세 화면 내 리뷰에서 UI로 구현되는 내용 관련 ProductReviewContents 클래스 끝

// ------ 연결된 링크로 이동하는 '상품 문의하기' 버튼을 UI로 구현하는 ProductInquiryContents 클래스 내용 구현 시작
// ProductInquiryContents 클래스는 StatelessWidget을 상속받아 정의됨
class ProductInquiryContents extends StatelessWidget {
  // build 메서드를 오버라이드하여 UI를 구성
  @override
  Widget build(BuildContext context) {
    // CommonCardView 위젯을 반환, content에 Column 위젯을 사용하여 여러 위젯을 세로로 배치
    return CommonCardView(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
        children: [
          // ElevatedButton 위젯을 사용하여 버튼을 생성
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: BUTTON_COLOR, // 버튼 텍스트 색상
              backgroundColor: BACKGROUND_COLOR, // 버튼 배경 색상
              side: BorderSide(color: BUTTON_COLOR), // 버튼 테두리 색상
            ),
            // 버튼이 눌렸을 때의 동작 정의
            onPressed: () async {
              // URL을 상수로 선언
              const url = 'https://pf.kakao.com/_xjVrbG';
              // URI를 파싱하여 생성
              final uri = Uri.parse(url);
              // URL을 열 수 있는지 확인하고 열 수 있으면 URL을 엶
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                // URL을 열 수 없으면 예외를 던짐
                throw 'Could not launch $url';
              }
            },
            // 버튼의 자식 위젯으로 텍스트를 설정
            child: Text(
              '상품 문의하기',
              style: TextStyle(
                fontWeight: FontWeight.bold, // 텍스트를 굵게 설정
              ),
            ),
          ),
        ],
      ),
      backgroundColor: BEIGE_COLOR, // 카드의 배경색 설정
    );
  }
}
// ------ 연결된 링크로 이동하는 '상품 문의하기' 버튼을 UI로 구현하는 ProductInquiryContents 클래스 내용 구현 끝