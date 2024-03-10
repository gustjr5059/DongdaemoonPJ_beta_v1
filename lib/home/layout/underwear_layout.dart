import 'package:flutter/cupertino.dart'; // iOS 스타일의 위젯 사용을 위한 패키지
import 'package:flutter/material.dart'; // Material 디자인 위젯 사용을 위한 패키지
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위한 Riverpod 패키지
import '../../common/provider/state_provider.dart'; // 앱 전반에 걸친 상태 관리를 위한 state provider
import '../../common/view/common_parts.dart'; // 공통으로 사용되는 UI 컴포넌트 모음

// '언더웨어' 카테고리의 레이아웃을 구성하는 위젯, Riverpod의 ConsumerWidget을 상속 받음
class UnderwearLayout extends ConsumerWidget {
  const UnderwearLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 탭의 인덱스를 관찰하고 있는 Riverpod Provider
    final tabIndex = ref.watch(tabIndexProvider);

    // 상단의 카테고리 탭 바를 구성하고, 각 탭 선택 시 수행될 동작을 정의
    Widget topBarList = buildTopBarList(context, (index) {
      // 카테고리별 이동 로직 정의. 예를 들어, Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLayout()))로 특정 카테고리 페이지로 이동 가능
    });

    return Scaffold(
      appBar: buildCommonAppBar('언더웨어', context), // '언더웨어' 페이지의 공통 앱 바
      body: Column(
        children: [
          Container(
            height: 100, // 상단 탭 바의 높이 설정
            child: topBarList, // 상단 탭 바 리스트 표시
          ),
          Expanded(
            // '언더웨어 옷 내용' 표시 영역. 실제 콘텐츠나 데이터에 따라 다르게 구성될 수 있음
            child: Center(child: Text('언더웨어 옷 내용')),
          ),
        ],
      ),
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref, context), // 페이지 이동을 위한 하단 네비게이션 바
      drawer: buildCommonDrawer(context), // 사용자 정보 및 추가 메뉴 항목을 제공하는 드로어
    );
  }
}
