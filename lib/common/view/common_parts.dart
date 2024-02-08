import 'package:dongdaemoon_beta_v1/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../home/view/home_screen.dart';
import '../../order/view/order_screen.dart';
import '../../product/view/product_screen.dart';
import '../../user/view/profile_screen.dart';
import '../const/colors.dart';
import '../provider/tab_index_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// GlobalKey 사용 제거
// final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

// AppBar 생성 함수에서 GlobalKey 사용 제거
AppBar buildCommonAppBar(String title, BuildContext context) {
  return AppBar(
    title: Text(title),
    leading: Builder( // Builder 위젯 사용
      builder: (BuildContext context) {
        return IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        );
      },
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          // 검색 기능 로직
        },
      ),
    ],
  );
}



// BottomNavigationBar 생성 함수
Widget buildCommonBottomNavigationBar(int selectedIndex, WidgetRef ref, BuildContext context) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: selectedIndex,
    onTap: (index) {
      // 상태 업데이트
      ref.read(tabIndexProvider.notifier).state = index;
      // 화면 전환 로직
      switch (index) {
        case 0:
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
          break;
        case 1:
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ProductScreen()));
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
      BottomNavigationBarItem(icon: Icon(Icons.checkroom_outlined), label: '옷'),
      BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: '주문'),
      BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: '프로필'),
    ],
    selectedItemColor: PRIMARY_COLOR,
    unselectedItemColor: BODY_TEXT_COLOR,
    selectedFontSize: 10,
    unselectedFontSize: 10,
  );
}

// 카테고리 리스트 생성 함수
Widget buildCategoryList(Function(int) onCategoryTap) {
  return Container(
    height: 60,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 12, // 예시 카테고리 수
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onCategoryTap(index),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('카테고리 ${index + 1}'),
          ),
        );
      },
    ),
  );
}

// 드로워 생성 함수
Widget buildCommonDrawer(BuildContext context) {
  final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'No Email';
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(color: BUTTON_COLOR),
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
            await FirebaseAuth.instance.signOut();
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
