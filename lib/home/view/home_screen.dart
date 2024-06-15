
// Dart의 IO 라이브러리에서 Platform 클래스를 가져옵니다. 이 클래스는 운영 체제에 대한 정보를 제공합니다.
import 'dart:io' show Platform;
// Dart 비동기 프로그래밍을 위한 라이브러리에서 Future와 Stream 등을 사용할 수 있게 합니다.
import 'dart:async';
// banner_model.dart 파일을 common 디렉토리에서 가져옵니다.
// 이 파일에는 배너와 관련된 데이터 모델이 정의되어 있을 것입니다.
// 'dongdaemoon_beta_v1' 프로젝트의 'common' 디렉토리 내에 위치한 'banner_model.dart' 파일을 가져옵니다.
import 'package:dongdaemoon_beta_v1/common/model/banner_model.dart';
// Firebase의 사용자 인증 기능을 사용하기 위한 패키지를 임포트합니다.
import 'package:firebase_auth/firebase_auth.dart';
// Flutter의 기본 디자인과 인터페이스 요소들을 사용하기 위한 Material 패키지를 임포트합니다.
import 'package:flutter/material.dart';
// 플랫폼 특정 기능을 제어하기 위한 서비스 인터페이스를 제공합니다.
import 'package:flutter/services.dart';
// Riverpod 패키지를 사용한 상태 관리 기능을 추가합니다. Riverpod는 상태 관리를 위한 외부 패키지입니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// url_launcher 패키지를 가져옵니다.
// 이 패키지는 Flutter 애플리케이션에서 URL을 열거나, 이메일, 전화, 문자 메시지 등을 실행할 수 있는 기능을 제공합니다.
// 예를 들어, 웹 브라우저에서 특정 웹 페이지를 열거나, 메일 앱을 열어 이메일을 작성하게 할 수 있습니다.
import 'package:url_launcher/url_launcher.dart';
// 공통적으로 사용될 상태 관리 로직을 포함하는 파일을 임포트합니다.
import '../../../common/provider/common_state_provider.dart';
// 애플리케이션의 공통 UI 컴포넌트를 구성하는 파일을 임포트합니다.
import '../../../common/layout/common_body_parts_layout.dart';
// 다양한 색상을 정의하는 파일을 임포트합니다.
import '../../common/const/colors.dart';
// 예외 발생 시 사용할 공통 UI 부분을 정의한 파일을 임포트합니다.
import '../../common/layout/common_exception_parts_of_body_layout.dart';
// common 디렉토리의 provider 폴더에 있는 common_future_provider.dart 파일을 가져옵니다.
// 이 파일은 Future Provider와 관련된 기능을 제공하는 파일입니다.
// 이를 통해 비동기 데이터 호출 및 상태 관리를 할 수 있습니다.
import '../../common/provider/common_future_provider.dart';
// 각 계절별 및 특별한 상품 카테고리에 대한 하위 페이지를 구현한 파일들을 임포트합니다.
import '../../product/layout/product_body_parts_layout.dart';
import '../../product/view/sub_main_screen/autumn_sub_main_screen.dart';
import '../../product/view/sub_main_screen/best_sub_main_screen.dart';
import '../../product/view/sub_main_screen/new_sub_main_screen.dart';
import '../../product/view/sub_main_screen/sale_sub_main_screen.dart';
import '../../product/view/sub_main_screen/spring_sub_main_screen.dart';
import '../../product/view/sub_main_screen/summer_sub_main_screen.dart';
import '../../product/view/sub_main_screen/winter_sub_main_screen.dart';
// 홈 화면 구성을 위한 레이아웃 파일을 임포트합니다.
import '../layout/home_body_parts_layout.dart';
// 현재 디렉토리의 부모 디렉토리에 위치한 provider 폴더에서 home_future_provider.dart 파일을 가져옵니다.
// 이 파일은 홈 화면과 관련된 Future Provider 기능을 제공합니다.
// 이를 통해 홈 화면에서 비동기 데이터를 호출하고 상태를 관리할 수 있습니다.
import '../provider/home_future_provider.dart';
// 홈 화면의 상태를 관리하기 위한 Provider 파일을 임포트합니다.
import '../provider/home_state_provider.dart';


// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용 권장
// GlobalKey 사용 시 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// HomeMainScreen 클래스는 ConsumerWidget 상속, Riverpod를 통한 상태 관리 지원
class HomeMainScreen extends ConsumerStatefulWidget {
  const HomeMainScreen({Key? key}) : super(key: key);
  @override
  _HomeMainScreenState createState() => _HomeMainScreenState();
}

// _HomeMainScreenState 클래스 시작
// _HomeMainScreenState 클래스는 HomeMainScreen 위젯의 상태를 관리함.
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

  // homeScrollControllerProvider에서 ScrollController를 읽어와서 scrollController에 할당
  // ref.read(homeScrollControllerProvider)는 provider를 이용해 상태를 읽는 방식.
  // ScrollController는 스크롤 가능한 위젯의 스크롤 동작을 제어하기 위해 사용됨.
  // 1.상단 탭바 버튼 클릭 시 해당 섹션으로 스크롤 이동하는 기능,
  // 2.하단 탭바의 홈 버튼 클릭 시 홈 화면 초기 위치로 스크롤 이동하는 기능,
  // 3.사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을때 마지막으로 본 위치로 자동으로 스크롤되도록 하는 기능,
  // 4.단순 스크롤을 내리거나 올릴 시, 상단 탭 바 버튼 텍스트 색상이 변경되도록 하는 기능,
  // 5. 'top' 버튼 클릭 시 홈 화면 초기 위치로 스크롤 이동하는 기능
  // => 5개의 기능인 전체 화면의 스크롤을 제어하는 컨트롤러-화면 내의 여러 섹션으로의 이동 역할

  // homeScrollControllerProvider : 여러 위젯에서 동일한 ScrollController를 공유하고,
  // 상태를 유지하기 위해 Riverpod의 Provider를 사용하여 관리함.
  // 이를 통해 앱의 다른 부분에서도 동일한 ScrollController에 접근할 수 있으며, 상태를 일관성 있게 유지함.
  // late ScrollController homeScreenPointScrollController = ref.read(homeScrollControllerProvider); // 스크롤 컨트롤러 선언
  // ScrollController를 late 변수로 선언
  // ScrollController가 여러 ScrollView에 attach 되어서 ScrollController가 동시에 여러 ScrollView에서 사용될 때 발생한 문제를 해결한 방법
  // => late로 변수 선언 / 해당 변수를 초기화(initState()) / 해당 변수를 해제 (dispose())
  late ScrollController homeScreenPointScrollController; // 스크롤 컨트롤러 선언

  // 상단 탭 바의 보이지 않는 버튼이 활성화될 시 자동으로 스크롤되는 기능만을 담당함.
  // 그러므로, 특정 조건에서만 사용되므로, 굳이 Provider를 통해 전역적으로 상태를 관리할 필요가 없음.
  // 즉, 단일 기능만을 담당하며 상태 관리의 필요성이 적기 때문에 단순히 ScrollController()를 직접 사용한 것임.
  // ScrollController를 late 변수로 선언
  // ScrollController가 여러 ScrollView에 attach 되어서 ScrollController가 동시에 여러 ScrollView에서 사용될 때 발생한 문제를 해결한 방법
  // => late로 변수 선언 / 해당 변수를 초기화(initState()) / 해당 변수를 해제 (dispose())
  late ScrollController homeTopBarPointAutoScrollController;

  // => homeScreenPointScrollController는 전체 화면의 스크롤을 제어함 vs homeTopBarPointAutoScrollController는 상단 탭 바의 스크롤을 제어함.
  // => 그러므로, 서로 다른 UI 요소 제어, 다른 동작 방식, _onScroll 함수 내 다르게 사용하므로 두 컨트롤러를 병합하면 복잡성 증가하고, 동작이 충돌할 수 있어 독립적으로 제작!!
  // => homeTopBarPointAutoScrollController는 전체 화면의 UI를 담당하는게 아니므로 scaffold의 body 내 컨트롤러에 연결이 안되어도 addListener()에 _onScroll()로 연결해놓은거라 해당 기능 사용이 가능!!

  // ------ 스크롤 이벤트가 발생할 때마다 호출되는 함수인 _onScroll() 내용 시작
  void _onScroll() {
    // 현재 스크롤 위치를 homeScreenPointScrollController의 offset 값으로부터 가져옴.
    double currentScroll = homeScreenPointScrollController.offset;
    // 현재 스크롤 위치에 따른 탭 인덱스를 계산함.
    int currentIndex = _determineCurrentTabIndex(currentScroll);
    // 계산된 탭 인덱스를 상태 관리 객체를 통해 업데이트 함.
    ref.read(homeCurrentTabProvider.notifier).state = currentIndex;

// '가을'이나 '겨울' 탭이 활성화될 때 자동 스크롤
    if (currentIndex >= 6) {
      // currentIndex가 6 이상인 경우 (즉, '가을'이나 '겨울' 탭이 활성화된 경우)

      // 스크롤 컨트롤러의 최대 스크롤 값을 offset에 저장
      double offset = homeTopBarPointAutoScrollController.position.maxScrollExtent;

      // 스크롤 애니메이션을 사용하여 homeTopBarPointAutoScrollController를 offset 위치로 이동
      homeTopBarPointAutoScrollController.animateTo(
        offset, // 이동할 위치 (최대 스크롤 값)
        duration: Duration(milliseconds: 50), // 애니메이션 시간 (50밀리초)
        curve: Curves.easeInOut, // 애니메이션 커브 (서서히 시작하고 서서히 끝나는 곡선)
      );
    } else if (currentIndex <= 1) {
      // currentIndex가 1 이하인 경우 (즉, 처음 몇 개의 탭이 활성화된 경우)

      // 스크롤 애니메이션을 사용하여 homeTopBarPointAutoScrollController를 0.0 위치로 이동 (맨 처음 위치)
      homeTopBarPointAutoScrollController.animateTo(
        0.0, // 이동할 위치 (맨 처음)
        duration: Duration(milliseconds: 50), // 애니메이션 시간 (50밀리초)
        curve: Curves.easeInOut, // 애니메이션 커브 (서서히 시작하고 서서히 끝나는 곡선)
      );
    }
  }
  // ------ 스크롤 이벤트가 발생할 때마다 호출되는 함수인 _onScroll() 내용 끝

  // ------ 스크롤 오프셋을 받아 현재의 탭 인덱스를 결정하는 함수인 _determineCurrentTabIndex 내용 시작
  int _determineCurrentTabIndex(double scrollOffset) {
    // 각 섹션의 스크롤 시작 위치를 배열로 정의함.
    // 이 배열의 각 요소는 각 섹션의 시작 스크롤 위치를 나타냄.
    const sectionOffsets = [0.0, 650.0, 910.0, 1170.0, 1530.0, 1790.0, 2150.0, 2410.0];

    // 섹션 오프셋 배열의 마지막 요소부터 처음 요소까지 역순으로 검사함.
    for (int i = sectionOffsets.length - 1; i >= 0; i--) {
      // 현재 스크롤 오프셋이 검사 중인 섹션의 시작 위치보다 크거나 같다면,
      if (scrollOffset >= sectionOffsets[i]) {
        // 현재 섹션의 인덱스를 반환함.
        return i;
      }
    }
    // 어떤 섹션의 시작 위치보다 현재 스크롤 위치가 작은 경우 첫 번째 섹션의 인덱스인 0을 반환함.
    return 0;
  }
  // ------ 스크롤 오프셋을 받아 현재의 탭 인덱스를 결정하는 함수인 _determineCurrentTabIndex 내용 끝

  // ------ 스크롤 위치를 업데이트하기 위한 '_updateScrollPosition' 함수 관련 구현 내용 시작
  // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동하는 위치를 저장하는거에 해당 부분도 추가하여
  // 사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을 때 마지막으로 본 위치로 자동으로 스크롤되도록 함.
  void _updateScrollPosition() {
    // 'homeScreenPointScrollController'에서 현재의 스크롤 위치(offset)를 가져와서 'currentScrollPosition' 변수에 저장함.
    double currentScrollPosition = homeScreenPointScrollController.offset;

    // 'ref'를 사용하여 'homeScrollPositionProvider'의 notifier를 읽어옴.
    // 읽어온 notifier의 'state' 값을 'currentScrollPosition'으로 설정함.
    // 이렇게 하면 앱의 다른 부분에서 해당 스크롤 위치 정보를 참조할 수 있게 됨.
    ref.read(homeScrollPositionProvider.notifier).state = currentScrollPosition;
  }
  // ------ 스크롤 위치를 업데이트하기 위한 '_updateScrollPosition' 함수 관련 구현 내용 끝

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // ScrollController를 초기화
    homeScreenPointScrollController = ScrollController();
    homeTopBarPointAutoScrollController = ScrollController();
    // initState에서 저장된 스크롤 위치로 이동
    // initState에서 실행되는 코드. initState는 위젯이 생성될 때 호출되는 초기화 단계
    // WidgetsBinding.instance.addPostFrameCallback 메서드를 사용하여 프레임 렌더링 후 콜백을 등록.
    // 스크롤 컨트롤러가 활성 상태인지 확인하고, 로그인 상태에 따라 저장된 스크롤 위치를 읽어 jumpTo 메서드로 이동.
    // homeScreenPointScrollController.addListener(_updateScrollPosition)를 통해 사용자가 스크롤할 때마다 스크롤 위치를 homeScrollPositionProvider에 저장.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 스크롤 컨트롤러가 활성 스크롤 뷰를 가지고 있는지 확인함.
      if (homeScreenPointScrollController.hasClients) {
        // 로그인 상태에 따라 다른 스크롤 위치로 설정
        double savedScrollPosition = FirebaseAuth.instance.currentUser != null
            ? ref.read(homeScrollPositionProvider)
            : ref.read(homeLoginAndLogoutScrollPositionProvider);
        homeScreenPointScrollController.jumpTo(savedScrollPosition);
      }
    });

    // 사용자가 스크롤할 때마다 현재의 스크롤 위치를 scrollPositionProvider에 저장하는 코드
    // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동하는 위치를 저장하는거에 해당 부분도 추가하여
    // 사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을 때 마지막으로 본 위치로 자동으로 스크롤되도록 함.
    homeScreenPointScrollController.addListener(_updateScrollPosition);

    // homeScreenPointScrollController에 스크롤 이벤트 리스너를 추가함.
    // 이 리스너는 사용자가 스크롤할 때마다 _onScroll 함수를 호출하도록 설정됨.
    homeScreenPointScrollController.addListener(_onScroll);

    // homeScreenPointScrollController.addListener(() {
    //   debugPrint('Scroll position: ${homeScreenPointScrollController.position.pixels}');
    //   _updateScrollPosition();
    //   _onScroll();
    // });

    // 큰 배너에 대한 PageController 및 AutoScroll 초기화
    // 'homeLargeBannerPageProvider'에서 초기 페이지 인덱스를 읽어옴
    _largeBannerPageController = PageController(initialPage: ref.read(homeLargeBannerPageProvider));

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
    // FirebaseAuth.instance.authStateChanges를 통해 로그인 상태 변화를 감지함.
    // 사용자가 로그아웃하면(user == null), 페이지 인덱스와 스크롤 위치를 초기화함.
    // 로그아웃 시 homeScrollPositionProvider가 초기화되므로, 재로그인 시 초기 스크롤 위치에서 시작됨. 하지만 섹션 내 데이터는 유지됨.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        ref.read(homeLargeBannerPageProvider.notifier).state = 0;
        ref.read(homeSmall1BannerPageProvider.notifier).state = 0;
        ref.read(homeSmall2BannerPageProvider.notifier).state = 0;
        ref.read(homeSmall3BannerPageProvider.notifier).state = 0;
        ref.read(homeScrollPositionProvider.notifier).state = 0.0; // 로그아웃 시 homeScrollPositionProvider가 초기화되므로, 재로그인 시 초기 스크롤 위치에서 시작됨. 하지만 섹션 내 데이터는 유지됨.
        ref.read(homeCurrentTabProvider.notifier).state = 0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
      }
    });

    // WidgetsBindingObserver를 추가하여 앱의 생명주기 변화 감지
    WidgetsBinding.instance.addObserver(this); // 생명주기 옵저버 등록

    // 상태표시줄 색상을 안드로이드와 ios 버전에 맞춰서 변경하는데 사용되는 함수-앱 실행 생명주기에 맞춰서 변경
    _updateStatusBar();

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
    if (state == AppLifecycleState.resumed) {
      _updateStatusBar();
    }
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

    // 'homeScreenPointScrollController'의 리스너 목록에서 '_updateScrollPosition' 함수를 제거함.
    // 이는 '_updateScrollPosition' 함수가 더 이상 스크롤 이벤트에 반응하지 않도록 설정함.
    homeScreenPointScrollController.removeListener(_updateScrollPosition);

    // homeScreenPointScrollController에서 _onScroll 함수를 리스너로서 제거함.
    // 이 작업은 더 이상 스크롤 이벤트에 반응하지 않도록 설정할 때 사용됨.
    homeScreenPointScrollController.removeListener(_onScroll);

    homeScreenPointScrollController.dispose(); // ScrollController 해제

    homeTopBarPointAutoScrollController.dispose(); // ScrollController 해제

    super.dispose(); // 위젯의 기본 정리 작업 수행
  }
  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 끝 (앱 실행 생명주기 관련 함수)
  // ------ 앱 실행 생명주기 관리 관련 함수 끝

  // 상태표시줄 색상을 안드로이드와 ios 버전에 맞춰서 변경하는데 사용되는 함수-앱 실행 생명주기에 맞춰서 변경
  void _updateStatusBar() {

    Color statusBarColor = BUTTON_COLOR;  // 여기서 원하는 색상을 지정

    if (Platform.isAndroid) {
      // 안드로이드에서는 상태표시줄 색상을 직접 지정
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: Brightness.light,
      ));
    } else if (Platform.isIOS) {
      // iOS에서는 앱 바 색상을 통해 상태표시줄 색상을 간접적으로 조정
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,  // 밝은 아이콘 사용
      ));
    }
  }

  // ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 시작
  @override
  Widget build(BuildContext context) {

    // 각 섹션의 스크롤 위치를 계산하는 함수
    double calculateScrollOffset(String sectionTitle) {
      switch (sectionTitle) {
        case '신상':  //260  360
          return 650.0; // '신상품 섹션'의 스크롤 위치
        case '최고':
          return 910.0; // '최고의 제품 섹션'의 스크롤 위치
        case '할인':
          return 1170.0; // '할인 제품 섹션'의 스크롤 위치
        case '봄':
          return 1530.0; // '봄 제품 섹션'의 스크롤 위치
        case '여름':
          return 1790.0; // '여름 제품 섹션'의 스크롤 위치
        case '가을':
          return 2150.0; // '가을 제품 섹션'의 스크롤 위치
        case '겨울':
          return 2410.0; // '겨울 제품 섹션'의 스크롤 위치
        default:
          return 0.0;  // 해당하지 않는 섹션의 경우 0.0으로 반환
      }
    }

    // 탭의 인덱스에 따라 해당하는 섹션 이름을 결정하는 String 변수 관련 함수
    String getSectionFromIndex(int index) {
      switch (index) {
        case 0: return '전체'; // 전체 항목
        case 1: return '신상'; // 신상품 항목
        case 2: return '최고'; // 최고의 제품 항목
        case 3: return '할인'; // 할인 제품 항목
        case 4: return '봄'; // 봄 제품 항목
        case 5: return '여름'; // 여름 제품 항목
        case 6: return '가을'; // 가을 제품 항목
        case 7: return '겨울'; // 겨울 제품 항목
        default: return '';
      }
    }

    // ------ common_body_parts_layout.dart 내 buildTopBarList, onTopBarTap 재사용하여 TopBar 구현 내용 시작
    // 탭을 탭했을 때 호출될 함수
    // 상단 탭 바를 구성하고 탭 선택 시 동작을 정의하는 함수
    // (common_parts.dart의 onTopBarTap 함수를 불러와 생성자를 만든 후 사용하는 개념이라 void인 함수는 함수명을 그대로 사용해야 함)
    // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 시작
    void onTopBarTap(int index) {

      String section = getSectionFromIndex(index);
      // 선택된 섹션에 따라 계산된 스크롤 오프셋으로 스크롤 이동
      double scrollToPosition = calculateScrollOffset(section);
      homeScreenPointScrollController.animateTo(
          scrollToPosition,
          duration: Duration(milliseconds: 500), // 이동에 걸리는 시간: 500 밀리초
          curve: Curves.easeInOut // 이동하는 동안의 애니메이션 효과: 시작과 끝이 부드럽게
      );
      // 스크롤 위치를 StateProvider에 저장
      ref.read(homeScrollPositionProvider.notifier).state = scrollToPosition;
    }
    // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 끝

    // 상단 탭 바를 구성하는 리스트 뷰를 가져오는 위젯
    // (common_parts.dart의 buildTopBarList 재사용 후 topBarList 위젯으로 재정의)
    Widget topBarList = buildTopBarList(context, onTopBarTap, homeCurrentTabProvider, homeTopBarPointAutoScrollController);
    // ------ common_body_parts_layout.dart 내 buildTopBarList, onTopBarTap 재사용하여 TopBar 구현 내용 끝

    // 큰 배너 클릭 시, 해당 링크로 이동하도록 하는 로직 관련 함수
    void _onLargeBannerTap(BuildContext context, int index) async {
      final url = largeBannerLinks[index];
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw '네트워크 오류';
      }
    }

    // 작은 배너1 클릭 시, 해당 링크로 이동하도록 하는 로직 관련 함수
    void _onSmall1BannerTap(BuildContext context, int index) async {
      final url = small1BannerLinks[index];
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw '네트워크 오류';
      }
    }

    // 작은 배너2 클릭 시, 해당 링크로 이동하도록 하는 로직 관련 함수
    void _onSmall2BannerTap(BuildContext context, int index) async {
      final url = small2BannerLinks[index];
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw '네트워크 오류';
      }
    }

    // 작은 배너3 클릭 시, 해당 링크로 이동하도록 하는 로직 관련 함수
    void _onSmall3BannerTap(BuildContext context, int index) async {
      final url = small3BannerLinks[index];
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw '네트워크 오류';
      }
    }

    // ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 시작
    // ------ 기존 buildCommonAppBar 위젯 내용과 동일하며,
    // 플러터 기본 SliverAppBar 위젯을 활용하여 앱 바의 상태 동적 UI 구현에 수월한 부분을 정의해서 해당 위젯을 바로 다른 화면에 구현하여
    // 기본 SliverAppBar의 드로워화면 토글 옵션을 삭제하는 등의 작업이 필요없는 방식-현재는 이슈가 있어 사용 안함..
    return Scaffold(
      body: Stack(
        children: [
        CustomScrollView(
          controller: homeScreenPointScrollController, // 스크롤 컨트롤러 연결
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
                  buttonCase: 2, // 2번 케이스 (찜 목록 버튼만 노출)
                ),
              ),
              leading: null, // 좌측 상단의 메뉴 버튼 등을 제거함.
              // iOS에서는 AppBar의 배경색을 사용
              // SliverAppBar 배경색 설정  // AppBar 배경을 투명하게 설정 -> 투명하게 해서 스크롤 내리면 다른 컨텐츠가 비쳐서 보이는 것!!
              backgroundColor: BUTTON_COLOR,
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
                      SizedBox(height: 5), // 높이 20으로 간격 설정
                      // 큰 배너 섹션을 카드뷰로 구성
                      CommonCardView(
                        content: SizedBox(
                          // buildCommonBannerPageViewSection 위젯의 높이를 200으로 설정함
                          height: 200,
                          // 카드뷰의 내용으로 buildCommonBannerPageViewSection 위젯을 재사용하여 구현함
                          child: buildCommonBannerPageViewSection<AllLargeBannerImage>(
                            // 현재 빌드 컨텍스트를 전달
                            context: context,
                            // Provider의 참조를 전달 (상태 관리를 위해 사용)
                            ref: ref,
                            // 현재 페이지를 관리하는 Provider를 전달
                            currentPageProvider: homeLargeBannerPageProvider,
                            // 페이지 컨트롤러를 전달 (페이지 전환을 관리)
                            pageController: _largeBannerPageController,
                            // 배너 자동 스크롤 기능을 전달
                            bannerAutoScroll: _largeBannerAutoScroll,
                            // 배너 링크들을 전달
                            bannerLinks: largeBannerLinks,
                            // 배너 이미지들을 관리하는 Provider를 전달
                            bannerImagesProvider: allLargeBannerImagesProvider,
                            // 배너를 탭했을 때 실행할 함수를 전달
                            onPageTap: _onLargeBannerTap,
                          ),
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
                          // buildCommonBannerPageViewSection 위젯의 높이를 60으로 설정함
                          height: 60,
                          // 카드뷰의 내용으로 buildCommonBannerPageViewSection 위젯을 재사용하여 구현함
                          child: buildCommonBannerPageViewSection<HomeSmall1BannerImage>(
                            // 현재 빌드 컨텍스트를 전달
                            context: context,
                            // Provider의 참조를 전달 (상태 관리를 위해 사용)
                            ref: ref,
                            // 현재 페이지를 관리하는 Provider를 전달
                            currentPageProvider: homeSmall1BannerPageProvider,
                            // 페이지 전환을 관리하는 페이지 컨트롤러를 전달
                            pageController: _small1BannerPageController,
                            // 배너 자동 스크롤 기능을 전달
                            bannerAutoScroll: _small1BannerAutoScroll,
                            // 배너에 사용될 링크들을 전달
                            bannerLinks: small1BannerLinks,
                            // 배너 이미지들을 관리하는 Provider를 전달
                            bannerImagesProvider: homeSmall1BannerImagesProvider,
                            // 배너를 탭했을 때 실행할 함수를 전달
                            onPageTap: _onSmall1BannerTap,
                          ),
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
                        _buildSectionCard(context, ref, "신상", buildNewProductsSection, NewSubMainScreen()),
                      SizedBox(height: 10), // 높이 10으로 간격 설정
                      // common_parts_layout.dart에 구현된 최고 관련 옷 상품 부분
                      // 베스트 제품 섹션
                        _buildSectionCard(context, ref, "최고", buildBestProductsSection, BestSubMainScreen()),
                      SizedBox(height: 10), // 높이 10으로 간격 설정
                      // common_parts_layout.dart에 구현된 할인 관련 옷 상품 부분
                      // 할인 제품 섹션
                        _buildSectionCard(context, ref, "할인", buildSaleProductsSection, SaleSubMainScreen()),
                      SizedBox(height: 15), // 높이 15로 간격 설정
                      // 두 번째 작은 배너 섹션
                      CommonCardView(
                        content: SizedBox(
                          // buildCommonBannerPageViewSection 위젯의 높이를 60으로 설정함
                          height: 60,
                          // 카드뷰의 내용으로 buildCommonBannerPageViewSection 위젯을 재사용하여 구현함
                          child: buildCommonBannerPageViewSection<HomeSmall2BannerImage>(
                            // 현재 빌드 컨텍스트를 전달
                            context: context,
                            // Provider의 참조를 전달 (상태 관리를 위해 사용)
                            ref: ref,
                            // 현재 페이지를 관리하는 Provider를 전달
                            currentPageProvider: homeSmall2BannerPageProvider,
                            // 페이지 전환을 관리하는 페이지 컨트롤러를 전달
                            pageController: _small2BannerPageController,
                            // 배너 자동 스크롤 기능을 전달
                            bannerAutoScroll: _small2BannerAutoScroll,
                            // 배너에 사용될 링크들을 전달
                            bannerLinks: small2BannerLinks,
                            // 배너 이미지들을 관리하는 Provider를 전달
                            bannerImagesProvider: homeSmall2BannerImagesProvider,
                            // 배너를 탭했을 때 실행할 함수를 전달
                            onPageTap: _onSmall2BannerTap,
                          ),
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
                        _buildSectionCard(context, ref, "봄", buildSpringProductsSection, SpringSubMainScreen()),
                      SizedBox(height: 10), // 높이 10으로 간격 설정
                      // common_parts_layout.dart에 구현된 여름 관련 옷 상품 부분
                        _buildSectionCard(context, ref, "여름", buildSummerProductsSection, SummerSubMainScreen()),
                      SizedBox(height: 15), // 높이 15로 간격 설정
                      CommonCardView(
                        content: SizedBox(
                          // buildCommonBannerPageViewSection 위젯의 높이를 60으로 설정함
                          height: 60,
                          // 카드뷰의 내용으로 buildCommonBannerPageViewSection 위젯을 재사용하여 구현함
                          child: buildCommonBannerPageViewSection<HomeSmall3BannerImage>(
                            // 현재 빌드 컨텍스트를 전달
                            context: context,
                            // Provider의 참조를 전달 (상태 관리를 위해 사용)
                            ref: ref,
                            // 현재 페이지를 관리하는 Provider를 전달
                            currentPageProvider: homeSmall3BannerPageProvider,
                            // 페이지 전환을 관리하는 페이지 컨트롤러를 전달
                            pageController: _small3BannerPageController,
                            // 배너 자동 스크롤 기능을 전달
                            bannerAutoScroll: _small3BannerAutoScroll,
                            // 배너에 사용될 링크들을 전달
                            bannerLinks: small3BannerLinks,
                            // 배너 이미지들을 관리하는 Provider를 전달
                            bannerImagesProvider: homeSmall3BannerImagesProvider,
                            // 배너를 탭했을 때 실행할 함수를 전달
                            onPageTap: _onSmall3BannerTap,
                          ),
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
                        _buildSectionCard(context, ref, "가을", buildAutumnProductsSection, AutumnSubMainScreen()),
                      SizedBox(height: 10), // 높이 10으로 간격 설정
                      // common_parts_layout.dart에 구현된 겨울 관련 옷 상품 부분
                        _buildSectionCard(context, ref, "겨울", buildWinterProductsSection, WinterSubMainScreen()),
                      SizedBox(height: 500), // 높이 15로 간격 설정
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
        // buildTopButton 함수는 주어진 context와 homeScreenPointScrollController를 사용하여
        // 화면 상단으로 스크롤하기 위한 버튼 생성 위젯이며, common_body_parts_layout.dart 내에 있는 곳에서 재사용하여 구현한 부분
        buildTopButton(context, homeScreenPointScrollController),
       ],
     ),
     bottomNavigationBar: buildCommonBottomNavigationBar(
      ref.watch(tabIndexProvider), ref, context), // 공통으로 사용되는 하단 네비게이션 바를 가져옴.
     drawer: buildCommonDrawer(context, ref), // 드로어 메뉴를 추가함.
   );
    // ------ 화면구성 끝
 }
// ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 끝
// ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 끝

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
