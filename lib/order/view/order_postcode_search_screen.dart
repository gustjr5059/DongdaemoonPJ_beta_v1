// Dart의 IO 라이브러리에서 Platform 클래스를 가져옵니다. 이 클래스는 운영 체제에 대한 정보를 제공합니다.
import 'dart:convert';
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
import 'package:webview_flutter/webview_flutter.dart';

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


// 카카오 우편번호 서비스 웹 뷰 관련 postcode.html을 로드하여서 우편번호 서비스 웹 뷰를 보여주는 OrderPostcodeSearchScreen 클래스 내용 시작 부분
class OrderPostcodeSearchScreen extends ConsumerStatefulWidget {
  const OrderPostcodeSearchScreen({Key? key}) : super(key: key);

  @override
  _OrderPostcodeSearchScreenState createState() => _OrderPostcodeSearchScreenState();
}

class _OrderPostcodeSearchScreenState extends ConsumerState<OrderPostcodeSearchScreen> with WidgetsBindingObserver {
  late WebViewController _webViewController; // WebView 컨트롤러를 저장할 변수 선언
  late ScrollController orderPostcodeSearchScreenPointScrollController; // 스크롤 컨트롤러 변수 선언

  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  StreamSubscription<User?>? authStateChangesSubscription; // 인증 상태 변화를 감지하는 스트림 구독 변수 선언

  @override
  void initState() {
    super.initState();
    orderPostcodeSearchScreenPointScrollController = ScrollController(); // 스크롤 컨트롤러 초기화
    WidgetsBinding.instance.addObserver(this); // 위젯 바인딩 옵저버 추가

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView(); // 안드로이드 플랫폼일 경우 WebView 플랫폼 설정

    updateStatusBar(); // 앱이 다시 활성화되었을 때 상태바 업데이트

    // 네트워크 상태 체크 시작
    _networkChecker = NetworkChecker(context);
    _networkChecker?.checkNetworkStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 위젯 바인딩 옵저버 제거
    authStateChangesSubscription?.cancel(); // 인증 상태 변화 구독 취소
    orderPostcodeSearchScreenPointScrollController.dispose(); // 스크롤 컨트롤러 리소스 해제

    // 네트워크 체크 해제
    _networkChecker?.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      updateStatusBar(); // 앱이 다시 활성화되었을 때 상태바 업데이트
    }
  }

  // HTML 파일을 로드하여 WebView에 표시하는 함수
  void _loadHtmlFromAssets() async {
    final htmlContent = await rootBundle.loadString('asset/postcode.html'); // asset 폴더에서 postcode.html 파일 로드
    _webViewController.loadUrl(Uri.dataFromString(htmlContent, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString()); // WebView에 HTML 콘텐츠 로드
  }

  @override
  Widget build(BuildContext context) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // AppBar 관련 수치 동적 적용
    final double postcodeSearchAppBarTitleWidth = screenSize.width * (160 / referenceWidth);
    final double postcodeSearchAppBarTitleHeight = screenSize.height * (22 / referenceHeight);
    final double postcodeSearchAppBarTitleX = screenSize.width * (150 / referenceHeight);
    final double postcodeSearchAppBarTitleY = screenSize.height * (11 / referenceHeight);

    // 이전화면으로 이동 아이콘 관련 수치 동적 적용
    final double postcodeSearchChevronIconWidth =
        screenSize.width * (24 / referenceWidth);
    final double postcodeSearchChevronIconHeight =
        screenSize.height * (24 / referenceHeight);
    final double postcodeSearchChevronIconX =
        screenSize.width * (12 / referenceWidth);
    final double postcodeSearchChevronIconY =
        screenSize.height * (8 / referenceHeight);

    final double interval1X = screenSize.width * (4 / referenceWidth);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 화면 탭 시 포커스를 해제하여 키보드 숨김
      },
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              controller: orderPostcodeSearchScreenPointScrollController, // 스크롤 컨트롤러 설정
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false, // 기본 뒤로가기 버튼 비활성화
                  floating: true, // 스크롤 시 AppBar가 나타나게 설정
                  pinned: true, // 스크롤 시 AppBar가 화면 상단에 고정되게 설정
                  expandedHeight: 0.0, // 확장된 AppBar의 높이를 0으로 설정
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin, // AppBar가 스크롤 시 함께 축소되게 설정
                    background: buildCommonAppBar(
                      context: context,
                      ref: ref,
                      title: '우편번호 찾기', // AppBar의 제목 설정
                      leadingType: LeadingType.back, // 뒤로가기 버튼 설정
                      buttonCase: 1, // 버튼 유형 설정
                      appBarTitleWidth: postcodeSearchAppBarTitleWidth,
                      appBarTitleHeight: postcodeSearchAppBarTitleHeight,
                      appBarTitleX: postcodeSearchAppBarTitleX,
                      appBarTitleY: postcodeSearchAppBarTitleY,
                      chevronIconWidth: postcodeSearchChevronIconWidth,
                      chevronIconHeight: postcodeSearchChevronIconHeight,
                      chevronIconX: postcodeSearchChevronIconX,
                      chevronIconY: postcodeSearchChevronIconY,
                    ),
                  ),
                  leading: null, // 기본 뒤로가기 버튼 비활성화
                  // backgroundColor: BUTTON_COLOR, // AppBar 배경색 설정
                ),
                SliverFillRemaining(
                  hasScrollBody: false, // 스크롤 가능 여부 설정
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: interval1X), // 좌우 여백 설정
                    child: Column(
                      children: [
                        Expanded(
                          child: WebView(
                            javascriptMode: JavascriptMode.unrestricted, // JavaScript 사용 모드 설정
                            onWebViewCreated: (WebViewController webViewController) {
                              _webViewController = webViewController; // WebView 컨트롤러 초기화
                              _loadHtmlFromAssets(); // HTML 콘텐츠 로드
                            },
                            javascriptChannels: <JavascriptChannel>{
                              _toasterJavascriptChannel(context), // JavaScript 채널 설정
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            buildTopButton(context, orderPostcodeSearchScreenPointScrollController), // 상단 버튼 빌드 함수 호출
          ],
        ),
      ),
    );
  }

  // JavaScript 채널을 생성하는 함수
  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster', // JavaScript 채널 이름 설정
        onMessageReceived: (JavascriptMessage message) {
          List<String> addressData = message.message.split('|'); // 메시지를 '|'로 분리하여 주소 데이터로 저장
          Navigator.pop(context, addressData); // 주소 데이터를 팝업하여 이전 화면으로 전달
        });
  }
}
// 카카오 우편번호 서비스 웹 뷰 관련 postcode.html을 로드하여서 우편번호 서비스 웹 뷰를 보여주는 OrderPostcodeSearchScreen 클래스 내용 끝 부분
