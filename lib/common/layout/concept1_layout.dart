import 'package:flutter/cupertino.dart'; // iOS 스타일의 디자인 위젯 사용을 위한 패키지
import 'package:flutter/material.dart'; // Material 디자인 위젯 사용을 위한 패키지
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod를 사용한 상태 관리를 위한 패키지
import '../../common/view/common_parts.dart'; // 앱 전반에 걸쳐 재사용 가능한 공통 UI 컴포넌트들
import '../provider/state_provider.dart'; // 상태 관리를 위한 state provider들을 정의한 파일

// 컨셉1 카테고리 레이아웃을 구성하는 위젯. Riverpod의 ConsumerWidget을 상속받아 상태 관리가 가능함.
class Concept1Layout extends ConsumerWidget {
  const Concept1Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 선택된 탭 인덱스를 관찰하고 반응하는 Riverpod Provider
    final tabIndex = ref.watch(tabIndexProvider);

    // 상단 탭 바(카테고리 리스트) 구성 및 사용자의 선택에 따른 동작 정의
    Widget topBarList = buildTopBarList(context, (index) {
      // 여기서 각 카테고리별 사용자의 탭(선택)에 따른 동작을 정의합니다.
      // 예시: Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLayout()));
      // 다른 카테고리별 레이아웃으로 이동하는 로직을 구현할 수 있습니다.
    });

    return Scaffold(
      // GlobalKey의 사용이 제거되었습니다. 필요하지 않은 경우 제거를 권장합니다.
      appBar: buildCommonAppBar('컨셉1', context), // 공통 AppBar 구성. '컨셉1' 제목으로 설정.
      body: Column(
        children: [
          Container(
            height: 100, // 상단 탭 바의 높이 설정
            child: topBarList, // 상단 탭 바 리스트를 표시하는 위젯
          ),
          Expanded(
            // '컨셉1 옷 내용'을 표시. 실제 애플리케이션에서는 여기에 컨텐츠를 동적으로 로드하여 표시
            child: Center(child: Text('컨셉1 옷 내용')),
          ),
        ],
      ),
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref, context), // 하단 네비게이션 바 구성, 상태 관리를 위해 context 전달
      drawer: buildCommonDrawer(context), // 드로어 메뉴 구성, 사용자 정보 등을 표시할 수 있음
    );
  }
}
