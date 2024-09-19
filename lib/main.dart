// Firebase 코어 관련 기능을 사용하기 위해 필요한 Firebase Core 패키지를 임포트합니다.
// 이 패키지는 Firebase 서비스를 Flutter 애플리케이션에 연동하고 초기화하는데 사용됩니다.
// Firebase 서비스에는 인증, 데이터베이스, 분석 등 다양한 기능이 포함되어 있으며,
// 이를 사용하기 위해서는 초기화 과정이 필수적입니다.
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase 코어 관련 패키지
// iOS 스타일의 인터페이스 요소를 사용하기 위해 Cupertino 디자인 패키지를 임포트합니다.
// 이 패키지는 iOS 사용자에게 친숙한 디자인 요소와 애니메이션을 제공하여 iOS 사용자 경험을 향상시킵니다.
import 'package:flutter/cupertino.dart'; // iOS 스타일 위젯 관련 패키지
// Flutter의 UI 구성 요소를 제공하는 Material 디자인 패키지를 임포트합니다.
// 이 패키지는 다양한 머티리얼 디자인 위젯을 포함하여 사용자 인터페이스를 효과적으로 구성할 수 있도록 도와줍니다.
import 'package:flutter/material.dart'; // Material 디자인 위젯 관련 패키지
// 상태 관리를 위한 현대적인 라이브러리인 Riverpod를 임포트합니다.
// Riverpod는 애플리케이션의 상태를 효과적으로 관리하고, 상태 변화에 따라 UI를 자동으로 업데이트합니다.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리 라이브러리 Riverpod 관련 패키지
// 애플리케이션의 초기 스크린을 정의하는 스플래시 스크린 뷰 파일을 임포트합니다.
// 이 스크린은 앱이 로딩되는 동안 사용자에게 보여지며, 첫 인상을 형성하는 중요한 역할을 합니다.
import 'common/view/splash1_error_screen.dart';
import 'common/view/splash1_screen.dart';

// Firebase 초기 설정 파일을 임포트합니다.
// 이 파일은 FlutterFire CLI 도구를 사용하여 생성되며, Firebase 프로젝트의 구성 정보를 포함하고 있습니다.
// Firebase 서비스를 사용하기 위한 필수적인 API 키, 프로젝트 ID 등의 정보가 이 파일에 정의되어 있습니다.
import 'firebase_options.dart'; // Firebase 초기 설정 관련 패키지 (firebase_cli를 통해 생성된 파일)

// Firebase 초기화 코드
// (Firebase와 Flutter 프로젝트를 연동하여 Firebase 서비스를 사용할 수 있게 함)
// Firebase와 Flutter 프로젝트가 통합되어 Firebase 서비스를 사용가능)
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Flutter 엔진이 초기화되기 전에 실행되어야 하는 코드를 위한 메서드
  // Firebase 초기화
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // 현재 플랫폼에 맞는 Firebase 초기 설정 적용
  );
  runApp(
    ProviderScope(
      // 앱 전체에 걸쳐 Riverpod 상태 관리를 가능하게 하는 최상위 위젯
      child: MyApp(),
    ),
  );
}

// ------ 앱 실행할 때 필요한 메인 실행 역할인 MyApp 클래스 내용 시작
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isFirebaseConnected = true; // Firebase 연결 상태 변수
  StreamSubscription? _networkSubscription; // 네트워크 상태 구독자

  @override
  void initState() {
    super.initState();
    _checkFirebaseConnection(); // Firebase 연결 상태 확인
    _monitorNetworkStatus(); // 네트워크 상태 실시간 감지
  }

  @override
  void dispose() {
    _networkSubscription?.cancel(); // 네트워크 상태 구독 해제
    super.dispose();
  }

  // Firebase 연결 상태를 확인하는 함수
  Future<void> _checkFirebaseConnection() async {
    try {
      // Firebase 연결 확인 (Firebase 기본 서비스 확인)
      await Firebase.initializeApp(); // Firebase 초기화
      setState(() {
        _isFirebaseConnected = true; // 연결 성공 시 상태 업데이트
      });
    } catch (e) {
      setState(() {
        _isFirebaseConnected = false; // 연결 실패 시 상태 업데이트
      });
    }
  }

  // 네트워크 상태를 실시간으로 모니터링하는 함수
  void _monitorNetworkStatus() {
    _networkSubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      for (var result in results) {
        if (result == ConnectivityResult.none) {
          setState(() {
            _isFirebaseConnected = false; // 네트워크 연결이 끊기면 상태 업데이트
          });
        } else {
          _checkFirebaseConnection(); // 네트워크가 다시 연결되면 Firebase 연결 상태 확인
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 화면에 debug 리본형식이 나오는 것 비활성화하는 설정
      // Firebase가 연결되어 있으면 SplashScreen1()을 홈 화면으로 설정
      // Firebase가 연결되지 않았거나 네트워크가 끊긴 경우 SplashErrorScreen1()을 홈 화면으로 설정
      home: _isFirebaseConnected ? SplashScreen1() : SplashErrorScreen1(),
    );
  }
}
// ------ 앱 실행할 때 필요한 메인 실행 역할인 MyApp 클래스 내용 끝