import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/layout/category1_layout.dart';
import '../../common/provider/tab_index_provider.dart';
import '../../common/view/common_parts.dart';
import '../layout/accessory_layout.dart';
import '../layout/all_layout.dart';
import '../layout/blouse_layout.dart';
import '../layout/bottom_layout.dart';
import '../layout/neat_layout.dart';
import '../layout/onepiece_layout.dart';
import '../layout/outer_layout.dart';
import '../layout/pants_layout.dart';
import '../layout/shirt_layout.dart';
import '../layout/skirt_layout.dart';
import '../layout/top_layout.dart';
import '../layout/underwear_layout.dart';

// 상태 관리를 위한 StateProvider 정의
final currentPageProvider = StateProvider<int>((ref) => 0);

// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PageController pageController = PageController();
    final categories = [
      "전체", "상의", "하의", "아우터",
      "니트", "원피스", "티셔츠", "블라우스",
      "스커트", "팬츠", "언더웨어", "악세서리"
    ];
    final currentPage = ref.watch(currentPageProvider);

    // 카테고리 선택 시 실행될 함수
    void _onCategorySelected(int index) {
      // Navigator를 사용하여 Category1Layout으로 화면 전환
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Category1Layout()),
      );
    }

    void onCategoryTap(int index) {
      switch (index) {
        case 0: // "전체" 버튼에 대응하는 경우
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AllLayout()));
          break;
        case 1: // "상의" 버튼에 대응하는 경우
          Navigator.push(context, MaterialPageRoute(builder: (context) => const TopLayout()));
          break;
        case 2: // "하의" 버튼에 대응하는 경우
          Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomLayout()));
          break;
        case 3: // "아우터" 버튼에 대응하는 경우
          Navigator.push(context, MaterialPageRoute(builder: (context) => const OuterLayout()));
          break;
        case 4: // "니트" 버튼에 대응하는 경우
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NeatLayout()));
          break;
        case 5: // "원피스" 버튼에 대응하는 경우
          Navigator.push(context, MaterialPageRoute(builder: (context) => const OnepieceLayout()));
          break;
        case 6: // "티셔츠" 버튼에 대응하는 경우
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ShirtLayout()));
          break;
        case 7: // "블라우스" 버튼에 대응하는 경우
          Navigator.push(context, MaterialPageRoute(builder: (context) => const BlouseLayout()));
          break;
        case 8: // "스커트" 버튼에 대응하는 경우
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SkirtLayout()));
          break;
        case 9: // "팬츠" 버튼에 대응하는 경우
          Navigator.push(context, MaterialPageRoute(builder: (context) => const PantsLayout()));
          break;
        case 10: // "언더웨어" 버튼에 대응하는 경우
          Navigator.push(context, MaterialPageRoute(builder: (context) => const UnderwearLayout()));
          break;
        case 11: // "악세서리" 버튼에 대응하는 경우
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AccessoryLayout()));
          break;
      }
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
              child: pageViewWithArrows(pageController, ref, currentPage),
            ),
            categoryButtonsGrid(categories, onCategoryTap),
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

  Widget pageViewWithArrows(PageController pageController, WidgetRef ref, int currentPage) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
          controller: pageController,
          itemCount: 5,
          onPageChanged: (index) => ref.read(currentPageProvider.notifier).state = index,
          itemBuilder: (context, index) => Center(child: Text('페이지 ${index + 1}', style: TextStyle(fontSize: 24))),
        ),
        arrowButton(
          Icons.arrow_back_ios,
          currentPage > 0,
          currentPage > 0 ? () => pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut) : null,
        ),
        arrowButton(
          Icons.arrow_forward_ios,
          currentPage < 4,
          currentPage < 4 ? () => pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut) : null,
        ),
      ],
    );
  }


  Widget arrowButton(IconData icon, bool isActive, VoidCallback? onPressed) {
    return Positioned(
      left: icon == Icons.arrow_back_ios ? 10 : null,
      right: icon == Icons.arrow_forward_ios ? 10 : null,
      child: IconButton(
        icon: Icon(icon),
        color: isActive ? Colors.black : Colors.grey,
        onPressed: onPressed,
      ),
    );
  }


  Widget categoryButtonsGrid(List<String> categories, void Function(int) onCategoryTap) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: 3,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return GridTile(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: TextButton(
              onPressed: () => onCategoryTap(index),
              child: Text(categories[index], style: TextStyle(color: Colors.black)),
            ),
          ),
        );
      },
    );
  }
}




