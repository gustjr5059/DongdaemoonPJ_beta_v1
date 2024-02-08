import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/const/colors.dart';
import '../../common/layout/category1_layout.dart';
import '../../common/provider/tab_index_provider.dart';
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

    // 카테고리 선택 시 실행될 함수
    void _onCategorySelected(int index) {
      // Navigator를 사용하여 Category1Layout으로 화면 전환
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Category1Layout()),
      );
    }

    return Scaffold(
      // GlobalKey 제거
      // key: scaffoldKey, // common_parts.dart에서 정의한 GlobalKey 사용
      appBar: buildCommonAppBar('프로필', context),// common_parts.dart의 AppBar 재사용
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildCategoryList(_onCategorySelected), // common_parts.dart에서 정의한 카테고리 리스트 사용
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