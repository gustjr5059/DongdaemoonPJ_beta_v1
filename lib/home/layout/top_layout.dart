import 'package:flutter/cupertino.dart'; // iOS 스타일 위젯을 사용하기 위해 포함된 패키지
import 'package:flutter/material.dart'; // Material 디자인 위젯을 사용하기 위해 포함된 패키지
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위한 Riverpod 패키지
import '../../common/provider/state_provider.dart'; // 앱 전반에서 사용하는 상태 관리자
import '../../common/view/common_parts.dart'; // 재사용 가능한 UI 컴포넌트를 모아둔 파일

// 상의 카테고리 페이지를 구성하는 위젯. Riverpod의 ConsumerWidget을 상속 받아 상태 관리 기능을 사용
class TopLayout extends ConsumerWidget {
  const TopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(tabIndexProvider); // 현재 탭 인덱스 상태를 구독

    // 상단의 카테고리 리스트 탭 바를 생성하고, 각 탭 선택 시 발생하는 이벤트를 정의
    Widget topBarList = buildTopBarList(context, (index) {
      // 카테고리별 동작을 정의하는 곳. 예: Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLayout()));
      // 실제 앱 내에서 카테고리별 페이지 이동 등의 동작을 구현
    });

    return Scaffold(
      appBar: buildCommonAppBar('상의', context), // 공통으로 사용되는 앱 바를 '상의' 제목으로 생성
      body: Column(
        children: [
          Container(
            height: 100, // 탑바의 높이 설정
            child: topBarList, // 상단 탭 바를 보여주는 위젯
          ),
          Expanded(
            // '상의 옷 내용'을 표시하는 부분. 실제 데이터나 콘텐츠가 로드되어 표시되는 영역
            child: Center(child: Text('상의 옷 내용')),
          ),
        ],
      ),
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref, context), // 하단 네비게이션 바 구성, 현재 선택된 탭에 따라 상태 변경
      drawer: buildCommonDrawer(context), // 드로어 메뉴, 사용자 정보 및 기타 메뉴 항목을 포함
    );
  }
}
