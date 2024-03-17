import 'package:flutter/cupertino.dart'; // Cupertino 디자인 시스템을 위한 Flutter 패키지
import 'package:flutter/material.dart'; // Material 디자인 시스템을 위한 Flutter 패키지
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리 라이브러리
import '../../common/provider/common_state_provider.dart'; // 공통 상태 관리자(provider) 파일
import '../../common/view/common_parts.dart'; // 공통 UI 컴포넌트가 정의된 파일

// 장바구니 화면을 나타내는 위젯, Riverpod의 ConsumerWidget을 활용하여 상태 관리
class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 선택된 탭 인덱스를 Riverpod를 통해 관찰
    final tabIndex = ref.watch(tabIndexProvider);

    // 상단 탭 바(카테고리 리스트)와 사용자의 탭 동작을 정의
    Widget topBarList = buildTopBarList(context, (index) {
      // 여기에 각 카테고리별 탭했을 때의 동작을 정의합니다.
      // 예시: Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLayout()));
      // 사용자가 탭했을 때 필요한 화면으로 전환되도록 로직을 구현합니다.
    });

    return Scaffold(
      // Scaffold의 key 설정은 제거되었습니다.
      appBar: buildCommonAppBar('CART', context), // 공통 AppBar 사용, 장바구니 화면 제목 설정
      body: Column(
        children: [
          Container(
            height: 100, // TopBar의 높이 설정
            child: topBarList, // 상단 탭 바(카테고리 리스트)를 표시
          ),
          Expanded(
            // 장바구니 내용을 여기에 구현
            // 현재는 단순 텍스트로 'CART 내용'을 중앙에 표시
            child: Center(child: Text('CART 내용')),
          ),
        ],
      ),
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref, context), // 하단 네비게이션 바
      drawer: buildCommonDrawer(context), // 공통 드로어 메뉴
    );
  }
}
