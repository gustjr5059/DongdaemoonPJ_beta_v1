import 'package:dongdaemoon_beta_v1/user/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'home/view/home_screen.dart';

// Firebase 초기화 코드(Firebase와 Flutter 프로젝트가 통합되어 Firebase 서비스를 사용가능)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope( // 앱을 ProviderScope로 감싸기
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // 사용자가 로그인한 경우, 홈페이지로 이동
            return HomeScreen();
          } else {
            // 사용자가 로그아웃한 경우 또는 로그인하지 않은 경우, 로그인 페이지로 이동
            return LoginScreen();
          }
        },
      ),
    );
  }
}
