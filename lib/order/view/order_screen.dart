
import 'package:flutter/cupertino.dart'; // iOS 스타일 위젯을 사용하기 위한 패키지
import 'package:flutter/material.dart'; // Material 디자인 위젯을 사용하기 위한 패키지
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위한 Riverpod 패키지
import '../../common/layout/common_exception_parts_of_body_layout.dart';
import '../../common/provider/common_state_provider.dart'; // 앱 전반에 걸친 상태 관리를 위한 state provider


// 주문 페이지를 구성하는 위젯, Riverpod의 ConsumerWidget을 상속 받음
class OrderScreen extends ConsumerWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 탭의 인덱스를 관찰하고 있는 Riverpod Provider
    final tabIndex = ref.watch(tabIndexProvider);

    // 상단 탭 바 클릭 했을 시, 동작을 넣어야하는데 현재는 비어있음
    void onTopBarTap(int index) {}

    // 상단의 카테고리 탭 바를 구성하고, 각 탭 선택 시 수행될 동작을 정의
    Widget topBarList = buildTopBarList(context, onTopBarTap, currentTabProvider);

    return Scaffold(
      appBar: buildCommonAppBar(context: context, title: '주문', pageBackButton: false), // 'ORDER' 페이지의 공통 앱 바
      body: Column(
        children: [
          Container(
            height: 100, // 상단 탭 바의 높이 설정
            child: topBarList, // 상단 탭 바 리스트 표시
          ),
          Expanded(
            // 'ORDER 내용' 표시 영역. 실제 데이터나 콘텐츠가 로드되어 표시되는 영역
            child: Center(child: Text('ORDER 내용')),
          ),
        ],
      ),
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref, context), // 페이지 이동을 위한 하단 네비게이션 바
      drawer: buildCommonDrawer(context), // 사용자 정보 및 추가 메뉴 항목을 제공하는 드로어
    );
  }
}
