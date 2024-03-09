import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongdaemoon_beta_v1/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../home/view/home_screen.dart';
import '../../order/view/order_screen.dart';
import '../../product/view/cart_screen.dart';
import '../../user/view/profile_screen.dart';
import '../const/colors.dart';
import '../layout/best_layout.dart';
import '../layout/concept1_layout.dart';
import '../layout/concept2_layout.dart';
import '../layout/concept3_layout.dart';
import '../layout/couple_layout.dart';
import '../layout/new_layout.dart';
import '../layout/sale_layout.dart';
import '../layout/season_layout.dart';
import '../provider/state_provider.dart';
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

// TopBar의 카테고리 리스트를 생성하는 함수를 재작성
Widget buildTopBarList(BuildContext context, void Function(int) onTopBarTap) {
  final List<String> topBarCategories = [
    "NEW", "BEST", "SALE", "시즌룩", "커플룩", "컨셉1", "컨셉2", "컨셉3"
  ];

  void onTopBarTap(int index) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLayout()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const BestLayout()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SaleLayout()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SeasonLayout()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CoupleLayout()));
        break;
      case 5:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Concept1Layout()));
        break;
      case 6:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Concept2Layout()));
        break;
      case 7:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Concept3Layout()));
        break;
    }
  }

  return SizedBox(
    height: 60, // 적절한 높이 설정
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: topBarCategories.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onTopBarTap(index),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(child: Text(topBarCategories[index])),
          ),
        );
      },
    ),
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
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => CartScreen()));
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
      BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: '장바구니'),
      BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: '주문'),
      BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: '마이페이지'),
    ],
    selectedItemColor: PRIMARY_COLOR,
    unselectedItemColor: BODY_TEXT_COLOR,
    selectedFontSize: 10,
    unselectedFontSize: 10,
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
          decoration: BoxDecoration(color: DRAWER_COLOR),
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

// firestore 데이터별 세부 UI 구현 위젯
Widget buildFirestoreDetailDocument(WidgetRef ref, String docId) {
  final asyncValue = ref.watch(firestoreDataProvider(docId));

  return asyncValue.when(
    data: (DocumentSnapshot snapshot) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        // 데이터를 사용하여 UI 위젯 구성
        return Container(
          width: 180, // 각 문서의 UI 컨테이너 너비 설정
          margin: EdgeInsets.all(8), // 주변 여백 설정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트와 색상 이미지들을 왼쪽으로 정렬
            children: [
              if (data['thumbnails'] != null)
                Center( // thumbnails 이미지를 중앙에 배치
                  child: Image.network(data['thumbnails'], width: 90, fit: BoxFit.cover),// width: 90 : 전체인 Container 180 너비 중 thumbnails가 90 차지하도록 설정
                ),
              SizedBox(height: 10), // thumbnails와 clothes_color 사이의 간격 설정
              // 색상 이미지 URL 처리
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
                    : Container())
                    .toList(),
              ),
              if (data['brief_introduction'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    data['brief_introduction'],
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              if (data['original_price'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "${data['original_price']}",
                    style: TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough),
                  ),
                ),
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
        );
      } else {
        return Text("데이터 없음");
      }
    },
    loading: () => CircularProgressIndicator(),
    error: (error, stack) => Text("오류 발생: $error"),
  );
}

// firestore 데이터의 문서를 가로로 배열하여 구현되도록 하는 위젯
Widget buildHorizontalDocumentsList(WidgetRef ref, List<String> documentIds) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: documentIds.map((docId) => buildFirestoreDetailDocument(ref, docId)).toList(),
    ),
  );
}


