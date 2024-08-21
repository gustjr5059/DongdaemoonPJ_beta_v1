import 'dart:io' show Platform;

// Dart의 비동기 프로그래밍 기능을 지원하는 'dart:async' 라이브러리 임포트
// 이 라이브러리는 Future와 Stream 객체를 통해 비동기 작업을 처리하는 기능을 제공함
import 'dart:async';

// Firebase의 사용자 인증 기능을 제공하는 FirebaseAuth 패키지 임포트
// 이를 통해 이메일, 비밀번호, 소셜 미디어 계정을 이용한 로그인 기능을 구현할 수 있음
import 'package:firebase_auth/firebase_auth.dart';

// Flutter의 기본 디자인 및 UI 요소를 제공하는 Material 디자인 패키지 임포트
// 이 패키지는 버튼, 카드, 앱 바 등 다양한 머티리얼 디자인 위젯을 포함하고 있음
import 'package:flutter/material.dart';

// flutter 패키지의 services 라이브러리를 임포트
// 이 라이브러리는 플러터 애플리케이션에서 네이티브 서비스에 접근할 수 있게 해줌
// 예를 들어, 클립보드, 네트워크 상태, 시스템 설정 등을 제어하는 기능을 제공함
import 'package:flutter/services.dart';

// 상태 관리를 위한 현대적인 라이브러리인 Riverpod를 임포트
// Riverpod는 애플리케이션의 상태를 효율적으로 관리하고, 상태 변화에 따라 UI를 자동으로 업데이트함
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod를 사용한 상태 관리를 위한 import

// 애플리케이션에서 발생할 수 있는 예외 상황을 처리하기 위한 공통 UI 레이아웃 파일 임포트
// 이 레이아웃은 에러 발생 시 사용자에게 보여질 UI 컴포넌트를 정의함
import '../../../common/layout/common_exception_parts_of_body_layout.dart';

// colors.dart 파일을 common 디렉토리의 const 폴더에서 임포트
// 이 파일에는 애플리케이션 전반에서 사용할 색상 상수들이 정의되어 있음
// 상수로 정의된 색상들을 사용하여 일관된 색상 테마를 유지할 수 있음
import '../../../common/const/colors.dart';

// 애플리케이션의 여러 부분에서 재사용될 수 있는 공통 UI 컴포넌트 파일 임포트
// 이 파일은 통일된 디자인과 구조를 제공하여 UI 개발을 효율적으로 할 수 있도록 도와줌
import '../../../common/layout/common_body_parts_layout.dart'; // 공통 UI 컴포넌트 파일

// 홈 화면의 레이아웃을 구성하는 파일 임포트
// 이 파일은 홈 화면의 주요 구성 요소들을 정의하며, 사용자에게 첫 인상을 제공하는 중요한 역할을 함
import '../../../common/provider/common_state_provider.dart';

// 제품 상태 관리를 위해 사용되는 상태 제공자 파일 임포트
// 이 파일은 제품 관련 데이터의 상태를 관리하고, 필요에 따라 상태를 업데이트하는 로직을 포함함
import '../layout/review_body_parts_layout.dart';
import '../provider/review_all_provider.dart';
import '../provider/review_state_provider.dart';

// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용 권장
// GlobalKey를 사용하면 여러 위젯에서 사용이 안될 수 있기 때문에 로컬 context를 사용하는 것이 좋음
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용을 권장함
// GlobalKey를 사용할 경우 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// ReviewMainScreen 클래스는 ConsumerStatefulWidget을 상속받으며, Riverpod를 통한 상태 관리 기능을 지원함
class ReviewMainScreen extends ConsumerStatefulWidget {
  final String email; // 이메일 정보를 저장하는 변수

  // ReviewMainScreen 생성자, email 매개변수를 필수로 받음
  const ReviewMainScreen({Key? key, required this.email}) : super(key: key);

  @override
  _ReviewMainScreenState createState() => _ReviewMainScreenState(); // 상태 관리 객체 생성
}

// _ReviewMainScreenState 클래스 시작
// _ReviewMainScreenState 클래스는 ReviewMainScreen 위젯의 상태를 관리함
// WidgetsBindingObserver 믹스인을 통해 앱 생명주기 상태 변화를 감시하는 역할을 함
class _ReviewMainScreenState extends ConsumerState<ReviewMainScreen>
    with WidgetsBindingObserver {
  // 사용자 인증 상태 변경을 감지하는 스트림 구독 객체
  // 이를 통해 사용자 로그인 또는 로그아웃 상태 변경을 실시간으로 감지하고 처리할 수 있음
  StreamSubscription<User?>? authStateChangesSubscription;

  // reviewScrollControllerProvider에서 ScrollController를 읽어와서 scrollController에 할당
  // ref.read(reviewScrollControllerProvider)는 provider를 이용해 상태를 읽는 방식임
  // ScrollController는 스크롤 가능한 위젯의 스크롤 동작을 제어하기 위해 사용됨
  // 1. 상단 탭바 버튼 클릭 시 해당 섹션으로 스크롤 이동하는 기능
  // 2. 하단 탭바의 버튼 클릭 시 화면 초기 위치로 스크롤 이동하는 기능
  // 3. 사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을 때 마지막으로 본 위치로 자동으로 스크롤되도록 하는 기능
  // 4. 단순 스크롤을 내리거나 올릴 시, 상단 탭 바 버튼 텍스트 색상이 변경되도록 하는 기능
  // 5. 'top' 버튼 클릭 시 홈 화면 초기 위치로 스크롤 이동하는 기능
  // => 5개의 기능으로 전체 화면의 스크롤을 제어하는 컨트롤러 역할

  // reviewScrollControllerProvider: 여러 위젯에서 동일한 ScrollController를 공유하고,
  // 상태를 유지하기 위해 Riverpod의 Provider를 사용하여 관리함
  // 이를 통해 앱의 다른 부분에서도 동일한 ScrollController에 접근할 수 있으며, 상태를 일관성 있게 유지할 수 있음
  // ScrollController를 late 변수로 선언
  // ScrollController가 여러 ScrollView에 attach되었을 때 발생하는 문제를 해결하기 위한 방법
  // => late로 변수 선언, 해당 변수를 초기화(initState()), 해당 변수를 해제(dispose())
  late ScrollController reviewScreenPointScrollController; // 스크롤 컨트롤러 선언

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // ScrollController를 초기화함
    reviewScreenPointScrollController = ScrollController();
    // initState에서 저장된 스크롤 위치로 이동
    // initState에서 실행되는 코드, initState는 위젯이 생성될 때 호출되는 초기화 단계임
    // WidgetsBinding.instance.addPostFrameCallback 메서드를 사용하여 프레임이 렌더링 된 후 콜백을 등록함
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 스크롤 컨트롤러가 활성 스크롤 뷰를 가지고 있는지 확인함
      if (reviewScreenPointScrollController.hasClients) {
        // savedScrollPosition 변수에 저장된 스크롤 위치를 읽어옴
        // ref.read(scrollPositionProvider)는 Riverpod 상태 관리 라이브러리를 사용하여
        // scrollPositionProvider에서 마지막으로 저장된 스크롤 위치를 가져옴
        double savedScrollPosition = ref.read(reviewScrollPositionProvider);
        // reviewScreenPointScrollController.jumpTo 메서드를 사용하여 스크롤 위치를 savedScrollPosition으로 즉시 이동함
        // 이는 스크롤 애니메이션이나 다른 복잡한 동작 없이 바로 지정된 위치로 점프함
        reviewScreenPointScrollController.jumpTo(savedScrollPosition);
      }

      // tabIndexProvider의 상태를 하단 탭 바 내 버튼과 매칭되지 않도록 0~3이 아닌 -1로 매핑함
      // -> 리뷰 관리 화면 초기화 시, 하단 탭 바 내 모든 버튼을 비활성화함
      ref.read(tabIndexProvider.notifier).state = -1;
      ref.invalidate(reviewUserOrdersProvider); // 리뷰 작성 데이터를 초기화
      ref.read(privateReviewScreenTabProvider.notifier).state = ReviewScreenTab.create; // 리뷰 작성/목록 탭 초기화
    });

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        ref.read(reviewScrollPositionProvider.notifier).state = 0;
        ref.invalidate(reviewUserOrdersProvider); // 리뷰 작성 데이터를 초기화
        ref.read(privateReviewScreenTabProvider.notifier).state = ReviewScreenTab.create; // 리뷰 작성/목록 탭 초기화
      }
    });

    // WidgetsBindingObserver를 추가하여 앱의 생명주기 변화 감지
    WidgetsBinding.instance.addObserver(this); // 생명주기 옵저버 등록

    // 상태표시줄 색상을 안드로이드와 iOS 버전에 맞춰서 변경하는 함수 - 앱 실행 생명주기에 맞춰서 변경
    _updateStatusBar();
  }

  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 끝 (앱 실행 생명주기 관련 함수)

  // didChangeAppLifecycleState 함수 관련 구현 내용 시작
  // 앱 생명주기 상태 변화를 감지하여 특정 동작을 수행하는 함수
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(reviewUserOrdersProvider); // 리뷰 작성 데이터를 초기화
      ref.read(privateReviewScreenTabProvider.notifier).state = ReviewScreenTab.create; // 리뷰 작성/목록 탭 초기화
      _updateStatusBar(); // 앱이 다시 활성화될 때 상태표시줄 업데이트
    }
  }
  // didChangeAppLifecycleState 함수 관련 구현 내용 끝

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  // dispose 함수는 위젯이 제거될 때 호출되어 자원을 정리하는 역할을 함
  @override
  void dispose() {
    // WidgetsBinding 인스턴스에서 이 객체를 옵저버 목록에서 제거함
    // 앱 생명주기 이벤트를 더 이상 수신하지 않겠다는 의도임
    WidgetsBinding.instance.removeObserver(this);

    // 사용자 인증 상태 감지 구독 해제함
    authStateChangesSubscription?.cancel();

    // ScrollController 해제
    reviewScreenPointScrollController.dispose();
    super.dispose(); // 위젯의 기본 정리 작업 수행
  }
  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 끝 (앱 실행 생명주기 관련 함수)
  // ------ 앱 실행 생명주기 관리 관련 함수 끝

  // 상태표시줄 색상을 안드로이드와 iOS 버전에 맞춰서 변경하는 함수 - 앱 실행 생명주기에 맞춰서 변경
  void _updateStatusBar() {
    Color statusBarColor = BUTTON_COLOR; // 상태표시줄 색상을 BUTTON_COLOR로 설정

    if (Platform.isAndroid) {
      // 안드로이드에서는 상태표시줄 색상을 직접 지정함
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: Brightness.light,
      ));
    } else if (Platform.isIOS) {
      // iOS에서는 앱 바 색상을 통해 상태표시줄 색상을 간접적으로 조정함
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light, // 밝은 아이콘 사용
      ));
    }
  }

  // ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 시작
  // build 함수는 위젯의 UI를 그리는 역할을 함
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: reviewScreenPointScrollController,
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                floating: true,
                pinned: true,
                expandedHeight: 0.0,
                // 공통 앱 바를 빌드하는 함수 호출
                title: buildCommonAppBar(
                  context: context,
                  ref: ref,
                  title: '리뷰 관리', // 앱 바의 제목 설정
                  leadingType: LeadingType.none, // 앱 바의 leading 버튼 설정
                  buttonCase: 1, // 앱 바 버튼의 경우 설정
                ),
                leading: null,
                backgroundColor: BUTTON_COLOR, // 앱 바 배경색 설정
              ),
              SliverPadding(
                padding: EdgeInsets.only(top: 5),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            // reviewUserOrdersProvider를 통해 주문 데이터를 가져옴
                            ref.watch(reviewUserOrdersProvider(widget.email)).when(
                              data: (orders) {
                                if (orders.isEmpty) {
                                  return Center(
                                    child: Text('해당 주문 정보를 찾을 수 없습니다.'),
                                  );
                                }
                                // PrivateReviewScreenTabs 위젯을 반환
                                return PrivateReviewScreenTabs(orders: orders);
                              },
                              loading: () => Center(child: CircularProgressIndicator()), // 로딩 중일 때 표시할 UI
                              error: (error, stack) => Center(child: Text('에러가 발생했습니다: $error')), // 오류 발생 시 표시할 UI
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      );
                    },
                    childCount: 1, // 리스트 아이템 수
                  ),
                ),
              ),
            ],
          ),
          // 상단으로 스크롤하는 버튼을 빌드하는 함수 호출
          buildTopButton(context, reviewScreenPointScrollController),
        ],
      ),
      // 하단 네비게이션 바를 빌드하는 함수 호출
      bottomNavigationBar: buildCommonBottomNavigationBar(
          ref.watch(tabIndexProvider),
          ref,
          context,
          5, 1),
    );
  }
}
// _ReviewScreenState 클래스 끝