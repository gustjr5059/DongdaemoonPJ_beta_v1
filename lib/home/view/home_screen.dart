import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/provider/state_provider.dart';
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
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 사용을 위한 import


// 상태 관리를 위한 StateProvider 정의
final currentPageProvider = StateProvider<int>((ref) => 0);

// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PageController pageController = PageController();
    final homeCategories = [
      "전체", "상의", "하의", "아우터",
      "니트", "원피스", "티셔츠", "블라우스",
      "스커트", "팬츠", "언더웨어", "악세서리"
    ];
    // state_provider.dart에 정의한 currentPageProvider 활용한 현재 페이지 인덱스를 가져옴
    final currentPage = ref.watch(currentPageProvider);

    // state_provider.dart에 정의한 selectedTabIndexProvider 활용한 선택된 탭의 인덱스를 가져옴
    final selectedIndex = ref
        .watch(selectedTabIndexProvider.state)
        .state;

    // ------ common_parts.dart 내 buildTopBarList, onTopBarTap 재사용하여 TopBar 구현 내용 시작
    // 탭을 탭했을 때 호출될 함수
    void onTopBarTap(int index) {
      // 선택된 탭의 인덱스를 업데이트합니다.
      selectedIndex;
      // ref.read(selectedTabIndexProvider.state).state = index;
      // 필요한 경우 여기에서 추가적인 로직을 구현할 수 있습니다.
    }

    // 상단 탭 바를 구성하는 리스트 뷰를 가져옵니다.
    Widget topBarList = buildTopBarList(context, onTopBarTap);

    // ------ common_parts.dart 내 buildTopBarList, onTopBarTap 재사용하여 TopBar 구현 내용 끝

    // ------ home_screen.dart에만 사용되는 onHomeCategoryTap 내용 시작
    void onHomeCategoryTap(int index) {
      switch (index) {
        case 0: // "전체" 버튼에 대응하는 경우
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AllLayout()));
          break;
        case 1: // "상의" 버튼에 대응하는 경우
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TopLayout()));
          break;
        case 2: // "하의" 버튼에 대응하는 경우
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BottomLayout()));
          break;
        case 3: // "아우터" 버튼에 대응하는 경우
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const OuterLayout()));
          break;
        case 4: // "니트" 버튼에 대응하는 경우
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NeatLayout()));
          break;
        case 5: // "원피스" 버튼에 대응하는 경우
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const OnepieceLayout()));
          break;
        case 6: // "티셔츠" 버튼에 대응하는 경우
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ShirtLayout()));
          break;
        case 7: // "블라우스" 버튼에 대응하는 경우
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BlouseLayout()));
          break;
        case 8: // "스커트" 버튼에 대응하는 경우
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SkirtLayout()));
          break;
        case 9: // "팬츠" 버튼에 대응하는 경우
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PantsLayout()));
          break;
        case 10: // "언더웨어" 버튼에 대응하는 경우
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const UnderwearLayout()));
          break;
        case 11: // "악세서리" 버튼에 대응하는 경우
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AccessoryLayout()));
          break;
      }
    }
    // ------ home_screen.dart에만 사용되는 onHomeCategoryTap 내용 끝

    // ------ 화면 구성 시작
    return Scaffold(
      appBar: buildCommonAppBar('홈', context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // common_parts.dart에서 가져온 카테고리 리스트
            // 상단 탭 바
            // 여기에 Container보다 SizedBox 사용을 더 선호함(알아두기)
            SizedBox(
              height: 100, // TopBar의 높이 설정
              child: topBarList, // 수정된 buildTopBarList 함수 호출
            ),
            // 사용자 정의 화살표 버튼이 있는 PageView
            SizedBox(
              height: 200,
              child: pageViewWithArrows(pageController, ref, currentPage),
            ),
            homeCategoryButtonsGrid(homeCategories, onHomeCategoryTap),
            SizedBox(height: 20),
            Text('🛍️ 이벤트 상품',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            // Firestore 문서 데이터를 가로로 배열하여 표시하는 부분
            buildDocumentWidgetsRow(),
          ],
        ),
      ),
      // buildCommonBottomNavigationBar 함수 호출 시 context 인자 추가
      bottomNavigationBar: buildCommonBottomNavigationBar(
          ref.watch(tabIndexProvider), ref, context),
      drawer: buildCommonDrawer(context),
    ); // ------ 화면구성 끝
  }

  Widget buildDocumentWidgetsRow() {
    List<String> docNames = [
      'alpha',
      'apple',
      'cat'
    ]; // Firestore에서 불러올 문서 이름 목록
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: docNames.map((docName) => buildDocumentWidget(docName))
            .toList(),
      ),
    );
  }

  Widget buildDocumentWidget(String docName) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('item').doc(docName).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
            if (data != null) {
              //Container: 파이어스토어의 각 doc 데이터 한 묶음씩을 의미
              return Container(
                width: 180, // 각 문서의 UI 컨테이너 너비 설정
                margin: EdgeInsets.all(8), // 주변 여백 설정
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 텍스트와 색상 이미지들을 왼쪽으로 정렬
                  children: [
                    if (data['thumbnails'] != null)
                      Center( // thumbnails 이미지를 중앙에 배치
                        child: Image.network(data['thumbnails'], height: 100, fit: BoxFit.cover),
                      ),
                    // 색상 이미지 URL 처리
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start, // 색상 이미지들을 왼쪽으로 정렬
                      children: List.generate(5, (index) => index + 1) // 1부터 5까지의 숫자 생성
                          .map((i) => data['clothes_color$i'] != null
                          ? Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.network(
                          data['clothes_color$i'],
                          width: 13,
                          height: 13,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Container())
                          .toList(),
                    ),
                    if (data['brief_introduction'] != null)
                      Text(data['brief_introduction']),
                    if (data['original_price'] != null)
                      Text("원가: ${data['original_price']}"),
                    if (data['discount_price'] != null)
                      Text("할인가: ${data['discount_price']}"),
                  ],
                ),
              );
            } else {
              return Text('데이터가 없습니다.');
            }
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
        }
        return CircularProgressIndicator(); // 로딩 중 표시
      },
    );
  }



  // ------ home_screen.dart 내부에서만 사용되는 위젯 내용 시작

  Widget pageViewWithArrows(PageController pageController, WidgetRef ref,
      int currentPage) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
          controller: pageController,
          itemCount: 5,
          onPageChanged: (index) =>
          ref
              .read(currentPageProvider.notifier)
              .state = index,
          itemBuilder: (context, index) => Center(child: Text(
              '페이지 ${index + 1}', style: TextStyle(fontSize: 24))),
        ),
        arrowButton(
          Icons.arrow_back_ios,
          currentPage > 0,
          currentPage > 0 ? () => pageController.previousPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut) : null,
        ),
        arrowButton(
          Icons.arrow_forward_ios,
          currentPage < 4,
          currentPage < 4 ? () => pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut) : null,
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

  Widget homeCategoryButtonsGrid(List<String> homeCategories,
      void Function(int) onHomeCategoryTap) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: 3,
      ),
      itemCount: homeCategories.length,
      itemBuilder: (context, index) {
        return GridTile(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: TextButton(
              onPressed: () => onHomeCategoryTap(index),
              child: Text(
                  homeCategories[index], style: TextStyle(color: Colors.black)),
            ),
          ),
        );
      },
    );
  }
// ------ home_screen.dart 내부에서만 사용되는 위젯 내용 끝
}



