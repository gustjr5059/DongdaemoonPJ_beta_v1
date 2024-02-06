import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/view/home_screen.dart';
import '../../order/view/order_screen.dart';
import '../../product/view/product_screen.dart';
import '../../user/view/profile_screen.dart';
import '../const/colors.dart';
import '../provider/tab_index_provider.dart';
import 'default_layout.dart';

class Category1Layout extends ConsumerWidget {
  const Category1Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 탭 인덱스 상태를 관찰합니다.
    final tabIndex = ref.watch(tabIndexProvider);

    // 사용자 이메일을 가져옵니다.
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'No Email';

    return DefaultLayout(
      userEmail: userEmail,
      title: '카테고리 1',
      child: IndexedStack(
        index: tabIndex,
        children: [
          HomeScreen(),
          ProductScreen(),
          OrderScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: tabIndex,
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
      ),
    );
  }
}