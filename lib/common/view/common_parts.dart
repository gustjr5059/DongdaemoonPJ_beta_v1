import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 데이터베이스 사용을 위한 패키지
import 'package:dongdaemoon_beta_v1/user/view/login_screen.dart'; // 로그인 화면
import 'package:flutter/material.dart'; // Flutter의 기본 디자인 위젯
import 'package:firebase_auth/firebase_auth.dart'; // Firebase 인증 사용을 위한 패키지
import '../../cart/view/cart_screen.dart'; // 장바구니 화면
import '../../home/view/home_screen.dart'; // 홈 화면
import '../../order/view/order_screen.dart'; // 주문 화면
import '../../product/view/detail_product_screen.dart'; // 제품 상세 화면
import '../../user/view/profile_screen.dart'; // 사용자 프로필 화면
import '../const/colors.dart'; // 앱 전반에 사용되는 색상 상수
import '../layout/best_layout.dart'; // BEST 카테고리 레이아웃
import '../layout/concept1_layout.dart'; // 컨셉1 카테고리 레이아웃
import '../layout/concept2_layout.dart'; // 컨셉2 카테고리 레이아웃
import '../layout/concept3_layout.dart'; // 컨셉3 카테고리 레이아웃
import '../layout/couple_layout.dart'; // 커플룩 카테고리 레이아웃
import '../layout/new_layout.dart'; // NEW 카테고리 레이아웃
import '../layout/sale_layout.dart'; // SALE 카테고리 레이아웃
import '../layout/season_layout.dart'; // 시즌룩 카테고리 레이아웃
import '../provider/future_provider.dart'; // 비동기 데이터 로드를 위한 FutureProvider
import '../provider/state_provider.dart'; // 상태 관리를 위한 StateProvider
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리 라이브러리

// GlobalKey 사용 제거
// final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

// AppBar 생성 함수에서 GlobalKey 사용 제거
// 공통 AppBar 생성 함수. GlobalKey 사용을 제거하고 context를 활용하여 Drawer를 열 수 있게 함.
AppBar buildCommonAppBar(String title, BuildContext context) {
  return AppBar(
    title: Text(title),
    leading: Builder( // Builder 위젯을 사용하여 context를 전달함.
      builder: (BuildContext context) {
        return IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(), // 현재 context의 Scaffold를 찾아서 Drawer를 열음.
        );
      },
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          // 검색 기능 구현 위치
        },
      ),
    ],
  );
}

// TopBar의 카테고리 리스트를 생성하는 함수를 재작성
// TopBar의 카테고리 리스트 생성 함수. 각 카테고리를 탭했을 때의 동작을 정의함.
Widget buildTopBarList(BuildContext context, void Function(int) onTopBarTap) {
  final List<String> topBarCategories = [
    "NEW", "BEST", "SALE", "시즌룩", "커플룩", "컨셉1", "컨셉2", "컨셉3"
  ];

  void onTopBarTap(int index) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLayout()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const BestLayout()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SaleLayout()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SeasonLayout()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CoupleLayout()));
        break;
      case 5:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Concept1Layout()));
        break;
      case 6:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Concept2Layout()));
        break;
      case 7:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Concept3Layout()));
        break;
    }
  }

  // 각 카테고리를 탭했을 때 실행될 함수. 카테고리에 따라 다른 페이지로 이동함.
  return SizedBox(
    height: 60, // 적절한 높이 설정
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: topBarCategories.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onTopBarTap(index),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(child: Text(topBarCategories[index])),
          ),
        );
      },
    ),
  );
}



// BottomNavigationBar 생성 함수
// 공통 BottomNavigationBar 생성 함수. 선택된 항목에 따라 다른 화면으로 이동하도록 구현함.
Widget buildCommonBottomNavigationBar(int selectedIndex, WidgetRef ref, BuildContext context) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: selectedIndex,
    onTap: (index) {
      // 상태 업데이트
      // 선택된 인덱스에 따라 상태 업데이트 및 화면 전환 로직
      ref.read(tabIndexProvider.notifier).state = index;
      // 화면 전환 로직
      switch (index) {
        case 0:
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
          break;
        case 1:
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => CartScreen()));
          break;
        case 2:
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderScreen()));
          break;
        case 3:
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ProfileScreen()));
          break;
      }
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
      BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: '장바구니'),
      BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: '주문'),
      BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: '마이페이지'),
    ],
    selectedItemColor: PRIMARY_COLOR,
    unselectedItemColor: BODY_TEXT_COLOR,
    selectedFontSize: 10,
    unselectedFontSize: 10,
  );
}

// 드로워 생성 함수
// 공통 Drawer 생성 함수. 사용자 이메일을 표시하고 로그아웃 등의 메뉴 항목을 포함함.
Widget buildCommonDrawer(BuildContext context) {
  final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'No Email'; // 현재 로그인한 사용자의 이메일 표시
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(color: DRAWER_COLOR),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dongdaemoon', style: TextStyle(color: Colors.white, fontSize: 24)),
              SizedBox(height: 10),
              Text(userEmail, style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () async {
            await FirebaseAuth.instance.signOut(); // 로그아웃 처리
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text('Profile'),
        ),
        ListTile(
          leading: Icon(Icons.group),
          title: Text('Communities'),
        ),
        ListTile(
          leading: Icon(Icons.message),
          title: Text('Q&A'),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
        ),
        // 다른 메뉴 아이템 추가 가능
      ],
    ),
  );
}

// PageView와 화살표 버튼을 포함하는 위젯
// 사용자가 페이지를 넘길 수 있도록 함.
Widget pageViewWithArrows(BuildContext context, PageController pageController, WidgetRef ref, StateProvider<int> currentPageProvider) {
  int currentPage = ref.watch(currentPageProvider);
  return Stack(
    alignment: Alignment.center,
    children: [
      PageView.builder(
        controller: pageController,
        itemCount: 5, // 총 페이지 수
        onPageChanged: (index) => ref.read(currentPageProvider.notifier).state = index, // 페이지 변경 시 상태 업데이트
        itemBuilder: (_, index) => Center(child: Text('페이지 ${index + 1}', style: TextStyle(fontSize: 24))),
      ),
      arrowButton(context, Icons.arrow_back_ios, currentPage > 0,
              () => pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut), currentPageProvider, ref),
      arrowButton(context, Icons.arrow_forward_ios, currentPage < 4,
              () => pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut), currentPageProvider, ref),
    ],
  );
}

// 화살표 버튼을 생성하는 위젯(함수)
// 화살표 버튼을 통해 사용자는 페이지를 앞뒤로 넘길 수 있음.
Widget arrowButton(BuildContext context, IconData icon, bool isActive, VoidCallback onPressed, StateProvider<int> currentPageProvider, WidgetRef ref) {
  return Positioned(
    left: icon == Icons.arrow_back_ios ? 10 : null, // 왼쪽 화살표 위치 조정
    right: icon == Icons.arrow_forward_ios ? 10 : null, // 오른쪽 화살표 위치 조정
    child: IconButton(
      icon: Icon(icon),
      color: isActive ? Colors.black : Colors.grey, // 활성화 여부에 따라 색상 변경
      onPressed: isActive ? onPressed : null, // 활성화 상태일 때만 동작
    ),
  );
}

// Firestore 데이터를 기반으로 세부 정보를 표시하는 위젯.
// 각 문서의 세부 정보를 UI에 표시함.
Widget buildFirestoreDetailDocument(WidgetRef ref, String docId, BuildContext context) {
  final asyncValue = ref.watch(firestoreDataProvider(docId)); // 비동기 데이터 로드

  return asyncValue.when(
    data: (DocumentSnapshot snapshot) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        // 데이터가 있는 경우 UI 구성
        return GestureDetector(
            onTap: () {
              // 모든 문서 클릭 시 DetailProductScreen으로 이동하되, 특정 문서에 대한 다른 동작이 필요한 경우 아래에 조건문 추가
              // Navigator를 사용하여 DetailProductScreen으로 이동하면서 문서 ID 전달
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailProductScreen(docId: docId)));
        },
      child: Container(
      width: 180,
      margin: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트와 색상 이미지들을 왼쪽으로 정렬
            children: [
              // 썸네일 이미지 표시
              if (data['thumbnails'] != null)
                Center( // thumbnails 이미지를 중앙에 배치
                  child: Image.network(data['thumbnails'], width: 90, fit: BoxFit.cover),// width: 90 : 전체인 Container 180 너비 중 thumbnails가 90 차지하도록 설정
                ),
              SizedBox(height: 10), // thumbnails와 clothes_color 사이의 간격 설정
              // 색상 이미지 URL 처리
              // 색상 정보 표시
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
                    : Container()) // 색상 정보가 없으면 표시하지 않음
                    .toList(),
              ),
              // 짧은 소개 텍스트
              if (data['brief_introduction'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    data['brief_introduction'],
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              // 원가 표시
              if (data['original_price'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "${data['original_price']}",
                    style: TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough),
                  ),
                ),
              // 할인가 표시
              if (data['discount_price'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    "${data['discount_price']}",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
        );
      } else {
        return Text("데이터 없음"); // 데이터가 없는 경우 표시
      }
    },
    loading: () => CircularProgressIndicator(), // 로딩 중 표시
    error: (error, stack) => Text("오류 발생: $error"), // 오류 발생 시 표시
  );
}

// buildHorizontalDocumentsList 함수에서 Document 클릭 시 동작 추가
// 가로로 스크롤 가능한 문서 리스트를 생성하는 함수. 문서 클릭 시 설정된 동작을 실행함.
Widget buildHorizontalDocumentsList(WidgetRef ref, List<String> documentIds, BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal, // 가로 스크롤 설정
    child: Row(
      children: documentIds.map((docId) => buildFirestoreDetailDocument(ref, docId, context)).toList(),
    ),
  );
}


