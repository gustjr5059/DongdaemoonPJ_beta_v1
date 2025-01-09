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
import 'package:url_launcher/url_launcher.dart';

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
import '../provider/inquiry_state_provider.dart';


// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용 권장
// GlobalKey 사용 시 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// InquiryMainScreen 클래스는 ConsumerWidget 상속, Riverpod를 통한 상태 관리 지원
class InquiryMainScreen extends ConsumerStatefulWidget {
  const InquiryMainScreen({Key? key}) : super(key: key);

  @override
  _InquiryMainScreenState createState() => _InquiryMainScreenState();
}

// _InquiryMainScreenState 클래스 시작
// _InquiryMainScreenState 클래스는 InquiryMainScreen 위젯의 상태를 관리함.
// WidgetsBindingObserver 믹스인을 통해 앱 생명주기 상태 변화를 감시함.
class _InquiryMainScreenState extends ConsumerState<InquiryMainScreen>
    with WidgetsBindingObserver {
  // 사용자 인증 상태 변경을 감지하는 스트림 구독 객체임.
  // 이를 통해 사용자 로그인 또는 로그아웃 상태 변경을 실시간으로 감지하고 처리할 수 있음.
  StreamSubscription<User?>? authStateChangesSubscription;

  // inquiryScrollControllerProvider에서 ScrollController를 읽어와서 scrollController에 할당
  // ref.read(inquiryScrollControllerProvider)는 provider를 이용해 상태를 읽는 방식.
  // ScrollController는 스크롤 가능한 위젯의 스크롤 동작을 제어하기 위해 사용됨.
  // 1.상단 탭바 버튼 클릭 시 해당 섹션으로 스크롤 이동하는 기능,
  // 2.하단 탭바의 버튼 클릭 시  화면 초기 위치로 스크롤 이동하는 기능,
  // 3.사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을때 마지막으로 본 위치로 자동으로 스크롤되도록 하는 기능,
  // 4.단순 스크롤을 내리거나 올릴 시, 상단 탭 바 버튼 텍스트 색상이 변경되도록 하는 기능,
  // 5. 'top' 버튼 클릭 시 홈 화면 초기 위치로 스크롤 이동하는 기능,
  // => 5개의 기능인 전체 화면의 스크롤을 제어하는 컨트롤러-화면 내의 여러 섹션으로의 이동 역할

  // inquiryScrollControllerProvider : 여러 위젯에서 동일한 ScrollController를 공유하고,
  // 상태를 유지하기 위해 Riverpod의 Provider를 사용하여 관리함.
  // 이를 통해 앱의 다른 부분에서도 동일한 ScrollController에 접근할 수 있으며, 상태를 일관성 있게 유지함.
  // ScrollController를 late 변수로 선언
  // ScrollController가 여러 ScrollView에 attach 되어서 ScrollController가 동시에 여러 ScrollView에서 사용될 때 발생한 문제를 해결한 방법
  // => late로 변수 선언 / 해당 변수를 초기화(initState()) / 해당 변수를 해제 (dispose())
  late ScrollController inquiryScreenPointScrollController; // 스크롤 컨트롤러 선언

  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // ScrollController를 초기화
    inquiryScreenPointScrollController = ScrollController();
    // initState에서 저장된 스크롤 위치로 이동
    // initState에서 실행되는 코드. initState는 위젯이 생성될 때 호출되는 초기화 단계
    // WidgetsBinding.instance.addPostFrameCallback 메서드를 사용하여 프레임이 렌더링 된 후 콜백을 등록함.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 스크롤 컨트롤러가 활성 스크롤 뷰를 가지고 있는지 확인함.
      if (inquiryScreenPointScrollController.hasClients) {
        // savedScrollPosition 변수에 저장된 스크롤 위치를 읽어옴.
        // ref.read(scrollPositionProvider)는 Riverpod 상태 관리 라이브러리를 사용하여
        // scrollPositionProvider에서 마지막으로 저장된 스크롤 위치를 가져옴.
        double savedScrollPosition = ref.read(inquiryScrollPositionProvider);
        // inquiryScreenPointScrollController.jumpTo 메서드를 사용하여 스크롤 위치를 savedScrollPosition으로 즉시 이동함.
        // 이는 스크롤 애니메이션이나 다른 복잡한 동작 없이 바로 지정된 위치로 점프함.
        inquiryScreenPointScrollController.jumpTo(savedScrollPosition);
      }

      // tabIndexProvider의 상태를 하단 탭 바 내 버튼과 매칭이 되면 안되므로 0~3이 아닌 -1로 매핑
      // -> 문의하기 화면 초기화 시, 하단 탭 바 내 모든 버튼 비활성화
      ref.read(tabIndexProvider.notifier).state = -1;
      ref.invalidate(cartItemCountProvider); // 장바구니 아이템 갯수 데이터 초기화
    });

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        ref.read(inquiryScrollPositionProvider.notifier).state = 0;
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
  }

  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 끝 (앱 실행 생명주기 관련 함수)

  // didChangeAppLifecycleState 함수 관련 구현 내용 시작
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
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

    inquiryScreenPointScrollController.dispose(); // ScrollController 해제

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
    final double inquiryAppBarTitleWidth = screenSize.width * (240 / referenceWidth);
    final double inquiryAppBarTitleHeight = screenSize.height * (22 / referenceHeight);
    final double inquiryAppBarTitleX = screenSize.width * (5 / referenceHeight);
    final double inquiryAppBarTitleY = screenSize.height * (11 / referenceHeight);

    // body 부분 데이터 내용의 전체 패딩 수치
    final double inquiryPaddingX = screenSize.width * (8 / referenceWidth);

    // 컨텐츠 사이의 간격 계산
    final double interval1Y = screenSize.height * (200 / referenceHeight); // 세로 간격 1 계산
    final double interval2Y = screenSize.height * (40 / referenceHeight); // 세로 간격 2 계산
    final double interval3Y = screenSize.height * (50 / referenceHeight); // 세로 간격 3 계산
    final double interval1X = screenSize.width * (30 / referenceWidth); // 가로 간격 1 계산
    final double interval2X = screenSize.width * (10 / referenceWidth); // 가로 간격 2 계산

    // 텍스트 폰트 크기 수치
    final double inquiryGuideTextWidth1 =
        screenSize.width * (393 / referenceWidth); // 가로 비율
    final double inquiryGuideTextWidth2 =
        screenSize.width * (310 / referenceWidth); // 가로 비율
    final double inquiryGuidFontSize1 =
        screenSize.height * (18 / referenceHeight); // 텍스트 크기 비율 계산
    final double inquiryGuidFontSize2 =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산

    // 문의하기로 이동 버튼 수치
    final double inquiryBtnWidth =
        screenSize.width * (250 / referenceWidth); // 문의하기로 이동 버튼 가로 비율 계산
    final double inquiryBtnHeight =
        screenSize.height * (45 / referenceHeight); // 문의하기로 이동 버튼 세로 비율 계산
    final double inquiryBtnPaddingX = screenSize.width * (20 / referenceWidth); // 문의하기로 이동 버튼 좌우 패딩 계산
    final double inquiryBtnPaddingY = screenSize.height * (5 / referenceHeight); // 문의하기로 이동 버튼 상하 패딩 계산
    final double inquiryBtnFontSize =
        screenSize.height * (14 / referenceHeight); // 문의하기로 이동 버튼 텍스트 크기 비율 계산
    final double inquiryBtnX = screenSize.width * (120 / referenceWidth);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: inquiryScreenPointScrollController,
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                floating: true,
                pinned: true,
                expandedHeight: 0.0,
                // 확장 높이 설정
                // FlexibleSpaceBar를 사용하여 AppBar 부분의 확장 및 축소 효과 제공함.
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  // 앱 바 부분을 고정시키는 옵션->앱 바가 스크롤에 의해 사라지고, 그 자리에 상단 탭 바가 있는 bottom이 상단에 고정되도록 하는 기능
                  background: buildCommonAppBar(
                    context: context,
                    ref: ref,
                    title: '문의하기',
                    fontFamily: 'NanumGothic',
                    leadingType: LeadingType.none,
                    buttonCase: 1,
                    appBarTitleWidth: inquiryAppBarTitleWidth,
                    appBarTitleHeight: inquiryAppBarTitleHeight,
                    appBarTitleX: inquiryAppBarTitleX,
                    appBarTitleY: inquiryAppBarTitleY,
                    ),
                ),
                leading: null,
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
                        // 각 항목의 좌우 간격을 orderlistPaddingX로 설정함.
                        padding: EdgeInsets.symmetric(horizontal: inquiryPaddingX),
                        child: Column(
                          // 자식 위젯들을 왼쪽 정렬.
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: interval1Y),
                            Container(
                              width: inquiryGuideTextWidth1,
                              alignment: Alignment.center,
                              child: Text('* 문의는 아래 절차에 따라 진행해주세요.',
                                style: TextStyle(
                                  fontSize: inquiryGuidFontSize1, // 텍스트 크기 설정
                                  fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                  fontFamily: 'NanumGothic', // 글꼴 설정
                                  color: BLACK_COLOR, // 텍스트 색상 설정
                                ),
                              ),
                            ),
                            SizedBox(height: interval2Y),
                            Container(
                              width: inquiryGuideTextWidth2,
                              alignment: Alignment.centerLeft,
                              child: Text('1. [문의하기] 버튼을 클릭해주세요.',
                                style: TextStyle(
                                  fontSize: inquiryGuidFontSize2, // 텍스트 크기 설정
                                  fontWeight: FontWeight.normal, // 텍스트 굵기 설정
                                  fontFamily: 'NanumGothic', // 글꼴 설정
                                  color: BLACK_COLOR, // 텍스트 색상 설정
                                ),
                              ),
                            ),
                            Container(
                              width: inquiryGuideTextWidth2,
                              alignment: Alignment.centerLeft,
                              child: Text('2. 해당 페이지에서 내용 작성 후, 제출해주세요.',
                                style: TextStyle(
                                  fontSize: inquiryGuidFontSize2, // 텍스트 크기 설정
                                  fontWeight: FontWeight.normal, // 텍스트 굵기 설정
                                  fontFamily: 'NanumGothic', // 글꼴 설정
                                  color: BLACK_COLOR, // 텍스트 색상 설정
                                  ),
                               ),
                            ),
                            SizedBox(height: interval3Y),
                            Container(
                              width: inquiryBtnWidth,
                              height: inquiryBtnHeight,
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                // 버튼이 눌렸을 때 실행되는 동작을 정의함
                                onPressed: () async {
                                  // 열고자 하는 URL을 url 변수에 상수로 저장함
                                  const url = 'http://pf.kakao.com/_xjVrbG';
                                  try {
                                    // URL을 Uri로 변환하여 외부 브라우저에서 실행함
                                    final bool launched = await launchUrl(
                                      Uri.parse(url), // URL을 Uri 객체로 변환함
                                      mode: LaunchMode.externalApplication, // 외부 애플리케이션 실행 모드 설정함
                                    );

                                    // URL 실행에 실패한 경우 사용자에게 알림을 표시함
                                    if (!launched) {
                                      showCustomSnackBar(context, '웹 페이지를 열 수 없습니다.');
                                    }
                                  } catch (e) {
                                    // URL 실행 중 예외가 발생한 경우 사용자에게 에러 메시지를 표시함
                                    showCustomSnackBar(context, '에러가 발생했습니다.\n앱을 재실행해주세요.');
                                  }
                                },
                                style: ElevatedButton.styleFrom( // 버튼의 스타일을 설정함
                                  foregroundColor: SOFTGREEN60_COLOR, // 버튼의 글자 색상을 설정함
                                  backgroundColor: SOFTGREEN60_COLOR, // 버튼의 배경 색상을 설정함
                                  padding: EdgeInsets.symmetric(vertical: inquiryBtnPaddingY, horizontal: inquiryBtnPaddingX), // 패딩 설정
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(45), // 모서리 둥글게 설정
                                  ),
                                ),
                                child: Text(
                                  '문의하기', // 버튼에 표시될 텍스트
                                  style: TextStyle(
                                    fontSize: inquiryBtnFontSize, // 텍스트 크기 설정
                                    fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                    fontFamily: 'NanumGothic', // 글꼴 설정
                                    color: WHITE_COLOR, // 텍스트 색상 설정
                                  ), // 텍스트 스타일
                                ),
                              ),
                            ),
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
          buildTopButton(context, inquiryScreenPointScrollController),
        ],
      ),
      bottomNavigationBar: buildCommonBottomNavigationBar(
          ref.watch(tabIndexProvider),
          ref,
          context,
          5, 1, scrollController: inquiryScreenPointScrollController),
    );
  }
}
// _InquiryScreenState 클래스 끝
