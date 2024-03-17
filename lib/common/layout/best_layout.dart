import 'package:flutter/cupertino.dart'; // iOS 스타일 위젯을 사용하기 위한 패키지
import 'package:flutter/material.dart'; // Material 디자인 위젯을 사용하기 위한 패키지
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리 라이브러리
import '../../common/view/common_parts.dart'; // 공통으로 사용되는 UI 컴포넌트 모음
import '../provider/common_state_provider.dart'; // 상태 관리를 위한 provider 파일

// 'BEST' 카테고리의 레이아웃을 나타내는 위젯, Riverpod의 ConsumerWidget을 상속받음
class BestLayout extends ConsumerWidget {
  const BestLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 선택된 탭의 인덱스를 관찰하는 Riverpod Provider
    final tabIndex = ref.watch(tabIndexProvider);

    // 상단 탭 바 카테고리 리스트와 사용자가 탭했을 때의 동작을 정의
    Widget topBarList = buildTopBarList(context, (index) {
      // 여기에 각 카테고리별 탭했을 때의 동작을 정의합니다.
      // 예시: Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLayout()));
      // 실제 앱에서는 각 카테고리별로 다른 페이지로 이동하도록 구현합니다.
    });

    return Scaffold(
      // Scaffold의 key는 이제 사용하지 않습니다.
      appBar: buildCommonAppBar('BEST', context), // 'BEST' 제목의 AppBar, common_parts.dart에서 재사용
      body: Column(
        children: [
          Container(
            height: 100, // 상단 탭 바의 높이 설정
            child: topBarList, // 상단 탭 바 리스트를 보여주는 위젯
          ),
          Expanded(
            // 'BEST 옷 내용' 표시, 실제 앱에서는 이 부분에 제품 목록 등이 표시됩니다.
            child: Center(child: Text('BEST 옷 내용')),
          ),
        ],
      ),
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref, context), // 하단 네비게이션 바, 상태 관리를 위해 context 전달
      drawer: buildCommonDrawer(context), // 드로어 메뉴, 사용자 이메일 등 정보 표시
    );
  }
}
