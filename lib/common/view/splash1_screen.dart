import 'package:dongdaemoon_beta_v1/common/view/splash2_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../const/colors.dart';

// 스플래시 화면에 대한 StatefulWidget을 생성함.
class SplashScreen1 extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

// _SplashScreenState 클래스는 SplashScreen1의 상태를 관리함.
class _SplashScreenState extends State<SplashScreen1> {

  @override
  void initState() {
    super.initState(); // 상위 클래스의 initState() 함수를 호출함.
    // 3초 후에 SplashScreen2로 화면을 전환함.
    Timer(Duration(seconds: 3), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SplashScreen2())));
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold를 사용하여 기본 머티리얼 디자인 레이아웃을 제공함.
    return Scaffold(
      backgroundColor: LOGO_COLOR, // 배경색상으로 LOGO_COLOR를 사용함.
      body: Center(
        // body에서는 중앙에 이미지를 배치함.
        // asset/img/misc 디렉토리의 logo_image.jpg를 로드하여 표시함.
        child: Image.asset('asset/img/misc/logo_image.jpg'),
      ),
    );
  }
}
