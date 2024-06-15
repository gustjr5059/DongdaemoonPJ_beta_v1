
// Firebase의 사용자 인증 기능을 사용하기 위한 패키지를 임포트합니다.
import 'package:firebase_auth/firebase_auth.dart';
// Flutter의 기본 디자인과 인터페이스 요소들을 사용하기 위한 Material 패키지를 임포트합니다.
import 'package:flutter/material.dart';
// Riverpod 패키지를 사용한 상태 관리 기능을 추가합니다. Riverpod는 상태 관리를 위한 외부 패키지입니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// 외부 웹사이트나 애플리케이션 링크를 열기 위한 URL Launcher 패키지를 임포트합니다.
import 'package:url_launcher/url_launcher.dart';
// 애플리케이션 내 쇼핑 카트 화면 관련 파일을 임포트합니다.
import '../../cart/provider/cart_state_provider.dart';
import '../../cart/view/cart_screen.dart';
// 홈 화면의 레이아웃을 구성하는 파일을 임포트합니다.
import '../../home/layout/home_body_parts_layout.dart';
// 애플리케이션의 메인 홈 화면을 구성하는 파일을 임포트합니다.
import '../../home/provider/home_state_provider.dart';
import '../../home/view/home_screen.dart';
// 주문 관련 화면을 구현한 파일을 임포트합니다.
import '../../order/provider/order_state_provider.dart';
import '../../order/view/order_screen.dart';
// 사용자 로그인 화면을 구현한 파일을 임포트합니다.
import '../../product/layout/product_body_parts_layout.dart';
import '../../product/provider/product_future_provider.dart';
import '../../user/provider/profile_state_provider.dart';
import '../../user/view/login_screen.dart';
// 사용자 프로필 화면을 구현한 파일을 임포트합니다.
import '../../user/view/profile_screen.dart';
// 다양한 색상을 정의하는 파일을 임포트합니다.
import '../../wishlist/view/wishlist_screen.dart';
import '../const/colors.dart';
// 애플리케이션의 공통적인 상태 관리 로직을 포함하는 파일을 임포트합니다.
import '../provider/common_state_provider.dart';


// ------ AppBar 생성 함수 내용 구현 시작
// 공통 앱 바
AppBar buildCommonAppBar({
  required BuildContext context, // BuildContext를 필수 인자로 받고, 각종 위젯에서 위치 정보 등을 제공받음.
  required String title, // AppBar에 표시될 제목을 문자열로 받음.
  bool pageBackButton = false, // 이전 화면으로 돌아가는 버튼을 표시할지 여부를 결정하는 플래그, 기본값은 false암.
  int buttonCase = 1, // 버튼 구성을 선택하기 위한 매개변수 추가
}) {
  // AppBar의 'leading' 위젯을 조건에 따라 설정함.
  Widget? leadingWidget; // 앱 바 왼쪽 상단에 표시될 위젯을 저장할 변수임.
  if (pageBackButton) {
    // pageBackButton이 true일 경우, 이전 화면으로 돌아가는 버튼을 생성함.
    leadingWidget = IconButton(
      icon: Icon(Icons.arrow_back), // 뒤로 가기 아이콘을 사용함.
      onPressed: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); // 페이지 스택이 존재하면 이전 페이지로 돌아감.
        } else {
          // 이동할 수 없을 때 대비한 로직
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('이전 화면으로 이동할 수 없습니다.'))
          );
        }
      },
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

  // 버튼 구성을 결정하는 로직
  List<Widget> actions = [];
  switch (buttonCase) {
    case 1:
    // 케이스 1: 아무 내용도 없음
      actions.add(Container(width: 48)); // 빈 공간 추가
      break;
    case 2:
    // 케이스 2: 찜 목록 버튼만 노출
      actions.add(
        IconButton(
          icon: Icon(Icons.favorite, color: Colors.red),
          onPressed: () => navigateToScreen(context, WishlistMainScreen()), // 찜 목록 화면으로 이동
        ),
      );
      break;
    case 3:
    // 케이스 3: 찜 목록 버튼, 홈 버튼 노출
      actions.addAll([
        IconButton(
          icon: Icon(Icons.favorite, color: Colors.red),
          onPressed: () => navigateToScreen(context, WishlistMainScreen()), // 찜 목록 화면으로 이동
        ),
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () => navigateToScreen(context, HomeMainScreen()), // 홈 화면으로 이동
        ),
      ]);
      break;
    case 4:
    // 케이스 4: 찜 목록 버튼, 홈 버튼, 장바구니 버튼 노출
      actions.addAll([
        IconButton(
          icon: Icon(Icons.favorite, color: Colors.red),
          onPressed: () => navigateToScreen(context, WishlistMainScreen()), // 찜 목록 화면으로 이동
        ),
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () => navigateToScreen(context, HomeMainScreen()), // 홈 화면으로 이동
        ),
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () => navigateToScreen(context, CartMainScreen()), // 장바구니 화면으로 이동
        ),
      ]);
      break;
  }

  return AppBar(
    backgroundColor: BUTTON_COLOR, // AppBar 색상 설정
    title: Container(
      height: kToolbarHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  'asset/img/misc/logo_image.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    centerTitle: true, // 제목을 중앙에 위치시킴.
    leading: leadingWidget, // 설정된 leading 위젯을 사용함.
    actions: actions, // 설정된 동작 버튼들을 추가함.
  );
}
// ------ AppBar 생성 함수 내용 구현 끝

// 앱 바 버튼 클릭 시, 각 화면으로 이동하는 함수인 navigateToScreen 내용
void navigateToScreen(BuildContext context, Widget screen) {
  // 현재 라우트의 타입을 검사하여 중복 열기를 방지
  if (ModalRoute.of(context)?.settings.name == screen.runtimeType.toString()) {
    // 이미 해당 화면이면 아무 작업도 수행하지 않음
    return;
  }
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => screen));
}

// ------ 상단 탭 바 텍스트 스타일 관련 topBarTextStyle 함수 내용 구현 시작
// 상단 탭 바 텍스트 스타일 설정 함수
TextStyle topBarTextStyle(int currentIndex, int buttonIndex) {
  return TextStyle(
    fontSize: 16,  // 텍스트 크기를 16으로 설정
    fontWeight: FontWeight.bold,  // 텍스트 굵기를 굵게 설정
    color: currentIndex == buttonIndex ? GOLD_COLOR : INPUT_BORDER_COLOR,  // 현재 선택된 탭과 탭 인덱스가 같다면 금색, 아니면 입력창 테두리 색상으로 설정
    shadows: [  // 텍스트에 그림자 효과를 추가
      Shadow(  // 하단에 그림자 설정
        offset: Offset(0, 2),  // 그림자의 위치를 하단으로 설정
        color: LOGO_COLOR,  // 그림자 색상을 로고 색상으로 설정
        blurRadius: 0,  // 흐림 효과 없음
      ),
      Shadow(  // 오른쪽에 그림자 설정
        offset: Offset(2, 0),  // 그림자의 위치를 오른쪽으로 설정
        color: LOGO_COLOR,  // 그림자 색상을 로고 색상으로 설정
        blurRadius: 0,  // 흐림 효과 없음
      ),
      Shadow(  // 상단에 그림자 설정
        offset: Offset(0, -2),  // 그림자의 위치를 상단으로 설정
        color: LOGO_COLOR,  // 그림자 색상을 로고 색상으로 설정
        blurRadius: 0,  // 흐림 효과 없음
      ),
      Shadow(  // 왼쪽에 그림자 설정
        offset: Offset(-2, 0),  // 그림자의 위치를 왼쪽으로 설정
        color: LOGO_COLOR,  // 그림자 색상을 로고 색상으로 설정
        blurRadius: 0,  // 흐림 효과 없음
      ),
    ],
  );
}
// ------ 상단 탭 바 텍스트 스타일 관련 topBarTextStyle 함수 내용 구현 끝

// ------ buildTopBarList 위젯 내용 구현 시작
// TopBar의 카테고리 리스트를 생성하는 함수를 재작성
// TopBar의 카테고리 리스트 생성 함수. 각 카테고리를 탭했을 때의 동작을 정의함.
Widget buildTopBarList(BuildContext context, void Function(int) onTopBarTap, StateProvider<int> currentTabProvider, ScrollController topBarAutoScrollController) {
  final List<Map<String, String>> topBarCategories = [ // 카테고리 리스트를 정의
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
  return Consumer(
    builder: (context, ref, child) {
      int currentIndex = ref.watch(currentTabProvider); // 현재 선택된 탭의 인덱스를 가져옴
      return SizedBox(
        height: 60,  // 높이를 60으로 설정
        child: ListView.builder(
          controller: topBarAutoScrollController, // 상단 탭 바 자동 스크롤을 위한 컨트롤러 설정
          scrollDirection: Axis.horizontal, // 리스트뷰의 스크롤 방향을 가로로 설정함.
          itemCount: topBarCategories.length, // 리스트뷰에 표시될 항목의 개수를 상단 바 카테고리 배열의 길이로 설정함.
          itemBuilder: (context, index) {
            final category = topBarCategories[index]["data"] ?? ""; // 안전하게 문자열 추출
            return GestureDetector(
              onTap: () {
                onTopBarTap(index);  // onTopBarTap 함수를 호출하여 처리
                ref.read(currentTabProvider.notifier).state = index;  // 선택된 탭의 인덱스를 갱신
              },
              child: Container( // 수정된 부분: Padding을 Container로 변경
                alignment: Alignment.center, // Container 내부 내용을 중앙 정렬
                padding: EdgeInsets.symmetric(horizontal: 20), // 좌우로 패딩 적용
                child: Text(category, style: topBarTextStyle(currentIndex, index)),
            ),
          );
        },
      ),
    );
  },
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
      // 선택된 탭의 인덱스가 현재 인덱스와 같은지 확인함.
      if (ref.read(tabIndexProvider) == index) {
        // 인덱스가 0인 경우, 즉 '홈' 탭이 선택된 경우
        if (index == 0) {
          // homeScrollControllerProvider를 통해 ScrollController를 가져옴.
          final homeScrollController = ref.read(homeScrollControllerProvider);
          // ScrollController가 유효한지 확인함.
          if (homeScrollController.hasClients) {
            // ScrollController가 클라이언트를 가지고 있는지 확인함.
            // 즉, ScrollController가 연결된 Scrollable Widget이 있는지 확인함.
            // 스크롤 위치를 0으로 설정하여 초기 위치로 이동함.
            homeScrollController.animateTo(
              0, // 스크롤 위치를 최상단(0)으로 설정함.
              duration: Duration(milliseconds: 500), // 스크롤 애니메이션의 지속 시간을 500밀리초로 설정함.
              curve: Curves.easeInOut, // 스크롤 애니메이션의 커브를 easeInOut으로 설정하여 부드럽게 시작하고 끝나도록 함.
            );
          }
        }

        // 인덱스가 1인 경우, 즉 '장바구니' 탭이 선택된 경우
        if (index == 1) {
          // cartScrollControllerProvider를 통해 ScrollController를 가져옴.
          final cartScrollController = ref.read(cartScrollControllerProvider);
          // ScrollController가 유효한지 확인함.
          if (cartScrollController.hasClients) {
            // ScrollController가 클라이언트를 가지고 있는지 확인함.
            // 즉, ScrollController가 연결된 Scrollable Widget이 있는지 확인함.
            // 스크롤 위치를 0으로 설정하여 초기 위치로 이동함.
            cartScrollController.animateTo(
              0, // 스크롤 위치를 최상단(0)으로 설정함.
              duration: Duration(milliseconds: 500), // 스크롤 애니메이션의 지속 시간을 500밀리초로 설정함.
              curve: Curves.easeInOut, // 스크롤 애니메이션의 커브를 easeInOut으로 설정하여 부드럽게 시작하고 끝나도록 함.
            );
          }
        }

        // 인덱스가 2인 경우, 즉 '주문' 탭이 선택된 경우
        if (index == 2) {
          // orderScrollControllerProvider를 통해 ScrollController를 가져옴.
          final orderScrollController = ref.read(orderScrollControllerProvider);
          // ScrollController가 유효한지 확인함.
          if (orderScrollController.hasClients) {
            // ScrollController가 클라이언트를 가지고 있는지 확인함.
            // 즉, ScrollController가 연결된 Scrollable Widget이 있는지 확인함.
            // 스크롤 위치를 0으로 설정하여 초기 위치로 이동함.
            orderScrollController.animateTo(
              0, // 스크롤 위치를 최상단(0)으로 설정함.
              duration: Duration(milliseconds: 500), // 스크롤 애니메이션의 지속 시간을 500밀리초로 설정함.
              curve: Curves.easeInOut, // 스크롤 애니메이션의 커브를 easeInOut으로 설정하여 부드럽게 시작하고 끝나도록 함.
            );
          }
        }

        // 인덱스가 3인 경우, 즉 '마이페이지' 탭이 선택된 경우
        if (index == 3) {
          // profileScrollControllerProvider를 통해 ScrollController를 가져옴.
          final profileScrollController = ref.read(profileScrollControllerProvider);
          // ScrollController가 유효한지 확인함.
          if (profileScrollController.hasClients) {
            // ScrollController가 클라이언트를 가지고 있는지 확인함.
            // 즉, ScrollController가 연결된 Scrollable Widget이 있는지 확인함.
            // 스크롤 위치를 0으로 설정하여 초기 위치로 이동함.
            profileScrollController.animateTo(
              0, // 스크롤 위치를 최상단(0)으로 설정함.
              duration: Duration(milliseconds: 500), // 스크롤 애니메이션의 지속 시간을 500밀리초로 설정함.
              curve: Curves.easeInOut, // 스크롤 애니메이션의 커브를 easeInOut으로 설정하여 부드럽게 시작하고 끝나도록 함.
            );
          }
        }
        // 이미 선택된 탭이면 아무 동작도 하지 않음.
        return;
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
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => CartMainScreen()));
          break;
        case 2:
        // '주문' 화면으로 이동
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderMainScreen()));
          break;
        case 3:
        // '마이페이지' 화면으로 이동
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ProfileMainScreen()));
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
// 드로워 생성 함수
// 공통 Drawer 생성 함수. 사용자 이메일을 표시하고 로그아웃 등의 메뉴 항목을 포함함.
Widget buildCommonDrawer(BuildContext context, WidgetRef ref) {
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
        // 로그아웃 버튼 항목
        ListTile(
          leading: Icon(Icons.logout), // 로그아웃 아이콘
          title: Text('Logout'), // 로그아웃 텍스트
          onTap: () async {
            // 로그아웃 및 자동로그인 체크 상태에서 앱 종료 후 재실행 시,
            // 홈 화면 내 섹션의 데이터 초기화 / 홈 화면 내 섹션의 스크롤 위치 초기화 /  화면 자체의 스크롤 위치 초기화 관련 함수 호출
            await logoutSecDataAndHomeScrollPointReset(ref);
            // 로그인 화면으로 이동
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
          },
        ),
        // 네이버 카페 항목
        _buildListTile(context, '네이버 카페', 'https://cafe.naver.com/ottbayo', 'asset/img/misc/drawer_img/navercafe.logo.png'),
        // 유튜브 항목
        _buildListTile(context, '유튜브', 'https://www.youtube.com/@OTTBAYO', 'asset/img/misc/drawer_img/youtube.logo.png'),
        // 인스타그램 항목
        _buildListTile(context, '인스타그램', 'https://www.instagram.com/ottbayo', 'asset/img/misc/drawer_img/instagram.logo.png'),
        // 카카오 항목
        _buildListTile(context, '카카오', 'https://pf.kakao.com/_xjVrbG', 'asset/img/misc/drawer_img/kakao.logo.png'),
        // 프로필 설정 항목
        ListTile(leading: Icon(Icons.account_circle), title: Text('Profile')),
        // 커뮤니티 항목
        ListTile(leading: Icon(Icons.group), title: Text('Communities')),
        // Q&A 항목
        ListTile(leading: Icon(Icons.message), title: Text('Q&A')),
        // 설정 항목
        ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
      ],
    ),
  );
}

// ------ buildCommonDrawer 위젯 내용 구현 끝

// ------ 웹 링크를 포함한 리스트 타일을 생성하는 함수(위젯) 시작
Widget _buildListTile(BuildContext context, String title, String url, String leadingImage) {
  // ListTile 위젯 반환
  return ListTile(
    // 이미지 리딩
    leading: Image.asset(leadingImage, width: 24),
    // 타이틀 텍스트
    title: Text(title),
    // 탭 핸들러
    onTap: () async {
      try {
        // URL을 파싱하여 웹 페이지 열기 시도
        final bool launched = await launchUrl(Uri.parse(url));
        if (!launched) {
          // 웹 페이지를 열지 못할 경우 스낵바로 알림
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('웹 페이지를 열 수 없습니다.')));
        }
      } catch (e) {
        // 예외 발생 시 스낵바로 에러 메시지 출력
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('앱 실행에 실패했습니다.')));
      }
    },
  );
}
// ------ 웹 링크를 포함한 리스트 타일을 생성하는 함수(위젯) 끝