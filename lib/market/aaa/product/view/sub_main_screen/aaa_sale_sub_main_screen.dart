// Dart의 IO 라이브러리에서 Platform 클래스를 가져옵니다. 이 클래스는 운영 체제에 대한 정보를 제공합니다.
import 'dart:io' show Platform;

// Dart의 비동기 프로그래밍 기능을 지원하는 'dart:async' 라이브러리를 가져옵니다.
// 이 라이브러리를 사용하여 Future와 Stream 객체를 통해 비동기 작업을 쉽게 처리할 수 있습니다.
import 'dart:async';

// Firebase의 사용자 인증 기능을 제공하는 FirebaseAuth 패키지를 임포트합니다.
// 이를 통해 이메일, 비밀번호, 소셜 미디어 계정을 이용한 로그인 기능 등을 구현할 수 있습니다.
import 'package:firebase_auth/firebase_auth.dart';

// Flutter의 기본 디자인 및 UI 요소를 제공하는 Material 디자인 패키지를 임포트합니다.
// 이 패키지는 버튼, 카드, 앱 바 등 다양한 머티리얼 디자인 위젯을 포함하고 있습니다.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 상태 관리를 위한 현대적인 라이브러리인 Riverpod를 임포트합니다.
// Riverpod는 애플리케이션의 상태를 효율적으로 관리하고, 상태 변화에 따라 UI를 자동으로 업데이트합니다.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod를 사용한 상태 관리를 위한 import

// 애플리케이션에서 발생할 수 있는 예외 상황을 처리하기 위한 공통 UI 레이아웃 파일을 임포트합니다.
// 이 레이아웃은 에러 발생 시 사용자에게 보여질 UI 컴포넌트를 정의합니다.
import '../../../../../cart/provider/cart_state_provider.dart';
import '../../../../../common/const/colors.dart';
import '../../../../../common/layout/common_body_parts_layout.dart';
import '../../../../../common/layout/common_exception_parts_of_body_layout.dart';
import '../../../../../common/model/banner_model.dart';
import '../../../../../common/provider/common_state_provider.dart';
import '../../../../../product/layout/product_body_parts_layout.dart';
import '../../../../../product/provider/product_state_provider.dart';
import '../../../../../wishlist/provider/wishlist_state_provider.dart';

// 애플리케이션의 여러 부분에서 재사용될 수 있는 공통 UI 컴포넌트 파일을 임포트합니다.
// 이 파일은 통일된 디자인과 구조를 제공하여 UI 개발을 효율적으로 할 수 있도록 돕습니다.
import '../../../common/layout/aaa_common_body_parts_layout.dart'; // 공통 UI 컴포넌트 파일

// 제품 상태 관리를 위해 사용되는 상태 제공자 파일을 임포트합니다.
// 이 파일은 제품 관련 데이터의 상태를 관리하고, 필요에 따라 상태를 업데이트하는 로직을 포함합니다.
import '../../../common/provider/aaa_common_all_provider.dart';
import '../../../home/provider/aaa_home_all_providers.dart';
import '../../layout/aaa_product_body_parts_layout.dart';
import '../../provider/aaa_product_all_providers.dart';
import '../../provider/aaa_product_state_provider.dart';


// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용 권장
// GlobalKey 사용 시 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// AaaSaleSubMainScreen 클래스는 ConsumerWidget 상속, Riverpod를 통한 상태 관리 지원
class AaaSaleSubMainScreen extends ConsumerStatefulWidget {
  const AaaSaleSubMainScreen({Key? key}) : super(key: key);

  @override
  _AaaSaleSubMainScreenState createState() => _AaaSaleSubMainScreenState();
}

// _AaaSaleSubMainScreenState 클래스 시작
// _AaaSaleSubMainScreenState 클래스는 AaaSaleSubMainScreen 위젯의 상태를 관리함.
// WidgetsBindingObserver 믹스인을 통해 앱 생명주기 상태 변화를 감시함.
class _AaaSaleSubMainScreenState extends ConsumerState<AaaSaleSubMainScreen>
    with WidgetsBindingObserver {
  // 큰 배너를 위한 페이지 컨트롤러
  late PageController _largeBannerPageController;

  // 큰 배너를 자동 스크롤하는 클래스
  late BannerAutoScrollClass _largeBannerAutoScroll;

  // 첫 번째 작은 배너를 위한 페이지 컨트롤러
  late PageController _small1BannerPageController;

  // 첫 번째 작은 배너를 자동 스크롤하는 클래스
  late BannerAutoScrollClass _small1BannerAutoScroll;

  // 배너 이미지의 총 개수를 저장하는 변수
  // 대배너
  int bannerImageCount1 = 5;

  // 소배너
  int bannerImageCount2 = 3;

  // 사용자 인증 상태 변경을 감지하는 스트림 구독 객체임.
  // 이를 통해 사용자 로그인 또는 로그아웃 상태 변경을 실시간으로 감지하고 처리할 수 있음.
  StreamSubscription<User?>? authStateChangesSubscription;

  // aaaSaleSubMainScrollControllerProvider에서 ScrollController를 읽어와서 scrollController에 할당
  // ref.read(aaaSaleSubMainScrollControllerProvider)는 provider를 이용해 상태를 읽는 방식.
  // ScrollController는 스크롤 가능한 위젯의 스크롤 동작을 제어하기 위해 사용됨.
  // 1.상단 탭바 버튼 클릭 시 해당 섹션으로 스크롤 이동하는 기능,
  // 2.하단 탭바의 버튼 클릭 시  화면 초기 위치로 스크롤 이동하는 기능,
  // 3.사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을때 마지막으로 본 위치로 자동으로 스크롤되도록 하는 기능,
  // 4.단순 스크롤을 내리거나 올릴 시, 상단 탭 바 버튼 텍스트 색상이 변경되도록 하는 기능,
  // 5. 'top' 버튼 클릭 시 홈 화면 초기 위치로 스크롤 이동하는 기능,
  // => 5개의 기능인 전체 화면의 스크롤을 제어하는 컨트롤러-화면 내의 여러 섹션으로의 이동 역할

  // aaaSaleSubMainScrollControllerProvider : 여러 위젯에서 동일한 ScrollController를 공유하고,
  // 상태를 유지하기 위해 Riverpod의 Provider를 사용하여 관리함.
  // 이를 통해 앱의 다른 부분에서도 동일한 ScrollController에 접근할 수 있으며, 상태를 일관성 있게 유지함.
  // ScrollController를 late 변수로 선언
  // ScrollController가 여러 ScrollView에 attach 되어서 ScrollController가 동시에 여러 ScrollView에서 사용될 때 발생한 문제를 해결한 방법
  // => late로 변수 선언 / 해당 변수를 초기화(initState()) / 해당 변수를 해제 (dispose())
  late ScrollController saleSubMainScreenPointScrollController; // 스크롤 컨트롤러 선언

  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  // ------ 스크롤 위치를 업데이트하기 위한 '_updateScrollPosition' 함수 관련 구현 내용 시작
  // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동하는 위치를 저장하는거에 해당 부분도 추가하여
  // 사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을 때 마지막으로 본 위치로 자동으로 스크롤되도록 함.
  void _updateScrollPosition() {
    // 'saleSubMainScreenPointScrollController'에서 현재의 스크롤 위치(offset)를 가져와서 'currentScrollPosition' 변수에 저장함.
    double currentScrollPosition =
        saleSubMainScreenPointScrollController.offset;

    // 'ref'를 사용하여 'aaaSaleSubMainScrollPositionProvider'의 notifier를 읽어옴.
    // 읽어온 notifier의 'state' 값을 'currentScrollPosition'으로 설정함.
    // 이렇게 하면 앱의 다른 부분에서 해당 스크롤 위치 정보를 참조할 수 있게 됨.
    ref.read(aaaSaleSubMainScrollPositionProvider.notifier).state =
        currentScrollPosition;
  }

  // ------ 스크롤 위치를 업데이트하기 위한 '_updateScrollPosition' 함수 관련 구현 내용 끝

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // ScrollController를 초기화
    saleSubMainScreenPointScrollController = ScrollController();
    // initState에서 저장된 스크롤 위치로 이동
    // initState에서 실행되는 코드. initState는 위젯이 생성될 때 호출되는 초기화 단계
    // WidgetsBinding.instance.addPostFrameCallback 메서드를 사용하여 프레임이 렌더링 된 후 콜백을 등록함.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 스크롤 컨트롤러가 활성 스크롤 뷰를 가지고 있는지 확인함.
      if (saleSubMainScreenPointScrollController.hasClients) {
        // savedScrollPosition 변수에 저장된 스크롤 위치를 읽어옴.
        // ref.read(scrollPositionProvider)는 Riverpod 상태 관리 라이브러리를 사용하여
        // scrollPositionProvider에서 마지막으로 저장된 스크롤 위치를 가져옴.
        double savedScrollPosition =
            ref.read(aaaSaleSubMainScrollPositionProvider);
        // saleSubMainScreenPointScrollController.jumpTo 메서드를 사용하여 스크롤 위치를 savedScrollPosition으로 즉시 이동함.
        // 이는 스크롤 애니메이션이나 다른 복잡한 동작 없이 바로 지정된 위치로 점프함.
        saleSubMainScreenPointScrollController.jumpTo(savedScrollPosition);
      }

      // tabIndexProvider의 상태를 하단 탭 바 내 버튼과 매칭이 되면 안되므로 0~3이 아닌 -1로 매핑
      // -> 할인 섹션 더보기 화면 초기화 시, 하단 탭 바 내 모든 버튼 비활성화
      ref.read(tabIndexProvider.notifier).state = -1;
      ref.invalidate(wishlistItemProvider); // 찜 목록 데이터 초기화
      ref.invalidate(cartItemCountProvider); // 장바구니 아이템 갯수 데이터 초기화
      ref.invalidate(wishlistItemCountProvider); // 찜 목록 아이템 갯수 데이터 초기화
    });
    // 사용자가 스크롤할 때마다 현재의 스크롤 위치를 saleSubMainScreenPointScrollController에 저장하는 코드
    // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동하는 위치를 저장하는거에 해당 부분도 추가하여
    // 사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을 때 마지막으로 본 위치로 자동으로 스크롤되도록 함.
    saleSubMainScreenPointScrollController.addListener(_updateScrollPosition);

    // 큰 배너에 대한 PageController 및 AutoScroll 초기화
    // 'aaaSaleSubMainLargeBannerPageProvider'에서 초기 페이지 인덱스를 읽어옴
    _largeBannerPageController = PageController(
        initialPage: ref.read(aaaSaleSubMainLargeBannerPageProvider));

    // 큰 배너를 자동으로 스크롤하는 기능 초기화
    _largeBannerAutoScroll = BannerAutoScrollClass(
      pageController: _largeBannerPageController,
      currentPageProvider: aaaSaleSubMainLargeBannerPageProvider,
      itemCount: bannerImageCount1, // 총 배너 이미지 개수 전달
    );

    // 작은 배너1에 대한 PageController 및 AutoScroll 초기화
    // 'aaaSaleSubMainSmall1BannerPageProvider'에서 초기 페이지 인덱스를 읽어옴
    _small1BannerPageController = PageController(
        initialPage: ref.read(aaaSaleSubMainSmall1BannerPageProvider));

    // 작은 배너1을 자동으로 스크롤하는 기능 초기화
    _small1BannerAutoScroll = BannerAutoScrollClass(
      pageController: _small1BannerPageController,
      currentPageProvider: aaaSaleSubMainSmall1BannerPageProvider,
      itemCount: bannerImageCount2, // 총 배너 이미지 개수 전달
    );

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        ref.read(aaaSaleSubMainLargeBannerPageProvider.notifier).state =
            0; // 대배너 페이지 초기화
        ref.read(aaaSaleSubMainSmall1BannerPageProvider.notifier).state =
            0; // 소배너 페이지 초기화
        ref.read(aaaSaleSubMainScrollPositionProvider.notifier).state =
            0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
        ref
            .read(aaaSaleSubMainProductListProvider.notifier)
            .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
        ref.read(aaaSaleSubMainSortButtonProvider.notifier).state =
            ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
        ref.invalidate(wishlistItemProvider); // 찜 목록 데이터 초기화
        ref.invalidate(cartItemCountProvider); // 장바구니 아이템 갯수 데이터 초기화
        ref.invalidate(wishlistItemCountProvider); // 찜 목록 아이템 갯수 데이터 초기화
      }
    });

    // WidgetsBindingObserver를 추가하여 앱의 생명주기 변화 감지
    WidgetsBinding.instance.addObserver(this); // 생명주기 옵저버 등록

    // 상태표시줄 색상을 안드로이드와 ios 버전에 맞춰서 변경하는데 사용되는 함수-앱 실행 생명주기에 맞춰서 변경
    updateStatusBar();

    // 배너 데이터 로드가 완료된 후 자동 스크롤 시작
    Future.delayed(Duration.zero, () {
      _largeBannerAutoScroll.startAutoScroll();
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
      _largeBannerAutoScroll.startAutoScroll();
      _small1BannerAutoScroll.startAutoScroll();
      // 앱이 백그라운드로 이동할 때, 배너의 자동 스크롤을 중지
    } else if (state == AppLifecycleState.paused) {
      _largeBannerAutoScroll.stopAutoScroll();
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
    _largeBannerPageController.dispose();
    _largeBannerAutoScroll.stopAutoScroll();

    _small1BannerPageController.dispose();
    _small1BannerAutoScroll.stopAutoScroll();

    // 사용자 인증 상태 감지 구독 해제함.
    authStateChangesSubscription?.cancel();

    // 'saleSubMainScreenPointScrollController'의 리스너 목록에서 '_updateScrollPosition' 함수를 제거함.
    // 이는 '_updateScrollPosition' 함수가 더 이상 스크롤 이벤트에 반응하지 않도록 설정함.
    saleSubMainScreenPointScrollController
        .removeListener(_updateScrollPosition);

    saleSubMainScreenPointScrollController.dispose(); // ScrollController 해제

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

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 대배너 부분 관련 수치
    final double saleSubMainScreenLargeBannerWidth =
        screenSize.width * (393 / referenceWidth); // 대배너 이미지 너비
    final double saleSubMainScreenLargeBannerHeight =
        screenSize.height * (378 / referenceHeight); // 대배너 이미지 높이
    final double saleSubMainLargeBannerViewHeight =
        screenSize.height * (378 / referenceHeight); // 대배너 화면 세로 비율

    // 소배너 부분 관련 수치
    final double saleSubMainScreenSmallBannerWidth =
        screenSize.width * (361 / referenceWidth); // 소배너 이미지 너비
    final double saleSubMainScreenSmallBannerHeight =
        screenSize.height * (90 / referenceHeight); // 소배너 이미지 높이
    final double saleSubMainScreenSmallBannerViewHeight =
        screenSize.height * (90 / referenceHeight); // 소배너 화면 세로 비율

    // AppBar 관련 수치 동적 적용
    final double sectionPlusAppBarTitleWidth =
        screenSize.width * (240 / referenceWidth);
    final double sectionPlusAppBarTitleHeight =
        screenSize.height * (22 / referenceHeight);
    final double sectionPlusAppBarTitleX =
        screenSize.height * (4 / referenceHeight);
    final double sectionPlusAppBarTitleY =
        screenSize.height * (11 / referenceHeight);

    // 이전화면으로 이동 아이콘 관련 수치 동적 적용
    final double sectionPlusChevronIconWidth =
        screenSize.width * (24 / referenceWidth);
    final double sectionPlusChevronIconHeight =
        screenSize.height * (24 / referenceHeight);
    final double sectionPlusChevronIconX =
        screenSize.width * (10 / referenceWidth);
    final double sectionPlusChevronIconY =
        screenSize.height * (9 / referenceHeight);

    // 찜 목록 버튼 수치 (Case 2)
    final double sectionPlusWishlistBtnWidth =
        screenSize.width * (40 / referenceWidth);
    final double sectionPlusWishlistBtnHeight =
        screenSize.height * (40 / referenceHeight);
    final double sectionPlusWishlistBtnX =
        screenSize.width * (10 / referenceWidth);
    final double sectionPlusWishlistBtnY =
        screenSize.height * (7 / referenceHeight);

    // 컨텐츠 사이의 높이 수치
    final double interval1Y = screenSize.height * (3 / referenceHeight);
    final double interval2Y = screenSize.height * (10 / referenceHeight);

    // ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 시작
    // ------ 기존 buildCommonAppBar 위젯 내용과 동일하며,
    // 플러터 기본 SliverAppBar 위젯을 활용하여 앱 바의 상태 동적 UI 구현에 수월한 부분을 정의해서 해당 위젯을 바로 다른 화면에 구현하여
    // 기본 SliverAppBar의 드로워화면 토글 옵션을 삭제하는 등의 작업이 필요없는 방식-현재는 이슈가 있어 사용 안함..
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: saleSubMainScreenPointScrollController, // 스크롤 컨트롤러 연결
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
                      title: '특가상품 섹션',
                      // AppBar의 제목을 '특가상품 섹션'으로 설정
                      fontFamily: 'NanumGothic',
                      leadingType: LeadingType.back,
                      // AppBar의 리딩 타입을 뒤로가기 버튼으로 설정
                      buttonCase: 2,
                      // 버튼 케이스를 2로 설정
                      appBarTitleWidth: sectionPlusAppBarTitleWidth,
                      appBarTitleHeight: sectionPlusAppBarTitleHeight,
                      appBarTitleX: sectionPlusAppBarTitleX,
                      appBarTitleY: sectionPlusAppBarTitleY,
                      chevronIconWidth: sectionPlusChevronIconWidth,
                      chevronIconHeight: sectionPlusChevronIconHeight,
                      chevronIconX: sectionPlusChevronIconX,
                      chevronIconY: sectionPlusChevronIconY,
                      wishlistBtnWidth: sectionPlusWishlistBtnWidth,
                      wishlistBtnHeight: sectionPlusWishlistBtnHeight,
                      wishlistBtnX: sectionPlusWishlistBtnX,
                      wishlistBtnY: sectionPlusWishlistBtnY,
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
                padding: EdgeInsets.only(top: 0),
                // SliverList를 사용하여 목록 아이템을 동적으로 생성함.
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        // 각 항목의 좌우 간격을 4.0으로 설정함.
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Column(
                          children: [
                            // Container(
                            //   decoration: BoxDecoration(
                            //     border: Border(
                            //       bottom: BorderSide(
                            //           color: BLACK_COLOR,
                            //           width: 1.0), // 하단 테두리 색상을 설정함
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(height: 5), // 5의 높이를 가진 간격 추가
                            // 큰 배너 섹션을 카드뷰로 구성
                            CommonCardView(
                              content: Container(
                                // 모서리에 반경을 주기 위한 BoxDecoration 추가함
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      0), // 큰 배너의 모서리 반경을 0으로 설정함
                                  border: Border(
                                    bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
                                  ),
                                ),
                                child: SizedBox(
                                  // 배너 섹션의 높이를 200으로 설정함
                                  height: saleSubMainLargeBannerViewHeight,
                                  // 배너 섹션의 내용을 buildCommonBannerPageViewSection 위젯으로 재사용하여 구현함
                                  child: buildCommonBannerPageViewSection<
                                      AllLargeBannerImage>(
                                    context: context,
                                    // 위젯 트리를 위한 빌드 컨텍스트 전달함
                                    ref: ref,
                                    // 상태 관리를 위한 참조 전달함
                                    currentPageProvider:
                                        aaaSaleSubMainLargeBannerPageProvider,
                                    // 큰 배너 페이지의 상태 제공자를 전달함
                                    pageController: _largeBannerPageController,
                                    // 배너 페이지의 스크롤을 제어할 컨트롤러를 전달함
                                    bannerAutoScroll: _largeBannerAutoScroll,
                                    // 배너의 자동 스크롤 설정을 전달함
                                    bannerImagesProvider:
                                    aaaAllLargeBannerImagesProvider,
                                    // 배너 이미지의 상태 제공자를 전달함
                                    // 배너를 탭했을 때 실행할 함수를 전달
                                    onPageTap: (context, index) =>
                                        // 대배너 클릭 시 호출할 함수 aaaOnLargeBannerTap 실행
                                        aaaOnLargeBannerTap(
                                            context, // 현재 화면의 컨텍스트를 전달함
                                            index, // 클릭된 배너의 인덱스를 전달함
                                            // aaaAllLargeBannerImagesProvider에서 대배너 이미지 리스트를 가져옴. 값이 없으면 빈 리스트를 사용함
                                            ref
                                                    .watch(
                                                aaaAllLargeBannerImagesProvider)
                                                    .value ??
                                                [],
                                            ref // Provider의 참조를 전달함
                                            ),
                                    width: saleSubMainScreenLargeBannerWidth,
                                    // 배너 섹션의 너비를 설정함
                                    height: saleSubMainScreenLargeBannerHeight,
                                    // 배너 섹션의 높이를 설정함
                                    borderRadius: 0, // 배너의 모서리 반경을 0으로 설정함
                                  ),
                                ),
                              ),
                              backgroundColor: Theme.of(context)
                                  .scaffoldBackgroundColor, // 앱 기본 배경색을 설정함
                              elevation: 4, // 카드뷰의 그림자 깊이를 설정함
                              padding: EdgeInsets.zero, // 카드뷰의 패딩을 없앰
                            ),
                            SizedBox(height: interval2Y),
                            // interval2Y의 높이를 가진 간격을 추가함
                            CommonCardView(
                              content: Container(
                                // 모서리에 반경을 주기 위한 BoxDecoration 추가함
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      8), // 작은 배너의 모서리 반경을 8로 설정함
                                ),
                                child: SizedBox(
                                  // 작은 배너 섹션의 높이를 60으로 설정함
                                  height:
                                      saleSubMainScreenSmallBannerViewHeight,
                                  // 작은 배너 섹션의 내용을 buildCommonBannerPageViewSection 위젯으로 재사용하여 구현함
                                  child: buildCommonBannerPageViewSection<
                                      AllSmallBannerImage>(
                                    context: context,
                                    // 위젯 트리를 위한 빌드 컨텍스트 전달함
                                    ref: ref,
                                    // 상태 관리를 위한 참조 전달함
                                    currentPageProvider:
                                        aaaSaleSubMainSmall1BannerPageProvider,
                                    // 작은 배너 페이지의 상태 제공자를 전달함
                                    pageController: _small1BannerPageController,
                                    // 작은 배너 페이지의 스크롤을 제어할 컨트롤러를 전달함
                                    bannerAutoScroll: _small1BannerAutoScroll,
                                    // 작은 배너의 자동 스크롤 설정을 전달함
                                    bannerImagesProvider:
                                        aaaSaleSubMainSmall1BannerImagesProvider,
                                    // 작은 배너 이미지의 상태 제공자를 전달함
                                    // 배너를 탭했을 때 실행할 함수를 전달
                                    onPageTap: (context, index) =>
                                        // 소배너 클릭 시 호출할 함수 aaaOnSmallBannerTap 실행
                                        aaaOnSmallBannerTap(
                                            context, // 현재 화면의 컨텍스트를 전달함
                                            index, // 클릭된 배너의 인덱스를 전달함
                                            // aaaCardiganMainSmall1BannerImagesProvider에서 대배너 이미지 리스트를 가져옴. 값이 없으면 빈 리스트를 사용함
                                            ref
                                                    .watch(
                                                        aaaCardiganMainSmall1BannerImagesProvider)
                                                    .value ??
                                                [],
                                            ref // Provider의 참조를 전달함
                                            ),
                                    width: saleSubMainScreenSmallBannerWidth,
                                    // 작은 배너 섹션의 너비를 설정함
                                    height: saleSubMainScreenSmallBannerHeight,
                                    // 작은 배너 섹션의 높이를 설정함
                                    borderRadius: 8, // 작은 배너의 모서리 반경을 8로 설정함
                                  ),
                                ),
                              ),
                              backgroundColor: Theme.of(context)
                                  .scaffoldBackgroundColor, // 앱 기본 배경색을 설정함
                              elevation: 0, // 카드뷰의 그림자 깊이를 0으로 설정함
                              padding: const EdgeInsets.fromLTRB(
                                  16.0,
                                  0.0,
                                  16.0,
                                  0.0), // 카드뷰의 좌우 패딩을 16.0으로 설정하고 상하 패딩을 없앰
                            ),
                            SizedBox(height: interval2Y), // interval1Y의 높이를 가진 간격 추가
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
                                ),
                              ),
                            ),
                            SizedBox(height: interval1Y),
                            AaaPriceAndDiscountPercentSortButtons<
                                AaaSectionMoreProductListNotifier>(
                              productListProvider:
                                  aaaSaleSubMainProductListProvider,
                              // 특가 상품 제품 리스트 프로바이더 전달
                              sortButtonProvider:
                                  aaaSaleSubMainSortButtonProvider, // 할인 정렬 버튼 프로바이더 전달
                            ),
                            // 가격 및 할인 정렬 버튼 추가
                            SizedBox(height: interval1Y),
                            // AaaGeneralProductList 위젯을 생성, AaaSectionMoreProductListNotifier를 사용
                            AaaGeneralProductList<AaaSectionMoreProductListNotifier>(
                              // 스크롤 컨트롤러를 설정 (특가 상품 섹션의 스크롤 컨트롤러)
                              scrollController:
                                  saleSubMainScreenPointScrollController,
                              // 상품 리스트 프로바이더를 설정 (특가 상품 섹션의 상품 리스트 프로바이더)
                              productListProvider:
                                  aaaSaleSubMainProductListProvider,
                              // 카테고리를 '특가 상품'으로 설정
                              category: '특가 상품',
                            ),
                            SizedBox(height: interval1Y),
                            // interval1Y의 높이를 가진 간격 추가
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
          // buildTopButton 함수는 주어진 context와 saleSubMainScreenPointScrollController를 사용하여
          // 화면 상단으로 스크롤하기 위한 버튼 생성 위젯이며, common_body_parts_layout.dart 내에 있는 곳에서 재사용하여 구현한 부분
          buildTopButton(context, saleSubMainScreenPointScrollController),
        ],
      ),
      // 하단 탭 바 - 1번 케이스인 '홈','장바구니', '발주내역', '마이페이지' 버튼이 UI로 구현됨.
      bottomNavigationBar: buildCommonBottomNavigationBar(
          ref.watch(tabIndexProvider), ref, context, 5, 1,
          scrollController: saleSubMainScreenPointScrollController),
      // 공통으로 사용되는 하단 네비게이션 바를 가져옴.
      drawer: buildCommonDrawer(context, ref), // 드로어 메뉴를 추가함.
    );
    // ------ 화면구성 끝
  }
// ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 끝
// ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 끝
}
// _AaaCartMainScreenState 클래스 끝
