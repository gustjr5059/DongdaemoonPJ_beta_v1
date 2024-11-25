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
import '../../cart/provider/cart_state_provider.dart';
import '../../message/provider/message_all_provider.dart';
import '../../order/provider/order_all_providers.dart';
import '../../user/view/easy_login_aos_screen.dart';
import '../../user/view/easy_login_ios_screen.dart';
import '../layout/review_body_parts_layout.dart';
import '../provider/review_all_provider.dart';
import '../provider/review_state_provider.dart';

// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용 권장
// GlobalKey를 사용하면 여러 위젯에서 사용이 안될 수 있기 때문에 로컬 context를 사용하는 것이 좋음
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용을 권장함
// GlobalKey를 사용할 경우 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// PrivateReviewMainScreen 클래스는 ConsumerStatefulWidget을 상속받으며, Riverpod를 통한 상태 관리 기능을 지원함
class PrivateReviewMainScreen extends ConsumerStatefulWidget {
  final bool navigateToListTab; // 리뷰 목록 탭으로 이동할지 여부를 결정하는 플래그

  // ReviewMainScreen 생성자, navigateToListTab 매개변수를 필수로 받음
  const PrivateReviewMainScreen(
      {Key? key, this.navigateToListTab = false})
      : super(key: key);

  @override
  _PrivateReviewMainScreenState createState() =>
      _PrivateReviewMainScreenState(); // 상태 관리 객체 생성
}

// _PrivateReviewMainScreenState 클래스 시작
// _PrivateReviewMainScreenState 클래스는 ReviewMainScreen 위젯의 상태를 관리함
// WidgetsBindingObserver 믹스인을 통해 앱 생명주기 상태 변화를 감시하는 역할을 함
class _PrivateReviewMainScreenState
    extends ConsumerState<PrivateReviewMainScreen> with WidgetsBindingObserver {
  // 사용자 인증 상태 변경을 감지하는 스트림 구독 객체
  // 이를 통해 사용자 로그인 또는 로그아웃 상태 변경을 실시간으로 감지하고 처리할 수 있음
  StreamSubscription<User?>? authStateChangesSubscription;

  // privateReviewScrollControllerProvider에서 ScrollController를 읽어와서 scrollController에 할당
  // ref.read(privateReviewScrollControllerProvider)는 provider를 이용해 상태를 읽는 방식임
  // ScrollController는 스크롤 가능한 위젯의 스크롤 동작을 제어하기 위해 사용됨
  // 1. 상단 탭바 버튼 클릭 시 해당 섹션으로 스크롤 이동하는 기능
  // 2. 하단 탭바의 버튼 클릭 시 화면 초기 위치로 스크롤 이동하는 기능
  // 3. 사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을 때 마지막으로 본 위치로 자동으로 스크롤되도록 하는 기능
  // 4. 단순 스크롤을 내리거나 올릴 시, 상단 탭 바 버튼 텍스트 색상이 변경되도록 하는 기능
  // 5. 'top' 버튼 클릭 시 홈 화면 초기 위치로 스크롤 이동하는 기능
  // => 5개의 기능으로 전체 화면의 스크롤을 제어하는 컨트롤러 역할

  // privateReviewScrollControllerProvider: 여러 위젯에서 동일한 ScrollController를 공유하고,
  // 상태를 유지하기 위해 Riverpod의 Provider를 사용하여 관리함
  // 이를 통해 앱의 다른 부분에서도 동일한 ScrollController에 접근할 수 있으며, 상태를 일관성 있게 유지할 수 있음
  // ScrollController를 late 변수로 선언
  // ScrollController가 여러 ScrollView에 attach되었을 때 발생하는 문제를 해결하기 위한 방법
  // => late로 변수 선언, 해당 변수를 초기화(initState()), 해당 변수를 해제(dispose())
  late ScrollController privateReviewScreenPointScrollController; // 스크롤 컨트롤러 선언

  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // ScrollController를 초기화함
    privateReviewScreenPointScrollController = ScrollController();

    // 스크롤이 끝에 도달했을 때 추가 데이터를 로드하도록 구현
    privateReviewScreenPointScrollController.addListener(() {
      if (privateReviewScreenPointScrollController.position.pixels ==
          privateReviewScreenPointScrollController.position.maxScrollExtent) {
        // 스크롤이 끝에 도달했을 때, 추가 데이터를 로드하는 함수 호출
        ref
            .read(privateReviewItmesListNotifierProvider.notifier)
            .loadMoreReviews();
      }
    });

    // initState에서 저장된 스크롤 위치로 이동
    // initState에서 실행되는 코드, initState는 위젯이 생성될 때 호출되는 초기화 단계임
    // WidgetsBinding.instance.addPostFrameCallback 메서드를 사용하여 프레임이 렌더링 된 후 콜백을 등록함
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 스크롤 컨트롤러가 활성 스크롤 뷰를 가지고 있는지 확인함
      if (privateReviewScreenPointScrollController.hasClients) {
        // savedScrollPosition 변수에 저장된 스크롤 위치를 읽어옴
        // ref.read(scrollPositionProvider)는 Riverpod 상태 관리 라이브러리를 사용하여
        // scrollPositionProvider에서 마지막으로 저장된 스크롤 위치를 가져옴
        double savedScrollPosition =
            ref.read(privateReviewScrollPositionProvider);
        // privateReviewScreenPointScrollController.jumpTo 메서드를 사용하여 스크롤 위치를 savedScrollPosition으로 즉시 이동함
        // 이는 스크롤 애니메이션이나 다른 복잡한 동작 없이 바로 지정된 위치로 점프함
        privateReviewScreenPointScrollController.jumpTo(savedScrollPosition);
      }

      // tabIndexProvider의 상태를 하단 탭 바 내 버튼과 매칭되지 않도록 0~3이 아닌 -1로 매핑함
      // -> 리뷰 관리 화면 초기화 시, 하단 탭 바 내 모든 버튼을 비활성화함
      ref.read(tabIndexProvider.notifier).state = -1;

      // 리뷰 목록 초기화
      ref.read(privateReviewItmesListNotifierProvider.notifier).resetReviews();
      ref
          .read(privateReviewItmesListNotifierProvider.notifier)
          .loadMoreReviews();
      ref.invalidate(cartItemCountProvider); // 장바구니 아이템 갯수 데이터 초기화
    });

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        ref.read(privateReviewScrollPositionProvider.notifier).state = 0;

        // 리뷰 목록 초기화
        ref
            .read(privateReviewItmesListNotifierProvider.notifier)
            .resetReviews();
        ref
            .read(privateReviewItmesListNotifierProvider.notifier)
            .loadMoreReviews();
        ref.invalidate(cartItemCountProvider); // 장바구니 아이템 갯수 데이터 초기화
      }
    });

    // WidgetsBindingObserver를 추가하여 앱의 생명주기 변화 감지
    WidgetsBinding.instance.addObserver(this); // 생명주기 옵저버 등록

    // 상태표시줄 색상을 안드로이드와 iOS 버전에 맞춰서 변경하는 함수 - 앱 실행 생명주기에 맞춰서 변경
    updateStatusBar();

    // 네트워크 상태 체크 시작
    _networkChecker = NetworkChecker(context);
    _networkChecker?.checkNetworkStatus();
  }

  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 끝 (앱 실행 생명주기 관련 함수)

  // didChangeAppLifecycleState 함수 관련 구현 내용 시작
  // 앱 생명주기 상태 변화를 감지하여 특정 동작을 수행하는 함수
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // // ref.read(privateReviewScrollPositionProvider.notifier).state =
      // // 0.0; // 리뷰 관리 메인 화면 자체의 스크롤 위치 인덱스를 초기화
      // ref.invalidate(reviewUserOrdersProvider); // 리뷰 작성 데이터를 초기화
      // ref.read(privateReviewScreenTabProvider.notifier).state = ReviewScreenTab.create; // 리뷰 작성/목록 탭 초기화
      // // 리뷰 관리 화면 중 리뷰 작성 탭 화면 내 '환불' 버튼과 '리뷰 작성' 버튼 활성도 관련 데이터를 불러오는 로직 초기화
      // ref.invalidate(buttonInfoProvider);
      // ref.invalidate(reviewListProvider); // 리뷰 목록 초기화
      // ref.invalidate(paymentCompleteDateProvider); // 결제완료일 데이터 초기화
      // ref.invalidate(deliveryStartDateProvider); // 배송시작일 데이터 초기화
      updateStatusBar(); // 앱이 다시 활성화될 때 상태표시줄 업데이트
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
    privateReviewScreenPointScrollController.dispose();

    // 네트워크 체크 해제
    _networkChecker?.dispose();

    super.dispose(); // 위젯의 기본 정리 작업 수행
  }

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 끝 (앱 실행 생명주기 관련 함수)
  // ------ 앱 실행 생명주기 관리 관련 함수 끝

  // ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 시작
  // build 함수는 위젯의 UI를 그리는 역할을 함
  @override
  Widget build(BuildContext context) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // AppBar 관련 수치 동적 적용
    final double reviewAppBarTitleWidth =
        screenSize.width * (240 / referenceWidth);
    final double reviewAppBarTitleHeight =
        screenSize.height * (22 / referenceHeight);
    final double reviewAppBarTitleX = screenSize.height * (5 / referenceHeight);
    final double reviewAppBarTitleY =
        screenSize.height * (11 / referenceHeight);

    // body 부분 데이터 내용의 전체 패딩 수치
    final double reviewPaddingX = screenSize.width * (8 / referenceWidth);

    // 컨텐츠 사이의 간격 계산
    final double interval1Y =
        screenSize.height * (10 / referenceHeight); // 세로 간격 1 계산

    // 리뷰관리 화면 내 발주내역 부분이 비어있는 경우의 알림 부분 수치
    final double reviewEmptyTextWidth =
        screenSize.width * (250 / referenceWidth); // 가로 비율
    final double reviewEmptyTextHeight =
        screenSize.height * (22 / referenceHeight); // 세로 비율
    final double reviewEmptyTextY =
        screenSize.height * (300 / referenceHeight); // 세로 비율
    final double reviewEmptyTextFontSize =
        screenSize.height * (16 / referenceHeight);

    // 텍스트 폰트 크기 수치
    final double loginGuideTextFontSize =
        screenSize.height * (16 / referenceHeight); // 텍스트 크기 비율 계산
    final double loginGuideTextWidth =
        screenSize.width * (393 / referenceWidth); // 가로 비율
    final double loginGuideTextHeight =
        screenSize.height * (22 / referenceHeight); // 세로 비율
    final double loginGuideText1Y = screenSize.height * (300 / referenceHeight);

    // 로그인 하기 버튼 수치
    final double loginBtnPaddingX = screenSize.width * (20 / referenceWidth);
    final double loginBtnPaddingY = screenSize.height * (5 / referenceHeight);
    final double loginBtnTextFontSize =
        screenSize.height * (14 / referenceHeight);
    final double TextAndBtnInterval =
        screenSize.height * (16 / referenceHeight);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: privateReviewScreenPointScrollController,
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                floating: true,
                pinned: true,
                expandedHeight: 0.0,
                // 공통 앱 바를 빌드하는 함수 호출
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
                      context: context,
                      ref: ref,
                      title: '리뷰 관리',
                      // 앱 바의 제목 설정
                      leadingType: LeadingType.none,
                      // 앱 바의 leading 버튼 설정
                      buttonCase: 1,
                      // 앱 바 버튼의 경우 설정
                      appBarTitleWidth: reviewAppBarTitleWidth,
                      appBarTitleHeight: reviewAppBarTitleHeight,
                      appBarTitleX: reviewAppBarTitleX,
                      appBarTitleY: reviewAppBarTitleY,
                    ),
                  ),
                ),
                leading: null,
                // backgroundColor: BUTTON_COLOR, // 앱 바 배경색 설정
              ),
              // 실제 컨텐츠를 나타내는 슬리버 리스트
              // 슬리버 패딩을 추가하여 위젯 간 간격 조정함.
              // 상단에 여백을 주는 SliverPadding 위젯
              SliverPadding(
                padding: EdgeInsets.only(top: 0),
                // Consumer 위젯을 사용하여 cartItemsProvider의 상태를 구독
                sliver: Consumer(
                  builder: (context, ref, child) {
                    // FirebaseAuth를 사용하여 현재 로그인 상태를 확인
                    final user = FirebaseAuth.instance.currentUser;

                    // 사용자가 로그인되어 있지 않은 경우
                    if (user == null) {
                      return SliverToBoxAdapter(
                        child: LoginRequiredWidget(
                          textWidth: loginGuideTextWidth,
                          textHeight: loginGuideTextHeight,
                          textFontSize: loginGuideTextFontSize,
                          buttonWidth: loginGuideTextWidth,
                          buttonPaddingX: loginBtnPaddingX,
                          buttonPaddingY: loginBtnPaddingY,
                          buttonFontSize: loginBtnTextFontSize,
                          marginTop: loginGuideText1Y,
                          interval: TextAndBtnInterval,
                        ),
                      );
                    }
                    // reviewsNotifierProvider의 상태를 가져옴
                    final reviewItems =
                        ref.watch(privateReviewItmesListNotifierProvider);
                    // 리뷰 내역이 비어 있을 경우 '현재 리뷰 목록 내 리뷰가 없습니다.' 텍스트를 중앙에 표시
                    // StateNotifierProvider를 사용한 로직에서는 AsyncValue를 사용하여 상태를 처리할 수 없으므로
                    // loading: (), error: (err, stack)를 구분해서 구현 못함
                    // 그래서, 이렇게 isEmpty 경우로 해서 구현하면 error와 동일하게 구현은 됨
                    // 그대신 로딩 표시를 못 넣음...
                    return reviewItems.isEmpty
                        ? SliverToBoxAdapter(
                            child: Container(
                              width: reviewEmptyTextWidth,
                              height: reviewEmptyTextHeight,
                              margin: EdgeInsets.only(top: reviewEmptyTextY),
                              // 텍스트를 중앙에 위치하도록 설정함.
                              alignment: Alignment.center,
                              child: Text(
                                '현재 리뷰 목록 내 리뷰가 없습니다.',
                                style: TextStyle(
                                  fontSize: reviewEmptyTextFontSize,
                                  fontFamily: 'NanumGothic',
                                  fontWeight: FontWeight.bold,
                                  color: BLACK_COLOR,
                                ),
                              ),
                            ),
                          )
                        // 리뷰 관리 화면에 아이템이 있을 경우 SliverList를 사용하여 아이템 목록을 표시
                        : SliverList(
                            // SliverChildBuilderDelegate를 사용하여 아이템 목록을 빌드
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Column(
                                  // 아이템 사이에 여백을 주기 위한 SizedBox 위젯
                                  children: [
                                    // PrivateReviewItemsList 위젯을 사용하여 장바구니 아이템 목록을 표시
                                    PrivateReviewItemsList(),
                                  ],
                                );
                              },
                              // 아이템 개수를 1로 설정
                              childCount: 1,
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
          // 상단으로 스크롤하는 버튼을 빌드하는 함수 호출
          buildTopButton(context, privateReviewScreenPointScrollController),
        ],
      ),
      // 하단 탭 바 - 1번 케이스인 '홈','장바구니', '발주내역', '마이페이지' 버튼이 UI로 구현됨.
      bottomNavigationBar: buildCommonBottomNavigationBar(
          ref.watch(tabIndexProvider), ref, context, 5, 1,
          scrollController:
              privateReviewScreenPointScrollController), // 공통으로 사용되는 하단 네비게이션 바를 가져옴.
    );
    // ------ 화면구성 끝
  }
}
// _PrivateReviewMainScreenState 클래스 끝
