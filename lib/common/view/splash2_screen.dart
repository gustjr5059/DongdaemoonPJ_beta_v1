import 'package:flutter/material.dart';
import 'dart:async'; // 비동기 작업을 위한 dart:async 라이브러리 임포트
import '../../home/view/home_screen.dart'; // 홈 화면으로 이동하기 위한 HomeScreen 임포트
import '../const/colors.dart'; // 색상 정의 파일 임포트

class SplashScreen2 extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen2> {

  @override
  void initState() {
    super.initState();
    // 앱 시작 후 3초 후에 홈 화면으로 자동으로 이동함.
    Timer(Duration(seconds: 3), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    // 스플래시 화면 UI 구성
    return Scaffold(
      backgroundColor: LOGO_COLOR, // 배경색상으로 LOGO_COLOR 사용
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 세로축 중앙 정렬
          crossAxisAlignment: CrossAxisAlignment.start, // 가로축 시작점 정렬
          children: <Widget>[
            Text('당신도',
              style: TextStyle(
                fontSize: 30.0, // 글자 크기
                height: 2.0, // 줄 높이
                color: INPUT_BORDER_COLOR, // 글자 색상으로 INPUT_BORDER_COLOR 사용
              ),
            ),
            SizedBox(height: 20), // "당신도"와 "쇼핑몰 창업자" 사이의 공간
            Padding(
              padding: const EdgeInsets.only(left: 40.0), // 왼쪽으로 40의 패딩
              child: Text('쇼핑몰 창업자',
                style: TextStyle(
                  fontSize: 30.0, // 글자 크기
                  height: 2.0, // 줄 높이
                  color: GOLD_COLOR, // 글자 색상으로 GOLD_COLOR 사용
                ),
              ),
            ),
            SizedBox(height: 20), // "쇼핑몰 창업자"와 "될 수 있어" 사이의 공간
            Padding(
              padding: const EdgeInsets.only(left: 130.0), // 왼쪽으로 130의 패딩
              child: Text('될 수 있어',
                style: TextStyle(
                  fontSize: 30.0, // 글자 크기
                  height: 2.0, // 줄 높이
                  color: INPUT_BORDER_COLOR, // 글자 색상으로 INPUT_BORDER_COLOR 사용
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
