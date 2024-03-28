import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/provider/common_state_provider.dart';
import '../../common/view/common_parts.dart';
import 'login_screen.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(tabIndexProvider);
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 확인


    // TopBar 카테고리 리스트를 생성하고 사용자가 탭했을 때의 동작을 정의합니다.
    Widget topBarList = buildTopBarList(context, (index) {
      // 각 카테고리 인덱스에 따른 동작을 여기에 정의합니다.
      // 예: Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLayout()));
      // 위에서 정의한 switch-case 로직을 여기에 포함시킵니다.
    });

    // // 로그인 상태에 따라 버튼 텍스트 변경
    // String loginButtonText = user != null ? '로그아웃' : '로그인';

    return Scaffold(
      // GlobalKey 제거
      // key: scaffoldKey, // common_parts.dart에서 정의한 GlobalKey 사용
      appBar: buildCommonAppBar('PROFILE', context),// common_parts.dart의 AppBar 재사용
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