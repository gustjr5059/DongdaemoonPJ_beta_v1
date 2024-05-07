

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

