// Dart의 IO 라이브러리에서 Platform 클래스를 가져옵니다. 이 클래스는 운영 체제에 대한 정보를 제공합니다.
import 'dart:io' show Platform;

// Dart의 비동기 프로그래밍 기능을 지원하는 'dart:async' 라이브러리를 가져옵니다.
// 이 라이브러리를 사용하여 Future와 Stream 객체를 통해 비동기 작업을 쉽게 처리할 수 있습니다.
import 'dart:async';

// Firebase의 사용자 인증 기능을 제공하는 FirebaseAuth 패키지를 임포트합니다.
// 이를 통해 이메일, 비밀번호, 소셜 미디어 계정을 이용한 로그인 기능 등을 구현할 수 있습니다.
import 'package:dongdaemoon_beta_v1/user/view/profile_screen.dart';
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
import '../../cart/provider/cart_state_provider.dart';
import '../../home/view/home_screen.dart';
import '../../order/provider/order_state_provider.dart';
import '../layout/user_body_parts_layout.dart';
import '../provider/user_info_modify_and_secession_all_provider.dart';
import '../provider/user_info_modify_and_secession_state_provider.dart';

import 'package:korean_profanity_filter/korean_profanity_filter.dart'
as KoreanFilter; // 별칭 설정 (korean_profanity_filter 패키지 임포트)
import 'package:profanity_filter/profanity_filter.dart'
as EnglishFilter; // 별칭 설정 (profanity_filter 패키지 임포트)


// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용 권장
// GlobalKey 사용 시 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// UserInfoModifyAndSecessionScreen 클래스는 ConsumerWidget 상속, Riverpod를 통한 상태 관리 지원
class UserInfoModifyAndSecessionScreen extends ConsumerStatefulWidget {
  const UserInfoModifyAndSecessionScreen({Key? key}) : super(key: key);

  @override
  _UserInfoModifyAndSecessionScreenState createState() =>
      _UserInfoModifyAndSecessionScreenState();
}

// _UserInfoModifyAndSecessionScreenState 클래스 시작
// _UserInfoModifyAndSecessionScreenState 클래스는 UserInfoModifyAndSecessionScreen 위젯의 상태를 관리함.
// WidgetsBindingObserver 믹스인을 통해 앱 생명주기 상태 변화를 감시함.
class _UserInfoModifyAndSecessionScreenState
    extends ConsumerState<UserInfoModifyAndSecessionScreen>
    with WidgetsBindingObserver {
  // 사용자 인증 상태 변경을 감지하는 스트림 구독 객체임.
  // 이를 통해 사용자 로그인 또는 로그아웃 상태 변경을 실시간으로 감지하고 처리할 수 있음.
  StreamSubscription<User?>? authStateChangesSubscription;

  // userInfoModifyAndSecessionScrollPositionProvider에서 ScrollController를 읽어와서 scrollController에 할당
  // ref.read(userInfoModifyAndSecessionScrollPositionProvider)는 provider를 이용해 상태를 읽는 방식.
  // ScrollController는 스크롤 가능한 위젯의 스크롤 동작을 제어하기 위해 사용됨.
  // 1.상단 탭바 버튼 클릭 시 해당 섹션으로 스크롤 이동하는 기능,
  // 2.하단 탭바의 버튼 클릭 시  화면 초기 위치로 스크롤 이동하는 기능,
  // 3.사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을때 마지막으로 본 위치로 자동으로 스크롤되도록 하는 기능,
  // 4.단순 스크롤을 내리거나 올릴 시, 상단 탭 바 버튼 텍스트 색상이 변경되도록 하는 기능,
  // 5. 'top' 버튼 클릭 시 홈 화면 초기 위치로 스크롤 이동하는 기능,
  // => 5개의 기능인 전체 화면의 스크롤을 제어하는 컨트롤러-화면 내의 여러 섹션으로의 이동 역할

  //  userInfoModifyAndSecessionScrollPositionProvider : 여러 위젯에서 동일한 ScrollController를 공유하고,
  // 상태를 유지하기 위해 Riverpod의 Provider를 사용하여 관리함.
  // 이를 통해 앱의 다른 부분에서도 동일한 ScrollController에 접근할 수 있으며, 상태를 일관성 있게 유지함.
  // ScrollController를 late 변수로 선언
  // ScrollController가 여러 ScrollView에 attach 되어서 ScrollController가 동시에 여러 ScrollView에서 사용될 때 발생한 문제를 해결한 방법
  // => late로 변수 선언 / 해당 변수를 초기화(initState()) / 해당 변수를 해제 (dispose())
  late ScrollController
      userInfoModifyAndSecessionScreenPointScrollController; // 스크롤 컨트롤러 선언

  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  final TextEditingController _nameController =
      TextEditingController(); // 이름 입력 필드 컨트롤러
  final TextEditingController _emailController =
      TextEditingController(); // 이메일 입력 필드 컨트롤러
  final TextEditingController _phoneController =
      TextEditingController(); // 휴대폰 번호 입력 필드 컨트롤러

  // ProfanityFilter라는 클래스가 두 개의 패키지(korean_profanity_filter와 profanity_filter)에서 동일한 이름으로 정의되어 있어서 충돌이 발생함
  // 이런 경우, 하나의 패키지에서 해당 이름을 사용하려면 as 키워드로 별칭을 부여해야 합니다. 별칭을 사용하면 두 패키지의 동일한 이름 충돌을 피함
  final EnglishFilter.ProfanityFilter _englishProfanityFilter =
  EnglishFilter.ProfanityFilter(); // 영어 비속어 필터 객체

  bool isLoading = false; // 로딩 상태
  bool isChecked = false; // 체크박스 상태

  // ------ 포커스 노드 초기화 ------
  FocusNode _nameFocusNode = FocusNode(); // 이름 입력 필드 포커스 노드
  FocusNode _emailFocusNode = FocusNode(); // 이메일 입력 필드 포커스 노드
  FocusNode _phoneNumberFocusNode = FocusNode(); // 휴대폰 번호 입력 필드 포커스 노드

  // Firestore에서 가져온 데이터를 텍스트 필드에 '딱 한 번만' 세팅했는지 여부를 확인하기 위한 플래그
  bool _isDataLoaded = false;

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // ScrollController를 초기화
    userInfoModifyAndSecessionScreenPointScrollController = ScrollController();

    // initState에서 저장된 스크롤 위치로 이동
    // initState에서 실행되는 코드. initState는 위젯이 생성될 때 호출되는 초기화 단계
    // WidgetsBinding.instance.addPostFrameCallback 메서드를 사용하여 프레임이 렌더링 된 후 콜백을 등록함.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;
      final userEmail = user?.email ?? user?.uid ?? '';

      // 스크롤 컨트롤러가 활성 스크롤 뷰를 가지고 있는지 확인함.
      if (userInfoModifyAndSecessionScreenPointScrollController.hasClients) {
        // savedScrollPosition 변수에 저장된 스크롤 위치를 읽어옴.
        // ref.read(scrollPositionProvider)는 Riverpod 상태 관리 라이브러리를 사용하여
        // scrollPositionProvider에서 마지막으로 저장된 스크롤 위치를 가져옴.
        double savedScrollPosition =
            ref.read(userInfoModifyAndSecessionScrollPositionProvider);
        // userInfoModifyAndSecessionScreenPointScrollController.jumpTo 메서드를 사용하여 스크롤 위치를 savedScrollPosition으로 즉시 이동함.
        // 이는 스크롤 애니메이션이나 다른 복잡한 동작 없이 바로 지정된 위치로 점프함.
        userInfoModifyAndSecessionScreenPointScrollController
            .jumpTo(savedScrollPosition);
      }

      // tabIndexProvider의 상태를 하단 탭 바 내 버튼과 매칭이 되면 안되므로 0~3이 아닌 -1로 매핑
      // -> 문의하기 화면 초기화 시, 하단 탭 바 내 모든 버튼 비활성화
      ref.read(tabIndexProvider.notifier).state = -1;
      ref.invalidate(cartItemCountProvider); // 장바구니 아이템 갯수 데이터 초기화
      ref.invalidate(orderlistItemCountProvider); // 요청내역 아이템 갯수 데이터 초기화
      ref
          .read(userInfoModifyNotifierProvider.notifier)
          .fetchUserInfo(userEmail); // SNS ID, 이름, 이메일, 휴대폰 번호 데이터 초기화
    });

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      final user = FirebaseAuth.instance.currentUser;
      final userEmail = user?.email ?? user?.uid ?? '';

      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        ref
            .read(userInfoModifyAndSecessionScrollPositionProvider.notifier)
            .state = 0;
        ref.invalidate(cartItemCountProvider); // 장바구니 아이템 갯수 데이터 초기화
        ref.invalidate(orderlistItemCountProvider); // 요청내역 아이템 갯수 데이터 초기화
        ref
            .read(userInfoModifyNotifierProvider.notifier)
            .fetchUserInfo(userEmail); // SNS ID, 이름, 이메일, 휴대폰 번호 데이터 초기화
      }
    });

    // WidgetsBindingObserver를 추가하여 앱의 생명주기 변화 감지
    WidgetsBinding.instance.addObserver(this); // 생명주기 옵저버 등록

    // 상태표시줄 색상을 안드로이드와 ios 버전에 맞춰서 변경하는데 사용되는 함수-앱 실행 생명주기에 맞춰서 변경
    updateStatusBar();

    // 네트워크 상태 체크 시작
    _networkChecker = NetworkChecker(context);
    _networkChecker?.checkNetworkStatus();

    // 이메일 입력 필드 포커스 리스너 추가 (유효성 체크)
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        // 입력값이 있을 때만 검사
        // @를 포함하지 않거나, @를 제외한 값이 없는 경우
        if (_emailController.text.isNotEmpty &&
            (!_emailController.text.contains('@') ||
                _emailController.text
                    .replaceAll('@', '')
                    .trim()
                    .isEmpty)) {
          showCustomSnackBar(context, '이메일 형식에 맞게 기입해주세요.');
        }
        // 빈칸 포함 여부 확인
        if (_emailController.text.contains(' ')) {
          showCustomSnackBar(context, '빈칸 없이 이메일을 기입해주세요.');
          _nameController.clear();
          return;
        }
      }
    });

    // 휴대폰 번호 입력 필드 포커스 리스너 추가 (유효성 체크)
    _phoneNumberFocusNode.addListener(() {
      if (!_phoneNumberFocusNode.hasFocus) {
        // '-'가 포함된 횟수 계산
        // 입력값이 있을 때만 검사
        // '-' 사이 양쪽 어디에든 입력값이 없거나 '-'가 2개 미만인 경우
        // => '-' 기준으로 문자열을 나누어 List<String>로 저장한 후, 부분 문자열(parts)의 길이가 3이 아닌 경우로 구현
        String phoneText = _phoneController.text;
        List<String> parts = phoneText.split('-');
        if (phoneText.isNotEmpty &&
            (parts.length != 3 || parts.any((part) => part.isEmpty))) {
          showCustomSnackBar(context, "'-'를 붙인 휴대폰 번호 형식에 맞게 기입해주세요.");
        }
        // 빈칸 포함 여부 확인
        if (_phoneController.text.contains(' ')) {
          showCustomSnackBar(context, '빈칸 없이 휴대폰 번호를 기입해주세요.');
          _nameController.clear();
          return;
        }
      }
    });

    // ----- 이름 입력 필드 텍스트 변경 리스너 추가 (유효성 체크) 시작
    // 이름 내 빈칸 제한 필터링
    _nameController.addListener(() {
      // 빈칸 입력 방지
      // if (!_nameFocusNode.hasFocus) {
      // 빈칸 포함 여부 확인
      // 입력값이 있을 때만 검사
      if (_nameController.text.isNotEmpty && _nameController.text.contains(' ')) {
        showCustomSnackBar(context, '빈칸 없이 이름을 입력해주세요.');
        _nameController.clear();
        return;
      }

      // 이름 길이 제한 필터링
      // 입력값이 있을 때만 검사
      if (_nameController.text.isNotEmpty && _nameController.text.length > 10) {
        showCustomSnackBar(context, '최대 10자까지 작성 가능합니다.');
        _nameController.text = _nameController.text.substring(0, 10);
        _nameController.selection = TextSelection.fromPosition(
          TextPosition(offset: _nameController.text.length),
        );
      }

      // 영어 비속어 필터링
      // 입력값이 있을 때만 검사
      if (_nameController.text.isNotEmpty && _englishProfanityFilter.hasProfanity(_nameController.text)) {
        showCustomSnackBar(context, '영어 비속어가 포함된 이름은 사용할 수 없습니다.');
        _nameController.clear(); // 필드값이 초기화가 됨
        return;
      }

      // 한국어 비속어 필터링
      // 입력값이 있을 때만 검사
      if (_nameController.text.isNotEmpty && _nameController.text.containsBadWords) {
        showCustomSnackBar(context, '한국어 비속어가 포함된 이름은 사용할 수 없습니다.');
        _nameController.clear();
        return;
      }
      // }
    });
    // ----- 이름 입력 필드 텍스트 변경 리스너 추가 (유효성 체크) 끝
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

    userInfoModifyAndSecessionScreenPointScrollController
        .dispose(); // ScrollController 해제

    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();

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
    final double userInfoModifyAppBarTitleWidth =
        screenSize.width * (240 / referenceWidth);
    final double userInfoModifyAppBarTitleHeight =
        screenSize.height * (22 / referenceHeight);
    final double userInfoModifyAppBarTitleX =
        screenSize.width * (5 / referenceHeight);
    final double userInfoModifyAppBarTitleY =
        screenSize.height * (11 / referenceHeight);

    // body 부분 데이터 내용의 전체 패딩 수치
    final double userInfoModifyPaddingX =
        screenSize.width * (8 / referenceWidth);
    final double nameGuideTextFontSize =
        screenSize.height * (10 / referenceHeight);

    // 이전화면으로 이동 아이콘 관련 수치 동적 적용
    final double userInfoModifyChevronIconWidth =
        screenSize.width * (24 / referenceWidth);
    final double userInfoModifyChevronIconHeight =
        screenSize.height * (24 / referenceHeight);
    final double userInfoModifyChevronIconX =
        screenSize.width * (10 / referenceWidth);
    final double userInfoModifyChevronIconY =
        screenSize.height * (9 / referenceHeight);

    // 컨텐츠 사이의 간격 계산
    final double interval1Y =
        screenSize.height * (16 / referenceHeight); // 세로 간격 1 계산
    final double interval2Y =
        screenSize.height * (32 / referenceHeight); // 세로 간격 2 계산
    final double interval3Y =
        screenSize.height * (10 / referenceHeight); // 세로 간격 3 계산

    // 에러 관련 텍스트 수치
    final double errorTextFontSize1 =
        screenSize.height * (14 / referenceHeight);
    final double errorTextFontSize2 =
        screenSize.height * (12 / referenceHeight);
    final double errorTextHeight = screenSize.height * (600 / referenceHeight);

    final double modifyAndSecessionBtnHeight = screenSize.height * (30 / referenceHeight);
    final double modifyAndSecessionBtnWidth = screenSize.width * (140 / referenceWidth);
    final double modifyAndSecessionBtnFontSize = screenSize.height * (14 / referenceHeight);

    // 텍스트 폰트 크기 수치
    final double loginGuideTextFontSize =
        screenSize.height * (16 / referenceHeight); // 텍스트 크기 비율 계산
    final double loginGuideTextWidth =
        screenSize.width * (393 / referenceWidth); // 가로 비율
    final double loginGuideTextHeight =
        screenSize.height * (22 / referenceHeight); // 세로 비율
    final double loginGuideText1Y = screenSize.height * (270 / referenceHeight);
    final double titleTextWidth =
        screenSize.width * (393 / referenceWidth); // 가로 비율
    final double titleTextFontSize =
        screenSize.height * (16 / referenceHeight); // 텍스트 크기 비율 계산
    final double subTitleTextFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산

    // 로그인 하기 버튼 수치
    final double loginBtnPaddingX = screenSize.width * (20 / referenceWidth);
    final double loginBtnPaddingY = screenSize.height * (5 / referenceHeight);
    final double loginBtnTextFontSize =
        screenSize.height * (14 / referenceHeight);
    final double TextAndBtnInterval =
        screenSize.height * (16 / referenceHeight);

    // 탈퇴하기 버튼 관련 부분 수치
    final double userSecessionInfoCardViewWidth =
        screenSize.width * (393 / referenceWidth); // 가로 비율 계산
    final double userSecessionInfoCardViewPaddingX =
        screenSize.width * (15 / referenceWidth); // 좌우 패딩 계산
    final double userSecessionInfoCardViewPadding1Y =
        screenSize.height * (8 / referenceHeight); // 상하 패딩 계산
    final double checkboxTextFontSize = screenSize.height * (14 / referenceHeight);
    final double userSecessionInfoTextFontSize =
        screenSize.height * (12 / referenceHeight); // 텍스트 크기 비율 계산

    return GestureDetector(
      onTap: () {
        // 입력 필드 외부를 클릭하면 모든 입력 필드의 포커스를 해제
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              controller: userInfoModifyAndSecessionScreenPointScrollController,
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
                        title: '회원정보 수정 및 탈퇴',
                        fontFamily: 'NanumGothic',
                        leadingType: LeadingType.none,
                        buttonCase: 1,
                        appBarTitleWidth: userInfoModifyAppBarTitleWidth,
                        appBarTitleHeight: userInfoModifyAppBarTitleHeight,
                        appBarTitleX: userInfoModifyAppBarTitleX,
                        appBarTitleY: userInfoModifyAppBarTitleY,
                        chevronIconWidth: userInfoModifyChevronIconWidth,
                        chevronIconHeight: userInfoModifyChevronIconHeight,
                        chevronIconX: userInfoModifyChevronIconX,
                        chevronIconY: userInfoModifyChevronIconY,
                      ),
                    ),
                  ),
                  leading: null,
                  // backgroundColor: BUTTON_COLOR,
                ),
                // 실제 컨텐츠를 나타내는 슬리버 리스트
                // 슬리버 패딩을 추가하여 위젯 간 간격 조정함.
                SliverPadding(
                  padding: EdgeInsets.only(top: 5),
                  // Consumer 위젯을 사용하여 cartItemsProvider의 상태를 구독
                  sliver: Consumer(
                    builder: (context, ref, child) {
                      // FirebaseAuth를 사용하여 현재 로그인 상태를 확인
                      final user = FirebaseAuth.instance.currentUser;
                      // 로그인한 회원 정보 데이터 불러오는 변수
                      final userInfoState =
                          ref.watch(userInfoModifyNotifierProvider);
                      // 로딩 상태 변수
                      var isLoading = ref.watch(isLoadingProvider);

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

                      // SliverList를 사용하여 목록 아이템을 동적으로 생성함.
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Padding(
                              // 각 항목의 좌우 간격을 orderlistPaddingX로 설정함.
                              padding: EdgeInsets.symmetric(
                                  horizontal: userInfoModifyPaddingX),
                              child: userInfoState.when(
                                data: (userInfo) {
                                  // 한 번만 Controller에 Firestore 데이터 세팅을 하고,
                                  // userInfo(문서)가 존재하고, 아직 수정한 내용으로 세팅이 되어있지 않는 경우에는 수정한 내용으로 세팅
                                  if (userInfo != null && !_isDataLoaded) {
                                    _nameController.text =
                                        userInfo['name'] ?? '';
                                    _emailController.text =
                                        userInfo['email'] ?? '';
                                    _phoneController.text =
                                        userInfo['phone_number'] ?? '';
                                    _isDataLoaded = true; // 한 번 세팅 후에는 true
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: interval3Y),
                                      Container(
                                        width: titleTextWidth,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '회원정보 수정',
                                          style: TextStyle(
                                            fontSize: titleTextFontSize,
                                            // 텍스트 크기 설정
                                            fontWeight: FontWeight.bold,
                                            // 텍스트 굵기 설정
                                            fontFamily: 'NanumGothic',
                                            // 글꼴 설정
                                            color: BLACK_COLOR, // 텍스트 색상 설정
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: interval3Y),
                                      _buildFixedValueRow(context, 'SNS 계정',
                                          userInfo?['registration_id'] ?? ''),
                                      SizedBox(height: interval1Y),
                                      _buildEditableRow(
                                          context,
                                          '이름',
                                          _nameController,
                                          _nameFocusNode,
                                          "'성'을 붙여서 이름을 기입해주세요."),
                                      Align(
                                        alignment: Alignment.centerLeft, // 왼쪽 정렬
                                        child: Text(
                                          '* 빈칸 없이 최대 10자 이내이며, 비속어는 사용할 수 없습니다.',
                                          style: TextStyle(
                                            fontSize: nameGuideTextFontSize,
                                            fontFamily: 'NanumGothic',
                                            fontWeight: FontWeight.normal,
                                            color: GRAY60_COLOR,
                                          ),
                                        ),
                                      ),
                                      _buildEditableRow(
                                          context,
                                          '이메일',
                                          _emailController,
                                          _emailFocusNode,
                                          "이메일 형식에 맞게 이메일을 기입해주세요."),
                                      Align(
                                        alignment: Alignment.centerLeft, // 왼쪽 정렬
                                        child: Text(
                                          '* 예) abc@naver.com, abc@hanmail.net',
                                          style: TextStyle(
                                            fontSize: nameGuideTextFontSize,
                                            fontFamily: 'NanumGothic',
                                            fontWeight: FontWeight.normal,
                                            color: GRAY60_COLOR,
                                          ),
                                        ),
                                      ),
                                      _buildEditableRow(
                                          context,
                                          '휴대폰 번호',
                                          _phoneController,
                                          _phoneNumberFocusNode,
                                          "'-'를 붙여서 연락처를 기입해주세요."),
                                      Align(
                                        alignment: Alignment.centerLeft, // 왼쪽 정렬
                                        child: Text(
                                          '* 예) 010-XXXX-XXXX',
                                          style: TextStyle(
                                            fontSize: nameGuideTextFontSize,
                                            fontFamily: 'NanumGothic',
                                            fontWeight: FontWeight.normal,
                                            color: GRAY60_COLOR,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: interval2Y),
                                      Center(
                                        child: Container(
                                          width: modifyAndSecessionBtnWidth,
                                          height: modifyAndSecessionBtnHeight,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor:
                                                  _isModifyEnabled()
                                                      ? SOFTGREEN60_COLOR
                                                      : GRAY62_COLOR,
                                              backgroundColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              side: BorderSide(
                                                color: _isModifyEnabled()
                                                    ? SOFTGREEN60_COLOR
                                                    : GRAY62_COLOR,
                                              ),
                                            ),
                                            onPressed: _isModifyEnabled()
                                                ? () {
                                                    if (!_validateEmailFormat() ||
                                                        !_validatePhoneNumberFormat() ||
                                                        !_validateNameLength()) {
                                                      showCustomSnackBar(
                                                          context,
                                                          '각 입력칸에 정보를 형식에 맞게 제대로 기입해주세요.');
                                                      return;
                                                    }
                                                    _modifyUserInfo();
                                                  }
                                                : null,
                                            child: isLoading
                                                ? buildCommonLoadingIndicator()
                                                : Text(
                                                    '수정하기',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          modifyAndSecessionBtnFontSize,
                                                      color: _isModifyEnabled()
                                                          ? SOFTGREEN60_COLOR
                                                          : GRAY40_COLOR,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: interval2Y),
                                      Container(
                                        width: titleTextWidth,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '회원정보 탈퇴',
                                          style: TextStyle(
                                            fontSize: titleTextFontSize,
                                            // 텍스트 크기 설정
                                            fontWeight: FontWeight.bold,
                                            // 텍스트 굵기 설정
                                            fontFamily: 'NanumGothic',
                                            // 글꼴 설정
                                            color: BLACK_COLOR, // 텍스트 색상 설정
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: interval1Y),
                                      Text(
                                        '준수사항',
                                        style: TextStyle(
                                          fontSize: subTitleTextFontSize,
                                          // 텍스트 크기 설정
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'NanumGothic',
                                          // 글꼴 설정
                                          color: BLACK_COLOR, // 텍스트 색상 설정
                                        ),
                                      ),
                                      SizedBox(height: interval3Y),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          width: userSecessionInfoCardViewWidth,
                                          color: GRAY97_COLOR, // 배경색 설정
                                          child: CommonCardView(
                                            backgroundColor: GRAY97_COLOR,
                                            // 배경색 설정
                                            elevation: 0,
                                            // 그림자 깊이 설정
                                            content: Padding(
                                              // 패딩 설정
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      userSecessionInfoCardViewPadding1Y,
                                                  horizontal:
                                                      userSecessionInfoCardViewPaddingX),
                                              // 상하 좌우 패딩 설정
                                              child: Column(
                                                // 컬럼 위젯으로 구성함
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '1. 회원 탈퇴 시 모든 혜택이 소멸됩니다.',
                                                    style: TextStyle(
                                                      fontSize: userSecessionInfoTextFontSize,
                                                      // 텍스트 크기 설정
                                                      fontWeight: FontWeight.normal,
                                                      fontFamily: 'NanumGothic',
                                                      // 글꼴 설정
                                                      color: BLACK_COLOR, // 텍스트 색상 설정
                                                  ),
                                                  ),
                                                  Text(
                                                    '2. 동일한 SNS 계정으로 재가입은 30일간 제한됩니다.',
                                                    style: TextStyle(
                                                      fontSize: userSecessionInfoTextFontSize,
                                                      // 텍스트 크기 설정
                                                      fontWeight: FontWeight.normal,
                                                      fontFamily: 'NanumGothic',
                                                      // 글꼴 설정
                                                      color: BLACK_COLOR, // 텍스트 색상 설정
                                                    ),
                                                  ),
                                                  Text(
                                                    '3. 탈퇴 후 데이터 복구는 불가능합니다.',
                                                    style: TextStyle(
                                                      fontSize: userSecessionInfoTextFontSize,
                                                      // 텍스트 크기 설정
                                                      fontWeight: FontWeight.normal,
                                                      fontFamily: 'NanumGothic',
                                                      // 글꼴 설정
                                                      color: BLACK_COLOR, // 텍스트 색상 설정
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: interval1Y),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                            value: isChecked,
                                            onChanged: (value) {
                                              setState(() {
                                                isChecked = value ?? false;
                                              });
                                            },
                                            activeColor: SOFTGREEN60_COLOR, // 피그마에서 체크박스 색상을 투명하게 설정
                                            checkColor: WHITE_COLOR, // 체크 표시 색상
                                          ),
                                          Expanded(
                                            child: Text(
                                              '위 내용을 숙지하였으며 탈퇴에 동의합니다.',
                                              style: TextStyle(
                                                  fontSize:
                                                      checkboxTextFontSize),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: interval1Y),
                                      // "탈퇴하기" 버튼: 아래 부분이 변경된 로직
                                      Consumer(
                                        builder: (context, ref, child) {
                                          // 회원 탈퇴 관련 비동기 상태를 가져옴
                                          final secessionState = ref.watch(
                                              userSecessionNotifierProvider);

                                          return Center(
                                            // 버튼을 감싸는 컨테이너를 생성함
                                            child: Container(
                                              width: modifyAndSecessionBtnWidth, // 버튼의 너비를 설정함
                                              height:
                                              modifyAndSecessionBtnHeight, // 버튼의 높이를 설정함
                                              child: ElevatedButton(
                                                // ElevatedButton 스타일 설정 시작
                                                style: ElevatedButton.styleFrom(
                                                  // 버튼 텍스트 색상을 설정함
                                                  foregroundColor: isChecked
                                                      ? SOFTGREEN60_COLOR // 체크된 경우의 색상
                                                      : GRAY62_COLOR, // 체크되지 않은 경우의 색상
                                                  // 버튼 배경색을 테마의 배경색으로 설정함
                                                  backgroundColor:
                                                  Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  // 버튼 테두리 색상을 설정함
                                                  side: BorderSide(
                                                    color: isChecked
                                                        ? SOFTGREEN60_COLOR // 체크된 경우의 색상
                                                        : GRAY62_COLOR, // 체크되지 않은 경우의 색상
                                                  ),
                                                ),
                                                // 버튼의 onPressed 동작 설정 시작
                                                onPressed: isChecked
                                                    ? () async {
                                                  // 만약 secessionState가 로딩 중이면 중복 호출을 방지함
                                                  if (secessionState
                                                  is AsyncLoading) {
                                                    return;
                                                  }
                                                  // 탈퇴 로직을 실행함
                                                  await onSecessionPressed();
                                                }
                                                    : null, // 버튼이 비활성화된 경우 null 처리
                                                // 버튼 내부 위젯 설정 시작
                                                child: secessionState.maybeWhen(
                                                  // 로딩 상태일 때 로딩 인디케이터를 표시함
                                                  loading: () =>
                                                      buildCommonLoadingIndicator(),
                                                  // 기본 상태일 때 텍스트를 표시함
                                                  orElse: () => Text(
                                                    '탈퇴하기', // 버튼에 표시할 텍스트
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold, // 텍스트를 굵게 설정함
                                                      fontSize:
                                                      modifyAndSecessionBtnFontSize, // 텍스트 크기를 설정함
                                                      color: isChecked
                                                          ? SOFTGREEN60_COLOR // 체크된 경우의 색상
                                                          : GRAY40_COLOR, // 체크되지 않은 경우의 색상
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      // "탈퇴하기" 버튼 끝
                                      SizedBox(height: interval2Y),
                                    ],
                                  );
                                },
                                loading: () => buildCommonLoadingIndicator(),
                                // 공통 로딩 인디케이터 호출
                                error: (error, stack) => Container(
                                  // 에러 상태에서 중앙 배치
                                  height: errorTextHeight,
                                  // 전체 화면 높이 설정
                                  alignment: Alignment.center,
                                  // 중앙 정렬
                                  child: buildCommonErrorIndicator(
                                    message: '에러가 발생했으니, 앱을 재실행해주세요.',
                                    // 첫 번째 메시지 설정
                                    secondMessage:
                                        '에러가 반복될 시, \'문의하기\'에서 문의해주세요.',
                                    // 두 번째 메시지 설정
                                    fontSize1: errorTextFontSize1,
                                    // 폰트1 크기 설정
                                    fontSize2: errorTextFontSize2,
                                    // 폰트2 크기 설정
                                    color: BLACK_COLOR,
                                    // 색상 설정
                                    showSecondMessage:
                                        true, // 두 번째 메시지를 표시하도록 설정
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount:
                              1, // 하나의 큰 Column이 모든 카드뷰를 포함하고 있기 때문에 1로 설정
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            buildTopButton(
                context, userInfoModifyAndSecessionScreenPointScrollController),
          ],
        ),
        bottomNavigationBar: buildCommonBottomNavigationBar(
            ref.watch(tabIndexProvider), ref, context, 5, 1,
            scrollController:
                userInfoModifyAndSecessionScreenPointScrollController),
      ),
    );
  }

  // Firestore에 회원 정보 수정 내용 반영하여 저장하는 함수
  Future<void> _modifyUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email ?? user?.uid ?? '';

    setState(() {
      isLoading = true;
    });
    try {
      // FireStore에 변경된 사용자 정보 반영하여 저장
      await ref.read(userInfoModifyNotifierProvider.notifier).updateUserInfo(
        email: userEmail,
        updatedData: {
          'name': _nameController.text,
          'email': _emailController.text,
          'phone_number': _phoneController.text,
        },
      );

      showCustomSnackBar(context, '회원정보가 수정되었습니다.');

      // 회원 정보 수정 후 마이페이지으로 화면 이동
      // FireStore 저장 완료 후 화면 이동
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => ProfileMainScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      showCustomSnackBar(context, '회원정보 수정 중 문제가 발생했습니다: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 이메일 형식 유효성 검증 함수
  bool _validateEmailFormat() {
    // @를 포함하고 @를 제외한 값이 비어있지 않은 경우에만 유효함
    return _emailController.text.contains('@') &&
        _emailController.text.replaceAll('@', '').trim().isNotEmpty;
  }

  // 휴대폰 번호 형식 유효성 검증 함수
  bool _validatePhoneNumberFormat() {
    String phoneText = _phoneController.text;
    List<String> parts = phoneText.split('-');
    // '-' 사이 양쪽 어디에든 입력값이 없거나 '-'가 2개 이상인 경우에만 유효함
    return parts.length == 3 && parts.every((part) => part.isNotEmpty);
  }

  // 이름 길이 유효성 검증 함수
  bool _validateNameLength() {
    // 빈 값이고, 10자 이하인 경우에만 유효함
    return _nameController.text.isNotEmpty &&
        _nameController.text.length <= 10;
  }

  // 수정하기 버튼 활성화 상태 확인 함수
  bool _isModifyEnabled() {
    // 원본 코드에서는 '하나라도 값이 있다면' 버튼이 활성화되도록 작성되어 있으나,
    // 일반적으로는 "이름, 이메일, 휴대폰 번호 모두 입력"일 경우에만 활성화시키는 등
    // 조건을 다양하게 변경할 수도 있음.
    return _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;
  }

  // 회원 탈퇴를 진행하는 함수
  Future<void> onSecessionPressed() async {

    // 현재 로그인한 유저
    final currentUser =
        FirebaseAuth.instance.currentUser;
    final userEmail = currentUser?.email ??
        currentUser?.uid ??
        '';

    await showSubmitAlertDialog(
      context,
      title: '[회원 탈퇴]',
      content:
      '탈퇴 시, 해당 계정은 30일간 재가입이 불가하며,\n데이터 복구는 불가능합니다.\n정말 탈퇴하시겠습니까?',
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            '아니요',
            style: TextStyle(
              color: Colors.black,
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            try {
              // 레포지토리 호출
              await ref
                  .read(
                  userSecessionNotifierProvider
                      .notifier)
                  .secessionUser(
                  userEmail);

              // 탈퇴가 성공하면 Firebase 로그아웃
              await FirebaseAuth.instance
                  .signOut();

              // 홈 화면으로 이동
              if (!mounted) return;
              Navigator
                  .pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      HomeMainScreen(),
                ),
                    (route) => false,
              );

              showCustomSnackBar(
                  context, '회원 탈퇴가 완료되었습니다.');
            } catch (e) {
              showCustomSnackBar(
                  context,
                  '회원 탈퇴 중 오류 발생: $e');
            }
          },
          child: Text(
            '예',
            style: TextStyle(
              color: Colors.red,
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // 고정된 값을 가진 행을 생성하는 함수
  Widget _buildFixedValueRow(BuildContext context, String label, String value) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 회원가입 정보 표 부분 수치
    final double signUpInfoTextFontSize =
        screenSize.height * (13 / referenceHeight);
    final double signUpInfoDataFontSize =
        screenSize.height * (8 / referenceHeight);
    final double signUpInfoTextPartWidth =
        screenSize.width * (97 / referenceWidth);
    final double signUpInfoTextPartHeight =
        screenSize.height * (40 / referenceHeight);

    // 행 간 간격 수치
    final double signUpInfo4Y = screenSize.height * (2 / referenceHeight);
    final double signUpInfo1X = screenSize.width * (4 / referenceWidth);

    // 데이터 부분 패딩 수치
    final double signUpInfoDataPartX = screenSize.width * (8 / referenceWidth);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: signUpInfo4Y),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
          children: [
            Container(
              height: signUpInfoTextPartHeight,
              width: signUpInfoTextPartWidth,
              // 라벨 셀의 너비 설정
              decoration: BoxDecoration(
                // color: GRAY96_COLOR,
                color: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                border: Border.all(color: GRAY83_COLOR, width: 1), // 윤곽선
                borderRadius:
                    // BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)), // 왼쪽만 둥글게
                    BorderRadius.circular(6),
              ),
              // 배경 색상 설정
              alignment: Alignment.center,
              // 텍스트 정렬
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NanumGothic',
                  fontSize: signUpInfoTextFontSize,
                  color: BLACK_COLOR,
                ), // 텍스트 스타일 설정
              ),
            ),
            SizedBox(width: signUpInfo1X), // 왼쪽과 오른쪽 사이 간격 추가
            Expanded(
              child: Container(
                // 데이터 셀의 너비 설정
                decoration: BoxDecoration(
                  // color: GRAY98_COLOR, // 앱 기본 배경색
                  color: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                  border: Border.all(color: GRAY83_COLOR, width: 1), // 윤곽선
                  // borderRadius: BorderRadius.only(
                  //   topRight: Radius.circular(6),
                  //   bottomRight: Radius.circular(6),
                  // ), // 오른쪽만 둥글게
                  borderRadius: BorderRadius.circular(6),
                ),
                // color: Colors.red, // 배경 색상 설정
                padding: EdgeInsets.symmetric(horizontal: signUpInfoDataPartX),
                alignment: Alignment.centerLeft, // 텍스트 정렬
                child: Text(
                  value ?? '',
                  style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: signUpInfoDataFontSize,
                    color: BLACK_COLOR,
                  ),
                ), // 값 표시
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 수정 가능한 행을 생성하는 함수
Widget _buildEditableRow(BuildContext context, String label,
    TextEditingController controller, FocusNode focusNode, String hintText) {
  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 회원가입 정보 표 부분 수치
  final double signUpInfoTextFontSize =
      screenSize.height * (13 / referenceHeight);
  final double signUpInfoDataFontSize =
      screenSize.height * (12 / referenceHeight);
  final double signUpInfoTextPartWidth =
      screenSize.width * (97 / referenceWidth);
  final double signUpInfoTextPartHeight =
      screenSize.height * (40 / referenceHeight);
  // 행 간 간격 수치
  final double signUpInfo4Y = screenSize.height * (2 / referenceHeight);
  final double signUpInfo1X = screenSize.width * (4 / referenceWidth);
  // 데이터 부분 패딩 수치
  final double signUpInfoDataPartX = screenSize.width * (8 / referenceWidth);

  // FocusNode의 상태 변화 감지 리스너 추가
  return StatefulBuilder(
    builder: (context, setState) {
      // // FocusNode의 상태 변화 감지 리스너
      focusNode.addListener(() {
        // 이렇게 구현해야 해당 화면에서 값 수정 후 복귀 시, 다시 입력 필드 클릭해서
        // 포커스 노드가 생길 때, 오류가 발생하지않음!!
        // 1) 현재 이 위젯이 아직 트리에 남아있는지 확인
        if (!context.mounted) return;

        // 2) 남아있다면 setState() 진행
        setState(() {});
      });

      return Padding(
        padding: EdgeInsets.symmetric(vertical: signUpInfo4Y),
        // 행의 상하단에 2.0 픽셀의 여백 추가
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
            children: [
              Container(
                width: signUpInfoTextPartWidth,
                // 셀의 너비 설정
                height: signUpInfoTextPartHeight,
                // 셀의 높이 설정
                // 라벨 셀의 너비 설정
                decoration: BoxDecoration(
                  // color: GRAY96_COLOR,
                  color: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                  border: Border.all(color: GRAY83_COLOR, width: 1), // 윤곽선
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                // 텍스트를 중앙 정렬
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: signUpInfoTextFontSize,
                    color: BLACK_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: signUpInfo1X), // 왼쪽과 오른쪽 사이 간격 추가
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                    border: Border.all(
                      color: focusNode.hasFocus
                          ? SOFTGREEN60_COLOR
                          : GRAY83_COLOR, // 포커스 여부에 따른 색상 변경
                      width: 1.0,
                    ), // 윤곽선
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: signUpInfoDataPartX),
                  alignment: Alignment.centerLeft, // 텍스트 정렬
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context)
                          .requestFocus(focusNode); // 행을 탭할 때 포커스를 설정
                    },
                    child: TextField(
                      controller: controller,
                      // 텍스트 필드 컨트롤러 설정
                      focusNode: focusNode,
                      // 텍스트 필드 포커스 노드 설정
                      cursorColor: SOFTGREEN60_COLOR,
                      // 커서 색상 설정
                      style: TextStyle(
                        fontFamily: 'NanumGothic',
                        fontSize: signUpInfoDataFontSize,
                        color: BLACK_COLOR,
                        fontWeight: FontWeight.normal,
                      ),
                      // 텍스트 필드 스타일 설정
                      decoration: InputDecoration(
                        hintText: hintText,
                        // 힌트 텍스트 설정
                        hintStyle: TextStyle(color: GRAY74_COLOR),
                        // 힌트 텍스트 색상 설정
                        hintMaxLines: 2,
                        // 힌트 텍스트 최대 줄 수 설정
                        border: InputBorder.none,
                        // 입력 경계선 제거
                        isDense: true,
                        // 간격 설정
                        contentPadding: EdgeInsets.zero, // 내용 여백 제거
                      ),
                      maxLines: null,
                      // 최대 줄 수 설정
                      onChanged: (value) {
                        print('텍스트 필드 $label 변경됨: $value'); // 디버깅 메시지 추가
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
// _UserInfoModifyScreenState 클래스 끝
