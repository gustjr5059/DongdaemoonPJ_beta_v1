// Flutter에서 제공하는 Material 디자인 요소를 사용하기 위한 패키지입니다.
// 이 패키지는 버튼, 카드, 타이포그래피 등의 디자인 요소를 포함하고 있으며,
// 앱의 기본적인 UI 구성에 필수적입니다.
import 'package:flutter/material.dart';

// Dart의 비동기 프로그래밍을 지원하는 'dart:async' 라이브러리를 가져옵니다.
// 이 라이브러리는 Future와 Stream을 통해 비동기 작업을 쉽게 다룰 수 있게 해주며,
// 네트워크 요청, 파일 I/O, 시간 지연 작업 등에 사용됩니다.
import 'dart:async'; // 비동기 작업을 위한 dart:async 라이브러리를 가져옴.
// 애플리케이션의 스플래시 스크린 중 두 번째 화면을 구현한 'SplashScreen2' 파일을 가져옵니다.
// 이 화면은 앱이 시작할 때 초기 로딩 화면으로 사용되어, 사용자에게 앱 로딩 중임을 알립니다.
import 'package:dongdaemoon_beta_v1/common/view/splash2_screen.dart'; // 다음 화면으로 전환하기 위해 SplashScreen2를 가져옴.
import 'package:flutter_svg/svg.dart';
// 애플리케이션 전반에 걸쳐 사용될 색상의 상수를 정의한 파일을 가져옵니다.
// 이 파일에서 정의된 색상은 버튼, 배경, 텍스트 등 다양한 UI 요소에 일관되게 사용되어,
// 앱의 디자인 통일성을 유지하는데 도움을 줍니다.
import '../const/colors.dart';
import '../layout/common_body_parts_layout.dart'; // 앱에서 사용할 색상 상수를 정의한 파일을 가져옴.

// ------ 네트워크 통신이 끊긴 경우에 나오는 에러 화면 내용인 SplashErrorScreen1 시작
class SplashErrorScreen1 extends StatefulWidget {
  @override
  _SplashErrorScreenState createState() => _SplashErrorScreenState();
}

// _SplashScreenState 클래스에서 SingleTickerProviderStateMixin을 사용하여 애니메이션 컨트롤러를 생성함.
class _SplashErrorScreenState extends State<SplashErrorScreen1>
    with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 세로 852
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 화면 부분 수치
    final double errorTextFontSize =
        screenSize.height * (18 / referenceHeight);
    final double screenX =
        screenSize.height * (180 / referenceHeight); // 위쪽 여백 비율

    // 화면의 UI를 구성함.
    return Scaffold(
      body: Stack(
        // Stack 위젯을 사용하여 요소들을 겹쳐서 배치함.
        children: <Widget>[
          // 피그마에서 추출한 배경 이미지를 SVG로 추가
          Positioned.fill(
            child: Image.asset(
              'asset/img/misc/splash_image/couture_splash1_bg_img.png', // 배경 이미지를 SVG로 설정
              fit: BoxFit.cover, // 화면 전체에 맞게 조정
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter, // 하단 중앙에 배치함.
            child: Padding(
              padding: EdgeInsets.only(bottom: screenX), // 하단에서부터 100의 여백을 줌.
              child: Text(
                '네트워크가 연결되지 않았습니다.\n\n         앱을 재실행 해주세요.',
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.bold,
                  fontSize: errorTextFontSize,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// ------ 네트워크 통신이 끊긴 경우에 나오는 에러 화면 내용인 SplashErrorScreen1 끝