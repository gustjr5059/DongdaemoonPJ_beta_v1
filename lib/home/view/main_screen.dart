// 메인 화면 정의
import 'package:dongdaemoon_beta_v1/home/view/shirt_main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'blouse_main_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품 카테고리'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          ShirtMainScreen(),   // 티셔츠 메인 화면
          BlouseMainScreen(),  // 블라우스 메인 화면
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_one),
            label: '티셔츠',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_two),
            label: '블라우스',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}