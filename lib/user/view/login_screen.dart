// Flutter의 UI 구성 요소를 제공하는 Material 디자인 패키지를 임포트합니다.
import 'dart:async';

import 'package:flutter/material.dart';

// 상태 관리를 위한 현대적인 라이브러리인 Riverpod를 임포트합니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Firebase의 사용자 인증 기능을 제공하는 FirebaseAuth 패키지를 임포트합니다.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../cart/provider/cart_state_provider.dart';
import '../../common/component/custom_text_form_field.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../common/provider/common_state_provider.dart';
import '../../home/view/home_screen.dart';
import '../provider/user_me_provider.dart';
import 'membership_registration_info_screen.dart';

// ------- 로그인 화면 관련 클래스인 LoginScreen 내용 부분 시작
class LoginScreen extends ConsumerStatefulWidget {
  // 라우트 이름 정의
  static String get routeName => 'login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // FirebaseAuth 인스턴스 초기화
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 이메일 입력을 위한 컨트롤러
  final TextEditingController emailController = TextEditingController();

  // 비밀번호 입력을 위한 컨트롤러
  final TextEditingController passwordController = TextEditingController();

  // 이메일 입력 필드의 포커스 노드
  FocusNode emailFocusNode = FocusNode();

  // 비밀번호 입력 필드의 포커스 노드
  FocusNode passwordFocusNode = FocusNode();

  // 사용자 이메일 저장 변수
  String username = '';

  // 사용자 비밀번호 저장 변수
  String password = '';

  // 자동 로그인 여부 저장 변수
  bool autoLogin = false;

  // 로그인 오류 메시지 저장 변수
  String? errorMessage;

  // 로그인 성공 시 버튼 색상을 변경하기 위한 변수
  Color buttonColor = Color(0xFF303030); // 기본 색상

  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  @override
  void initState() {
    super.initState();
    // 자동 로그인 정보 불러옴
    _loadAutoLogin();

    // 이메일 필드에 포커스가 생기면 오류 메시지를 초기화
    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {
        setState(() {
          errorMessage = null;
        });
      }
    });

    // 비밀번호 필드에 포커스가 생기면 오류 메시지를 초기화
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        setState(() {
          errorMessage = null;
        });
      }
    });

    // 네트워크 상태 체크 시작
    _networkChecker = NetworkChecker(context);
    _networkChecker?.checkNetworkStatus();
  }

  @override
  void dispose() {
    // 포커스 노드 해제
    emailFocusNode.dispose();
    passwordFocusNode.dispose();

    // 네트워크 체크 해제
    _networkChecker?.dispose();

    super.dispose();
  }

// 로그인 함수
  void _login() async {
    try {
      // FirebaseAuth를 사용하여 이메일과 비밀번호로 로그인 시도
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      // 로그인한 사용자 정보 가져옴
      User? user = userCredential.user;
      if (user != null) {
        // 로그인 성공 시 버튼 색상을 변경
        setState(() {
          buttonColor = Color(0xFF4934CE); // 피그마에서 지정한 색상으로 변경
        });

        // 자동로그인이 체크된 경우에만 이메일과 비밀번호 저장
        // => 자동로그인만 체크되어 있으면 앱을 재실행 시, 로그인이 되어 홈 화면으로 진입하던 이슈 해결 포인트!!
        if (autoLogin) {
          _saveAutoLogin(); // 로그인 성공 시에만 자동로그인 정보 저장
        }

        // 1초 후에 홈 화면으로 이동
        Timer(Duration(seconds: 1), () {
          // userMeProvider를 통해 사용자 정보 저장
          ref.read(userMeProvider.notifier).login(
                email: username,
                password: password,
              );
          // cartItemsProvider를 통해 장바구니 데이터 로드
          ref.read(cartItemsProvider.notifier).loadCartItems(); // 장바구니 데이터 로드

          // 탭 인덱스를 0으로 설정
          ref.read(tabIndexProvider.notifier).state = 0;
          // 홈 화면으로 이동 및 현재 화면을 대체
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => HomeMainScreen()),
          );
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = "입력하신 아이디 또는 비밀번호가 일치하지 않습니다.";
      });
    }
  }

  // SharedPreferences에서 자동 로그인 정보 불러오는 함수
  void _loadAutoLogin() async {
    // SharedPreferences 인스턴스 가져옴
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState로 상태 업데이트
    setState(() {
      // autoLogin 값을 SharedPreferences에서 불러오고, 값이 없으면 false 설정
      autoLogin = prefs.getBool('autoLogin') ?? false;
      if (autoLogin) {
        // autoLogin이 true인 경우, username과 password를 SharedPreferences에서 불러옴
        username = prefs.getString('username') ?? '';
        password = prefs.getString('password') ?? '';

        // 이메일과 비밀번호가 있을 경우에만 로그인 시도
        // => 자동로그인만 체크되어 있으면 앱을 재실행 시, 로그인이 되어 홈 화면으로 진입하던 이슈 해결 포인트!!
        if (username.isNotEmpty && password.isNotEmpty) {
          _login();
        }
      }
    });
  }

  // SharedPreferences에 자동 로그인 정보 저장하는 함수
  void _saveAutoLogin() async {
    // SharedPreferences 인스턴스 가져옴
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (autoLogin) {
      // autoLogin이 true인 경우, username과 password를 SharedPreferences에 저장
      prefs.setString('username', username);
      prefs.setString('password', password);
    } else {
      // autoLogin이 false인 경우, username과 password를 SharedPreferences에서 삭제
      prefs.remove('username');
      prefs.remove('password');
    }
    // autoLogin 값을 SharedPreferences에 저장
    prefs.setBool('autoLogin', autoLogin);
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 화면 이름 부분 수치
    final double screenNameTop =
        screenSize.height * (54 / referenceHeight); // 위쪽 여백 비율

    // 화면 제목 부분 수치
    final double screenTitleLeft =
        screenSize.width * (51 / referenceWidth); // 왼쪽 여백 비율
    final double screenTitleTop =
        screenSize.height * (227 / referenceHeight); // 위쪽 여백 비율
    final double screenLoginText1FontSize =
        screenSize.height * (24 / referenceHeight);
    final double screenTitleTextFontSize =
        screenSize.height * (26 / referenceHeight);

    // 화면 서브제목 부분 수치
    final double screenSubTitleLeft =
        screenSize.width * (49 / referenceWidth); // 왼쪽 여백 비율
    final double screenSubTitleTop =
        screenSize.height * (268 / referenceHeight); // 위쪽 여백 비율
    final double screenSubTitleTextFontSize =
        screenSize.height * (14 / referenceHeight);

    // 이메일 입력 필드 및 비밀번호 입력 필드 수치
    final double insertFieldWidth =
        screenSize.width * (313 / referenceWidth); // 가로 비율
    final double insertFieldHeight =
        screenSize.height * (42 / referenceHeight); // 세로 비율
    final double insertFieldLeft =
        screenSize.width * (40 / referenceWidth); // 왼쪽 여백 비율
    final double insertFieldTextFontSize1 =
        screenSize.height * (12 / referenceHeight);
    final double insertFieldTextFontSize2 =
        screenSize.height * (14 / referenceHeight);
    final double insertFieldX =
        screenSize.width * (10 / referenceWidth);
    final double insertFieldY =
        screenSize.height * (5 / referenceHeight);
    final double emailFieldTop =
        screenSize.height * (330 / referenceHeight); // 위쪽 여백 비율
    final double passwordFieldTop =
        screenSize.height * (380 / referenceHeight); // 위쪽 여백 비율

    // 자동로그인 부분 수치
    final double autoLoginCheckboxLeft =
        screenSize.width * (56 / referenceWidth); // 왼쪽 여백 비율
    final double autoLoginCheckboxTop =
        screenSize.height * (434 / referenceHeight); // 위쪽 여백 비율
    final double autoLoginCheckboxWidth =
        screenSize.width * (16 / referenceWidth); // 너비 비율
    final double autoLoginCheckboxHeight =
        screenSize.height * (16 / referenceHeight); // 높이 비율
    final double autoLoginTextLeft =
        screenSize.width * (80 / referenceWidth); // 왼쪽 여백 비율
    final double autoLoginTextTop =
        screenSize.height * (436 / referenceHeight); // 위쪽 여백 비율
    final double autoLoginCheckboxTextFontSize =
        screenSize.height * (12 / referenceHeight);

    // 로그인 버튼 부분 수치
    final double loginBtnLeft =
        screenSize.width * (40 / referenceWidth); // 왼쪽 여백 비율
    final double loginBtnTop =
        screenSize.height * (487 / referenceHeight); // 위쪽 여백 비율
    final double loginBtnWidth =
        screenSize.width * (313 / referenceWidth); // 너비 비율
    final double loginBtnHeight =
        screenSize.height * (42 / referenceHeight); // 높이 비율
    final double loginBtnTextFontSize =
        screenSize.height * (16 / referenceHeight);

    // 로그인 에러 메세지 바 부분 수치
    final double loginErrorMessageBarLeft =
        screenSize.width * (40 / referenceWidth); // 왼쪽 여백 비율
    final double loginErrorMessageBarTop =
        screenSize.height * (456 / referenceHeight); // 위쪽 여백 비율
    final double loginErrorMessageBarWidth =
        screenSize.width * (313 / referenceWidth); // 너비 비율
    final double loginErrorMessageBarHeight =
        screenSize.height * (24 / referenceHeight); // 높이 비율
    final double loginErrorMessageBarTextFontSize =
        screenSize.height * (12 / referenceHeight);

    // 회원가입 및 아이디/비밀번호 찾기 버튼 부분 수치
    final double joinAndFindBtnLeft =
        screenSize.width * (88 / referenceWidth); // 왼쪽 여백 비율
    final double joinAndFindBtnTop =
        screenSize.height * (543 / referenceHeight); // 위쪽 여백 비율
    final double joinAndFindBtnWidth =
        screenSize.width * (218 / referenceWidth); // 너비 비율
    final double joinAndFindBtnHeight =
        screenSize.height * (24 / referenceHeight); // 높이 비율
    final double joinAndFindBtnTextFontSize =
        screenSize.height * (12 / referenceHeight);

    return Scaffold(
      body: Stack(
        children: [
          // 화면 크기에 맞게 배경 이미지 설정
          Positioned.fill(
            child: Image.asset(
              'asset/img/misc/login_image/couture_login_bg_img.png',
              fit: BoxFit.cover, // 화면을 꽉 채우도록 설정
              width: screenSize.width, // 화면 너비
              height: screenSize.height, // 화면 높이
            ),
          ),
          // 화면 제목 (Login)
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: screenNameTop),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: screenLoginText1FontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // 타이틀 텍스트
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:
                  EdgeInsets.only(left: screenTitleLeft, top: screenTitleTop),
              child: Text(
                '오늘도 나만의 옷을 PICK!',
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.bold,
                  fontSize: screenTitleTextFontSize,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // 서브 타이틀 텍스트
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  left: screenSubTitleLeft, top: screenSubTitleTop),
              child: Text(
                '이메일과 비밀번호를 입력해서 로그인해주세요! :)',
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.normal,
                  fontSize: screenSubTitleTextFontSize,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // 이메일 입력 필드
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:
                  EdgeInsets.only(left: insertFieldLeft, top: emailFieldTop),
              child: Container(
                width: insertFieldWidth,
                height: insertFieldHeight,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85), // Figma에서 지정한 투명도 반영
                  borderRadius: BorderRadius.circular(5.0), // 둥근 모서리 반영
                  // Figma에서 설정된 효과 추가 (Background blur는 Flutter에서 직접 지원하지 않으므로 Color와 Opacity로 대체)
                ),
                child: CustomTextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  hintText: '이메일을 입력해주세요.',
                  hintStyle: TextStyle(
                    fontFamily: 'NanumGothic', // Figma에서 사용된 폰트
                    fontSize: insertFieldTextFontSize1, // Figma에서 설정된 폰트 크기
                    fontWeight: FontWeight.normal, // Figma에서 설정된 굵기
                    color: Color(0xFF818181), // Figma에서 설정된 색상 (818181)
                  ),
                  hintTextPadding: EdgeInsets.only(left: insertFieldX, top: insertFieldY),
                  // Figma에서 제공된 위치 반영
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (String value) {
                    username = value;
                  },
                  textStyle: TextStyle(
                    fontFamily: 'NanumGothic', // 피그마에서 사용된 폰트
                    fontSize: insertFieldTextFontSize2, // 피그마에서 지정된 폰트 크기
                    fontWeight: FontWeight.bold, // 피그마에서 설정된 굵기
                    color: Color(0xFF4933CE), // 텍스트 색상
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent, // 비활성 상태에서는 투명한 테두리
                      ),
                      borderRadius: BorderRadius.circular(5.0), // 둥근 모서리 반영
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF4933CE),
                        // 활성화된 상태에서는 지정된 색상 (피그마에서 설정된 테두리 색상)
                        width: 2.0, // 테두리 두께
                      ),
                      borderRadius: BorderRadius.circular(5.0), // 둥근 모서리 반영
                    ),
                    fillColor: Colors.white.withOpacity(0.85), // 배경색
                    filled: true, // 배경색 채우기
                  ),
                ),
              ),
            ),
          ),
          // 비밀번호 입력 필드
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:
                  EdgeInsets.only(left: insertFieldLeft, top: passwordFieldTop),
              child: Container(
                width: insertFieldWidth,
                height: insertFieldHeight,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85), // Figma에서 지정한 투명도 반영
                  borderRadius: BorderRadius.circular(5.0), // 둥근 모서리 반영
                  // Figma에서 설정된 효과 추가 (Background blur는 Flutter에서 직접 지원하지 않으므로 Color와 Opacity로 대체)
                ),
                child: CustomTextFormField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  hintText: '비밀번호를 입력해주세요.',
                  hintStyle: TextStyle(
                    fontFamily: 'NanumGothic', // Figma에서 사용된 폰트
                    fontSize: insertFieldTextFontSize1, // Figma에서 설정된 폰트 크기
                    fontWeight: FontWeight.normal, // Figma에서 설정된 굵기
                    color: Color(0xFF818181), // Figma에서 설정된 색상 (818181)
                  ),
                  hintTextPadding: EdgeInsets.only(left: insertFieldX, top: insertFieldY),
                  // Figma에서 제공된 위치 반영
                  obscureText: true,
                  onChanged: (String value) {
                    password = value;
                  },
                  textStyle: TextStyle(
                    fontFamily: 'NanumGothic', // 피그마에서 사용된 폰트
                    fontSize: insertFieldTextFontSize2, // 피그마에서 지정된 폰트 크기
                    fontWeight: FontWeight.normal, // 피그마에서 설정된 굵기
                    color: Color(0xFF4933CE), // 텍스트 색상
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent, // 비활성 상태에서는 투명한 테두리
                      ),
                      borderRadius: BorderRadius.circular(5.0), // 둥근 모서리 반영
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF4933CE),
                        // 활성화된 상태에서는 지정된 색상 (피그마에서 설정된 테두리 색상)
                        width: 2.0, // 테두리 두께
                      ),
                      borderRadius: BorderRadius.circular(5.0), // 둥근 모서리 반영
                    ),
                    fillColor: Colors.white.withOpacity(0.85), // 배경색
                    filled: true, // 배경색 채우기
                  ),
                ),
              ),
            ),
          ),
          // 자동 로그인 체크박스
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  left: autoLoginCheckboxLeft, top: autoLoginCheckboxTop),
              child: Container(
                width: autoLoginCheckboxWidth, // Figma에서 지정한 너비
                height: autoLoginCheckboxHeight, // Figma에서 지정한 높이
                decoration: BoxDecoration(
                  color: Colors.white, // Figma에서 지정한 색상
                  borderRadius:
                      BorderRadius.circular(2.0), // Figma에서 지정한 둥근 모서리
                ),
                child: Checkbox(
                  value: autoLogin,
                  onChanged: (bool? value) {
                    setState(() {
                      autoLogin = value ?? false;
                    });
                  },
                  activeColor: Color(0xFF4933CE), // 피그마에서 체크박스 색상을 투명하게 설정
                  checkColor: Colors.white, // 체크 표시 색상
                ),
              ),
            ),
          ),
          // 자동 로그인 텍스트
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  left: autoLoginTextLeft, top: autoLoginTextTop),
              child: Text(
                '자동로그인',
                style: TextStyle(
                  fontFamily: 'NanumGothic', // 피그마에서 사용된 폰트
                  fontSize: autoLoginCheckboxTextFontSize, // 피그마에서 지정된 폰트 크기
                  fontWeight: FontWeight.bold, // 피그마에서 지정된 굵기
                  color: Colors.white.withOpacity(0.9), // 피그마에서 지정된 색상 및 투명도
                ),
              ),
            ),
          ),
          // 로그인 버튼
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: loginBtnLeft, top: loginBtnTop),
              child: Container(
                width: loginBtnWidth,
                height: loginBtnHeight,
                decoration: BoxDecoration(
                  color: Color(0xFF303030), // Figma에서 지정한 버튼 배경 색상
                  borderRadius:
                      BorderRadius.circular(5.0), // Figma에서 지정한 둥근 모서리 반영
                  // Figma에서 설정된 효과 추가 (Background blur는 Flutter에서 직접 지원하지 않으므로 Color와 Opacity로 대체)
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    // 포커스를 해제하는 부분
                    // (이를 통해서 이메일 또는 비밀번호 입력 필드에 포커스가 생길 시, 오류 메세지 초기화되는 로직이 정상적으로 구현됨)
                    FocusScope.of(context).unfocus();

                    // 로그인 시도 및 자동 로그인 정보 저장
                    _login();
                    _saveAutoLogin();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    elevation: 0, // 그림자 효과 제거
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0), // 모서리 둥글게 설정
                    ),
                  ),
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      fontFamily: 'NanumGothic', // Figma에서 사용된 폰트
                      fontSize: loginBtnTextFontSize, // Figma에서 지정한 폰트 크기
                      fontWeight: FontWeight.bold, // Figma에서 지정한 굵기
                      color: Colors.white
                          .withOpacity(0.9), // Figma에서 지정한 텍스트 색상 및 투명도
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 오류 메시지 바
          if (errorMessage != null)
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: loginErrorMessageBarLeft,
                    top: loginErrorMessageBarTop),
                child: Container(
                  width: loginErrorMessageBarWidth,
                  height: loginErrorMessageBarHeight,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF0000), // 피그마에서 지정한 배경색
                    borderRadius:
                        BorderRadius.circular(5.0), // 피그마에서 설정된 둥근 모서리
                  ),
                  child: Align(
                    alignment: Alignment.center, // 피그마에서의 텍스트 정렬
                    child: Text(
                      errorMessage!,
                      style: TextStyle(
                        fontFamily: 'NanumGothic', // 피그마에서 사용된 폰트
                        fontSize: loginErrorMessageBarTextFontSize, // 피그마에서 지정한 폰트 크기
                        fontWeight: FontWeight.bold, // 피그마에서 설정된 굵기
                        color: Colors.white, // 피그마에서 지정한 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Row(
            children: [
              // 회원가입 및 아이디/비밀번호 찾기 버튼
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: joinAndFindBtnLeft, top: joinAndFindBtnTop),
                  // Figma에서 지정한 위치를 Padding으로 적용
                  child: Container(
                    width: joinAndFindBtnWidth, // Figma에서 지정한 전체 너비
                    height: joinAndFindBtnHeight, // Figma에서 지정한 전체 높이
                    child: Row(
                      children: [
                        // 회원가입 텍스트 버튼
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MembershipRegistrationInfoScreen(),
                                ),
                              );
                            },
                            child: Text(
                              '회원가입',
                              style: TextStyle(
                                fontFamily: 'NanumGothic', // 피그마에서 사용된 폰트
                                fontSize: joinAndFindBtnTextFontSize, // 피그마에서 지정된 폰트 크기
                                fontWeight: FontWeight.normal, // 피그마에서 지정된 굵기
                                color: Colors.white, // 피그마에서 지정된 텍스트 색상
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero, // 여백 제거
                              alignment: Alignment.centerLeft, // 텍스트 정렬
                            ),
                          ),
                        ),
                        // 아이디/비밀번호 찾기 텍스트 버튼
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              const url = 'https://pf.kakao.com/_xjVrbG';
                              _launchURL(url);
                            },
                            child: Text(
                              '아이디/비밀번호 찾기',
                              style: TextStyle(
                                fontFamily: 'NanumGothic', // 피그마에서 사용된 폰트
                                fontSize: joinAndFindBtnTextFontSize, // 피그마에서 지정된 폰트 크기
                                fontWeight: FontWeight.normal, // 피그마에서 지정된 굵기
                                color: Colors.white, // 피그마에서 지정된 텍스트 색상
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero, // 여백 제거
                              alignment: Alignment.centerRight, // 텍스트 정렬
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // URL을 여는 함수 정의
  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
