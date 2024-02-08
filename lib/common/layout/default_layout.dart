//
//
// import 'package:dongdaemoon_beta_v1/common/const/colors.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import 'category1_layout.dart';
// import '../../user/view/login_screen.dart';
//
// class DefaultLayout extends StatelessWidget {
//   final Color? backgroundColor;
//   final Widget child;
//   final String? title;
//   final Widget? bottomNavigationBar;
//   final Widget? floatingActionButton;
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   final String userEmail; // Added to accept user email
//
//   DefaultLayout({
//     required this.child,
//     this.backgroundColor,
//     this.title,
//     this.bottomNavigationBar,
//     this.floatingActionButton,
//     required this.userEmail, // Make userEmail required
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey, // Scaffold에 key 할당
//       backgroundColor: backgroundColor ?? Colors.white,
//       appBar: AppBar(
//         title: title != null ? Text(title!) : null,
//         leading: IconButton(
//           icon: Icon(Icons.menu),
//           onPressed: () => scaffoldKey.currentState!.openDrawer(), // 드로워 열기
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               // 검색 버튼 로직
//             },
//           ),
//         ],
//       ),
//
//       body: Column( // Column 위젯으로 body의 자식들을 감싸줍니다.
//         children: [
//           _buildCategoryList(context), // 카테고리 리스트를 body의 첫 번째 자식으로 추가
//           Expanded( // 나머지 공간을 차지하도록 child를 Expanded로 감싸줍니다.
//             child: child,
//           ),
//         ],
//       ),
//       drawer: _buildDrawer(context),
//       bottomNavigationBar: bottomNavigationBar,
//       floatingActionButton: floatingActionButton,
//     );
//   }
//
//   Widget _buildCategoryList(BuildContext context) {
//     return Container(
//       height: 60,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: 12,
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: () {
//               if (index == 0) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => Category1Layout()),
//                 );
//               }
//               // 추가 카테고리에 대한 로직 구현 필요
//             },
//             child: Container(
//               alignment: Alignment.center,
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Text('카테고리 ${index + 1}'),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildDrawer(BuildContext context) {
//       return Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: BUTTON_COLOR,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Dongdaemoon',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     userEmail, // Display user email
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Logout'),
//               onTap: () async {
//                 await FirebaseAuth.instance.signOut(); // Sign out from Firebase
//                 Navigator.of(context).pushReplacement( // Navigate to login screen
//                   MaterialPageRoute(builder: (context) => LoginScreen()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.account_circle),
//               title: Text('Profile'),
//             ),
//             ListTile(
//               leading: Icon(Icons.group),
//               title: Text('Communities'),
//             ),
//             ListTile(
//               leading: Icon(Icons.message),
//               title: Text('Q&A'),
//             ),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text('Settings'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
