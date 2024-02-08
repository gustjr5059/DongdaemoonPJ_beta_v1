import 'package:dongdaemoon_beta_v1/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../const/colors.dart';
import '../provider/tab_index_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// GlobalKey 선언
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

// AppBar 생성 함수
AppBar buildCommonAppBar(String title) {
  return AppBar(
    title: Text(title),
    leading: IconButton(
      icon: Icon(Icons.menu),
      // GlobalKey를 사용하여 Scaffold의 상태에 접근
      onPressed: () => scaffoldKey.currentState?.openDrawer(),
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
Widget buildCommonBottomNavigationBar(int selectedIndex, WidgetRef ref) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: selectedIndex,
    onTap: (index) => ref.read(tabIndexProvider.notifier).state = index,
    items: [
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
