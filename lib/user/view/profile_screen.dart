

// Dart의 IO 라이브러리에서 Platform 클래스를 가져옵니다. 이 클래스는 운영 체제에 대한 정보를 제공합니다.
import 'dart:io' show Platform;
// Dart 비동기 프로그래밍을 위한 라이브러리에서 Future와 Stream 등을 사용할 수 있게 합니다.
import 'dart:async';
// Firebase의 사용자 인증 기능을 사용하기 위한 패키지를 임포트합니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../../common/const/colors.dart';
// 예외 발생 시 사용할 공통 UI 부분을 정의한 파일을 임포트합니다.
import '../../common/layout/common_exception_parts_of_body_layout.dart';
// banner_model.dart 파일을 common 디렉토리의 model 폴더에서 가져옵니다.
// 이 파일에는 배너와 관련된 데이터 모델이 정의되어 있을 것입니다.
import '../../common/model/banner_model.dart';
// common_future_provider.dart 파일을 common 디렉토리의 provider 폴더에서 가져옵니다.
// 이 파일에는 Future Provider와 관련된 기능이 정의되어 있을 것입니다.
import '../../common/provider/common_future_provider.dart';
// 프로필 화면의 상태를 관리하기 위한 Provider 파일을 임포트합니다.
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
class _ProfileMainScreenState extends ConsumerState<ProfileMainScreen> with WidgetsBindingObserver {

  // 큰 배너를 위한 페이지 컨트롤러
  late PageController _largeBannerPageController;
  // 큰 배너를 자동 스크롤하는 클래스
  late BannerAutoScrollClass _largeBannerAutoScroll;

  // 배너 이미지의 총 개수를 저장하는 변수
  int bannerImageCount = 3;

  // 배너 클릭 시 이동할 URL 리스트를 정의함.
  // 각 배너 클릭 시 연결될 웹사이트 주소를 리스트로 관리함.
  // 큰 배너 클릭 시 이동할 URL 목록
  final List<String> largeBannerLinks = [
    'https://www.naver.com', // 첫 번째 배너 클릭 시 네이버로 이동
    'https://www.youtube.com', // 두 번째 배너 클릭 시 유튜브로 이동
  ];

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

  // 상단 탭 바의 보이지 않는 버튼이 활성화될 시 자동으로 스크롤되는 기능만을 담당함.
  // 그러므로, 특정 조건에서만 사용되므로, 굳이 Provider를 통해 전역적으로 상태를 관리할 필요가 없음.
  // 즉, 단일 기능만을 담당하며 상태 관리의 필요성이 적기 때문에 단순히 ScrollController()를 직접 사용한 것임.
  // ScrollController를 late 변수로 선언
  // ScrollController가 여러 ScrollView에 attach 되어서 ScrollController가 동시에 여러 ScrollView에서 사용될 때 발생한 문제를 해결한 방법
  // => late로 변수 선언 / 해당 변수를 초기화(initState()) / 해당 변수를 해제 (dispose())
  late ScrollController profileTopBarPointAutoScrollController;

  // => cartScreenPointScrollController는 전체 화면의 스크롤을 제어함 vs cartTopBarPointAutoScrollController는 상단 탭 바의 스크롤을 제어함.
  // => 그러므로, 서로 다른 UI 요소 제어, 다른 동작 방식, _onScroll 함수 내 다르게 사용하므로 두 컨트롤러를 병합하면 복잡성 증가하고, 동작이 충돌할 수 있어 독립적으로 제작!!
  // => cartTopBarPointAutoScrollController는 전체 화면의 UI를 담당하는게 아니므로 scaffold의 body 내 컨트롤러에 연결이 안되어도 addListener()에 _onScroll()로 연결해놓은거라 해당 기능 사용이 가능!!


  // ------ 스크롤 이벤트가 발생할 때마다 호출되는 함수인 _onScroll() 내용 시작
  void _onScroll() {
    // 현재 스크롤 위치를 profileScreenPointScrollController의 offset 값으로부터 가져옴.
    double currentScroll = profileScreenPointScrollController.offset;
    // 현재 스크롤 위치에 따른 탭 인덱스를 계산함.
    int currentIndex = _determineCurrentTabIndex(currentScroll);
    // 계산된 탭 인덱스를 상태 관리 객체를 통해 업데이트 함.
    ref.read(profileCurrentTabProvider.notifier).state = currentIndex;

// '가을'이나 '겨울' 탭이 활성화될 때 자동 스크롤
    if (currentIndex >= 6) {
      // currentIndex가 6 이상인 경우 (즉, '가을'이나 '겨울' 탭이 활성화된 경우)

      // 스크롤 컨트롤러의 최대 스크롤 값을 offset에 저장
      double offset = profileTopBarPointAutoScrollController.position.maxScrollExtent;

      // 스크롤 애니메이션을 사용하여 profileTopBarPointAutoScrollController를 offset 위치로 이동
      profileTopBarPointAutoScrollController.animateTo(
        offset, // 이동할 위치 (최대 스크롤 값)
        duration: Duration(milliseconds: 50), // 애니메이션 시간 (50밀리초)
        curve: Curves.easeInOut, // 애니메이션 커브 (서서히 시작하고 서서히 끝나는 곡선)
      );
    } else if (currentIndex <= 1) {
      // currentIndex가 1 이하인 경우 (즉, 처음 몇 개의 탭이 활성화된 경우)

      // 스크롤 애니메이션을 사용하여 profileTopBarPointAutoScrollController를 0.0 위치로 이동 (맨 처음 위치)
      profileTopBarPointAutoScrollController.animateTo(
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
    // 'profileScreenPointScrollController'에서 현재의 스크롤 위치(offset)를 가져와서 'currentScrollPosition' 변수에 저장함.
    double currentScrollPosition = profileScreenPointScrollController.offset;

    // 'ref'를 사용하여 'profileScrollPositionProvider'의 notifier를 읽어옴.
    // 읽어온 notifier의 'state' 값을 'currentScrollPosition'으로 설정함.
    // 이렇게 하면 앱의 다른 부분에서 해당 스크롤 위치 정보를 참조할 수 있게 됨.
    ref.read(profileScrollPositionProvider.notifier).state = currentScrollPosition;
  }
  // ------ 스크롤 위치를 업데이트하기 위한 '_updateScrollPosition' 함수 관련 구현 내용 끝

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // ScrollController를 초기화
    profileScreenPointScrollController = ScrollController();
    profileTopBarPointAutoScrollController = ScrollController();
    // initState에서 저장된 스크롤 위치로 이동
    // initState에서 실행되는 코드. initState는 위젯이 생성될 때 호출되는 초기화 단계
    // WidgetsBinding.instance.addPostFrameCallback 메서드를 사용하여 프레임이 렌더링 된 후 콜백을 등록함.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 스크롤 컨트롤러가 활성 스크롤 뷰를 가지고 있는지 확인함.
      if (profileScreenPointScrollController.hasClients) {
        // savedScrollPosition 변수에 저장된 스크롤 위치를 읽어옴.
        // ref.read(scrollPositionProvider)는 Riverpod 상태 관리 라이브러리를 사용하여
        // scrollPositionProvider에서 마지막으로 저장된 스크롤 위치를 가져옴.
        double savedScrollPosition = ref.read(profileScrollPositionProvider);
        // profileScreenPointScrollController.jumpTo 메서드를 사용하여 스크롤 위치를 savedScrollPosition으로 즉시 이동함.
        // 이는 스크롤 애니메이션이나 다른 복잡한 동작 없이 바로 지정된 위치로 점프함.
        profileScreenPointScrollController.jumpTo(savedScrollPosition);
      }

      // tabIndexProvider의 상태를 하단 탭 바 내 마이페이지 버튼 인덱스인 3과 매핑
      // -> 마이페이지 화면 초기화 시, 하단 탭 바 내 마이페이지 버튼을 활성화
      ref.read(tabIndexProvider.notifier).state = 3;

    });
    // 사용자가 스크롤할 때마다 현재의 스크롤 위치를 scrollPositionProvider에 저장하는 코드
    // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동하는 위치를 저장하는거에 해당 부분도 추가하여
    // 사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을 때 마지막으로 본 위치로 자동으로 스크롤되도록 함.
    profileScreenPointScrollController.addListener(_updateScrollPosition);

    // profileScreenPointScrollController에 스크롤 이벤트 리스너를 추가함.
    // 이 리스너는 사용자가 스크롤할 때마다 _onScroll 함수를 호출하도록 설정됨.
    profileScreenPointScrollController.addListener(_onScroll);

    // 큰 배너에 대한 PageController 및 AutoScroll 초기화
    // 'profileLargeBannerPageProvider'에서 초기 페이지 인덱스를 읽어옴
    _largeBannerPageController = PageController(initialPage: ref.read(profileLargeBannerPageProvider));

    // 큰 배너를 자동으로 스크롤하는 기능 초기화
    _largeBannerAutoScroll = BannerAutoScrollClass(
      pageController: _largeBannerPageController,
      currentPageProvider: profileLargeBannerPageProvider,
      itemCount: bannerImageCount, // 총 배너 이미지 개수 전달
    );

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        ref.read(profileLargeBannerPageProvider.notifier).state = 0;
      }
    });

    // WidgetsBindingObserver를 추가하여 앱의 생명주기 변화 감지
    WidgetsBinding.instance.addObserver(this); // 생명주기 옵저버 등록

    // 상태표시줄 색상을 안드로이드와 ios 버전에 맞춰서 변경하는데 사용되는 함수-앱 실행 생명주기에 맞춰서 변경
    _updateStatusBar();

    // 배너 데이터 로드가 완료된 후 자동 스크롤 시작
    Future.delayed(Duration.zero, () {
      _largeBannerAutoScroll.startAutoScroll();
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
      // 앱이 백그라운드로 이동할 때, 배너의 자동 스크롤을 중지
    } else if (state == AppLifecycleState.paused) {
      _largeBannerAutoScroll.stopAutoScroll();
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

    // 사용자 인증 상태 감지 구독 해제함.
    authStateChangesSubscription?.cancel();

    // 'profileScreenPointScrollController'의 리스너 목록에서 '_updateScrollPosition' 함수를 제거함.
    // 이는 '_updateScrollPosition' 함수가 더 이상 스크롤 이벤트에 반응하지 않도록 설정함.
    profileScreenPointScrollController.removeListener(_updateScrollPosition);

    // profileScreenPointScrollController에서 _onScroll 함수를 리스너로서 제거함.
    // 이 작업은 더 이상 스크롤 이벤트에 반응하지 않도록 설정할 때 사용됨.
    profileScreenPointScrollController.removeListener(_onScroll);

    profileScreenPointScrollController.dispose(); // ScrollController 해제

    profileTopBarPointAutoScrollController.dispose(); // ScrollController 해제

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
        case '신상':
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
      profileScreenPointScrollController.animateTo(
          scrollToPosition,
          duration: Duration(milliseconds: 500), // 이동에 걸리는 시간: 500 밀리초
          curve: Curves.easeInOut // 이동하는 동안의 애니메이션 효과: 시작과 끝이 부드럽게
      );
      // 스크롤 위치를 StateProvider에 저장
      ref.read(profileScrollPositionProvider.notifier).state = scrollToPosition;
    }
    // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 끝

    // 상단 탭 바를 구성하는 리스트 뷰를 가져오는 위젯
    // (common_parts.dart의 buildTopBarList 재사용 후 topBarList 위젯으로 재정의)
    Widget topBarList = buildTopBarList(context, onTopBarTap, profileCurrentTabProvider, profileTopBarPointAutoScrollController);
    // ------ common_body_parts_layout.dart 내 buildTopBarList, onTopBarTap 재사용하여 TopBar 구현 내용 끝

    // 큰 배너 클릭 시, 해당 링크로 이동하도록 하는 로직 관련 함수
    void _onLargeBannerTap(BuildContext context, int index) async {
      // largeBannerLinks 리스트에서 index에 해당하는 URL을 가져옴.
      final url = largeBannerLinks[index];

      // 주어진 URL을 열 수 있는지 확인함.
      if (await canLaunchUrl(Uri.parse(url))) {
        // URL을 열 수 있다면, 해당 URL을 염.
        await launchUrl(Uri.parse(url));
      } else {
        // URL을 열 수 없다면 예외를 던짐.
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
            controller: profileScreenPointScrollController, // 스크롤 컨트롤러 연결
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
                    ref: ref,
                    title: '마이페이지',
                    leadingType: LeadingType.none, // 버튼 없음.
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
                              // 카드뷰의 내용을 설정
                              content: SizedBox(
                                // buildCommonBannerPageViewSection 위젯의 높이를 200으로 설정
                                height: 200,
                                // 카드뷰 내용으로 buildCommonBannerPageViewSection 위젯을 재사용하여 설정
                                child: buildCommonBannerPageViewSection<AllLargeBannerImage>(
                                  // 현재 빌드 컨텍스트를 전달
                                  context: context,
                                  // Provider의 참조를 전달 (상태 관리를 위해 사용)
                                  ref: ref,
                                  // 현재 페이지를 관리하는 Provider를 전달
                                  currentPageProvider: profileLargeBannerPageProvider,
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
                            SizedBox(height: 50), // 높이 임의로 50으로 간격 설정
                            Text('PROFILE 내용'),
                            // 로그인/로그아웃 버튼
                            ElevatedButton(
                              onPressed: () async {
                              // 로그아웃 처리
                                await FirebaseAuth.instance.signOut();
                              // 페이지 인덱스를 0으로 초기화
                                ref.read(currentPageProvider.notifier).state = 0;
                              // 로그아웃 후 로그인 화면으로 이동
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
                              },
                              child: Text('로그아웃'),
                            ),
                            // 항상 표시되는 회원가입 버튼
                            ElevatedButton(
                              onPressed: () {
                                 // 회원가입 페이지로 이동
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginScreen())); // 여기에 회원가입 화면 경로 필요
                              },
                              child: Text('회원가입'),
                            ),
                            // // 파이어베이스 내 파이어스토어 데이터베이스의 데이터 생성하는 로직 관련 버튼
                            // ElevatedButton(
                            //   onPressed: () async {
                            //     await createFirestoreDocuments();
                            //   },
                            //   child: Text('FireStore 문서 생성'),
                            // ),
                            SizedBox(height: 3000), // 높이 임의로 3000으로 간격 설정
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
          buildTopButton(context, profileScreenPointScrollController),
        ],
      ),
      bottomNavigationBar: buildCommonBottomNavigationBar(
          ref.watch(tabIndexProvider), ref, context, 4), // 공통으로 사용되는 하단 네비게이션 바를 가져옴.
    );
    // ------ 화면구성 끝
  }
// ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 끝
// ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 끝

// Firestore 문서를 생성하는 함수
  Future<void> createFirestoreDocuments() async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();
    const int originalPrice = 10000;

    final Map<int, String> briefIntroductionMap = {
    1: '해당 상품은 티셔츠입니다.',
    2: '해당 상품은 블라우스입니다.',
    3: '해당 상품은 맨투맨입니다.',
    4: '해당 상품은 니트입니다.',
    5: '해당 상품은 폴라티입니다.',
    6: '해당 상품은 원피스입니다.',
    7: '해당 상품은 팬츠입니다.',
    8: '해당 상품은 청바지입니다.',
    9: '해당 상품은 스커트입니다.',
    10: '해당 상품은 패딩입니다.',
    11: '해당 상품은 코트입니다.',
    12: '해당 상품은 가디건입니다.',
    };


    for (int i = 1; i <= 12; i++) {
      String docId = 'a$i';
      DocumentReference docRef = firestore.collection('couturier').doc(docId);
      String briefIntroduction = briefIntroductionMap[i] ?? '해당 상품은 설명이 없습니다.';

      for (int j = 1; j <= 7; j++) {
        String subCollectionId = 'a${i}b$j';
        CollectionReference subCollectionRef = docRef.collection(subCollectionId);

        for (int k = 1; k <= 15; k++) {
          int discountPercent = 9 + k; // k=1이면 10, k=2이면 11, ...
          int discountPrice = originalPrice - (originalPrice * discountPercent ~/ 100);
          String subDocId = 'a${i}b${j}_$k';
          DocumentReference subDocRef = subCollectionRef.doc(subDocId);

          batch.set(subDocRef, {
            'brief_introduction': briefIntroduction,
            'clothes_color1': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/clothes_color%2Fblack.png?alt=media&token=8eb2b83e-16f3-4921-9248-aeac08ba548b',
            'clothes_color2': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/clothes_color%2Fbrown.png?alt=media&token=c6742c7e-dc7f-4133-921e-86fca1a80441',
            'clothes_color3': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/clothes_color%2F%20lavender.png?alt=media&token=e8118999-064f-47b2-8f08-1055b5a886c3',
            'clothes_color4': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/clothes_color%2Fpink.png?alt=media&token=7abd298b-dc20-4f8e-88c2-f9aa8c4fc135',
            'clothes_color5': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/clothes_color%2Fyellow.png?alt=media&token=8a8158dd-66de-40f3-b5de-690059511261',
            'clothes_size1': 'S',
            'clothes_size2': 'M',
            'clothes_size3': 'L',
            'clothes_size4': 'XL',
            'color1_text': 'black',
            'color2_text': 'brown',
            'color3_text': 'lavender',
            'color4_text': 'pink',
            'color5_text': 'yellow',
            'detail_page_image1': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fflutter%2Fmtm1.png?alt=media&token=979c896f-29ba-4739-9725-5e3d84ad48af',
            'detail_page_image2': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fflutter%2Fmtm2.png?alt=media&token=2a2b915d-3d40-4ce6-8c92-0e4f1f64e6fb',
            'detail_page_image3': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fflutter%2Fmtm3.png?alt=media&token=db3c8ce7-81e2-4391-81b4-df9d475e201f',
            'detail_page_image4': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fflutter%2Fmtm4.png?alt=media&token=9ed3622d-c1c1-4366-bd78-23d33bc6f497',
            'detail_page_image5': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fflutter%2Fmtm5.png?alt=media&token=b220aa12-960f-4c67-811e-7c3cd4ceb073',
            'discount_percent': discountPercent,
            'discount_price': discountPrice,
            'original_price': originalPrice,
            'thumbnails': '',
          });
        }
      }
    }
    await batch.commit();
  }

}
// _ProfileMainScreenState 클래스 끝