// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import '../../common/const/colors.dart';
// import '../../home/view/home_screen.dart';
// import '../../order/view/order_screen.dart';
// import '../../product/view/product_screen.dart';
// import '../../user/view/profile_screen.dart';
// import '../../user/view/login_screen.dart';
//
// class RootLayout extends StatefulWidget {
//   static String get routeName => 'home';
//
//   const RootLayout({Key? key}) : super(key: key);
//
//   @override
//   State<RootLayout> createState() => _RootLayoutState();
// }
//
// class _RootLayoutState extends State<RootLayout> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   int _selectedIndex = 0;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         _selectedIndex = _tabController.index;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'No Email';
//
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: Text('Dongdaemoon'),
//         leading: IconButton(
//           icon: Icon(Icons.menu),
//           onPressed: () => _scaffoldKey.currentState!.openDrawer(),
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
//       drawer: _buildDrawer(context, userEmail),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           HomeScreen(),
//           ProductScreen(),
//           OrderScreen(),
//           ProfileScreen(),
//           // 다른 탭의 내용도 필요에 따라 수정
//         ],
//       ),
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }
//
//   Widget _buildDrawer(BuildContext context, String userEmail) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             decoration: BoxDecoration(color: BUTTON_COLOR),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Dongdaemoon', style: TextStyle(color: Colors.white, fontSize: 24)),
//                 SizedBox(height: 10),
//                 Text(userEmail, style: TextStyle(color: Colors.white, fontSize: 16)),
//               ],
//             ),
//           ),
//           _buildDrawerItem(Icons.logout, 'Logout', () async {
//             await FirebaseAuth.instance.signOut();
//             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
//           }),
//           _buildDrawerItem(Icons.account_circle, 'Profile', () {}),
//           _buildDrawerItem(Icons.group, 'Communities', () {}),
//           _buildDrawerItem(Icons.message, 'Q&A', () {}),
//           _buildDrawerItem(Icons.settings, 'Settings', () {}),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(title),
//       onTap: onTap,
//     );
//   }
//
//   Widget _buildBottomNavigationBar() {
//     return BottomNavigationBar(
//       selectedItemColor: PRIMARY_COLOR,
//       unselectedItemColor: BODY_TEXT_COLOR,
//       selectedFontSize: 10,
//       unselectedFontSize: 10,
//       type: BottomNavigationBarType.fixed,
//       onTap: (int index) {
//         setState(() {
//           _selectedIndex = index;
//           _tabController.animateTo(index);
//         });
//       },
//       currentIndex: _selectedIndex,
//       items: [
//         BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
//         BottomNavigationBarItem(icon: Icon(Icons.checkroom_outlined), label: '옷'),
//         BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: '주문'),
//         BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: '프로필'),
//       ],
//     );
//   }
// }
