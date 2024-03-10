import 'package:flutter/cupertino.dart'; // iOS 스타일 위젯을 사용하기 위한 패키지
import 'package:flutter/material.dart'; // Material 디자인 위젯을 사용하기 위한 패키지
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위한 Riverpod 패키지
import '../../common/provider/state_provider.dart'; // 앱 전반의 상태 관리를 위한 provider 파일
import '../../common/view/common_parts.dart'; // 앱에서 재사용 가능한 공통 UI 컴포넌트 파일

// '악세서리' 카테고리 레이아웃을 나타내는 위젯, Riverpod의 ConsumerWidget을 상속받음
class AccessoryLayout extends ConsumerWidget {
  const AccessoryLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 선택된 탭 인덱스를 관찰하는 Riverpod Provider
    final tabIndex = ref.watch(tabIndexProvider);

    // 상단 탭 바(카테고리 리스트) 구성 및 사용자 선택에 따른 동작 정의
    Widget topBarList = buildTopBarList(context, (index) {
      // 여기서 각 카테고리별 탭했을 때의 동작을 정의합니다.
      // 예시: Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLayout()));
      // 사용자가 선택한 카테고리에 따라 다른 레이아웃으로 이동하는 로직을 구현할 수 있습니다.
    });

    return Scaffold(
      appBar: buildCommonAppBar('악세서리', context), // '악세서리' 제목의 AppBar, 공통 UI 컴포넌트 재사용
      body: Column(
        children: [
          Container(
            height: 100, // 상단 탭 바의 높이 설정
            child: topBarList, // 상단 탭 바 리스트를 보여주는 위젯
          ),
          Expanded(
            // '악세서리 내용'을 표시하는 부분. 실제 애플리케이션에서는 여기에 컨텐츠를 동적으로 로드하여 표시
            child: Center(child: Text('악세서리 내용')),
          ),
        ],
      ),
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref, context), // 하단 네비게이션 바 구성, 상태 관리를 위해 context 전달
      drawer: buildCommonDrawer(context), // 드로어 메뉴 구성, 사용자 정보 등을 표시할 수 있음
    );
  }
}
