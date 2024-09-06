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

// common_all_providers.dart 파일을 common 디렉토리의 provider 폴더에서 가져옵니다.
// 이 파일에는 Future Provider와 관련된 기능이 정의되어 있을 것입니다.
import '../../common/provider/common_all_providers.dart';

// 프로필 화면의 상태를 관리하기 위한 Provider 파일을 임포트합니다.
import '../../order/provider/order_all_providers.dart';
import '../../product/provider/product_all_providers.dart';
import '../layout/user_body_parts_layout.dart';
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

  // 배너 클릭 시 이동할 URL 리스트를 정의함.
  // 각 배너 클릭 시 연결될 웹사이트 주소를 리스트로 관리함.
  // 첫 번째 작은 배너 클릭 시 이동할 URL 목록
  final List<String> small1BannerLinks = [
    'https://www.coupang.com', // 첫 번째 배너 클릭 시 쿠팡으로 이동
    'https://www.temu.com/kr', // 두 번째 배너 클릭 시 테무로 이동
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

  // ------ 스크롤 위치를 업데이트하기 위한 '_updateScrollPosition' 함수 관련 구현 내용 시작
  // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동하는 위치를 저장하는거에 해당 부분도 추가하여
  // 사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을 때 마지막으로 본 위치로 자동으로 스크롤되도록 함.
  void _updateScrollPosition() {
    // 'profileScreenPointScrollController'에서 현재의 스크롤 위치(offset)를 가져와서 'currentScrollPosition' 변수에 저장함.
    double currentScrollPosition = profileScreenPointScrollController.offset;

    // 'ref'를 사용하여 'profileScrollPositionProvider'의 notifier를 읽어옴.
    // 읽어온 notifier의 'state' 값을 'currentScrollPosition'으로 설정함.
    // 이렇게 하면 앱의 다른 부분에서 해당 스크롤 위치 정보를 참조할 수 있게 됨.
    ref.read(profileMainScrollPositionProvider.notifier).state =
        currentScrollPosition;
  }

  // ------ 스크롤 위치를 업데이트하기 위한 '_updateScrollPosition' 함수 관련 구현 내용 끝

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
    });
    // 사용자가 스크롤할 때마다 현재의 스크롤 위치를 scrollPositionProvider에 저장하는 코드
    // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동하는 위치를 저장하는거에 해당 부분도 추가하여
    // 사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을 때 마지막으로 본 위치로 자동으로 스크롤되도록 함.
    profileScreenPointScrollController.addListener(_updateScrollPosition);

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

    // 'profileScreenPointScrollController'의 리스너 목록에서 '_updateScrollPosition' 함수를 제거함.
    // 이는 '_updateScrollPosition' 함수가 더 이상 스크롤 이벤트에 반응하지 않도록 설정함.
    profileScreenPointScrollController.removeListener(_updateScrollPosition);

    profileScreenPointScrollController.dispose(); // ScrollController 해제

    super.dispose(); // 위젯의 기본 정리 작업 수행
  }

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 끝 (앱 실행 생명주기 관련 함수)
  // ------ 앱 실행 생명주기 관리 관련 함수 끝

  // ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 시작
  @override
  Widget build(BuildContext context) {

    void _onSmall1BannerTap(BuildContext context, int index) async {
      final url = small1BannerLinks[index];
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw '네트워크 오류';
      }
    }

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
                // 확장된 높이를 0으로 설정하여 확장 기능 제거
                title: buildCommonAppBar(
                  // 공통 AppBar 빌드
                  context: context,
                  // 현재 context 전달
                  ref: ref,
                  // 참조(ref) 전달
                  title: '마이페이지',
                  // AppBar의 제목을 '마이페이지'로 설정
                  leadingType: LeadingType.none,
                  // 버튼 없음.
                  buttonCase: 1, // 1번 케이스 (버튼 없음)
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
                            SizedBox(height: 2), // 높이 임의로 10으로 간격 설정
                            if (user != null) UserProfileInfo(email: user.email!),
                            SizedBox(height: 10),
                            CommonCardView(
                              content: SizedBox(
                                // buildCommonBannerPageViewSection 내용의 높이가 60으로 구현함.
                                height: 50,
                                // 카드뷰 내용으로 buildCommonBannerPageViewSection 재사용하여 구현함.
                                child: buildCommonBannerPageViewSection<
                                    ProfileMainSmall1BannerImage>(
                                  context: context,
                                  ref: ref,
                                  currentPageProvider:
                                  profileMainSmall1BannerPageProvider,
                                  pageController: _small1BannerPageController,
                                  bannerAutoScroll: _small1BannerAutoScroll,
                                  bannerLinks: small1BannerLinks,
                                  bannerImagesProvider:
                                  profileMainSmall1BannerImagesProvider,
                                  onPageTap: _onSmall1BannerTap,
                                ),
                              ),
                              backgroundColor: LIGHT_SKY_BLUE_COLOR,
                              // 카드뷰 배경 색상 : LIGHT_PURPLE_COLOR
                              elevation: 4,
                              // 카드뷰 그림자 깊이
                              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0,
                                  8.0), // 카드뷰 패딩 : 상/좌/우: 8.0, 하: 4.0
                            ),
                            SizedBox(height: 10), // 높이 임의로 3000으로 간격 설정
                            // user 객체가 null이 아닌 경우 실행됨
                            if (user != null)
                            // UserProfileOptions 위젯을 생성하고, user 객체의 email 속성을 전달함
                              UserProfileOptions(email: user.email!),
                            SizedBox(height: 20), // 높이 임의로 3000으로 간격 설정
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
