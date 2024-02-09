import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/provider/tab_index_provider.dart';
import '../../common/view/common_parts.dart';


class BlouseLayout extends ConsumerWidget {
  const BlouseLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(tabIndexProvider);

    // 카테고리를 탭했을 때 실행할 함수
    void onCategoryTap(int index) {
      // 여기에서 원하는 동작을 구현합니다.
      // 예: 특정 카테고리 페이지로 이동
      print("카테고리 ${index+1} 선택됨");
    }

    return Scaffold(
      // GlobalKey 제거
      // key: scaffoldKey, // common_parts.dart에서 정의한 GlobalKey 사용
      appBar: buildCommonAppBar('블라우스', context),// common_parts.dart의 AppBar 재사용
      // body에 카테고리 리스트 포함
      body: Column(
        children: [
          // 카테고리 리스트 추가
          buildCategoryList(onCategoryTap),
          Expanded(
            child: Center(child: Text('블라우스 옷 내용')),
          ),
        ],
      ),
      // buildCommonBottomNavigationBar 함수 호출 시 context 인자 추가
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref, context),
      drawer: buildCommonDrawer(context),
    );
  }
}