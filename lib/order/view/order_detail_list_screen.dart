// Dart의 IO 라이브러리에서 Platform 클래스를 가져옵니다. 이 클래스는 운영 체제에 대한 정보를 제공합니다.
import 'dart:io' show Platform;
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import '../../../common/const/colors.dart';
import '../../../common/layout/common_exception_parts_of_body_layout.dart';
import '../../../common/provider/common_state_provider.dart';


// flutter 패키지의 services 라이브러리를 가져옵니다.
// 이 라이브러리는 플러터 애플리케이션에서 네이티브 서비스에 접근할 수 있게 해줍니다.
// 예를 들어, 클립보드, 네트워크 상태, 시스템 설정 등을 제어할 수 있습니다.
import 'package:flutter/services.dart';

// 애플리케이션의 여러 부분에서 재사용될 수 있는 공통 UI 컴포넌트 파일을 임포트합니다.
// 이 파일은 통일된 디자인과 구조를 제공하여 UI 개발을 효율적으로 할 수 있도록 돕습니다.
import '../../common/layout/common_body_parts_layout.dart';
import '../../message/provider/message_all_provider.dart';
import '../layout/order_body_parts_layout.dart';
import '../provider/order_all_providers.dart';
import '../provider/order_state_provider.dart'; // 공통 UI 컴포넌트 파일

// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용 권장
// GlobalKey 사용 시 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// OrderListDetailScreen 클래스는 ConsumerWidget 상속, Riverpod를 통한 상태 관리 지원
class OrderListDetailScreen extends ConsumerStatefulWidget {
  final String orderNumber; // orderNumber 매개변수

  // 생성자에서 orderNumber를 필수 매개변수로 받도록 설정
  const OrderListDetailScreen({
    Key? key,
    required this.orderNumber, // orderNumber를 required로 설정
  }) : super(key: key);

  @override
  _OrderListDetailScreenState createState() =>
      _OrderListDetailScreenState();
}

// _OrderListDetailScreenState 클래스 시작
// _OrderListDetailScreenState 클래스는 OrderListDetailScreen 위젯의 상태를 관리함.
// WidgetsBindingObserver 믹스인을 통해 앱 생명주기 상태 변화를 감시함.
class _OrderListDetailScreenState
    extends ConsumerState<OrderListDetailScreen>
    with WidgetsBindingObserver {

  late String userEmail; // 사용자 이메일을 나중에 초기화할 수 있도록 late 키워드를 사용함
// FirebaseAuth에서 로그인된 사용자의 이메일을 가져와서 해당 변수에 할당함
// 가져온 이메일을 매개변수로 활용하여 Firestore 쿼리 등에 사용할 수 있음

  // 사용자 인증 상태 변경을 감지하는 스트림 구독 객체임.
  // 이를 통해 사용자 로그인 또는 로그아웃 상태 변경을 실시간으로 감지하고 처리할 수 있음.
  StreamSubscription<User?>? authStateChangesSubscription;

  // orderListDetailScrollPositionProvider에서 ScrollController를 읽어와서 scrollController에 할당
  // ref.read(orderListDetailScrollPositionProvider)는 provider를 이용해 상태를 읽는 방식.
  // ScrollController는 스크롤 가능한 위젯의 스크롤 동작을 제어하기 위해 사용됨.
  // 1.상단 탭바 버튼 클릭 시 해당 섹션으로 스크롤 이동하는 기능,
  // 2.하단 탭바의 버튼 클릭 시  화면 초기 위치로 스크롤 이동하는 기능,
  // 3.사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을때 마지막으로 본 위치로 자동으로 스크롤되도록 하는 기능,
  // 4.단순 스크롤을 내리거나 올릴 시, 상단 탭 바 버튼 텍스트 색상이 변경되도록 하는 기능,
  // 5. 'top' 버튼 클릭 시 홈 화면 초기 위치로 스크롤 이동하는 기능,
  // => 5개의 기능인 전체 화면의 스크롤을 제어하는 컨트롤러-화면 내의 여러 섹션으로의 이동 역할

  // orderListDetailScrollPositionProvider : 여러 위젯에서 동일한 ScrollController를 공유하고,
  // 상태를 유지하기 위해 Riverpod의 Provider를 사용하여 관리함.
  // 이를 통해 앱의 다른 부분에서도 동일한 ScrollController에 접근할 수 있으며, 상태를 일관성 있게 유지함.
  // ScrollController를 late 변수로 선언
  // ScrollController가 여러 ScrollView에 attach 되어서 ScrollController가 동시에 여러 ScrollView에서 사용될 때 발생한 문제를 해결한 방법
  // => late로 변수 선언 / 해당 변수를 초기화(initState()) / 해당 변수를 해제 (dispose())
  late ScrollController
  orderListDetailScreenPointScrollController; // 스크롤 컨트롤러 선언

  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // ScrollController를 초기화
    orderListDetailScreenPointScrollController = ScrollController();

    // FirebaseAuth에서 사용자 이메일 가져오기
    userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    // initState에서 저장된 스크롤 위치로 이동
    // initState에서 실행되는 코드. initState는 위젯이 생성될 때 호출되는 초기화 단계
    // WidgetsBinding.instance.addPostFrameCallback 메서드를 사용하여 프레임이 렌더링 된 후 콜백을 등록함.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 스크롤 컨트롤러가 활성 스크롤 뷰를 가지고 있는지 확인함.
      if (orderListDetailScreenPointScrollController.hasClients) {
        // savedScrollPosition 변수에 저장된 스크롤 위치를 읽어옴.
        // ref.read(scrollPositionProvider)는 Riverpod 상태 관리 라이브러리를 사용하여
        // scrollPositionProvider에서 마지막으로 저장된 스크롤 위치를 가져옴.
        double savedScrollPosition = ref.read(orderListDetailScrollPositionProvider);
        // orderListDetailScreenPointScrollController.jumpTo 메서드를 사용하여 스크롤 위치를 savedScrollPosition으로 즉시 이동함.
        // 이는 스크롤 애니메이션이나 다른 복잡한 동작 없이 바로 지정된 위치로 점프함.
        orderListDetailScreenPointScrollController.jumpTo(savedScrollPosition);
      }

      // tabIndexProvider의 상태를 하단 탭 바 내 발주내역 버튼 인덱스인 2와 매핑
      // -> 발주내역 화면 초기화 시, 하단 탭 바 내 발주내역 버튼을 활성화
      ref.read(tabIndexProvider.notifier).state = 2;
      // 발주 목록 상세 화면 내 '환불' 버튼과 '리뷰 작성' 버튼 활성도 관련 데이터를 불러오는 로직 초기화
      ref.invalidate(buttonInfoProvider);
      ref.invalidate(paymentCompleteDateProvider); // 결제완료일 데이터 초기화
    });

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        // 발주 화면에서 로그아웃 이벤트를 실시간으로 감지하고 처리하는 로직 (여기에도 발주 화면 내 프로바이더 중 초기화해야하는 것을 로직 구현)
        ref.read(orderListDetailScrollPositionProvider.notifier).state =
        0.0; // 발주 화면 자체의 스크롤 위치 인덱스를 초기화
        // 발주 목록 상세 화면 내 '환불' 버튼과 '리뷰 작성' 버튼 활성도 관련 데이터를 불러오는 로직 초기화
        ref.invalidate(buttonInfoProvider);
        ref.invalidate(paymentCompleteDateProvider); // 결제완료일 데이터 초기화
      }
    });

    // WidgetsBindingObserver를 추가하여 앱의 생명주기 변화 감지
    WidgetsBinding.instance.addObserver(this); // 생명주기 옵저버 등록

    // 상태표시줄 색상을 안드로이드와 ios 버전에 맞춰서 변경하는데 사용되는 함수-앱 실행 생명주기에 맞춰서 변경
    updateStatusBar();

    // 네트워크 상태 체크 시작
    _networkChecker = NetworkChecker(context);
    _networkChecker?.checkNetworkStatus();
  }

  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 끝 (앱 실행 생명주기 관련 함수)

  // didChangeAppLifecycleState 함수 관련 구현 내용 시작
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // // 앱이 다시 포커스를 얻었을 때 상태를 업데이트 (다른 화면 이동 후 복귀 시, 해당 초기화 로직이 동작함)
      // ref.read(orderListDetailScrollPositionProvider.notifier).state =
      // 0.0; // 발주 화면 자체의 스크롤 위치 인덱스를 초기화
      // // 발주 목록 상세 화면 내 발주내역 데이터를 불러오는 로직 초기화
      // ref.invalidate(orderListDetailProvider);
      // ref.invalidate(buttonInfoProvider);  // 초기화
      // ref.invalidate(paymentCompleteDateProvider); // 결제완료일 데이터 초기화
      updateStatusBar();
    }
  }

  // didChangeAppLifecycleState 함수 관련 구현 내용 끝

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void dispose() {
    // WidgetsBinding 인스턴스에서 이 객체를 옵저버 목록에서 제거함.
    // 앱 생명주기 이벤트를 더 이상 수신하지 않겠다는 의도임.
    WidgetsBinding.instance.removeObserver(this);

    // 사용자 인증 상태 감지 구독 해제함.
    authStateChangesSubscription?.cancel();

    orderListDetailScreenPointScrollController
        .dispose(); // ScrollController 해제

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

    // AppBar 관련 수치 동적 적용
    final double orderlistDtAppBarTitleWidth = screenSize.width * (160 / referenceWidth);
    final double orderlistDtAppBarTitleHeight = screenSize.height * (22 / referenceHeight);
    final double orderlistDtAppBarTitleX = screenSize.width * (143 / referenceHeight);
    final double orderlistDtAppBarTitleY = screenSize.height * (11 / referenceHeight);

    // body 부분 데이터 내용의 전체 패딩 수치
    final double orderlistDtPaddingX = screenSize.width * (16 / referenceWidth);
    final double orderlistDtPadding1Y = screenSize.height * (5 / referenceHeight);

    // 이전화면으로 이동 아이콘 관련 수치 동적 적용
    final double orderlistDtChevronIconWidth = screenSize.width * (24 / referenceWidth);
    final double orderlistDtChevronIconHeight = screenSize.height * (24 / referenceHeight);
    final double orderlistDtChevronIconX = screenSize.width * (12 / referenceWidth);
    final double orderlistDtChevronIconY = screenSize.height * (8 / referenceHeight);

    // 찜 목록 버튼 수치 (Case 2)
    final double orderlistDtWishlistBtnWidth = screenSize.width * (40 / referenceWidth);
    final double orderlistDtWishlistBtnHeight = screenSize.height * (40 / referenceHeight);
    final double orderlistDtWishlistBtnX = screenSize.width * (10 / referenceWidth);
    final double orderlistDtWishlistBtnY = screenSize.height * (7 / referenceHeight);

    // 발주 내역 상세 목록 비어있는 경우의 알림 부분 수치
    final double orderlistEmptyTextWidth =
        screenSize.width * (270 / referenceWidth); // 가로 비율
    final double orderlistEmptyTextHeight =
        screenSize.height * (22 / referenceHeight); // 세로 비율
    final double orderlistEmptyTextX =
        screenSize.width * (60 / referenceWidth); // 가로 비율
    final double orderlistEmptyTextY =
        screenSize.height * (100 / referenceHeight); // 세로 비율
    final double orderlistEmptyTextFontSize =
        screenSize.height * (16 / referenceHeight);

    // Tuple2로 이메일과 orderNumber 전달
    final orderlistDetailItem = ref.watch(orderlistDetailItemProvider(Tuple2(userEmail, widget.orderNumber)));

    // ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 시작
    // ------ 기존 buildCommonAppBar 위젯 내용과 동일하며,
    // 플러터 기본 SliverAppBar 위젯을 활용하여 앱 바의 상태 동적 UI 구현에 수월한 부분을 정의해서 해당 위젯을 바로 다른 화면에 구현하여
    // 기본 SliverAppBar의 드로워화면 토글 옵션을 삭제하는 등의 작업이 필요없는 방식-현재는 이슈가 있어 사용 안함..
    return Scaffold(
      body: Stack(
          children: [
            // 발주 상세 내역이 비어 있을 경우, '발주 데이터를 불러올 수 없습니다.' 메시지를 표시함.
            if (orderlistDetailItem.isEmpty)
              Center(
                child: Container(
                  width: orderlistEmptyTextWidth,
                  height: orderlistEmptyTextHeight,
                  margin: EdgeInsets.only(left: orderlistEmptyTextX, top: orderlistEmptyTextY),
                  child: Text(
                    '발주 데이터를 불러올 수 없습니다.',
                    style: TextStyle(
                      fontSize: orderlistEmptyTextFontSize,
                      fontFamily: 'NanumGothic',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
              else
              CustomScrollView(
                controller: orderListDetailScreenPointScrollController,
                // 스크롤 컨트롤러 연결
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
                      background: buildCommonAppBar(
                      // 공통 AppBar 빌드
                      context: context,
                      // 현재 context 전달
                      ref: ref,
                      // 참조(ref) 전달
                      title: '발주 내역 상세',
                      // AppBar의 제목을 '발주 목록 상세'로 설정
                      leadingType: LeadingType.back,
                      // AppBar의 리딩 타입을 뒤로가기 버튼으로 설정
                      buttonCase: 2, // 버튼 케이스를 2로 설정
                      appBarTitleWidth: orderlistDtAppBarTitleWidth,
                      appBarTitleHeight: orderlistDtAppBarTitleHeight,
                      appBarTitleX: orderlistDtAppBarTitleX,
                      appBarTitleY: orderlistDtAppBarTitleY,
                      chevronIconWidth: orderlistDtChevronIconWidth,
                      chevronIconHeight: orderlistDtChevronIconHeight,
                      chevronIconX: orderlistDtChevronIconX,
                      chevronIconY: orderlistDtChevronIconY,
                      wishlistBtnWidth: orderlistDtWishlistBtnWidth,
                      wishlistBtnHeight: orderlistDtWishlistBtnHeight,
                      wishlistBtnX: orderlistDtWishlistBtnX,
                      wishlistBtnY: orderlistDtWishlistBtnY,
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
                    padding: EdgeInsets.zero, // 컨텐츠 내용 부분 패딩이 없음.
                    // SliverList를 사용하여 목록 아이템을 동적으로 생성함.
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return Padding(
                            // 각 항목의 좌우 간격을 orderlistDtPaddingX로 설정함.
                            padding: EdgeInsets.symmetric(horizontal: orderlistDtPaddingX),
                            child: Column(
                              children: [
                                SizedBox(height: orderlistDtPadding1Y), // 높이 orderlistDtPadding1Y로 간격 설정
                                OrderListDetailItemWidget(order: orderlistDetailItem),
                                SizedBox(height: orderlistDtPadding1Y),
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
          ],
      ),
      // buildTopButton 함수는 주어진 context와 orderListDetailProductScreenPointScrollController를 사용하여
      // 화면 상단으로 스크롤하기 위한 버튼 생성 위젯이며, common_body_parts_layout.dart 내에 있는 곳에서 재사용하여 구현한 부분
      // buildTopButton(
      //     context, orderListDetailScreenPointScrollController),
      bottomNavigationBar: buildCommonBottomNavigationBar(
          ref.watch(tabIndexProvider),
          ref,
          context,
          3, 1, scrollController: orderListDetailScreenPointScrollController),
    );
    // ------ 화면구성 끝
  }
// ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 끝
// ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 끝
}
// _OrderListDetailScreenState 클래스 끝
