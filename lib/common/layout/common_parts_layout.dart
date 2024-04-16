
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 데이터베이스 사용을 위한 패키지
import 'package:dongdaemoon_beta_v1/user/view/login_screen.dart'; // 로그인 화면
import 'package:flutter/material.dart'; // Flutter의 기본 디자인 위젯
import 'package:firebase_auth/firebase_auth.dart'; // Firebase 인증 사용을 위한 패키지
import 'package:url_launcher/url_launcher.dart';
import '../../cart/view/cart_screen.dart'; // 장바구니 화면
import '../../home/view/blouse_main_screen.dart'; // 블라우스 화면
import '../../home/view/cardigan_main_screen.dart'; // 가디건 화면
import '../../home/view/coat_main_screen.dart'; // 코트 화면
import '../../home/view/jean_main_screen.dart'; // 청바지 화면
import '../../home/view/neat_main_screen.dart'; // 니트 화면
import '../../home/view/onepiece_main_screen.dart'; // 원피스 화면
import '../../home/view/paeding_main_screen.dart'; // 패딩 화면
import '../../home/view/pants_main_screen.dart'; // 팬츠 화면
import '../../home/view/shirt_main_screen.dart'; // 셔츠 화면
import '../../home/view/skirt_main_screen.dart'; // 스커트 화면
import '../../home/view/pola_main_screen.dart'; // 상의 화면
import '../../home/view/mtm_main_screen.dart'; // 언더웨어 화면
import '../../order/view/order_screen.dart'; // 주문 화면
import '../../product/provider/product_state_provider.dart';
// 제품 상세 화면
import '../../product/view/blouse_detail_screen.dart';
import '../../product/view/cardigan_detail_screen.dart';
import '../../product/view/coat_detail_screen.dart';
import '../../product/view/jean_detail_screen.dart';
import '../../product/view/neat_detail_screen.dart';
import '../../product/view/onepiece_detail_screen.dart';
import '../../product/view/paeding_detail_screen.dart';
import '../../product/view/pants_detail_screen.dart';
import '../../product/view/shirt_detail_screen.dart';
import '../../product/view/skirt_detail_screen.dart';
import '../../product/view/pola_detail_screen.dart';
import '../../product/view/mtm_detail_screen.dart';
import '../../user/view/profile_screen.dart'; // 사용자 프로필 화면
import '../const/colors.dart'; // 앱 전반에 사용되는 색상 상수
import '../provider/common_future_provider.dart'; // 비동기 데이터 로드를 위한 FutureProvider
import '../provider/common_state_provider.dart'; // 상태 관리를 위한 StateProvider
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리 라이브러리

// GlobalKey 사용 제거
// final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

// ------ 배너 페이지 뷰 자동 스크롤 기능 구현 위한 클래스 시작
class BannerAutoScrollClass {
  // 페이지 컨트롤러를 위한 변수 선언
  final PageController pageController;
  // 현재 페이지 인덱스를 추적하기 위한 상태 관리 변수
  final StateProvider<int> currentPageProvider;
  // 자동 스크롤 타이머를 관리하기 위한 Timer 변수
  Timer? _timer;
  // 배너 아이템의 총 개수
  int itemCount;

  // 생성자를 통해 필수 변수를 초기화
  BannerAutoScrollClass({
    required this.pageController,
    required this.currentPageProvider,
    required this.itemCount,
  });

  // 자동 스크롤 기능을 시작하는 함수
  void startAutoScroll() {
    _timer?.cancel(); // 기존에 실행중인 타이머가 있다면 취소
    // 5초마다 반복되는 타이머를 설정
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      // 페이지 컨트롤러와 아이템 수를 확인
      if (pageController.hasClients && itemCount > 0) {
        // 다음 페이지 번호 계산, 현재 페이지에서 1을 더함
        int nextPage = (pageController.page?.round() ?? 0) + 1;
        // 계산된 다음 페이지가 아이템 수보다 많거나 같으면 첫 페이지로 설정
        if (nextPage >= itemCount) {
          nextPage = 0; // 첫 페이지로 이동
        }
        // 페이지 컨트롤러를 사용하여 부드럽게 다음 페이지로 이동
        pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300), // 이동하는 데 300밀리초 소요
          curve: Curves.easeInOut, // 이동 애니메이션은 easeInOut 곡선을 사용
        );
      }
    });
  }

  // 자동 스크롤 기능을 정지하는 함수
  void stopAutoScroll() {
    _timer?.cancel(); // 타이머를 취소
    _timer = null; // 타이머 변수를 null로 설정
  }
}
// ------ 배너 페이지 뷰 자동 스크롤 기능 구현 위한 클래스 끝

// ------ 배너 페이지 뷰에 사용되는 파이어베이스의 이미지 데이터를 캐시에 임시 저장하기 위한 클래스 시작
// StatelessWidget를 상속받아 상태가 없는 위젯 BannerImage를 정의함.
class BannerImage extends StatelessWidget {
  // imageUrl은 네트워크 이미지의 URL을 저장하는 문자열 변수
  final String imageUrl;

  // 생성자에서는 imageUrl을 필수적으로 받으며, key는 선택적으로 받음.
  // super(key: key)를 통해 부모 클래스의 생성자에 key를 전달함.
  const BannerImage({Key? key, required this.imageUrl}) : super(key: key);

  // build 메소드는 위젯의 UI를 구성함.
  @override
  Widget build(BuildContext context) {
    // CachedNetworkImage 위젯을 사용하여 네트워크 이미지를 로딩하고 캐싱함.
    return CachedNetworkImage(
      imageUrl: imageUrl, // imageUrl 프로퍼티를 통해 이미지 URL을 지정함.
      fit: BoxFit.contain, // 이미지가 부모 위젯의 경계 내에 들어가도록 조정함.
      // 이미지 로딩 중 에러가 발생한 경우 errorWidget을 통해 에러 아이콘을 표시함.
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
// ------ 배너 페이지 뷰에 사용되는 파이어베이스의 이미지 데이터를 캐시에 임시 저장하기 위한 클래스 끝

// ------ midCategories 부분의 버튼을 화면 크기에 동적으로 한 열당 버튼 갯수를 정해서 열로 정렬하기 위한 클래스 시작
// MidCategoryButtonList 위젯 정의
class MidCategoryButtonList extends ConsumerWidget {
  // 카테고리 버튼 클릭시 실행할 함수를 정의
  final void Function(BuildContext context, int index) onCategoryTap;

  // 생성자에서 필수적으로 클릭 이벤트 함수를 받음
  MidCategoryButtonList({Key? key, required this.onCategoryTap}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 선택된 카테고리의 인덱스를 상태 관리 도구에서 가져옴
    final selectedCategoryIndex = ref.watch(selectedCategoryProvider);
    // 현재 화면의 너비를 MediaQuery를 통해 얻음
    final screenWidth = MediaQuery.of(context).size.width;
    // 화면의 너비에 따라 한 줄에 표시할 카테고리 버튼의 수를 결정
    int itemsPerRow = screenWidth > 600 ? 6 : screenWidth > 400 ? 5 : 4;
    // 전체적인 좌우 패딩 값을 설정
    double padding = 16.0;
    // 버튼들 사이의 간격을 설정
    double spacing = 8.0;
    // 버튼의 너비를 계산 (화면 너비에서 좌우 패딩과 버튼 사이 간격을 제외한 너비를 버튼 수로 나눔)
    double buttonWidth = (screenWidth - padding * 2 - (itemsPerRow - 1) * spacing) / itemsPerRow;

    // Wrap 위젯을 사용하여 화면 너비에 따라 자동으로 줄바꿈을 처리
    return Wrap(
      spacing: spacing, // 버튼 사이의 가로 간격
      runSpacing: spacing, // 버튼 사이의 세로 간격
      children: List.generate(midCategories.length, (index) {
        // midCategories 배열의 길이만큼 버튼을 생성
        // 각 카테고리의 정보와 인덱스를 이용하여 버튼을 생성하는 함수를 호출
        return buildDetailMidCategoryButton(
          context: context,
          index: index,
          category: midCategories[index],
          onCategoryTap: onCategoryTap,
          selectedCategoryIndex: selectedCategoryIndex,
          buttonWidth: buttonWidth,
          ref: ref,  // 상태 관리를 위해 ref 전달
        );
      }),
    );
  }
}
// ------ midCategories 부분의 버튼을 화면 크기에 동적으로 한 열당 버튼 갯수를 정해서 열로 정렬하기 위한 클래스 끝

// ------ AppBar 생성 함수 내용 구현 시작
// 상단 탭 바 생성 함수
// AppBar 생성 함수에서 GlobalKey 사용 제거
// 공통 AppBar 생성 함수. GlobalKey 사용을 제거하고 context를 활용하여 Drawer를 열 수 있게 함.
AppBar buildCommonAppBar(String title, BuildContext context) {
  return AppBar(
    // AppBar의 높이에 맞게 이미지를 조정. 이미지의 원본 비율을 유지하면서 최대 높이를 AppBar의 높이에 맞춤.
    title: Container(
      height: kToolbarHeight, // AppBar의 기본 높이인 kToolbarHeight를 사용하여 이미지 높이를 AppBar 높이로 제한함.
      child: Image.asset(
        'asset/img/misc/logo_image.jpg', // 로고 이미지 경로를 지정합니다.
        fit: BoxFit.scaleDown, // 이미지가 컨테이너에 맞추어 스케일을 조정함.(원본 비율을 유지한 채 이미지 크기 줄이는 부분)
      ),
    ),
    centerTitle: true,
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
          child: Padding(
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

// buildCommonMidScrollCategoryButtons인 중간 카테고리 버튼 화면에 표시될 카테고리명 변수
final List<String> midCategories = [
  "티셔츠", "블라우스", "맨투맨", "니트",
  "폴라티", "원피스", "팬츠", "청바지",
  "스커트", "패딩", "코트", "가디건"
];

// 카테고리명과 해당하는 이미지 파일명을 매핑하는 변수
final Map<String, String> midCategoryImageMap = {
  "티셔츠": "shirt_button.png",
  "블라우스": "blouse_button.png",
  "맨투맨": "mtm_button.png",
  "니트": "neat_button.png",
  "폴라티": "pola_button.png",
  "원피스": "onepiece_button.png",
  "팬츠": "pants_button.png",
  "청바지": "jean_button.png",
  "스커트": "skirt_button.png",
  "패딩": "paeding_button.png",
  "코트": "coat_button.png",
  "가디건": "cardigan_button.png"
};

// 홈 카테고리 버튼이 탭되었을 때 호출되는 함수
void onMidCategoryTap(BuildContext context, int index) {
  final List<Widget> midcategoryPages = [
    // 각 카테고리에 해당하는 페이지 위젯들을 리스트로 정의함.
    ShirtMainScreen(), BlouseMainScreen(), MtmMainScreen(), NeatMainScreen(),
    PolaMainScreen(), OnepieceMainScreen(), PantsMainScreen(), JeanMainScreen(),
    SkirtMainScreen(), PaedingMainScreen(), CoatMainScreen(), CardiganMainScreen(),
  ];

  // 네비게이터를 사용하여, 사용자가 선택한 카테고리에 해당하는 페이지로 화면을 전환함.
  // 여기서는 MaterialApp의 Navigator 기능을 사용하여 새로운 페이지로 이동함.
  Navigator.push(
    context, // 현재 컨텍스트
    MaterialPageRoute(builder: (context) => midcategoryPages[index]), // 선택된 카테고리에 해당하는 페이지로의 루트를 생성함.
  );
}

// ------ buildCommonMidGridCategoryButtons 위젯 내용 시작
// ------ 카테고리 12개를 선으로 구획나누고 표시한 부분 관련 위젯 구현 내용 시작
// 카테고리 버튼들을 그리드 형태로 표시하는 위젯
Widget buildCommonMidGridCategoryButtons(BuildContext context, void Function(BuildContext, int) onMidCategoryTap) {
  return GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(), // 스크롤이 불필요한 곳에서의 스크롤 방지
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // 한 줄에 표시될 아이템의 개수
      crossAxisSpacing: 1, // 가로 간격
      mainAxisSpacing: 1, // 세로 간격
      childAspectRatio: 3, // 아이템의 가로 세로 비율
    ),
    itemCount: midCategories.length, // 전체 카테고리 수
    itemBuilder: (context, index) {
      // 각 카테고리에 해당하는 버튼을 생성
      return GridTile(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey), // 테두리 색상 설정
          ),
          child: TextButton(
            onPressed: () => onMidCategoryTap(context, index), // 버튼 탭 시 처리
            child: Text(midCategories[index], style: TextStyle(color: Colors.black)), // 카테고리 이름 표시
          ),
        ),
      );
    },
  );
}
// ------ 카테고리 12개를 선으로 구획나누고 표시한 부분 관련 위젯 구현 내용 끝
// ------ buildCommonMidGridCategoryButtons 위젯 내용 끝

// ------ buildDetailMidCategoryButton 위젯 내용 시작
// 각 카테고리 버튼을 생성하는 위젯
Widget buildDetailMidCategoryButton({
  required BuildContext context, // 위젯 빌드에 필요한 컨텍스트
  required int index, // 카테고리의 인덱스
  required String category, // 카테고리 이름
  required void Function(BuildContext, int) onCategoryTap, // 카테고리 탭 시 실행될 함수
  required int? selectedCategoryIndex, // 선택된 카테고리 인덱스
  required double buttonWidth, // 버튼의 너비
  required WidgetRef ref,  // 상태 관리를 위한 WidgetRef 매개변수
}) {
  // 카테고리 이름을 기반으로 영어로 된 이미지 파일명을 찾아서 imageAsset 경로에 설정함.
  String imageAsset = 'asset/img/misc/${midCategoryImageMap[category]}'; // 해당 카테고리에 매핑된 이미지 파일의 경로.
  // 선택된 카테고리 인덱스와 현재 인덱스를 비교하여 선택 상태 결정
  bool isSelected = index ==selectedCategoryIndex ;

  return GestureDetector(
    onTap: () {
      ref.read(selectedCategoryProvider.notifier).state = index; // 클릭된 인덱스로 선택된 카테고리 인덱스를 업데이트
      onCategoryTap(context, index); // 해당 카테고리를 탭했을 때 실행할 함수 호출
    },
    child: Container(
        width: buttonWidth, // 매개변수로 받은 너비를 사용
        padding: EdgeInsets.all(5.0), // 모든 방향에 5.0의 패딩 설정
        decoration: BoxDecoration(
          color: Colors.white, // 배경색을 흰색으로 설정
          borderRadius: BorderRadius.circular(20), // 테두리를 둥글게 처리
          border: Border.all(color: isSelected ? LOGO_COLOR : Colors.grey, width: 2), // 선택 상태에 따라 테두리 색상 변경
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 컬럼 내부의 아이템들을 중앙에 위치시킴.
        children: <Widget>[
          AspectRatio( // 이미지의 원본 비율을 유지하는 AspectRatio 위젯 사용
            aspectRatio: 1.8, // 너비와 높이의 비율을 1:1로 설정
            child: Image.asset(imageAsset, fit: BoxFit.contain), // 이미지 파일을 보여줌
          ),
          SizedBox(height: 8), // 이미지와 텍스트 사이의 공간을 8로 설정함.
          Text(
            category, // 카테고리 이름 표시
            style: TextStyle(
              color: Colors.black, // 텍스트 색상
              fontSize: 12, // 텍스트 크기
            ),
            textAlign: TextAlign.center, // 텍스트를 중앙 정
          ),
        ],
      ),
    ),
  );
}
// ------ buildDetailMidCategoryButton 위젯 내용 끝
// ------ 카테고리 12개를 버튼 형식의 두줄로 표시한 부분 관련 위젯 구현 내용 끝

// ------ buildCommonBottomNavigationBar 위젯 내용 구현 시작
// BottomNavigationBar 생성 함수
// 공통 BottomNavigationBar 생성 함수. 선택된 항목에 따라 다른 화면으로 이동하도록 구현함.
Widget buildCommonBottomNavigationBar(int selectedIndex, WidgetRef ref, BuildContext context) {
  // 하단 네비게이션 바 위젯을 생성하고 반환
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed, // 네비게이션 바의 유형을 고정된 유형으로 설정
    currentIndex: selectedIndex, // 현재 선택된 인덱스
    onTap: (index) {
      // 탭이 클릭되었을 때 실행할 로직
      // 선택된 인덱스에 따라 상태 업데이트
      ref.read(tabIndexProvider.notifier).state = index; // 선택된 탭의 인덱스를 상태 관리자에 저장
      // 화면 전환 로직
      switch (index) { // 클릭된 탭의 인덱스에 따라 각기 다른 화면으로 이동
        case 0:
        // '홈' 화면으로 이동
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ShirtMainScreen()));
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
          leading: Image.asset('asset/img/misc/navercafe.logo.png', width: 24),
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
          leading: Image.asset('asset/img/misc/youtube.logo.png', width: 24),
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
          leading: Image.asset('asset/img/misc/instagram.logo.png', width: 24),
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
          leading: Image.asset('asset/img/misc/kakao.logo.png', width: 24),
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

// ------ pageViewWithArrows 위젯 내용 구현 시작
// PageView와 화살표 버튼을 포함하는 위젯
// 사용자가 페이지를 넘길 수 있도록 함.
Widget pageViewWithArrows(
    BuildContext context,
    PageController pageController, // 페이지 전환을 위한 컨트롤러
    WidgetRef ref, // Riverpod 상태 관리를 위한 ref
    StateProvider<int> currentPageProvider, { // 현재 페이지 인덱스를 관리하기 위한 StateProvider
      required IndexedWidgetBuilder itemBuilder, // 각 페이지를 구성하기 위한 함수
      required int itemCount, // 전체 페이지 수
    }) {
  int currentPage = ref.watch(currentPageProvider); // 현재 페이지 인덱스를 관찰
  return Stack(
    alignment: Alignment.center,
    children: [
      PageView.builder(
        controller: pageController, // 페이지 컨트롤러 할당
        itemCount: itemCount, // 페이지 수 설정
        onPageChanged: (index) {
          ref.read(currentPageProvider.notifier).state = index; // 페이지가 변경될 때마다 인덱스 업데이트
        },
        itemBuilder: itemBuilder, // 페이지를 구성하는 위젯을 생성
      ),
      // 왼쪽 화살표 버튼. 첫 페이지가 아닐 때만 활성화됩니다.
      arrowButton(context, Icons.arrow_back_ios, currentPage > 0,
              () => pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut), currentPageProvider, ref),
      // 오른쪽 화살표 버튼. 마지막 페이지가 아닐 때만 활성화됩니다.
      // 현재 페이지 < 전체 페이지 수 - 1 의 조건으로 변경하여 마지막 페이지 검사를 보다 정확하게 합니다.
      arrowButton(context, Icons.arrow_forward_ios, currentPage < itemCount - 1,
              () => pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut), currentPageProvider, ref),
    ],
  );
}
// ------ pageViewWithArrows 위젯 내용 구현 끝

// ------ arrowButton 위젯 내용 구현 시작
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
// ------ arrowButton 위젯 내용 구현 끝

Widget buildBannerPageView({
  required WidgetRef ref, // BuildContext 대신 WidgetRef를 사용, ref를 매개변수(인자)로 받음.
  required PageController pageController, // 페이지 컨트롤러
  required int itemCount, // 배너 아이템(이미지)의 총 개수
  required IndexedWidgetBuilder itemBuilder, // 각 배너 아이템을 구성하는 위젯 빌더
  required StateProvider<int> currentPageProvider, // 현재 페이지 인덱스를 관리하는 상태 프로바이더
  required BuildContext context, // 현재 컨텍스트
}) {
  // 배너 클릭 시 이동할 URL 리스트
  final List<String> bannerLinks = [
    'https://www.naver.com',
    'https://www.youtube.com',
    // 여기서는 'https://www.coupang.com' 주석 처리되어 있음
  ];

  return Stack(
    children: [
      PageView.builder(
        controller: pageController, // 페이지 뷰 컨트롤러 할당
        itemCount: itemCount, // 아이템(배너)의 총 개수 설정
        onPageChanged: (index) {
          // 페이지가 변경될 때 호출되는 콜백 함수
          // 여기서 현재 페이지 상태를 업데이트합니다.
          ref.read(currentPageProvider.notifier).state = index; // 현재 페이지 인덱스 업데이트
        },
        itemBuilder: (context, index) => GestureDetector(
          onTap: () async {
            // 각 배너를 탭(클릭)했을 때의 동작
            if (index == 2) {
              // 인덱스 2(세 번째 배너)의 경우 특별한 페이지로 이동
              Navigator.push(context, MaterialPageRoute(builder: (context) => const BlouseMainScreen()));
            } else {
              // 나머지 배너는 지정된 URL로 이동
              final url = bannerLinks[index]; // 해당 인덱스의 URL 가져오기
              if (await canLaunchUrl(Uri.parse(url))) {
                // URL을 실행할 수 있는지 확인 후 실행
                await launchUrl(Uri.parse(url));
              } else {
                // 실행할 수 없는 경우 에러 메시지 표시
                throw 'Could not launch $url';
              }
            }
          },
          child: itemBuilder(context, index), // 원래 정의된 아이템 빌더를 사용하여 배너 아이템 위젯 생성
          // ------ buildBannerPageView 위젯 내용 구현 시작
// 배너 페이지뷰 UI 위젯
        ),
      ),
      Positioned(
        right: 40,
        bottom: 10,
        child: Consumer(
          builder: (context, ref, child) {
            final currentPage = ref.watch(currentPageProvider); // 현재 페이지 인덱스를 감시
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${currentPage + 1} / $itemCount', // 현재 페이지 번호와 총 페이지 수 표시
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    ],
  );
}
// ------ buildBannerPageView 위젯 내용 구현 끝

// ------ buildFirestoreDetailDocument 위젯 내용 구현 시작
// Firestore 데이터를 기반으로 세부 정보를 표시하는 위젯.
// 각 문서의 세부 정보를 UI에 표시함.
Widget buildFirestoreDetailDocument(WidgetRef ref, String docId, String category, BuildContext context) {
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
            // 카테고리에 따라 다른 상세 화면으로 이동
            switch (category) {
              case '티셔츠':
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        ShirtDetailProductScreen(docId: docId)))
                    .then((_) {
                  // 디테일 화면에서 선택한 '색상'과 '사이즈' 데이터 상태를 다른 화면에 갔다가 다시 돌아올 시, 초기화하는 로직을 실행
                  ref
                      .read(colorSelectionIndexProvider.state)
                      .state = null;
                  ref
                      .read(sizeSelectionProvider.state)
                      .state = null;
                });
                break;
              case '블라우스':
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        BlouseDetailProductScreen(docId: docId)))
                    .then((_) {
                  // 디테일 화면에서 선택한 '색상'과 '사이즈' 데이터 상태를 다른 화면에 갔다가 다시 돌아올 시, 초기화하는 로직을 실행
                  ref
                      .read(colorSelectionIndexProvider.state)
                      .state = null;
                  ref
                      .read(sizeSelectionProvider.state)
                      .state = null;
                });
                break;
              case '맨투맨':
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        MtmDetailProductScreen(docId: docId)))
                    .then((_) {
                  // 디테일 화면에서 선택한 '색상'과 '사이즈' 데이터 상태를 다른 화면에 갔다가 다시 돌아올 시, 초기화하는 로직을 실행
                  ref
                      .read(colorSelectionIndexProvider.state)
                      .state = null;
                  ref
                      .read(sizeSelectionProvider.state)
                      .state = null;
                });
                break;
              case '니트':
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        NeatDetailProductScreen(docId: docId)))
                    .then((_) {
                  // 디테일 화면에서 선택한 '색상'과 '사이즈' 데이터 상태를 다른 화면에 갔다가 다시 돌아올 시, 초기화하는 로직을 실행
                  ref
                      .read(colorSelectionIndexProvider.state)
                      .state = null;
                  ref
                      .read(sizeSelectionProvider.state)
                      .state = null;
                });
                break;
              case '폴라티':
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        PolaDetailProductScreen(docId: docId)))
                    .then((_) {
                  // 디테일 화면에서 선택한 '색상'과 '사이즈' 데이터 상태를 다른 화면에 갔다가 다시 돌아올 시, 초기화하는 로직을 실행
                  ref
                      .read(colorSelectionIndexProvider.state)
                      .state = null;
                  ref
                      .read(sizeSelectionProvider.state)
                      .state = null;
                });
                break;
              case '원피스':
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        OnepieceDetailProductScreen(docId: docId)))
                    .then((_) {
                  // 디테일 화면에서 선택한 '색상'과 '사이즈' 데이터 상태를 다른 화면에 갔다가 다시 돌아올 시, 초기화하는 로직을 실행
                  ref
                      .read(colorSelectionIndexProvider.state)
                      .state = null;
                  ref
                      .read(sizeSelectionProvider.state)
                      .state = null;
                });
                break;
              case '팬츠':
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        PantsDetailProductScreen(docId: docId)))
                    .then((_) {
                  // 디테일 화면에서 선택한 '색상'과 '사이즈' 데이터 상태를 다른 화면에 갔다가 다시 돌아올 시, 초기화하는 로직을 실행
                  ref
                      .read(colorSelectionIndexProvider.state)
                      .state = null;
                  ref
                      .read(sizeSelectionProvider.state)
                      .state = null;
                });
                break;
              case '청바지':
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        JeanDetailProductScreen(docId: docId)))
                    .then((_) {
                  // 디테일 화면에서 선택한 '색상'과 '사이즈' 데이터 상태를 다른 화면에 갔다가 다시 돌아올 시, 초기화하는 로직을 실행
                  ref
                      .read(colorSelectionIndexProvider.state)
                      .state = null;
                  ref
                      .read(sizeSelectionProvider.state)
                      .state = null;
                });
                break;
              case '스커트':
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        SkirtDetailProductScreen(docId: docId)))
                    .then((_) {
                  // 디테일 화면에서 선택한 '색상'과 '사이즈' 데이터 상태를 다른 화면에 갔다가 다시 돌아올 시, 초기화하는 로직을 실행
                  ref
                      .read(colorSelectionIndexProvider.state)
                      .state = null;
                  ref
                      .read(sizeSelectionProvider.state)
                      .state = null;
                });
                break;
              case '패딩':
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        PaedingDetailProductScreen(docId: docId)))
                    .then((_) {
                  // 디테일 화면에서 선택한 '색상'과 '사이즈' 데이터 상태를 다른 화면에 갔다가 다시 돌아올 시, 초기화하는 로직을 실행
                  ref
                      .read(colorSelectionIndexProvider.state)
                      .state = null;
                  ref
                      .read(sizeSelectionProvider.state)
                      .state = null;
                });
                break;
              case '코트':
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        CoatDetailProductScreen(docId: docId)))
                    .then((_) {
                  // 디테일 화면에서 선택한 '색상'과 '사이즈' 데이터 상태를 다른 화면에 갔다가 다시 돌아올 시, 초기화하는 로직을 실행
                  ref
                      .read(colorSelectionIndexProvider.state)
                      .state = null;
                  ref
                      .read(sizeSelectionProvider.state)
                      .state = null;
                });
                break;
              case '가디건':
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        CardiganDetailProductScreen(docId: docId)))
                    .then((_) {
                  // 디테일 화면에서 선택한 '색상'과 '사이즈' 데이터 상태를 다른 화면에 갔다가 다시 돌아올 시, 초기화하는 로직을 실행
                  ref
                      .read(colorSelectionIndexProvider.state)
                      .state = null;
                  ref
                      .read(sizeSelectionProvider.state)
                      .state = null;
                });
                break;
            }
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
// ------ buildFirestoreDetailDocument 위젯 내용 구현 끝

// ------ buildHorizontalDocumentsList 위젯 내용 구현 시작
// buildHorizontalDocumentsList 함수에서 Document 클릭 시 동작 추가
// 가로로 스크롤 가능한 문서 리스트를 생성하는 함수. 문서 클릭 시 설정된 동작을 실행함.
Widget buildHorizontalDocumentsList(WidgetRef ref, List<String> documentIds, String category, BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal, // 가로 스크롤 설정
    child: Row(
      children: documentIds.map((docId) => buildFirestoreDetailDocument(ref, docId, category, context)).toList(),
    ),
  );
}
// ------ buildHorizontalDocumentsList 위젯 내용 구현 끝

// ------- 상단 탭 바 버튼 관련 섹션을 구현한 위젯 내용 구현 시작
// 신상 섹션을 위젯으로 구현한 부분
Align buildNewProductsSection() {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: EdgeInsets.only(left: 16),
      child: Text(
        '신상',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

// 최고 섹션을 위젯으로 구현한 부분
Align buildBestProductsSection() {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: EdgeInsets.only(left: 16),
      child: Text(
        '최고',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

// 할인 섹션을 위젯으로 구현한 부분
Align buildDiscountProductsSection() {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: EdgeInsets.only(left: 16),
      child: Text(
        '할인',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

// 봄 섹션을 위젯으로 구현한 부분.
Align buildSpringProductsSection() {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: EdgeInsets.only(left: 16),
      child: Text(
        '봄',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

// 여름 섹션을 위젯으로 구현한 부분
Align buildSummerProductsSection() {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: EdgeInsets.only(left: 16),
      child: Text(
        '여름',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

// 가을 섹션을 위젯으로 구현한 부분
Align buildAutumnProductsSection() {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: EdgeInsets.only(left: 16),
      child: Text(
        '가을',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

// 겨울 섹션을 위젯으로 구현한 부분
Align buildWinterProductsSection() {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: EdgeInsets.only(left: 16),
      child: Text(
        '겨울',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
// ------- 상단 탭 바 버튼 관련 섹션을 구현한 위젯 내용 구현 끝



