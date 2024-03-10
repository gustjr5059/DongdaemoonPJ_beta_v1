import 'package:flutter/cupertino.dart'; // iOS 스타일 위젯 사용을 위한 패키지
import 'package:flutter/material.dart'; // Material 디자인 위젯 사용을 위한 패키지
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위한 Riverpod 패키지
import '../../common/view/common_parts.dart'; // 앱 전반에서 재사용 가능한 공통 UI 컴포넌트
import '../provider/state_provider.dart'; // 상태 관리를 위한 state provider

// '컨셉2' 카테고리의 레이아웃을 구성하는 위젯. Riverpod의 ConsumerWidget을 활용하여 상태 관리 기능을 제공.
class Concept2Layout extends ConsumerWidget {
  const Concept2Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 선택된 탭의 인덱스를 관찰하는 Riverpod Provider
    final tabIndex = ref.watch(tabIndexProvider);

    // 상단 탭 바(카테고리 리스트) 구성 및 사용자의 선택에 따른 동작 정의
    Widget topBarList = buildTopBarList(context, (index) {
      // 여기서 각 카테고리별 사용자의 탭(선택)에 따른 동작을 정의합니다.
      // 예시: Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLayout()));
      // 다른 카테고리별 레이아웃으로 이동하는 로직을 구현할 수 있습니다.
    });

    return Scaffold(
      // Scaffold의 key 설정은 제거되었습니다.
      appBar: buildCommonAppBar('컨셉2', context), // '컨셉2' 제목의 AppBar, common_parts.dart에서 재사용
      body: Column(
        children: [
          Container(
            height: 100, // 상단 탭 바의 높이 설정
            child: topBarList, // 상단 탭 바 리스트를 보여주는 위젯
          ),
          Expanded(
            // '컨셉2 옷 내용'을 표시하는 부분. 실제 애플리케이션에서는 여기에 컨텐츠를 동적으로 로드하여 표시
            child: Center(child: Text('컨셉2 옷 내용')),
          ),
        ],
      ),
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref, context), // 하단 네비게이션 바 구성, 상태 관리를 위해 context 전달
      drawer: buildCommonDrawer(context), // 드로어 메뉴 구성, 사용자 정보 등을 표시할 수 있음
    );
  }
}
