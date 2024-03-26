import 'package:flutter/material.dart';
import 'dart:async'; // 비동기 작업을 위한 dart:async 라이브러리 임포트
import '../../user/view/login_screen.dart'; // 로그인 화면으로 이동하기 위한 LoginScreen 임포트
import '../const/colors.dart'; // 색상 정의 파일 임포트

class SplashScreen2 extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen2> {

  @override
  void initState() {
    super.initState();
    // 앱 시작 후 1초 후에 로그인 화면으로 자동으로 이동함.
    // (BuildContext context) -> (_) 로 변경 : 매개변수를 정의해야 하지만 실제로 내부 로직에서 사용하지 않을 때 표기방법
    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    // 스플래시 화면 UI 구성
    return Scaffold(
      backgroundColor: LOGO_COLOR, // 배경색상으로 LOGO_COLOR 사용
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 60.0), // 상하 여백만 추가
          child: Image.asset(
            // 'asset/img/misc/splash2_image.png',
            // 'asset/img/misc/ssamjang.png',
            'asset/img/misc/douna.png',// 이미지 파일 경로를 설정하세요.
            fit: BoxFit.contain, // 이미지 비율을 유지하면서 화면에 맞게 조절
          ),
        ),
      ),
    );
  }
}
