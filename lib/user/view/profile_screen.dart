import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/provider/state_provider.dart';
import '../../common/view/common_parts.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(tabIndexProvider);

    // 페이지 컨트롤러 초기화
    final PageController _controller = PageController();
    int _currentPage = 0;

    // 가상의 카테고리 데이터
    final List<String> categories = List.generate(12, (index) => '카테고리 ${index + 1}');
    String _selectedCategory = '카테고리 1';


    // TopBar 카테고리 리스트를 생성하고 사용자가 탭했을 때의 동작을 정의합니다.
    Widget topBarList = buildTopBarList(context, (index) {
      // 각 카테고리 인덱스에 따른 동작을 여기에 정의합니다.
      // 예: Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLayout()));
      // 위에서 정의한 switch-case 로직을 여기에 포함시킵니다.
    });

    return Scaffold(
      // GlobalKey 제거
      // key: scaffoldKey, // common_parts.dart에서 정의한 GlobalKey 사용
      appBar: buildCommonAppBar('마이페이지', context),// common_parts.dart의 AppBar 재사용
      body: SingleChildScrollView(
        child: Column(
          children: [
            // common_parts.dart에서 가져온 카테고리 리스트
            Container(
              height: 100, // TopBar의 높이 설정
              child: topBarList, // 수정된 buildTopBarList 함수 호출
            ),
            SizedBox(
              height: 200, // 페이지 뷰의 높이를 200으로 설정
              child: PageView.builder(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                itemCount: 5, // 총 페이지 수
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(child: Text('페이지 ${index + 1}', style: TextStyle(fontSize: 24))),
                  );
                },
              ),
            ),
            Container(
              height: 300, // 선택된 카테고리의 콘텐츠를 표시하는 영역
              child: Center(
                child: Text(_selectedCategory, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
      // buildCommonBottomNavigationBar 함수 호출 시 context 인자 추가
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref, context),
      drawer: buildCommonDrawer(context),
    );
  }
}