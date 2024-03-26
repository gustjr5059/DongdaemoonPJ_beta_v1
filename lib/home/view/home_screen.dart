import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod를 통한 상태 관리를 위해 import 합니다.
import '../../common/provider/common_future_provider.dart';
import '../../common/provider/common_state_provider.dart'; // 공통 상태 관리자 파일
import '../../common/view/common_parts.dart'; // 공통 UI 컴포넌트 모듈
// 아래 import된 파일들은 각 카테고리 별로 상세 페이지를 보여주기 위한 레이아웃 파일들입니다.
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

// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
// GlobalKey 대신 로컬 context를 사용하는 방법에 대해 설명하는 클래스
// HomeScreen 클래스는 ConsumerWidget을 상속받아, Riverpod를 통한 상태 관리를 지원함.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    // 초기 페이지 설정을 위해 ref를 사용합니다.
    pageController = PageController(
      initialPage: ref.read(currentPageProvider), // 초기 페이지 설정
    );

    // 생명주기 감지를 위해 현재 State 객체를 옵저버에 추가합니다.
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  Widget build(BuildContext context) {
    // // PageController는 페이지뷰를 컨트롤함.
    // final PageController pageController = PageController(
    //   initialPage: ref.read(currentPageProvider), // 초기 페이지 설정
    // );

    // home_screen.dart에 표시된 카테고리 12개 변수 정의
    // 홈 화면에 표시될 카테고리 목록
    final homeCategories = [
      "전체", "상의", "하의", "아우터",
      "니트", "원피스", "티셔츠", "블라우스",
      "스커트", "팬츠", "언더웨어", "악세서리"
    ];

    // common_part.dart에 정의한 buildHorizontalDocumentsList에 불러올 문서 ID 리스트 변수 정의
    // 문서 ID 목록을 정의함, 실제 애플리케이션에서는 이런 ID를 사용하여 데이터베이스에서 정보를 가져올 수 있음.
    List<String> docIds1 = ['alpha', 'apple', 'cat'];
    List<String> docIds2 = ['flutter', 'github', 'samsung'];

    // ------ common_parts.dart 내 buildTopBarList, onTopBarTap 재사용하여 TopBar 구현 내용 시작
    // 탭을 탭했을 때 호출될 함수
    // 상단 탭 바를 구성하고 탭 선택 시 동작을 정의하는 함수
    void onTopBarTap(int index) {
      // 여기서 탭 선택 로직을 구현할 수 있습니다.
      // 예를 들어, ref.read(selectedTabIndexProvider.state).state = index; 와 같이 사용할 수 있습니다.
    }

    // 상단 탭 바를 구성하는 리스트 뷰를 가져오는 위젯
    Widget topBarList = buildTopBarList(context, onTopBarTap);

    // ------ common_parts.dart 내 buildTopBarList, onTopBarTap 재사용하여 TopBar 구현 내용 끝

    WidgetsBinding.instance.addObserver(this); // 생명주기 감지를 위해 옵저버 추가

// 배너 이미지를 보여주는 페이지뷰 섹션
    Widget buildBannerPageViewSection() {
      // bannerImagesProvider를 사용하여 Firestore로부터 이미지 URL 리스트를 가져옴.
      // 이 비동기 작업은 FutureProvider에 의해 관리되며, 데이터가 준비되면 위젯을 다시 빌드함.
      final asyncBannerImages = ref.watch(bannerImagesProvider);

      // asyncBannerImages의 상태에 따라 다른 위젯을 반환함.
      return asyncBannerImages.when(
        data: (List<String> imageUrls) {
          // 이미지 URL 리스트를 성공적으로 가져온 경우,
          // 페이지 뷰를 구성하는 `buildBannerPageView` 함수를 호출함.
          // 이 함수는 페이지뷰 위젯과, 각 페이지를 구성하는 아이템 빌더, 현재 페이지 인덱스를 관리하기 위한 provider 등을 인자로 받음.
          return buildBannerPageView(
            ref: ref, // Riverpod의 WidgetRef를 통해 상태를 관리함.
            pageController: pageController, // 페이지 컨트롤러를 전달하여 페이지간 전환을 관리함.
            itemCount: imageUrls.length, // 이미지 URL 리스트의 길이를 전달하여 전체 페이지 수를 정의함.
            itemBuilder: (context, index) => Image.network(imageUrls[index], fit: BoxFit.cover), // 각 페이지를 구성할 위젯을 정의하고, 여기서는 네트워크 이미지를 사용함.
            currentPageProvider: currentPageProvider, // 현재 페이지 인덱스를 관리하기 위한 StateProvider를 전달함.
          );
        },
        loading: () => Center(child: CircularProgressIndicator()), // 데이터 로딩 중에는 로딩 인디케이터를 표시함.
        error: (error, stack) => Center(child: Text('이미지를 불러오는 중 오류가 발생했습니다.')), // 오류 발생 시 오류 메시지를 표시함.
      );
    }



    // 5초마다 페이지를 자동으로 전환하는 기능을 구현함.
    startAutoScrollTimer(
      ref: ref, // 이렇게 ref를 전달합니다.
      pageController: pageController,
      itemCount: 3, // 총 페이지 수 설정
      currentPageProvider: currentPageProvider,
    );


    // ------ home_screen.dart에만 사용되는 onHomeCategoryTap 내용 시작
    // 홈 카테고리 버튼이 탭되었을 때 호출되는 함수
    void onHomeCategoryTap(int index) {
      // 여기서 각 카테고리에 맞는 페이지로 이동하는 로직을 구현
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
    // 앱의 주요 화면을 구성하는 Scaffold 위젯
    return Scaffold(
      appBar: buildCommonAppBar('홈', context), // 공통으로 사용되는 AppBar를 가져옴.
      body: SingleChildScrollView(
        child: Column(
          children: [
            // common_parts.dart에서 가져온 카테고리 리스트
            // 상단 탭 바
            // 여기에 Container보다 SizedBox 사용을 더 선호함(알아두기)
            SizedBox(
              // 상단 탭 바를 표시
              height: 100, // TopBar의 높이 설정
              child: topBarList, // 수정된 buildTopBarList 함수 호출
            ),
            // 화살표 버튼이 있는 PageView
            SizedBox(
            // 페이지 뷰 섹션을 표시
              height: 200, // 페이지 뷰의 높이 설정
              // child: pageViewSection, // pageViewSection 호출
              child: buildBannerPageViewSection(), // 배너 페이지뷰 위젯 사용
            ),
            // 카테고리 12개를 표현한 homeCategoryButtonsGrid 버튼 뷰
            homeCategoryButtonsGrid(
              // 카테고리 버튼 그리드를 표시
              homeCategories,
              onHomeCategoryTap,
            ), // homeCategoryButtonsGrid
            // 높이 20으로 간격 설정
            SizedBox(height: 20), // 간격을 추가
            // 이벤트 상품 섹션 제목을 표시
            Text('🛍️ 이벤트 상품',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            // Firestore 문서 데이터를 가로로 배열하여 표시하는 부분
            buildHorizontalDocumentsList(ref, docIds1, context),// 'alpha', 'apple', 'cat' 관련 데이터를 가로로 한줄 표시되도록 정렬하여 구현
            buildHorizontalDocumentsList(ref, docIds2, context),// 'flutter', 'github', 'samsung' 관련 데이터를 가로로 한줄 표시되도록 정렬하여 구현
          ],
        ),
      ),
      // buildCommonBottomNavigationBar 함수 호출 시 context 인자 추가
      bottomNavigationBar: buildCommonBottomNavigationBar(
          ref.watch(tabIndexProvider), ref, context), // 공통으로 사용되는 하단 네비게이션 바를 가져옴.
      drawer: buildCommonDrawer(context), // 드로어 메뉴를 추가함.
    ); // ------ 화면구성 끝
  }

  // home_Screen.dart에서 구현된 카테고리 12개를 선으로 구획나누고 표시한 부분 관련 위젯
  // 카테고리 버튼들을 그리드 형태로 표시하는 위젯
  Widget homeCategoryButtonsGrid(List<String> homeCategories, void Function(int) onHomeCategoryTap) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // 스크롤이 불필요한 곳에서의 스크롤 방지
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 한 줄에 표시될 아이템의 개수
        crossAxisSpacing: 1, // 가로 간격
        mainAxisSpacing: 1, // 세로 간격
        childAspectRatio: 3, // 아이템의 가로 세로 비율
      ),
      itemCount: homeCategories.length, // 전체 카테고리 수
      itemBuilder: (context, index) {
        // 각 카테고리에 해당하는 버튼을 생성
        return GridTile(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey), // 테두리 색상 설정
            ),
            child: TextButton(
              onPressed: () => onHomeCategoryTap(index), // 버튼 탭 시 처리
              child: Text(homeCategories[index], style: TextStyle(color: Colors.black)), // 카테고리 이름 표시
            ),
          ),
        );
      },
    );
  }
// ------ home_screen.dart 내부에서만 사용되는 위젯 내용 끝

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // 앱이 다시 활성화될 때 실행할 로직
      // 마지막 페이지 번호를 기반으로 PageController를 업데이트할 수 있음
      // 이 예시에서는 구체적인 PageController 업데이트 로직을 추가하지 않았음
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 옵저버 제거
    super.dispose();
  }

}



