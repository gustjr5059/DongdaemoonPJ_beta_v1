// Firebase의 사용자 인증 기능을 사용하기 위한 패키지를 임포트합니다.
import 'package:firebase_auth/firebase_auth.dart';

// Flutter의 기본 디자인과 인터페이스 요소들을 사용하기 위한 Material 패키지를 임포트합니다.
import 'package:flutter/material.dart';

// Riverpod 패키지를 사용한 상태 관리 기능을 추가합니다. Riverpod는 상태 관리를 위한 외부 패키지입니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 외부 웹사이트나 애플리케이션 링크를 열기 위한 URL Launcher 패키지를 임포트합니다.
import 'package:url_launcher/url_launcher.dart';

// 애플리케이션 내 쇼핑 카트 화면 관련 파일을 임포트합니다.
import '../../cart/layout/cart_body_parts_layout.dart';
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
import '../../product/model/product_model.dart';
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
  required BuildContext
      context, // BuildContext를 필수 인자로 받고, 각종 위젯에서 위치 정보 등을 제공받음.
  required WidgetRef ref, // WidgetRef를 필수 인자로 받음.
  required String title, // AppBar에 표시될 제목을 문자열로 받음.
  LeadingType leadingType =
      LeadingType.drawer, // 왼쪽 상단 버튼 유형을 결정하는 열거형, 기본값은 드로어 버튼.
  int buttonCase = 1, // 버튼 구성을 선택하기 위한 매개변수 추가
}) {
  // 왼쪽 상단에 표시될 위젯을 설정함.
  Widget? leadingWidget;
  switch (leadingType) {
    // 이전 화면으로 이동 버튼인 경우
    case LeadingType.back:
      leadingWidget = IconButton(
        icon: Icon(Icons.arrow_back), // 뒤로 가기 아이콘을 사용함.
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(); // 페이지 스택이 존재하면 이전 페이지로 돌아감.
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('이전 화면으로 이동할 수 없습니다.')) // 이전 페이지로 돌아갈 수 없다는 메시지 표시
                );
          }
        },
      );
      break;
    // 드로워화면 버튼인 경우
    case LeadingType.drawer:
      leadingWidget = Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.menu), // 메뉴 아이콘을 사용함.
            onPressed: () =>
                Scaffold.of(context).openDrawer(), // 버튼을 누르면 드로어 메뉴를 열게됨.
          );
        },
      );
      break;
    // 버튼이 없는 경우
    case LeadingType.none:
      leadingWidget = null; // 아무런 위젯도 표시하지 않음.
      break;
  }

  // 버튼 구성을 결정하는 로직
  List<Widget> actions = [];
  switch (buttonCase) {
    case 1:
      // 케이스 1: 아무 내용도 없음
      //   actions.add(Container(width: 48)); // 빈 공간 추가
      break;
    case 2:
      // 케이스 2: 찜 목록 버튼만 노출
      actions.add(
        IconButton(
          icon: Icon(Icons.favorite, color: Colors.red),
          // 찜 목록 아이콘을 사용함.
          // WishlistMainScreen()을 tabIndex=4로 한 것은 BottomNavigationBar에는 해당 버튼을 생성하지는 않았으므로
          // 단순히 찜 목록 화면으로 이동할 때의 고유한 식별자 역할을 하는 인덱스 값이며, 상태 관리 로직에서는 다른 화면과 구분되기 위해 사용함.
          // 그래서, 홈:0, 장바구니:1, 발주내역:2, 마이페이지:3의 숫자를 피해서 적용
          onPressed: () => navigateToScreenAndRemoveUntil(
              context, ref, WishlistMainScreen(), 4), // 찜 목록 화면으로 이동
        ),
      );
      break;
    case 3:
      // 케이스 3: 찜 목록 버튼, 홈 버튼 노출
      actions.addAll([
        IconButton(
          icon: Icon(Icons.favorite, color: Colors.red),
          onPressed: () => navigateToScreenAndRemoveUntil(
              context, ref, WishlistMainScreen(), 4), // 찜 목록 화면으로 이동
        ),
        IconButton(
          icon: Icon(Icons.home),
          // HomeMainScreen()을 tabIndex=0으로 한 것은 BottomNavigationBar에서 홈 버튼을 0으로 지정한 것과 일치하게 설정
          onPressed: () => navigateToScreenAndRemoveUntil(
              context, ref, HomeMainScreen(), 0), // 홈 화면으로 이동
        ),
      ]);
      break;
    case 4:
      // 케이스 4: 찜 목록 버튼, 홈 버튼, 장바구니 버튼 노출
      actions.addAll([
        IconButton(
          icon: Icon(Icons.favorite, color: Colors.red),
          onPressed: () => navigateToScreenAndRemoveUntil(
              context, ref, WishlistMainScreen(), 4), // 찜 목록 화면으로 이동
        ),
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () => navigateToScreenAndRemoveUntil(
              context, ref, HomeMainScreen(), 0), // 홈 화면으로 이동
        ),
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () => navigateToScreenAndRemoveUntil(
              context, ref, CartMainScreen(), 1), // 장바구니 화면으로 이동
        ),
      ]);
      break;
  }

  // AppBar를 반환
  return AppBar(
    backgroundColor: BUTTON_COLOR,
    // AppBar 색상 설정
    title: Container(
      height: kToolbarHeight, // AppBar 높이를 설정
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 세로 방향 가운데 정렬
        children: <Widget>[
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1, // 가로 세로 비율을 1:1로 설정
                child: Image.asset(
                  'asset/img/misc/logo_img/couture_logo_image.png',
                  // 로고 이미지 경로 설정
                  fit: BoxFit.contain, // 이미지를 포함하여 맞춤
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title, // 제목 설정
                style: TextStyle(
                  color: Colors.black, // 제목 텍스트 색상
                  fontSize: 20, // 제목 텍스트 크기
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    centerTitle: true,
    // 제목을 중앙에 위치시킴.
    leading: leadingWidget,
    // 설정된 leading 위젯을 사용함.
    actions: actions, // 설정된 동작 버튼들을 추가함.
  );
}
// ------ AppBar 생성 함수 내용 구현 끝

// ------ buildCommonBottomNavigationBar 위젯 내용 구현 시작
// BottomNavigationBar 생성 함수
Widget buildCommonBottomNavigationBar(
    int selectedIndex, WidgetRef ref, BuildContext context, int colorCase, int navigationCase, {ProductContent? product}) {

  // 숫자 형식을 지정하기 위한 NumberFormat 객체 생성
  final numberFormat = NumberFormat('###,###'); // 천 단위일때마다 쉼표 표시

  switch (navigationCase) {
    // '홈', '장바구니', '발주내역', '마이페이지' 버튼을 UI로 구현한 케이스
    case 1:
  // 선택된 아이템의 색상을 초기화
  Color selectedColor = DRAWER_COLOR;
  // 선택되지 않은 아이템의 색상을 초기화
  Color unselectedColor = BODY_TEXT_COLOR;

  // colorCase 값에 따라 선택된 아이템의 색상을 설정
  switch (colorCase) {
    case 1: // 홈 버튼만 선택된 경우
      selectedColor = DRAWER_COLOR;
      break;
    case 2: // 장바구니 버튼만 선택된 경우
      selectedColor = DRAWER_COLOR;
      break;
    case 3: // 발주 내역 버튼만 선택된 경우
      selectedColor = DRAWER_COLOR;
      break;
    case 4: // 마이페이지 버튼만 선택된 경우
      selectedColor = DRAWER_COLOR;
      break;
    case 5: // 모든 버튼이 선택되지 않은 경우
      selectedColor = BODY_TEXT_COLOR;
      break;
  }

  // BottomNavigationBar를 반환
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    // BottomNavigationBar 타입을 고정형으로 설정
    currentIndex: selectedIndex >= 0 && selectedIndex < 4 ? selectedIndex : 0,
    // 현재 선택된 인덱스를 설정, 범위가 벗어나면 0으로 설정
    onTap: (index) {
      // 다른 인덱스가 선택된 경우
      if (index != selectedIndex) {
        // 선택된 인덱스를 상태로 업데이트
        ref.read(tabIndexProvider.notifier).state = index;

        // 화면 전환
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) {
            // 선택된 인덱스에 따라 다른 화면을 반환
            switch (index) {
              case 0:
                return HomeMainScreen();
              case 1:
                return CartMainScreen();
              case 2:
                return OrderMainScreen();
              case 3:
                return ProfileMainScreen();
              default:
                return HomeMainScreen();
            }
          }),
          (Route<dynamic> route) => false, // 모든 이전 라우트를 제거
        );
      } else {
        // 현재 화면이 이미 선택된 화면인 경우, 스크롤 위치를 초기화
        switch (index) {
          case 0:
            // 홈 화면의 스크롤 컨트롤러를 가져와 위치를 초기화
            final homeScrollController = ref.read(homeScrollControllerProvider);
            if (homeScrollController.hasClients) {
              homeScrollController.animateTo(
                0,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
            break;
          case 1:
            // 장바구니 화면의 스크롤 컨트롤러를 가져와 위치를 초기화
            final cartScrollController = ref.read(cartScrollControllerProvider);
            if (cartScrollController.hasClients) {
              cartScrollController.animateTo(
                0,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
            break;
          case 2:
            // 발주 내역 화면의 스크롤 컨트롤러를 가져와 위치를 초기화
            final orderScrollController =
                ref.read(orderScrollControllerProvider);
            if (orderScrollController.hasClients) {
              orderScrollController.animateTo(
                0,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
            break;
          case 3:
            // 마이페이지 화면의 스크롤 컨트롤러를 가져와 위치를 초기화
            final profileScrollController =
                ref.read(profileScrollControllerProvider);
            if (profileScrollController.hasClients) {
              profileScrollController.animateTo(
                0,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
            break;
        }
      }
    },
    // BottomNavigationBar의 아이템들을 정의
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined), // 홈 아이콘
        label: '홈', // 홈 라벨
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart_outlined), // 장바구니 아이콘
        label: '장바구니', // 장바구니 라벨
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long_outlined), // 발주 내역 아이콘
        label: '발주내역', // 발주 내역 라벨
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outlined), // 마이페이지 아이콘
        label: '마이페이지', // 마이페이지 라벨
      ),
    ],
    selectedItemColor: selectedColor,
    // 선택된 아이템의 색상
    unselectedItemColor: unselectedColor,
    // 선택되지 않은 아이템의 색상
    selectedFontSize: 10,
    // 선택된 아이템의 폰트 크기
    unselectedFontSize: 10, // 선택되지 않은 아이템의 폰트 크기
  );

  // '장바구니', '바로 발주' 버튼을 UI로 구현한 케이스
    case 2:
      if (product == null) {
        throw ArgumentError('Product must be provided for navigation case 2');
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // 좌우 20.0, 상하 10.0의 여백을 추가
        child: Row( // 수평으로 배치되는 Row 위젯 사용
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Row 내부 위젯들을 양 끝에 배치
          children: [
            Expanded( // 내부 위젯의 가로 공간을 최대한 확장
              child: ElevatedButton(
                onPressed: () => onCartButtonPressed(context, ref, product), // 장바구니 버튼 클릭했을 때, 데이터를 파이어베이스에 저장하도록 하는 로직 재사용하여 구현
                style: ElevatedButton.styleFrom(
                  backgroundColor: BUTTON_COLOR, // 버튼의 배경색 설정
                  foregroundColor: INPUT_BG_COLOR, // 버튼 텍스트 색상 설정
                ),
                child: Text('장바구니'), // 버튼 텍스트 설정
              ),
            ),
            SizedBox(width: 10), // 버튼들 사이에 10픽셀 너비의 여백 추가
            Expanded( // 내부 위젯의 가로 공간을 최대한 확장
              child: ElevatedButton(
                onPressed: () {
                  // 바로 발주 버튼 클릭 시 동작 추가
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: BUTTON_COLOR, // 버튼의 배경색 설정
                  foregroundColor: INPUT_BG_COLOR, // 버튼 텍스트 색상 설정
                ),
                child: Text('바로 발주'), // 버튼 텍스트 설정
              ),
            ),
          ],
        ),
      );

  // '전체 체크박스', '합계' '발주하기' 버튼을 UI로 구현한 케이스 - 장바구니 화면에 구현
    case 3:
    // 전체 체크박스 선택 여부를 상태로 관리
      final allChecked = ref.watch(allCheckedProvider);
      // 장바구니 아이템 목록을 상태로 관리
      final cartItems = ref.watch(cartItemsProvider);

      // 선택된 아이템들의 합계 금액 계산
      int totalSelectedPrice = cartItems
      // 아이템 목록 중 선택된 아이템만 필터링
          .where((item) => item['checked'] == true)
      // 선택된 아이템들의 합계 금액을 계산
          .fold(0, (sum, item) => sum + (item['discount_price'] as num).toInt() * (item['selected_count'] as num).toInt());

      return Container(
        // 컨테이너의 내부 여백 설정
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        // 컨테이너 배경색을 흰색으로 설정
        color: Colors.white,
        child: Row(
          // Row의 주 축 방향에서의 정렬 방식을 공간을 동일하게 나눔
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 전체 선택 체크박스와 텍스트를 담을 Row
            Row(
              children: [
                // 체크박스 크기를 1.5배로 확대
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    // 체크박스의 선택 여부를 allChecked 상태로 설정
                    value: allChecked,
                    activeColor: BUTTON_COLOR,  // 체크박스 색상 변경
                    // 체크박스 상태 변경 시 호출되는 함수
                    onChanged: (bool? value) {
                      // allCheckedProvider 상태 업데이트
                      ref.read(allCheckedProvider.notifier).state = value!;
                      // cartItemsProvider 상태에서 모든 아이템의 체크 상태를 변경
                      ref.read(cartItemsProvider.notifier).toggleAll(value);
                    },
                  ),
                ),
                // 체크박스와 텍스트 사이의 간격 설정
                SizedBox(width: 8),
                // "전체" 텍스트를 표시
                Text(
                  '전체',
                  // 텍스트 스타일 설정 (크기: 16, 굵게)
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // 합계 금액을 표시하는 텍스트
            Text(
              '합계: ${numberFormat.format(totalSelectedPrice)}원',
              // 텍스트 스타일 설정 (크기: 18, 굵게)
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // 발주하기 버튼
            ElevatedButton(
              // 버튼 클릭 시 호출되는 함수
              onPressed: () {
                // OrderMainScreen으로 화면 전환
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => OrderMainScreen()),
                );
              },
              // 버튼 스타일 설정 (배경색: BUTTON_COLOR, 글자색: INPUT_BG_COLOR)
              style: ElevatedButton.styleFrom(
                backgroundColor: BUTTON_COLOR,
                foregroundColor: INPUT_BG_COLOR,
              ),
              // 버튼에 표시될 텍스트
              child: Text('발주하기'),
            ),
          ],
        ),
      );

    default:
      return Container(); // 기본으로 빈 컨테이너 반환
  }
}
// ------ buildCommonBottomNavigationBar 위젯 내용 구현 끝

// 왼쪽 상단 버튼 유형을 정의하는 열거형 관련 함수
enum LeadingType {
  drawer, // 드로어 버튼.
  back, // 이전 화면으로 이동 버튼.
  none, // 아무 버튼도 없음.
}

// 버튼 클릭하는 경우, 각 화면으로 이동하는 함수인 navigateToScreen 내용 (앱 바, 하단 탭 바에 사용)
void navigateToScreen(
    BuildContext context, WidgetRef ref, Widget screen, int tabIndex) {
  // 현재 경로가 이동하려는 화면과 동일한지 확인
  if (ModalRoute.of(context)?.settings.name == screen.runtimeType.toString()) {
    return; // 동일하면 아무 작업도 하지 않음
  }
  // 탭 인덱스 업데이트
  ref.read(tabIndexProvider.notifier).state = tabIndex;
  // 지정된 화면으로 교체하면서 이동
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (_) => screen));
}

// 특정 화면으로 이동하면서 기존의 모든 페이지 스택을 제거하는 함수인 navigateToScreenAndRemoveUntil 내용 (앱 바, 하단 탭 바에 사용)
void navigateToScreenAndRemoveUntil(
    BuildContext context, WidgetRef ref, Widget screen, int tabIndex) {
  // 탭 인덱스 업데이트
  ref.read(tabIndexProvider.notifier).state = tabIndex;
  // 지정된 화면으로 이동하면서 기존의 모든 페이지 스택을 제거
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => screen),
    (Route<dynamic> route) => false, // 모든 이전 라우트를 제거
  );
}

// ------ 상단 탭 바 텍스트 스타일 관련 topBarTextStyle 함수 내용 구현 시작
// 상단 탭 바 텍스트 스타일 설정 함수
TextStyle topBarTextStyle(int currentIndex, int buttonIndex) {
  return TextStyle(
    fontSize: 16,
    // 텍스트 크기를 16으로 설정
    fontWeight: FontWeight.bold,
    // 텍스트 굵기를 굵게 설정
    color: currentIndex == buttonIndex ? GOLD_COLOR : INPUT_BORDER_COLOR,
    // 현재 선택된 탭과 탭 인덱스가 같다면 금색, 아니면 입력창 테두리 색상으로 설정
    shadows: [
      // 텍스트에 그림자 효과를 추가
      Shadow(
        // 하단에 그림자 설정
        offset: Offset(0, 2), // 그림자의 위치를 하단으로 설정
        color: LOGO_COLOR, // 그림자 색상을 로고 색상으로 설정
        blurRadius: 0, // 흐림 효과 없음
      ),
      Shadow(
        // 오른쪽에 그림자 설정
        offset: Offset(2, 0), // 그림자의 위치를 오른쪽으로 설정
        color: LOGO_COLOR, // 그림자 색상을 로고 색상으로 설정
        blurRadius: 0, // 흐림 효과 없음
      ),
      Shadow(
        // 상단에 그림자 설정
        offset: Offset(0, -2), // 그림자의 위치를 상단으로 설정
        color: LOGO_COLOR, // 그림자 색상을 로고 색상으로 설정
        blurRadius: 0, // 흐림 효과 없음
      ),
      Shadow(
        // 왼쪽에 그림자 설정
        offset: Offset(-2, 0), // 그림자의 위치를 왼쪽으로 설정
        color: LOGO_COLOR, // 그림자 색상을 로고 색상으로 설정
        blurRadius: 0, // 흐림 효과 없음
      ),
    ],
  );
}
// ------ 상단 탭 바 텍스트 스타일 관련 topBarTextStyle 함수 내용 구현 끝

// ------ buildTopBarList 위젯 내용 구현 시작
// TopBar의 카테고리 리스트를 생성하는 함수를 재작성
// TopBar의 카테고리 리스트 생성 함수. 각 카테고리를 탭했을 때의 동작을 정의함.
Widget buildTopBarList(
    BuildContext context,
    void Function(int) onTopBarTap,
    StateProvider<int> currentTabProvider,
    ScrollController topBarAutoScrollController) {
  final List<Map<String, String>> topBarCategories = [
    // 카테고리 리스트를 정의
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
        height: 60, // 높이를 60으로 설정
        child: ListView.builder(
          controller: topBarAutoScrollController,
          // 상단 탭 바 자동 스크롤을 위한 컨트롤러 설정
          scrollDirection: Axis.horizontal,
          // 리스트뷰의 스크롤 방향을 가로로 설정함.
          itemCount: topBarCategories.length,
          // 리스트뷰에 표시될 항목의 개수를 상단 바 카테고리 배열의 길이로 설정함.
          itemBuilder: (context, index) {
            final category =
                topBarCategories[index]["data"] ?? ""; // 안전하게 문자열 추출
            return GestureDetector(
              onTap: () {
                onTopBarTap(index); // onTopBarTap 함수를 호출하여 처리
                ref.read(currentTabProvider.notifier).state =
                    index; // 선택된 탭의 인덱스를 갱신
              },
              child: Container(
                // 수정된 부분: Padding을 Container로 변경
                alignment: Alignment.center, // Container 내부 내용을 중앙 정렬
                padding: EdgeInsets.symmetric(horizontal: 20), // 좌우로 패딩 적용
                child:
                    Text(category, style: topBarTextStyle(currentIndex, index)),
              ),
            );
          },
        ),
      );
    },
  );
}
// ------ buildTopBarList 위젯 내용 구현 끝

// ------ buildCommonDrawer 위젯 내용 구현 시작
// 드로워 생성 함수
// 공통 Drawer 생성 함수. 사용자 이메일을 표시하고 로그아웃 등의 메뉴 항목을 포함함.
Widget buildCommonDrawer(BuildContext context, WidgetRef ref) {
  // FirebaseAuth에서 현재 로그인한 사용자의 이메일을 가져옴. 로그인하지 않았다면 'No Email'이라는 기본 문자열을 표시함.
  final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'No Email';

  // Drawer 위젯을 반환합니다. 이 위젯은 앱의 사이드 메뉴를 구현하는 데 사용.
  return Drawer(
    // SingleChildScrollView를 자식으로 사용하여 드로어 내용물을 스크롤 가능하게 함.
    child: SingleChildScrollView(
      padding: EdgeInsets.zero,
      // SingleChildScrollView의 패딩을 0으로 설정하여 상단 여백을 제거함.
      child: Column(
        children: <Widget>[
          // 드로어의 헤더 부분을 구성합니다. 헤더는 사용자 정보를 표시하는 영역.
          DrawerHeader(
            decoration: BoxDecoration(color: DRAWER_COLOR), // 헤더 배경색을 설정함.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 세로 방향으로 중앙 정렬
              crossAxisAlignment: CrossAxisAlignment.start, // 가로 방향으로 왼쪽 정렬
              children: [
                // Flexible 위젯을 사용하여 로고 이미지가 가변적인 높이를 가질 수 있도록 함.
                // 이 위젯을 통해서 드로워헤더의 정해진 높이에 맞춰서 내용이 들어가도록 이미지 크기를 동적으로 변경해줌.
                Flexible(
                  child: Image.asset(
                      'asset/img/misc/logo_img/couture_logo_image.png',
                      width: 100,
                      height: 100),
                ),
                SizedBox(height: 10), // 간격을 위한 SizedBox
                // 현재 로그인한 사용자의 이메일을 표시함.
                Text(userEmail,
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                SizedBox(height: 10), // 텍스트 사이의 간격을 위한 SizedBox
                // 로그아웃 버튼 항목
                GestureDetector(
                  onTap: () async {
                    // 로그아웃 및 자동로그인 체크 상태에서 앱 종료 후 재실행 시,
                    // 홈 화면 내 섹션의 데이터 초기화 / 홈 화면 내 섹션의 스크롤 위치 초기화 / 화면 자체의 스크롤 위치 초기화 관련 함수 호출
                    await logoutAndLoginAfterProviderReset(ref);
                    // 로그인 화면으로 이동
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.white),
                      // 로그아웃 아이콘
                      SizedBox(width: 10),
                      // 아이콘과 텍스트 사이의 간격
                      Text('Logout', style: TextStyle(color: Colors.white)),
                      // 로그아웃 텍스트
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20), // 간격을 위한 SizedBox
          // 네이버 카페 항목
          _buildListTile(context, '네이버 카페', 'https://cafe.naver.com/ottbayo',
              'asset/img/misc/drawer_img/navercafe.logo.png'),
          SizedBox(height: 20), // 간격을 위한 SizedBox
          // 유튜브 항목
          _buildListTile(context, '유튜브', 'https://www.youtube.com/@OTTBAYO',
              'asset/img/misc/drawer_img/youtube.logo.png'),
          SizedBox(height: 20), // 간격을 위한 SizedBox
          // 인스타그램 항목
          _buildListTile(context, '인스타그램', 'https://www.instagram.com/ottbayo',
              'asset/img/misc/drawer_img/instagram.logo.png'),
          SizedBox(height: 20), // 간격을 위한 SizedBox
          // 카카오 항목
          _buildListTile(context, '카카오톡', 'https://pf.kakao.com/_xjVrbG',
              'asset/img/misc/drawer_img/kakao.logo.png'),
        ],
      ),
    ),
  );
}

// ------ buildCommonDrawer 위젯 내용 구현 끝

// ------ 웹 링크를 포함한 리스트 타일을 생성하는 함수(위젯) 시작
Widget _buildListTile(
    BuildContext context, String title, String url, String leadingImage) {
  // ListTile 위젯 반환
  return ListTile(
    // 이미지 리딩
    leading: Image.asset(leadingImage, width: 40),
    // 타이틀 텍스트
    title: Text(title),
    // 탭 핸들러
    onTap: () async {
      try {
        // URL을 파싱하여 웹 페이지 열기 시도
        final bool launched = await launchUrl(Uri.parse(url));
        if (!launched) {
          // 웹 페이지를 열지 못할 경우 스낵바로 알림
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('웹 페이지를 열 수 없습니다.')));
        }
      } catch (e) {
        // 예외 발생 시 스낵바로 에러 메시지 출력
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('앱 실행에 실패했습니다.')));
      }
    },
  );
}
// ------ 웹 링크를 포함한 리스트 타일을 생성하는 함수(위젯) 끝
