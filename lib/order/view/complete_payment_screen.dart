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

// flutter 패키지의 services 라이브러리를 가져옵니다.
// 이 라이브러리는 플러터 애플리케이션에서 네이티브 서비스에 접근할 수 있게 해줍니다.
// 예를 들어, 클립보드, 네트워크 상태, 시스템 설정 등을 제어할 수 있습니다.
import 'package:flutter/services.dart';

// 상태 관리를 위한 현대적인 라이브러리인 Riverpod를 임포트합니다.
// Riverpod는 애플리케이션의 상태를 효율적으로 관리하고, 상태 변화에 따라 UI를 자동으로 업데이트합니다.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod를 사용한 상태 관리를 위한 import

// 숫자 및 날짜 포맷을 위한 intl 라이브러리를 임포트합니다.
import 'package:intl/intl.dart';

// 애플리케이션에서 발생할 수 있는 예외 상황을 처리하기 위한 공통 UI 레이아웃 파일을 임포트합니다.
// 이 레이아웃은 에러 발생 시 사용자에게 보여질 UI 컴포넌트를 정의합니다.
import '../../../common/layout/common_exception_parts_of_body_layout.dart';

// colors.dart 파일을 common 디렉토리의 const 폴더에서 가져옵니다.
// 이 파일에는 애플리케이션 전반에서 사용할 색상 상수들이 정의되어 있을 것입니다.
// 상수로 정의된 색상들을 사용하여 일관된 색상 테마를 유지할 수 있습니다.
import '../../../common/const/colors.dart';

// 애플리케이션의 여러 부분에서 재사용될 수 있는 공통 UI 컴포넌트 파일을 임포트합니다.
// 이 파일은 통일된 디자인과 구조를 제공하여 UI 개발을 효율적으로 할 수 있도록 돕습니다.
import '../../../common/layout/common_body_parts_layout.dart'; // 공통 UI 컴포넌트 파일

// 홈 화면의 레이아웃을 구성하는 파일을 임포트합니다.
// 이 파일은 홈 화면의 주요 구성 요소들을 정의하며, 사용자에게 첫 인상을 제공하는 중요한 역할을 합니다.
import '../../../common/provider/common_state_provider.dart';

// 제품 상태 관리를 위해 사용되는 상태 제공자 파일을 임포트합니다.
// 이 파일은 제품 관련 데이터의 상태를 관리하고, 필요에 따라 상태를 업데이트하는 로직을 포함합니다.
import '../../cart/provider/cart_state_provider.dart';
import '../../product/model/product_model.dart';
import '../../user/view/easy_login_aos_screen.dart';
import '../../user/view/easy_login_ios_screen.dart';
import '../layout/complete_body_parts_layout.dart';
import '../provider/complete_payment_provider.dart';
import '../provider/order_all_providers.dart';

// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는 경우가 있으므로 로컬 context를 사용
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용 권장
// GlobalKey 사용 시 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// CompletePaymentScreen 클래스는 ConsumerWidget을 상속하여 Riverpod를 통한 상태 관리 지원
class CompletePaymentScreen extends ConsumerStatefulWidget {
  final String orderId; // orderId 필드 추가

  const CompletePaymentScreen({
    Key? key, // 위젯의 키를 전달받음
    required this.orderId, // 생성자에서 orderId를 받아옴
  }) : super(key: key); // 상위 클래스의 생성자를 호출하여 key를 전달

  @override
  _CompletePaymentScreenState createState() =>
      _CompletePaymentScreenState(); // 상태 관리 클래스 생성
}

// _CompletePaymentScreenState 클래스 시작
// _CompletePaymentScreenState 클래스는 CompletePaymentScreen 위젯의 상태를 관리함.
// WidgetsBindingObserver 믹스인을 통해 앱 생명주기 상태 변화를 감시함.
class _CompletePaymentScreenState extends ConsumerState<CompletePaymentScreen>
    with WidgetsBindingObserver {
  // 사용자 인증 상태 변경을 감지하는 스트림 구독 객체임.
  // 이를 통해 사용자 로그인 또는 로그아웃 상태 변경을 실시간으로 감지하고 처리할 수 있음.
  StreamSubscription<User?>? authStateChangesSubscription;

  // ScrollController를 late 변수로 선언
  // ScrollController가 여러 ScrollView에 attach 되어서 ScrollController가 동시에 여러 ScrollView에서 사용될 때 발생한 문제를 해결한 방법
  // => late로 변수 선언 / 해당 변수를 초기화(initState()) / 해당 변수를 해제 (dispose())
  late ScrollController
      completePaymentScreenPointScrollController; // 스크롤 컨트롤러 선언

  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // ScrollController를 초기화
    completePaymentScreenPointScrollController = ScrollController();
    // initState에서 저장된 스크롤 위치로 이동
    // initState에서 실행되는 코드. initState는 위젯이 생성될 때 호출되는 초기화 단계
    // WidgetsBinding.instance.addPostFrameCallback 메서드를 사용하여 프레임이 렌더링 된 후 콜백을 등록함.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 스크롤 컨트롤러가 활성 스크롤 뷰를 가지고 있는지 확인함.
      if (completePaymentScreenPointScrollController.hasClients) {
        // savedScrollPosition 변수에 저장된 스크롤 위치를 읽어옴.
        // ref.read(scrollPositionProvider)는 Riverpod 상태 관리 라이브러리를 사용하여
        // scrollPositionProvider에서 마지막으로 저장된 스크롤 위치를 가져옴.
        double savedScrollPosition =
            ref.read(completePaymentScrollPositionProvider);
        // completePaymentScrollPositionProvider.jumpTo 메서드를 사용하여 스크롤 위치를 savedScrollPosition으로 즉시 이동함.
        // 이는 스크롤 애니메이션이나 다른 복잡한 동작 없이 바로 지정된 위치로 점프함.
        completePaymentScreenPointScrollController.jumpTo(savedScrollPosition);
      }

      // tabIndexProvider의 상태를 하단 탭 바 내 버튼과 매칭이 되면 안되므로 0~3이 아닌 -1로 매핑
      // -> 블라우스 메인 화면 초기화 시, 하단 탭 바 내 모든 버튼 비활성화
      ref.read(tabIndexProvider.notifier).state = -1;

      ref.invalidate(cartItemCountProvider); // 장바구니 아이템 갯수 데이터 초기화
    });

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        // (해당 부분은 logoutSecDataAndHomeScrollPointReset에서 구현한 것과 중복되서 필요없음 - 이후에 없애기!!)
        // 발주 화면에서 로그아웃 이벤트를 실시간으로 감지하고 처리하는 로직 (여기에도 발주 화면 내 프로바이더 중 초기화해야하는 것을 로직 구현)
        ref.read(completePaymentScrollPositionProvider.notifier).state =
            0.0; // 로그아웃 시 completePaymentScrollPositionProvider가 초기화되므로, 재로그인 시 초기 스크롤 위치에서 시작됨. 하지만 상품 데이터는 유지됨.
        // print("로그아웃 시 정렬 상태 및 상품 데이터 초기화됨");
        ref.invalidate(cartItemCountProvider); // 장바구니 아이템 갯수 데이터 초기화
      }
    });

    // WidgetsBindingObserver를 추가하여 앱의 생명주기 변화 감지
    WidgetsBinding.instance.addObserver(this); // 생명주기 옵저버 등록

    // 상태표시줄 색상을 안드로이드와 ios 버전에 맞춰서 변경하는데 사용되는 함수-앱 실행 생명주기에 맞춰서 변경
    updateStatusBar();

    // 네트워크 상태 체크 시작
    _networkChecker = NetworkChecker(context);
    _networkChecker?.checkNetworkStatus();

    // CompletePaymentScreen에 도착한 후 다이얼로그 표시 (이러기 위해서는 addPostFrameCallback 이게 필요함!!)
    // 원래는 업데이트 요청 화면에서 '업데이트 요청하기' 버튼 클릭 -> '예' 버튼 클릭하면 해당 로직에서 해당 알림창을 띄우는 로직을 구현하려고
    // 했지만, 이렇게 하면 navigator 특징 상 다른 화면으로 이동한 후에 랜더링 될 때, 이미 context를 활용을 못하므로 에러가 뜸
    // 이를 방지하기 위해 업데이트 요청 완료 화면에 시작할 때 해당 알림창을 띄우도록 여기에 로직을 구현해서 해결함!!
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSubmitAlertDialog(
        context,
        title: '[발주 요청 완료]',
        content: '발주 요청이 완료되었습니다.',
        actions: [
          TextButton(
            child: Text(
              '확인',
              style: TextStyle(
                color: ORANGE56_COLOR,
                fontWeight: FontWeight.bold,
                fontFamily: 'NanumGothic',
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // 알림창 닫기
            },
          ),
        ],
      );
    });
  }

  // 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 끝 (앱 실행 생명주기 관련 함수)

  // 페이지 뷰 자동 스크롤 타이머 함수인 startAutoScrollTimer() 시작 및 정지 관린 함수인
  // didChangeAppLifecycleState 함수 관련 구현 내용 시작
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      updateStatusBar();
    }
  }

  // 페이지 뷰 자동 스크롤 타이머 함수인 startAutoScrollTimer() 시작 및 정지 관린 함수인
  // didChangeAppLifecycleState 함수 관련 구현 내용 끝

  // 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void dispose() {
    // WidgetsBinding 인스턴스에서 이 객체를 옵저버 목록에서 제거함.
    // 앱 생명주기 이벤트를 더 이상 수신하지 않겠다는 의도임.
    WidgetsBinding.instance.removeObserver(this);

    // 사용자 인증 상태 감지 구독 해제함.
    authStateChangesSubscription?.cancel();

    completePaymentScreenPointScrollController.dispose(); // ScrollController 해제

    // 네트워크 체크 해제
    _networkChecker?.dispose();

    super.dispose(); // 위젯의 기본 정리 작업 수행
  }

  // 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 끝 (앱 실행 생명주기 관련 함수)
  // 앱 실행 생명주기 관리 관련 함수 끝

  // 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 시작
  @override
  Widget build(BuildContext context) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // AppBar 관련 수치 동적 적용
    final double completePaymentAppBarTitleWidth =
        screenSize.width * (240 / referenceWidth);
    final double completePaymentAppBarTitleHeight =
        screenSize.height * (22 / referenceHeight);
    final double completePaymentAppBarTitleX =
        screenSize.width * (5 / referenceHeight);
    final double completePaymentAppBarTitleY =
        screenSize.height * (11 / referenceHeight);

    // 에러 관련 텍스트 수치
    final double errorTextFontSize1 =
        screenSize.height * (14 / referenceHeight);
    final double errorTextFontSize2 =
        screenSize.height * (12 / referenceHeight);
    final double errorTextHeight = screenSize.height * (600 / referenceHeight);

    // orderDataProvider에서 orderId를 통해 주문 데이터를 구독함.
    final orderDataFuture = ref.watch(orderDataProvider(widget.orderId));

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

    // 주문 데이터의 상태에 따라 다른 UI를 표시
    return orderDataFuture.when(
      data: (data) {
        // 주문 데이터를 각각의 변수로 분리
        final amountInfo = data['amountInfo'] ?? '';
        final ordererInfo = data['ordererInfo'] ?? '';
        final recipientInfo = data['recipientInfo'] ?? '';
        final numberInfo = data['numberInfo'] ?? '';
        final orderNumber = numberInfo['order_number'] ?? '';
        // 주문 날짜를 원하는 형식으로 포맷
        final orderDate = numberInfo['order_date'] != null
            ? DateFormat('yyyy년 MM월 dd일 HH시 mm분')
                .format(numberInfo['order_date'].toDate())
            : '';
        final orderItems = data['orderItems'] ?? []; // null일 경우 빈 리스트로 대체

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                controller: completePaymentScreenPointScrollController,
                // 스크롤 컨트롤러 연결
                slivers: <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    // 기본 뒤로 가기 버튼 비활성화
                    floating: true,
                    // 스크롤 시 앱바 고정
                    pinned: true,
                    // 앱바를 상단에 고정
                    expandedHeight: 0.0,
                    // 확장되지 않도록 설정
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
                        title: '발주 완료',
                        // 앱바 제목 설정
                        fontFamily: 'NanumGothic',
                        leadingType: LeadingType.none,
                        // 리딩 아이콘 없음
                        buttonCase: 1,
                        // 버튼 타입 설정
                        appBarTitleWidth: completePaymentAppBarTitleWidth,
                        appBarTitleHeight: completePaymentAppBarTitleHeight,
                        appBarTitleX: completePaymentAppBarTitleX,
                        appBarTitleY: completePaymentAppBarTitleY,
                      ),
                      ),
                    ),
                    leading: null,
                    // backgroundColor: BUTTON_COLOR, // 앱바 배경 색상 설정
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 0), // 패딩 설정
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
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: BLACK_COLOR,
                                              width: 1.0), // 하단 테두리 색상을 설정함
                                        ),
                                      ),
                                    ),
                                    CompletePaymentInfoWidget(
                                      orderNumber: orderNumber,
                                      orderDate: orderDate,
                                      totalPayment: amountInfo[
                                          'total_payment_price_included_delivery_fee'],
                                      customerName: ordererInfo['name'],
                                      recipientInfo: recipientInfo,
                                      orderItems: orderItems
                                          .map<ProductContent>((item) {
                                        return ProductContent.fromMap(item);
                                      }).toList(), // 데이터가 null일 경우에도 안전하게 처리
                                    ),
                                  ],
                                ),
                              );
                            },
                            childCount: 1,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              // buildTopButton 함수는 주어진 context와 completePaymentScreenPointScrollController를 사용하여
              // 화면 상단으로 스크롤하기 위한 버튼 생성 위젯이며, common_body_parts_layout.dart 내에 있는 곳에서 재사용하여 구현한 부분
              // buildTopButton(context, completePaymentScreenPointScrollController),
            ],
          ),
          // 하단 탭 바 - 1번 케이스인 '홈','장바구니', '발주내역', '마이페이지' 버튼이 UI로 구현됨.
          bottomNavigationBar: buildCommonBottomNavigationBar(
              ref.watch(tabIndexProvider), ref, context, 5, 1,
              scrollController: completePaymentScreenPointScrollController),
        );
      },
      loading: () => buildCommonLoadingIndicator(), // 공통 로딩 인디케이터 호출
      error: (error, stack) => Container(
        // 에러 상태에서 중앙 배치
        height: errorTextHeight, // 전체 화면 높이 설정
        alignment: Alignment.center, // 중앙 정렬
        child: buildCommonErrorIndicator(
          message: '에러가 발생했으니, 앱을 재실행해주세요.',
          // 첫 번째 메시지 설정
          secondMessage: '에러가 반복될 시, \'문의하기\'에서 문의해주세요.',
          // 두 번째 메시지 설정
          fontSize1: errorTextFontSize1,
          // 폰트1 크기 설정
          fontSize2: errorTextFontSize2,
          // 폰트2 크기 설정
          color: BLACK_COLOR,
          // 색상 설정
          showSecondMessage: true, // 두 번째 메시지를 표시하도록 설정
        ),
      ),
      // 공통으로 사용되는 하단 네비게이션 바를 가져옴.
    );
    // 화면 구성 끝
  }
// 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 끝
// SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 끝
}
// _CompletePaymentScreenState 클래스 끝
