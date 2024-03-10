import 'package:dongdaemoon_beta_v1/user/view/login_screen.dart'; // 로그인 화면 관련 패키지
import 'package:firebase_auth/firebase_auth.dart'; // Firebase 인증 관련 패키지
import 'package:firebase_core/firebase_core.dart'; // Firebase 코어 관련 패키지
import 'package:flutter/cupertino.dart'; // iOS 스타일 위젯 관련 패키지
import 'package:flutter/material.dart'; // Material 디자인 위젯 관련 패키지
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리 라이브러리 Riverpod 관련 패키지
import 'firebase_options.dart'; // Firebase 초기 설정 관련 패키지 (firebase_cli를 통해 생성된 파일)
import 'home/view/home_screen.dart'; // 홈 화면 관련 패키지

// Firebase 초기화 코드
// (Firebase와 Flutter 프로젝트를 연동하여 Firebase 서비스를 사용할 수 있게 함)
// Firebase와 Flutter 프로젝트가 통합되어 Firebase 서비스를 사용가능)
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진이 초기화되기 전에 실행되어야 하는 코드를 위한 메서드
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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), // Firebase 인증 상태 변화를 수신하는 스트림
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // 사용자가 로그인한 경우, HomeScreen (홈 화면)으로 이동
            return HomeScreen();
          } else {
            // 사용자가 로그아웃한 경우 또는 로그인하지 않은 경우, LoginScreen (로그인 화면)으로 이동
            return LoginScreen();
          }
        },
      ),
    );
  }
}