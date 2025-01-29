// Flutter에서 제공하는 Material 디자인 위젯을 사용하기 위해 필수적인 패키지입니다.
// 이 패키지는 애플리케이션의 시각적 구성 요소들을 제공하며, UI 구축의 기본이 됩니다.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Dart에서 비동기 프로그래밍을 위한 기본 라이브러리인 'dart:async'를 임포트합니다.
// 이 라이브러리는 비동기 작업을 관리하기 위한 Future와 Stream과 같은 객체들을 제공합니다.
// 예를 들어, 네트워크 요청, 데이터베이스 쿼리 등의 작업을 비동기적으로 처리할 때 사용됩니다.
import 'dart:async'; // 비동기 작업을 위한 dart:async 라이브러리 임포트
// 사용자 인증과 관련된 로그인 화면 구성을 위한 LoginScreen 파일을 임포트합니다.
// 이 파일은 사용자가 로그인할 수 있는 인터페이스를 제공하며, 사용자의 인증 정보를 처리합니다.
import '../../home/view/home_screen.dart';
import '../../user/provider/sns_login_and_sign_up_all_provider.dart';
import '../../user/view/login_screen.dart'; // 로그인 화면으로 이동하기 위한 LoginScreen 임포트
// 애플리케이션에서 사용될 색상을 정의한 파일을 임포트합니다.
// 이 파일은 애플리케이션의 다양한 구성 요소에 사용될 색상의 값을 상수로 정의하여,
// 디자인의 일관성을 유지하는 데 도움을 줍니다.
import '../const/colors.dart';
import '../layout/common_body_parts_layout.dart'; // 색상 정의 파일 임포트

class SplashScreen2 extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen2> {
  @override
  void initState() {
    super.initState();
    // 위젯이 생성될 때 _checkAutoLogin 메서드를 호출하여 자동 로그인 여부를 확인.
    _checkAutoLogin(ref);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // // ----- 일반 이메일/비밀번호 로그인 및 회원가입 관련 자동 로그인 메서드 내용 시작
  // // 자동 로그인을 확인하는 비동기 메서드
  // // 앱 실행 시, 사용자가 이전에 '자동 로그인'을 체크했는지 확인하고
  // // Firebase Authentication 상태와 함께 검증하여 로그인 유지 여부를 결정.
  // void _checkAutoLogin(WidgetRef ref) async {
  //   // ───────────────────────────────────────────────────────────────
  //   // (1) SharedPreferences에서 autoLogin 값 가져오기
  //   //     - 사용자 기기에 'autoLogin' 여부(체크박스 상태) 저장되어 있는지 확인
  //   //     - 없으면 false(미체크)로 간주
  //   // ───────────────────────────────────────────────────────────────
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool autoLogin = prefs.getBool('autoLogin') ?? false;
  //
  //   // ───────────────────────────────────────────────────────────────
  //   // (2) 현재 Firebase 인증 상태에서 사용자 정보를 가져옴
  //   //     - FirebaseAuth.instance.currentUser로 현재 로그인한 사용자 정보 확인
  //   //     - 로그아웃 상태이면 user == null
  //   // ───────────────────────────────────────────────────────────────
  //   User? user = FirebaseAuth.instance.currentUser;
  //
  //   // ───────────────────────────────────────────────────────────────
  //   // (3) 사용자 정보가 있는 경우 (user != null)
  //   //     - 이미 Firebase 로그인 상태임
  //   // ───────────────────────────────────────────────────────────────
  //   if (user != null) {
  //     // 3-1) 'password' Provider인 경우 → 이메일/비밀번호 로그인 방식을 사용했는지 체크
  //     //      autoLogin이 false라면 => 자동 로그인 해제
  //     bool isEmailUser = user.providerData.any((info) => info.providerId == 'password');
  //
  //     // ▸ 이메일/비밀번호 사용자이고(autoLogin == false)이면 로그아웃 처리
  //     if (isEmailUser && !autoLogin) {
  //       // 자동 로그인이 체크되어 있지 않으므로 로그인 해제
  //       await FirebaseAuth.instance.signOut();
  //       // 로그아웃 직후 user 상태를 null로 업데이트 (화면에 즉시 반영할 수 있도록)
  //       user = null;
  //     // } else {
  //     //   // SNS 계정 로그인 사용자인 경우 추가 검증 필요
  //     //   // ───────────────────────────────────────────────────────────────
  //     //   // (3-2) Firestore 'users' 컬렉션에서 사용자 문서 확인
  //     //   //       - SNS 계정 로그인 사용자의 경우에도
  //     //   //         Firestore 'users' 컬렉션에 해당 문서가 없을 경우 로그아웃 처리
  //     //   // ───────────────────────────────────────────────────────────────
  //     //   // Firestore 사용자 문서 존재 여부 확인
  //     //   final userDocumentExists = await ref.read(userDocumentExistsProvider(user.email).future);
  //     //
  //     //   // 사용자 문서가 존재하지 않으면 로그아웃 처리
  //     //   if (!userDocumentExists) {
  //     //     print('Firestore에서 사용자 문서를 찾을 수 없음: ${user.email}');
  //     //     await FirebaseAuth.instance.signOut();
  //     //     user = null;
  //     //   }
  //     }
  //
  //     // SNS 계정 로그인 사용자의 경우는 3-1인 이메일/비밀번호 사용자이고(autoLogin == false)이면 로그아웃 처리에 해당하지 않는 경우이므로
  //     // else 경우에 해당하고 해당 경우는 따로 구현하지않아도 일반적으로 반대 케이스로 인식하므로 로그인 해제가 안되어서 자연스레 앱을 재실행해도 로그인 상태가 유지됨.
  //   }
  //   // ───────────────────────────────────────────────────────────────
  //   // (4) 사용자 정보가 없는 경우 (user == null)
  //   //     - 이미 로그인 정보가 없거나, 이전 단계에서 로그아웃 처리된 상황
  //   //     - autoLogin == false이면 혹시 모를 세션(토큰) 흔적을 지우기 위해 다시 signOut()
  //   // ───────────────────────────────────────────────────────────────
  //   else {
  //     // 자동 로그인이 해제되어 있으면 로그인 세션 정리
  //     if (!autoLogin) {
  //       await FirebaseAuth.instance.signOut();
  //     }
  //   }
  //   // ----- 일반 이메일/비밀번호 로그인 및 회원가입 관련 자동 로그인 메서드 내용 끝

  // 자동 로그인을 확인하는 비동기 메서드
  // 앱 실행 시, 사용자가 이전에 '자동 로그인'을 체크했는지 확인하고
  // Firebase Authentication 상태와 함께 검증하여 로그인 유지 여부를 결정.
  void _checkAutoLogin(WidgetRef ref) async {
    // ───────────────────────────────────────────────────────────────
    // (1) SharedPreferences에서 autoLogin 값 가져오기
    //     - 사용자 기기에 'autoLogin' 여부(체크박스 상태) 저장되어 있는지 확인
    //     - 없으면 false(미체크)로 간주
    // ───────────────────────────────────────────────────────────────
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool autoLogin = prefs.getBool('autoLogin') ?? false;

    // ───────────────────────────────────────────────────────────────
    // (2) 현재 Firebase 인증 상태에서 사용자 정보를 가져옴
    //     - FirebaseAuth.instance.currentUser로 현재 로그인한 사용자 정보 확인
    //     - 로그아웃 상태이면 user == null
    // ───────────────────────────────────────────────────────────────
    User? user = FirebaseAuth.instance.currentUser;

    // ───────────────────────────────────────────────────────────────
    // (3) 사용자 정보가 있는 경우 (user != null)
    //     - 이미 Firebase 로그인 상태임
    // ───────────────────────────────────────────────────────────────
    if (user != null) {
      // 3-1) 'password' Provider인 경우 → 이메일/비밀번호 로그인 방식을 사용했는지 체크
      //      autoLogin이 false라면 => 자동 로그인 해제
      bool isEmailUser =
          user.providerData.any((info) => info.providerId == 'password');

      // ▸ 이메일/비밀번호 사용자이고(autoLogin == false)이면 로그아웃 처리
      if (isEmailUser && !autoLogin) {
        // 자동 로그인이 체크되어 있지 않으므로 로그인 해제
        await FirebaseAuth.instance.signOut();
        // 로그아웃 직후 user 상태를 null로 업데이트 (화면에 즉시 반영할 수 있도록)
        user = null;
      } else {
        // SNS 계정 로그인 사용자인 경우 추가 검증 필요
        // ───────────────────────────────────────────────────────────────
        // (3-2) Firestore 'users' 컬렉션에서 사용자 문서 확인
        //       - SNS 계정 로그인 사용자의 경우에도
        //         Firestore 'users' 컬렉션에 해당 문서가 없을 경우 로그아웃 처리
        // ───────────────────────────────────────────────────────────────
        // Firestore 사용자 문서 존재 여부 확인
        // 네이버 로그인 및 회원가입 시, 'users' 문서명이 사용자 UID이므로 해당 경우도 포함시킨 형태
        final userDocumentExists = await ref
            .read(userDocumentExistsProvider(user.email ?? user?.uid).future);

        // 사용자 문서가 존재하지 않으면 로그아웃 처리
        if (!userDocumentExists) {
          print('Firestore에서 사용자 문서를 찾을 수 없음: ${user.email}');
          await FirebaseAuth.instance.signOut();
          user = null;
        }
      }

      // SNS 계정 로그인 사용자의 경우는 3-1인 이메일/비밀번호 사용자이고(autoLogin == false)이면 로그아웃 처리에 해당하지 않는 경우이므로
      // else 경우에 해당하고 해당 경우는 따로 구현하지않아도 일반적으로 반대 케이스로 인식하므로 로그인 해제가 안되어서 자연스레 앱을 재실행해도 로그인 상태가 유지됨.
    }
    // ───────────────────────────────────────────────────────────────
    // (4) 사용자 정보가 없는 경우 (user == null)
    //     - 이미 로그인 정보가 없거나, 이전 단계에서 로그아웃 처리된 상황
    //     - autoLogin == false이면 혹시 모를 세션(토큰) 흔적을 지우기 위해 다시 signOut()
    // ───────────────────────────────────────────────────────────────
    else {
      // 자동 로그인이 해제되어 있으면 로그인 세션 정리
      if (!autoLogin) {
        await FirebaseAuth.instance.signOut();
      }
    }

    // 1.75초 후에 다음 동작을 수행.
    Timer(Duration(milliseconds: 1750), () {
      Navigator.of(context).pushReplacement(
        // MaterialPageRoute(builder: (_) => HomeMainScreen()),
        MaterialPageRoute(builder: (_) => HomeMainScreen()),
      ); // 홈 화면으로 이동

      // if (autoLogin) {
      //   // autoLogin이 true인 경우 HomeMainScreen으로 이동.
      //   Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(builder: (_) => HomeMainScreen()),
      //   );
      // } else {
      //   // autoLogin이 false인 경우 플랫폼에 따라 분기
      //   // IOS 플랫폼은 IOS 화면으로 이동
      //   if (Platform.isIOS) {
      //     Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(builder: (_) => EasyLoginIosScreen()),
      //     );
      //     // AOS 플랫폼은 AOS 화면으로 이동
      //   } else if (Platform.isAndroid) {
      //     Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(builder: (_) => EasyLoginAosScreen()),
      //     );
      //   } else {
      //     // 기타 플랫폼은 기본적으로 AOS 화면으로 이동
      //     Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(builder: (_) => EasyLoginAosScreen()),
      //     );
      //   }
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    // // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려하지 않은 사이즈 시작 부분
    // // 스플래시 화면 UI 구성
    // return Scaffold(
    //   body: Stack(
    //     // Stack 위젯을 사용하여 요소들을 겹쳐서 배치함.
    //       children: <Widget>[
    //       Positioned.fill(
    //         child: Image.asset(
    //         'asset/img/misc/splash_image/couture_splash2_bg_img.png', // 이미지 파일 경로를 설정.
    //         fit: BoxFit.cover, // 이미지 비율을 유지하면서 화면에 맞게 조절
    //       ),
    //      ),
    //     ],
    //   ),
    // );
    // // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려하지 않은 사이즈 끝 부분

    // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려한 사이즈 시작 부분
    // 스플래시 화면 UI 구성
    return Scaffold(
      // body에 바로 CustomScrollView 배치
      body: CustomScrollView(
        slivers: [
          // SliverFillRemaining:
          // 남은 화면 전체를 차지하기 때문에
          // 배경 이미지를 상하단까지 완전히 채울 수 있음.
          SliverFillRemaining(
            // 만약 스크롤이 필요 없고, 화면을 '정적으로' 채우기만 한다면
            // hasScrollBody: false 를 사용해서 내용이 화면보다 작을 때 스크롤이 비활성화되도록 할 수 있음
            hasScrollBody: false,
            child: Stack(
              children: [
                // 배경 이미지
                Positioned.fill(
                  child: Image.asset(
                    'asset/img/misc/splash_image/couture_splash2_bg_img.png',
                    // 이미지 파일 경로를 설정.
                    fit: BoxFit.cover, // 이미지 비율을 유지하면서 화면에 맞게 조절
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려한 사이즈 시작 부분
  }
}
