// Dart의 IO 라이브러리에서 Platform 클래스를 가져옵니다. 이 클래스는 운영 체제에 대한 정보를 제공합니다.
import 'dart:io' show Platform;
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../cart/provider/cart_state_provider.dart';
import '../../../../../common/const/colors.dart';
import '../../../../../common/layout/common_body_parts_layout.dart';
import '../../../../../common/layout/common_exception_parts_of_body_layout.dart';
import '../../../../../common/provider/common_state_provider.dart';
import '../../../../../product/layout/product_body_parts_layout.dart';
import '../../../../../product/provider/product_state_provider.dart';
import '../../../../../review/provider/review_state_provider.dart';
import '../../../../../wishlist/provider/wishlist_state_provider.dart';
import '../../provider/aat_product_all_providers.dart';
import '../../provider/aat_product_state_provider.dart';

// flutter 패키지의 services 라이브러리를 가져옵니다.
// 이 라이브러리는 플러터 애플리케이션에서 네이티브 서비스에 접근할 수 있게 해줍니다.
// 예를 들어, 클립보드, 네트워크 상태, 시스템 설정 등을 제어할 수 있습니다.
import 'package:flutter/services.dart';

// 애플리케이션의 여러 부분에서 재사용될 수 있는 공통 UI 컴포넌트 파일을 임포트합니다.
// 이 파일은 통일된 디자인과 구조를 제공하여 UI 개발을 효율적으로 할 수 있도록 돕습니다.
import '../../../common/layout/aat_common_body_parts_layout.dart'; // 공통 UI 컴포넌트 파일

// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용 권장
// GlobalKey 사용 시 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// AatPaedingDetailProductScreen 클래스는 ConsumerWidget 상속, Riverpod를 통한 상태 관리 지원
class AatPaedingDetailProductScreen extends ConsumerStatefulWidget {
  final String fullPath; // 전체 경로를 나타내는 문자열 변수
  final String title; // 타이틀을 나타내는 문자열 변수

  const AatPaedingDetailProductScreen({
    Key? key, // 위젯의 키를 나타내는 매개변수
    required this.fullPath, // 전체 경로를 필수 매개변수로 받음
    required this.title, // 타이틀을 필수 매개변수로 받음
  }) : super(key: key); // 부모 클래스의 생성자를 호출하여 초기화함

  @override
  _AatPaedingDetailProductScreenState createState() =>
      _AatPaedingDetailProductScreenState();
}

// _AatPaedingDetailProductScreenState 클래스 시작
// _AatPaedingDetailProductScreenState 클래스는 AatPaedingDetailProductScreen 위젯의 상태를 관리함.
// WidgetsBindingObserver 믹스인을 통해 앱 생명주기 상태 변화를 감시함.
class _AatPaedingDetailProductScreenState
    extends ConsumerState<AatPaedingDetailProductScreen>
    with WidgetsBindingObserver {
  // 사용자 인증 상태 변경을 감지하는 스트림 구독 객체임.
  // 이를 통해 사용자 로그인 또는 로그아웃 상태 변경을 실시간으로 감지하고 처리할 수 있음.
  StreamSubscription<User?>? authStateChangesSubscription;

  // aatPaedingDetailScrollPositionProvider에서 ScrollController를 읽어와서 scrollController에 할당
  // ref.read(aatPaedingDetailScrollPositionProvider)는 provider를 이용해 상태를 읽는 방식.
  // ScrollController는 스크롤 가능한 위젯의 스크롤 동작을 제어하기 위해 사용됨.
  // 1.상단 탭바 버튼 클릭 시 해당 섹션으로 스크롤 이동하는 기능,
  // 2.하단 탭바의 버튼 클릭 시  화면 초기 위치로 스크롤 이동하는 기능,
  // 3.사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을때 마지막으로 본 위치로 자동으로 스크롤되도록 하는 기능,
  // 4.단순 스크롤을 내리거나 올릴 시, 상단 탭 바 버튼 텍스트 색상이 변경되도록 하는 기능,
  // 5. 'top' 버튼 클릭 시 홈 화면 초기 위치로 스크롤 이동하는 기능,
  // => 5개의 기능인 전체 화면의 스크롤을 제어하는 컨트롤러-화면 내의 여러 섹션으로의 이동 역할

  // aatPaedingDetailScrollPositionProvider : 여러 위젯에서 동일한 ScrollController를 공유하고,
  // 상태를 유지하기 위해 Riverpod의 Provider를 사용하여 관리함.
  // 이를 통해 앱의 다른 부분에서도 동일한 ScrollController에 접근할 수 있으며, 상태를 일관성 있게 유지함.
  // ScrollController를 late 변수로 선언
  // ScrollController가 여러 ScrollView에 attach 되어서 ScrollController가 동시에 여러 ScrollView에서 사용될 때 발생한 문제를 해결한 방법
  // => late로 변수 선언 / 해당 변수를 초기화(initState()) / 해당 변수를 해제 (dispose())
  late ScrollController
      paedingDetailProductScreenPointScrollController; // 스크롤 컨트롤러 선언

  late PageController pageController;

  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // StateProvider 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // getImagePageProvider의 상태를 0으로 초기화함.
      ref.read(getImagePageProvider(widget.fullPath).notifier).state = 0;
    });

    // 페이지 컨트롤러를 초기 페이지로 초기화함.
    pageController = PageController(
        initialPage: ref.read(getImagePageProvider(widget.fullPath)));

    pageController.addListener(() {
      // 페이지 컨트롤러의 현재 페이지를 반올림하여 getImagePageProvider 상태에 업데이트함.
      ref.read(getImagePageProvider(widget.fullPath).notifier).state =
          pageController.page!.round();
    });

    // ScrollController를 초기화
    paedingDetailProductScreenPointScrollController = ScrollController();

    // 스크롤 리스너 추가: 리뷰 탭일 때만 다음 페이지 로드
    paedingDetailProductScreenPointScrollController.addListener(() {
      // 현재 어떤 탭인지 확인
      final currentTabSection = ref.read(prodDetailScreenTabSectionProvider);
      if (currentTabSection == ProdDetailScreenTabSection.reviews) {
        if (paedingDetailProductScreenPointScrollController.position.pixels ==
            paedingDetailProductScreenPointScrollController.position.maxScrollExtent) {
          // 리뷰 탭이고, 스크롤이 끝에 도달했을 때만 다음 페이지 로드
          ref.read(productReviewListNotifierProvider(widget.fullPath).notifier).loadMoreReviews();
        }
      }
    });

    // initState에서 저장된 스크롤 위치로 이동
    // initState에서 실행되는 코드. initState는 위젯이 생성될 때 호출되는 초기화 단계
    // WidgetsBinding.instance.addPostFrameCallback 메서드를 사용하여 프레임이 렌더링 된 후 콜백을 등록함.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 스크롤 컨트롤러가 활성 스크롤 뷰를 가지고 있는지 확인함.
      if (paedingDetailProductScreenPointScrollController.hasClients) {
        // savedScrollPosition 변수에 저장된 스크롤 위치를 읽어옴.
        // ref.read(scrollPositionProvider)는 Riverpod 상태 관리 라이브러리를 사용하여
        // scrollPositionProvider에서 마지막으로 저장된 스크롤 위치를 가져옴.
        double savedScrollPosition =
            ref.read(aatPaedingDetailScrollPositionProvider);
        // paedingDetailProductScreenPointScrollController.jumpTo 메서드를 사용하여 스크롤 위치를 savedScrollPosition으로 즉시 이동함.
        // 이는 스크롤 애니메이션이나 다른 복잡한 동작 없이 바로 지정된 위치로 점프함.
        paedingDetailProductScreenPointScrollController
            .jumpTo(savedScrollPosition);
      }

      ref.invalidate(wishlistItemProvider); // 찜 목록 데이터 초기화
      // 화면을 돌아왔을 때 선택된 색상과 사이즈, 수량의 상태를 초기화함
      ref.read(colorSelectionIndexProvider.notifier).state = 0;
      ref.read(colorSelectionTextProvider.notifier).state = null;
      ref.read(colorSelectionUrlProvider.notifier).state = null;
      ref.read(sizeSelectionIndexProvider.notifier).state = null;
      ref.invalidate(detailQuantityIndexProvider);
      // 페이지가 처음 생성될 때 '상품 정보 펼쳐보기' 버튼이 클릭되지 않은 상태로 초기화
      ref.read(showFullImageProvider.notifier).state = false;
      ref
          .read(imagesProvider(widget.fullPath).notifier)
          .resetButtonState(); // '접기' 버튼 상태 초기화
      ref.read(productReviewListNotifierProvider(widget.fullPath).notifier).resetAndLoadFirstPage(); // 특정 상품에 대한 리뷰 데이터를 초기화
      ref.invalidate(cartItemCountProvider); // 장바구니 아이템 갯수 데이터 초기화
      ref.invalidate(wishlistItemCountProvider); // 찜 목록 아이템 갯수 데이터 초기화
    });

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        ref.read(aatPaedingDetailScrollPositionProvider.notifier).state =
            0; // paedingDetailScrollPositionProvider의 상태를 0으로 설정
        ref.read(getImagePageProvider(widget.fullPath).notifier).state =
            0; // getImagePageProvider의 상태를 0으로 설정
        // pageController가 ScrollView에 연결되어 있는지 확인 후 jumpToPage 호출
        if (pageController.hasClients) {
          pageController.jumpToPage(0); // pageController를 사용하여 페이지를 0으로 이동시킴.
        }

        ref.read(productReviewListNotifierProvider(widget.fullPath).notifier).resetAndLoadFirstPage(); // 특정 상품에 대한 리뷰 데이터를 초기화
        ref.invalidate(wishlistItemProvider); // 찜 목록 데이터 초기화
        ref.invalidate(cartItemCountProvider); // 장바구니 아이템 갯수 데이터 초기화
        ref.invalidate(wishlistItemCountProvider); // 찜 목록 아이템 갯수 데이터 초기화
      }
    });

    // WidgetsBindingObserver를 추가하여 앱의 생명주기 변화 감지
    WidgetsBinding.instance.addObserver(this); // 생명주기 옵저버 등록

    // 상태표시줄 색상을 안드로이드와 ios 버전에 맞춰서 변경하는데 사용되는 함수-앱 실행 생명주기에 맞춰서 변경
    updateStatusBar();

    // 네트워크 상태 체크 시작
    _networkChecker = NetworkChecker(context);
    _networkChecker?.checkNetworkStatus();

    // 스크롤 리스너 추가
    paedingDetailProductScreenPointScrollController.addListener(_onScroll);
  }

  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 끝 (앱 실행 생명주기 관련 함수)

  // didChangeAppLifecycleState 함수 관련 구현 내용 시작
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      updateStatusBar();
    }
  }

  // didChangeAppLifecycleState 함수 관련 구현 내용 끝

  // 화면 스크롤 움직임에 따른 이미지 데이터 불러오도록 연결하는 로직 함수
  void _onScroll() {
    bool showFullImage = ref.read(showFullImageProvider);
    if (!showFullImage) return;

    // 현재 스크롤 위치가 스크롤 가능한 최대 위치에 도달했는지 확인함
    if (paedingDetailProductScreenPointScrollController.position.pixels ==
        paedingDetailProductScreenPointScrollController
            .position.maxScrollExtent) {
      // 스크롤이 끝에 도달했을 때 실행되는 추가 이미지 로드 함수 호출
      ref.read(imagesProvider(widget.fullPath).notifier).loadMoreImages();
    }
  }

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void dispose() {
    // WidgetsBinding 인스턴스에서 이 객체를 옵저버 목록에서 제거함.
    // 앱 생명주기 이벤트를 더 이상 수신하지 않겠다는 의도임.
    WidgetsBinding.instance.removeObserver(this);

    // 사용자 인증 상태 감지 구독 해제함.
    authStateChangesSubscription?.cancel();

    paedingDetailProductScreenPointScrollController
        .dispose(); // ScrollController 해제
    pageController.dispose(); // PageController 해제

    // 네트워크 체크 해제
    _networkChecker?.dispose();

    // 스크롤 리스너 제거
    paedingDetailProductScreenPointScrollController.removeListener(_onScroll);

    super.dispose(); // 위젯의 기본 정리 작업 수행
  }

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 끝 (앱 실행 생명주기 관련 함수)
  // ------ 앱 실행 생명주기 관리 관련 함수 끝

  // ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 시작
  @override
  Widget build(BuildContext context) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // AppBar 관련 수치 동적 적용
    final double productDtAppBarTitleWidth =
        screenSize.width * (240 / referenceWidth);
    final double productDtAppBarTitleHeight =
        screenSize.height * (22 / referenceHeight);
    final double productDtAppBarTitleX =
        screenSize.height * (70 / referenceHeight);
    final double productDtAppBarTitleY =
        screenSize.height * (11 / referenceHeight);

    // 이전화면으로 이동 아이콘 관련 수치 동적 적용
    final double productDtChevronIconWidth =
        screenSize.width * (24 / referenceWidth);
    final double productDtChevronIconHeight =
        screenSize.height * (24 / referenceHeight);
    final double productDtChevronIconX =
        screenSize.width * (10 / referenceWidth);
    final double productDtChevronIconY =
        screenSize.height * (8 / referenceHeight);

    //  업데이트 요청 목록 버튼 수치 (Case 4)
    final double productDtCartlistBtnWidth =
        screenSize.width * (50 / referenceWidth);
    final double productDtCartlistBtnHeight =
        screenSize.height * (40 / referenceHeight);
    final double productDtCartlistBtnX =
        screenSize.width * (1 / referenceWidth);
    final double productDtCartlistBtnY =
        screenSize.height * (8 / referenceHeight);

    // 홈 버튼 수치 (Case 4)
    final double productDtHomeBtnWidth =
        screenSize.width * (30 / referenceWidth);
    final double productDtHomeBtnHeight =
        screenSize.height * (40 / referenceHeight);
    final double productDtHomeBtnX = screenSize.width * (1 / referenceWidth);
    final double productDtHomeBtnY = screenSize.height * (8 / referenceHeight);

    // 찜 목록 버튼 수치 (Case 4)
    final double productDtWishlistBtnWidth =
        screenSize.width * (40 / referenceWidth);
    final double productDtWishlistBtnHeight =
        screenSize.height * (40 / referenceHeight);
    final double productDtWishlistBtnX =
        screenSize.width * (1 / referenceWidth);
    final double productDtWishlistBtnY =
        screenSize.height * (8 / referenceHeight);

    // 에러 관련 텍스트 수치
    final double errorTextFontSize1 =
        screenSize.height * (14 / referenceHeight);
    final double errorTextFontSize2 =
        screenSize.height * (12 / referenceHeight);
    final double errorTextHeight = screenSize.height * (600 / referenceHeight);

    // Firestore 데이터 제공자를 통해 특정 문서 ID(docId)의 상품 데이터를 구독.
    final productContent =
        ref.watch(aatPaedingDetailProdFirestoreDataProvider(widget.fullPath));
    final productReviews = ref.watch(productReviewListNotifierProvider(widget.fullPath)); // 리뷰 데이터를 가져옴

    print(
        "AatPaedingDetailProductScreen: 제품 경로에 대한 화면 로드 중: ${widget.fullPath}"); // 디버깅 메시지 추가

    // ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 시작
    // ------ 기존 buildCommonAppBar 위젯 내용과 동일하며,
    // 플러터 기본 SliverAppBar 위젯을 활용하여 앱 바의 상태 동적 UI 구현에 수월한 부분을 정의해서 해당 위젯을 바로 다른 화면에 구현하여
    // 기본 SliverAppBar의 드로워화면 토글 옵션을 삭제하는 등의 작업이 필요없는 방식-현재는 이슈가 있어 사용 안함..
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: paedingDetailProductScreenPointScrollController,
            // 스크롤 컨트롤러 연결
            slivers: <Widget>[
              // SliverAppBar를 사용하여 기존 AppBar 기능을 재사용
              SliverAppBar(
                // 'automaticallyImplyLeading: false'를 추가하여 SliverAppBar가 자동으로 leading 버튼을 생성하지 않도록 설정함.
                automaticallyImplyLeading: false,
                floating: true,
                // 스크롤 시 SliverAppBar가 빠르게 나타남.
                pinned: true,
                // 스크롤 다운시 AppBar가 상단에 고정됨.
                expandedHeight: 0.0,
                // 확장된 높이를 0으로 설정하여 확장 기능 제거
                // 확장 높이 설정
                // FlexibleSpaceBar를 사용하여 AppBar 부분의 확장 및 축소 효과 제공함.
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  // 앱 바 부분을 고정시키는 옵션->앱 바가 스크롤에 의해 사라지고, 그 자리에 상단 탭 바가 있는 bottom이 상단에 고정되도록 하는 기능
                  background: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: BLACK_COLOR, width: 1.0), // 하단 테두리 추가
                      ),
                    ),
                    child: buildCommonAppBar(
                      // 공통 AppBar 빌드
                      context: context,
                      // 현재 context 전달
                      ref: ref,
                      // 참조(ref) 전달
                      title: widget.title,
                      // AppBar의 제목을 '패딩 상세'로 설정
                      fontFamily: 'NanumGothic',
                      leadingType: LeadingType.back,
                      // AppBar의 리딩 타입을 뒤로가기 버튼으로 설정
                      buttonCase: 4,
                      // 버튼 케이스를 4로 설정
                      appBarTitleWidth: productDtAppBarTitleWidth,
                      appBarTitleHeight: productDtAppBarTitleHeight,
                      appBarTitleX: productDtAppBarTitleX,
                      appBarTitleY: productDtAppBarTitleY,
                      chevronIconWidth: productDtChevronIconWidth,
                      chevronIconHeight: productDtChevronIconHeight,
                      chevronIconX: productDtChevronIconX,
                      chevronIconY: productDtChevronIconY,
                      cartlistBtnWidth: productDtCartlistBtnWidth,
                      cartlistBtnHeight: productDtCartlistBtnHeight,
                      cartlistBtnX: productDtCartlistBtnX,
                      cartlistBtnY: productDtCartlistBtnY,
                      homeBtnWidth: productDtHomeBtnWidth,
                      homeBtnHeight: productDtHomeBtnHeight,
                      homeBtnX: productDtHomeBtnX,
                      homeBtnY: productDtHomeBtnY,
                      wishlistBtnWidth: productDtWishlistBtnWidth,
                      wishlistBtnHeight: productDtWishlistBtnHeight,
                      wishlistBtnX: productDtWishlistBtnX,
                      wishlistBtnY: productDtWishlistBtnY,
                    ),
                  ),
                ),
                leading: null,
                // 좌측 상단의 메뉴 버튼 등을 제거함.
                // iOS에서는 AppBar의 배경색을 사용
                // SliverAppBar 배경색 설정  // AppBar 배경을 투명하게 설정 -> 투명하게 해서 스크롤 내리면 다른 컨텐츠가 비쳐서 보이는 것!!
                // backgroundColor: BUTTON_COLOR,
              ),
              // 실제 컨텐츠를 나타내는 슬리버 리스트
              // 슬리버 패딩을 추가하여 위젯 간 간격 조정함.
              SliverPadding(
                padding: EdgeInsets.zero,
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Column(
                        children: [
                          productContent.when(
                            data: (product) {
                              print(
                                  "PaedingDetailProductScreen: 제품 데이터 로드 완료"); // 디버깅 메시지 추가
                              return Column(
                                children: [
                                  buildProdDetailScreenContents(
                                      context, ref, product, pageController),
                                  // ProductDetailScreenTabs를 사용하여 탭을 생성
                                  ProductDetailScreenTabs(
                                    productInfoContent: ProductInfoContents(
                                      fullPath: widget.fullPath,
                                    ),
                                    reviewsContent: productReviews, // 페이징 처리된 리뷰 리스트
                                    // Firestore에서 가져온 리뷰 데이터를 전달
                                    inquiryContent:
                                    ProductInquiryContents(),
                                  ),
                                  // 로딩 인디케이터를 표시 (로그아웃 후 재로그인 시, 로딩 표시가 안나오도록 추가 설정)
                                  if (ref
                                          .watch(
                                              imagesProvider(widget.fullPath))
                                          .isEmpty &&
                                      ref
                                          .watch(imagesProvider(widget.fullPath)
                                              .notifier)
                                          .isLoadingMore)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: buildCommonLoadingIndicator()),
                                    ),
                                ],
                              );
                            },
                            loading: () => buildCommonLoadingIndicator(),
                            // 공통 로딩 인디케이터 호출
                            error: (error, stack) => Container(
                              // 에러 상태에서 중앙 배치
                              height: errorTextHeight, // 전체 화면 높이 설정
                              alignment: Alignment.center, // 중앙 정렬
                              child: buildCommonErrorIndicator(
                                message: '에러가 발생했으니, 앱을 재실행해주세요.',
                                // 첫 번째 메시지 설정
                                secondMessage: '에러가 반복될 시, \'문의하기\'에서 문의해주세요.',
                                // 두 번째 메시지 설정
                                fontSize1: errorTextFontSize1,
                                // 폰트1 크기 설정
                                fontSize2: errorTextFontSize2,
                                // 폰트2 크기 설정
                                color: BLACK_COLOR,
                                // 색상 설정
                                showSecondMessage: true, // 두 번째 메시지를 표시하도록 설정
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: 1, // 하나의 큰 Column이 모든 카드뷰를 포함하고 있기 때문에 1로 설정
                  ),
                ),
              ),
            ],
          ),
          // buildTopButton 함수는 주어진 context와 paedingDetailProductScreenPointScrollController를 사용하여
          // 화면 상단으로 스크롤하기 위한 버튼 생성 위젯이며, common_body_parts_layout.dart 내에 있는 곳에서 재사용하여 구현한 부분
          buildTopButton(
              context, paedingDetailProductScreenPointScrollController),
        ],
      ),
      // 하단 탭 바 - 2번 케이스인 '장바구니' 버튼과 '바로 발주' 버튼이 UI로 구현됨.
      bottomNavigationBar: productContent.when(
        data: (product) {
          return buildCommonBottomNavigationBar(
              ref.watch(tabIndexProvider), ref, context, 5, 2,
              product: product,
              scrollController:
                  paedingDetailProductScreenPointScrollController);
        },
        loading: () => SizedBox.shrink(), // 로딩 중일 때는 빈 공간으로 처리
        error: (error, _) => SizedBox.shrink(), // 에러가 발생했을 때는 빈 공간으로 처리
      ),
    );
    // ------ 화면구성 끝
  }
// ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 끝
// ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 끝
}
// _AatPaedingDetailProductScreenState 클래스 끝
