// Firebase의 사용자 인증 기능을 제공하는 FirebaseAuth 패키지를 임포트합니다.
// FirebaseAuth는 애플리케이션에 로그인 및 사용자 관리 기능을 추가하는 데 필수적인 도구로,
// 이메일과 비밀번호를 이용한 인증, 소셜 로그인, 전화번호 인증 등 다양한 인증 옵션을 지원합니다.
import 'package:firebase_auth/firebase_auth.dart';

// Flutter의 기본적인 플랫폼, 레이아웃, 그리고 디자인 지원을 위해 Foundation 라이브러리를 임포트합니다.
// 이 라이브러리는 Flutter 앱 개발의 기초를 제공하며, 플랫폼 간 호환성과 기본적인 기능 구현에 필요한 요소들을 포함합니다.
import 'package:flutter/foundation.dart';

// Flutter의 UI 구성 요소를 제공하는 Material 디자인 패키지를 임포트합니다.
// 이 패키지는 다양한 머티리얼 디자인 위젯을 포함하여, 사용자 인터페이스를 효과적으로 구성할 수 있게 도와줍니다.
import 'package:flutter/material.dart';

// GoRouter 패키지를 임포트하여, Flutter 애플리케이션 내에서의 라우팅 관리를 용이하게 합니다.
// GoRouter는 선언적 스타일의 라우팅을 지원하며, URL 기반 라우팅, 네스트된 라우팅, 리다이렉션 등 복잡한 라우팅 요구 사항을 처리할 수 있습니다.
import 'package:go_router/go_router.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthProvider() {
    _listenToAuthStateChanges();
  }

  void _listenToAuthStateChanges() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        // 사용자가 로그아웃했거나 로그인하지 않은 경우
      } else {
        // 사용자가 로그인한 경우
      }
      notifyListeners();
    });
  }

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final user = FirebaseAuth.instance.currentUser;

    final loggingIn = state.uri.path == '/login';
    final isSplashScreen = state.uri.path == '/splash';

    // 사용자가 로그인하지 않은 경우
    if (user == null) {
      return loggingIn ? null : '/login';
    }

    // 사용자가 로그인한 경우
    if (user != null) {
      return isSplashScreen || loggingIn ? '/' : null;
    }

    return null;
  }
}

Future<void> logout() async {
  try {
    await FirebaseAuth.instance.signOut();
    // 로그아웃 후 필요한 처리, 예를 들어 상태 업데이트 또는 화면 전환 등
  } catch (e) {
    // 로그아웃 실패 시 처리, 예를 들어 오류 메시지 표시
  }
}
