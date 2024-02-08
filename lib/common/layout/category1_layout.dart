import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/tab_index_provider.dart';
import '../view/common_parts.dart';

class Category1Layout extends ConsumerWidget {
  const Category1Layout({Key? key}) : super(key: key);

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
      key: scaffoldKey,
      appBar: buildCommonAppBar('카테고리 1'),
      // body에 카테고리 리스트 포함
      body: Column(
        children: [
          // 카테고리 리스트 추가
          buildCategoryList(onCategoryTap),
          Expanded(
            child: Center(child: Text('Category 1 Content')),
          ),
        ],
      ),
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref),
      drawer: buildCommonDrawer(context),
    );
  }
}