import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod를 사용한 상태 관리를 위한 import
import '../../../common/provider/common_state_provider.dart'; // 공통 상태 관리 파일
import '../../../common/layout/common_parts_layout.dart'; // 공통 UI 컴포넌트 파일
// 아래는 각 카테고리별 상세 페이지를 위한 레이아웃 파일들
import '../../common/const/colors.dart';
import '../../product/view/sub_main_screen/autumn_sub_main_screen.dart';
import '../../product/view/sub_main_screen/best_sub_main_screen.dart';
import '../../product/view/sub_main_screen/new_sub_main_screen.dart';
import '../../product/view/sub_main_screen/sale_sub_main_screen.dart';
import '../../product/view/sub_main_screen/spring_sub_main_screen.dart';
import '../../product/view/sub_main_screen/summer_sub_main_screen.dart';
import '../../product/view/sub_main_screen/winter_sub_main_screen.dart';
import '../provider/home_state_provider.dart';

// 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 시작
// // GlobalKey 선언
// GlobalKey newProductsKey = GlobalKey();
// GlobalKey bestProductsKey = GlobalKey();
// GlobalKey discountProductsKey = GlobalKey();
// GlobalKey springProductsKey = GlobalKey();
// GlobalKey summerProductsKey = GlobalKey();
// GlobalKey autumnProductsKey = GlobalKey();
// GlobalKey winterProductsKey = GlobalKey();
// 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 끝


// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용 권장
// GlobalKey 사용 시 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// ShirtMainScreen 클래스는 ConsumerWidget 상속, Riverpod를 통한 상태 관리 지원
class HomeMainScreen extends ConsumerStatefulWidget {
  const HomeMainScreen({Key? key}) : super(key: key);
  @override
  _HomeMainScreenState createState() => _HomeMainScreenState();
}

// _ShirtMainScreenState 클래스 시작
// _ShirtMainScreenState 클래스는 ShirtMainScreen 위젯의 상태를 관리함.
// WidgetsBindingObserver 믹스인을 통해 앱 생명주기 상태 변화를 감시함.
class _HomeMainScreenState extends ConsumerState<HomeMainScreen> with WidgetsBindingObserver {

  // 큰 배너를 위한 페이지 컨트롤러
  late PageController _largeBannerPageController;
  // 큰 배너를 자동 스크롤하는 클래스
  late BannerAutoScrollClass _largeBannerAutoScroll;

  // 첫 번째 작은 배너를 위한 페이지 컨트롤러
  late PageController _small1BannerPageController;
  // 첫 번째 작은 배너를 자동 스크롤하는 클래스
  late BannerAutoScrollClass _small1BannerAutoScroll;

  // 두 번째 작은 배너를 위한 페이지 컨트롤러
  late PageController _small2BannerPageController;
  // 두 번째 작은 배너를 자동 스크롤하는 클래스
  late BannerAutoScrollClass _small2BannerAutoScroll;

  // 세 번째 작은 배너를 위한 페이지 컨트롤러
  late PageController _small3BannerPageController;
  // 세 번째 작은 배너를 자동 스크롤하는 클래스
  late BannerAutoScrollClass _small3BannerAutoScroll;

  // 배너 이미지의 총 개수를 저장하는 변수
  int bannerImageCount = 3;

  // 배너 클릭 시 이동할 URL 리스트를 정의함.
  // 각 배너 클릭 시 연결될 웹사이트 주소를 리스트로 관리함.
  // 큰 배너 클릭 시 이동할 URL 목록
  final List<String> largeBannerLinks = [
    'https://www.naver.com', // 첫 번째 배너 클릭 시 네이버로 이동
    'https://www.youtube.com', // 두 번째 배너 클릭 시 유튜브로 이동
  ];

  // 첫 번째 작은 배너 클릭 시 이동할 URL 목록
  final List<String> small1BannerLinks = [
    'https://www.coupang.com', // 첫 번째 배너 클릭 시 쿠팡으로 이동
    'https://www.temu.com/kr', // 두 번째 배너 클릭 시 테무로 이동
  ];

  // 두 번째 작은 배너 클릭 시 이동할 URL 목록
  final List<String> small2BannerLinks = [
    'https://ko.aliexpress.com/', // 첫 번째 배너 클릭 시 알리익스프레스로 이동
    'https://www.yanolja.com/', // 두 번째 배너 클릭 시 야놀자로 이동
  ];

  // 세 번째 작은 배너 클릭 시 이동할 URL 목록
  final List<String> small3BannerLinks = [
    'https://www.kakaocorp.com/', // 첫 번째 배너 클릭 시 카카오로 이동
    'https://www.netflix.com/kr', // 두 번째 배너 클릭 시 넷플릭스로 이동
  ];

  // 사용자 인증 상태 변경을 감지하는 스트림 구독 객체임.
  // 이를 통해 사용자 로그인 또는 로그아웃 상태 변경을 실시간으로 감지하고 처리할 수 있음.
  StreamSubscription<User?>? authStateChangesSubscription;

  // late ScrollController scrollController; // ScrollController 추가

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // 큰 배너에 대한 PageController 및 AutoScroll 초기화
    // 'homeLargeBannerPageProvider'에서 초기 페이지 인덱스를 읽어옴
    _largeBannerPageController = PageController(initialPage: ref.read(homeLargeBannerPageProvider));

    // // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 시작
    // scrollController = ScrollController(); // ScrollController 인스턴스 초기화
    // // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 끝

    // 큰 배너를 자동으로 스크롤하는 기능 초기화
    _largeBannerAutoScroll = BannerAutoScrollClass(
      pageController: _largeBannerPageController,
      currentPageProvider: homeLargeBannerPageProvider,
      itemCount: bannerImageCount, // 총 배너 이미지 개수 전달
    );

    // 작은 배너1에 대한 PageController 및 AutoScroll 초기화
    // 'homeSmall1BannerPageProvider'에서 초기 페이지 인덱스를 읽어옴
    _small1BannerPageController = PageController(initialPage: ref.read(homeSmall1BannerPageProvider));

    // 작은 배너1을 자동으로 스크롤하는 기능 초기화
    _small1BannerAutoScroll = BannerAutoScrollClass(
      pageController: _small1BannerPageController,
      currentPageProvider: homeSmall1BannerPageProvider,
      itemCount: bannerImageCount, // 총 배너 이미지 개수 전달
    );

    // 작은 배너2에 대한 PageController 및 AutoScroll 초기화
    // 'homeSmall2BannerPageProvider'에서 초기 페이지 인덱스를 읽어옴
    _small2BannerPageController = PageController(initialPage: ref.read(homeSmall2BannerPageProvider));

    // 작은 배너2를 자동으로 스크롤하는 기능 초기화
    _small2BannerAutoScroll = BannerAutoScrollClass(
      pageController: _small2BannerPageController,
      currentPageProvider: homeSmall2BannerPageProvider,
      itemCount: bannerImageCount, // 총 배너 이미지 개수 전달
    );

    // 작은 배너3에 대한 PageController 및 AutoScroll 초기화
    // 'homeSmall3BannerPageProvider'에서 초기 페이지 인덱스를 읽어옴
    _small3BannerPageController = PageController(initialPage: ref.read(homeSmall3BannerPageProvider));

    // 작은 배너3을 자동으로 스크롤하는 기능 초기화
    _small3BannerAutoScroll = BannerAutoScrollClass(
      pageController: _small3BannerPageController,
      currentPageProvider: homeSmall3BannerPageProvider,
      itemCount: bannerImageCount, // 총 배너 이미지 개수 전달
    );


    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        ref.read(homeLargeBannerPageProvider.notifier).state = 0;
        ref.read(homeSmall1BannerPageProvider.notifier).state = 0;
        ref.read(homeSmall2BannerPageProvider.notifier).state = 0;
        ref.read(homeSmall3BannerPageProvider.notifier).state = 0;
      }
    });

    // WidgetsBindingObserver를 추가하여 앱의 생명주기 변화 감지
    WidgetsBinding.instance.addObserver(this); // 생명주기 옵저버 등록

    // 배너 데이터 로드가 완료된 후 자동 스크롤 시작
    Future.delayed(Duration.zero, () {
      _largeBannerAutoScroll.startAutoScroll();
      _small1BannerAutoScroll.startAutoScroll();
      _small2BannerAutoScroll.startAutoScroll();
      _small3BannerAutoScroll.startAutoScroll();
    });

  }
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 끝 (앱 실행 생명주기 관련 함수)

  // ------ 페이지 뷰 자동 스크롤 타이머 함수인 startAutoScrollTimer() 시작 및 정지 관린 함수인
  // didChangeAppLifecycleState 함수 관련 구현 내용 시작
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 앱이 다시 활성화되면(포어그라운드로 올 때), 배너의 자동 스크롤을 재시작
    if (state == AppLifecycleState.resumed) {
      _largeBannerAutoScroll.startAutoScroll();
      _small1BannerAutoScroll.startAutoScroll();
      _small2BannerAutoScroll.startAutoScroll();
      _small3BannerAutoScroll.startAutoScroll();
    // 앱이 백그라운드로 이동할 때, 배너의 자동 스크롤을 중지
    } else if (state == AppLifecycleState.paused) {
      _largeBannerAutoScroll.stopAutoScroll();
      _small1BannerAutoScroll.stopAutoScroll();
      _small2BannerAutoScroll.stopAutoScroll();
      _small3BannerAutoScroll.stopAutoScroll();
    }
  }
  // ------ 페이지 뷰 자동 스크롤 타이머 함수인 startAutoScrollTimer() 시작 및 정지 관린 함수인
  // didChangeAppLifecycleState 함수 관련 구현 내용 끝

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void dispose() {
    // WidgetsBinding 인스턴스에서 이 객체를 옵저버 목록에서 제거함.
    // 앱 생명주기 이벤트를 더 이상 수신하지 않겠다는 의도임.
    WidgetsBinding.instance.removeObserver(this);

    // 각 배너 관련 리소스 해제
    _largeBannerPageController.dispose();
    _largeBannerAutoScroll.stopAutoScroll();

    _small1BannerPageController.dispose();
    _small1BannerAutoScroll.stopAutoScroll();

    _small2BannerPageController.dispose();
    _small2BannerAutoScroll.stopAutoScroll();

    _small3BannerPageController.dispose();
    _small3BannerAutoScroll.stopAutoScroll();

    // 사용자 인증 상태 감지 구독 해제함.
    authStateChangesSubscription?.cancel();

    // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 시작
    // scrollController.dispose(); // ScrollController 해제
    // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 끝

    super.dispose(); // 위젯의 기본 정리 작업 수행
  }
  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 끝 (앱 실행 생명주기 관련 함수)
  // ------ 앱 실행 생명주기 관리 관련 함수 끝

  // ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 시작
  @override
  Widget build(BuildContext context) {

// 상태표시줄의 색상을 변경하고자 할 때,
// Scaffold가 완전히 빌드된 후에 적용되도록 설정함.
// 이는 초기 UI 렌더링이 완료된 직후에 추가적인 설정을 적용하기 위해 사용됨.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // SystemChrome.setSystemUIOverlayStyle을 사용하여 시스템 UI의 스타일을 변경함.
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: BUTTON_COLOR, // 상태표시줄의 색상을 여기서 정의한 BUTTON_COLOR로 설정함.
      ));
    });

    // ------ common_parts_layout.dart 내 buildTopBarList, onTopBarTap 재사용하여 TopBar 구현 내용 시작
    // 탭을 탭했을 때 호출될 함수
    // 상단 탭 바를 구성하고 탭 선택 시 동작을 정의하는 함수
    // (common_parts.dart의 onTopBarTap 함수를 불러와 생성자를 만든 후 사용하는 개념이라 void인 함수는 함수명을 그대로 사용해야 함)
    void onTopBarTap(int index) {
      // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 시작
      // GlobalKey? selectedKey;
      // switch (index) {
      //   case 0:
      //     selectedKey = newProductsKey;
      //     break;
      //   case 1:
      //     selectedKey = bestProductsKey;
      //     break;
      //   case 2:
      //     selectedKey = discountProductsKey;
      //     break;
      //   case 3:
      //     selectedKey = springProductsKey;
      //     break;
      //   case 4:
      //     selectedKey = summerProductsKey;
      //     break;
      //   case 5:
      //     selectedKey = autumnProductsKey;
      //     break;
      //   case 6:
      //     selectedKey = winterProductsKey;
      //     break;
      // }
      //
      // if (selectedKey != null) {
      //   // Scrollable.ensureVisible을 호출하여 해당 섹션으로 스크롤합니다.
      //   Scrollable.ensureVisible(selectedKey.currentContext!, duration: Duration(milliseconds: 500));
      // }
      // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 끝

    }
    // 상단 탭 바를 구성하는 리스트 뷰를 가져오는 위젯
    // (common_parts.dart의 buildTopBarList 재사용 후 topBarList 위젯으로 재정의)
    Widget topBarList = buildTopBarList(context, onTopBarTap);
    // ------ common_parts_layout.dart 내 buildTopBarList, onTopBarTap 재사용하여 TopBar 구현 내용 끝

    // ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 시작
    // ------ 기존 buildCommonAppBar 위젯 내용과 동일하며,
    // 플러터 기본 SliverAppBar 위젯을 활용하여 앱 바의 상태 동적 UI 구현에 수월한 부분을 정의해서 해당 위젯을 바로 다른 화면에 구현하여
    // 기본 SliverAppBar의 드로워화면 토글 옵션을 삭제하는 등의 작업이 필요없는 방식-현재는 이슈가 있어 사용 안함..
    // 향후 이슈해결하여 해당 앱 바로 변경작업 진행할 예정!!
    // return Scaffold(
    //   body: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 4.0),
    //     child: CustomScrollView(
    //       slivers: <Widget>[
    //         // SliverAppBar를 사용하여 스크롤 시 동적으로 사라지거나 고정되는 헤더를 구현
    //         buildCommonSliverAppBar(
    //           context: context,
    //           title: '홈',
    //           pageBackButton: false, // 뒤로 가기 버튼 비활성화
    //         ),
    // //         // 상단 탭 바 구현, 스크롤 시 상단에 고정되도록 SliverPersistentHeader 사용
    // //         SliverPersistentHeader(
    // //           delegate: _SliverAppBarDelegate(
    // //             minHeight: 60.0, // 최소 높이
    // //             maxHeight: 60.0, // 최대 높이
    // //             child: buildTopBarList(context, onTopBarTap), // 상단 탭 바 리스트
    // //           ),
    // //           pinned: true, // 항상 고정
    // //         ),
    //         // 스크롤되는 컨텐츠 영역
    //         SliverList(
    //           delegate: SliverChildBuilderDelegate(
    //                 (BuildContext context, int index)  {
    //                       return Column(
    //                         children: [
    //                           SizedBox(height: 15), // 높이 20으로 간격 설정
    //                           // 큰 배너 섹션을 카드뷰로 구성
    //                           CommonCardView(
    //                             content: SizedBox(
    //                               // buildBannerPageViewSection 내용의 높이가 200으로 구현함.
    //                               height: 200,
    //                               // 카드뷰 내용으로 buildBannerPageViewSection 재사용하여 구현함.
    //                               child: buildLargeBannerPageViewSection(
    //                                   context, ref, homeLargeBannerPageProvider,
    //                                   _largeBannerPageController, _largeBannerAutoScroll,
    //                                   largeBannerLinks),
    //                             ),
    //                             backgroundColor: LIGHT_PURPLE_COLOR,
    //                             // 카드뷰 배경 색상 : LIGHT_PURPLE_COLOR
    //                             elevation: 4,
    //                             // 카드뷰 그림자 깊이
    //                             padding: const EdgeInsets.fromLTRB(
    //                                 8.0, 8.0, 8.0, 8.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
    //                           ),
    //                           SizedBox(height: 10), // 높이 10으로 간격 설정
    //                           // 카드뷰 클래스 재사용으로 MidCategoryButtonList 내용이 있는 카드뷰 구현
    //                           // 중간 카테고리 버튼 리스트를 카드뷰로 구성
    //                           CommonCardView(
    //                             content: MidCategoryButtonList(
    //                                 onCategoryTap: onMidCategoryTap),
    //                             // 카드뷰 내용으로 MidCategoryButtonList 재사용하여 구현
    //                             backgroundColor: LIGHT_PURPLE_COLOR,
    //                             // 카드뷰 배경 색상 : LIGHT_PURPLE_COLOR
    //                             elevation: 4,
    //                             // 카드뷰 그림자 깊이
    //                             padding: const EdgeInsets.fromLTRB(
    //                                 8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
    //                           ),
    //                           SizedBox(height: 15), // 높이 15로 간격 설정
    //                           // 첫 번째 작은 배너 섹션
    //                           CommonCardView(
    //                             content: SizedBox(
    //                               // buildBannerPageViewSection 내용의 높이가 200으로 구현함.
    //                               height: 60,
    //                               // 카드뷰 내용으로 buildBannerPageViewSection 재사용하여 구현함.
    //                               child: buildSmall1BannerPageViewSection(
    //                                   context, ref, homeSmall1BannerPageProvider,
    //                                   _small1BannerPageController,
    //                                   _small1BannerAutoScroll, small1BannerLinks),
    //                             ),
    //                             backgroundColor: LIGHT_SKY_BLUE_COLOR,
    //                             // 카드뷰 배경 색상 : LIGHT_PURPLE_COLOR
    //                             elevation: 4,
    //                             // 카드뷰 그림자 깊이
    //                             padding: const EdgeInsets.fromLTRB(
    //                                 8.0, 8.0, 8.0, 8.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
    //                           ),
    //                           SizedBox(height: 15), // 높이 15로 간격 설정
    //                           // common_parts_layout.dart에 구현된 신상 관련 옷 상품 부분
    //                           // 신상품 섹션
    //                           CommonCardView(
    //                             content: buildNewProductsSection(ref, context),
    //                             // 카드뷰 내용으로 buildNewProductsSection 재사용하여 구현
    //                             backgroundColor: BEIGE_COLOR,
    //                             // 카드뷰 배경 색상 : BEIGE_COLOR
    //                             elevation: 4,
    //                             // 카드뷰 그림자 깊이
    //                             padding: const EdgeInsets.fromLTRB(
    //                                 8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
    //                           ),
    //                           SizedBox(height: 10), // 높이 10으로 간격 설정
    //                           // common_parts_layout.dart에 구현된 최고 관련 옷 상품 부분
    //                           // 베스트 제품 섹션
    //                           CommonCardView(
    //                             content: buildBestProductsSection(ref, context),
    //                             // 카드뷰 내용으로 buildBestProductsSection 재사용하여 구현
    //                             backgroundColor: LIGHT_YELLOW_COLOR,
    //                             // 카드뷰 배경 색상 : LIGHT_YELLOW_COLOR
    //                             elevation: 4,
    //                             // 카드뷰 그림자 깊이
    //                             padding: const EdgeInsets.fromLTRB(
    //                                 8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
    //                           ),
    //                           SizedBox(height: 10), // 높이 10으로 간격 설정
    //                           // common_parts_layout.dart에 구현된 할인 관련 옷 상품 부분
    //                           // 할인 제품 섹션
    //                           CommonCardView(
    //                             content: buildDiscountProductsSection(ref, context),
    //                             // 카드뷰 내용으로 buildDiscountProductsSection 재사용하여 구현
    //                             backgroundColor: BEIGE_COLOR,
    //                             // 카드뷰 배경 색상 : BEIGE_COLOR
    //                             elevation: 4,
    //                             // 카드뷰 그림자 깊이
    //                             padding: const EdgeInsets.fromLTRB(
    //                                 8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
    //                           ),
    //                           SizedBox(height: 15), // 높이 15로 간격 설정
    //                           // 두 번째 작은 배너 섹션
    //                           CommonCardView(
    //                             content: SizedBox(
    //                               // buildBannerPageViewSection 내용의 높이가 200으로 구현함.
    //                               height: 60,
    //                               // 카드뷰 내용으로 buildBannerPageViewSection 재사용하여 구현함.
    //                               child: buildSmall2BannerPageViewSection(
    //                                   context, ref, homeSmall2BannerPageProvider,
    //                                   _small2BannerPageController,
    //                                   _small2BannerAutoScroll, small2BannerLinks),
    //                             ),
    //                             backgroundColor: LIGHT_SKY_BLUE_COLOR,
    //                             // 카드뷰 배경 색상 : LIGHT_PURPLE_COLOR
    //                             elevation: 4,
    //                             // 카드뷰 그림자 깊이
    //                             padding: const EdgeInsets.fromLTRB(
    //                                 8.0, 8.0, 8.0, 8.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
    //                           ),
    //                           SizedBox(height: 15), // 높이 15로 간격 설정
    //                           // 계절별 제품 섹션들을 순차적으로 추가 (봄, 여름, 가을, 겨울)
    //                           // common_parts_layout.dart에 구현된 봄 관련 옷 상품 부분
    //                           CommonCardView(
    //                             content: buildSpringProductsSection(ref, context),
    //                             // 카드뷰 내용으로 buildSpringProductsSection 재사용하여 구현
    //                             backgroundColor: LIGHT_YELLOW_COLOR,
    //                             // 카드뷰 배경 색상 : LIGHT_YELLOW_COLOR
    //                             elevation: 4,
    //                             // 카드뷰 그림자 깊이
    //                             padding: const EdgeInsets.fromLTRB(
    //                                 8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
    //                           ),
    //                           SizedBox(height: 10), // 높이 10으로 간격 설정
    //                           // common_parts_layout.dart에 구현된 여름 관련 옷 상품 부분
    //                           CommonCardView(
    //                             content: buildSummerProductsSection(ref, context),
    //                             // 카드뷰 내용으로 buildSummerProductsSection 재사용하여 구현
    //                             backgroundColor: BEIGE_COLOR,
    //                             // 카드뷰 배경 색상 : BEIGE_COLOR
    //                             elevation: 4,
    //                             // 카드뷰 그림자 깊이
    //                             padding: const EdgeInsets.fromLTRB(
    //                                 8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
    //                           ),
    //                           SizedBox(height: 15), // 높이 15로 간격 설정
    //                           CommonCardView(
    //                             content: SizedBox(
    //                               // buildBannerPageViewSection 내용의 높이가 200으로 구현함.
    //                               height: 60,
    //                               // 카드뷰 내용으로 buildBannerPageViewSection 재사용하여 구현함.
    //                               child: buildSmall3BannerPageViewSection(
    //                                   context, ref, homeSmall3BannerPageProvider,
    //                                   _small3BannerPageController,
    //                                   _small3BannerAutoScroll, small3BannerLinks),
    //                             ),
    //                             backgroundColor: LIGHT_SKY_BLUE_COLOR,
    //                             // 카드뷰 배경 색상 : LIGHT_PURPLE_COLOR
    //                             elevation: 4,
    //                             // 카드뷰 그림자 깊이
    //                             padding: const EdgeInsets.fromLTRB(
    //                                 8.0, 8.0, 8.0, 8.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
    //                           ),
    //                           SizedBox(height: 15), // 높이 15로 간격 설정
    //                           // common_parts_layout.dart에 구현된 가을 관련 옷 상품 부분
    //                           CommonCardView(
    //                             content: buildAutumnProductsSection(ref, context),
    //                             // 카드뷰 내용으로 buildAutumnProductsSection 재사용하여 구현
    //                             backgroundColor: LIGHT_YELLOW_COLOR,
    //                             // 카드뷰 배경 색상 : LIGHT_YELLOW_COLOR
    //                             elevation: 4,
    //                             // 카드뷰 그림자 깊이
    //                             padding: const EdgeInsets.fromLTRB(
    //                                 8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
    //                           ),
    //                           SizedBox(height: 10), // 높이 10으로 간격 설정
    //                           // common_parts_layout.dart에 구현된 겨울 관련 옷 상품 부분
    //                           CommonCardView(
    //                             content: buildWinterProductsSection(ref, context),
    //                             // 카드뷰 내용으로 buildWinterProductsSection 재사용하여 구현
    //                             backgroundColor: BEIGE_COLOR,
    //                             // 카드뷰 배경 색상 : BEIGE_COLOR
    //                             elevation: 4,
    //                             // 카드뷰 그림자 깊이
    //                             padding: const EdgeInsets.fromLTRB(
    //                                 8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
    //                           ),
    //                         ],
    //                       );
    //                     },
    //                     childCount: 1, // 하나의 큰 Column이 모든 카드뷰를 포함하고 있기 때문에 1로 설정
    //                   ),
    //                 ),
    //              ],
    //            ),
    //          ),
    //          bottomNavigationBar: buildCommonBottomNavigationBar(
    //           ref.watch(tabIndexProvider), ref, context), // 공통으로 사용되는 하단 네비게이션 바를 가져옴.
    //          drawer: buildCommonDrawer(context), // 드로어 메뉴를 추가함.
    //       );
    //     }
    // ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 끝

    return Scaffold(
      body: CustomScrollView(
          slivers: <Widget>[
            // SliverAppBar를 사용하여 기존 AppBar 기능을 재사용
            SliverAppBar(
              // 'automaticallyImplyLeading: false'를 추가하여 SliverAppBar가 자동으로 leading 버튼을 생성하지 않도록 설정함.
              automaticallyImplyLeading: false,
              floating: true, // 스크롤 시 SliverAppBar가 빠르게 나타남.
              pinned: true, // 스크롤 다운시 AppBar가 상단에 고정됨.
              expandedHeight: 120.0, // 확장 높이 설정
              // FlexibleSpaceBar를 사용하여 AppBar 부분의 확장 및 축소 효과 제공함.
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin, // 앱 바 부분을 고정시키는 옵션->앱 바가 스크롤에 의해 사라지고, 그 자리에 상단 탭 바가 있는 bottom이 상단에 고정되도록 하는 기능
                background: buildCommonAppBar(
                  context: context,
                  title: '홈',
                  pageBackButton: false,  // 페이지 뒤로 가기 버튼 비활성화
                ),
              ),
              leading: null, // 좌측 상단의 메뉴 버튼 등을 제거함.
              // backgroundColor: Colors.transparent,  // AppBar 배경을 투명하게 설정
              backgroundColor: BUTTON_COLOR, // SliverAppBar 배경색 설정  // AppBar 배경을 투명하게 설정 -> 투명하게 해서 스크롤 내리면 다른 컨텐츠가 비쳐서 보이는 것!!
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(60.0), // AppBar 하단에 PreferredSize를 사용하여 탭 바의 높이 지정
                child: Container(
                  color: BUTTON_COLOR, // 상단 탭 바 색상 설정
                  child: topBarList, // 탭 바에 들어갈 위젯 배열
                ),
              ),
            ),
          // 실제 컨텐츠를 나타내는 슬리버 리스트
          // 슬리버 패딩을 추가하여 위젯 간 간격 조정함.
          SliverPadding(
            padding: EdgeInsets.only(top: 5),
            // SliverList를 사용하여 목록 아이템을 동적으로 생성함.
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    // 각 항목의 좌우 간격을 4.0으로 설정함.
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      children: [
                      SizedBox(height: 15), // 높이 20으로 간격 설정
                      // 큰 배너 섹션을 카드뷰로 구성
                      CommonCardView(
                        content: SizedBox(
                          // buildBannerPageViewSection 내용의 높이가 200으로 구현함.
                          height: 200,
                          // 카드뷰 내용으로 buildBannerPageViewSection 재사용하여 구현함.
                          child: buildLargeBannerPageViewSection(
                              context, ref, homeLargeBannerPageProvider,
                              _largeBannerPageController, _largeBannerAutoScroll,
                              largeBannerLinks),
                        ),
                        backgroundColor: LIGHT_PURPLE_COLOR,
                        // 카드뷰 배경 색상 : LIGHT_PURPLE_COLOR
                        elevation: 4,
                        // 카드뷰 그림자 깊이
                        padding: const EdgeInsets.fromLTRB(
                            8.0, 8.0, 8.0, 8.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
                      ),
                      SizedBox(height: 10), // 높이 10으로 간격 설정
                      // 카드뷰 클래스 재사용으로 MidCategoryButtonList 내용이 있는 카드뷰 구현
                      // 중간 카테고리 버튼 리스트를 카드뷰로 구성
                      CommonCardView(
                        content: MidCategoryButtonList(
                            onCategoryTap: onMidCategoryTap),
                        // 카드뷰 내용으로 MidCategoryButtonList 재사용하여 구현
                        backgroundColor: LIGHT_PURPLE_COLOR,
                        // 카드뷰 배경 색상 : LIGHT_PURPLE_COLOR
                        elevation: 4,
                        // 카드뷰 그림자 깊이
                        padding: const EdgeInsets.fromLTRB(
                            8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
                      ),
                      SizedBox(height: 15), // 높이 15로 간격 설정
                      // 첫 번째 작은 배너 섹션
                      CommonCardView(
                        content: SizedBox(
                          // buildBannerPageViewSection 내용의 높이가 200으로 구현함.
                          height: 60,
                          // 카드뷰 내용으로 buildBannerPageViewSection 재사용하여 구현함.
                          child: buildSmall1BannerPageViewSection(
                              context, ref, homeSmall1BannerPageProvider,
                              _small1BannerPageController,
                              _small1BannerAutoScroll, small1BannerLinks),
                        ),
                        backgroundColor: LIGHT_SKY_BLUE_COLOR,
                        // 카드뷰 배경 색상 : LIGHT_PURPLE_COLOR
                        elevation: 4,
                        // 카드뷰 그림자 깊이
                        padding: const EdgeInsets.fromLTRB(
                            8.0, 8.0, 8.0, 8.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
                      ),
                      SizedBox(height: 15), // 높이 15로 간격 설정
                      // common_parts_layout.dart에 구현된 신상 관련 옷 상품 부분
                      // 신상품 섹션
                      // CommonCardView(
                      //   content: buildNewProductsSection(ref, context),
                      //   // 카드뷰 내용으로 buildNewProductsSection 재사용하여 구현
                      //   backgroundColor: BEIGE_COLOR,
                      //   // 카드뷰 배경 색상 : BEIGE_COLOR
                      //   elevation: 4,
                      //   // 카드뷰 그림자 깊이
                      //   padding: const EdgeInsets.fromLTRB(
                      //       8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
                      // ),
                        _buildSectionCard(context, ref, "신상", buildNewProductsSection, NewSubMainScreen()),
                        SizedBox(height: 10),
                      SizedBox(height: 10), // 높이 10으로 간격 설정
                      // common_parts_layout.dart에 구현된 최고 관련 옷 상품 부분
                      // 베스트 제품 섹션
                      // CommonCardView(
                      //   content: buildBestProductsSection(ref, context),
                      //   // 카드뷰 내용으로 buildBestProductsSection 재사용하여 구현
                      //   backgroundColor: LIGHT_YELLOW_COLOR,
                      //   // 카드뷰 배경 색상 : LIGHT_YELLOW_COLOR
                      //   elevation: 4,
                      //   // 카드뷰 그림자 깊이
                      //   padding: const EdgeInsets.fromLTRB(
                      //       8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
                      // ),
                        _buildSectionCard(context, ref, "최고", buildBestProductsSection, BestSubMainScreen()),
                      SizedBox(height: 10), // 높이 10으로 간격 설정
                      // common_parts_layout.dart에 구현된 할인 관련 옷 상품 부분
                      // 할인 제품 섹션
                      // CommonCardView(
                      //   content: buildDiscountProductsSection(ref, context),
                      //   // 카드뷰 내용으로 buildDiscountProductsSection 재사용하여 구현
                      //   backgroundColor: BEIGE_COLOR,
                      //   // 카드뷰 배경 색상 : BEIGE_COLOR
                      //   elevation: 4,
                      //   // 카드뷰 그림자 깊이
                      //   padding: const EdgeInsets.fromLTRB(
                      //       8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
                      // ),
                        _buildSectionCard(context, ref, "할인", buildDiscountProductsSection, SaleSubMainScreen()),
                      SizedBox(height: 15), // 높이 15로 간격 설정
                      // 두 번째 작은 배너 섹션
                      CommonCardView(
                        content: SizedBox(
                          // buildBannerPageViewSection 내용의 높이가 200으로 구현함.
                          height: 60,
                          // 카드뷰 내용으로 buildBannerPageViewSection 재사용하여 구현함.
                          child: buildSmall2BannerPageViewSection(
                              context, ref, homeSmall2BannerPageProvider,
                              _small2BannerPageController,
                              _small2BannerAutoScroll, small2BannerLinks),
                        ),
                        backgroundColor: LIGHT_SKY_BLUE_COLOR,
                        // 카드뷰 배경 색상 : LIGHT_PURPLE_COLOR
                        elevation: 4,
                        // 카드뷰 그림자 깊이
                        padding: const EdgeInsets.fromLTRB(
                            8.0, 8.0, 8.0, 8.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
                      ),
                      SizedBox(height: 15), // 높이 15로 간격 설정
                      // 계절별 제품 섹션들을 순차적으로 추가 (봄, 여름, 가을, 겨울)
                      // common_parts_layout.dart에 구현된 봄 관련 옷 상품 부분
                      // CommonCardView(
                      //   content: buildSpringProductsSection(ref, context),
                      //   // 카드뷰 내용으로 buildSpringProductsSection 재사용하여 구현
                      //   backgroundColor: LIGHT_YELLOW_COLOR,
                      //   // 카드뷰 배경 색상 : LIGHT_YELLOW_COLOR
                      //   elevation: 4,
                      //   // 카드뷰 그림자 깊이
                      //   padding: const EdgeInsets.fromLTRB(
                      //       8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
                      // ),
                        _buildSectionCard(context, ref, "봄", buildSpringProductsSection, SpringSubMainScreen()),
                      SizedBox(height: 10), // 높이 10으로 간격 설정
                      // common_parts_layout.dart에 구현된 여름 관련 옷 상품 부분
                      // CommonCardView(
                      //   content: buildSummerProductsSection(ref, context),
                      //   // 카드뷰 내용으로 buildSummerProductsSection 재사용하여 구현
                      //   backgroundColor: BEIGE_COLOR,
                      //   // 카드뷰 배경 색상 : BEIGE_COLOR
                      //   elevation: 4,
                      //   // 카드뷰 그림자 깊이
                      //   padding: const EdgeInsets.fromLTRB(
                      //       8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
                      // ),
                        _buildSectionCard(context, ref, "여름", buildSummerProductsSection, SummerSubMainScreen()),
                      SizedBox(height: 15), // 높이 15로 간격 설정
                      CommonCardView(
                        content: SizedBox(
                          // buildBannerPageViewSection 내용의 높이가 200으로 구현함.
                          height: 60,
                          // 카드뷰 내용으로 buildBannerPageViewSection 재사용하여 구현함.
                          child: buildSmall3BannerPageViewSection(
                              context, ref, homeSmall3BannerPageProvider,
                              _small3BannerPageController,
                              _small3BannerAutoScroll, small3BannerLinks),
                        ),
                        backgroundColor: LIGHT_SKY_BLUE_COLOR,
                        // 카드뷰 배경 색상 : LIGHT_PURPLE_COLOR
                        elevation: 4,
                        // 카드뷰 그림자 깊이
                        padding: const EdgeInsets.fromLTRB(
                            8.0, 8.0, 8.0, 8.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
                      ),
                      SizedBox(height: 15), // 높이 15로 간격 설정
                      // common_parts_layout.dart에 구현된 가을 관련 옷 상품 부분
                      // CommonCardView(
                      //   content: buildAutumnProductsSection(ref, context),
                      //   // 카드뷰 내용으로 buildAutumnProductsSection 재사용하여 구현
                      //   backgroundColor: LIGHT_YELLOW_COLOR,
                      //   // 카드뷰 배경 색상 : LIGHT_YELLOW_COLOR
                      //   elevation: 4,
                      //   // 카드뷰 그림자 깊이
                      //   padding: const EdgeInsets.fromLTRB(
                      //       8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
                      // ),
                        _buildSectionCard(context, ref, "가을", buildAutumnProductsSection, AutumnSubMainScreen()),
                      SizedBox(height: 10), // 높이 10으로 간격 설정
                      // common_parts_layout.dart에 구현된 겨울 관련 옷 상품 부분
                      // CommonCardView(
                      //   content: buildWinterProductsSection(ref, context),
                      //   // 카드뷰 내용으로 buildWinterProductsSection 재사용하여 구현
                      //   backgroundColor: BEIGE_COLOR,
                      //   // 카드뷰 배경 색상 : BEIGE_COLOR
                      //   elevation: 4,
                      //   // 카드뷰 그림자 깊이
                      //   padding: const EdgeInsets.fromLTRB(
                      //       8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
                      // ),
                        _buildSectionCard(context, ref, "겨울", buildWinterProductsSection, WinterSubMainScreen()),
                    ],
                   ),
                 );
                },
                childCount: 1, // 하나의 큰 Column이 모든 카드뷰를 포함하고 있기 때문에 1로 설정
              ),
            ),
           ),
         ],
       ),
     bottomNavigationBar: buildCommonBottomNavigationBar(
      ref.watch(tabIndexProvider), ref, context), // 공통으로 사용되는 하단 네비게이션 바를 가져옴.
     drawer: buildCommonDrawer(context), // 드로어 메뉴를 추가함.
    );
    // ------ 화면구성 끝
  }
// ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 끝

// ------ 상단 탭 바 관련 카드뷰 섹션 위젯 -
// (카드뷰 색상, 카드뷰 섹션 내용-CommonCardView, "+" 버튼 이미지로 버튼 구현-버튼 클릭 시, 서브 메인 페이지로 이동) 위젯 구현 내용 시작
// Flutter의 context와 ref 객체, 섹션의 제목, 내용을 빌드하는 함수, 그리고 네비게이션할 목적지 스크린을 인자로 받는 위젯 빌드 함수임.
  Widget _buildSectionCard(BuildContext context, WidgetRef ref, String title, Widget Function(WidgetRef, BuildContext) contentBuilder, Widget destinationScreen) {
    // 제목에 따라 다른 배경색을 설정함. '신상', '할인', '여름', '겨울' 일 경우 BEIGE_COLOR를, 그 외의 경우는 LIGHT_YELLOW_COLOR를 배경색으로 사용함.
    Color backgroundColor = (title == '신상' || title == '할인' || title == '여름' || title == '겨울') ? BEIGE_COLOR : LIGHT_YELLOW_COLOR;

    // 공통 카드 뷰를 반환함. 이 카드는 Stack 위젯을 사용하여 contentBuilder로 생성된 콘텐츠와 오른쪽 상단에 위치한 '더보기' 버튼을 포함함.
    return CommonCardView(
      content: Stack(
        children: [
          // 사용자 정의 콘텐츠를 빌드하는 함수를 호출함.
          contentBuilder(ref, context),
          // '더보기' 버튼을 위치시키며, 이 버튼을 탭하면 destinationScreen으로 네비게이션함.
          Positioned(
            right: 8,
            top: 1,
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destinationScreen)),
              child: Image.asset('asset/img/misc/button_img/plus_button.png', width: 24, height: 24),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      elevation: 4,  // 카드의 높이(그림자 깊이)를 설정함.
      padding: const EdgeInsets.all(8.0),  // 카드 내부의 패딩을 설정함.
    );
  }
// ------ 상단 탭 바 관련 카드뷰 섹션 위젯 -
// (카드뷰 색상, 카드뷰 섹션 내용-CommonCardView, "+" 버튼 이미지로 버튼 구현-버튼 클릭 시, 서브 메인 페이지로 이동) 위젯 구현 내용 끝

}
// _HomeScreenState 클래스 끝
