import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod를 사용한 상태 관리를 위한 import
import '../../../common/provider/common_state_provider.dart'; // 공통 상태 관리 파일
import '../../../common/layout/common_parts_layout.dart'; // 공통 UI 컴포넌트 파일
// 아래는 각 카테고리별 상세 페이지를 위한 레이아웃 파일들
import '../../common/const/colors.dart';
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

  // ------ ㅊ 시작
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


    // ------ 화면 구성 시작
    // 앱의 주요 화면을 구성하는 Scaffold 위젯
    return Scaffold(
      // 공통으로 사용되는 AppBar를 가져옴. '홈' 제목과 페이지 뒤로 가기 버튼 비활성화
      appBar: buildCommonAppBar(context: context, title: '홈', pageBackButton: false),
      // 전체 바디에 좌우 패딩: 4.0을 적용한 Padding 위젯
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: SingleChildScrollView(
        // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 시작
        // controller: scrollController, // 스크롤 컨트롤러 연결
        // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 끝
          child: Column(
            children: [
              // common_parts.dart에서 가져온 카테고리 리스트
              // 상단 탭 바
              // 여기에 Container보다 SizedBox 사용을 더 선호함(알아두기)
              SizedBox(
                // 상단 탭 바를 표시
                height: 20, // TopBar의 높이 설정
                child: topBarList, // 상단 탭 바 리스트 빌드
              ),
              SizedBox(height: 20), // 높이 20으로 간격 설정
              // 큰 배너 섹션을 카드뷰로 구성
              CommonCardView(
                content: SizedBox(
                  // buildBannerPageViewSection 내용의 높이가 200으로 구현함.
                  height: 200,
                  // 카드뷰 내용으로 buildBannerPageViewSection 재사용하여 구현함.
                  child: buildLargeBannerPageViewSection(context, ref, homeLargeBannerPageProvider, _largeBannerPageController, _largeBannerAutoScroll, largeBannerLinks),
                ),
                backgroundColor: LIGHT_PURPLE_COLOR, // 카드뷰 배경 색상 : LIGHT_PURPLE_COLOR
                elevation: 4, // 카드뷰 그림자 깊이
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
              ),
              SizedBox(height: 10), // 높이 10으로 간격 설정
              // 카드뷰 클래스 재사용으로 MidCategoryButtonList 내용이 있는 카드뷰 구현
              // 중간 카테고리 버튼 리스트를 카드뷰로 구성
              CommonCardView(
                content: MidCategoryButtonList(onCategoryTap: onMidCategoryTap), // 카드뷰 내용으로 MidCategoryButtonList 재사용하여 구현
                backgroundColor: LIGHT_PURPLE_COLOR, // 카드뷰 배경 색상 : LIGHT_PURPLE_COLOR
                elevation: 4, // 카드뷰 그림자 깊이
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
              ),
              SizedBox(height: 10), // 높이 10으로 간격 설정
              // 첫 번째 작은 배너 섹션
              CommonCardView(
                content: SizedBox(
                  // buildBannerPageViewSection 내용의 높이가 200으로 구현함.
                  height: 100,
                  // 카드뷰 내용으로 buildBannerPageViewSection 재사용하여 구현함.
                  child: buildSmall1BannerPageViewSection(context, ref, homeSmall1BannerPageProvider, _small1BannerPageController, _small1BannerAutoScroll, small1BannerLinks),
                ),
                backgroundColor: LIGHT_SKY_BLUE_COLOR, // 카드뷰 배경 색상 : LIGHT_PURPLE_COLOR
                elevation: 4, // 카드뷰 그림자 깊이
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
              ),
              SizedBox(height: 10), // 높이 10으로 간격 설정
              // common_parts_layout.dart에 구현된 신상 관련 옷 상품 부분
              // 신상품 섹션
              CommonCardView(
                content: buildNewProductsSection(ref, context), // 카드뷰 내용으로 buildNewProductsSection 재사용하여 구현
                backgroundColor: BEIGE_COLOR, // 카드뷰 배경 색상 : BEIGE_COLOR
                elevation: 4, // 카드뷰 그림자 깊이
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
              ),
              SizedBox(height: 10), // 높이 10으로 간격 설정
              // common_parts_layout.dart에 구현된 최고 관련 옷 상품 부분
              // 베스트 제품 섹션
              CommonCardView(
                content: buildBestProductsSection(ref, context), // 카드뷰 내용으로 buildBestProductsSection 재사용하여 구현
                backgroundColor: LIGHT_YELLOW_COLOR, // 카드뷰 배경 색상 : LIGHT_YELLOW_COLOR
                elevation: 4, // 카드뷰 그림자 깊이
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
              ),
              SizedBox(height: 10), // 높이 10으로 간격 설정
              // common_parts_layout.dart에 구현된 할인 관련 옷 상품 부분
              // 할인 제품 섹션
              CommonCardView(
                content: buildDiscountProductsSection(ref, context), // 카드뷰 내용으로 buildDiscountProductsSection 재사용하여 구현
                backgroundColor: BEIGE_COLOR, // 카드뷰 배경 색상 : BEIGE_COLOR
                elevation: 4, // 카드뷰 그림자 깊이
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
              ),
              SizedBox(height: 10), // 높이 10으로 간격 설정
              // 두 번째 작은 배너 섹션
              CommonCardView(
                content: SizedBox(
                  // buildBannerPageViewSection 내용의 높이가 200으로 구현함.
                  height: 100,
                  // 카드뷰 내용으로 buildBannerPageViewSection 재사용하여 구현함.
                  child: buildSmall2BannerPageViewSection(context, ref, homeSmall2BannerPageProvider, _small2BannerPageController, _small2BannerAutoScroll, small2BannerLinks),
                ),
                backgroundColor: LIGHT_SKY_BLUE_COLOR, // 카드뷰 배경 색상 : LIGHT_PURPLE_COLOR
                elevation: 4, // 카드뷰 그림자 깊이
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
              ),
              SizedBox(height: 10), // 높이 10으로 간격 설정
              // 계절별 제품 섹션들을 순차적으로 추가 (봄, 여름, 가을, 겨울)
              // common_parts_layout.dart에 구현된 봄 관련 옷 상품 부분
              CommonCardView(
                content: buildSpringProductsSection(ref, context), // 카드뷰 내용으로 buildSpringProductsSection 재사용하여 구현
                backgroundColor: LIGHT_YELLOW_COLOR, // 카드뷰 배경 색상 : LIGHT_YELLOW_COLOR
                elevation: 4, // 카드뷰 그림자 깊이
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
              ),
              SizedBox(height: 10), // 높이 10으로 간격 설정
              // common_parts_layout.dart에 구현된 여름 관련 옷 상품 부분
              CommonCardView(
                content: buildSummerProductsSection(ref, context), // 카드뷰 내용으로 buildSummerProductsSection 재사용하여 구현
                backgroundColor: BEIGE_COLOR, // 카드뷰 배경 색상 : BEIGE_COLOR
                elevation: 4, // 카드뷰 그림자 깊이
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
              ),
              SizedBox(height: 10), // 높이 10으로 간격 설정
              CommonCardView(
                content: SizedBox(
                  // buildBannerPageViewSection 내용의 높이가 200으로 구현함.
                  height: 100,
                  // 카드뷰 내용으로 buildBannerPageViewSection 재사용하여 구현함.
                  child: buildSmall3BannerPageViewSection(context, ref, homeSmall3BannerPageProvider, _small3BannerPageController, _small3BannerAutoScroll, small3BannerLinks),
                ),
                backgroundColor: LIGHT_SKY_BLUE_COLOR, // 카드뷰 배경 색상 : LIGHT_PURPLE_COLOR
                elevation: 4, // 카드뷰 그림자 깊이
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
              ),
              SizedBox(height: 10), // 높이 10으로 간격 설정
              // common_parts_layout.dart에 구현된 가을 관련 옷 상품 부분
              CommonCardView(
                content: buildAutumnProductsSection(ref, context), // 카드뷰 내용으로 buildAutumnProductsSection 재사용하여 구현
                backgroundColor: LIGHT_YELLOW_COLOR, // 카드뷰 배경 색상 : LIGHT_YELLOW_COLOR
                elevation: 4, // 카드뷰 그림자 깊이
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
              ),
              SizedBox(height: 10), // 높이 10으로 간격 설정
              // common_parts_layout.dart에 구현된 겨울 관련 옷 상품 부분
              CommonCardView(
                content: buildWinterProductsSection(ref, context), // 카드뷰 내용으로 buildWinterProductsSection 재사용하여 구현
                backgroundColor: BEIGE_COLOR, // 카드뷰 배경 색상 : BEIGE_COLOR
                elevation: 4, // 카드뷰 그림자 깊이
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
              ),
              ],
            ),
          ),
        ),
        // 하단 네비게이션 바 구성
        // buildCommonBottomNavigationBar 함수 호출 시 context 인자 추가
        bottomNavigationBar: buildCommonBottomNavigationBar(
            ref.watch(tabIndexProvider), ref, context), // 공통으로 사용되는 하단 네비게이션 바를 가져옴.
        drawer: buildCommonDrawer(context), // 드로어 메뉴를 추가함.
      );
      // ------ 화면구성 끝
    }
  // ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 끝
  }
  // _HomeScreenState 클래스 끝
