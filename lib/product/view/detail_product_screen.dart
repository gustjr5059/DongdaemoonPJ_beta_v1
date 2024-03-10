import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리를 위한 패키지
import '../../common/provider/state_provider.dart'; // 공통 상태 관리를 위한 provider 파일
import '../../common/view/common_parts.dart'; // 공통 UI 부품을 위한 파일


// 제품 상세 페이지를 나타내는 위젯 클래스, Riverpod의 ConsumerWidget을 상속받아 상태 관리 가능
class DetailProductScreen extends ConsumerWidget {
  const DetailProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 선택된 탭 인덱스를 관찰합니다.
    final tabIndex = ref.watch(tabIndexProvider);
    final PageController pageController = PageController(); // PageView 컨트롤을 위한 컨트롤러

    // TopBar 카테고리 리스트를 생성하고 사용자가 탭했을 때의 동작을 정의
    Widget topBarList = buildTopBarList(context, (index) {
      // 각 카테고리 인덱스에 따른 동작을 여기에 정의합니다.
      // 예: Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLayout()));
      // 위에서 정의한 switch-case 로직을 여기에 포함시킵니다.
    });

    // common_part.dart 재사용하여 pageViewWithArrows를 구현한 위젯
    // 페이지 뷰와 화살표 버튼을 포함하는 섹션, 공통 부품을 재사용
    Widget pageViewSection = pageViewWithArrows(context, pageController, ref, currentPageProvider);

    return Scaffold(
      // GlobalKey 제거
      // key: scaffoldKey, // common_parts.dart에서 정의한 GlobalKey 사용
      // 기존 GlobalKey의 사용은 제거됨.
      // 공통 AppBar 구성 함수 호출
      appBar: buildCommonAppBar('DETAIL PRODUCT', context),// common_parts.dart의 AppBar 재사용
      // body에 카테고리 리스트 포함
      body: Column(
        children: [
          // common_parts.dart에서 가져온 카테고리 리스트
          // 상단에 카테고리 리스트를 표시하는 컨테이너
          Container(
            height: 100, // TopBar의 높이 설정
            child: topBarList, // 수정된 buildTopBarList 함수 호출
          ),
          // 화살표 버튼이 있는 PageView 섹션
          SizedBox(height: 200, child: pageViewSection),
          // 제품 상세 내용을 표시할 부분
          Expanded(
            child: Center(child: Text('DETAIL PRODUCT 내용')), // 상세 내용 텍스트를 중앙에 표시
          ),
        ],
      ),
      // buildCommonBottomNavigationBar 함수 호출 시 context 인자 추가
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref, context),
      drawer: buildCommonDrawer(context), // 드로어 메뉴, 공통 구성 함수 호출
    );
  }
}