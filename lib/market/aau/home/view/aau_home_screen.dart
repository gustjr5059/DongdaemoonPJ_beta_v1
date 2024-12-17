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

// 공통적으로 사용될 상태 관리 로직을 포함하는 파일을 임포트합니다.
import '../../../../../cart/provider/cart_state_provider.dart';
import '../../../../../common/const/colors.dart';
import '../../../../../common/layout/common_body_parts_layout.dart';
import '../../../../../common/layout/common_exception_parts_of_body_layout.dart';
import '../../../../../common/provider/common_state_provider.dart';
import '../../../../../wishlist/provider/wishlist_state_provider.dart';
import '../../../../home/layout/home_body_parts_layout.dart';
import '../../common/layout/aau_common_body_parts_layout.dart';
import '../../common/provider/aau_common_all_provider.dart';
import '../../product/provider/aau_product_all_providers.dart';
import '../../product/view/sub_main_screen/aau_autumn_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aau_best_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aau_new_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aau_sale_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aau_spring_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aau_summer_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aau_winter_sub_main_screen.dart';
import '../layout/aau_home_body_parts_layout.dart';

// 현재 디렉토리의 부모 디렉토리에 위치한 provider 폴더에서 aab_home_all_providers.dart 파일을 가져옵니다.
// 이 파일은 홈 화면과 관련된 Future Provider 기능을 제공합니다.
// 이를 통해 홈 화면에서 비동기 데이터를 호출하고 상태를 관리할 수 있습니다.
import '../provider/aau_home_all_providers.dart';

// 홈 화면의 상태를 관리하기 위한 Provider 파일을 임포트합니다.
import '../provider/aau_home_state_provider.dart';

// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용 권장
// GlobalKey 사용 시 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// AauHomeMainScreen 클래스는 ConsumerWidget 상속, Riverpod를 통한 상태 관리 지원
class AauHomeMainScreen extends ConsumerStatefulWidget {
  const AauHomeMainScreen({Key? key}) : super(key: key);

  @override
  _AauHomeMainScreenState createState() => _AauHomeMainScreenState();
}

// _AauHomeMainScreenState 클래스 시작
// _AauHomeMainScreenState 클래스는 AauHomeMainScreen 위젯의 상태를 관리함.
// WidgetsBindingObserver 믹스인을 통해 앱 생명주기 상태 변화를 감시함.
class _AauHomeMainScreenState extends ConsumerState<AauHomeMainScreen>
    with WidgetsBindingObserver {
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
  // 대배너
  int bannerImageCount1 = 5;
  // 소배너
  int bannerImageCount2 = 3;

  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

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

  // 기존의 int currentIndex 선언 대신 ref로 상태를 읽어오기 위한 변수 선언
  late int currentIndex;

  // 각 섹션에 대한 GlobalKey를 정의함.
  // GlobalKey를 사용하여 각 섹션의 위치를 추적함.
  final GlobalKey scrollKey = GlobalKey(); // '전체' 섹션의 키
  final GlobalKey sectionNewKey = GlobalKey(); // '신상' 섹션의 키
  final GlobalKey sectionBestSellerKey = GlobalKey(); // '베스트 셀러' 섹션의 키
  final GlobalKey sectionSaleKey = GlobalKey(); // '특가 상품' 섹션의 키
  final GlobalKey sectionSpringKey = GlobalKey(); // '봄' 섹션의 키
  final GlobalKey sectionSummerKey = GlobalKey(); // '여름' 섹션의 키
  final GlobalKey sectionAutumnKey = GlobalKey(); // '가을' 섹션의 키
  final GlobalKey sectionWinterKey = GlobalKey(); // '겨울' 섹션의 키
  final GlobalKey sectionEventKey = GlobalKey(); // '이벤트' 섹션의 키

  // ------ 선택된 섹션에 따라 GlobalKey를 반환하는 함수 내용 시작
  // 선택된 섹션 인덱스에 따라 해당하는 GlobalKey를 반환함.
  GlobalKey _getSectionKey(int index) {
    switch (index) {
      case 1:
        return sectionNewKey; // '신상' 섹션의 GlobalKey를 반환함.
      case 2:
        return sectionBestSellerKey; // '베스트 셀러' 섹션의 GlobalKey를 반환함.
      case 3:
        return sectionSaleKey; // '특가 상품' 섹션의 GlobalKey를 반환함.
      case 4:
        return sectionSpringKey; // '봄' 섹션의 GlobalKey를 반환함.
      case 5:
        return sectionSummerKey; // '여름' 섹션의 GlobalKey를 반환함.
      case 6:
        return sectionAutumnKey; // '가을' 섹션의 GlobalKey를 반환함.
      case 7:
        return sectionWinterKey; // '겨울' 섹션의 GlobalKey를 반환함.
      case 8:
        return sectionEventKey; // '이벤트' 섹션의 GlobalKey를 반환함.
      default:
        return scrollKey; // 기본값으로 '전체' 섹션의 GlobalKey를 반환함.
    }
  }

  // ------ 선택된 섹션에 따라 GlobalKey를 반환하는 함수 내용 끝

  // ------ 스크롤 이벤트가 발생할 때마다 호출되는 함수인 _onScroll() 내용 시작
  // 스크롤이 발생할 때마다 현재 탭 인덱스를 계산하여 상태를 업데이트함.
  void _onScroll() {
    // 현재 탭 인덱스를 선언 (_determineCurrentTabIndex(context) 값으로 지정)
    int newCurrentIndex = _determineCurrentTabIndex(context);
    if (newCurrentIndex != currentIndex) {
      // 현재 인덱스가 변경된 경우
      currentIndex = newCurrentIndex; // 현재 인덱스를 갱신함
      ref.read(aauHomeCurrentTabProvider.notifier).state = currentIndex; // 상태 업데이트
    }

    // '봄'이나 '여름' 탭이 활성화될 때 자동 스크롤
    if (currentIndex >= 4) {
      // currentIndex가 4 이상인 경우 (즉, '봄'이나 '여름' 탭이 활성화된 경우)
      // 스크롤 컨트롤러의 최대 스크롤 값을 offset에 저장
      double offset =
          homeTopBarPointAutoScrollController.position.maxScrollExtent;

      // 스크롤 애니메이션을 사용하여 homeTopBarPointAutoScrollController를 offset 위치로 이동
      homeTopBarPointAutoScrollController.animateTo(
        offset, // 이동할 위치 (최대 스크롤 값)
        duration: Duration(milliseconds: 50), // 애니메이션 시간 (50밀리초)
        curve: Curves.easeInOut, // 애니메이션 커브 (서서히 시작하고 서서히 끝나는 곡선)
      );
    } else if (currentIndex <= 1) {
      // currentIndex가 1 이하인 경우 (처음 몇 개의 탭이 활성화된 경우)
      // 스크롤 애니메이션을 사용하여 homeTopBarPointAutoScrollController를 0.0 위치로 이동 (맨 처음 위치)
      homeTopBarPointAutoScrollController.animateTo(
        0.0, // 이동할 위치 (맨 처음)
        duration: Duration(milliseconds: 50), // 애니메이션 시간 (50밀리초)
        curve: Curves.easeInOut, // 애니메이션 커브 (서서히 시작하고 서서히 끝나는 곡선)
      );
    }
  }

  // ------ 스크롤 이벤트가 발생할 때마다 호출되는 함수인 _onScroll() 내용 끝

  // ------ 현재 탭 인덱스를 계산하여 반환하는 함수 내용 시작
  // 현재 탭 인덱스를 계산하여 반환함.
  int _determineCurrentTabIndex(BuildContext context) {
    int currentIndex = 0; // 초기 탭 인덱스 설정

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 세로 852 (비율 계산에 사용)
    final double referenceHeight = 852.0;

    // preferredSizeHeight 계산 (기준 높이를 바탕으로 계산된 높이)
    double preferredSizeHeight = screenSize.height * (60 / referenceHeight);
    double intervalY = screenSize.height * (10 / referenceHeight); // 여백 계산

    // 선택된 섹션의 가시성 여부를 체크하는 함수
    void checkVisibility(int index, GlobalKey key) {
      final context = key.currentContext;
      if (context != null) {
        // 섹션의 context가 null이 아닐 경우
        final renderBox =
        context.findRenderObject() as RenderBox; // RenderBox 객체로 변환
        final position = renderBox.localToGlobal(Offset.zero); // 글로벌 좌표로 변환
        if (position.dy <= kToolbarHeight + preferredSizeHeight + intervalY) {
          // 위치가 특정 높이 내에 있을 경우
          currentIndex = index; // 현재 인덱스 업데이트
        }
      }
    }

    // 각 섹션의 가시성을 체크하여 currentIndex 업데이트
    checkVisibility(1, sectionNewKey); // '신상' 섹션의 가시성 확인
    checkVisibility(2, sectionBestSellerKey); // '베스트 셀러' 섹션의 가시성 확인
    checkVisibility(3, sectionSaleKey); // '특가 상품' 섹션의 가시성 확인
    checkVisibility(4, sectionSpringKey); // '봄' 섹션의 가시성 확인
    checkVisibility(5, sectionSummerKey); // '여름' 섹션의 가시성 확인
    checkVisibility(6, sectionAutumnKey); // '가을' 섹션의 가시성 확인
    checkVisibility(7, sectionWinterKey); // '겨울' 섹션의 가시성 확인
    checkVisibility(8, sectionEventKey); // '이벤트' 섹션의 가시성 확인

    return currentIndex; // 계산된 현재 인덱스 반환
  }

  // ------ 현재 탭 인덱스를 계산하여 반환하는 함수 내용 끝

  // ------ 스크롤 위치를 업데이트하기 위한 '_updateScrollPosition' 함수 관련 구현 내용 시작
  // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동하는 위치를 저장하는거에 해당 부분도 추가하여
  // 사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을 때 마지막으로 본 위치로 자동으로 스크롤되도록 함.
  void _updateScrollPosition() {
    // 'homeScreenPointScrollController'에서 현재의 스크롤 위치(offset)를 가져와서 'currentScrollPosition' 변수에 저장함.
    double currentScrollPosition = homeScreenPointScrollController.offset;

    // 'ref'를 사용하여 'aauHomeScrollPositionProvider'의 notifier를 읽어옴.
    // 읽어온 notifier의 'state' 값을 'currentScrollPosition'으로 설정함.
    // 이렇게 하면 앱의 다른 부분에서 해당 스크롤 위치 정보를 참조할 수 있게 됨.
    ref.read(aauHomeScrollPositionProvider.notifier).state = currentScrollPosition;
  }

  // ------ 스크롤 위치를 업데이트하기 위한 '_updateScrollPosition' 함수 관련 구현 내용 끝

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // (이 부분이 로그인 상태에서 다른 화면 이동 후 다시 해당 화면으로 올 때, 동작 상태 조절하는 함수-초기화 / 종료)
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();

    // ScrollController를 초기화
    homeScreenPointScrollController = ScrollController();
    homeTopBarPointAutoScrollController = ScrollController();

    // 초기값으로 임시 currentIndex 설정
    currentIndex = 0;

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
            ? ref.read(aauHomeScrollPositionProvider)
            : ref.read(aauHomeLoginAndLogoutScrollPositionProvider);
        // 저장된 위치로 스크롤 이동
        homeScreenPointScrollController.jumpTo(savedScrollPosition);
      }

      ref.read(midCategoryViewBoolExpandedProvider.notifier).state = false;

      // tabIndexProvider의 상태를 하단 탭 바 내 버튼과 매칭이 되면 안되므로 0~3이 아닌 -1로 매핑
      // -> 화면 초기화 시, 하단 탭 바 내 모든 버튼 비활성화
      ref.read(tabIndexProvider.notifier).state = -1;
      ref.invalidate(wishlistItemProvider); // 찜 목록 데이터 초기화
      // 저장된 인덱스를 가져와 currentIndex 초기화
      currentIndex = ref.read(aauHomeCurrentTabProvider);

      // 초기화 시 상단 탭 바 위치 복구를 위한 조건문
      if (currentIndex >= 4) {
        // currentIndex가 4 이상일 경우 ('봄' 섹션 이후가 선택된 경우)
        double offset = homeTopBarPointAutoScrollController
            .position.maxScrollExtent; // 최대 스크롤 위치를 offset에 저장함
        homeTopBarPointAutoScrollController
            .jumpTo(offset); // 스크롤을 최대 위치로 즉시 이동함
      } else if (currentIndex <= 1) {
        // currentIndex가 1 이하일 경우 ('전체' 또는 '신상' 섹션이 선택된 경우)
        homeTopBarPointAutoScrollController.jumpTo(0.0); // 스크롤을 맨 처음 위치로 즉시 이동함
      }

      ref.invalidate(cartItemCountProvider); // 장바구니 아이템 갯수 데이터 초기화
      ref.invalidate(wishlistItemCountProvider); // 찜 목록 아이템 갯수 데이터 초기화
    });

    // 사용자가 스크롤할 때마다 현재의 스크롤 위치를 scrollPositionProvider에 저장하는 코드
    // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동하는 위치를 저장하는거에 해당 부분도 추가하여
    // 사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을 때 마지막으로 본 위치로 자동으로 스크롤되도록 함.
    homeScreenPointScrollController.addListener(_updateScrollPosition);

    // homeScreenPointScrollController에 스크롤 이벤트 리스너를 추가함.
    // 이 리스너는 사용자가 스크롤할 때마다 _onScroll 함수를 호출하도록 설정됨.
    homeScreenPointScrollController.addListener(_onScroll);

    // 큰 배너에 대한 PageController 및 AutoScroll 초기화
    // 'homeLargeBannerPageProvider'에서 초기 페이지 인덱스를 읽어옴
    _largeBannerPageController =
        PageController(initialPage: ref.read(aauHomeLargeBannerPageProvider));

    // 큰 배너를 자동으로 스크롤하는 기능 초기화
    _largeBannerAutoScroll = BannerAutoScrollClass(
      pageController: _largeBannerPageController,
      currentPageProvider: aauHomeLargeBannerPageProvider,
      itemCount: bannerImageCount1, // 총 배너 이미지 개수 전달
    );

    // 작은 배너1에 대한 PageController 및 AutoScroll 초기화
    // 'aauHomeSmall1BannerPageProvider'에서 초기 페이지 인덱스를 읽어옴
    _small1BannerPageController =
        PageController(initialPage: ref.read(aauHomeSmall1BannerPageProvider));

    // 작은 배너1을 자동으로 스크롤하는 기능 초기화
    _small1BannerAutoScroll = BannerAutoScrollClass(
      pageController: _small1BannerPageController,
      currentPageProvider: aauHomeSmall1BannerPageProvider,
      itemCount: bannerImageCount2, // 총 배너 이미지 개수 전달
    );

    // 작은 배너2에 대한 PageController 및 AutoScroll 초기화
    // 'aauHomeSmall2BannerPageProvider'에서 초기 페이지 인덱스를 읽어옴
    _small2BannerPageController =
        PageController(initialPage: ref.read(aauHomeSmall2BannerPageProvider));

    // 작은 배너2를 자동으로 스크롤하는 기능 초기화
    _small2BannerAutoScroll = BannerAutoScrollClass(
      pageController: _small2BannerPageController,
      currentPageProvider: aauHomeSmall2BannerPageProvider,
      itemCount: bannerImageCount2, // 총 배너 이미지 개수 전달
    );

    // 작은 배너3에 대한 PageController 및 AutoScroll 초기화
    // 'aauHomeSmall3BannerPageProvider'에서 초기 페이지 인덱스를 읽어옴
    _small3BannerPageController =
        PageController(initialPage: ref.read(aauHomeSmall3BannerPageProvider));

    // 작은 배너3을 자동으로 스크롤하는 기능 초기화
    _small3BannerAutoScroll = BannerAutoScrollClass(
      pageController: _small3BannerPageController,
      currentPageProvider: aauHomeSmall3BannerPageProvider,
      itemCount: bannerImageCount2, // 총 배너 이미지 개수 전달
    );

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함.
    // FirebaseAuth.instance.authStateChanges를 통해 로그인 상태 변화를 감지함.
    // 사용자가 로그아웃하면(user == null), 페이지 인덱스와 스크롤 위치를 초기화함.
    // 로그아웃 시 homeScrollPositionProvider가 초기화되므로, 재로그인 시 초기 스크롤 위치에서 시작됨. 하지만 섹션 내 데이터는 유지됨.
    // 홈 화면에서 로그아웃 이벤트를 실시간으로 감지하고 처리하는 로직 (여기에도 홈 화면 내 프로바이더 중 초기화해야하는 것을 로직 구현)
    // (이 부분은 로그아웃하고 재로그인할 때 해당 화면으로 올 때, 동작 상태 조절하는 함수-초기화)
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        // (해당 부분은 logoutSecDataAndHomeScrollPointReset에서 구현한 것과 중복되서 필요없음 - 이후에 없애기!!)
        ref.read(aauHomeLargeBannerPageProvider.notifier).state = 0;
        ref.read(aauHomeSmall1BannerPageProvider.notifier).state = 0;
        ref.read(aauHomeSmall2BannerPageProvider.notifier).state = 0;
        ref.read(aauHomeSmall3BannerPageProvider.notifier).state = 0;
        ref.read(aauHomeScrollPositionProvider.notifier).state =
        0.0; // 로그아웃 시 homeScrollPositionProvider가 초기화되므로, 재로그인 시 초기 스크롤 위치에서 시작됨. 하지만 섹션 내 데이터는 유지됨.
        ref.read(aauHomeCurrentTabProvider.notifier).state =
        0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
        ref.read(midCategoryViewBoolExpandedProvider.notifier).state =
        false; // 홈 화면 내 카테고리 버튼 뷰 확장 상태 관련 provider를 초기화
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
      _small2BannerAutoScroll.startAutoScroll();
      _small3BannerAutoScroll.startAutoScroll();
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
      // updateStatusBar();
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

    // 네트워크 체크 해제
    _networkChecker?.dispose();

    super.dispose(); // 위젯의 기본 정리 작업 수행
  }

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 끝 (앱 실행 생명주기 관련 함수)
  // ------ 앱 실행 생명주기 관리 관련 함수 끝

  // ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 시작
  @override
  Widget build(BuildContext context) {
    // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 시작
    void onTopBarTap(int index) {
      if (index == 0) {
        // '전체' 탭이 선택된 경우
        homeScreenPointScrollController.animateTo(
          0.0, // 화면을 맨 위로 스크롤 이동함
          duration: Duration(milliseconds: 500), // 애니메이션 지속 시간 설정 (500밀리초)
          curve: Curves.easeInOut, // 스크롤 애니메이션 커브 설정 (서서히 시작하고 끝나는 곡선)
        );
      } else {
        // 다른 탭이 선택된 경우
        GlobalKey sectionKey = _getSectionKey(index); // 선택된 섹션의 GlobalKey를 가져옴
        if (sectionKey.currentContext != null) {
          // 섹션의 컨텍스트가 null이 아닌 경우
          Scrollable.ensureVisible(
            sectionKey.currentContext!, // 해당 섹션을 화면에 보이도록 스크롤함
            duration: Duration(milliseconds: 500), // 애니메이션 지속 시간 설정 (500밀리초)
            curve: Curves.easeInOut, // 스크롤 애니메이션 커브 설정
          );
        }
      }
      // 탭 선택 시, 선택된 인덱스를 상태에 저장함
      currentIndex = index; // 현재 인덱스를 업데이트함
      ref.read(aauHomeCurrentTabProvider.notifier).state =
          index; // 상태에 현재 탭 인덱스를 저장함
    }
    // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 끝

    // 이벤트 이미지 탭 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 시작
    void onEventImageTap(int index) {

      // 다른 탭이 선택된 경우
      GlobalKey sectionKey = _getSectionKey(index); // 선택된 섹션의 GlobalKey를 가져옴
      if (sectionKey.currentContext != null) {
        // 섹션의 컨텍스트가 null이 아닌 경우
        Scrollable.ensureVisible(
          sectionKey.currentContext!, // 해당 섹션을 화면에 보이도록 스크롤함
          duration: Duration(milliseconds: 500), // 애니메이션 지속 시간 설정 (500밀리초)
          curve: Curves.easeInOut, // 스크롤 애니메이션 커브 설정
        );
      }
      // 탭 선택 시, 선택된 인덱스를 상태에 저장함
      currentIndex = index; // 현재 인덱스를 업데이트함
      ref.read(aauHomeCurrentTabProvider.notifier).state =
          index; // 상태에 현재 탭 인덱스를 저장함
    }
    // 이벤트 이미지 탭 버튼 클릭 시, 해당 섹션으로 화면 이동 코드 끝

    // 상단 탭 바를 구성하는 리스트 뷰를 가져오는 위젯
    // (common_parts.dart의 buildTopBarList 재사용 후 topBarList 위젯으로 재정의)
    Widget topBarList = buildTopBarList(context, onTopBarTap,
        aauHomeCurrentTabProvider, homeTopBarPointAutoScrollController);
    // ------ aab_common_body_parts_layout.dart 내 buildTopBarList, onTopBarTap 재사용하여 TopBar 구현 내용 끝

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 앱 바 부분 수치
    final double expandedHeight =
        screenSize.height * (104 / referenceHeight); // 앱 바의 확장 최대 높이 비율
    final double preferredSizeHeight =
        screenSize.height * (60 / referenceHeight); // 상단 탭 바 높이 비율

    // 대배너 부분 관련 수치
    final double homeScreenLargeBannerWidth = screenSize.width * (393 / referenceWidth); // 대배너 이미지 너비
    final double homeScreenLargeBannerHeight = screenSize.height * (378 / referenceHeight); // 대배너 이미지 높이
    final double homeScreenLargeBannerViewHeight =
        screenSize.height * (378 / referenceHeight); // 대배너 화면 세로 비율

    // 홈 소배너 부분 관련 수치
    final double homeScreenSmallBannerWidth = screenSize.width * (345 / referenceWidth); // 소배너 이미지 너비
    final double homeScreenSmallBannerHeight = screenSize.height * (127 / referenceHeight); // 소배너 이미지 높이
    final double homeScreenSmallBannerViewHeight =
        screenSize.height * (127 / referenceHeight); // 소배너 화면 세로 비율

    // AppBar 관련 수치 동적 적용
    final double homeAppBarTitleWidth = screenSize.width * (240 / referenceWidth);
    final double homeAppBarTitleHeight = screenSize.height * (22 / referenceHeight);
    final double homeAppBarTitleX = screenSize.width * (5 / referenceHeight);
    final double homeAppBarTitleY = screenSize.height * (11 / referenceHeight);

    // 이전화면으로 이동 아이콘 관련 수치 동적 적용
    final double homeChevronIconWidth = screenSize.width * (28 / referenceWidth);
    final double homeChevronIconHeight = screenSize.height * (24 / referenceHeight);
    final double homeChevronIconX = screenSize.width * (10 / referenceWidth);
    final double homeChevronIconY = screenSize.height * (8 / referenceHeight);

    // 찜 목록 버튼 수치 (Case 2)
    final double homeWishlistBtnWidth = screenSize.width * (40 / referenceWidth);
    final double homeWishlistBtnHeight = screenSize.height * (40 / referenceHeight);
    final double homeWishlistBtnX = screenSize.width * (10 / referenceWidth);
    final double homeWishlistBtnY = screenSize.height * (7 / referenceHeight);

    // 홈 화면 컨텐츠 사이의 간격 수치
    final double interval1Y = screenSize.height * (5 / referenceHeight);
    final double interval2Y = screenSize.height * (10 / referenceHeight);
    final double interval3Y = screenSize.height * (60 / referenceHeight);
    final double interval4Y = screenSize.height * (13 / referenceHeight);
    final double interval5Y = screenSize.height * (8 / referenceHeight);

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
                floating: true,
                // 스크롤 시 SliverAppBar가 빠르게 나타남.
                pinned: true,
                // 스크롤 다운시 AppBar가 상단에 고정됨.
                expandedHeight: expandedHeight,
                // 확장 높이 설정
                // FlexibleSpaceBar를 사용하여 AppBar 부분의 확장 및 축소 효과 제공함.
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  // 앱 바 부분을 고정시키는 옵션->앱 바가 스크롤에 의해 사라지고, 그 자리에 상단 탭 바가 있는 bottom이 상단에 고정되도록 하는 기능
                  background: buildCommonAppBar(
                    context: context,
                    ref: ref,
                    title: 'WEARCANO',
                    fontFamily: 'Charter',
                    boolEventImg: true,
                    boolTitleImg: true,
                    titleImagePath:
                    'asset/img/misc/appbar_img/home_appbar_title_img.png',
                    // 앱 바 타이틀 이미지 경로 추가
                    leadingType: LeadingType.back,
                    // 아무 버튼도 없음.
                    buttonCase: 2, // 2번 케이스 (찜 목록 버튼만 노출)
                    appBarTitleWidth: homeAppBarTitleWidth,
                    appBarTitleHeight: homeAppBarTitleHeight,
                    appBarTitleX: homeAppBarTitleX,
                    appBarTitleY: homeAppBarTitleY,
                    chevronIconWidth: homeChevronIconWidth,
                    chevronIconHeight: homeChevronIconHeight,
                    chevronIconX: homeChevronIconX,
                    chevronIconY: homeChevronIconY,
                    wishlistBtnWidth: homeWishlistBtnWidth,
                    wishlistBtnHeight: homeWishlistBtnHeight,
                    wishlistBtnX: homeWishlistBtnX,
                    wishlistBtnY: homeWishlistBtnY,
                    scrollController: homeScreenPointScrollController,
                    // sectionKey: sectionWinterKey,
                    // 여기서 이벤트 이미지 클릭 시 onEventImageTap(8) 호출
                    onEventImageTap: () => onEventImageTap(8),
                  ),
                ),
                leading: null,
                // 좌측 상단의 메뉴 버튼 등을 제거함.
                // iOS에서는 AppBar의 배경색을 사용
                // SliverAppBar 배경색 설정  // AppBar 배경을 투명하게 설정 -> 투명하게 해서 스크롤 내리면 다른 컨텐츠가 비쳐서 보이는 것!!
                // backgroundColor: BUTTON_COLOR,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(preferredSizeHeight),
                  // AppBar 하단에 PreferredSize를 사용하여 탭 바의 높이 지정
                  child: Container(
                    // color: BUTTON_COLOR, // 상단 탭 바 색상 설정
                    child: topBarList, // 탭 바에 들어갈 위젯 배열
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: BLACK_COLOR, width: 1.0), // 상단 테두리 색상을 설정함
                        bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
                      ),
                    ),
                  ),
                ),
              ),
              // // 실제 컨텐츠를 나타내는 슬리버 리스트
              // // 슬리버 패딩을 추가하여 위젯 간 간격 조정함.
              // SliverPadding(
              //   padding: EdgeInsets.only(top: 5),
              //   // SliverList를 사용하여 목록 아이템을 동적으로 생성함.
              //   sliver: SliverList(
              // 실제 컨텐츠를 나타내는 슬리버 리스트
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Padding(
                      // 각 항목의 좌우 간격을 1.0으로 설정함.
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Column(
                        children: [
                          // SizedBox(height: 5), // 높이 20으로 간격 설정
                          // 큰 배너 섹션을 카드뷰로 구성
                          CommonCardView(
                            content: Container(
                              // 모서리에 반경을 주기 위해 BoxDecoration 추가
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0), // 큰 배너의 모서리 반경을 0으로 설정
                                border: Border(
                                  bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
                                ),
                              ),
                              child: SizedBox(
                                // buildCommonBannerPageViewSection 위젯의 높이를 200으로 설정함
                                height: homeScreenLargeBannerViewHeight,
                                // 카드뷰의 내용으로 buildCommonBannerPageViewSection 위젯을 재사용하여 구현함
                                child: buildCommonBannerPageViewSection<
                                    AllLargeBannerImage>(
                                  // 현재 빌드 컨텍스트를 전달
                                  context: context,
                                  // Provider의 참조를 전달 (상태 관리를 위해 사용)
                                  ref: ref,
                                  // 현재 페이지를 관리하는 Provider를 전달
                                  currentPageProvider:
                                  aauHomeLargeBannerPageProvider,
                                  // 페이지 컨트롤러를 전달 (페이지 전환을 관리)
                                  pageController: _largeBannerPageController,
                                  // 배너 자동 스크롤 기능을 전달
                                  bannerAutoScroll: _largeBannerAutoScroll,
                                  // 배너 이미지들을 관리하는 Provider를 전달
                                  bannerImagesProvider:
                                  aauAllLargeBannerImagesProvider,
                                  // 배너를 탭했을 때 실행할 함수를 전달
                                  onPageTap: (context, index) =>
                                  // 대배너 클릭 시 호출할 함수 aauOnLargeBannerTap 실행
                                  aauOnLargeBannerTap(
                                      context, // 현재 화면의 컨텍스트를 전달함
                                      index, // 클릭된 배너의 인덱스를 전달함
                                      // aauAllLargeBannerImagesProvider에서 대배너 이미지 리스트를 가져옴. 값이 없으면 빈 리스트를 사용함
                                      ref.watch(aauAllLargeBannerImagesProvider).value ?? [],
                                      ref // Provider의 참조를 전달함
                                  ),
                                  width: homeScreenLargeBannerWidth, // 원하는 너비
                                  height: homeScreenLargeBannerHeight, // 원하는 높이
                                  borderRadius: 0,
                                ),
                              ),
                            ),
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                            // 카드뷰 배경 색상 : 앱 기본 배경색
                            elevation: 4,
                            // 카드뷰 그림자 깊이
                            // padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0,
                            //     8.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
                            padding: EdgeInsets.zero, // 패딩을 없앰
                            // padding: const EdgeInsets.all(
                            //     2),
                          ),
                          SizedBox(height: interval1Y), // 높이 간격 설정
                          // 카드뷰 클래스 재사용으로 MidCategoryButtonList 내용이 있는 카드뷰 구현
                          // 중간 카테고리 버튼 리스트를 카드뷰로 구성
                          CommonCardView(
                            // 카드뷰 내용으로 MidCategoryButtonList 재사용하여 구현
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                            // 카드뷰 배경 색상 : 앱 기본 배경색
                            elevation: 0,
                            // 카드뷰 그림자 깊이
                            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0,
                                4.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
                            content: Container(
                              child: MidCategoryButtonList(
                                onCategoryTap: aauOnMidCategoryTap,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: interval5Y), // 높이 간격 설정
                          // 첫 번째 홈 소배너 섹션
                          CommonCardView(
                            content: Container(
                              // 모서리에 반경을 주기 위해 BoxDecoration 추가
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5), // 작은 배너의 모서리 반경을 5로 설정
                              ),
                              child: SizedBox(
                                // buildCommonBannerPageViewSection 위젯의 높이를 60으로 설정함
                                height: homeScreenSmallBannerViewHeight,
                                // 카드뷰의 내용으로 buildCommonBannerPageViewSection 위젯을 재사용하여 구현함
                                child: buildCommonBannerPageViewSection<
                                    AllSmallBannerImage>(
                                  // 현재 빌드 컨텍스트를 전달
                                  context: context,
                                  // Provider의 참조를 전달 (상태 관리를 위해 사용)
                                  ref: ref,
                                  // 현재 페이지를 관리하는 Provider를 전달
                                  currentPageProvider:
                                  aauHomeSmall1BannerPageProvider,
                                  // 페이지 전환을 관리하는 페이지 컨트롤러를 전달
                                  pageController: _small1BannerPageController,
                                  // 배너 자동 스크롤 기능을 전달
                                  bannerAutoScroll: _small1BannerAutoScroll,
                                  // 배너 이미지들을 관리하는 Provider를 전달
                                  bannerImagesProvider:
                                  aauHomeSmall1BannerImagesProvider,
                                  // 배너를 탭했을 때 실행할 함수를 전달
                                  onPageTap: (context, index) =>
                                  // 소배너 클릭 시 호출할 함수 aauOnSmallBannerTap 실행
                                  aauOnSmallBannerTap(
                                      context, // 현재 화면의 컨텍스트를 전달함
                                      index, // 클릭된 배너의 인덱스를 전달함
                                      // aauHomeSmall1BannerImagesProvider에서 대배너 이미지 리스트를 가져옴. 값이 없으면 빈 리스트를 사용함
                                      ref.watch(aauHomeSmall1BannerImagesProvider).value ?? [],
                                      ref // Provider의 참조를 전달함
                                  ),
                                  width: homeScreenSmallBannerWidth, // 원하는 너비
                                  height: homeScreenSmallBannerHeight, // 원하는 높이
                                  borderRadius: 5,
                                ),
                              ),
                            ),
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                            // 카드뷰 배경 색상 : 앱 기본 배경색
                            elevation: 0,
                            // 카드뷰 그림자 깊이
                            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0,
                                0.0), // 카드뷰 패딩 : 좌/우: 20.0, 상/하: 0.0
                          ),
                          SizedBox(height: interval4Y), // 높이 간격 설정
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
                              ),
                            ),
                          ),
                          SizedBox(height: interval2Y), // 높이 간격 설정
                          // common_parts_layout.dart에 구현된 신상 관련 옷 상품 부분
                          // 신상품 섹션
                          Container(
                            key: sectionNewKey,
                            child: buildSectionCard(
                                context, ref, "신상", aauBuildNewProductsSection,
                                destinationScreen: AauNewSubMainScreen(),
                                showPlusButton: true),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
                              ),
                            ),
                          ),
                          // SizedBox(height: interval1Y), // 높이 간격 설정
                          // common_parts_layout.dart에 구현된 최고 관련 옷 상품 부분
                          // 베스트 제품 섹션
                          Container(
                            key: sectionBestSellerKey,
                            child: buildSectionCard(context, ref, "스테디 셀러",
                                aauBuildBestProductsSection,
                                destinationScreen: AauBestSubMainScreen(),
                                showPlusButton: true),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
                              ),
                            ),
                          ),
                          // SizedBox(height: interval1Y), // 높이 간격 설정
                          // common_parts_layout.dart에 구현된 할인 관련 옷 상품 부분
                          // 할인 제품 섹션
                          Container(
                            key: sectionSaleKey,
                            child: buildSectionCard(
                                context, ref, "특가 상품", aauBuildSaleProductsSection,
                                destinationScreen: AauSaleSubMainScreen(),
                                showPlusButton: true),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
                              ),
                            ),
                          ),
                          // SizedBox(height: interval1Y), // 높이 간격 설정
                          SizedBox(height: interval4Y), // 높이 간격 설정
                          // 두 번째 홈 소배너 섹션
                          CommonCardView(
                            content: Container(
                              // 모서리에 반경을 주기 위해 BoxDecoration 추가
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5), // 작은 배너의 모서리 반경을 5로 설정
                              ),
                              child: SizedBox(
                                // buildCommonBannerPageViewSection 위젯의 높이를 60으로 설정함
                                height: homeScreenSmallBannerViewHeight,
                                // 카드뷰의 내용으로 buildCommonBannerPageViewSection 위젯을 재사용하여 구현함
                                child: buildCommonBannerPageViewSection<
                                    AllSmallBannerImage>(
                                  // 현재 빌드 컨텍스트를 전달
                                  context: context,
                                  // Provider의 참조를 전달 (상태 관리를 위해 사용)
                                  ref: ref,
                                  // 현재 페이지를 관리하는 Provider를 전달
                                  currentPageProvider:
                                  aauHomeSmall2BannerPageProvider,
                                  // 페이지 전환을 관리하는 페이지 컨트롤러를 전달
                                  pageController: _small2BannerPageController,
                                  // 배너 자동 스크롤 기능을 전달
                                  bannerAutoScroll: _small2BannerAutoScroll,
                                  // 배너 이미지들을 관리하는 Provider를 전달
                                  bannerImagesProvider:
                                  aauHomeSmall2BannerImagesProvider,
                                  // 배너를 탭했을 때 실행할 함수를 전달
                                  onPageTap: (context, index) =>
                                  // 소배너 클릭 시 호출할 함수 aauOnSmallBannerTap 실행
                                  aauOnSmallBannerTap(
                                      context, // 현재 화면의 컨텍스트를 전달함
                                      index, // 클릭된 배너의 인덱스를 전달함
                                      // aauHomeSmall2BannerImagesProvider에서 대배너 이미지 리스트를 가져옴. 값이 없으면 빈 리스트를 사용함
                                      ref.watch(aauHomeSmall2BannerImagesProvider).value ?? [],
                                      ref // Provider의 참조를 전달함
                                  ),
                                  width: homeScreenSmallBannerWidth, // 원하는 너비
                                  height: homeScreenSmallBannerHeight, // 원하는 높이
                                  borderRadius: 5,
                                ),
                              ),
                            ),
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                            // 카드뷰 배경 색상 : 앱 기본 배경색
                            elevation: 0,
                            // 카드뷰 그림자 깊이
                            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0,
                                0.0), // 카드뷰 패딩 : 좌/우: 20.0, 상/하: 0.0
                          ),
                          SizedBox(height: interval4Y), // 높이 간격 설정
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
                              ),
                            ),
                          ),
                          // SizedBox(height: interval2Y), // 높이 간격 설정
                          // 계절별 제품 섹션들을 순차적으로 추가 (봄, 여름, 가을, 겨울)
                          // common_parts_layout.dart에 구현된 봄 관련 옷 상품 부분
                          Container(
                            key: sectionSpringKey,
                            child: buildSectionCard(
                                context, ref, "봄", aauBuildSpringProductsSection,
                                destinationScreen: AauSpringSubMainScreen(),
                                showPlusButton: true),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
                              ),
                            ),
                          ),
                          // SizedBox(height: interval1Y), // 높이 간격 설정
                          // common_parts_layout.dart에 구현된 여름 관련 옷 상품 부분
                          Container(
                            key: sectionSummerKey,
                            child: buildSectionCard(
                                context, ref, "여름", aauBuildSummerProductsSection,
                                destinationScreen: AauSummerSubMainScreen(),
                                showPlusButton: true),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
                              ),
                            ),
                          ),
                          // SizedBox(height: interval1Y), // 높이 간격 설정
                          SizedBox(height: interval4Y), // 높이 간격 설정
                          // 세 번째 홈 소배너 섹션
                          CommonCardView(
                            content: Container(
                              // 모서리에 반경을 주기 위해 BoxDecoration 추가
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5), // 작은 배너의 모서리 반경을 5로 설정
                              ),
                              child: SizedBox(
                                // buildCommonBannerPageViewSection 위젯의 높이를 60으로 설정함
                                height: homeScreenSmallBannerViewHeight,
                                // 카드뷰의 내용으로 buildCommonBannerPageViewSection 위젯을 재사용하여 구현함
                                child: buildCommonBannerPageViewSection<
                                    AllSmallBannerImage>(
                                  // 현재 빌드 컨텍스트를 전달
                                  context: context,
                                  // Provider의 참조를 전달 (상태 관리를 위해 사용)
                                  ref: ref,
                                  // 현재 페이지를 관리하는 Provider를 전달
                                  currentPageProvider:
                                  aauHomeSmall3BannerPageProvider,
                                  // 페이지 전환을 관리하는 페이지 컨트롤러를 전달
                                  pageController: _small3BannerPageController,
                                  // 배너 자동 스크롤 기능을 전달
                                  bannerAutoScroll: _small3BannerAutoScroll,
                                  // 배너 이미지들을 관리하는 Provider를 전달
                                  bannerImagesProvider:
                                  aauHomeSmall3BannerImagesProvider,
                                  // 배너를 탭했을 때 실행할 함수를 전달
                                  onPageTap: (context, index) =>
                                  // 소배너 클릭 시 호출할 함수 aauOnSmallBannerTap 실행
                                  aauOnSmallBannerTap(
                                      context, // 현재 화면의 컨텍스트를 전달함
                                      index, // 클릭된 배너의 인덱스를 전달함
                                      // aauHomeSmall3BannerImagesProvider에서 대배너 이미지 리스트를 가져옴. 값이 없으면 빈 리스트를 사용함
                                      ref.watch(aauHomeSmall3BannerImagesProvider).value ?? [],
                                      ref // Provider의 참조를 전달함
                                  ),
                                  width: homeScreenSmallBannerWidth, // 원하는 너비
                                  height: homeScreenSmallBannerHeight, // 원하는 높이
                                  borderRadius: 5,
                                ),
                              ),
                            ),
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                            // 카드뷰 배경 색상 : 앱 기본 배경색
                            elevation: 0,
                            // 카드뷰 그림자 깊이
                            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0,
                                0.0), // 카드뷰 패딩 : 좌/우: 20.0, 상/하: 0.0
                          ),
                          SizedBox(height: interval4Y), // 높이 간격 설정
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
                              ),
                            ),
                          ),
                          // SizedBox(height: interval2Y), // 높이 간격 설정
                          // common_parts_layout.dart에 구현된 가을 관련 옷 상품 부분
                          Container(
                            key: sectionAutumnKey,
                            child: buildSectionCard(
                                context, ref, "가을", aauBuildAutumnProductsSection,
                                destinationScreen: AauAutumnSubMainScreen(),
                                showPlusButton: true),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
                              ),
                            ),
                          ),
                          // SizedBox(height: interval2Y), // 높이 간격 설정
                          // common_parts_layout.dart에 구현된 겨울 관련 옷 상품 부분
                          Container(
                            key: sectionWinterKey,
                            child: buildSectionCard(
                                context, ref, "겨울", aauBuildWinterProductsSection,
                                destinationScreen: AauWinterSubMainScreen(),
                                showPlusButton: true),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
                              ),
                            ),
                          ),
                          Container(
                            key: sectionEventKey,
                            child: buildSectionCard(context, ref, "이벤트",
                                aauBuildEventPosterImgProductsSection,
                                showPlusButton: false),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
                              ),
                            ),
                          ),
                          SizedBox(height: interval3Y), // 높이 간격 설정
                        ],
                      ),
                    );
                  },
                  childCount: 1, // 하나의 큰 Column이 모든 카드뷰를 포함하고 있기 때문에 1로 설정
                ),
              ),
              // ),
            ],
          ),
          // buildTopButton 함수는 주어진 context와 homeScreenPointScrollController를 사용하여
          // 화면 상단으로 스크롤하기 위한 버튼 생성 위젯이며, common_body_parts_layout.dart 내에 있는 곳에서 재사용하여 구현한 부분
          buildTopButton(context, homeScreenPointScrollController),
        ],
      ),
      // 하단 탭 바 - 1번 케이스인 '홈','장바구니', '발주내역', '마이페이지' 버튼이 UI로 구현됨.
      bottomNavigationBar: buildCommonBottomNavigationBar(
        ref.watch(tabIndexProvider), ref, context, 5, 1, scrollController: homeScreenPointScrollController,),
      // 공통으로 사용되는 하단 네비게이션 바를 가져옴.
      drawer: buildCommonDrawer(context, ref), // 드로어 메뉴를 추가함.
    );
    // ------ 화면구성 끝
  }

// ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 끝
// ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 끝
}
// _AauHomeScreenState 클래스 끝
