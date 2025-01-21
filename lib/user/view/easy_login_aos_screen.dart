
import 'package:dongdaemoon_beta_v1/user/view/sns_sign_up_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../home/view/home_screen.dart';
import '../provider/sns_login_and_sign_up_state_provider.dart';
import 'login_screen.dart';


// ------ AOS용 간편 로그인 화면 UI 구현 관련 EasyLoginAosScreen 시작 부분
class EasyLoginAosScreen extends ConsumerStatefulWidget {
  // 라우트 이름 정의
  static String get routeName => 'login';

  @override
  _EasyLoginAosScreenState createState() => _EasyLoginAosScreenState();
}

class _EasyLoginAosScreenState extends ConsumerState<EasyLoginAosScreen> {
  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  bool isLoading = false; // 로딩 상태 관리

  bool isNavigatedToSignUp = false; // 화면 전환 상태를 관리할 변수 추가

  bool isGoogleLoginReset = false;  // 구글 로그인 상태 초기화 플래그

  bool isNaverLoginReset = false;  // 네이버 로그인 상태 초기화 플래그

  @override
  void initState() {
    super.initState();
    // 네트워크 상태 체크 시작
    _networkChecker = NetworkChecker(context);
    _networkChecker?.checkNetworkStatus();

    // 위젯이 렌더링된 후 Google 로그인 상태를 확인하는 콜백 함수
    // (회원가입 화면에서 이전화면으로 이동 버튼 클릭 시, 해당 로그인 화면으로 이동하지 않는 이슈 해결 로직)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 화면이 활성 상태이고 회원가입 화면으로 이동하지 않았다면
      if (mounted && !isNavigatedToSignUp) {
        // Google 로그인 상태를 확인하고 처리
        _listenGoogleLoginState(context, ref.watch(googleSignInNotifierProvider));
        _listenNaverLoginState(context, ref.watch(naverSignInNotifierProvider));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    // 네트워크 체크 해제
    _networkChecker?.dispose();
  }

  // 구글 로그인 상태 감지 후 UI 동작
  void _listenGoogleLoginState(BuildContext context, GoogleSignInState state) {
    setState(() {
      isLoading = state.isLoading;
    });

    // 1) 'secessionUser' 인 경우 => AlertDialog 보여주고, 상태 초기화
    if (state.errorMessage == 'secessionUser') {
      showSubmitAlertDialog(
        context,
        title: '[회원가입 실패]',
        content: '해당 계정은 탈퇴한 계정이며,\n탈퇴 후 5분 이후에만 재가입이 가능합니다.',
        // 30일로 쓰고 싶으면 문구만 30일로 변경.
        actions: [
          TextButton(
            child: Text(
              '확인',
              style: TextStyle(
                color: SOFTGREEN60_COLOR,
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
      // AlertDialog 닫은 뒤(사용자가 확인 누른 뒤)에는 상태 초기화
      ref.read(googleSignInNotifierProvider.notifier).resetState();
      return;
    }

    // 2) 로그인 실패 시
    // 에러 메시지 표시 (취소 상태는 제외)
    if (state.errorMessage != null &&
        state.errorMessage!.isNotEmpty &&
        !state.errorMessage!.contains('취소')) {
      showCustomSnackBar(context, state.errorMessage!);
    }

    // 3) 기존 회원이면 -> 메인 화면으로 이동
    if (state.isLoginSuccess) {
      // 상태 초기화 후 화면 이동
      ref.read(googleSignInNotifierProvider.notifier).state = GoogleSignInState();
      // MaterialPageRoute를 사용해 화면 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeMainScreen()),
      );
    }

    // 4) 신규 회원이면 -> 회원가입 화면으로 이동 (이메일, 이름 등을 전달)
    // 신규 회원일 경우
    if (state.isSignUpNeeded && state.signUpEmail != null && !isNavigatedToSignUp) {
      isNavigatedToSignUp = true;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SnsSignUpScreen(
            snsType: 'google', // SNS 타입 전달
            snsId: state.signUpEmail ?? '',
            // platformType: 'aos', // 플랫폼 정보 전달
          ),
        ),
      ).then((_) {
        isNavigatedToSignUp = false; // 상태 초기화
        // (회원가입 화면에서 이전화면으로 이동 버튼 클릭 시, 해당 로그인 화면으로 이동하지 않는 이슈 해결 로직)
        if (mounted && !isGoogleLoginReset) {
          ref.read(googleSignInNotifierProvider.notifier).resetState();
        }
      });
    }
  }

  // 네이버 로그인 상태 처리 로직
  void _listenNaverLoginState(BuildContext context, NaverSignInState state) async {
    if (state.isLoading) return;

    // 1) 'secessionUser' 인 경우 => AlertDialog 보여주고, 상태 초기화
    if (state.errorMessage == 'secessionUser') {
      showSubmitAlertDialog(
        context,
        title: '[회원가입 실패]',
        content: '해당 계정은 탈퇴한 계정이며,\n탈퇴 후 5분 이후에만 재가입이 가능합니다.',
        // 30일로 쓰고 싶으면 문구만 30일로 변경.
        actions: [
          TextButton(
            child: Text(
              '확인',
              style: TextStyle(
                color: SOFTGREEN60_COLOR,
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
      // AlertDialog 닫은 뒤(사용자가 확인 누른 뒤)에는 상태 초기화
      ref.read(naverSignInNotifierProvider.notifier).resetState();
      return;
    }

    // 2) 다른 일반 오류 메시지는 스낵바로 처리
    if (state.errorMessage != null &&
        state.errorMessage!.isNotEmpty &&
        !state.errorMessage!.contains('취소')) {
      // 에러 발생 시 처리
      showCustomSnackBar(context, state.errorMessage!);
    }

    // 3) 로그인 성공 => 홈 화면 이동
    if (state.isLoginSuccess) {
      // 상태 초기화 후 화면 이동
      ref.read(naverSignInNotifierProvider.notifier).state = NaverSignInState();
      // MaterialPageRoute를 사용해 화면 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeMainScreen()),
      );
    }

    // 4) 신규 회원 => 회원가입 화면 이동
    if (state.isSignUpNeeded && state.signUpEmail != null && !isNavigatedToSignUp) {
      isNavigatedToSignUp = true;
      Navigator.of(context)
          .push(MaterialPageRoute(
        builder: (context) => SnsSignUpScreen(
          snsType: 'naver',
          snsId: state.signUpEmail ?? '',
        ),
      ))
          .then((_) {
        isNavigatedToSignUp = false;
        // (회원가입 화면에서 이전화면으로 이동 버튼 클릭 시, 해당 로그인 화면으로 이동하지 않는 이슈 해결 로직)
        if (mounted && !isNaverLoginReset) {
          ref.read(naverSignInNotifierProvider.notifier).resetState();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider에서 구글 로그인 상태를 감시
    final googleLoginState = ref.watch(googleSignInNotifierProvider);
    // Provider에서 네이버 로그인 상태를 감시
    final naverLoginState = ref.watch(naverSignInNotifierProvider);


    // 상태 변경 시 후처리
    // (간편 로그인 화면에서 회원가입 화면으로 이동하도록 하는 로직)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _listenGoogleLoginState(context, googleLoginState);
        _listenNaverLoginState(context, naverLoginState);
      }
    });

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 화면 이름 부분 수치
    final double screenNameTop =
        screenSize.height * (60 / referenceHeight); // 위쪽 여백 비율
    final double backBtnTop =
        screenSize.height * (50 / referenceHeight);
    final double backBtnLeft =
        screenSize.width * (10 / referenceWidth);

    // 화면 제목 부분 수치
    final double screenTitleTop =
        screenSize.height * (227 / referenceHeight); // 위쪽 여백 비율
    final double screenLoginText1FontSize =
        screenSize.height * (20 / referenceHeight);
    final double screenTitleTextFontSize =
        screenSize.height * (20 / referenceHeight);

    // 화면 서브제목 부분 수치
    final double screenSubTitleTop =
        screenSize.height * (268 / referenceHeight); // 위쪽 여백 비율
    final double screenSubTitleTextFontSize =
        screenSize.height * (16 / referenceHeight);

    // 안내 텍스트 부분 수치
    final double guideTextTop =
        screenSize.height * (320 / referenceHeight); // 위쪽 여백 비율
    final double guideTextFontSize = screenSize.height * (14 / referenceHeight);

    // SNS 계정 로그인 버튼 부분 수치
    final double easyLoginBtnImageTop =
        screenSize.height * (360 / referenceHeight); // 위쪽 여백 비율
    final double interval1X = screenSize.width * (20 / referenceWidth);
    final double easyLoginBtnImageWidth =
        screenSize.width * (70 / referenceWidth);
    final double easyLoginBtnImageHeight =
        screenSize.height * (70 / referenceHeight);

    // 네이버 로그인 안내 텍스트 부분 수치
    final double guidelineText3Left =
        screenSize.width * (0 / referenceWidth); // 왼쪽 여백 비율
    final double guidelineText3Top =
        screenSize.height * (450 / referenceHeight); // 위쪽 여백 비율
    final double guidelineText4Top =
        screenSize.height * (470 / referenceHeight); // 위쪽 여백 비율
    final double guidelineText5Top =
        screenSize.height * (482 / referenceHeight); // 위쪽 여백 비율
    final double guidelineText3FontSize =
        screenSize.height * (8 / referenceHeight); // 텍스트 크기

    // 로그인 개인정보 처리방침 안내 텍스트1 부분 수치
    final double guidelineText1Left =
        screenSize.width * (0 / referenceWidth); // 왼쪽 여백 비율
    final double guidelineText1Top =
        screenSize.height * (680 / referenceHeight); // 위쪽 여백 비율
    final double guidelineText1FontSize =
        screenSize.height * (13 / referenceHeight); // 텍스트 크기

    // 로그인 개인정보 처리방침 안내 텍스트2 부분 수치
    final double guidelineText2Left =
        screenSize.width * (0 / referenceWidth); // 왼쪽 여백 비율
    final double guidelineText2Top =
        screenSize.height * (710 / referenceHeight); // 위쪽 여백 비율
    final double guidelineText2FontSize =
        screenSize.height * (13 / referenceHeight); // 텍스트 크기

    // 관리자 로그인 화면으로 이동 버튼 부분 수치
    final double goToLoginBtnTop =
        screenSize.height * (770 / referenceHeight); // 위쪽 여백 비율
    final double goToLoginBtnTextFontSize =
        screenSize.height * (16 / referenceHeight);

    // 간편로그인 화면 UI 구성
    return Scaffold(
      body: Stack(
        // 화면 크기에 맞게 배경 이미지 설정
        children: [
          Positioned.fill(
            child: Image.asset(
              'asset/img/misc/login_image/couture_login_bg_img.png',
              // 이미지 파일 경로를 설정.
              fit: BoxFit.cover, // 이미지 비율을 유지하면서 화면에 맞게 조절
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
                '로그인',
                style: TextStyle(
                  fontSize: screenLoginText1FontSize,
                  fontWeight: FontWeight.w600,
                  color: BLACK_COLOR,
                ),
              ),
            ),
          ),
          // 닫기 아이콘 (스택이 있을 때만 표시)
          if (Navigator.canPop(context))
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: backBtnLeft, top: backBtnTop),
                child: IconButton(
                  icon: Icon(Icons.arrow_back), // 이전화면으로 이동 아이콘 설정
                  color: BLACK_COLOR, // 색상 설정
                  onPressed: () {
                    Navigator.pop(context); // 누르면 이전 화면으로 돌아가기
                  },
                ),
              ),
            ),
          // 타이틀 텍스트
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: screenTitleTop),
              child: Text(
                '동대문 의류도매 제로마진 플랫폼',
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.bold,
                  fontSize: screenTitleTextFontSize,
                  color: WHITE_COLOR,
                ),
              ),
            ),
          ),
          // 서브 타이틀 텍스트
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: screenSubTitleTop),
              child: Text(
                '꾸띠르, Couture',
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.normal,
                  fontSize: screenSubTitleTextFontSize,
                  color: WHITE_COLOR,
                ),
              ),
            ),
          ),
          // 안내 텍스트
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: guideTextTop),
              child: Text(
                'SNS 버튼 클릭 후, 간편하게 로그인 및 회원가입을 하세요.',
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.normal,
                  fontSize: guideTextFontSize,
                  color: WHITE_COLOR,
                ),
              ),
            ),
          ),
          // 이미지를 나타내는 부분
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: easyLoginBtnImageTop),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 네이버 로그인 버튼
                  GestureDetector(
                    onTap: () async {
                      // 네이버 로그인 로직 호출
                      print('네이버 로그인 버튼 클릭됨.');
                      ref.read(naverSignInNotifierProvider.notifier).signInWithNaver();
                    },
                    child: Container(
                      child: Image.asset(
                        'asset/img/misc/login_image/naver_login_btn_img.png',
                        width: easyLoginBtnImageWidth,
                        height: easyLoginBtnImageHeight,
                        fit: BoxFit.contain, // 이미지 크기 조정
                      ),
                    ),
                  ),
                  SizedBox(width: interval1X),
                  // 구글 로그인 버튼
                  GestureDetector(
                    onTap: () async {
                      // 구글 로그인 로직 호출
                      print('Google 로그인 버튼 클릭됨.');
                      ref.read(googleSignInNotifierProvider.notifier).signInWithGoogle();
                    },
                    child: Container(
                      child: Image.asset(
                        'asset/img/misc/login_image/google_login_btn_img.png',
                        width: easyLoginBtnImageWidth,
                        height: easyLoginBtnImageHeight,
                        fit: BoxFit.contain, // 이미지 크기 조정
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 네이버 로그인 안내 텍스트1
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  left: guidelineText3Left, top: guidelineText3Top),
              child: Text(
                '[네이버 로그인 안내]',
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.normal,
                  fontSize: guidelineText3FontSize,
                  color: WHITE_COLOR,
                ),
              ),
            ),
          ),
          // 네이버 로그인 안내 텍스트2
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  left: guidelineText3Left, top: guidelineText4Top),
              child: Text(
                '네이버 앱 또는 웹 브라우저 내 로그아웃을 직접 실행 후',
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.normal,
                  fontSize: guidelineText3FontSize,
                  color: WHITE_COLOR,
                ),
              ),
            ),
          ),
          // 네이버 로그인 안내 텍스트3
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  left: guidelineText3Left, top: guidelineText5Top),
              child: Text(
                "'로그인' 버튼 클릭 시, 타 네이버 계정 선택이 가능합니다.",
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.normal,
                  fontSize: guidelineText3FontSize,
                  color: WHITE_COLOR,
                ),
              ),
            ),
          ),
          // 개인정보 처리방침 안내 텍스트1
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  left: guidelineText1Left, top: guidelineText1Top),
              child: Text(
                '로그인함으로써 개인정보 처리방침에 동의합니다.',
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.normal,
                  fontSize: guidelineText1FontSize,
                  color: WHITE_COLOR,
                ),
              ),
            ),
          ),
          // 개인정보 처리방침 안내 텍스트2
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  left: guidelineText2Left, top: guidelineText2Top),
              child: GestureDetector( // GestureDetector 사용하여 탭 이벤트 처리
                onTap: () async {
                  const url = 'https://gshe.oopy.io/couture/privacy'; // 열려는 URL
                  try {
                    final bool launched = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication); // 외부 브라우저에서 URL 열기
                    if (!launched) {
                      // 웹 페이지를 열지 못할 경우 스낵바로 알림
                      showCustomSnackBar(context, '웹 페이지를 열 수 없습니다.');
                    }
                  } catch (e) {
                    // 예외 발생 시 스낵바로 에러 메시지 출력
                    showCustomSnackBar(context, '에러가 발생했습니다.\n앱을 재실행해주세요.');
                  }
                },
                child: Text(
                  '개인정보 처리방침 보기',
                  style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontWeight: FontWeight.normal,
                    fontSize: guidelineText2FontSize,
                    color: BLUE49_COLOR, // 파란색 텍스트
                    decoration: TextDecoration.underline, // 밑줄 추가
                  ),
                ),
              ),
            ),
          ),
          // 관리자 로그인 화면으로 이동 버튼
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: goToLoginBtnTop),
              child: GestureDetector(
                // GestureDetector 사용하여 탭 이벤트 처리
                onTap: () async {
                  // 로그인 화면으로 이동
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                },
                child: Text(
                  '관리자 로그인',
                  style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontWeight: FontWeight.normal,
                    fontSize: goToLoginBtnTextFontSize,
                    color: WHITE_COLOR, // 텍스트 색상
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// ------ AOS용 간편 로그인 화면 UI 구현 관련 EasyLoginAosScreen 끝 부분