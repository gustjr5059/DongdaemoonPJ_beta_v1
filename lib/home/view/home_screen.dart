import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/layout/category1_layout.dart';
import '../../common/provider/tab_index_provider.dart';
import '../../common/view/common_parts.dart';

// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PageController pageController = PageController();
    final List<String> categories = List.generate(12, (index) => '카테고리 ${index + 1}');

    void onCategoryTap(int index) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Category1Layout()));
    }

    return Scaffold(
      appBar: buildCommonAppBar('홈', context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // common_parts.dart에서 가져온 카테고리 리스트
            buildCategoryList(onCategoryTap),
            // 사용자 정의 화살표 버튼이 있는 PageView
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: pageController,
                    itemCount: 5,
                    itemBuilder: (context, index) => Center(child: Text('페이지 ${index + 1}', style: TextStyle(fontSize: 24))),
                  ),
                  Positioned(
                    left: 10,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        if (pageController.page != 0) {
                          pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                        }
                      },
                    ),
                  ),
                  Positioned(
                    right: 10,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        if (pageController.page != 4) {
                          pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            // 동적으로 생성된 카테고리 버튼
            Wrap(
              children: List.generate(categories.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: OutlinedButton(
                    onPressed: () => onCategoryTap(index),
                    child: Text(categories[index]),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            Text('선택된 카테고리의 콘텐츠', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      // buildCommonBottomNavigationBar 함수 호출 시 context 인자 추가
      bottomNavigationBar: buildCommonBottomNavigationBar(ref.watch(tabIndexProvider), ref, context),
      drawer: buildCommonDrawer(context),
    );
  }
}




