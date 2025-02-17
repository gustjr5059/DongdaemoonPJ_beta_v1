// Flutter에서 제공하는 Material 디자인 위젯을 사용하기 위해 필수적인 패키지입니다.
// 이 패키지는 애플리케이션의 시각적 구성 요소들을 제공하며, UI 구축의 기본이 됩니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongdaemoon_beta_v1/user/view/sns_sing_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

// Dart에서 비동기 프로그래밍을 위한 기본 라이브러리인 'dart:async'를 임포트합니다.
// 이 라이브러리는 비동기 작업을 관리하기 위한 Future와 Stream과 같은 객체들을 제공합니다.
// 예를 들어, 네트워크 요청, 데이터베이스 쿼리 등의 작업을 비동기적으로 처리할 때 사용됩니다.
import 'dart:async'; // 비동기 작업을 위한 dart:async 라이브러리 임포트
// 사용자 인증과 관련된 로그인 화면 구성을 위한 LoginScreen 파일을 임포트합니다.
// 이 파일은 사용자가 로그인할 수 있는 인터페이스를 제공하며, 사용자의 인증 정보를 처리합니다.
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../home/view/main_home_screen.dart';
import '../../user/view/login_screen.dart';
import '../provider/sns_login_and_sign_up_state_provider.dart'; // 로그인 화면으로 이동하기 위한 LoginScreen 임포트

// ------ IOS용 간편 로그인 화면 UI 구현 관련 EasyLoginIosScreen 시작 부분
class EasyLoginIosScreen extends ConsumerStatefulWidget {
  // 라우트 이름 정의
  static String get routeName => 'login';

  @override
  _EasyLoginIosScreenState createState() => _EasyLoginIosScreenState();
}

class _EasyLoginIosScreenState extends ConsumerState<EasyLoginIosScreen> {
  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  bool isLoading = false; // 로딩 상태를 관리하는 변수

  bool isNavigatedToSignUp = false; // 화면 전환 상태를 관리할 변수 추가

  bool isAppleLoginReset = false; // Apple 로그인 상태 초기화 플래그

  bool isNaverLoginReset = false; // 네이버 로그인 상태 초기화 플래그

  @override
  void initState() {
    super.initState();
    // 네트워크 상태 체크 시작
    _networkChecker = NetworkChecker(context);
    _networkChecker?.checkNetworkStatus();

    // 위젯이 렌더링된 후 애플 로그인 상태를 확인하는 콜백 함수
    // (회원가입 화면에서 이전화면으로 이동 버튼 클릭 시, 해당 로그인 화면으로 이동하지 않는 이슈 해결 로직)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !isNavigatedToSignUp) {
        _listenAppleLoginState(context, ref.watch(appleSignInNotifierProvider));
        _listenNaverLoginState(context, ref.watch(naverSignInNotifierProvider));
      }
    });
  }

  @override
  void dispose() {
    // 네트워크 체크 해제
    _networkChecker?.dispose();

    super.dispose();
  }

  // appleLoginState(로그인 진행 상황)에 따라 UI에서 네비게이션/알림 처리
  void _listenAppleLoginState(BuildContext context, AppleSignInState state) {
    // 로딩 상태 표시
    setState(() {
      isLoading = state.isLoading;
    });

    // 1) 'secessionUser' 인 경우 => AlertDialog 보여주고, 상태 초기화
    if (state.errorMessage == 'secessionUser') {
      showSubmitAlertDialog(
        context,
        title: '[회원가입 실패]',
        content: '해당 계정은 탈퇴한 계정이며,\n탈퇴 후 30일 이후에만 재가입이 가능합니다.',
        // 30일로 쓰고 싶으면 문구만 30일로 변경.
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
      // AlertDialog 닫은 뒤(사용자가 확인 누른 뒤)에는 상태 초기화
      ref.read(appleSignInNotifierProvider.notifier).resetState();
      return;
    }

    // 2) 로그인 실패 시 스낵바
    if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
      // 에러 메시지가 존재하되, Apple 로그인 취소 상태는 제외
      // 로그인 취소(`canceled`) 상태와 기타 오류를 구분
      if (state.errorMessage!.contains('canceled')) {
        print('Apple 로그인 취소됨.');
      } else if (state.errorMessage!.contains('error 1000')) {
        // 에러 1000 처리
        showCustomSnackBar(context, 'Apple 로그인 중 문제가 발생했습니다. 다시 시도해주세요.');
        ref.read(appleSignInNotifierProvider.notifier).resetState();
      } else {
        showCustomSnackBar(context, state.errorMessage!);
      }
    }

    // 3) 기존 회원일 경우: MainHomeScreen으로 이동
    if (state.isLoginSuccess) {
      // 상태 초기화 후 화면 이동
      ref.read(appleSignInNotifierProvider.notifier).state = AppleSignInState();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => MainHomeScreen()),
      );
    }

    // 4) 신규 회원일 경우: 회원가입 화면(SnsSignUpScreen)으로 이동
    // SignUpScreen으로 이메일/이름 전달
    if (state.isSignUpNeeded &&
        state.signUpEmail != null &&
        !isNavigatedToSignUp) {
      isNavigatedToSignUp = true; // 중복 호출 방지
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => SnsSignUpScreen(
            snsType: 'apple', // SNS 타입 전달
            snsId: state.signUpEmail ?? '', // SNS 계정
            prefilledEmail: state.signUpEmail ?? '', // 이메일
            prefilledName: state.signUpFullName ?? '', // 이름
            // platformType: 'ios', // 플랫폼 정보 전달
          ),
        ),
      )
          .then((_) {
        isNavigatedToSignUp = false; // 화면이 닫히면 상태 초기화
        // (회원가입 화면에서 이전화면으로 이동 버튼 클릭 시, 해당 로그인 화면으로 이동하지 않는 이슈 해결 로직)
        if (mounted && !isAppleLoginReset) {
          // 회원가입 화면에서 이전화면으로 이동할 시, 로그인 상태 해제하는 로직
          // 해당 로직이 있어야 로그인 화면 -> 회원가입 화면 -> 다시 로그인 화면 -> 홈 화면 -> 마이페이지 화면일 시,
          // users 내 문서 조회를 할만한 계정이 없도록 해서 로그인 하기 버튼이 나오도록 가능
          FirebaseAuth.instance.signOut(); // FirebaseAuth 로그아웃

          ref.read(appleSignInNotifierProvider.notifier).resetState();
        }
      });
    }
  }

  // 네이버 로그인 상태 처리 로직
  void _listenNaverLoginState(
      BuildContext context, NaverSignInState state) async {
    if (state.isLoading) return;

    // 1) 'secessionUser' 인 경우 => AlertDialog 보여주고, 상태 초기화
    if (state.errorMessage == 'secessionUser') {
      showSubmitAlertDialog(
        context,
        title: '[회원가입 실패]',
        content: '해당 계정은 탈퇴한 계정이며,\n탈퇴 후 30일 이후에만 재가입이 가능합니다.',
        // 30일로 쓰고 싶으면 문구만 30일로 변경.
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
    // 네이버 로그인 성공 후
    // 네이버 기존 회원 -> 홈 화면 이동
    if (state.isLoginSuccess) {
      // 상태 초기화 후 화면 이동
      ref.read(naverSignInNotifierProvider.notifier).state = NaverSignInState();
      // MaterialPageRoute를 사용해 화면 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => MainHomeScreen()),
      );
    }

    // 4) 신규 회원 => 회원가입 화면 이동
    if (state.isSignUpNeeded &&
        state.signUpId != null &&
        !isNavigatedToSignUp) {
      isNavigatedToSignUp = true;
      Navigator.of(context)
          .push(MaterialPageRoute(
        builder: (context) => SnsSignUpScreen(
          snsType: 'naver',
          snsId: state.signUpId ?? '',
          // 네이버는 파이어베이스의 식별자가 아닌 UID 형태이면 이를 전달
          prefilledEmail: state.signUpEmail ?? '',
          // 이메일
          prefilledName: state.signUpName ?? '', // 이름
        ),
      ))
          .then((_) {
        isNavigatedToSignUp = false;
        // (회원가입 화면에서 이전화면으로 이동 버튼 클릭 시, 해당 로그인 화면으로 이동하지 않는 이슈 해결 로직)
        if (mounted && !isNaverLoginReset) {
          // 회원가입 화면에서 이전화면으로 이동할 시, 로그인 상태 해제하는 로직
          // 해당 로직이 있어야 로그인 화면 -> 회원가입 화면 -> 다시 로그인 화면 -> 홈 화면 -> 마이페이지 화면일 시,
          // users 내 문서 조회를 할만한 계정이 없도록 해서 로그인 하기 버튼이 나오도록 가능
          FirebaseAuth.instance.signOut(); // FirebaseAuth 로그아웃
          FlutterNaverLogin.logOut(); // 네이버 로그아웃

          ref.read(naverSignInNotifierProvider.notifier).resetState();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider에서 Apple 로그인 상태를 감시
    final appleLoginState = ref.watch(appleSignInNotifierProvider);
    // Provider에서 네이버 로그인 상태를 감시
    final naverLoginState = ref.watch(naverSignInNotifierProvider);

    // appleLoginState가 변경될 때만 처리
    // (간편 로그인 화면에서 회원가입 화면으로 이동하도록 하는 로직)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _listenAppleLoginState(context, appleLoginState);
        _listenNaverLoginState(context, naverLoginState);
      }
    });

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려하지 않은 사이즈 시작 부분
    // // 비율을 기반으로 동적으로 크기와 위치 설정
    //
    // // 화면 이름 부분 수치
    // final double screenNameTop =
    //     screenSize.height * (60 / referenceHeight); // 위쪽 여백 비율
    // final double backBtnTop =
    //     screenSize.height * (48 / referenceHeight);
    // final double backBtnLeft =
    //     screenSize.width * (10 / referenceWidth);
    //
    // // 화면 제목 부분 수치
    // final double screenTitleTop =
    //     screenSize.height * (227 / referenceHeight); // 위쪽 여백 비율
    // final double screenLoginText1FontSize =
    //     screenSize.height * (20 / referenceHeight);
    // final double screenTitleTextFontSize =
    //     screenSize.height * (20 / referenceHeight);
    //
    // // 화면 서브제목 부분 수치
    // final double screenSubTitleTop =
    //     screenSize.height * (268 / referenceHeight); // 위쪽 여백 비율
    // final double screenSubTitleTextFontSize =
    //     screenSize.height * (16 / referenceHeight);
    //
    // // 안내 텍스트 부분 수치
    // final double guideTextTop =
    //     screenSize.height * (320 / referenceHeight); // 위쪽 여백 비율
    // final double guideTextFontSize = screenSize.height * (14 / referenceHeight);
    //
    // // SNS 계정 로그인 버튼 부분 수치
    // final double easyLoginBtnImageTop =
    //     screenSize.height * (360 / referenceHeight); // 위쪽 여백 비율
    // final double interval1X = screenSize.width * (20 / referenceWidth);
    // final double easyLoginBtnImageWidth =
    //     screenSize.width * (70 / referenceWidth);
    // final double easyLoginBtnImageHeight =
    //     screenSize.height * (70 / referenceHeight);
    //
    // // 로그인 개인정보 처리방침 안내 텍스트1 부분 수치
    // final double guidelineText1Top =
    //     screenSize.height * (680 / referenceHeight); // 위쪽 여백 비율
    // final double guidelineText1FontSize =
    //     screenSize.height * (13 / referenceHeight); // 텍스트 크기
    //
    // // 로그인 개인정보 처리방침 안내 텍스트2 부분 수치
    // final double guidelineText2Top =
    //     screenSize.height * (710 / referenceHeight); // 위쪽 여백 비율
    // final double guidelineText2FontSize =
    //     screenSize.height * (13 / referenceHeight); // 텍스트 크기
    //
    // // 관리자 로그인 화면으로 이동 버튼 부분 수치
    // final double goToLoginBtnTop =
    //     screenSize.height * (770 / referenceHeight); // 위쪽 여백 비율
    // final double goToLoginBtnTextFontSize =
    //     screenSize.height * (16 / referenceHeight);
    //
    // // 간편로그인 화면 UI 구성
    // return Scaffold(
    //   body: Stack(
    //     // 화면 크기에 맞게 배경 이미지 설정
    //     children: [
    //       Positioned.fill(
    //         child: Image.asset(
    //           'asset/img/misc/login_image/wearcano_easy_login_bg_img.png',
    //           // 이미지 파일 경로를 설정.
    //           fit: BoxFit.cover, // 이미지 비율을 유지하면서 화면에 맞게 조절
    //           width: screenSize.width, // 화면 너비
    //           height: screenSize.height, // 화면 높이
    //         ),
    //       ),
    //       // 화면 제목 (Login)
    //       Align(
    //         alignment: Alignment.topCenter,
    //         child: Padding(
    //           padding: EdgeInsets.only(top: screenNameTop),
    //           child: Text(
    //             '로그인',
    //             style: TextStyle(
    //               fontSize: screenLoginText1FontSize,
    //               fontWeight: FontWeight.w600,
    //               color: BLACK_COLOR,
    //               fontFamily: 'NanumGothic',
    //             ),
    //           ),
    //         ),
    //       ),
    //       // 닫기 아이콘 (스택이 있을 때만 표시)
    //       if (Navigator.canPop(context))
    //       Align(
    //         alignment: Alignment.topLeft,
    //         child: Padding(
    //           padding: EdgeInsets.only(left: backBtnLeft, top: backBtnTop),
    //           child: IconButton(
    //             icon: Icon(Icons.arrow_back), // 이전화면으로 이동 아이콘 설정
    //             color: BLACK_COLOR, // 색상 설정
    //             onPressed: () {
    //               Navigator.pop(context); // 누르면 이전 화면으로 돌아가기
    //             },
    //           ),
    //         ),
    //       ),
    //       // 타이틀 텍스트
    //       Align(
    //         alignment: Alignment.topCenter,
    //         child: Padding(
    //           padding: EdgeInsets.only(top: screenTitleTop),
    //           child: Text(
    //             '동대문 의류도매 제로마진 플랫폼',
    //             style: TextStyle(
    //               fontFamily: 'NanumGothic',
    //               fontWeight: FontWeight.bold,
    //               fontSize: screenTitleTextFontSize,
    //               color: WHITE_COLOR,
    //             ),
    //           ),
    //         ),
    //       ),
    //       // 서브 타이틀 텍스트
    //       Align(
    //         alignment: Alignment.topCenter,
    //         child: Padding(
    //           padding: EdgeInsets.only(top: screenSubTitleTop),
    //           child: Text(
    //             '웨어카노, Wearcano',
    //             style: TextStyle(
    //               fontFamily: 'NanumGothic',
    //               fontWeight: FontWeight.normal,
    //               fontSize: screenSubTitleTextFontSize,
    //               color: WHITE_COLOR,
    //             ),
    //           ),
    //         ),
    //       ),
    //       // 안내 텍스트
    //       Align(
    //         alignment: Alignment.topCenter,
    //         child: Padding(
    //           padding: EdgeInsets.only(top: guideTextTop),
    //           child: Text(
    //             'SNS 버튼 클릭 후, 간편하게 로그인 및 회원가입을 하세요.',
    //             style: TextStyle(
    //               fontFamily: 'NanumGothic',
    //               fontWeight: FontWeight.normal,
    //               fontSize: guideTextFontSize,
    //               color: WHITE_COLOR,
    //             ),
    //           ),
    //         ),
    //       ),
    //       // 이미지를 나타내는 부분
    //       Align(
    //         alignment: Alignment.topCenter,
    //         child: Padding(
    //           padding: EdgeInsets.only(top: easyLoginBtnImageTop),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               // 카카오 로그인 버튼
    //               GestureDetector(
    //                 onTap: () {
    //                   // TODO: 카카오 로그인 로직 (Provider/Repository) 연동
    //                   // 카카오 로그인 화면으로 이동
    //                   // Navigator.of(context).push(
    //                   //     MaterialPageRoute(builder: (_) => KakaoLoginScreen()),
    //                 },
    //                 child: Container(
    //                   child: Image.asset(
    //                     'asset/img/misc/login_image/kakao_login_btn_img.png',
    //                     width: easyLoginBtnImageWidth,
    //                     height: easyLoginBtnImageHeight,
    //                     fit: BoxFit.contain, // 이미지 크기 조정
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(width: interval1X),
    //               // 애플 로그인 버튼
    //               GestureDetector(
    //                 // 애플 로그인 화면으로 이동
    //                 onTap: () async {
    //                   // Provider에 있는 애플 로그인 로직 호출
    //                   print('애플 로그인 버튼 클릭됨.');
    //                   ref.read(appleSignInNotifierProvider.notifier).signInWithApple();
    //                 },
    //                 child: Container(
    //                   child: Image.asset(
    //                     'asset/img/misc/login_image/apple_login_btn_img.png',
    //                     width: easyLoginBtnImageWidth,
    //                     height: easyLoginBtnImageHeight,
    //                     fit: BoxFit.contain, // 이미지 크기 조정
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       // // 개인정보 처리방침 안내 텍스트1
    //       // Align(
    //       //   alignment: Alignment.topCenter,
    //       //   child: Padding(
    //       //     padding: EdgeInsets.only(top: guidelineText1Top),
    //       //     child: Text(
    //       //       '로그인함으로써 개인정보 처리방침에 동의합니다.',
    //       //       style: TextStyle(
    //       //         fontFamily: 'NanumGothic',
    //       //         fontWeight: FontWeight.normal,
    //       //         fontSize: guidelineText1FontSize,
    //       //         color: WHITE_COLOR,
    //       //       ),
    //       //     ),
    //       //   ),
    //       // ),
    //       // // 개인정보 처리방침 안내 텍스트2
    //       // Align(
    //       //   alignment: Alignment.topCenter,
    //       //   child: Padding(
    //       //     padding: EdgeInsets.only(top: guidelineText2Top),
    //       //     child: GestureDetector(
    //       //       // GestureDetector 사용하여 탭 이벤트 처리
    //       //       onTap: () async {
    //       //         const url = 'https://pf.kakao.com/_xjVrbG'; // 열려는 URL
    //       //         try {
    //       //           final bool launched = await launchUrl(Uri.parse(url),
    //       //               mode:
    //       //                   LaunchMode.externalApplication); // 외부 브라우저에서 URL 열기
    //       //           if (!launched) {
    //       //             // 웹 페이지를 열지 못할 경우 스낵바로 알림
    //       //             showCustomSnackBar(context, '웹 페이지를 열 수 없습니다.');
    //       //           }
    //       //         } catch (e) {
    //       //           // 예외 발생 시 스낵바로 에러 메시지 출력
    //       //           showCustomSnackBar(context, '에러가 발생했습니다.\n앱을 재실행해주세요.');
    //       //         }
    //       //       },
    //       //       child: Text(
    //       //         '개인정보 처리방침 보기',
    //       //         style: TextStyle(
    //       //           fontFamily: 'NanumGothic',
    //       //           fontWeight: FontWeight.bold,
    //       //           fontSize: guidelineText2FontSize,
    //       //           color: BLUE49_COLOR, // 파란색 텍스트
    //       //         ),
    //       //       ),
    //       //     ),
    //       //   ),
    //       // ),
    //       // 관리자 로그인 화면으로 이동 버튼
    //       Align(
    //         alignment: Alignment.topCenter,
    //         child: Padding(
    //           padding: EdgeInsets.only(top: goToLoginBtnTop),
    //           child: GestureDetector(
    //             // GestureDetector 사용하여 탭 이벤트 처리
    //             onTap: () async {
    //               // 로그인 화면으로 이동
    //               Navigator.of(context).push(
    //                   MaterialPageRoute(builder: (_) => LoginScreen()));
    //             },
    //             child: Text(
    //               '관리자 로그인',
    //               style: TextStyle(
    //                 fontFamily: 'NanumGothic',
    //                 fontWeight: FontWeight.normal,
    //                 fontSize: goToLoginBtnTextFontSize,
    //                 color: WHITE_COLOR, // 텍스트 색상
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    // // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려하지 않은 사이즈 끝 부분

    // // ----- Positioned, Align에 의해 화면 스크롤 시, 배경 제외한 빈 화면이 나오는 이슈가 발생한 이전 로직 시작 부분
    // // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려한 사이즈 시작 부분
    // // 비율을 기반으로 동적으로 크기와 위치 설정
    //
    // // 화면 이름 부분 수치
    // final double screenNameTop = 10; // 위쪽 여백 비율
    // final double backBtnTop = 0;
    // final double backBtnLeft = screenSize.width * (10 / referenceWidth);
    //
    // // 화면 제목 부분 수치
    // final double screenTitleTop = 227; // 위쪽 여백 비율
    // final double screenLoginText1FontSize = 20;
    // final double screenTitleTextFontSize = 20;
    //
    // // 화면 서브제목 부분 수치
    // final double screenSubTitleTop = 268; // 위쪽 여백 비율
    // final double screenSubTitleTextFontSize = 16;
    //
    // // 안내 텍스트 부분 수치
    // final double guideTextTop = 320; // 위쪽 여백 비율
    // final double guideTextFontSize = 14;
    //
    // // SNS 계정 로그인 버튼 부분 수치
    // final double easyLoginBtnImageTop = 360; // 위쪽 여백 비율
    // final double interval1X = screenSize.width * (20 / referenceWidth);
    // final double easyLoginBtnImageWidth =
    //     screenSize.width * (70 / referenceWidth);
    // final double easyLoginBtnImageHeight = 70;
    //
    // // 네이버 로그인 안내 텍스트 부분 수치
    // final double guidelineText3Left =
    //     screenSize.width * (0 / referenceWidth); // 왼쪽 여백 비율
    // final double guidelineText3Top = 450; // 위쪽 여백 비율
    // final double guidelineText4Top = 470; // 위쪽 여백 비율
    // final double guidelineText5Top = 482; // 위쪽 여백 비율
    // final double guidelineText3FontSize = 8; // 텍스트 크기
    //
    // // 로그인 개인정보 처리방침 안내 텍스트1 부분 수치
    // final double guidelineText1Left =
    //     screenSize.width * (0 / referenceWidth); // 왼쪽 여백 비율
    // final double guidelineText1Top = 630; // 위쪽 여백 비율
    // final double guidelineText1FontSize = 13; // 텍스트 크기
    //
    // // 로그인 개인정보 처리방침 안내 텍스트2 부분 수치
    // final double guidelineText2Left =
    //     screenSize.width * (0 / referenceWidth); // 왼쪽 여백 비율
    // final double guidelineText2Top = 660; // 위쪽 여백 비율
    // final double guidelineText2FontSize = 13; // 텍스트 크기
    //
    // // 관리자 로그인 화면으로 이동 버튼 부분 수치
    // final double goToLoginBtnTop = 720; // 위쪽 여백 비율
    // final double goToLoginBtnTextFontSize = 16;
    //
    // final double interval1Y = 20;
    //
    // // 간편로그인 화면 UI 구성
    // return Scaffold(
    //   // body에 바로 CustomScrollView 배치
    //   body: CustomScrollView(
    //     slivers: [
    //       // SliverFillRemaining:
    //       // 남은 화면 전체를 차지하기 때문에
    //       // 배경 이미지를 상하단까지 완전히 채울 수 있음.
    //       SliverFillRemaining(
    //         // 만약 스크롤이 필요 없고, 화면을 '정적으로' 채우기만 한다면
    //         // hasScrollBody: false 를 사용해서 내용이 화면보다 작을 때 스크롤이 비활성화되도록 할 수 있음
    //         hasScrollBody: false,
    //         child: Stack(
    //           children: [
    //             Positioned.fill(
    //               child: Image.asset(
    //                 'asset/img/misc/login_image/wearcano_easy_login_bg_img.png',
    //                 // 이미지 파일 경로를 설정.
    //                 fit: BoxFit.cover, // 이미지 비율을 유지하면서 화면에 맞게 조절
    //                 width: screenSize.width, // 화면 너비
    //                 height: screenSize.height, // 화면 높이
    //               ),
    //             ),
    //             // SafeArea 내부에 배치하여 상태바, 하단 제스처 영역 침범을 방지
    //             SafeArea(
    //               // 화면 제목 (Login)
    //               child: Align(
    //                 alignment: Alignment.topCenter,
    //                 child: Padding(
    //                   padding: EdgeInsets.only(top: screenNameTop),
    //                   child: Text(
    //                     '로그인',
    //                     style: TextStyle(
    //                       fontSize: screenLoginText1FontSize,
    //                       fontWeight: FontWeight.w600,
    //                       color: BLACK_COLOR,
    //                       fontFamily: 'NanumGothic',
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             // 닫기 아이콘 (스택이 있을 때만 표시)
    //             if (Navigator.canPop(context))
    //               // SafeArea 내부에 배치하여 상태바, 하단 제스처 영역 침범을 방지
    //               SafeArea(
    //                 child: Align(
    //                   alignment: Alignment.topLeft,
    //                   child: Padding(
    //                     padding:
    //                         EdgeInsets.only(left: backBtnLeft, top: backBtnTop),
    //                     child: IconButton(
    //                       icon: Icon(Icons.arrow_back), // 이전화면으로 이동 아이콘 설정
    //                       color: BLACK_COLOR, // 색상 설정
    //                       onPressed: () {
    //                         Navigator.pop(context); // 누르면 이전 화면으로 돌아가기
    //                       },
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             // 타이틀 텍스트
    //             // SafeArea 내부에 배치하여 상태바, 하단 제스처 영역 침범을 방지
    //             SafeArea(
    //               child: Align(
    //                 alignment: Alignment.topCenter,
    //                 child: Padding(
    //                   padding: EdgeInsets.only(top: screenTitleTop),
    //                   child: Text(
    //                     '동대문 의류도매 제로마진 플랫폼',
    //                     style: TextStyle(
    //                       fontFamily: 'NanumGothic',
    //                       fontWeight: FontWeight.bold,
    //                       fontSize: screenTitleTextFontSize,
    //                       color: WHITE_COLOR,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             // 서브 타이틀 텍스트
    //             // SafeArea 내부에 배치하여 상태바, 하단 제스처 영역 침범을 방지
    //             SafeArea(
    //               child: Align(
    //                 alignment: Alignment.topCenter,
    //                 child: Padding(
    //                   padding: EdgeInsets.only(top: screenSubTitleTop),
    //                   child: Text(
    //                     '웨어카노, Wearcano',
    //                     style: TextStyle(
    //                       fontFamily: 'NanumGothic',
    //                       fontWeight: FontWeight.normal,
    //                       fontSize: screenSubTitleTextFontSize,
    //                       color: WHITE_COLOR,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             // 안내 텍스트
    //             // SafeArea 내부에 배치하여 상태바, 하단 제스처 영역 침범을 방지
    //             SafeArea(
    //               child: Align(
    //                 alignment: Alignment.topCenter,
    //                 child: Padding(
    //                   padding: EdgeInsets.only(top: guideTextTop),
    //                   child: Text(
    //                     'SNS 버튼 클릭 후, 간편하게 로그인 및 회원가입을 하세요.',
    //                     style: TextStyle(
    //                       fontFamily: 'NanumGothic',
    //                       fontWeight: FontWeight.normal,
    //                       fontSize: guideTextFontSize,
    //                       color: WHITE_COLOR,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             // 이미지를 나타내는 부분
    //             // SafeArea 내부에 배치하여 상태바, 하단 제스처 영역 침범을 방지
    //             SafeArea(
    //               child: Align(
    //                 alignment: Alignment.topCenter,
    //                 child: Padding(
    //                   padding: EdgeInsets.only(top: easyLoginBtnImageTop),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       // 네이버 로그인 버튼
    //                       GestureDetector(
    //                         onTap: () async {
    //                           // 네이버 로그인 로직 호출
    //                           print('네이버 로그인 버튼 클릭됨.');
    //                           ref
    //                               .read(naverSignInNotifierProvider.notifier)
    //                               .signInWithNaver();
    //                         },
    //                         child: Container(
    //                           child: Image.asset(
    //                             'asset/img/misc/login_image/naver_login_btn_img.png',
    //                             width: easyLoginBtnImageWidth,
    //                             height: easyLoginBtnImageHeight,
    //                             fit: BoxFit.contain, // 이미지 크기 조정
    //                           ),
    //                         ),
    //                       ),
    //                       SizedBox(width: interval1X),
    //                       // 애플 로그인 버튼
    //                       GestureDetector(
    //                         // 애플 로그인 화면으로 이동
    //                         onTap: () async {
    //                           // Provider에 있는 애플 로그인 로직 호출
    //                           print('애플 로그인 버튼 클릭됨.');
    //                           ref
    //                               .read(appleSignInNotifierProvider.notifier)
    //                               .signInWithApple();
    //                         },
    //                         child: Container(
    //                           child: Image.asset(
    //                             'asset/img/misc/login_image/apple_login_btn_img.png',
    //                             width: easyLoginBtnImageWidth,
    //                             height: easyLoginBtnImageHeight,
    //                             fit: BoxFit.contain, // 이미지 크기 조정
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             // // 개인정보 처리방침 안내 텍스트1
    //             // Align(
    //             //   alignment: Alignment.topCenter,
    //             //   child: Padding(
    //             //     padding: EdgeInsets.only(top: guidelineText1Top),
    //             //     child: Text(
    //             //       '로그인함으로써 개인정보 처리방침에 동의합니다.',
    //             //       style: TextStyle(
    //             //         fontFamily: 'NanumGothic',
    //             //         fontWeight: FontWeight.normal,
    //             //         fontSize: guidelineText1FontSize,
    //             //         color: WHITE_COLOR,
    //             //       ),
    //             //     ),
    //             //   ),
    //             // ),
    //             // // 개인정보 처리방침 안내 텍스트2
    //             // Align(
    //             //   alignment: Alignment.topCenter,
    //             //   child: Padding(
    //             //     padding: EdgeInsets.only(top: guidelineText2Top),
    //             //     child: GestureDetector(
    //             //       // GestureDetector 사용하여 탭 이벤트 처리
    //             //       onTap: () async {
    //             //         const url = 'https://pf.kakao.com/_xjVrbG'; // 열려는 URL
    //             //         try {
    //             //           final bool launched = await launchUrl(Uri.parse(url),
    //             //               mode:
    //             //                   LaunchMode.externalApplication); // 외부 브라우저에서 URL 열기
    //             //           if (!launched) {
    //             //             // 웹 페이지를 열지 못할 경우 스낵바로 알림
    //             //             showCustomSnackBar(context, '웹 페이지를 열 수 없습니다.');
    //             //           }
    //             //         } catch (e) {
    //             //           // 예외 발생 시 스낵바로 에러 메시지 출력
    //             //           showCustomSnackBar(context, '에러가 발생했습니다.\n앱을 재실행해주세요.');
    //             //         }
    //             //       },
    //             //       child: Text(
    //             //         '개인정보 처리방침 보기',
    //             //         style: TextStyle(
    //             //           fontFamily: 'NanumGothic',
    //             //           fontWeight: FontWeight.bold,
    //             //           fontSize: guidelineText2FontSize,
    //             //           color: BLUE49_COLOR, // 파란색 텍스트
    //             //         ),
    //             //       ),
    //             //     ),
    //             //   ),
    //             // ),
    //             // 네이버 로그인 안내 텍스트1
    //             // SafeArea 내부에 배치하여 상태바, 하단 제스처 영역 침범을 방지
    //             SafeArea(
    //               child: Align(
    //                 alignment: Alignment.topCenter,
    //                 child: Padding(
    //                   padding: EdgeInsets.only(
    //                       left: guidelineText3Left, top: guidelineText3Top),
    //                   child: Text(
    //                     '[네이버 로그인 안내]',
    //                     style: TextStyle(
    //                       fontFamily: 'NanumGothic',
    //                       fontWeight: FontWeight.normal,
    //                       fontSize: guidelineText3FontSize,
    //                       color: WHITE_COLOR,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             // 네이버 로그인 안내 텍스트2
    //             // SafeArea 내부에 배치하여 상태바, 하단 제스처 영역 침범을 방지
    //             SafeArea(
    //               child: Align(
    //                 alignment: Alignment.topCenter,
    //                 child: Padding(
    //                   padding: EdgeInsets.only(
    //                       left: guidelineText3Left, top: guidelineText4Top),
    //                   child: Text(
    //                     '네이버 앱 또는 웹 브라우저 내 로그아웃을 직접 실행 후',
    //                     style: TextStyle(
    //                       fontFamily: 'NanumGothic',
    //                       fontWeight: FontWeight.normal,
    //                       fontSize: guidelineText3FontSize,
    //                       color: WHITE_COLOR,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             // 네이버 로그인 안내 텍스트3
    //             // SafeArea 내부에 배치하여 상태바, 하단 제스처 영역 침범을 방지
    //             SafeArea(
    //               child: Align(
    //                 alignment: Alignment.topCenter,
    //                 child: Padding(
    //                   padding: EdgeInsets.only(
    //                       left: guidelineText3Left, top: guidelineText5Top),
    //                   child: Text(
    //                     "'로그인' 버튼 클릭 시, 타 네이버 계정 선택이 가능합니다.",
    //                     style: TextStyle(
    //                       fontFamily: 'NanumGothic',
    //                       fontWeight: FontWeight.normal,
    //                       fontSize: guidelineText3FontSize,
    //                       color: WHITE_COLOR,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             // 개인정보 처리방침 안내 텍스트1
    //             // SafeArea 내부에 배치하여 상태바, 하단 제스처 영역 침범을 방지
    //             SafeArea(
    //               child: Align(
    //                 alignment: Alignment.topCenter,
    //                 child: Padding(
    //                   padding: EdgeInsets.only(
    //                       left: guidelineText1Left, top: guidelineText1Top),
    //                   child: Text(
    //                     '로그인함으로써 개인정보 처리방침에 동의합니다.',
    //                     style: TextStyle(
    //                       fontFamily: 'NanumGothic',
    //                       fontWeight: FontWeight.normal,
    //                       fontSize: guidelineText1FontSize,
    //                       color: WHITE_COLOR,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             // 개인정보 처리방침 안내 텍스트2
    //             // SafeArea 내부에 배치하여 상태바, 하단 제스처 영역 침범을 방지
    //             SafeArea(
    //               child: Align(
    //                 alignment: Alignment.topCenter,
    //                 child: Padding(
    //                   padding: EdgeInsets.only(
    //                       left: guidelineText2Left, top: guidelineText2Top),
    //                   child: GestureDetector(
    //                     // GestureDetector 사용하여 탭 이벤트 처리
    //                     onTap: () async {
    //                       const url =
    //                           'https://gshe.oopy.io/couture/privacy'; // 열려는 URL
    //                       try {
    //                         final bool launched = await launchUrl(
    //                             Uri.parse(url),
    //                             mode: LaunchMode
    //                                 .externalApplication); // 외부 브라우저에서 URL 열기
    //                         if (!launched) {
    //                           // 웹 페이지를 열지 못할 경우 스낵바로 알림
    //                           showCustomSnackBar(context, '웹 페이지를 열 수 없습니다.');
    //                         }
    //                       } catch (e) {
    //                         // 예외 발생 시 스낵바로 에러 메시지 출력
    //                         showCustomSnackBar(
    //                             context, '에러가 발생했습니다.\n앱을 재실행해주세요.');
    //                       }
    //                     },
    //                     child: Text(
    //                       '개인정보 처리방침 보기',
    //                       style: TextStyle(
    //                         fontFamily: 'NanumGothic',
    //                         fontWeight: FontWeight.normal,
    //                         fontSize: guidelineText2FontSize,
    //                         color: BLUE49_COLOR,
    //                         // 파란색 텍스트
    //                         decoration: TextDecoration.underline, // 밑줄 추가
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             // 관리자 로그인 화면으로 이동 버튼
    //             // SafeArea 내부에 배치하여 상태바, 하단 제스처 영역 침범을 방지
    //             SafeArea(
    //               child: Align(
    //                 alignment: Alignment.topCenter,
    //                 child: Padding(
    //                   padding: EdgeInsets.only(
    //                       top: goToLoginBtnTop, bottom: interval1Y),
    //                   child: GestureDetector(
    //                     // GestureDetector 사용하여 탭 이벤트 처리
    //                     onTap: () async {
    //                       // 로그인 화면으로 이동
    //                       Navigator.of(context).push(
    //                           MaterialPageRoute(builder: (_) => LoginScreen()));
    //                     },
    //                     child: Text(
    //                       '관리자 로그인',
    //                       style: TextStyle(
    //                         fontFamily: 'NanumGothic',
    //                         fontWeight: FontWeight.normal,
    //                         fontSize: goToLoginBtnTextFontSize,
    //                         color: WHITE_COLOR, // 텍스트 색상
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    // // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려한 사이즈 끝 부분
    // // ----- Positioned, Align에 의해 화면 스크롤 시, 배경 제외한 빈 화면이 나오는 이슈가 발생한 이전 로직 끝 부분

    // ----- Positioned, Align에 의해 화면 스크롤 시, 배경 제외한 빈 화면이 나오는 이슈를 해결한 로직 시작 부분
    // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려한 사이즈 시작 부분
    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 화면 이름 부분 수치
    final double screenNameTop = 10; // 위쪽 여백 비율
    final double backBtnTop = 50;
    final double backBtnLeft = screenSize.width * (10 / referenceWidth);

    // 화면 제목 부분 수치
    final double screenTitleTop = 180; // 위쪽 여백 비율
    final double screenLoginText1FontSize = 20;
    final double screenTitleTextFontSize = 20;

    // 화면 서브제목 부분 수치
    final double screenSubTitleTop = 20; // 위쪽 여백 비율
    final double screenSubTitleTextFontSize = 16;

    // 안내 텍스트 부분 수치
    final double guideTextTop = 30; // 위쪽 여백 비율
    final double guideTextFontSize = 14;

    // SNS 계정 로그인 버튼 부분 수치
    final double easyLoginBtnImageTop = 30; // 위쪽 여백 비율
    final double interval1X = 20;
    final double easyLoginBtnImageWidth =
        screenSize.width * (70 / referenceWidth);
    final double easyLoginBtnImageHeight = 70;

    // 네이버 로그인 안내 텍스트 부분 수치
    final double guidelineText3Top = 30; // 위쪽 여백 비율
    final double guidelineText3FontSize = 8; // 텍스트 크기

    // 개인정보 처리방침 보기 부분 수치
    final double guidelineText1Top = 120; // 위쪽 여백 비율
    final double guidelineText1FontSize = 13; // 텍스트 크기

    // 관리자 로그인 화면으로 이동 버튼 부분 수치
    final double goToLoginBtnTop = 20; // 위쪽 여백 비율
    final double goToLoginBtnTextFontSize = 16;

    final double interval1Y = 700;


    return Scaffold(
      body: Stack(
        children: [
          // 1) 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'asset/img/misc/login_image/wearcano_easy_login_bg_img.png',
              fit: BoxFit.cover,
            ),
          ),

          // 2) 메인 콘텐츠 (스크롤 가능)
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(), // iOS에서 자연스러운 스크롤
              child: Column(
                children: [
                  SizedBox(height: screenNameTop),

                  // ------------------------------------------
                  // 상단 영역: (A) 닫기 아이콘 (B) 화면 제목(로그인)
                  // ------------------------------------------
                  // 닫기 아이콘 + "로그인"을 가운데 배치하기 위해 Stack 사용
                  SizedBox(
                    height: backBtnTop,
                    child: Stack(
                      children: [
                        // (A) 닫기(뒤로가기) 아이콘 (왼쪽 정렬, canPop인 경우만)
                        if (Navigator.canPop(context))
                          Positioned(
                            left: backBtnLeft,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back),
                              color: BLACK_COLOR,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        // (B) 화면 제목(로그인) - 중앙 정렬
                        Center(
                          child: Text(
                            '로그인',
                            style: TextStyle(
                              fontSize: screenLoginText1FontSize,
                              fontWeight: FontWeight.w600,
                              color: BLACK_COLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenTitleTop),

                  // ------------------------------------------
                  // 타이틀 문구
                  // ------------------------------------------
                  Text(
                    '동대문 의류도매 제로마진 플랫폼',
                    style: TextStyle(
                      fontFamily: 'NanumGothic',
                      fontWeight: FontWeight.bold,
                      fontSize: screenTitleTextFontSize,
                      color: WHITE_COLOR,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenSubTitleTop),

                  Text(
                    '웨어카노, Wearcano',
                    style: TextStyle(
                      fontFamily: 'NanumGothic',
                      fontWeight: FontWeight.normal,
                      fontSize: screenSubTitleTextFontSize,
                      color: WHITE_COLOR,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: guideTextTop),

                  // 안내 문구
                  Text(
                    'SNS 버튼 클릭 후, 간편하게 로그인 및 회원가입을 하세요.',
                    style: TextStyle(
                      fontFamily: 'NanumGothic',
                      fontWeight: FontWeight.normal,
                      fontSize: guideTextFontSize,
                      color: WHITE_COLOR,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: easyLoginBtnImageTop),

                  // ------------------------------------------
                  // SNS 로그인 버튼들 (네이버, 애플)
                  // ------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 네이버 로그인 버튼
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(naverSignInNotifierProvider.notifier)
                              .signInWithNaver();
                        },
                        child: Image.asset(
                          'asset/img/misc/login_image/naver_login_btn_img.png',
                          width: easyLoginBtnImageWidth,
                          height: easyLoginBtnImageHeight,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: interval1X),
                      // 애플 로그인 버튼
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(appleSignInNotifierProvider.notifier)
                              .signInWithApple();
                        },
                        child: Image.asset(
                          'asset/img/misc/login_image/apple_login_btn_img.png',
                          width: easyLoginBtnImageWidth,
                          height: easyLoginBtnImageHeight,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: guidelineText3Top),

                  // ------------------------------------------
                  // 네이버 로그인 안내 문구
                  // ------------------------------------------
                  Text(
                    '[네이버 로그인 안내]\n'
                        '네이버 앱 또는 웹 브라우저 내 로그아웃을 직접 실행 후\n'
                        "'로그인' 버튼 클릭 시, 타 네이버 계정 선택이 가능합니다.",
                    style: TextStyle(
                      fontFamily: 'NanumGothic',
                      fontWeight: FontWeight.normal,
                      fontSize: guidelineText3FontSize,
                      color: WHITE_COLOR,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: guidelineText1Top),

                  // ------------------------------------------
                  // 개인정보 처리방침 보기
                  // ------------------------------------------
                  GestureDetector(
                    onTap: () async {
                      const url = 'https://gshe.oopy.io/couture/privacy';
                      try {
                        final bool launched = await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                        if (!launched) {
                          showCustomSnackBar(context, '웹 페이지를 열 수 없습니다.');
                        }
                      } catch (e) {
                        showCustomSnackBar(context, '에러가 발생했습니다.\n앱을 재실행해주세요.');
                      }
                    },
                    child: Text(
                      '개인정보 처리방침 보기',
                      style: TextStyle(
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.bold,
                        fontSize: guidelineText1FontSize,
                        color: BLUE49_COLOR,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  SizedBox(height: goToLoginBtnTop),

                  // ------------------------------------------
                  // 관리자 로그인 (기존 로그인 화면으로 이동)
                  // ------------------------------------------
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    child: Text(
                      '관리자 로그인',
                      style: TextStyle(
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.normal,
                        fontSize: goToLoginBtnTextFontSize,
                        color: WHITE_COLOR,
                      ),
                    ),
                  ),

                  SizedBox(height: interval1Y), // 하단 여백
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려한 사이즈 끝 부분
    // ----- Positioned, Align에 의해 화면 스크롤 시, 배경 제외한 빈 화면이 나오는 이슈를 해결한 로직 끝 부분
  }
}
// ------ IOS용 간편 로그인 화면 UI 구현 관련 EasyLoginIosScreen 끝 부분
