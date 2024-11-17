// Flutter에서 제공하는 Material 디자인 위젯을 사용하기 위해 필수적인 패키지입니다.
// 이 패키지는 애플리케이션의 시각적 구성 요소들을 제공하며, UI 구축의 기본이 됩니다.
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Dart에서 비동기 프로그래밍을 위한 기본 라이브러리인 'dart:async'를 임포트합니다.
// 이 라이브러리는 비동기 작업을 관리하기 위한 Future와 Stream과 같은 객체들을 제공합니다.
// 예를 들어, 네트워크 요청, 데이터베이스 쿼리 등의 작업을 비동기적으로 처리할 때 사용됩니다.
import 'dart:async'; // 비동기 작업을 위한 dart:async 라이브러리 임포트
// 사용자 인증과 관련된 로그인 화면 구성을 위한 LoginScreen 파일을 임포트합니다.
// 이 파일은 사용자가 로그인할 수 있는 인터페이스를 제공하며, 사용자의 인증 정보를 처리합니다.
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../user/view/login_screen.dart'; // 로그인 화면으로 이동하기 위한 LoginScreen 임포트


// ------ IOS용 간편 로그인 화면 UI 구현 관련 EasyLoginIosScreen 시작 부분
class EasyLoginIosScreen extends StatefulWidget {
  // 라우트 이름 정의
  static String get routeName => 'login';

  @override
  _EasyLoginIosScreenState createState() => _EasyLoginIosScreenState();
}

class _EasyLoginIosScreenState extends State<EasyLoginIosScreen> {
  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  @override
  void initState() {
    super.initState();
    // 네트워크 상태 체크 시작
    _networkChecker = NetworkChecker(context);
    _networkChecker?.checkNetworkStatus();
  }

  @override
  void dispose() {
    super.dispose();

    // 네트워크 체크 해제
    _networkChecker?.dispose();
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
    final double screenTitleTop =
        screenSize.height * (227 / referenceHeight); // 위쪽 여백 비율
    final double screenLoginText1FontSize =
        screenSize.height * (24 / referenceHeight);
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

    // 로그인 개인정보 처리방침 안내 텍스트1 부분 수치
    final double guidelineText1Top =
        screenSize.height * (680 / referenceHeight); // 위쪽 여백 비율
    final double guidelineText1FontSize =
        screenSize.height * (13 / referenceHeight); // 텍스트 크기

    // 로그인 개인정보 처리방침 안내 텍스트2 부분 수치
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
              'asset/img/misc/login_image/wearcano_easy_login_bg_img.png',
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
                'Login',
                style: TextStyle(
                  fontSize: screenLoginText1FontSize,
                  fontWeight: FontWeight.w600,
                  color: BLACK_COLOR,
                ),
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
                '웨어카노, Wearcano',
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
                '해당 SNS 버튼 클릭 후, 간편 로그인을 하세요.',
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
                  // 카카오 로그인 버튼
                  GestureDetector(
                    onTap: () {
                      // 카카오 로그인 화면으로 이동
                      // Navigator.of(context).push(
                      //     MaterialPageRoute(builder: (_) => KakaoLoginScreen()),
                    },
                    child: Container(
                      child: Image.asset(
                        'asset/img/misc/login_image/kakao_login_btn_img.png',
                        width: easyLoginBtnImageWidth,
                        height: easyLoginBtnImageHeight,
                        fit: BoxFit.contain, // 이미지 크기 조정
                      ),
                    ),
                  ),
                  SizedBox(width: interval1X),
                  // 애플 로그인 버튼
                  GestureDetector(
                    onTap: () {
                      // 애플 로그인 화면으로 이동
                      // Navigator.of(context).push(
                      //     MaterialPageRoute(builder: (_) => AppleLoginScreen()),
                    },
                    child: Container(
                      child: Image.asset(
                        'asset/img/misc/login_image/apple_login_btn_img.png',
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
          // 개인정보 처리방침 안내 텍스트1
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: guidelineText1Top),
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
              padding: EdgeInsets.only(top: guidelineText2Top),
              child: GestureDetector(
                // GestureDetector 사용하여 탭 이벤트 처리
                onTap: () async {
                  const url = 'https://pf.kakao.com/_xjVrbG'; // 열려는 URL
                  try {
                    final bool launched = await launchUrl(Uri.parse(url),
                        mode:
                            LaunchMode.externalApplication); // 외부 브라우저에서 URL 열기
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
                    fontWeight: FontWeight.bold,
                    fontSize: guidelineText2FontSize,
                    color: BLUE49_COLOR, // 파란색 텍스트
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
                  Navigator.of(context).pushReplacement(
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
// ------ IOS용 간편 로그인 화면 UI 구현 관련 EasyLoginIosScreen 끝 부분