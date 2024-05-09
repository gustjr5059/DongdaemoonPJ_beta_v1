
// Firebase의 사용자 인증 기능을 제공하는 FirebaseAuth 패키지를 임포트합니다.
// FirebaseAuth는 Firebase 플랫폼의 일부로, 애플리케이션에 로그인 및 사용자 계정 관리 기능을 쉽게 추가할 수 있게 해줍니다.
// 이메일 및 비밀번호 인증, 소셜 미디어 로그인, 전화번호 인증 등 다양한 인증 방법을 지원합니다.
import 'package:firebase_auth/firebase_auth.dart';
// iOS 스타일의 인터페이스 요소를 사용하기 위해 Cupertino 디자인 패키지를 임포트합니다.
// 이 패키지는 iOS 사용자에게 친숙한 디자인 요소와 애니메이션을 제공하여 iOS 사용자 경험을 향상시킵니다.
import 'package:flutter/cupertino.dart';
// Flutter의 UI 구성 요소를 제공하는 Material 디자인 패키지를 임포트합니다.
// 이 패키지는 다양한 머티리얼 디자인 위젯을 포함하여 사용자 인터페이스를 효과적으로 구성할 수 있도록 도와줍니다.
import 'package:flutter/material.dart';
// 상태 관리를 위한 현대적인 라이브러리인 Riverpod를 임포트합니다.
// Riverpod는 애플리케이션의 상태를 효율적으로 관리하고, 상태 변화에 따라 UI를 자동으로 업데이트합니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// 애플리케이션에서 발생할 수 있는 예외 상황을 처리하기 위한 공통 UI 레이아웃 파일을 임포트합니다.
// 이 파일은 에러 발생 시 사용자에게 보여질 UI 컴포넌트를 정의하고, 일관된 오류 처리 경험을 제공합니다.
import '../../common/layout/common_exception_parts_of_body_layout.dart';
// 애플리케이션의 여러 부분에서 재사용될 수 있는 공통 상태 관리 로직을 포함하는 Provider 파일을 임포트합니다.
// 이 파일은 통일된 상태 관리 패턴을 제공하여 UI 개발을 효율적으로 할 수 있도록 돕습니다.
import '../../common/provider/common_state_provider.dart';
// 애플리케이션의 로그인 화면을 구성하는 파일을 임포트합니다.
// 이 화면은 사용자가 로그인을 진행할 수 있는 인터페이스를 제공하며, 사용자 인증 절차를 처리합니다.
import 'login_screen.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(tabIndexProvider);

    // 상단 탭 바 클릭 했을 시, 동작을 넣어야하는데 현재는 비어있음
    void onTopBarTap(int index) {}

    // 상단 탭 바(카테고리 리스트)와 사용자의 탭 동작을 정의
    Widget topBarList = buildTopBarList(context, onTopBarTap, currentTabProvider);

    return Scaffold(
      // GlobalKey 제거
      // key: scaffoldKey, // common_parts.dart에서 정의한 GlobalKey 사용
      appBar: buildCommonAppBar(context: context, title: '마이페이지', pageBackButton: false),// common_parts.dart의 AppBar 재사용
      // body에 카테고리 리스트 포함
      body: Column(
        children: [
          Container(height: 100, child: topBarList),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('PROFILE 내용'),
                  // 로그인/로그아웃 버튼
                  ElevatedButton(
                    onPressed: () async {
                      // 로그아웃 처리
                      await FirebaseAuth.instance.signOut();
                      // 페이지 인덱스를 0으로 초기화
                      ref.read(currentPageProvider.notifier).state = 0;
                        // 로그아웃 후 로그인 화면으로 이동
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                    child: Text('로그아웃'),
                  ),
                  // 항상 표시되는 회원가입 버튼
                  ElevatedButton(
                    onPressed: () {
                      // 회원가입 페이지로 이동
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginScreen())); // 여기에 회원가입 화면 경로 필요
                    },
                    child: Text('회원가입'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // buildCommonBottomNavigationBar 함수 호출 시 context 인자 추가
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref, context),
      drawer: buildCommonDrawer(context),
    );
  }
}