import 'package:dongdaemoon_beta_v1/common/const/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../user/view/login_screen.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final String userEmail; // Added to accept user email

  DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    this.floatingActionButton,
    required this.userEmail, // Make userEmail required
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // Scaffold에 key 할당
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: AppBar(
        title: title != null ? Text(title!) : null,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState!.openDrawer(), // 드로워 열기
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 검색 버튼 로직
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // 카테고리 리스트
          Container(
            height: 60, // 높이 설정
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // 수평 스크롤 설정
              itemCount: 12, // 카테고리 수
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('카테고리 ${index + 1}'),
                );
              },
            ),
          ),
          Expanded(
            child: child, // 나머지 화면 콘텐츠
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: BUTTON_COLOR,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dongdaemoon',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    userEmail, // Display user email
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut(); // Sign out from Firebase
                Navigator.of(context).pushReplacement( // Navigate to login screen
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
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
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
