// Dart의 IO 라이브러리에서 Platform 클래스를 가져옵니다. 이 클래스는 운영 체제에 대한 정보를 제공합니다.
import 'dart:io' show Platform;

// Dart 비동기 프로그래밍을 위한 라이브러리에서 Future와 Stream 등을 사용할 수 있게 합니다.
import 'dart:async';

// Firebase의 사용자 인증 기능을 사용하기 위한 패키지를 임포트합니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';

// Flutter의 기본 디자인과 인터페이스 요소들을 사용하기 위한 Material 패키지를 임포트합니다.
import 'package:flutter/material.dart';

// 플랫폼 특정 기능을 제어하기 위한 서비스 인터페이스를 제공합니다.
import 'package:flutter/services.dart';

// Riverpod 패키지를 사용한 상태 관리 기능을 추가합니다. Riverpod는 상태 관리를 위한 외부 패키지입니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';

// url_launcher 패키지를 가져옵니다.
// 이 패키지는 URL을 열거나, 이메일, 전화 등을 실행할 수 있는 기능을 제공합니다.
import 'package:url_launcher/url_launcher.dart';

// 공통적으로 사용될 상태 관리 로직을 포함하는 파일을 임포트합니다.
import '../../../common/provider/common_state_provider.dart';

// 애플리케이션의 공통 UI 컴포넌트를 구성하는 파일을 임포트합니다.
import '../../../common/layout/common_body_parts_layout.dart';

// 다양한 색상을 정의하는 파일을 임포트합니다.
import '../../cart/provider/cart_state_provider.dart';
import '../../common/const/colors.dart';

// 예외 발생 시 사용할 공통 UI 부분을 정의한 파일을 임포트합니다.
import '../../common/layout/common_exception_parts_of_body_layout.dart';

// banner_model.dart 파일을 common 디렉토리의 model 폴더에서 가져옵니다.
// 이 파일에는 배너와 관련된 데이터 모델이 정의되어 있을 것입니다.
import '../../common/model/banner_model.dart';

// common_all_providers.dart 파일을 common 디렉토리의 provider 폴더에서 가져옵니다.
// 이 파일에는 Future Provider와 관련된 기능이 정의되어 있을 것입니다.
import '../../common/provider/common_all_providers.dart';

// 프로필 화면의 상태를 관리하기 위한 Provider 파일을 임포트합니다.
import '../../order/provider/order_all_providers.dart';
import '../../order/provider/order_state_provider.dart';
import '../../product/provider/product_all_providers.dart';
import '../layout/user_body_parts_layout.dart';
import '../provider/profile_all_providers.dart';
import '../provider/profile_state_provider.dart';
import 'login_screen.dart';

// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용 권장
// GlobalKey 사용 시 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// ProfileMainScreen 클래스는 ConsumerWidget 상속, Riverpod를 통한 상태 관리 지원
class ProfileMainScreen extends ConsumerStatefulWidget {
  const ProfileMainScreen({Key? key}) : super(key: key);

  @override
  _ProfileMainScreenState createState() => _ProfileMainScreenState();
}

// _ProfileMainScreenState 클래스 시작
// _ProfileMainScreenState 클래스는 CartMainScreen 위젯의 상태를 관리함.
// WidgetsBindingObserver 믹스인을 통해 앱 생명주기 상태 변화를 감시함.
class _ProfileMainScreenState extends ConsumerState<ProfileMainScreen>
    with WidgetsBindingObserver {

  // 첫 번째 작은 배너를 위한 페이지 컨트롤러
  late PageController _small1BannerPageController;

  // 첫 번째 작은 배너를 자동 스크롤하는 클래스
  late BannerAutoScrollClass _small1BannerAutoScroll;

  // 배너 이미지의 총 개수를 저장하는 변수
  int bannerImageCount = 3;

  // 사용자 인증 상태 변경을 감지하는 스트림 구독 객체임.
  // 이를 통해 사용자 로그인 또는 로그아웃 상태 변경을 실시간으로 감지하고 처리할 수 있음.
  StreamSubscription<User?>? authStateChangesSubscription;

  // profileScrollControllerProvider에서 ScrollController를 읽어와서 scrollController에 할당
  // ref.read(profileScrollControllerProvider)는 provider를 이용해 상태를 읽는 방식.
  // ScrollController는 스크롤 가능한 위젯의 스크롤 동작을 제어하기 위해 사용됨.
  // 1.상단 탭바 버튼 클릭 시 해당 섹션으로 스크롤 이동하는 기능,
  // 2.하단 탭바의 마이페이지 버튼 클릭 시  화면 초기 위치로 스크롤 이동하는 기능,
  // 3.사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을때 마지막으로 본 위치로 자동으로 스크롤되도록 하는 기능,
  // 4.단순 스크롤을 내리거나 올릴 시, 상단 탭 바 버튼 텍스트 색상이 변경되도록 하는 기능,
  // 5. 'top' 버튼 클릭 시 홈 화면 초기 위치로 스크롤 이동하는 기능,
  // => 5개의 기능인 전체 화면의 스크롤을 제어하는 컨트롤러-화면 내의 여러 섹션으로의 이동 역할

  // profileScrollControllerProvider : 여러 위젯에서 동일한 ScrollController를 공유하고,
  // 상태를 유지하기 위해 Riverpod의 Provider를 사용하여 관리함.
  // 이를 통해 앱의 다른 부분에서도 동일한 ScrollController에 접근할 수 있으며, 상태를 일관성 있게 유지함.
  // ScrollController를 late 변수로 선언
  // ScrollController가 여러 ScrollView에 attach 되어서 ScrollController가 동시에 여러 ScrollView에서 사용될 때 발생한 문제를 해결한 방법
  // => late로 변수 선언 / 해당 변수를 초기화(initState()) / 해당 변수를 해제 (dispose())
  late ScrollController profileScreenPointScrollController; // 스크롤 컨트롤러 선언

  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // ScrollController를 초기화
    profileScreenPointScrollController = ScrollController();
    // initState에서 저장된 스크롤 위치로 이동
    // initState에서 실행되는 코드. initState는 위젯이 생성될 때 호출되는 초기화 단계
    // WidgetsBinding.instance.addPostFrameCallback 메서드를 사용하여 프레임이 렌더링 된 후 콜백을 등록함.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 스크롤 컨트롤러가 활성 스크롤 뷰를 가지고 있는지 확인함.
      if (profileScreenPointScrollController.hasClients) {
        // savedScrollPosition 변수에 저장된 스크롤 위치를 읽어옴.
        // ref.read(scrollPositionProvider)는 Riverpod 상태 관리 라이브러리를 사용하여
        // scrollPositionProvider에서 마지막으로 저장된 스크롤 위치를 가져옴.
        double savedScrollPosition = ref.read(profileMainScrollPositionProvider);
        // profileScreenPointScrollController.jumpTo 메서드를 사용하여 스크롤 위치를 savedScrollPosition으로 즉시 이동함.
        // 이는 스크롤 애니메이션이나 다른 복잡한 동작 없이 바로 지정된 위치로 점프함.
        profileScreenPointScrollController.jumpTo(savedScrollPosition);
      }

      // tabIndexProvider의 상태를 하단 탭 바 내 마이페이지 버튼 인덱스인 3과 매핑
      // -> 마이페이지 화면 초기화 시, 하단 탭 바 내 마이페이지 버튼을 활성화
      ref.read(tabIndexProvider.notifier).state = 3;
      ref.invalidate(cartItemCountProvider); // 장바구니 아이템 갯수 데이터 초기화
      ref.invalidate(orderlistItemCountProvider); // 요청내역 아이템 갯수 데이터 초기화
      ref.invalidate(profileUserInfoProvider); // 마이페이지 회원정보 데이터 초기화
    });

    // 작은 배너1에 대한 PageController 및 AutoScroll 초기화
    // 'cardiganMainSmall1BannerPageProvider'에서 초기 페이지 인덱스를 읽어옴
    _small1BannerPageController = PageController(
        initialPage: ref.read(profileMainSmall1BannerPageProvider));

    // 작은 배너1을 자동으로 스크롤하는 기능 초기화
    _small1BannerAutoScroll = BannerAutoScrollClass(
      pageController: _small1BannerPageController,
      currentPageProvider: profileMainSmall1BannerPageProvider,
      itemCount: bannerImageCount, // 총 배너 이미지 개수 전달
    );

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        // 마이페이지 화면에서 로그아웃 이벤트를 실시간으로 감지하고 처리하는 로직 (여기에도 마이페이지 화면 내 프로바이더 중 초기화해야하는 것을 로직 구현)
        ref.read(profileMainSmall1BannerPageProvider.notifier).state = 0;
        ref.read(profileMainScrollPositionProvider.notifier).state =
            0.0; // 마이페이지 화면 자체의 스크롤 위치 인덱스를 초기화
        ref.invalidate(cartItemCountProvider); // 장바구니 아이템 갯수 데이터 초기화
        ref.invalidate(orderlistItemCountProvider); // 요청내역 아이템 갯수 데이터 초기화
      }
    });

    // WidgetsBindingObserver를 추가하여 앱의 생명주기 변화 감지
    WidgetsBinding.instance.addObserver(this); // 생명주기 옵저버 등록

    // 상태표시줄 색상을 안드로이드와 ios 버전에 맞춰서 변경하는데 사용되는 함수-앱 실행 생명주기에 맞춰서 변경
    updateStatusBar();

    // 배너 데이터 로드가 완료된 후 자동 스크롤 시작
    Future.delayed(Duration.zero, () {
      _small1BannerAutoScroll.startAutoScroll();
    });

    // 네트워크 상태 체크 시작
    _networkChecker = NetworkChecker(context);
    _networkChecker?.checkNetworkStatus();
  }

  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 끝 (앱 실행 생명주기 관련 함수)

  // ------ 페이지 뷰 자동 스크롤 타이머 함수인 startAutoScrollTimer() 시작 및 정지 관린 함수인
  // didChangeAppLifecycleState 함수 관련 구현 내용 시작
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      updateStatusBar();
    }
    // 앱이 다시 활성화되면(포어그라운드로 올 때), 배너의 자동 스크롤을 재시작
    if (state == AppLifecycleState.resumed) {
      _small1BannerAutoScroll.startAutoScroll();
      // 앱이 백그라운드로 이동할 때, 배너의 자동 스크롤을 중지
    } else if (state == AppLifecycleState.paused) {
      _small1BannerAutoScroll.stopAutoScroll();
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
    _small1BannerPageController.dispose();
    _small1BannerAutoScroll.stopAutoScroll();

    // 사용자 인증 상태 감지 구독 해제함.
    authStateChangesSubscription?.cancel();

    profileScreenPointScrollController.dispose(); // ScrollController 해제

    // 네트워크 체크 해제
    _networkChecker?.dispose();

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

    // // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려하지 않은 사이즈 시작 부분
    // // 비율을 기반으로 동적으로 크기와 위치 설정
    //
    // // 소배너 부분 관련 수치
    // final double profileMainScreenSmallBannerWidth = screenSize.width * (361 / referenceWidth); // 소배너 이미지 너비
    // final double profileMainScreenSmallBannerHeight = screenSize.height * (90 / referenceHeight); // 소배너 이미지 높이
    // final double profileMainScreenSmallBannerViewHeight =
    //     screenSize.height * (90 / referenceHeight); // 소배너 화면 세로 비율
    //
    // // AppBar 관련 수치 동적 적용
    // final double profileAppBarTitleWidth = screenSize.width * (240 / referenceWidth);
    // final double profileAppBarTitleHeight = screenSize.height * (22 / referenceHeight);
    // final double profileAppBarTitleX = screenSize.width * (5 / referenceHeight);
    // final double profileAppBarTitleY = screenSize.height * (11 / referenceHeight);
    //
    // // body 부분 데이터 내용의 전체 패딩 수치
    // final double profilePaddingX = screenSize.width * (16 / referenceWidth);
    // final double profilePadding1Y = screenSize.height * (5 / referenceHeight);
    // final double profilePadding2Y = screenSize.height * (5 / referenceHeight);
    // final double profilePadding3Y = screenSize.height * (10 / referenceHeight);
    //
    // // 개인정보 처리방침 관련 안내 텍스트 수치
    // final double guideTextFontSize =
    //     screenSize.height * (12 / referenceHeight);
    // // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려하지 않은 사이즈 끝 부분

    // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려한 사이즈 시작 부분
    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 소배너 부분 관련 수치
    final double profileMainScreenSmallBannerWidth = screenSize.width * (361 / referenceWidth); // 소배너 이미지 너비
    final double profileMainScreenSmallBannerHeight = 90; // 소배너 이미지 높이
    final double profileMainScreenSmallBannerViewHeight = 90; // 소배너 화면 세로 비율

    // AppBar 관련 수치 동적 적용
    final double profileAppBarTitleWidth = screenSize.width * (240 / referenceWidth);
    final double profileAppBarTitleHeight = 22;
    final double profileAppBarTitleX = screenSize.width * (5 / referenceHeight);
    final double profileAppBarTitleY = 11;

    // body 부분 데이터 내용의 전체 패딩 수치
    final double profilePaddingX = screenSize.width * (16 / referenceWidth);
    final double profilePadding1Y = 5;
    final double profilePadding2Y = 5;
    final double profilePadding3Y = 10;

    // 개인정보 처리방침 관련 안내 텍스트 수치
    final double guideTextFontSize = 12;
    // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려한 사이즈 끝 부분

    // 현재 로그인된 사용자를 FirebaseAuth 인스턴스로부터 가져옴
    final User? user = FirebaseAuth.instance.currentUser;

    // ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 시작
    // ------ 기존 buildCommonAppBar 위젯 내용과 동일하며,
    // 플러터 기본 SliverAppBar 위젯을 활용하여 앱 바의 상태 동적 UI 구현에 수월한 부분을 정의해서 해당 위젯을 바로 다른 화면에 구현하여
    // 기본 SliverAppBar의 드로워화면 토글 옵션을 삭제하는 등의 작업이 필요없는 방식-현재는 이슈가 있어 사용 안함..
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: profileScreenPointScrollController, // 스크롤 컨트롤러 연결
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
                // 확장 높이 설정
                // FlexibleSpaceBar를 사용하여 AppBar 부분의 확장 및 축소 효과 제공함.
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  // 앱 바 부분을 고정시키는 옵션->앱 바가 스크롤에 의해 사라지고, 그 자리에 상단 탭 바가 있는 bottom이 상단에 고정되도록 하는 기능
                  background: buildCommonAppBar(
                    context: context,
                    ref: ref,
                    title: '마이페이지',
                    fontFamily: 'NanumGothic',
                    leadingType: LeadingType.none,
                    buttonCase: 1,
                    appBarTitleWidth: profileAppBarTitleWidth,
                    appBarTitleHeight: profileAppBarTitleHeight,
                    appBarTitleX: profileAppBarTitleX,
                    appBarTitleY: profileAppBarTitleY,
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
                padding: EdgeInsets.only(top: 0),
                // SliverList를 사용하여 목록 아이템을 동적으로 생성함.
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        // 각 항목의 좌우 간격을 profilePaddingX으로 설정함.
                        padding: EdgeInsets.symmetric(horizontal: profilePaddingX),
                        child: Column(
                          children: [
                            SizedBox(height: profilePadding1Y), // 높이 profilePadding1Y로 간격 설정
                            UserProfileInfo(), // 항상 UserProfileInfo를 호출
                            SizedBox(height: profilePadding1Y),
                            // 첫 번째 작은 배너 섹션
                            CommonCardView(
                              content: Container(
                                // 모서리에 반경을 주기 위한 BoxDecoration 추가함
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8), // 작은 배너의 모서리 반경을 8로 설정함
                                ),
                                child: SizedBox(
                                  // 배너 섹션의 높이를 60으로 설정함
                                  height: profileMainScreenSmallBannerViewHeight,
                                  // 배너 섹션의 내용을 buildCommonBannerPageViewSection 위젯으로 재사용하여 구현함
                                  child: buildCommonBannerPageViewSection<
                                      AllSmallBannerImage>(
                                    context: context, // 위젯 트리를 위한 빌드 컨텍스트 전달함
                                    ref: ref, // 상태 관리를 위한 참조 전달함
                                    currentPageProvider:
                                    profileMainSmall1BannerPageProvider, // 작은 배너 페이지의 상태 제공자를 전달함
                                    pageController: _small1BannerPageController, // 작은 배너 페이지의 스크롤을 제어할 컨트롤러를 전달함
                                    bannerAutoScroll: _small1BannerAutoScroll, // 작은 배너의 자동 스크롤 설정을 전달함
                                    bannerImagesProvider:
                                    profileMainSmall1BannerImagesProvider, // 작은 배너 이미지의 상태 제공자를 전달함
                                    // 배너를 탭했을 때 실행할 함수를 전달
                                    onPageTap: (context, index) =>
                                    // 소배너 클릭 시 호출할 함수 onSmallBannerTap 실행
                                    onSmallBannerTap(
                                        context, // 현재 화면의 컨텍스트를 전달함
                                        index, // 클릭된 배너의 인덱스를 전달함
                                        // profileMainSmall1BannerImagesProvider에서 대배너 이미지 리스트를 가져옴. 값이 없으면 빈 리스트를 사용함
                                        ref.watch(profileMainSmall1BannerImagesProvider).value ?? [],
                                        ref // Provider의 참조를 전달함
                                    ),
                                    width: profileMainScreenSmallBannerWidth, // 배너 섹션의 너비를 설정함
                                    height: profileMainScreenSmallBannerHeight, // 배너 섹션의 높이를 설정함
                                    borderRadius: 8, // 배너의 모서리 반경을 8로 설정함
                                  ),
                                ),
                              ),
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색을 설정함
                              elevation: 0, // 카드뷰의 그림자 깊이를 0으로 설정함
                              padding: EdgeInsets.zero, // 패딩을 없앰
                            ),
                            SizedBox(height: profilePadding1Y), // 높이 profilePadding2Y로 간격 설정
                            // UserProfileOptions 위젯을 생성
                            UserProfileOptions(),
                            SizedBox(height: profilePadding2Y), // 높이 profilePadding2Y로 간격 설정
                            RichText(
                              text: TextSpan(
                                text: '* 개인정보 처리방침 관련 세부 내용은 공지사항에서 확인 가능합니다.',
                                style: TextStyle(
                                  fontFamily: 'NanumGothic',
                                  fontWeight: FontWeight.normal,
                                  fontSize: guideTextFontSize,
                                  color: BLACK_COLOR, // 검은색 텍스트
                                  decoration: TextDecoration.underline, // 밑줄 추가
                                ),
                              ),
                            ),
                            SizedBox(height: profilePadding3Y), // 높이 profilePadding3Y로 간격 설정
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
          // buildTopButton 함수는 주어진 context와 profileScreenPointScrollController를 사용하여
          // 화면 상단으로 스크롤하기 위한 버튼 생성 위젯이며, common_body_parts_layout.dart 내에 있는 곳에서 재사용하여 구현한 부분
          // buildTopButton(context, profileScreenPointScrollController),
        ],
      ),
      // 하단 탭 바 - 1번 케이스인 '홈','장바구니', '발주내역', '마이페이지' 버튼이 UI로 구현됨.
      bottomNavigationBar: buildCommonBottomNavigationBar(
          ref.watch(tabIndexProvider),
          ref,
          context,
          4, 1, scrollController: profileScreenPointScrollController), // 공통으로 사용되는 하단 네비게이션 바를 가져옴.
    );
    // ------ 화면구성 끝
  }
// ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 끝
// ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 끝
}
// _ProfileMainScreenState 클래스 끝
