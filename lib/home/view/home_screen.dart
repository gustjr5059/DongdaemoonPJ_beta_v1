import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod를 사용한 상태 관리를 위한 import
import '../../common/provider/common_future_provider.dart';
import '../../common/provider/common_state_provider.dart'; // 공통 상태 관리 파일
import '../../common/view/common_parts.dart'; // 공통 UI 컴포넌트 파일
// 아래는 각 카테고리별 상세 페이지를 위한 레이아웃 파일들
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
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용 권장
// GlobalKey 사용 시 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// HomeScreen 클래스는 ConsumerWidget 상속, Riverpod를 통한 상태 관리 지원
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// _HomeScreenState 클래스 시작
class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {
  late PageController pageController;
  late BannerAutoScrollClass bannerAutoScrollClass;
  int bannerImageCount = 3; // 배너 이미지 총 개수 저장 변수

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // PageController를 초기 페이지로 설정함.
    pageController = PageController(initialPage: 0);

    // 배너의 자동 스크롤 기능을 초기화함.
    bannerAutoScrollClass = BannerAutoScrollClass(
      pageController: pageController,
      currentPageProvider: currentPageProvider,
      itemCount: bannerImageCount,
    );

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        // 사용자가 로그인한 경우, 페이지 인덱스를 초기화하지 않음.
        // 이는 사용자가 앱 내에서 로그아웃하고 재로그인하는 경우를 대비한 것
      } else {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정함.
        ref.read(currentPageProvider.notifier).state = 0;
        pageController.jumpToPage(0);
      }
    });

    // WidgetsBindingObserver를 추가하여 앱의 생명주기를 관리함.
    WidgetsBinding.instance.addObserver(this); // 생명주기 옵저버 등록

    // 배너 데이터 로드가 완료된 후 자동 스크롤 시작
    Future.delayed(Duration.zero, () {
      bannerAutoScrollClass.startAutoScroll();
    });
  }
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 끝 (앱 실행 생명주기 관련 함수)

  // ------ 페이지 뷰 자동 스크롤 타이머 함수인 startAutoScrollTimer() 시작 및 정지 관린 함수인
  // didChangeAppLifecycleState 함수 관련 구현 내용 시작
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // 앱이 다시 활성화되면 자동 스크롤 재시작
      bannerAutoScrollClass.startAutoScroll();
    } else if (state == AppLifecycleState.paused) {
      // 앱이 백그라운드로 이동하면 자동 스크롤 중지
      bannerAutoScrollClass.stopAutoScroll();
    }
  }
  // ------ 페이지 뷰 자동 스크롤 타이머 함수인 startAutoScrollTimer() 시작 및 정지 관린 함수인
  // didChangeAppLifecycleState 함수 관련 구현 내용 끝

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void dispose() {
    // 앱 종료 시 리소스를 해제함.
    WidgetsBinding.instance.removeObserver(this);
    pageController.dispose();
    bannerAutoScrollClass.stopAutoScroll();
    super.dispose();
  }
  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 끝 (앱 실행 생명주기 관련 함수)
  // ------ 앱 실행 생명주기 관리 관련 함수 끝

  // ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 시작
  @override
  Widget build(BuildContext context) {

    // home_screen.dart에 표시된 카테고리 12개 변수 정의
    // 홈 화면에 표시될 카테고리 목록
    final homeCategories = [
      "전체", "상의", "하의", "아우터",
      "니트", "원피스", "티셔츠", "블라우스",
      "스커트", "팬츠", "언더웨어", "악세서리"
    ];

    // 문서 ID 리스트, 실제 앱에서는 DB에서 정보를 가져올 때 사용
    // common_part.dart에 정의한 buildHorizontalDocumentsList에 불러올 문서 ID 리스트 변수 정의
    // 문서 ID 목록을 정의함, 실제 애플리케이션에서는 이런 ID를 사용하여 데이터베이스에서 정보를 가져올 수 있음.
    List<String> docIds1 = ['alpha', 'apple', 'cat'];
    List<String> docIds2 = ['flutter', 'github', 'samsung'];

    // ------ common_parts.dart 내 buildTopBarList, onTopBarTap 재사용하여 TopBar 구현 내용 시작
    // 탭을 탭했을 때 호출될 함수
    // 상단 탭 바를 구성하고 탭 선택 시 동작을 정의하는 함수
    // (common_parts.dart의 onTopBarTap 함수를 불러와 생성자를 만든 후 사용하는 개념이라 void인 함수는 함수명을 그대로 사용해야 함)
    void onTopBarTap(int index) {
    }
    // 상단 탭 바를 구성하는 리스트 뷰를 가져오는 위젯
    // (common_parts.dart의 buildTopBarList 재사용 후 topBarList 위젯으로 재정의)
    Widget topBarList = buildTopBarList(context, onTopBarTap);
    // ------ common_parts.dart 내 buildTopBarList, onTopBarTap 재사용하여 TopBar 구현 내용 끝

    // ------ common_parts.dart 내 buildBannerPageView 재사용 후 buildBannerPageViewSection 위젯으로 재정의하고,
    // banner 페이지 뷰의 조건에 따른 동작 구현 내용 시작
    // 배너 이미지를 보여주는 페이지뷰 섹션
    Widget buildBannerPageViewSection() {
      // bannerImagesProvider를 사용하여 Firestore로부터 이미지 URL 리스트를 가져옴.
      // 이 비동기 작업은 FutureProvider에 의해 관리되며, 데이터가 준비되면 위젯을 다시 빌드함.
      final asyncBannerImages = ref.watch(bannerImagesProvider);

      // asyncBannerImages의 상태에 따라 다른 위젯을 반환함.
      return asyncBannerImages.when(
        // 데이터 상태인 경우, 이미지 URL 리스트를 바탕으로 페이지뷰를 구성함.
        data: (List<String> imageUrls) {
          // 이미지 URL 리스트를 성공적으로 가져온 경우,
          // 페이지 뷰를 구성하는 `buildBannerPageView` 함수를 호출함.
          // 이 함수는 페이지뷰 위젯과, 각 페이지를 구성하는 아이템 빌더, 현재 페이지 인덱스를 관리하기 위한 provider 등을 인자로 받음.
          return buildBannerPageView(
            ref: ref, // Riverpod의 WidgetRef를 통해 상태를 관리함.
            pageController: pageController, // 페이지 컨트롤러를 전달하여 페이지간 전환을 관리함.
            itemCount: imageUrls.length, // 페이지 개수를 정의합니다. 이미지 리스트의 길이에 해당함.
            itemBuilder: (context, index) => BannerImage(
              imageUrl: imageUrls[index], // 이미지 URL을 통해 각 페이지에 배너 이미지를 구성함.
            ),
            currentPageProvider: currentPageProvider, // 현재 페이지 인덱스를 관리하기 위한 provider
            context: context, // 현재의 BuildContext를 전달함.
          );
        },
        loading: () => Center(child: CircularProgressIndicator()), // 데이터 로딩 중에는 로딩 인디케이터를 표시함.
        error: (error, stack) => Center(child: Text('이미지를 불러오는 중 오류가 발생했습니다.')), // 오류 발생 시 오류 메시지를 표시함.
      );
    }
    // ------ common_parts.dart 내 buildBannerPageView 재사용 후 buildBannerPageViewSection 위젯으로 재정의하고,
    // banner 페이지 뷰의 조건에 따른 동작 구현 내용 끝

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
            SizedBox(height: 20), // 간격을 추가
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
    );
    // ------ 화면구성 끝
  }
  // ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 끝

  // ------ home_screen.dart 내부에서만 사용되는 위젯 내용 시작
  // ------ home_Screen.dart에서 구현된 카테고리 12개를 선으로 구획나누고 표시한 부분 관련 위젯 구현 내용 시작
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
  // ------ home_Screen.dart에서 구현된 카테고리 12개를 선으로 구획나누고 표시한 부분 관련 위젯 구현 내용 끝
  // ------ home_screen.dart 내부에서만 사용되는 위젯 내용 끝
}
// _HomeScreenState 클래스 끝


