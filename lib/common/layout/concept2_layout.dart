import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/view/common_parts.dart';
import '../provider/state_provider.dart';


class Concept2Layout extends ConsumerWidget {
  const Concept2Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(tabIndexProvider);


    // TopBar 카테고리 리스트를 생성하고 사용자가 탭했을 때의 동작을 정의합니다.
    Widget topBarList = buildTopBarList(context, (index) {
      // 각 카테고리 인덱스에 따른 동작을 여기에 정의합니다.
      // 예: Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLayout()));
      // 위에서 정의한 switch-case 로직을 여기에 포함시킵니다.
    });

    return Scaffold(
      // GlobalKey 제거
      // key: scaffoldKey, // common_parts.dart에서 정의한 GlobalKey 사용
      appBar: buildCommonAppBar('컨셉2', context),// common_parts.dart의 AppBar 재사용
      // body에 카테고리 리스트 포함
      body: Column(
        children: [
          // common_parts.dart에서 가져온 카테고리 리스트
          Container(
            height: 100, // TopBar의 높이 설정
            child: topBarList, // 수정된 buildTopBarList 함수 호출
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