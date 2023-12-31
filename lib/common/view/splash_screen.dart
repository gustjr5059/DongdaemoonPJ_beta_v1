import 'package:dongdaemoon_beta_v1/common/view/root_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../user/view/login_screen.dart';
import '../const/colors.dart';
import '../layout/default_layout.dart';

class SplashScreen extends ConsumerWidget {
  static String get routeName => 'splash';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Firebase 인증 상태를 실시간으로 감지
    final user = ref.watch(authStateChangesProvider);{
      if (user == null) {
        // 사용자가 로그인하지 않은 경우, 로그인 화면으로 이동
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      } else {
        // 사용자가 로그인한 경우, 메인 화면으로 이동
        Navigator.of(context).pushReplacementNamed(RootTab.routeName);
      }
    };

    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: _buildSplashContent(context),
    );
  }

  Widget _buildSplashContent(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'asset/img/logo/logo.png',
            width: MediaQuery.of(context).size.width / 2,
          ),
          const SizedBox(height: 16.0),
          CircularProgressIndicator(
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

// Firebase 인증 상태 변경을 감지하는 Provider
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
