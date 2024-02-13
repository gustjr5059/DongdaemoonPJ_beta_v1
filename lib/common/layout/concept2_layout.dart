import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/layout/category1_layout.dart';
import '../../common/provider/tab_index_provider.dart';
import '../../common/view/common_parts.dart';


class Concept2Layout extends ConsumerWidget {
  const Concept2Layout({Key? key}) : super(key: key);

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

    return Scaffold(
      // GlobalKey 제거
      // key: scaffoldKey, // common_parts.dart에서 정의한 GlobalKey 사용
      appBar: buildCommonAppBar('컨셉2', context),// common_parts.dart의 AppBar 재사용
      // body에 카테고리 리스트 포함
      body: Column(
        children: [
          // common_parts.dart의 buildTopBarList 함수를 호출하여 TopBar 카테고리 리스트를 생성합니다.
          Container(
            height: 50, // TopBar의 높이 설정
            child: buildTopBarList(context), // TopBar 리스트를 생성하는 함수 호출
          ),
          Expanded(
            child: Center(child: Text('컨셉2 옷 내용')),
          ),
        ],
      ),
      // buildCommonBottomNavigationBar 함수 호출 시 context 인자 추가
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref, context),
      drawer: buildCommonDrawer(context),
    );
  }
}