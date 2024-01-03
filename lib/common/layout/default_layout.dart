import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    this.floatingActionButton,
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Dongdaemoon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
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
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }

  // AppBar buildAppBar(BuildContext context) {
  //   return AppBar(
  //     title: title != null ? Text(title!) : null,
  //     leading: IconButton(
  //       icon: Icon(Icons.menu),
  //       onPressed: () { Scaffold.of(context).openDrawer();
  //         },
  //     ),
  //     actions: [
  //       IconButton(
  //         icon: Icon(Icons.search),
  //         onPressed: () {
  //           // Logic for search action
  //         },
  //       ),
  //     ],
  //   );
  // }
  //
  // Drawer buildDrawer() {
  //   return Drawer(
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: <Widget>[
  //         DrawerHeader(
  //           decoration: BoxDecoration(
  //             color: Colors.blue,
  //           ),
  //           child: Text(
  //             'Drawer Header',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 24,
  //             ),
  //           ),
  //         ),
  //         ListTile(
  //           leading: Icon(Icons.message),
  //           title: Text('Messages'),
  //         ),
  //         ListTile(
  //           leading: Icon(Icons.account_circle),
  //           title: Text('Profile'),
  //         ),
  //         ListTile(
  //           leading: Icon(Icons.settings),
  //           title: Text('Settings'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
