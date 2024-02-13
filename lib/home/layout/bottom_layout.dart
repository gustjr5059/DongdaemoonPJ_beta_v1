import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/provider/tab_index_provider.dart';
import '../../common/view/common_parts.dart';


class BottomLayout extends ConsumerWidget {
  const BottomLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(tabIndexProvider);

    // // 카테고리를 탭했을 때 실행할 함수
    // void onCategoryTap(int index) {
    //   // 여기에서 원하는 동작을 구현합니다.
    //   // 예: 특정 카테고리 페이지로 이동
    //   print("카테고리 ${index+1} 선택됨");
    // }

    // // 카테고리 선택 시 실행될 함수
    // void _onCategorySelected(int index) {
    //   // Navigator를 사용하여 Category1Layout으로 화면 전환
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => const Category1Layout()),
    //   );
    // }

    // TopBar 카테고리 리스트를 생성하고 사용자가 탭했을 때의 동작을 정의합니다.
    Widget topBarList = buildTopBarList(context, (index) {
      // 각 카테고리 인덱스에 따른 동작을 여기에 정의합니다.
      // 예: Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLayout()));
      // 위에서 정의한 switch-case 로직을 여기에 포함시킵니다.
    });

    return Scaffold(
      // GlobalKey 제거
      // key: scaffoldKey, // common_parts.dart에서 정의한 GlobalKey 사용
      appBar: buildCommonAppBar('하의', context),// common_parts.dart의 AppBar 재사용
      // body에 카테고리 리스트 포함
      body: Column(
        children: [
          // common_parts.dart에서 가져온 카테고리 리스트
          Container(
            height: 100, // TopBar의 높이 설정
            child: topBarList, // 수정된 buildTopBarList 함수 호출
          ),
          Expanded(
            child: Center(child: Text('하의 옷 내용')),
          ),
        ],
      ),
      // buildCommonBottomNavigationBar 함수 호출 시 context 인자 추가
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref, context),
      drawer: buildCommonDrawer(context),
    );
  }
}