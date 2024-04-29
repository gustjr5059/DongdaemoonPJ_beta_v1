
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod를 사용한 상태 관리를 위한 import
import '../../../common/layout/common_exception_parts_of_body_layout.dart';
import '../../../common/provider/common_future_provider.dart';
import '../../../common/provider/common_state_provider.dart'; // 공통 상태 관리 파일
import '../../../common/layout/common_body_parts_layout.dart'; // 공통 UI 컴포넌트 파일
// 아래는 각 카테고리별 상세 페이지를 위한 레이아웃 파일들
import '../../../home/layout/home_body_parts_layout.dart';
import '../../provider/product_state_provider.dart';


// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용 권장
// GlobalKey 사용 시 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// JeanMainScreen 클래스는 ConsumerWidget 상속, Riverpod를 통한 상태 관리 지원
class JeanMainScreen extends ConsumerStatefulWidget {
  const JeanMainScreen({Key? key}) : super(key: key);
  @override
  _JeanMainScreenState createState() => _JeanMainScreenState();
}

// _JeanMainScreenState 클래스 시작
// _JeanMainScreenState 클래스는 JeanMainScreen 위젯의 상태를 관리함.
// WidgetsBindingObserver 믹스인을 통해 앱 생명주기 상태 변화를 감시함.
class _JeanMainScreenState extends ConsumerState<JeanMainScreen> with WidgetsBindingObserver {
  // 페이지 컨트롤러 인스턴스를 늦게 초기화함.
  // 이 컨트롤러를 사용하여 페이지뷰를 프로그래매틱하게 제어할 수 있음.
  late PageController _pageController;
  // 배너 자동 스크롤 기능을 관리하는 클래스 인스턴스를 늦게 초기화함.
  // 이 클래스를 통해 배너 이미지가 자동으로 스크롤되는 기능을 구현할 수 있음.
  late BannerAutoScrollClass _bannerAutoScroll;
  int bannerImageCount = 3; // 배너 이미지 총 개수 저장 변수

  // 배너 클릭 시 이동할 URL 리스트를 정의합니다.
// 각 배너 클릭 시 연결될 웹사이트 주소를 리스트로 관리합니다.
  final List<String> bannerLinks = [
    'https://www.naver.com', // 첫 번째 배너 클릭 시 네이버로 이동
    'https://www.youtube.com', // 두 번째 배너 클릭 시 유튜브로 이동
    // 'https://www.coupang.com' // 세 번째 배너의 URL은 현재 주석 처리되어 사용되지 않음
  ];

  // 사용자 인증 상태 변경을 감지하는 스트림 구독 객체임.
  // 이를 통해 사용자 로그인 또는 로그아웃 상태 변경을 실시간으로 감지하고 처리할 수 있음.
  StreamSubscription<User?>? authStateChangesSubscription;

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // PageController를 현재 페이지로 설정함.(다른 화면 이동 후 다시 홈 화면으로 오는 경우에 이동하기 직전의 페이지로 시작)
    _pageController = PageController(initialPage: ref.read(jeanMainBannerPageProvider));

    // 배너의 자동 스크롤 기능을 초기화함.
    _bannerAutoScroll = BannerAutoScrollClass(
      pageController: _pageController,
      currentPageProvider: jeanMainBannerPageProvider,
      itemCount: bannerImageCount,
    );

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        ref.read(jeanMainBannerPageProvider.notifier).state = 0;
      }
    });

    // WidgetsBindingObserver를 추가하여 앱의 생명주기를 관리함.
    WidgetsBinding.instance.addObserver(this); // 생명주기 옵저버 등록

    // 배너 데이터 로드가 완료된 후 자동 스크롤 시작
    Future.delayed(Duration.zero, () {
      _bannerAutoScroll.startAutoScroll();
    });
  }
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 끝 (앱 실행 생명주기 관련 함수)

  // ------ 페이지 뷰 자동 스크롤 타이머 함수인 startAutoScrollTimer() 시작 및 정지 관린 함수인
  // didChangeAppLifecycleState 함수 관련 구현 내용 시작
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // 앱이 다시 활성화되면 자동 스크롤 재시작
      _bannerAutoScroll.startAutoScroll();
    } else if (state == AppLifecycleState.paused) {
      // 앱이 백그라운드로 이동하면 자동 스크롤 중지
      _bannerAutoScroll.stopAutoScroll();
    }
  }
  // ------ 페이지 뷰 자동 스크롤 타이머 함수인 startAutoScrollTimer() 시작 및 정지 관린 함수인
  // didChangeAppLifecycleState 함수 관련 구현 내용 끝

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void dispose() {
    // WidgetsBinding 인스턴스에서 현재 객체를 옵저버 목록에서 제거함.
    // 이는 앱 생명주기 이벤트를 더 이상 수신하지 않겠다는 것을 의미함.
    WidgetsBinding.instance.removeObserver(this);
    // 페이지 컨트롤러를 사용하여 생성된 리소스를 해제함.
    _pageController.dispose();
    // 배너 자동 스크롤 클래스를 사용하여 자동 스크롤을 중지함.
    // 배너가 자동으로 스크롤되는 기능을 사용할 때, 해당 기능을 중지하고 리소스를 정리함.
    _bannerAutoScroll.stopAutoScroll();
    // Firebase 같은 백엔드 서비스를 사용하여 인증 상태가 변경될 때마다 알림을 받는 경우,
    // 위젯이 제거될 때 이러한 알림을 더 이상 받지 않도록 구독을 취소함.
    authStateChangesSubscription?.cancel();
    // 위젯의 기본 dispose 메서드를 호출하여 추가적인 정리 작업을 수행함.
    super.dispose();
  }
  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 끝 (앱 실행 생명주기 관련 함수)
  // ------ 앱 실행 생명주기 관리 관련 함수 끝

  // ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 시작
  @override
  Widget build(BuildContext context) {
    // ------ common_body_parts_layout.dart 내 buildTopBarList, onTopBarTap 재사용하여 TopBar 구현 내용 시작
    // 탭을 탭했을 때 호출될 함수
    // 상단 탭 바를 구성하고 탭 선택 시 동작을 정의하는 함수
    // (common_parts.dart의 onTopBarTap 함수를 불러와 생성자를 만든 후 사용하는 개념이라 void인 함수는 함수명을 그대로 사용해야 함)
    void onTopBarTap(int index) {
    }
    // 상단 탭 바를 구성하는 리스트 뷰를 가져오는 위젯
    // (common_parts.dart의 buildTopBarList 재사용 후 topBarList 위젯으로 재정의)
    Widget topBarList = buildTopBarList(context, onTopBarTap);
    // ------ common_body_parts_layout.dart 내 buildTopBarList, onTopBarTap 재사용하여 TopBar 구현 내용 끝


    // ------ 화면 구성 시작
    // 앱의 주요 화면을 구성하는 Scaffold 위젯
    return Scaffold(
      appBar: buildCommonAppBar(context: context, title: '청바지 메인', pageBackButton: true), // 공통으로 사용되는 AppBar를 가져옴.
      body: SingleChildScrollView(
        child: Column(
          children: [
            // common_parts.dart에서 가져온 카테고리 리스트
            // 상단 탭 바
            // 여기에 Container보다 SizedBox 사용을 더 선호함(알아두기)
            SizedBox(
              // 상단 탭 바를 표시
              height: 20, // TopBar의 높이 설정
              child: topBarList, // 수정된 buildTopBarList 함수 호출
            ),
            SizedBox(height: 20), // 높이 20으로 간격 설정
            // 화살표 버튼이 있는 PageView
            SizedBox(
              // 페이지 뷰 섹션을 표시
              height: 200, // 페이지 뷰의 높이 설정
              child: buildLargeBannerPageViewSection(context, ref, jeanMainBannerPageProvider, _pageController, _bannerAutoScroll, bannerLinks), // 배너 페이지뷰 위젯 재사용하여 구현
            ),
            SizedBox(height: 40), // 높이 20으로 간격 설정

            // 텍스트 위에 회색선을 추가
            Divider(
              color: Colors.grey, // 선의 색상을 회색으로 지정
              thickness: 1, // 선의 두께를 1로 지정
            ),
            SizedBox(height: 10), // 높이 10으로 간격 설정
            buildNewProductsSection(ref, context), // common_parts_layout.dart에 구현된 신상 관련 옷 상품 부분
            SizedBox(height: 10), // 높이 10으로 간격 설정
            buildBestProductsSection(ref, context), // common_parts_layout.dart에 구현된 최고 관련 옷 상품 부분
            SizedBox(height: 10), // 높이 10으로 간격 설정
            buildDiscountProductsSection(ref, context), // common_parts_layout.dart에 구현된 할인 관련 옷 상품 부분
            SizedBox(height: 10), // 높이 10으로 간격 설정
            buildSpringProductsSection(ref, context), // common_parts_layout.dart에 구현된 봄 관련 옷 상품 부분
            SizedBox(height: 10), // 높이 10으로 간격 설정
            buildSummerProductsSection(ref, context), // common_parts_layout.dart에 구현된 여름 관련 옷 상품 부분
            SizedBox(height: 10), // 높이 10으로 간격 설정
            buildAutumnProductsSection(ref, context), // common_parts_layout.dart에 구현된 가을 관련 옷 상품 부분
            SizedBox(height: 10), // 높이 10으로 간격 설정
            buildWinterProductsSection(ref, context), // common_parts_layout.dart에 구현된 겨울 관련 옷 상품 부분
          ],
        ),
      ),
    );
    // ------ 화면구성 끝
  }
// ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 끝
}
// _HomeScreenState 클래스 끝


