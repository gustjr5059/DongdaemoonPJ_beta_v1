
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
import '../../announcement/provider/announce_all_provider.dart';
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
import '../../manager/review/provider/review_all_provider.dart';
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
import '../../wishlist/provider/wishlist_all_providers.dart';
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

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정
    // sortBtn 관련 수치 동적 적용
    final double sortBtnX = screenSize.width * (8 / referenceWidth);
    final double sortBtneY = screenSize.height * (4 / referenceHeight);

    // 현재 선택된 정렬 타입을 감시
    final selectedSortType = ref.watch(sortButtonProvider);
    // print("현재 정렬 상태: $selectedSortType");
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sortBtnX, vertical: sortBtneY),
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

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정
    // sortBtn 관련 수치 동적 적용
    final double sortBtn1X = screenSize.width * (4 / referenceWidth);
    final double sortBtn2X = screenSize.width * (8 / referenceWidth);
    final double sortBtnTextFontSize = screenSize.height * (12 / referenceHeight);

    // 현재 버튼이 선택된 상태인지 여부를 결정
    final bool isSelected = selectedSortType == title;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sortBtn1X), // 좌우 패딩 설정
        child: ElevatedButton(
          onPressed: () {
            ref.read(sortButtonProvider.notifier).state =
                title; // 버튼 클릭 시 정렬 상태 업데이트
            ref.read(productListProvider.notifier).sortType =
                title; // 상품 데이터 정렬 상태 업데이트
            // print("정렬 버튼 클릭: $title");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Color(0xFFE17735) : Color(0xFFCACACA),
            // 선택된 버튼 배경 색상 설정
            minimumSize: Size(0, 40),
            // 최소 버튼 크기 설정
            padding: EdgeInsets.symmetric(horizontal: sortBtn2X), // 버튼 내 패딩 설정
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(67),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown, // 텍스트 크기를 버튼 크기에 맞게 조절
            child: Text(
              title,
              textAlign: TextAlign.center, // 텍스트 가운데 정렬
              style: TextStyle(
                fontSize: sortBtnTextFontSize,
                color: Color(0xFFFFFFFF),
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.w800, // ExtraBold
              ),
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
  // 발주 목록 내 데이터를 불러오는 orderlistItemsProvider 초기화
  ref.invalidate(orderlistItemsProvider);
  // 발주 내역 화면 관련 초기화 부분 끝

  // 발주 내역 상세 화면 관련 초기화 부분 시작
  // 발주 화면에서 로그아웃 이벤트를 실시간으로 감지하고 처리하는 로직 (여기에도 발주 화면 내 프로바이더 중 초기화해야하는 것을 로직 구현)
  ref.read(orderListDetailScrollPositionProvider.notifier).state =
  0.0; // 발주 화면 자체의 스크롤 위치 인덱스를 초기화
  // 발주 목록 상세 화면 내 발주내역 데이터를 불러오는 로직 초기화
  ref.invalidate(orderlistDetailItemProvider);
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
  ref.invalidate(wishlistItemsLoadFutureProvider); // 찜 목록  데이터 로드 초기화
  ref.invalidate(wishlistItemLoadStreamProvider); // 찜 목록 실시간 삭제된 데이터 로드 초기화
  // 찜 목록 화면 관련 초기화 부분 끝

  // 마이페이지 화면 관련 초기화 부분 시작
  ref.read(profileMainScrollPositionProvider.notifier).state =
  0.0; // 마이페이지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(profileMainSmall1BannerPageProvider.notifier).state = 0; // 마이페이지 소배너 페이지뷰 초기화
  // 머아패아자 화면 관련 초기화 부분 끝

  // 공지사항 화면 관련 초기화 부분 시작
  ref.read(announceScrollPositionProvider.notifier).state =
  0.0; // 공지사항 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(announceDetailScrollPositionProvider.notifier).state =
  0.0; // 공지사항 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  // 공지사항 화면 내 데이터를 불러오는 announceItemsProvider 초기화
  ref.invalidate(announceItemsProvider);
  // 공지사항 상세 화면 내 데이터를 불러오는 announceDetailItemProvider 초기화
  ref.invalidate(announceDetailItemProvider);
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
  ref.invalidate(productReviewProvider); // 특정 상품에 대한 리뷰 데이터를 초기화
  // 리뷰 관리 화면 관련 초기화 부분 끝

  // ------ 관리자용 화면인 리뷰관리, 쪽지관리, 발주내역 관리, 찜 목록 괸리, 공지사항 관리 관련 초기화 부분 시작
  // 리뷰 관리 화면 초기화 시작
  ref.read(adminReviewScrollPositionProvider.notifier).state = 0.0;
  ref.invalidate(adminUsersEmailProvider); // 사용자 이메일 목록 초기화
  ref.invalidate(adminReviewListProvider); // 리뷰 목록 초기화
  ref.invalidate(adminDeleteReviewProvider); // 리뷰 삭제 관련 데이터 초기화
  ref.read(adminSelectedUserEmailProvider.notifier).state = null; // 선택된 사용자 이메일 초기화
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

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 신상 섹션 내 요소들의 수치
    final double DetailDocWidth =
        screenSize.width * (160 / referenceWidth); // 가로 비율
    final double DetailDocThumnailWidth =
        screenSize.width * (152 / DetailDocWidth); // 가로 비율
    final double DetailDoc1X =
        screenSize.width * (6 / referenceWidth);
    final double DetailDoc2X =
        screenSize.width * (2 / referenceWidth);
    final double DetailDoc3X =
        screenSize.width * (4 / referenceWidth);
    final double DetailDoc4X =
        screenSize.width * (-9 / referenceWidth);
    final double DetailDoc1Y =
        screenSize.height * (6 / referenceHeight);
    final double DetailDoc2Y =
        screenSize.height * (2 / referenceHeight);
    final double DetailDoc3Y =
        screenSize.height * (-11 / referenceHeight);
    final double DetailDocTextFontSize1 =
        screenSize.height * (11 / referenceHeight);
    final double DetailDocTextFontSize2 =
        screenSize.height * (12 / referenceHeight);
    final double DetailDocTextFontSize3 =
        screenSize.height * (12 / referenceHeight);
    final double DetailDocTextFontSize4 =
        screenSize.height * (14 / referenceHeight);
    final double DetailDocColorImageWidth =
        screenSize.height * (12 / referenceHeight);
    final double DetailDocColorImageHeight =
        screenSize.height * (12 / referenceHeight);

    final double interval1Y = screenSize.height * (4 / referenceHeight);
    final double interval1X = screenSize.width * (6 / referenceWidth);

    return GestureDetector(
      // 문서 클릭 시 navigateToDetailScreen 함수를 호출함.
      onTap: () {
        navigateToDetailScreen(
            context, product); // product.docId를 사용하여 해당 문서로 이동함.
      },
      child: Container(
        // 높이를 명시적으로 지정하여 충분한 공간 확보
        width: DetailDocWidth,
        padding: EdgeInsets.all(DetailDoc3X),
        margin: EdgeInsets.all(DetailDoc3X),
        decoration: BoxDecoration(
          // 컨테이너의 배경색을 흰색으로 설정하고 둥근 모서리 및 그림자 효과를 추가함
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0, // 그림자의 퍼짐 정도
              blurRadius: 1, // 그림자 흐림 정도 (숫자가 작을수록 선명함)
              offset: Offset(0, 4), // 그림자의 위치를 설정함 (x: 0으로 수평 위치를 고정, y: 4로 하단에만 그림자 발생)
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
                            width: DetailDocThumnailWidth, fit: BoxFit.cover),
                        // 위젯을 위치시키는 클래스, 상위 위젯의 특정 위치에 자식 위젯을 배치함
                        Positioned(
                          top: DetailDoc3Y,  // 자식 위젯을 상위 위젯의 위쪽 경계에서 -10 만큼 떨어뜨림 (위로 10 이동)
                          right: DetailDoc4X, // 자식 위젯을 상위 위젯의 오른쪽 경계에서 -10 만큼 떨어뜨림 (왼쪽으로 10 이동)
                          // 찜 목록 아이콘 동작 로직 관련 클래스인 WishlistIconButton 재사용하여 구현
                          child: WishlistIconButton(
                            product: product, // 'product' 파라미터를 전달
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: interval1Y),
                // 제품 간단한 소개를 표시함.
                if (product.briefIntroduction != null)
                  Padding(
                    padding: EdgeInsets.only(left: DetailDoc1X, top: DetailDoc1Y),
                    child: Text(
                      product.briefIntroduction!,
                      style: TextStyle(
                        fontSize: DetailDocTextFontSize1,
                        color: Colors.black, // 텍스트 색상
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.bold,),
                      maxLines: 2, // 최대 2줄까지 표시함.
                      overflow: TextOverflow.visible, // 넘치는 텍스트는 '...'으로 표시함.
                    ),
                  ),
                SizedBox(height: interval1Y),
                // 원래 가격을 표시함. 소수점은 표시하지 않음.
                if (product.originalPrice != null)
                  Padding(
                    padding: EdgeInsets.only(left: DetailDoc1X, top: DetailDoc2Y),
                    child: Row(
                      children: [
                        Text(
                          '${product.originalPrice!.toStringAsFixed(0)}원',
                          style: TextStyle(
                              fontSize: DetailDocTextFontSize2,
                              color: Color(0xFF6C6C6C), // 텍스트 색상
                              fontFamily: 'NanumGothic',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.lineThrough
                          ),
                        ),
                        SizedBox(width: interval1X),
                        // 할인율을 빨간색으로 표시함.
                        if (product.discountPercent != null)
                          Text(
                            '${product.discountPercent!.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: DetailDocTextFontSize3,
                              color: Colors.red, // 텍스트 색상
                              fontFamily: 'NanumGothic',
                              fontWeight: FontWeight.w800, // ExtraBold로 설정
                            ),
                          ),
                      ],
                    ),
                  ),
                // 할인된 가격을 표시함. 소수점은 표시하지 않음.
                if (product.discountPrice != null)
                  Padding(
                    padding: EdgeInsets.only(left: DetailDoc1X, top: DetailDoc2Y),
                    child: Text(
                      '${product.discountPrice!.toStringAsFixed(0)}원',
                      style: TextStyle(
                        fontSize: DetailDocTextFontSize4,
                        color: Colors.black, // 텍스트 색상
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.w800, // ExtraBold로 설정,
                      ),
                    ),
                  ),
                SizedBox(height: interval1Y),
                // 제품 색상 옵션을 표시함.
                if (product.colors != null)
                  Row(
                    children: product.colors!
                        .asMap()
                        .map((index, color) => MapEntry(
                      index,
                      Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? DetailDoc1X : DetailDoc2X, // 첫 번째 이미지만 left: 14.0, 나머지는 right: 2.0
                          right: DetailDoc2X,
                        ),
                        child: Image.network(color, width: DetailDocColorImageWidth, height: DetailDocColorImageHeight),
                      ),
                    ))
                        .values
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
        buildProductImageSliderSection(context, product, ref, pageController, product.docId), // 이미지 슬라이더 섹션
        // 제품 소개 부분과 가격 부분을 표시하는 위젯을 호출.
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFDADADA), width: 1.0), // 하단 테두리 색상을 지정함
            ),
          ),
          child: CommonCardView(
            content: buildProductBriefIntroAndPriceInfoSection(context, ref, product), // 제품 소개 및 가격 정보 부분 섹션
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0.0, // 그림자 효과 0
            margin: const EdgeInsets.symmetric(horizontal: 0.0), // 좌우 여백을 0으로 설정.
            padding: const EdgeInsets.all(0.0), // 카드 내부 여백을 0.0으로 설정.
          ),
        ),
        // 제품 색상과 사이즈 부분을 표시하는 클래스를 호출.
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFDADADA), width: 1.0), // 하단 테두리 색상을 지정함
            ),
          ),
          child: CommonCardView(
            content: ProductColorAndSizeSelection(product: product), // 색상과 사이즈 선택 관련 섹션
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0.0, // 그림자 효과 0
            margin: const EdgeInsets.symmetric(horizontal: 0.0), // 좌우 여백을 0으로 설정.
            padding: const EdgeInsets.all(0.0), // 카드 내부 여백을 1.0으로 설정.
          ),
        ),
        // 제품 선택한 색상과 사이즈 부분을 표시하는 위젯을 호출.
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFDADADA), width: 1.0), // 하단 테두리 색상을 지정함
            ),
          ),
          child: CommonCardView(
            content: buildProductAllCountAndPriceSelection(context, ref, product), // 총 선택 내용이 나오는 섹션
            backgroundColor: Color(0xFFEEEEEE),
            elevation: 0.0,
            margin: const EdgeInsets.symmetric(horizontal: 0.0),
            padding: const EdgeInsets.all(0.0),
          ),
        ),
      ],
    ),
  );
}
// ------ buildProdDetailScreenContents 위젯의 구현 끝

// ------ buildProductImageSlider 위젯 시작: 제품 이미지 부분을 구현.
Widget buildProductImageSliderSection(BuildContext context, ProductContent product, WidgetRef ref,
    PageController pageController, String productId) {

  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393 세로 852
  final double referenceWidht = 393.0;
  final double referenceHeight = 852.0;

  // 이미지 부분 수치
  final double ImageSliderSectionHeight = screenSize.height * (421 / referenceHeight);

  // 이미지 인디케이터 부분 수치
  final double ImageSliderSectionIndicator1Y = screenSize.height * (10 / referenceHeight);
  final double ImageSliderSectionIndicator2Y = screenSize.height * (8 / referenceHeight);
  final double ImageSliderSectionIndicator1X = screenSize.width * (4 / referenceWidht);
  final double ImageSliderSectionIndicatorWidth = screenSize.height * (12 / referenceHeight);
  final double ImageSliderSectionIndicatorHeight = screenSize.height * (12 / referenceHeight);

  // productId를 사용하여 pageProvider를 가져옴.
  final pageProvider = getImagePageProvider(productId);

  return Stack(
    children: [
      // CarouselSlider 위젯을 사용하여 이미지를 슬라이드 형태로 보여줌.
      CarouselSlider(
        options: CarouselOptions(
          height: ImageSliderSectionHeight,
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
      Positioned(
        bottom: ImageSliderSectionIndicator1Y, // 이미지 하단에서 10픽셀 위에 인디케이터를 배치
        left: 0,
        right: 0, // 양쪽 모두 0으로 설정해 인디케이터를 중앙 정렬
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // product.detailPageImages의 각 항목을 반복하여 인디케이터를 생성함.
          children: product.detailPageImages?.asMap().entries.map((entry) {
            return GestureDetector(
              // 인디케이터를 클릭하면 해당 페이지로 이동함.
              onTap: () => pageController.jumpToPage(entry.key),
              child: Container(
                width: ImageSliderSectionIndicatorWidth,
                height: ImageSliderSectionIndicatorHeight,
                margin: EdgeInsets.symmetric(vertical: ImageSliderSectionIndicator2Y, horizontal: ImageSliderSectionIndicator1X),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // 현재 페이지를 기준으로 인디케이터 색상을 변경함.
                  color: ref.watch(pageProvider) == entry.key
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            );
          }).toList() ??
              [],
        ),
      ),
    ],
  );
}
// ------ buildProductImageSlider 위젯 끝: 제품 이미지 부분을 구현.

// ------ buildProductBriefIntroAndPriceInfoSection 위젯 시작: 제품 소개 및 가격 정보 부분을 구현.
Widget buildProductBriefIntroAndPriceInfoSection(
    BuildContext context, WidgetRef ref, ProductContent product) {

  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 섹션 내 x, y 부분 수치
  final double sectionX = screenSize.width * (24 / referenceWidth);
  final double section1Y = screenSize.width * (30 / referenceHeight);
  final double section2Y = screenSize.width * (10 / referenceHeight);
  final double section3Y = screenSize.width * (1 / referenceHeight);
  final double width1X = screenSize.width * (15 / referenceWidth);

  // 상품번호 텍스트 부분 수치
  final double productNumberFontSize = screenSize.height * (14 / referenceHeight); // 텍스트 크기
  // 상품 설명 텍스트 부분 수치
  final double productIntroductionFontSize = screenSize.height * (22 / referenceHeight); // 텍스트 크기
  // 상품 원가 텍스트 부분 수치
  final double productOriginalPriceFontSize = screenSize.height * (18 / referenceHeight); // 텍스트 크기
  // 상품 할인가 텍스트 부분 수치
  final double productDiscountPriceFontSize = screenSize.height * (24 / referenceHeight); // 텍스트 크기
  // 상품 할인율 텍스트 부분 수치
  final double productDiscountPercentFontSize = screenSize.height * (22 / referenceHeight); // 텍스트 크기


  final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'); // 정규식을 사용하여 천 단위로 쉼표를 추가.
  return Padding(
    padding: EdgeInsets.only(left: sectionX, right: sectionX), // 좌/우 패딩을 sectionX로 설정
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
      children: [
        // 제품 번호를 표시함.
        if (product.productNumber != null) // productNumber가 null이 아닌 경우에만 표시
          Padding(
            padding: EdgeInsets.only(top: section1Y), // 상단 패딩을 section1Y로 설정
            child: Text(
              '상품번호: ${product.productNumber}', // productNumber 내용을 표시
              style: TextStyle(
                fontSize: productNumberFontSize,
                fontWeight: FontWeight.bold,
                fontFamily: 'NanumGothic',
                color: Colors.black,
              ), // 글자 크기를 14로 설정
            ),
          ),
        // 제품 간단한 소개를 표시함.
        if (product.briefIntroduction != null) // briefIntroduction이 null이 아닌 경우에만 표시
          Padding(
            padding: EdgeInsets.only(top: section2Y), // 상단 패딩을 section2Y로 설정
            child: Text(
              product.briefIntroduction!, // briefIntroduction 내용을 표시
              style: TextStyle(
                fontSize: productIntroductionFontSize,
                fontWeight: FontWeight.bold,
                fontFamily: 'NanumGothic',
                color: Colors.black,
              ),
              maxLines: 2, // 최대 2줄로 표시
              overflow: TextOverflow.visible, // 넘치는 텍스트를 표시
            ),
          ),
        // 원래 가격을 표시함. 소수점은 표시하지 않음.
        if (product.originalPrice != null) // originalPrice가 null이 아닌 경우에만 표시
          Padding(
            padding: EdgeInsets.only(top: section1Y), // 상단 패딩을 section1Y로 설정
            child: Text(
              '${product.originalPrice!.toStringAsFixed(0).replaceAllMapped(reg, (match) => '${match[1]},')}원', // 원래 가격을 표시, 소수점 없음
              style: TextStyle(
                fontSize: productOriginalPriceFontSize,
                decoration: TextDecoration.lineThrough, // 취소선을 추가
                color: Color(0xFF999999), // 색상을 연한 회색으로 설정
                decorationColor: Colors.grey[700], // 취소선 색상을 진한 회색으로 설정
                fontFamily: 'NanumGothic',
              ),
            ),
          ),
        // 할인된 가격을 표시함. 소수점은 표시하지 않음.
        if (product.discountPrice != null) // discountPrice가 null이 아닌 경우에만 표시
          Padding(
            padding: EdgeInsets.only(top: section3Y), // 상단 패딩을 section2Y로 설정
            child: Row(
              children: [
                Text(
                  '${product.discountPrice!.toStringAsFixed(0).replaceAllMapped(reg, (match) => '${match[1]},')}원', // 할인된 가격을 표시, 소수점 없음
                  style: TextStyle(
                    fontSize: productDiscountPriceFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'NanumGothic',
                  ),
                ),
                SizedBox(width: width1X), // 간격을 추가
                // 할인율을 빨간색으로 표시함.
                if (product.discountPercent != null) // discountPercent가 null이 아닌 경우에만 표시
                  Text(
                    '${product.discountPercent!.toStringAsFixed(0)}%', // 할인율을 표시, 소수점 없음
                    style: TextStyle(
                      fontSize: productDiscountPercentFontSize,
                      fontWeight: FontWeight.w800,
                      color: Colors.red,
                      fontFamily: 'NanumGothic',
                    ),
                  ),
                Spacer(), // 할인율과의 간격 공간 생성
                // 찜 목록 아이콘 동작 로직 관련 클래스인 WishlistIconButton 재사용하여 구현
                WishlistIconButton(
                  product: product, // 'product' 파라미터를 전달
                ),
              ],
            ),
          ),
        SizedBox(height: section1Y),
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

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 섹션 내 x, y 부분 수치
    final double sectionX = screenSize.width * (24 / referenceWidth);
    final double section1Y = screenSize.width * (40 / referenceHeight);
    final double section2Y = screenSize.width * (8 / referenceHeight);
    final double width1X = screenSize.width * (57 / referenceWidth);
    final double width2X = screenSize.width * (12 / referenceWidth);
    final double width3X = screenSize.width * (45 / referenceWidth);

    // 색상 텍스트 부분 수치
    final double colorFontSize = screenSize.height * (16 / referenceHeight);
    // 색상 이미지 데이터 부분 수치
    final double colorImageLength = screenSize.width * (24 / referenceWidth);
    // 색상 텍스트 데이터 부분 수치
    final double colorTextSize = screenSize.width * (16 / referenceWidth);
    // 사이즈 텍스트 부분 수치
    final double sizeFontSize = screenSize.height * (16 / referenceHeight);
    // 사이즈 텍스트 데이터 부분 수치
    final double sizeTextSize = screenSize.width * (16 / referenceWidth);

    return Padding(
      padding: EdgeInsets.only(left: sectionX, right: sectionX, top: section1Y), // 좌우 여백을 sectionX, 위쪽 여백을 section1Y로 설정.
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // 자식 위젯들을 왼쪽 정렬로 배치.
            children: [
              Text('색상',
                  style: TextStyle(
                    fontSize: colorFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'NanumGothic',
                  )
              ),// '색상' 라벨을 표시.
              SizedBox(width: width1X), // '색상' 라벨과 드롭다운 버튼 사이의 간격을 width1X로 설정.
              Expanded(
                // 드롭다운 버튼을 화면 너비에 맞게 확장.
                child: DropdownButton<String>(
                  isExpanded: true,
                  // 드롭다운 버튼의 너비를 최대로 확장.
                  underline: SizedBox.shrink(),
                  // 아래 선을 보이지 않게 설정.
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
                            width: colorImageLength, height: colorImageLength), // 색상을 나타내는 이미지를 표시.
                        SizedBox(width: width2X), // 이미지와 텍스트 사이의 간격을 width2X로 설정.
                        Text(option['text'],
                          style: TextStyle(
                            fontSize: colorTextSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'NanumGothic',
                          ),
                        ),// 색상의 텍스트 설명을 표시.
                      ],
                    ),
                  ))
                      .toList(), // 드롭다운 메뉴 아이템 목록을 생성.
                ),
              ),
            ],
          ),
          SizedBox(height: section2Y), // 색상 선택과 사이즈 선택 사이의 수직 간격을 section2Y로 설정.
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // 자식 위젯들을 왼쪽 정렬로 배치.
            children: [
              Text('사이즈',
                  style: TextStyle(
                    fontSize: sizeFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'NanumGothic',
                  )
              ), // '사이즈' 라벨을 표시.
              SizedBox(width: width3X), // '사이즈' 라벨과 드롭다운 버튼 사이의 간격을 width3X로 설정.
              Expanded(
                // 드롭다운 버튼을 화면 너비에 맞게 확장.
                child: DropdownButton<String>(
                  isExpanded: true,
                  // 드롭다운 버튼의 너비를 최대로 확장.
                  underline: SizedBox.shrink(),
                  // 아래 선을 보이지 않게 설정.
                  value: ref.watch(sizeSelectionIndexProvider),
                  // 선택된 사이즈 값을 가져옴.
                  onChanged: (newValue) {
                    ref.read(sizeSelectionIndexProvider.notifier).state = newValue!;
                    // 새로운 사이즈가 선택되면 상태를 업데이트.
                  },
                  items: product.sizes
                      ?.map((size) => DropdownMenuItem<String>(
                    value: size, // 각 사이즈를 값으로 사용.
                    child: Text(size,
                        style: TextStyle(
                          fontSize: sizeTextSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'NanumGothic',
                        )
                    ), // 사이즈 텍스트를 표시.
                  ))
                      .toList(), // 드롭다운 메뉴 아이템 목록을 생성.
                ),
              ),
              SizedBox(height: section1Y)
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

  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 섹션 내 x, y 부분 수치
  final double sectionX = screenSize.width * (20 / referenceWidth);
  final double section1Y = screenSize.width * (8 / referenceHeight);
  final double section2Y = screenSize.width * (30 / referenceHeight);
  final double width1X = screenSize.width * (57 / referenceWidth);
  final double width2X = screenSize.width * (12 / referenceWidth);
  final double width3X = screenSize.width * (41 / referenceWidth);

  // 선택한 색상 텍스트 부분 수치
  final double selectedColorFontSize = screenSize.height * (16 / referenceHeight);
  // 선택한 색상 이미지 데이터 부분 수치
  final double selectedColorImageLength = screenSize.width * (24 / referenceWidth);
  // 산텍힌 색상 텍스트 데이터 부분 수치
  final double selectedColorTextSize = screenSize.width * (16 / referenceWidth);
  // 선택한 사이즈 텍스트 부분 수치
  final double selectedSizeFontSize = screenSize.height * (16 / referenceHeight);
  // 선택한 사이즈 텍스트 데이터 부분 수치
  final double selectedSizeTextSize = screenSize.width * (16 / referenceWidth);


  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 색상과 사이즈가 선택되었을 때만 보여줌.
      if (selectedColorUrl != null && selectedSize != null)
        Padding(
          padding: EdgeInsets.only(left: sectionX, right: sectionX, top: section1Y), // 좌우 여백을 sectionX, 위쪽 여백을 section1Y로 설정.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 선택한 색상을 텍스트로 표시함.
                  Text('선택한 색상 :',
                      style: TextStyle(
                        fontSize: selectedColorFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'NanumGothic',
                      )
                  ),
                  SizedBox(width: width1X), // 텍스트와 이미지 사이의 간격을 width1X로 설정.
                  // 선택한 색상이 존재하면 이미지를 표시함.
                  if (selectedColorUrl != null)
                    Image.network(
                      selectedColorUrl,
                      width: selectedColorImageLength,
                      height: selectedColorImageLength,
                    ),
                  SizedBox(width: width2X), // 이미지와 텍스트 사이의 간격을 width2X로 설정.
                  // 선택한 색상 이름을 텍스트로 표시함.
                  Text(selectedColorText ?? '',
                    style: TextStyle(
                      fontSize: selectedColorTextSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'NanumGothic',
                    ),
                  ),
                ],
              ),
              SizedBox(height: section2Y), // 색상과 사이즈 사이의 수직 간격을 section2Y로 설정.
              Row(
                children: [
                  // 선택한 사이즈를 텍스트로 표시함.
                  Text('선택한 사이즈 : ',
                    style: TextStyle(
                      fontSize: selectedSizeFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'NanumGothic',
                    ),
                  ),
                  SizedBox(width: width3X), // 텍스트와 이미지 사이의 간격을 width3X로 설정.
                  // 선택한 색상 이름을 텍스트로 표시함.
                  Text(selectedSize ?? '',
                      style: TextStyle(
                        fontSize: selectedSizeTextSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'NanumGothic',
                      )
                  ),
                ],
              ),
              SizedBox(height: section1Y),
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

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 세로 852
    final double referenceHeight = 852.0;

    // 섹션 내 y 부분 수치
    final double section1Y = screenSize.height * (20 / referenceHeight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: section1Y),
        _buildTabButtons(context, ref, currentTabSection), // 탭 버튼들을 빌드
        SizedBox(height: section1Y), // 탭과 컨텐츠 사이에 간격을 추가
        _buildSectionContent(currentTabSection), // 현재 선택된 탭의 내용을 빌드
      ],
    );
  }

  // 탭 버튼들을 빌드하는 위젯인 _buildTabButtons
  Widget _buildTabButtons(BuildContext context, WidgetRef ref, ProdDetailScreenTabSection currentTabSection) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // '상품정보' 탭 버튼을 빌드
        _buildTabButton(context, ref, ProdDetailScreenTabSection.productInfo, currentTabSection, '상품정보'),
        // '리뷰' 탭 버튼을 빌드
        _buildTabButton(context, ref, ProdDetailScreenTabSection.reviews, currentTabSection, '리뷰'),
        // '문의' 탭 버튼을 빌드
        _buildTabButton(context, ref, ProdDetailScreenTabSection.inquiry, currentTabSection, '문의'),
      ],
    );
  }

  // 개별 탭 버튼을 빌드하는 위젯인 _buildTabButton
  Widget _buildTabButton(BuildContext context, WidgetRef ref, ProdDetailScreenTabSection section, ProdDetailScreenTabSection currentTabSection, String text) {
    final isSelected = section == currentTabSection; // 현재 선택된 탭인지 확인

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 세로 852
    final double referenceHeight = 852.0;

    // 상품정보, 리뷰 정보, 문의 선택 버튼 부분 수치
    final double _buildTabButtonFontSize = screenSize.height * (14 / referenceHeight);

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
              fontSize: _buildTabButtonFontSize,
              fontFamily: 'NanumGothic',
              color: isSelected ? Colors.black : Colors.grey, // 선택된 탭이면 검정색, 아니면 회색
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, // 선택된 탭이면 굵게, 아니면 일반
            ),
          ),
          if (isSelected) // 선택된 탭이면 밑줄 표시
            Container(
              width: _buildTabButtonFontSize * 4.5,
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
        return reviewsContent.isEmpty
            ? Center(child: Text('리뷰가 없습니다.')) // 리뷰 데이터가 없을 때 표시
            : Column(children: reviewsContent); // '리뷰' 내용을 반환
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
  final ProductContent product;

  const ProductInfoContents({Key? key, required this.product}) : super(key: key);

  @override
  _ProductInfoContentsState createState() => _ProductInfoContentsState();
}

class _ProductInfoContentsState extends State<ProductInfoContents> {
  bool showFullImage = false; // 전체 이미지를 표시할지 여부를 저장하는 변수, 초기값은 false로 설정됨.

  // 이미지 URL을 받아서 이미지의 1/5만 표시하는 위젯을 생성하는 함수임.
  Widget buildPartialImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(); // 이미지가 없을 경우 빈 컨테이너 반환됨.
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRect(
          child: Align(
            alignment: Alignment.topCenter, // 이미지 상단 정렬됨.
            heightFactor: 0.2, // 이미지의 높이가 1/5로 설정됨.
            child: Image.network(
              imageUrl,
              fit: BoxFit.fitWidth, // 이미지가 좌우로 꽉 차도록 원본 비율이 유지됨.
              width: MediaQuery.of(context).size.width, // 화면 너비에 맞추어 이미지 크기가 조정됨.
            ),
          ),
        );
      },
    );
  }

  // 전체 이미지를 표시하는 함수임.
  Widget buildFullImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(); // 이미지가 없을 경우 빈 컨테이너 반환됨.
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.fitWidth, // 이미지가 좌우로 꽉 차도록 원본 비율이 유지됨.
      width: MediaQuery.of(context).size.width, // 화면 너비에 맞추어 이미지 크기가 조정됨.
    );
  }

  // 밑줄과 텍스트를 포함하는 UI 위젯을 생성하는 함수임.
  Widget buildSectionTitle(String title) {
    final Size screenSize = MediaQuery.of(context).size; // 기기의 화면 크기를 동적으로 가져옴.
    final double referenceWidth = 393.0; // 기준 화면 너비를 설정함.
    final double referenceHeight = 852.0; // 기준 화면 높이를 설정함.

    final double buildSectionTitleFontSize = screenSize.height * (16 / referenceHeight); // 텍스트 크기가 화면 높이에 비례하여 설정됨.
    final double buildSectionWidthX = screenSize.width * (8 / referenceWidth); // 텍스트 좌우 여백 크기가 화면 너비에 비례하여 설정됨.
    final double buildSectionLineY = screenSize.height * (10 / referenceHeight); // 텍스트 아래 간격이 화면 높이에 비례하여 설정됨.

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(thickness: 3, color: Color(0xFFDADADA))), // 좌측에 두께 3의 회색 선이 표시됨.
            Padding(
              padding: EdgeInsets.only(left: buildSectionWidthX, right: buildSectionWidthX), // 좌우에 여백이 설정됨.
              child: Text(
                title, // 매개변수로 전달받은 제목이 표시됨.
                style: TextStyle(
                  fontFamily: 'NanumGothic', // 폰트가 NanumGothic으로 설정됨.
                  fontWeight: FontWeight.bold, // 글자가 굵게 설정됨.
                  fontSize: buildSectionTitleFontSize, // 글자 크기가 설정됨.
                  color: Color(0xFFDADADA), // 글자 색상이 회색으로 설정됨.
                ),
              ),
            ),
            Expanded(child: Divider(thickness: 3, color: Color(0xFFDADADA))), // 우측에 두께 3의 회색 선이 표시됨.
          ],
        ),
        SizedBox(height: buildSectionLineY), // 텍스트 아래에 여백이 추가됨.
      ],
    );
  }

  // 이미지 전체를 볼 수 있는 버튼을 생성하는 함수임.
  Widget buildExpandButton(String text, IconData icon) {
    final Size screenSize = MediaQuery.of(context).size; // 기기의 화면 크기를 동적으로 가져옴.
    final double referenceWidth = 393.0; // 기준 화면 너비를 설정함.
    final double referenceHeight = 852.0; // 기준 화면 높이를 설정함.

    final double ExpandBtnWidth = screenSize.width * (345 / referenceWidth); // 버튼 너비가 화면 너비에 비례하여 설정됨.
    final double ExpandBtnHeight = screenSize.height * (54 / referenceHeight); // 버튼 높이가 화면 높이에 비례하여 설정됨.
    final double ExpandBtnX = screenSize.width * (24 / referenceWidth); // 버튼의 좌측 여백이 화면 너비에 비례하여 설정됨.
    final double ExpandBtnFontSize = screenSize.height * (14 / referenceHeight); // 버튼 텍스트 크기가 화면 높이에 비례하여 설정됨.
    final double ExpandBtnY = screenSize.height * (10 / referenceHeight); // 버튼 상단 여백이 화면 높이에 비례하여 설정됨.

    return Container(
      height: ExpandBtnHeight, // 버튼 높이가 설정됨.
      width: ExpandBtnWidth, // 버튼 너비가 설정됨.
      margin: EdgeInsets.only(left: ExpandBtnX, top: ExpandBtnY), // 좌측 및 상단 여백이 설정됨.
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            showFullImage = !showFullImage; // 버튼 클릭 시 전체 이미지 표시 여부가 토글됨.
          });
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Color(0xFFE17735), // 텍스트 색상이 설정됨.
          backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 버튼 배경색이 앱 배경색으로 설정됨.
          side: BorderSide(color: Color(0xFFE17735),
          ), // 버튼 테두리 색상이 설정됨.
        ),
        icon: Icon(icon, size: ExpandBtnFontSize, color: Color(0xFFE17735),
        ), // 아이콘과 그 크기 및 색상이 설정됨.
        label: Text(
          text, // 버튼에 표시될 텍스트가 설정됨.
          style: TextStyle(
            fontFamily: 'NanumGothic', // 텍스트 폰트가 NanumGothic으로 설정됨.
            fontSize: ExpandBtnFontSize, // 텍스트 크기가 설정됨.
            fontWeight: FontWeight.bold, // 텍스트가 굵게 설정됨.
            color: Color(0xFFE17735), // 텍스트 색상이 설정됨.
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size; // 화면 크기를 동적으로 가져옴.
    final double referenceHeight = 852.0; // 기준 화면 높이를 설정함.
    final double productInfoY = screenSize.height * (10 / referenceHeight); // 이미지 사이 여백이 설정됨.

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 위젯이 세로로 나열됨.
      children: [
        buildSectionTitle('DETAILS INFO'), // 섹션 제목을 생성하여 화면에 표시됨.
        if (!showFullImage)
          buildPartialImage(widget.product.detailDetailsImage), // 전체 이미지가 아닌 부분 이미지가 표시됨.
        if (showFullImage)
          buildFullImage(widget.product.detailDetailsImage), // 전체 이미지가 표시됨.
        SizedBox(height: productInfoY), // 이미지 사이에 여백이 추가됨.
        if (!showFullImage)
          buildExpandButton('상품 정보 펼쳐보기', Icons.arrow_downward), // 전체 이미지 보기 버튼이 표시됨.
        if (showFullImage)
          buildExpandButton('접기', Icons.arrow_upward), // 이미지 접기 버튼이 표시됨.
      ],
    );
  }
}
// -------- 상품 상세 화면 내 상품정보에서 UI로 구현되는 내용 관련 ProductInfoContents 클래스 부분 끝

// ------ 상품 상세 화면 내 리뷰에서 UI로 구현되는 내용 관련 ProductReviewContents 클래스 시작
// ProductReviewContents 클래스는 StatelessWidget을 상속받아 정의됨
// 해당 리뷰 부분은 리뷰 작성 화면에서 작성한 내용을 파이어베이스에 저장 후 저장된 내용을 불러오도록 로직을 재설계해야함!!
class ProductReviewContents extends StatelessWidget {
  // 리뷰 작성자의 이름
  final String reviewerName;
  // 리뷰 작성 날짜
  final String reviewDate;
  // 리뷰 내용
  final String reviewContent;
  // 리뷰 제목
  final String reviewTitle;  // 리뷰 제목 추가
  // 리뷰에 첨부된 이미지 리스트
  final List<String> reviewImages;  // 리뷰에 첨부된 이미지들
  // 리뷰에서 선택된 색상
  final String reviewSelectedColor;  // 선택된 색상 추가
  // 리뷰에서 선택된 사이즈
  final String reviewSelectedSize;  // 선택된 사이즈 추가

  // 생성자에서 모든 필드를 필수로 받아 초기화함
  const ProductReviewContents({
    required this.reviewerName,
    required this.reviewDate,
    required this.reviewContent,
    required this.reviewTitle,  // 리뷰 제목 추가
    required this.reviewImages,  // 리뷰 이미지들 추가
    required this.reviewSelectedColor,  // 선택된 색상 추가
    required this.reviewSelectedSize,  // 선택된 사이즈 추가
  });

  @override
  Widget build(BuildContext context) {
    // 작성자 이름을 마스킹 처리함
    String maskedReviewerName = reviewerName.isNotEmpty
        ? reviewerName[0] + '*' * (reviewerName.length - 1)
        : '';

    final Size screenSize = MediaQuery.of(context).size; // 기기의 화면 크기를 동적으로 가져옴.
    final double referenceWidth = 393.0; // 기준 화면 너비를 설정함.
    final double referenceHeight = 852.0; // 기준 화면 높이를 설정함.

    final double buildSectionTitleFontSize = screenSize.height * (16 / referenceHeight); // 텍스트 크기가 화면 높이에 비례하여 설정됨.
    final double buildSectionWidthX = screenSize.width * (8 / referenceWidth); // 텍스트 좌우 여백 크기가 화면 너비에 비례하여 설정됨.
    final double buildSectionLineY = screenSize.height * (8 / referenceHeight); // 텍스트 아래 간격이 화면 높이에 비례하여 설정됨.
    final double interval1Y = screenSize.height * (4 / referenceHeight);
    final double reviewDataTextFontSize1 = screenSize.height * (14 / referenceHeight);

    return CommonCardView(
      // 배경색을 설정함
      backgroundColor: Color(0xFFF3F3F3),
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: buildSectionLineY, horizontal: buildSectionWidthX),
        // 리뷰 내용 전체를 세로로 정렬된 컬럼 위젯으로 구성함
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 작성자 이름을 마스킹 처리된 값으로 출력함
            _buildReviewInfoRow(context, '작성자: ', maskedReviewerName, bold: true),
            SizedBox(height: interval1Y),
            // 리뷰 작성일자를 출력함
            _buildReviewInfoRow(context, '리뷰 등록 일자: ', reviewDate, bold: true),
            SizedBox(height: interval1Y),
            // 선택된 색상 및 사이즈가 존재할 경우 이를 출력함
            if (reviewSelectedColor.isNotEmpty || reviewSelectedSize.isNotEmpty)
              _buildReviewInfoRow(context, '색상 / 사이즈: ', '$reviewSelectedColor / $reviewSelectedSize', bold: true),
            SizedBox(height: interval1Y),
            // 리뷰 제목이 존재할 경우 이를 출력함
            if (reviewTitle.isNotEmpty)
              _buildReviewInfoColumn(context, '제목: ', reviewTitle, bold: true, fontSize: reviewDataTextFontSize1),
            SizedBox(height: interval1Y),
            // 리뷰 내용이 존재할 경우 이를 출력함
            if (reviewContent.isNotEmpty)
              _buildReviewInfoColumn(context, '내용: ', reviewContent, bold: true, fontSize: reviewDataTextFontSize1),
            SizedBox(height: interval1Y),
            // 리뷰 이미지가 존재할 경우 이를 출력함
            if (reviewImages.isNotEmpty)
              _buildReviewImagesRow(reviewImages, context),
          ],
        ),
      ),
    );
  }

  // 리뷰 정보를 세로로 구성하여 표시하는 함수
  Widget _buildReviewInfoColumn(BuildContext context, String label, String value, {bool bold = false, double fontSize = 14}) {

    final Size screenSize = MediaQuery.of(context).size; // 기기의 화면 크기를 동적으로 가져옴.
    final double referenceWidth = 393.0; // 기준 화면 너비를 설정함.
    final double referenceHeight = 852.0; // 기준 화면 높이를 설정함.

    final double interval1Y = screenSize.height * (2 / referenceHeight);
    final double interval2Y = screenSize.height * (4 / referenceHeight);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: interval1Y),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 라벨 텍스트를 출력함
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.normal, // 라벨 텍스트는 기본 스타일로 표시함
              fontFamily: 'NanumGothic',
              color: Colors.black, // 텍스트 색상 설정
            ),
          ),
          SizedBox(height: interval2Y),
          // 데이터 텍스트를 출력함
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'NanumGothic',
              color: Colors.black, // 텍스트 색상 설정
              fontWeight: bold ? FontWeight.bold : FontWeight.normal, // 데이터 텍스트만 bold로 표시함
            ),
            textAlign: TextAlign.start,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }

  // 리뷰 정보를 가로로 구성하여 표시하는 함수
  Widget _buildReviewInfoRow(BuildContext context, String label, String value, {bool bold = false, double fontSize = 14}) {

    final Size screenSize = MediaQuery.of(context).size; // 기기의 화면 크기를 동적으로 가져옴.
    final double referenceWidth = 393.0; // 기준 화면 너비를 설정함.
    final double referenceHeight = 852.0; // 기준 화면 높이를 설정함.

    final double interval1Y = screenSize.height * (2 / referenceHeight);
    final double interval2Y = screenSize.height * (4 / referenceHeight);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: interval1Y),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 라벨 텍스트를 출력함
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.normal, // 라벨 텍스트는 기본 스타일로 표시함
              fontFamily: 'NanumGothic',
              color: Colors.black, // 텍스트 색상 설정
            ),
          ),
          SizedBox(height: interval2Y),
          // 데이터 텍스트를 확장 가능한 위젯으로 출력함
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: 'NanumGothic',
                color: Colors.black, // 텍스트 색상 설정
                fontWeight: bold ? FontWeight.bold : FontWeight.normal, // 데이터 텍스트만 bold로 표시함
              ),
              textAlign: TextAlign.start,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  // 리뷰 이미지를 가로로 구성하여 표시하는 함수
  Widget _buildReviewImagesRow(List<String> images, BuildContext context) {
    // 화면 너비를 계산함
    final width = MediaQuery.of(context).size.width;
    // 이미지 하나의 너비를 설정함
    final imageWidth = width / 4;

    final Size screenSize = MediaQuery.of(context).size; // 기기의 화면 크기를 동적으로 가져옴.
    final double referenceWidth = 393.0; // 기준 화면 너비를 설정함.

    final double interval1X = screenSize.width * (8 / referenceWidth);

    // 각 이미지를 가로로 나열하여 출력함
    return Row(
      children: images.map((image) {
        return GestureDetector(
          // 이미지를 클릭했을 때 원본 이미지를 보여주는 화면으로 이동함
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailOriginalImageScreen(
                  images: images,
                  initialPage: images.indexOf(image),
                ),
              ),
            );
          },
          // 이미지 컨테이너를 설정함
          child: Container(
            width: imageWidth,
            height: imageWidth,
            margin: EdgeInsets.only(right: interval1X),
            child: AspectRatio(
              aspectRatio: 1,
              // 네트워크에서 이미지를 불러와 출력함
              child: Image.network(image, fit: BoxFit.cover),
            ),
          ),
        );
      }).toList(),
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

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 버튼 관련 수치 동적 적용
    final double productInquiryBtnFontSize = screenSize.height * (14 / referenceHeight);
    final double productInquiryCardViewY = screenSize.height * (20 / referenceHeight);

    // CommonCardView 위젯을 반환, content에 Column 위젯을 사용하여 여러 위젯을 세로로 배치
    return CommonCardView(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
        children: [
          // ElevatedButton 위젯을 사용하여 버튼을 생성
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Color(0xFFE17735), // 텍스트 색상
              backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 배경 색상
              side: BorderSide(color: Color(0xFFE17735),), // 테두리 색상
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
                  fontFamily: 'NanumGothic',
                  fontSize: productInquiryBtnFontSize,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE17735),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0.0, // 그림자 효과 0
      margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: productInquiryCardViewY), // 좌우 여백을 0으로 설정.
      padding: const EdgeInsets.all(0.0), // 카드 내부 여백을 0.0으로 설정.
    );
  }
}
// ------ 연결된 링크로 이동하는 '상품 문의하기' 버튼을 UI로 구현하는 ProductInquiryContents 클래스 내용 구현 끝