
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../cart/view/cart_screen.dart';
import '../../home/layout/home_body_parts_layout.dart';
import '../../home/view/home_screen.dart';
import '../../order/view/order_screen.dart';
import '../../user/view/login_screen.dart';
import '../../user/view/profile_screen.dart';
import '../const/colors.dart';
import '../provider/common_state_provider.dart';


// ------ SliverAppBar buildCommonSliverAppBar 함수 시작
// ------ 기존 buildCommonAppBar 위젯 내용과 동일하며,
// 플러터 기본 SliverAppBar 위젯을 활용하여 앱 바의 상태 동적 UI 구현에 수월한 부분을 정의해서 해당 위젯을 바로 다른 화면에 구현하여
// 기본 SliverAppBar의 드로워화면 토글 옵션을 삭제하는 등의 작업이 필요없는 방식-현재는 이슈가 있어 사용 안함..
// 향후 이슈해결하여 해당 앱 바로 변경작업 진행할 예정!!

// void onTopBarTap(int index) {}
//
// // 공통 SliverAppBar 생성 함수
// SliverAppBar buildCommonSliverAppBar({
//   required BuildContext context,
//   required String title,
//   required bool pageBackButton, // 이전 화면으로 돌아가는 버튼 표시 여부
// }) {
//   // 조건에 따라 leadingWidget 결정
//   Widget leadingWidget;
//   if (pageBackButton) {
//     leadingWidget = IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () => Navigator.of(context).pop(),
//     );
//   } else {
//     leadingWidget = Builder(
//       builder: (BuildContext context) {
//         return IconButton(
//           icon: Icon(Icons.menu),
//           onPressed: () => Scaffold.of(context).openDrawer(),
//         );
//       },
//     );
//   }
//
//   return SliverAppBar(
//     floating: true,
//     pinned: true,
//     expandedHeight: 120.0, // 로고 이미지를 포함할 충분한 높이 제공
//     flexibleSpace: LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         return FlexibleSpaceBar(
//           centerTitle: true,
//           titlePadding: EdgeInsets.zero, // 로고 이미지의 상하좌우 패딩을 0으로 설정
//           title: constraints.biggest.height == kToolbarHeight + MediaQuery.of(context).padding.top ? null // 축소된 상태에서는 타이틀을 표시하지 않음
//             : Container(
//               alignment: Alignment.center,
//               height: kToolbarHeight,
//               child: Image.asset(
//                 'asset/img/misc/logo_image.jpg',
//                 fit: BoxFit.scaleDown, // 로고가 AppBar 높이에 맞게 조정됨
//               ),
//             ),
//           );
//       },
//     ),
//     backgroundColor: Colors.white,
//     leading: leadingWidget,
//     actions: [
//       IconButton(
//         icon: Icon(Icons.search),
//         onPressed: () {
//           // 검색 기능 구현
//         },
//       ),
//     ],
//     bottom: PreferredSize(
//       preferredSize: Size.fromHeight(60.0), // 여기에 탭 바의 높이를 설정합니다.
//       child: Container(
//         color: Colors.white,
//         alignment: Alignment.center,
//         child: buildTopBarList(context, onTopBarTap), // 상단 탭바 리스트를 구성하는 함수
//       ),
//     ),
//   );
// }
// ------ SliverAppBar buildCommonSliverAppBar 함수 끝

// ------ AppBar 생성 함수 내용 구현 시작
// 상단 탭 바 생성 함수
AppBar buildCommonAppBar({
  required BuildContext context, // BuildContext를 필수 인자로 받고, 각종 위젯에서 위치 정보 등을 제공받음.
  required String title, // AppBar에 표시될 제목을 문자열로 받음.
  bool pageBackButton = false, // 이전 화면으로 돌아가는 버튼을 표시할지 여부를 결정하는 플래그, 기본값은 false암.
}) {
  // AppBar의 'leading' 위젯을 조건에 따라 설정함.
  Widget? leadingWidget; // 앱 바 왼쪽 상단에 표시될 위젯을 저장할 변수임.
  if (pageBackButton) {
    // pageBackButton이 true일 경우, 이전 화면으로 돌아가는 버튼을 생성함.
    leadingWidget = IconButton(
      icon: Icon(Icons.arrow_back), // 뒤로 가기 아이콘을 사용함.
      onPressed: () => Navigator.of(context).pop(), // 버튼을 누르면 현재 화면을 종료하고 이전 화면으로 돌아감.
    );
  } else {
    // pageBackButton이 false일 경우, 드로어를 여는 버튼을 생성함.
    leadingWidget = Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: Icon(Icons.menu), // 메뉴 아이콘을 사용함.
          onPressed: () => Scaffold.of(context).openDrawer(), // 버튼을 누르면 드로어 메뉴를 열게됨.
        );
      },
    );
  }
  return AppBar(
    backgroundColor: BUTTON_COLOR, // AppBar 색상 설정
    title: Container(
      height: kToolbarHeight, // AppBar의 높이를 kToolbarHeight로 설정하여 로고 이미지의 높이를 제한함.
      child: Image.asset(
        'asset/img/misc/logo_image.jpg', // 로고 이미지 파일 경로를 지정함.
        fit: BoxFit.scaleDown, // 이미지가 컨테이너 안에서 원본 비율을 유지하며 축소되도록 설정함.
      ),
    ),
    centerTitle: true, // 제목을 AppBar의 중앙에 위치시킴.
    leading: leadingWidget, // 위에서 설정한 leading 위젯을 AppBar의 leading 위치에 배치함.
    actions: [
      IconButton(
        icon: Icon(Icons.search), // 검색 아이콘을 사용함.
        onPressed: () {
          // 검색 기능을 여기에 구현할 수 있음.
        },
      ),
    ],
  );
}
// ------ AppBar 생성 함수 내용 구현 끝

// ------ buildTopBarList 위젯 내용 구현 시작
// TopBar의 카테고리 리스트를 생성하는 함수를 재작성
// TopBar의 카테고리 리스트 생성 함수. 각 카테고리를 탭했을 때의 동작을 정의함.
Widget buildTopBarList(BuildContext context, void Function(int) onTopBarTap) {
  final List<Map<String, String>> topBarCategories = [
    {"type": "text", "data": "전체"},
    {"type": "text", "data": "신상"},
    {"type": "text", "data": "최고"},
    {"type": "text", "data": "할인"},
    {"type": "text", "data": "봄"},
    {"type": "text", "data": "여름"},
    {"type": "text", "data": "가을"},
    {"type": "text", "data": "겨울"},
  ];

  // 각 카테고리를 탭했을 때 실행될 함수. 카테고리에 따라 다른 페이지로 이동함.
  return SizedBox(
    height: 60, // 적절한 높이 설정
    child: ListView.builder(
      scrollDirection: Axis.horizontal, // 리스트뷰의 스크롤 방향을 가로로 설정함.
      itemCount: topBarCategories.length, // 리스트뷰에 표시될 항목의 개수를 상단 바 카테고리 배열의 길이로 설정함.
      itemBuilder: (context, index) {
        final category = topBarCategories[index]["data"] ?? ""; // 안전하게 문자열 추출

        return GestureDetector(
          onTap: () => onTopBarTap(index), // 해당 인덱스의 카테고리를 탭했을 때 실행될 함수
          child: Container( // 수정된 부분: Padding을 Container로 변경
            alignment: Alignment.center, // Container 내부 내용을 중앙 정렬
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              category,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: INPUT_BORDER_COLOR, // 글자 본연의 색상
                shadows: [
                  Shadow( // 하단 그림자
                    offset: Offset(0, 2),
                    color: LOGO_COLOR,
                    blurRadius: 0,
                  ),
                  Shadow( // 오른쪽 그림자
                    offset: Offset(2, 0),
                    color: LOGO_COLOR,
                    blurRadius: 0,
                  ),
                  Shadow( // 상단 그림자
                    offset: Offset(0, -2),
                    color: LOGO_COLOR,
                    blurRadius: 0,
                  ),
                  Shadow( // 왼쪽 그림자
                    offset: Offset(-2, 0),
                    color: LOGO_COLOR,
                    blurRadius: 0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
// ------ buildTopBarList 위젯 내용 구현 끝

// ------ buildCommonBottomNavigationBar 위젯 내용 구현 시작
// BottomNavigationBar 생성 함수
// 공통 BottomNavigationBar 생성 함수. 선택된 항목에 따라 다른 화면으로 이동하도록 구현함.
Widget buildCommonBottomNavigationBar(int selectedIndex, WidgetRef ref, BuildContext context) {
  // 하단 네비게이션 바 위젯을 생성하고 반환
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed, // 네비게이션 바의 유형을 고정된 유형으로 설정
    currentIndex: selectedIndex, // 현재 선택된 인덱스
    onTap: (index) {
      if(ref.read(tabIndexProvider) == index) {
        return; // 이미 선택된 탭이면 아무 동작도 하지 않음
      }
      // 탭이 클릭되었을 때 실행할 로직
      // 선택된 인덱스에 따라 상태 업데이트
      ref.read(tabIndexProvider.notifier).state = index; // 선택된 탭의 인덱스를 상태 관리자에 저장
      resetCategoryView(ref); // 카테고리 뷰를 초기화하는 함수를 호출
      // 화면 전환 로직
      switch (index) { // 클릭된 탭의 인덱스에 따라 각기 다른 화면으로 이동
        case 0:
        // '홈' 화면으로 이동
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeMainScreen()));
          break;
        case 1:
        // '장바구니' 화면으로 이동
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => CartScreen()));
          break;
        case 2:
        // '주문' 화면으로 이동
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderScreen()));
          break;
        case 3:
        // '마이페이지' 화면으로 이동
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ProfileScreen()));
          break;
      }
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'), // '홈' 탭 아이콘 및 라벨
      BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: '장바구니'), // '장바구니' 탭 아이콘 및 라벨
      BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: '주문'), // '주문' 탭 아이콘 및 라벨
      BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: '마이페이지'), // '마이페이지' 탭 아이콘 및 라벨
    ],
    selectedItemColor: DRAWER_COLOR, // 선택된 아이템의 색상
    unselectedItemColor: BODY_TEXT_COLOR, // 선택되지 않은 아이템의 색상
    selectedFontSize: 10, // 선택된 아이템의 폰트 크기
    unselectedFontSize: 10, // 선택되지 않은 아이템의 폰트 크기
  );
}
// ------ buildCommonBottomNavigationBar 위젯 내용 구현 끝

// ------ buildCommonDrawer 위젯 내용 구현 시작
// 드로워 생성 함수
// 공통 Drawer 생성 함수. 사용자 이메일을 표시하고 로그아웃 등의 메뉴 항목을 포함함.
Widget buildCommonDrawer(BuildContext context) {
  // FirebaseAuth에서 현재 로그인한 사용자의 이메일을 가져옴. 로그인하지 않았다면 'No Email'이라는 기본 문자열을 표시함.
  final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'No Email';

  // Drawer 위젯을 반환합니다. 이 위젯은 앱의 사이드 메뉴를 구현하는 데 사용.
  return Drawer(
    // ListView를 자식으로 사용하며, 드로어 내용물을 스크롤 가능하게 함.
    child: ListView(
      padding: EdgeInsets.zero, // ListView의 패딩을 0으로 설정하여 상단 여백을 제거함.
      children: <Widget>[
        // 드로어의 헤더 부분을 구성합니다. 헤더는 사용자 정보를 표시하는 영역.
        DrawerHeader(
          decoration: BoxDecoration(color: DRAWER_COLOR), // 헤더 배경색을 설정함.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 세로 방향으로 중앙 정렬
            crossAxisAlignment: CrossAxisAlignment.start, // 가로 방향으로 왼쪽 정렬
            children: [
              // 사용자가 소속된 동대문이라는 텍스트를 큰 글자로 표시함.
              Text('Dongdaemoon', style: TextStyle(color: Colors.white, fontSize: 24)),
              SizedBox(height: 10), // 텍스트 사이의 간격을 위한 SizedBox
              // 현재 로그인한 사용자의 이메일을 표시함.
              Text(userEmail, style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () async {
            // 로그아웃 후 로그인 화면으로 이동
            await FirebaseAuth.instance.signOut(); // 로그아웃 처리
            // (context) -> (_) 로 변경 : 매개변수를 정의해야 하지만 실제로 내부 로직에서 사용하지 않을 때 표기방법
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
          },
        ),

        ListTile(
          // ListTile의 앞부분에는 네이버 카페 로고 이미지를 표시함.
          leading: Image.asset('asset/img/misc/drawer_img/navercafe.logo.png', width: 24),
          title: Text('네이버 카페'),
          // 사용자가 ListTile을 탭할 때 실행될 코드, 네이버 카페의 URL로 이동하는 코드
          onTap: () async {
            const url = 'https://cafe.naver.com/ottbayo';
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            }
          },
        ),
        ListTile(
          // ListTile의 앞부분에는 유튜브 로고 이미지를 표시함.
          leading: Image.asset('asset/img/misc/drawer_img/youtube.logo.png', width: 24),
          title: Text('유튜브'),
          // 사용자가 ListTile을 탭할 때 실행될 코드, 유튜브의 URL로 이동하는 코드
          onTap: () async {
            const url = 'https://www.youtube.com/@OTTBAYO';
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            }
          },
        ),
        ListTile(
          // ListTile의 앞부분에는 인스타그램 로고 이미지를 표시함.
          leading: Image.asset('asset/img/misc/drawer_img/instagram.logo.png', width: 24),
          title: Text('인스타그램'),
          // 사용자가 ListTile을 탭할 때 실행될 코드, 인스타그램의 URL로 이동하는 코드
          onTap: () async {
            const url = 'https://www.instagram.com/ottbayo';
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            }
          },
        ),
        ListTile(
          // ListTile의 앞부분에는 카카오 로고 이미지를 표시함.
          leading: Image.asset('asset/img/misc/drawer_img/kakao.logo.png', width: 24),
          title: Text('카카오'),
          // 사용자가 ListTile을 탭할 때 실행될 코드, 카카오의 URL로 이동하는 코드
          onTap: () async {
            const url = 'https://pf.kakao.com/_xjVrbG';
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            }
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
// ------ buildCommonDrawer 위젯 내용 구현 끝