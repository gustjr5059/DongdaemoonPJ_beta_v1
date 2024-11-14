// Flutter에서 제공하는 Material 디자인 위젯을 사용하기 위해 필수적인 패키지입니다.
// 이 패키지는 애플리케이션의 시각적 구성 요소들을 제공하며, UI 구축의 기본이 됩니다.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Dart에서 비동기 프로그래밍을 위한 기본 라이브러리인 'dart:async'를 임포트합니다.
// 이 라이브러리는 비동기 작업을 관리하기 위한 Future와 Stream과 같은 객체들을 제공합니다.
// 예를 들어, 네트워크 요청, 데이터베이스 쿼리 등의 작업을 비동기적으로 처리할 때 사용됩니다.
import 'dart:async'; // 비동기 작업을 위한 dart:async 라이브러리 임포트
// 사용자 인증과 관련된 로그인 화면 구성을 위한 LoginScreen 파일을 임포트합니다.
// 이 파일은 사용자가 로그인할 수 있는 인터페이스를 제공하며, 사용자의 인증 정보를 처리합니다.
import '../../home/view/home_screen.dart';
import '../../user/view/login_screen.dart'; // 로그인 화면으로 이동하기 위한 LoginScreen 임포트
// 애플리케이션에서 사용될 색상을 정의한 파일을 임포트합니다.
// 이 파일은 애플리케이션의 다양한 구성 요소에 사용될 색상의 값을 상수로 정의하여,
// 디자인의 일관성을 유지하는 데 도움을 줍니다.
import '../const/colors.dart';
import '../layout/common_body_parts_layout.dart'; // 색상 정의 파일 임포트

class SplashScreen2 extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen2> {

  @override
  void initState() {
    super.initState();
    // 위젯이 생성될 때 _checkAutoLogin 메서드를 호출하여 자동 로그인 여부를 확인.
    _checkAutoLogin();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 자동 로그인을 확인하는 비동기 메서드.
  void _checkAutoLogin() async {
    // SharedPreferences 인스턴스를 가져옴.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 'autoLogin' 키에 저장된 값을 불러오며, 값이 없을 경우 기본값으로 false를 사용.
    bool autoLogin = prefs.getBool('autoLogin') ?? false;

    // 1.75초 후에 다음 동작을 수행.
    Timer(Duration(milliseconds: 1750), () {
      if (autoLogin) {
        // autoLogin이 true인 경우 HomeMainScreen으로 이동.
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => HomeMainScreen()));
      } else {
        // autoLogin이 false인 경우 LoginScreen으로 이동.
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 스플래시 화면 UI 구성
    return Scaffold(
      body: Stack(
        // Stack 위젯을 사용하여 요소들을 겹쳐서 배치함.
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'asset/img/misc/splash_image/couture_splash2_bg_img.png', // 이미지 파일 경로를 설정.
              fit: BoxFit.cover, // 이미지 비율을 유지하면서 화면에 맞게 조절
            ),
          ),
        ],
      ),
    );
  }
}