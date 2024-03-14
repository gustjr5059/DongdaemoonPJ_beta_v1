
import 'package:firebase_core/firebase_core.dart'; // Firebase 코어 관련 패키지
import 'package:flutter/cupertino.dart'; // iOS 스타일 위젯 관련 패키지
import 'package:flutter/material.dart'; // Material 디자인 위젯 관련 패키지
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리 라이브러리 Riverpod 관련 패키지
import 'common/view/splash1_screen.dart';
import 'firebase_options.dart'; // Firebase 초기 설정 관련 패키지 (firebase_cli를 통해 생성된 파일)


// Firebase 초기화 코드
// (Firebase와 Flutter 프로젝트를 연동하여 Firebase 서비스를 사용할 수 있게 함)
// Firebase와 Flutter 프로젝트가 통합되어 Firebase 서비스를 사용가능)
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진이 초기화되기 전에 실행되어야 하는 코드를 위한 메서드
  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // 현재 플랫폼에 맞는 Firebase 초기 설정 적용
  );
  runApp(
    ProviderScope( // 앱 전체에 걸쳐 Riverpod 상태 관리를 가능하게 하는 최상위 위젯
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen1(), // 첫 화면으로 SplashScreen을 설정
    );
  }
}