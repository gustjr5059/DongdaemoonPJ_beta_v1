// Firebase의 사용자 인증 기능을 사용하기 위한 패키지를 임포트합니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Flutter의 기본 디자인과 인터페이스 요소들을 사용하기 위한 Material 패키지를 임포트합니다.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Riverpod 패키지를 사용한 상태 관리 기능을 추가합니다. Riverpod는 상태 관리를 위한 외부 패키지입니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// 외부 웹사이트나 애플리케이션 링크를 열기 위한 URL Launcher 패키지를 임포트합니다.
import 'package:url_launcher/url_launcher.dart';

// 애플리케이션 내 쇼핑 카트 화면 관련 파일을 임포트합니다.
import '../../cart/layout/cart_body_parts_layout.dart';
import '../../cart/provider/cart_state_provider.dart';
import '../../cart/view/cart_screen.dart';

// 애플리케이션의 메인 홈 화면을 구성하는 파일을 임포트합니다.
import '../../home/provider/home_state_provider.dart';
import '../../home/view/home_screen.dart';

// 주문 관련 화면을 구현한 파일을 임포트합니다.
import '../../order/provider/order_state_provider.dart';
import '../../order/view/order_list_screen.dart';

// 사용자 로그인 화면을 구현한 파일을 임포트합니다.
import '../../order/view/order_screen.dart';
import '../../product/layout/product_body_parts_layout.dart';
import '../../product/model/product_model.dart';
import '../../product/provider/product_state_provider.dart';
import '../../user/provider/profile_state_provider.dart';
import '../../user/view/login_screen.dart';

// 사용자 프로필 화면을 구현한 파일을 임포트합니다.
import '../../user/view/profile_screen.dart';

// 다양한 색상을 정의하는 파일을 임포트합니다.
import '../../wishlist/view/wishlist_screen.dart';
import '../const/colors.dart';

// 애플리케이션의 공통적인 상태 관리 로직을 포함하는 파일을 임포트합니다.
import '../provider/common_state_provider.dart';

import 'dart:io' show Platform;


// 상태표시줄 색상을 안드로이드와 ios 버전에 맞춰서 변경하는데 사용되는 함수-앱 실행 생명주기에 맞춰서 변경
void updateStatusBar() {
  // Color statusBarColor = BUTTON_COLOR; // 여기서 원하는 색상을 지정

  if (Platform.isAndroid) {
    // 안드로이드에서는 상태표시줄 색상을 직접 지정
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // statusBarColor: statusBarColor,
      statusBarIconBrightness: Brightness.light,
    ));
  } else if (Platform.isIOS) {
    // iOS에서는 앱 바 색상을 통해 상태표시줄 색상을 간접적으로 조정
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light, // 밝은 아이콘 사용
    ));
  }
}

// ------ AppBar 생성 함수 내용 구현 시작
// 공통 앱 바
AppBar buildCommonAppBar({
  required BuildContext
      context, // BuildContext를 필수 인자로 받고, 각종 위젯에서 위치 정보 등을 제공받음.
  required WidgetRef ref, // WidgetRef를 필수 인자로 받음.
  required String title, // AppBar에 표시될 제목을 문자열로 받음.
  required double appBarTitleWidth,
  required double appBarTitleHeight,
  required double appBarTitleX,
  required double appBarTitleY,
  double? drawerIconWidth,
  double? drawerIconHeight,
  double? drawerIconX,
  double? drawerIconY,
  double? chevronIconWidth,
  double? chevronIconHeight,
  double? chevronIconX,
  double? chevronIconY,
  double? wishlistBtnWidth,
  double? wishlistBtnHeight,
  double? wishlistBtnX,
  double? wishlistBtnY,
  double? homeBtnWidth,
  double? homeBtnHeight,
  double? homeBtnX,
  double? homeBtnY,
  double? cartlistBtnWidth,
  double? cartlistBtnHeight,
  double? cartlistBtnX,
  double? cartlistBtnY,
  LeadingType leadingType =
      LeadingType.drawer, // 왼쪽 상단 버튼 유형을 결정하는 열거형, 기본값은 드로어 버튼.
  int buttonCase = 1, // 버튼 구성을 선택하기 위한 매개변수 추가
}) {

  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 세로 852
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정

  // 앱 바 내 title 글자 크기
  final double titleFontSize = screenSize.height * (17 / referenceHeight); // 텍스트 크기

  // ----- 앱 바 부분 수치 시작 부분
  final double appBarHeight =
      screenSize.height * (44 / referenceHeight); // 세로 비율

  // 왼쪽 상단에 표시될 위젯을 설정함.
  Widget? leadingWidget;
  switch (leadingType) {
  // 이전 화면으로 이동 버튼인 경우
    case LeadingType.back:
      if (chevronIconWidth != null &&
          chevronIconHeight != null &&
          chevronIconX != null &&
          chevronIconY != null) {
        leadingWidget = Container(
          width: chevronIconWidth,
          height: chevronIconHeight,
          margin: EdgeInsets.only(left: chevronIconX, top: chevronIconY),
          // 아이콘 위치 설정
          child: IconButton(
            icon: Icon(Icons.chevron_left),
            // 뒤로 가기 아이콘을 설정
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop(); // 페이지 스택이 존재하면 이전 페이지로 돌아감.
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        '이전 화면으로 이동할 수 없습니다.') // 이전 페이지로 돌아갈 수 없다는 메시지 표시
                ));
              }
            },
          ),
        );
      }
      break;
  // 드로워화면 버튼인 경우
    case LeadingType.drawer:
      if (drawerIconWidth != null &&
          drawerIconHeight != null &&
          drawerIconX != null &&
          drawerIconY != null) {
        leadingWidget = Container(
          width: drawerIconWidth,
          height: drawerIconHeight,
          margin: EdgeInsets.only(left: drawerIconX, top: drawerIconY),
          // 아이콘 위치 설정
          child: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu, size: drawerIconHeight), // 메뉴 아이콘 크기 설정
                onPressed: () =>
                    Scaffold.of(context).openDrawer(), // 버튼을 누르면 드로어 메뉴를 열게됨.
              );
            },
          ),
        );
      }
      break;
  // 버튼이 없는 경우
    case LeadingType.none:
      leadingWidget = null; // 아무런 위젯도 표시하지 않음.
      break;
  }

  // 버튼 구성을 결정하는 로직
  List<Widget> actions = [];
  switch (buttonCase) {
    case 1:
      // 케이스 1: 아무 내용도 없음
      //   actions.add(Container(width: 48)); // 빈 공간 추가
      break;
    case 2:
      // 케이스 2: 찜 목록 버튼만 노출
      if (wishlistBtnWidth != null &&
          wishlistBtnHeight != null &&
          wishlistBtnX != null &&
          wishlistBtnY != null) {
        actions.add(
          Container(
            width: wishlistBtnWidth,
            height: wishlistBtnHeight,
            margin: EdgeInsets.only(
                right: wishlistBtnX,
                top: wishlistBtnY
            ), // 찜 목록 버튼의 위치 설정
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.black),
              // 찜 목록 아이콘을 사용함.
              // WishlistMainScreen()을 tabIndex=4로 한 것은 BottomNavigationBar에는 해당 버튼을 생성하지는 않았으므로
              // 단순히 찜 목록 화면으로 이동할 때의 고유한 식별자 역할을 하는 인덱스 값이며, 상태 관리 로직에서는 다른 화면과 구분되기 위해 사용함.
              // 그래서, 홈:0, 장바구니:1, 발주내역:2, 마이페이지:3의 숫자를 피해서 적용
              onPressed: () =>
                  navigateToScreenAndRemoveUntil(
                      context, ref, WishlistMainScreen(), 4), // 찜 목록 화면으로 이동
            ),
          ),
        );
      }
      break;
    case 3:
      // 케이스 3: 찜 목록 버튼, 홈 버튼 노출
      if (wishlistBtnWidth != null &&
          wishlistBtnHeight != null &&
          wishlistBtnX != null &&
          wishlistBtnY != null &&
          homeBtnWidth != null &&
          homeBtnHeight != null &&
          homeBtnX != null &&
          homeBtnY != null) {
        actions.addAll([
          // 찜 목록 버튼
          Container(
            width: wishlistBtnWidth,
            height: wishlistBtnHeight,
            margin: EdgeInsets.only(
              right: wishlistBtnX,
              top: wishlistBtnY,
            ),
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () =>
                  navigateToScreenAndRemoveUntil(
                      context, ref, WishlistMainScreen(), 4), // 찜 목록 화면으로 이동
            ),
          ),
          // 홈 버튼
          Container(
            width: homeBtnWidth,
            height: homeBtnHeight,
            margin: EdgeInsets.only(
              right: homeBtnX,
              top: homeBtnY,
            ),
            child: IconButton(
              icon: Icon(Icons.home_outlined, color: Colors.black),
              onPressed: () =>
                  navigateToScreenAndRemoveUntil(
                      context, ref, HomeMainScreen(), 0), // 홈 화면으로 이동
            ),
          ),
        ]);
      }
      break;
    case 4:
    // 케이스 4: 찜 목록 버튼, 홈 버튼, 장바구니 버튼 노출
      if (wishlistBtnWidth != null &&
          wishlistBtnHeight != null &&
          wishlistBtnX != null &&
          wishlistBtnY != null &&
          homeBtnWidth != null &&
          homeBtnHeight != null &&
          homeBtnX != null &&
          homeBtnY != null &&
          cartlistBtnWidth != null &&
          cartlistBtnHeight != null &&
          cartlistBtnX != null &&
          cartlistBtnY != null) {
        actions.addAll([
          // 찜 목록 버튼
          Container(
            width: wishlistBtnWidth,
            height: wishlistBtnHeight,
            margin: EdgeInsets.only(
              right: wishlistBtnX,
              top: wishlistBtnY,
            ),
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () =>
                  navigateToScreenAndRemoveUntil(
                      context, ref, WishlistMainScreen(), 4), // 찜 목록 화면으로 이동
            ),
          ),
          // 홈 버튼
          Container(
            width: homeBtnWidth,
            height: homeBtnHeight,
            margin: EdgeInsets.only(
              right: homeBtnX,
              top: homeBtnY,
            ),
            child: IconButton(
              icon: Icon(Icons.home_outlined, color: Colors.black),
              onPressed: () =>
                  navigateToScreenAndRemoveUntil(
                      context, ref, HomeMainScreen(), 0), // 홈 화면으로 이동
            ),
          ),
          // 장바구니 버튼
          Container(
            width: cartlistBtnWidth,
            height: cartlistBtnHeight,
            margin: EdgeInsets.only(
              right: cartlistBtnX,
              top: cartlistBtnY,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart_outlined, color: Colors.black),
              onPressed: () =>
                  navigateToScreenAndRemoveUntil(
                      context, ref, CartMainScreen(), 1), // 장바구니 화면으로 이동
            ),
          ),
        ]);
      }
      break;
  }

  // AppBar를 반환
  return AppBar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
    // 앱 바 배경 색상 : 앱 기본 배경색
    // AppBar 색상 설정
    toolbarHeight: appBarHeight, // 앱 바의 높이를 설정
    title: Container(
      // alignment: Alignment.center,
      width: appBarTitleWidth, // 텍스트 너비 설정
      height: appBarTitleHeight, // 텍스트 높이 설정
      margin: EdgeInsets.only(left: appBarTitleX, top: appBarTitleY), // 텍스트 위치 설정
        // children: <Widget>[
        //   Expanded(
        //     child: Center(
        //       child: AspectRatio(
        //         aspectRatio: 1, // 가로 세로 비율을 1:1로 설정
        //         child: Image.asset(
        //           'asset/img/misc/logo_img/couture_logo_image.png',
        //           // 로고 이미지 경로 설정
        //           fit: BoxFit.contain, // 이미지를 포함하여 맞춤
        //         ),
        //       ),
        //     ),
        //   ),
        //   Expanded(
        //     child: Center(
        //       child: Text(
        //         title, // 제목 설정
        //         style: TextStyle(
        //           color: Colors.black, // 제목 텍스트 색상
        //           fontSize: 20, // 제목 텍스트 크기
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
              child: Text(
                title, // 제목 설정
                style: TextStyle(
                  color: Colors.black, // 제목 텍스트 색상
                  fontSize: titleFontSize, // 제목 텍스트 크기
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    centerTitle: true,
    // 제목을 중앙에 위치시킴.
    leading: leadingWidget,
    // 설정된 leading 위젯을 사용함.
    actions: actions, // 설정된 동작 버튼들을 추가함.
  );
}
// ------ AppBar 생성 함수 내용 구현 끝

// ------ buildCommonBottomNavigationBar 위젯 내용 구현 시작
// BottomNavigationBar 생성 함수
Widget buildCommonBottomNavigationBar(
    int selectedIndex, WidgetRef ref, BuildContext context, int colorCase, int navigationCase, {ProductContent? product, required ScrollController scrollController}) {

  // 숫자 형식을 지정하기 위한 NumberFormat 객체 생성
  final numberFormat = NumberFormat('###,###'); // 천 단위일때마다 쉼표 표시

  switch (navigationCase) {
  // '홈', '장바구니', '발주내역', '마이페이지' 버튼을 UI로 구현한 케이스
    case 1:
    // 선택된 아이템의 색상을 초기화
      Color selectedColor = Colors.black;
      // 선택되지 않은 아이템의 색상을 초기화
      Color unselectedColor = Colors.white;

      // colorCase 값에 따라 선택된 아이템의 색상을 설정
      switch (colorCase) {
        case 1: // 홈 버튼만 선택된 경우
          selectedColor = Colors.black;
          break;
        case 2: // 장바구니 버튼만 선택된 경우
          selectedColor = Colors.black;
          break;
        case 3: // 발주 내역 버튼만 선택된 경우
          selectedColor = Colors.black;
          break;
        case 4: // 마이페이지 버튼만 선택된 경우
          selectedColor = Colors.black;
          break;
        case 5: // 모든 버튼이 선택되지 않은 경우
          selectedColor = Colors.white;
          break;
      }

      return Container(
        color: Color(0xFF6FAD96), // 전체 배경색을 지정
        child: SafeArea(
          bottom: false, // 하단 SafeArea를 무효화하여 경계선을 제거
          child: Container(
            height: MediaQuery.of(context).size.height * 0.098, // 화면 높이에 비례하여 동적 높이 설정
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              // BottomNavigationBar 타입을 고정형으로 설정
              backgroundColor: Color(0xFF6FAD96), // 배경색을 0xFF6FAD96으로 설정,
              currentIndex: selectedIndex >= 0 && selectedIndex < 4 ? selectedIndex : 0,
              // 현재 선택된 인덱스를 설정, 범위가 벗어나면 0으로 설정
              onTap: (index) {
                // 다른 인덱스가 선택된 경우
                if (index != selectedIndex) {
                  // 선택된 인덱스를 상태로 업데이트
                  ref.read(tabIndexProvider.notifier).state = index;

                  // 화면 전환
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) {
                      // 선택된 인덱스에 따라 다른 화면을 반환
                      switch (index) {
                        case 0:
                          return HomeMainScreen();
                        case 1:
                          return CartMainScreen();
                        case 2:
                          return OrderListMainScreen();
                        case 3:
                          return ProfileMainScreen();
                        default:
                          return HomeMainScreen();
                      }
                    }),
                        (Route<dynamic> route) => false, // 모든 이전 라우트를 제거
                  );
                } else {
                  // 현재 화면이 이미 선택된 화면인 경우, 스크롤 위치를 초기화
                  if (scrollController.hasClients) {
                    scrollController.animateTo(
                      0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                }
              },
              // BottomNavigationBar의 아이템들을 정의
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.5), // 간격을 51로 설정 (좌우 25.5씩)
                    child: Icon(Icons.home_outlined, size: 24,), // 홈 아이콘
                  ),
                  label: '홈', // 홈 라벨
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.5),
                    child: Icon(Icons.shopping_cart_outlined, size: 24), // 장바구니 아이콘
                  ),
                  label: '요청품목', // 요청품목 라벨
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.5),
                    child: Icon(Icons.receipt_long_outlined, size: 24), // 발주 내역 아이콘
                  ),
                  label: '발주내역', // 발주 내역 라벨
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.5),
                    child: Icon(Icons.person_outlined, size: 24), // 마이페이지 아이콘
                  ),
                  label: '마이페이지', // 마이페이지 라벨
                ),
              ],
              selectedItemColor: selectedColor,
              unselectedItemColor: unselectedColor,
              selectedFontSize: 10, // 선택된 아이템의 폰트 크기
              unselectedFontSize: 10, // 선택되지 않은 아이템의 폰트 크기
              selectedLabelStyle: TextStyle(
                fontFamily: 'NanumGothic', // 폰트 패밀리 설정
                fontWeight: FontWeight.bold, // 텍스트를 bold로 설정
                fontSize: 10, // 텍스트 크기를 10으로 설정
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'NanumGothic', // 폰트 패밀리 설정
                fontWeight: FontWeight.bold, // 텍스트를 bold로 설정
                fontSize: 10, // 텍스트 크기를 10으로 설정
              ),
            ),
            // if (selectedIndex == 0) // 선택된 항목에만 하단 바 표시
            //   Positioned(
            //     bottom: 35,
            //     left: 34.5, // 홈 아이템의 위치에 맞게 바를 배치
            //     child: Container(
            //       width: MediaQuery.of(context).size.width / 12, // 바의 너비를 화면의 1/12로 설정
            //       height: 3, // 바의 높이
            //       color: selectedColor, // 선택된 색상
            //     ),
            //   ),
            // // 다른 선택된 항목들에 대해서도 같은 방식으로 적용
            // if (selectedIndex == 1)
            //   Positioned(
            //     bottom: 35,
            //     left: 125, // 요청품목 위치
            //     child: Container(
            //       width: MediaQuery.of(context).size.width / 10,
            //       height: 3,
            //       color: selectedColor,
            //     ),
            //   ),
            // if (selectedIndex == 2)
            //   Positioned(
            //     bottom: 35,
            //     left: 225, // 발주내역 위치
            //     child: Container(
            //       width: MediaQuery.of(context).size.width / 10,
            //       height: 3,
            //       color: selectedColor,
            //     ),
            //   ),
            // if (selectedIndex == 3)
            //   Positioned(
            //     bottom: 35,
            //     left: 320, // 마이페이지 위치
            //     child: Container(
            //       width: MediaQuery.of(context).size.width / 8,
            //       height: 3,
            //       color: selectedColor,
            //     ),
            //   ),
         ),
      ),
    );

  // '요청품목', '바로 발주' 버튼을 UI로 구현한 케이스
    case 2:
      if (product == null) {
        throw ArgumentError('Product must be provided for navigation case 2'); // 제품이 제공되지 않은 경우 예외 처리
      }

      // 선택된 색상, 사이즈, 수량 등을 상태에서 가져옴
      final selectedColorUrl = ref.watch(colorSelectionUrlProvider); // 선택된 색상 URL 상태 값 가져오기
      final selectedColorText = ref.watch(colorSelectionTextProvider); // 선택된 색상 텍스트 상태 값 가져오기
      final selectedSize = ref.watch(sizeSelectionIndexProvider); // 선택된 사이즈 상태 값 가져오기

      // 선택된 옵션과 수량을 반영한 ProductContent 객체 생성
      final orderProduct = ProductContent(
        docId: product.docId, // 제품 문서 ID 설정
        category: product.category ?? '', // 제품 카테고리 설정
        productNumber: product.productNumber ?? '', // 제품 번호 설정
        thumbnail: product.thumbnail ?? '', // 제품 썸네일 설정
        briefIntroduction: product.briefIntroduction ?? '', // 제품 간단 소개 설정
        originalPrice: (product.originalPrice ?? 0), // 원래 가격 설정
        discountPrice: (product.discountPrice ?? 0), // 할인 가격 설정
        discountPercent: (product.discountPercent ?? 0), // 할인 퍼센트 설정
        selectedColorImage: selectedColorUrl ?? '', // 선택한 색상 이미지 URL 설정
        selectedColorText: selectedColorText ?? '', // 선택한 색상 텍스트 설정
        selectedSize: selectedSize ?? '', // 선택한 사이즈 설정
      );

      // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
      final Size screenSize = MediaQuery.of(context).size;

      // 기준 화면 크기: 가로 393, 세로 852
      final double referenceWidth = 393.0;
      final double referenceHeight = 852.0;

      // 비율을 기반으로 동적으로 크기와 위치 설정

      // 버튼 관련 수치 동적 적용
      final double bottomBtnC2Width = screenSize.width * (166 / referenceWidth);
      final double bottomBtnC2Height = screenSize.height * (50 / referenceHeight);
      final double bottomBtnC2X = screenSize.width * (20 / referenceWidth);
      final double bottomBtnC2Y = screenSize.height * (10 / referenceHeight);
      final double bottomBarC2Y = screenSize.height * (15 / referenceHeight);
      final double bottomBtnFontSize = screenSize.height * (14 / referenceHeight);


    return Container(
      color: Theme.of(context).scaffoldBackgroundColor, // 전체 배경색을 지정
      child: SafeArea(
          bottom: false, // 하단 SafeArea를 무효화하여 경계선을 제거
            child: Container(
              height: MediaQuery.of(context).size.height * 0.098, // 화면 높이에 비례하여 동적 높이 설정
              padding: EdgeInsets.only(bottom: bottomBarC2Y),
              // UI 패딩 설정
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: bottomBtnC2X, vertical: bottomBtnC2Y), // 좌우 bottomBtnC2X, 상하 bottomBtnC2Y의 여백 추가
                child: Row( // 수평으로 배치되는 Row 위젯 사용
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Row 내부 위젯들을 양 끝에 배치
                  children: [
                    Container(
                      width: bottomBtnC2Width,
                      height: bottomBtnC2Height,
                      child: ElevatedButton(
                        onPressed: () => onCartButtonPressed(context, ref, product), // 요청품목 버튼 클릭 시 실행될 함수 지정
                        style: ElevatedButton.styleFrom(
                          foregroundColor:  Colors.white, // 텍스트 색상
                          backgroundColor: Color(0xFF6FAD96), // 배경 색상
                        ),
                        child: Text('요청품목 담기',
                          style: TextStyle(
                            fontFamily: 'NanumGothic',
                            fontSize: bottomBtnFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ), // 버튼 텍스트 설정
                      ),
                    ),
                    SizedBox(width: 10), // 버튼들 사이에 10픽셀 너비의 여백 추가
                    Container(
                      width: bottomBtnC2Width,
                      height: bottomBtnC2Height,
                      child: ElevatedButton(
                        onPressed: () {
                          // 선택된 아이템을 상태로 설정하여 데이터 가져올 수 있게 설정
                          ref.read(orderItemsProvider.notifier).setOrderItems([orderProduct]); // 주문 아이템 상태 업데이트
                          // OrderMainScreen으로 화면 전환
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => OrderMainScreen(
                            )),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor:  Colors.white, // 텍스트 색상
                          backgroundColor: Color(0xFF6FAD96), // 배경 색상
                        ),
                        child: Text('바로 발주',
                          style: TextStyle(
                            fontFamily: 'NanumGothic',
                            fontSize: bottomBtnFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            ),
                        ),// 텍스트를 굵게 설정 // 버튼 텍스트 설정
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

  // '전체 체크박스', '합계' '발주하기' 버튼을 UI로 구현한 케이스 - 장바구니 화면에 구현
    case 3:
    // 전체 체크박스 선택 여부를 상태로 관리
      final allChecked = ref.watch(allCheckedProvider);
      // 장바구니 아이템 목록을 상태로 관리
      final cartItems = ref.watch(cartItemsProvider);

// 발주 화면에서 사용할 선택된 아이템들을 필터링하고 ProductContent 객체로 변환하여 리스트로 저장
      final orderProducts = cartItems
      // cartItems 리스트에서 'bool_checked'가 true인 아이템들만 필터링
          .where((item) => item['bool_checked'] == true)
      // 필터링된 아이템들을 map 함수를 사용하여 ProductContent 객체로 변환
          .map((item) {
        return ProductContent(
          // ProductContent 객체의 docId 필드를 item의 'product_id' 값으로 설정
          docId: item['product_id'],
          // ProductContent 객체의 category 필드를 item의 'category' 값으로 설정
          category: item['category'],
          // ProductContent 객체의 productNumber 필드를 item의 'product_number' 값으로 설정
          productNumber: item['product_number'],
          // ProductContent 객체의 thumbnail 필드를 item의 'thumbnails' 값으로 설정
          thumbnail: item['thumbnails'],
          // ProductContent 객체의 briefIntroduction 필드를 item의 'brief_introduction' 값으로 설정
          briefIntroduction: item['brief_introduction'],
          // ProductContent 객체의 originalPrice 필드를 item의 'original_price' 값으로 설정
          originalPrice: item['original_price'],
          // ProductContent 객체의 discountPrice 필드를 item의 'discount_price' 값으로 설정
          discountPrice: item['discount_price'],
          // ProductContent 객체의 discountPercent 필드를 item의 'discount_percent' 값으로 설정
          discountPercent: item['discount_percent'],
          // ProductContent 객체의 selectedColorImage 필드를 item의 'selected_color_image' 값으로 설정
          selectedColorImage: item['selected_color_image'],
          // ProductContent 객체의 selectedColorText 필드를 item의 'selected_color_text' 값으로 설정
          selectedColorText: item['selected_color_text'],
          // ProductContent 객체의 selectedSize 필드를 item의 'selected_size' 값으로 설정
          selectedSize: item['selected_size'],
        );
      })
      // 변환된 ProductContent 객체들을 리스트로 저장
          .toList();

      return Container(
        // 컨테이너의 내부 여백 설정
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        // 컨테이너 배경색을 흰색으로 설정
        color: Colors.white,
        child: Row(
          // Row의 주 축 방향에서의 정렬 방식을 공간을 동일하게 나눔
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 전체 선택 체크박스와 텍스트를 담을 Row
            Row(
              children: [
                // 체크박스 크기를 1.5배로 확대
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    // 체크박스의 선택 여부를 allChecked 상태로 설정
                    value: allChecked,
                    activeColor: BUTTON_COLOR,  // 체크박스 색상 변경
                    // 체크박스 상태 변경 시 호출되는 함수
                    onChanged: (bool? value) {
                      // allCheckedProvider 상태 업데이트
                      ref.read(allCheckedProvider.notifier).state = value!;
                      // cartItemsProvider 상태에서 모든 아이템의 체크 상태를 변경
                      ref.read(cartItemsProvider.notifier).toggleAll(value);
                    },
                  ),
                ),
                // 체크박스와 텍스트 사이의 간격 설정
                SizedBox(width: 8),
                // "전체" 텍스트를 표시
                Text(
                  '전체',
                  // 텍스트 스타일 설정 (크기: 16, 굵게)
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // 발주하기 버튼
            ElevatedButton(
              // 버튼 클릭 시 호출되는 함수
              onPressed: () {
                // 선택된 아이템을 상태로 설정하여 데이터 가져올 수 있게 설정한 내용
                ref.read(orderItemsProvider.notifier).setOrderItems(orderProducts);
                // OrderMainScreen으로 화면 전환
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => OrderMainScreen(
                  )),
                );
              },
              // 버튼 스타일 설정 (배경색: BUTTON_COLOR, 글자색: INPUT_BG_COLOR)
              style: ElevatedButton.styleFrom(
                backgroundColor: BUTTON_COLOR,
                foregroundColor: INPUT_BG_COLOR,
              ),
              // 버튼에 표시될 텍스트
              child: Text('업데이트 요청하기'),
            ),
          ],
        ),
      );

    default:
      return Container(); // 기본으로 빈 컨테이너 반환
  }
}
// ------ buildCommonBottomNavigationBar 위젯 내용 구현 끝

// 왼쪽 상단 버튼 유형을 정의하는 열거형 관련 함수
enum LeadingType {
  drawer, // 드로어 버튼.
  back, // 이전 화면으로 이동 버튼.
  none, // 아무 버튼도 없음.
}

// 버튼 클릭하는 경우, 각 화면으로 이동하는 함수인 navigateToScreen 내용 (앱 바, 하단 탭 바에 사용)
void navigateToScreen(
    BuildContext context, WidgetRef ref, Widget screen, int tabIndex) {
  // 현재 경로가 이동하려는 화면과 동일한지 확인
  if (ModalRoute.of(context)?.settings.name == screen.runtimeType.toString()) {
    return; // 동일하면 아무 작업도 하지 않음
  }
  // 탭 인덱스 업데이트
  ref.read(tabIndexProvider.notifier).state = tabIndex;
  // 지정된 화면으로 교체하면서 이동
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (_) => screen));
}

// 특정 화면으로 이동하면서 기존의 모든 페이지 스택을 제거하는 함수인 navigateToScreenAndRemoveUntil 내용 (앱 바, 하단 탭 바에 사용)
void navigateToScreenAndRemoveUntil(
    BuildContext context, WidgetRef ref, Widget screen, int tabIndex) {
  // 탭 인덱스 업데이트
  ref.read(tabIndexProvider.notifier).state = tabIndex;
  // 지정된 화면으로 이동하면서 기존의 모든 페이지 스택을 제거
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => screen),
    (Route<dynamic> route) => false, // 모든 이전 라우트를 제거
  );
}

// ------ 상단 탭 바 텍스트 스타일 관련 topBarTextStyle 함수 내용 구현 시작
// 상단 탭 바 텍스트 스타일 설정 함수
// TextStyle topBarTextStyle(int currentIndex, int buttonIndex) {
//   return TextStyle(
//     fontSize: 14,
//     // 텍스트 크기를 16으로 설정
//     fontWeight: FontWeight.bold,
//     // 텍스트 굵기를 굵게 설정
//     color: currentIndex == buttonIndex ? GOLD_COLOR : INPUT_BORDER_COLOR,
//     // 현재 선택된 탭과 탭 인덱스가 같다면 금색, 아니면 입력창 테두리 색상으로 설정
//     shadows: [
//       // 텍스트에 그림자 효과를 추가
//       Shadow(
//         // 하단에 그림자 설정
//         offset: Offset(0, 2), // 그림자의 위치를 하단으로 설정
//         color: LOGO_COLOR, // 그림자 색상을 로고 색상으로 설정
//         blurRadius: 0, // 흐림 효과 없음
//       ),
//       Shadow(
//         // 오른쪽에 그림자 설정
//         offset: Offset(2, 0), // 그림자의 위치를 오른쪽으로 설정
//         color: LOGO_COLOR, // 그림자 색상을 로고 색상으로 설정
//         blurRadius: 0, // 흐림 효과 없음
//       ),
//       Shadow(
//         // 상단에 그림자 설정
//         offset: Offset(0, -2), // 그림자의 위치를 상단으로 설정
//         color: LOGO_COLOR, // 그림자 색상을 로고 색상으로 설정
//         blurRadius: 0, // 흐림 효과 없음
//       ),
//       Shadow(
//         // 왼쪽에 그림자 설정
//         offset: Offset(-2, 0), // 그림자의 위치를 왼쪽으로 설정
//         color: LOGO_COLOR, // 그림자 색상을 로고 색상으로 설정
//         blurRadius: 0, // 흐림 효과 없음
//       ),
//     ],
//   );
// }
TextStyle topBarTextStyle(int currentIndex, int buttonIndex) {
  return TextStyle(
    fontSize: 16, // Figma에서 확인한 텍스트 크기
    fontWeight: FontWeight.bold, // 폰트 굵기 설정
    color: currentIndex == buttonIndex ? Color(0xFF6FAD96) : Color(0xFF737373),
    // 현재 탭이 활성화된 경우 연한 초록색, 비활성화된 경우 회색 적용
  );
}
// ------ 상단 탭 바 텍스트 스타일 관련 topBarTextStyle 함수 내용 구현 끝

// ------ buildTopBarList 위젯 내용 구현 시작
// TopBar의 카테고리 리스트를 생성하는 함수를 재작성
// TopBar의 카테고리 리스트 생성 함수. 각 카테고리를 탭했을 때의 동작을 정의함.
Widget buildTopBarList(
    BuildContext context,
    void Function(int) onTopBarTap,
    StateProvider<int> currentTabProvider,
    ScrollController topBarAutoScrollController) {
  final List<Map<String, String>> topBarCategories = [
    // 카테고리 리스트를 정의
    {"type": "text", "data": "전체"},
    {"type": "text", "data": "신상"},
    {"type": "text", "data": "스테디 셀러"},
    {"type": "text", "data": "특가 상품"},
    {"type": "text", "data": "봄"},
    {"type": "text", "data": "여름"},
    {"type": "text", "data": "가을"},
    {"type": "text", "data": "겨울"},
  ];

  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정

  // 탑 바 부분 수치
  final double topBarListHeight = screenSize.width * (52 / referenceWidth); // 탑 바 리스트 높이
  final double topBarListX = screenSize.width * (16 / referenceWidth); // 탑 바 리스트 X 좌표
  final double topBarBtnHeight = screenSize.height * (52 / referenceHeight); // 탑 바 버튼 높이

  // 각 카테고리를 탭했을 때 실행될 함수. 카테고리에 따라 다른 페이지로 이동함.
  return Consumer(
    builder: (context, ref, child) {
      int currentIndex = ref.watch(currentTabProvider); // 현재 선택된 탭의 인덱스를 가져옴
      return Container(
        height: topBarListHeight,
        margin: EdgeInsets.only(left: topBarListX),
        child: ListView.builder(
          controller: topBarAutoScrollController,
          // 상단 탭 바 자동 스크롤을 위한 컨트롤러 설정
          scrollDirection: Axis.horizontal,
          // 리스트뷰의 스크롤 방향을 가로로 설정함.
          itemCount: topBarCategories.length,
          // 리스트뷰에 표시될 항목의 개수를 상단 바 카테고리 배열의 길이로 설정함.
          itemBuilder: (context, index) {
            final category =
                topBarCategories[index]["data"] ?? ""; // 안전하게 문자열 추출
            return GestureDetector(
              onTap: () {
                onTopBarTap(index); // onTopBarTap 함수를 호출하여 처리
                ref.read(currentTabProvider.notifier).state =
                    index; // 선택된 탭의 인덱스를 갱신
              },
              child: Container(
                // 수정된 부분: Padding을 Container로 변경
                alignment: Alignment.center, // Container 내부 내용을 중앙 정렬
                height: topBarBtnHeight,
                padding: EdgeInsets.symmetric(horizontal: 22), // 좌우로 패딩 적용
                child:
                    Text(category, style: topBarTextStyle(currentIndex, index)),
              ),
            );
          },
        ),
      );
    },
  );
}
// ------ buildTopBarList 위젯 내용 구현 끝

// ------ buildCommonDrawer 위젯 내용 구현 시작
// 드로워 생성 함수
// 공통 Drawer 생성 함수. 사용자 이메일을 표시하고 로그아웃 등의 메뉴 항목을 포함함.
Widget buildCommonDrawer(BuildContext context, WidgetRef ref) {
  // FirebaseAuth에서 현재 로그인한 사용자의 이메일을 가져옴. 로그인하지 않았다면 'No Email'이라는 기본 문자열을 표시함.
  final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'No Email';

  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 260.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정
  // 드로워 화면 내 아이콘 요소 수치
  final double drawerLogoIconWidth =
      screenSize.width * (130 / referenceWidth); // 가로 비율
  final double drawerLogoIconHeight =
      screenSize.height * (65 / referenceWidth); // 세로 비율
  final double drawerHeaderHeight =
      screenSize.height * (70 / referenceWidth); // 세로 비율
  final double drawerLogoIconX =
      screenSize.width * (33 / referenceWidth); // 왼쪽 여백 비율
  final double drawerLogoIconY =
      screenSize.width * (50 / referenceHeight); // 위쪽 여백 비율

  // Drawer 위젯을 반환합니다. 이 위젯은 앱의 사이드 메뉴를 구현하는 데 사용.
  return Drawer(
    child: Container(
      color: Colors.white, // 전체 드로어의 배경색을 흰색으로 설정
      child: Stack(
        children: [
          // 로고 및 이메일 배치
          Positioned(
            left: drawerLogoIconX, // 로고의 X 좌표 설정 (왼쪽 여백)
            top: drawerLogoIconY, // 로고의 Y 좌표 설정 (위쪽 여백)
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: drawerLogoIconWidth,
                  height: drawerLogoIconHeight,
                  padding: EdgeInsets.zero, // 패딩 제거
                  margin: EdgeInsets.zero, // 마진 제거
                  // decoration: BoxDecoration(
                  //   color: Colors.grey, // 회색 배경 설정 (테스트용)
                  // ),
                  child: Image.asset(
                    'asset/img/misc/logo_img/couture_logo_v1.png',
                    // fit: BoxFit.contain, // 이미지의 fit 속성 설정
                  ),
                ),
                Padding(
                  padding: EdgeInsets.zero, // 이메일의 패딩 제거
                  child: Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black, // 텍스트 색상
                      fontFamily: 'NanumGothic',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 콘텐츠 영역 관리
          Positioned(
            top: drawerLogoIconY + 1.3 * drawerLogoIconHeight, // 로고 아래의 간격을 최소화
            left: 32,
            right: 0,
            child: Column(
              children: <Widget>[
                _buildListTile(
                  context,
                  '네이버 카페',
                  'https://cafe.naver.com/ottbayo',
                  'asset/img/misc/drawer_img/naver_logo_v1.png',
                ),
                SizedBox(height: 20), // 간격을 위한 SizedBox
                _buildListTile(
                  context,
                  '유튜브',
                  'https://www.youtube.com/@OTTBAYO',
                  'asset/img/misc/drawer_img/youtube_logo_v1.png',
                ),
                SizedBox(height: 20), // 간격을 위한 SizedBox
                _buildListTile(
                  context,
                  '인스타그램',
                  'https://www.instagram.com/ottbayo',
                  'asset/img/misc/drawer_img/instagram_logo_v1.png',
                ),
                SizedBox(height: 20), // 간격을 위한 SizedBox
                _buildListTile(
                  context,
                  '카카오톡',
                  'https://pf.kakao.com/_xjVrbG',
                  'asset/img/misc/drawer_img/kakao_logo_v1.png',
                ),
                SizedBox(height: 130), // 간격을 위한 SizedBox
                // 로그아웃 버튼 항목
                GestureDetector(
                  onTap: () async {
                    // 로그아웃 및 자동로그인 체크 상태에서 앱 종료 후 재실행 시,
                    // 홈 화면 내 섹션의 데이터 초기화 / 홈 화면 내 섹션의 스크롤 위치 초기화 / 화면 자체의 스크롤 위치 초기화 관련 함수 호출
                    await logoutAndLoginAfterProviderReset(ref);
                    // 로그인 화면으로 이동
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  },
                  child: Center( // 가로 기준 중앙 정렬을 위해 Center 위젯 사용
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Row 안의 요소들에 맞게 크기 조정
                      children: [
                        Text('Logout', style: TextStyle(color: Color(0xFF777777), fontSize: 20)), // 로그아웃 텍스트
                        SizedBox(width: 15), // 아이콘과 텍스트 사이의 간격
                        Icon(Icons.logout, color: Color(0xFF777777), size: 20), // 로그아웃 아이콘
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
// ------ buildCommonDrawer 위젯 내용 구현 끝

// ------ 웹 링크를 포함한 리스트 타일을 생성하는 함수(위젯) 시작
Widget _buildListTile(
    BuildContext context, String title, String url, String leadingImage) {
  // ListTile 위젯 반환
  return ListTile(
    leading: Image.asset(leadingImage, width: 40), // 이미지를 왼쪽에 배치
    title: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          color: Colors.black, // 텍스트 색상
          fontFamily: 'NanumGothic',
          fontWeight: FontWeight.bold,
        )), // 제목을 설정
    contentPadding: EdgeInsets.symmetric(horizontal: 16), // 좌우 간격 조정
    onTap: () async {
      // 탭 이벤트 핸들러
      try {
        // URL을 파싱하여 웹 페이지 열기 시도
        final bool launched = await launchUrl(Uri.parse(url));
        if (!launched) {
          // 웹 페이지를 열지 못할 경우 스낵바로 알림
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('웹 페이지를 열 수 없습니다.')));
        }
      } catch (e) {
        // 예외 발생 시 스낵바로 에러 메시지 출력
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('앱 실행에 실패했습니다.')));
      }
    },
  );
}
// ------ 웹 링크를 포함한 리스트 타일을 생성하는 함수(위젯) 끝

// ------ Firestore 문서를 생성하는 함수 구현 시작
Future<void> createFirestoreDocuments() async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();
  const int originalPrice = 10000;

  final Map<int, String> briefIntroductionMap = {
    1: '해당 상품은 티셔츠입니다.',
    2: '해당 상품은 블라우스입니다.',
    3: '해당 상품은 맨투맨입니다.',
    4: '해당 상품은 니트입니다.',
    5: '해당 상품은 폴라티입니다.',
    6: '해당 상품은 원피스입니다.',
    7: '해당 상품은 팬츠입니다.',
    8: '해당 상품은 청바지입니다.',
    9: '해당 상품은 스커트입니다.',
    10: '해당 상품은 패딩입니다.',
    11: '해당 상품은 코트입니다.',
    12: '해당 상품은 가디건입니다.',
  };

  final Map<int, String> categoryMap = {
    1: 'shirt',
    2: 'blouse',
    3: 'mtm',
    4: 'neat',
    5: 'pola',
    6: 'onepiece',
    7: 'pants',
    8: 'jean',
    9: 'skirt',
    10: 'paeding',
    11: 'coat',
    12: 'cardigan',
  };

  final Map<int, String> typeMap = {
    1: 'new',
    2: 'best',
    3: 'sale',
    4: 'spring',
    5: 'summer',
    6: 'autumn',
    7: 'winter',
  };

  final Map<int, String> categoryTextMap = {
    1: '티셔츠',
    2: '블라우스',
    3: '맨투맨',
    4: '니트',
    5: '폴라티',
    6: '원피스',
    7: '팬츠',
    8: '청바지',
    9: '스커트',
    10: '패딩',
    11: '코트',
    12: '가디건',
  };

  final Map<int, String> detailImagePathMap = {
    1: 'shirt',
    2: 'blouse',
    3: 'mtm',
    4: 'neat',
    5: 'pola',
    6: 'onepiece',
    7: 'pants',
    8: 'jean',
    9: 'skirt',
    10: 'paeding',
    11: 'coat',
    12: 'cardigan',
  };

  for (int i = 1; i <= 12; i++) {
    String docId = 'a$i';
    DocumentReference docRef = firestore.collection('couturier').doc(docId);
    String briefIntroduction = briefIntroductionMap[i] ?? '해당 상품은 설명이 없습니다.';
    String category = categoryMap[i] ?? '';
    String categoryText = categoryTextMap[i] ?? '해당 상품은 카테고리가 없습니다.';
    String detailImagePath = detailImagePathMap[i] ?? '';

    for (int j = 1; j <= 7; j++) {
      String subCollectionId = 'a${i}b$j';
      CollectionReference subCollectionRef = docRef.collection(subCollectionId);
      String type = typeMap[j] ?? '';

      for (int k = 0; k < 15; k++) {
        int discountPercent = 10 + k; // k=0이면 10, k=1이면 11, ...
        int discountPrice = originalPrice - (originalPrice * discountPercent ~/ 100);
        String subDocId = 'a${i}b${j}_$k';
        String productNumber = 'A${i}B${j}_${k.toString().padLeft(3, '0')}';
        DocumentReference subDocRef = subCollectionRef.doc(subDocId);

        String thumbnailUrl = 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/product_thumnail%2F$category\_$type.png?alt=media';

        // // 해당 필드값만 기존 필드값에서 새롭게 변경하고 싶을 때 사용하는 매서드
        // batch.update(subDocRef, {
        //   'detail_page_image1': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}1.png?alt=media',
        //   'detail_page_image2': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}2.png?alt=media',
        //   'detail_page_image3': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}3.png?alt=media',
        //   'detail_page_image4': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}4.png?alt=media',
        //   'detail_page_image5': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}5.png?alt=media',
        // });

        // 해당 필드값으로 세팅하는 매서드 (SetOptions(merge: true)); // merge 옵션 사용을 해서 기존것이 날라가지않고 유지됨)
        batch.set(subDocRef, {
          'brief_introduction': briefIntroduction,
          'clothes_color1': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/clothes_color%2Fblack.png?alt=media&token=8eb2b83e-16f3-4921-9248-aeac08ba548b',
          'clothes_color2': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/clothes_color%2Fbrown.png?alt=media&token=c6742c7e-dc7f-4133-921e-86fca1a80441',
          'clothes_color3': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/clothes_color%2F%20lavender.png?alt=media&token=e8118999-064f-47b2-8f08-1055b5a886c3',
          'clothes_color4': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/clothes_color%2Fpink.png?alt=media&token=7abd298b-dc20-4f8e-88c2-f9aa8c4fc135',
          'clothes_color5': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/clothes_color%2Fyellow.png?alt=media&token=8a8158dd-66de-40f3-b5de-690059511261',
          'clothes_size1': 'S',
          'clothes_size2': 'M',
          'clothes_size3': 'L',
          'clothes_size4': 'XL',
          'color1_text': 'black',
          'color2_text': 'brown',
          'color3_text': 'lavender',
          'color4_text': 'pink',
          'color5_text': 'yellow',
          // 상품 상세 화면 내 상단 이미지 페이지 뷰 관련 이미지 데이터
          'detail_page_image1': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}1.png?alt=media',
          'detail_page_image2': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}2.png?alt=media',
          'detail_page_image3': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}3.png?alt=media',
          'detail_page_image4': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}4.png?alt=media',
          'detail_page_image5': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}5.png?alt=media',
          // 상품 상세 화면 내 상품 정보 관련 이미지 데이터
          'detail_color_image1': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fprod_info%2Fcolor_info%2Fdetail_color_image1.png?alt=media',
          'detail_color_image2': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fprod_info%2Fcolor_info%2Fdetail_color_image2.png?alt=media',
          'detail_color_image3': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fprod_info%2Fcolor_info%2Fdetail_color_image3.png?alt=media',
          'detail_color_image4': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fprod_info%2Fcolor_info%2Fdetail_color_image4.png?alt=media',
          'detail_color_image5': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fprod_info%2Fcolor_info%2Fdetail_color_image5.png?alt=media',
          'detail_details_image1': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fprod_info%2Fdetails_info%2Fdetail_details_image1.png?alt=media',
          'detail_fabric_image1': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fprod_info%2Ffabric_info%2Fdetail_fabric_image1.png?alt=media',
          'detail_intro_image1': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fprod_info%2Fintro_info%2Fdetail_intro_image1.png?alt=media',
          'detail_intro_image2': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fprod_info%2Fintro_info%2Fdetail_intro_image2.png?alt=media',
          'detail_intro_image3': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fprod_info%2Fintro_info%2Fdetail_intro_image3.png?alt=media',
          'detail_intro_image4': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fprod_info%2Fintro_info%2Fdetail_intro_image4.png?alt=media',
          'detail_intro_image5': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fprod_info%2Fintro_info%2Fdetail_intro_image5.png?alt=media',
          'detail_size_image1': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fprod_info%2Fsize_info%2Fdetail_size_image1.png?alt=media',
          'detail_washing_image1': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fprod_info%2Fwashing_info%2Fdetail_washing_image1.png?alt=media',
          // 'discount_percent': discountPercent,
          // 'discount_price': discountPrice,
          // 'original_price': originalPrice,
          'thumbnails': thumbnailUrl, // thumbnails 필드값 추가
          'category': categoryText, // category 필드값 추가
          'product_number': productNumber, // product_number 필드 추가
        }, SetOptions(merge: true)); // merge 옵션 사용

        // // 장바구니 관련 필드들 삭제
        // batch.update(subDocRef, {
        //   'cart_thumbnails': FieldValue.delete(),
        //   'cart_brief_introduction': FieldValue.delete(),
        //   'cart_original_price': FieldValue.delete(),
        //   'cart_discount_price': FieldValue.delete(),
        //   'cart_discount_percent': FieldValue.delete(),
        //   'cart_selected_color_text': FieldValue.delete(),
        //   'cart_selected_color_image': FieldValue.delete(),
        //   'cart_selected_size': FieldValue.delete(),
        //   'cart_selected_count': FieldValue.delete(),
        //   'cart_timestamp': FieldValue.delete(),
        // });
        // SetOptions(merge: true); // merge 옵션 사용
      }
    }
  }
  await batch.commit();
}
// ------ Firestore 문서를 생성하는 함수 구현 끝
