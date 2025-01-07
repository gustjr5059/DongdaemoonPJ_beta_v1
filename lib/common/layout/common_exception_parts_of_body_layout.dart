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

// 주문 관련 화면을 구현한 파일을 임포트합니다.
import '../../home/view/main_home_screen.dart';
import '../../manager/message/view/message_screen.dart';
import '../../manager/orderlist/view/orderlist_screen.dart';
import '../../manager/review/view/review_screen.dart';
import '../../order/provider/order_state_provider.dart';
import '../../order/view/order_list_screen.dart';

// 사용자 로그인 화면을 구현한 파일을 임포트합니다.
import '../../order/view/order_screen.dart';
import '../../product/model/product_model.dart';
import '../../product/provider/product_state_provider.dart';
import '../../user/layout/login_body_parts_layout.dart';
import '../../user/provider/drawer_user_provider.dart';
import '../../user/view/easy_login_aos_screen.dart';
import '../../user/view/easy_login_ios_screen.dart';

// 사용자 프로필 화면을 구현한 파일을 임포트합니다.
import '../../user/view/profile_screen.dart';

// 다양한 색상을 정의하는 파일을 임포트합니다.
import '../../wishlist/provider/wishlist_state_provider.dart';
import '../../wishlist/view/wishlist_screen.dart';
import '../const/colors.dart';

// 애플리케이션의 공통적인 상태 관리 로직을 포함하는 파일을 임포트합니다.
import '../provider/common_all_providers.dart';
import '../provider/common_state_provider.dart';

// Platform.isAndroid & Platform.isIOS 관련 임포트
import 'dart:io' show Platform;

import 'common_body_parts_layout.dart';

// 상태표시줄 색상을 안드로이드와 ios 버전에 맞춰서 변경하는데 사용되는 함수-앱 실행 생명주기에 맞춰서 변경
void updateStatusBar() {
  if (Platform.isAndroid) {
    // 안드로이드에서는 상태표시줄 색상을 직접 지정
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
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
      context, // BuildContext를 필수 인자로 받아 각종 위젯의 위치 정보 등을 제공받음.
  required WidgetRef ref, // 위젯 상태 참조를 위한 WidgetRef를 필수 인자로 받음.
  required String title, // AppBar에 표시될 제목을 문자열로 받음.
  required double appBarTitleWidth, // 앱 바 제목의 너비 설정
  required double appBarTitleHeight, // 앱 바 제목의 높이 설정
  required double appBarTitleX, // 앱 바 제목의 X축 위치 설정
  required double appBarTitleY, // 앱 바 제목의 Y축 위치 설정
  // String? platformType, // 플랫폼 정보 추가
  // 이벤트 이미지 버튼 클릭 시 이벤트 섹션으로 이동시키기 위한 변수
  ScrollController? scrollController, // 스크롤 컨트롤러 설정 변수
  GlobalKey? sectionKey, // 동적 위치 지정 키
  double? drawerIconWidth, // 드로어 아이콘의 너비 설정
  double? drawerIconHeight, // 드로어 아이콘의 높이 설정
  double? drawerIconX, // 드로어 아이콘의 X축 위치 설정
  double? drawerIconY, // 드로어 아이콘의 Y축 위치 설정
  double? chevronIconWidth, // 뒤로가기 아이콘의 너비 설정
  double? chevronIconHeight, // 뒤로가기 아이콘의 높이 설정
  double? chevronIconX, // 뒤로가기 아이콘의 X축 위치 설정
  double? chevronIconY, // 뒤로가기 아이콘의 Y축 위치 설정
  double? wishlistBtnWidth, // 위시리스트 버튼 너비 설정
  double? wishlistBtnHeight, // 위시리스트 버튼 높이 설정
  double? wishlistBtnX, // 위시리스트 버튼 X축 위치 설정
  double? wishlistBtnY, // 위시리스트 버튼 Y축 위치 설정
  double? homeBtnWidth, // 홈 버튼 너비 설정
  double? homeBtnHeight, // 홈 버튼 높이 설정
  double? homeBtnX, // 홈 버튼 X축 위치 설정
  double? homeBtnY, // 홈 버튼 Y축 위치 설정
  double? cartlistBtnWidth, // 장바구니 버튼 너비 설정
  double? cartlistBtnHeight, // 장바구니 버튼 높이 설정
  double? cartlistBtnX, // 장바구니 버튼 X축 위치 설정
  double? cartlistBtnY, // 장바구니 버튼 Y축 위치 설정
  LeadingType leadingType =
      LeadingType.drawer, // 앱 바 왼쪽 상단 버튼 유형 결정, 기본값은 드로어 버튼으로 설정
  int buttonCase = 1, // 버튼 구성을 선택하기 위한 매개변수, 기본값은 케이스 1
  String? fontFamily, // 제목의 글꼴을 설정하는 선택적 매개변수
  String? titleImagePath, // 이미지 경로를 설정하기 위한 선택적 매개변수
  bool boolEventImg = false, // 이벤트 이미지 표시 여부 설정
  bool boolTitleImg = false, // Firestore의 title_img 사용 여부 설정
  // 추가된 콜백 파라미터
  VoidCallback? onEventImageTap,
  String titleImageFieldName = 'title_img', // 타이틀 이미지 설정
}) {
  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정

  // 앱 바 내 title 글자 크기
  final double titleFontSize =
      screenSize.height * (17 / referenceHeight); // 텍스트 크기

  // ----- 앱 바 부분 수치 시작 부분
  final double appBarHeight =
      screenSize.height * (44 / referenceHeight); // 세로 비율
  final double appBarCartItemCountTextFontSize = screenSize.height *
      (12 / referenceHeight); // 앱 바 장바구니 아이콘의 장바구니 아이템 갯수 부분 텍스트 수치
  final double appBarWishlistItemCountTextFontSize = screenSize.height *
      (12 / referenceHeight); // 앱 바 찜 목록 아이콘의 찜 목록 아이템 갯수 부분 텍스트 수치
  final double interval1X =
      screenSize.width * (3 / referenceWidth); // 장바구니 아이콘 위치 X좌표
  final double interval1Y =
      screenSize.height * (4 / referenceHeight); // 장바구니 아이콘 위치 Y좌표
  final double interval2X =
      screenSize.width * (1 / referenceWidth); // 찜 목록 아이콘 위치 X좌표
  final double interval2Y =
      screenSize.height * (4 / referenceHeight); // 찜 목록 아이콘 위치 Y좌표

  // `boolEventImg` 값에 따라 이벤트 이미지를 가져옴
  final eventImage = ref.watch(eventImageProvider).whenOrNull(
        data: (data) =>
            boolEventImg && data != null && data.isNotEmpty ? data : null,
      );

  // Firestore에서 제목 이미지를 가져옴
  // titleImageFieldName으로 Firestore에서 지정된 필드명의 이미지 가져오기
  final titleImage = ref.watch(titleImageFieldProvider(titleImageFieldName)).whenOrNull(
    data: (data) => boolTitleImg && data != null && data.isNotEmpty ? data : null,
  );

  // 이벤트 이미지를 클릭 가능하게 만드는 위젯 선언
  Widget? eventImageWidget;
  if (eventImage != null) {
    // 이벤트 이미지가 있을 경우 조건문 실행
    eventImageWidget = GestureDetector(
      onTap: () {
        // 여기서 MainHomeScreen 클래스에서의 케이스(onEventImageTap 콜백) 추가
        // onEventImageTap 콜백이 존재한다면 콜백 실행(즉, MainHomeScreen에서 전달한 함수 사용)
        // 콜백이 없다면 기존 로직(섹션 컨텍스트 찾아 스크롤) 유지
        if (onEventImageTap != null) {
          // MainHomeScreen에서 onEventImageTap을 전달했다면 해당 콜백을 실행
          onEventImageTap();
        } else {
          // 이미지 클릭 시 실행할 함수 정의
          // '겨울' 섹션으로 스크롤 이동 기능 구현
          final sectionContext = sectionKey?.currentContext; // 해당 섹션의 컨텍스트 가져옴
          if (sectionContext != null) {
            // 섹션 컨텍스트가 null이 아닐 경우 실행
            Scrollable.ensureVisible(
              sectionContext, // 스크롤하려는 대상 섹션 컨텍스트 전달
              duration: Duration(milliseconds: 500), // 스크롤 애니메이션 시간 설정
              curve: Curves.easeInOut, // 스크롤 애니메이션 곡선 설정
            );
          }
        }
      },
      child: Align(
        alignment: Alignment.centerLeft, // 이미지의 정렬 위치 설정 (왼쪽 정렬)
        child: Image.network(
          eventImage, // 네트워크 이미지 URL 설정
          width: appBarTitleWidth * 0.20, // 이미지 가로 크기를 앱바 제목 크기의 20%로 설정
          height: appBarTitleHeight, // 이미지 세로 크기 설정
          fit: BoxFit.contain, // 이미지 맞춤 방식 설정
        ),
      ),
    );
  }

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
              // } else if (platformType == 'ios') {
              //   Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (_) => EasyLoginIosScreen()),
              //   );
              // } else if (platformType == 'aos') {
              //   Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (_) => EasyLoginAosScreen()),
              //   );
              } else {
                showCustomSnackBar(
                    context, '이전 화면으로 이동할 수 없습니다.'); // 이전 페이지로 돌아갈 수 없다는 메시지 표시
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
          // 드로어 아이콘 너비 설정
          height: drawerIconHeight,
          // 드로어 아이콘 높이 설정
          margin: EdgeInsets.only(left: drawerIconX, top: drawerIconY),
          // 아이콘 위치 설정
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
      break;
    case 2:
      // 케이스 2: 찜 목록 버튼만 노출
      if (wishlistBtnWidth != null &&
          wishlistBtnHeight != null &&
          wishlistBtnX != null &&
          wishlistBtnY != null) {
        actions.add(
          Consumer(
            builder: (context, ref, _) {
              // wishlistItemCountProvider를 구독하여 장바구니 아이템 수를 실시간으로 확인
              final wishlistItemCount =
                  ref.watch(wishlistItemCountProvider).value ?? 0;
              return Container(
                width: wishlistBtnWidth, // 찜 목록 버튼 너비 설정
                height: wishlistBtnHeight, // 찜 목록 버튼 높이 설정
                margin: EdgeInsets.only(
                    right: wishlistBtnX, top: wishlistBtnY), // 찜 목록 버튼의 위치 설정
                child: Stack(
                  alignment: Alignment.center, // 아이콘과 뱃지를 겹쳐 정렬
                  clipBehavior: Clip.none, // 배지가 아이콘 영역을 넘어도 표시되도록 설정
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border, color: BLACK_COLOR),
                      // 찜 목록 아이콘을 사용함.
                      // WishlistMainScreen()을 tabIndex=4로 한 것은 BottomNavigationBar에는 해당 버튼을 생성하지는 않았으므로
                      // 단순히 찜 목록 화면으로 이동할 때의 고유한 식별자 역할을 하는 인덱스 값이며, 상태 관리 로직에서는 다른 화면과 구분되기 위해 사용함.
                      // 그래서, 홈:0, 장바구니:1, 발주내역:2, 마이페이지:3의 숫자를 피해서 적용
                      onPressed: () => navigateToScreenAndRemoveUntil(context,
                          ref, WishlistMainScreen(), 4), // 찜 목록 화면으로 이동
                    ),
                    if (wishlistItemCount > 0)
                      Positioned(
                        top: -interval2Y, // 뱃지의 Y축 위치
                        right: interval2X, // 뱃지의 X축 위치
                        child: Container(
                          padding: EdgeInsets.all(2), // 뱃지 내부 여백
                          decoration: BoxDecoration(
                            color: ORANGE56_COLOR, // 뱃지 배경색 (주황색)
                            shape: BoxShape.circle, // 뱃지 모양 (원형)
                          ),
                          child: Text(
                            wishlistItemCount >= 100
                                ? '99+'
                                : '$wishlistItemCount',
                            // 100개 이상은 '99+', 그렇지 않으면 실제 갯수 표시
                            style: TextStyle(
                              color: WHITE_COLOR,
                              // 뱃지 텍스트 색상
                              fontSize: appBarWishlistItemCountTextFontSize,
                              // 텍스트 크기
                              fontWeight: FontWeight.bold, // 텍스트 두께
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
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
          Consumer(
            builder: (context, ref, _) {
              // wishlistItemCountProvider를 구독하여 장바구니 아이템 수를 실시간으로 확인
              final wishlistItemCount =
                  ref.watch(wishlistItemCountProvider).value ?? 0;
              return Container(
                width: wishlistBtnWidth, // 찜 목록 버튼 너비 설정
                height: wishlistBtnHeight, // 찜 목록 버튼 높이 설정
                margin: EdgeInsets.only(
                    right: wishlistBtnX, top: wishlistBtnY), // 찜 목록 버튼의 위치 설정
                child: Stack(
                  alignment: Alignment.center, // 아이콘과 뱃지를 겹쳐 정렬
                  clipBehavior: Clip.none, // 배지가 아이콘 영역을 넘어도 표시되도록 설정
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border, color: BLACK_COLOR),
                      // 찜 목록 아이콘을 사용함.
                      // WishlistMainScreen()을 tabIndex=4로 한 것은 BottomNavigationBar에는 해당 버튼을 생성하지는 않았으므로
                      // 단순히 찜 목록 화면으로 이동할 때의 고유한 식별자 역할을 하는 인덱스 값이며, 상태 관리 로직에서는 다른 화면과 구분되기 위해 사용함.
                      // 그래서, 홈:0, 장바구니:1, 발주내역:2, 마이페이지:3의 숫자를 피해서 적용
                      onPressed: () => navigateToScreenAndRemoveUntil(context,
                          ref, WishlistMainScreen(), 4), // 찜 목록 화면으로 이동
                    ),
                    if (wishlistItemCount > 0)
                      Positioned(
                        top: -interval2Y, // 뱃지의 Y축 위치
                        right: interval2X, // 뱃지의 X축 위치
                        child: Container(
                          padding: EdgeInsets.all(2), // 뱃지 내부 여백
                          decoration: BoxDecoration(
                            color: ORANGE56_COLOR, // 뱃지 배경색 (주황색)
                            shape: BoxShape.circle, // 뱃지 모양 (원형)
                          ),
                          child: Text(
                            wishlistItemCount >= 100
                                ? '99+'
                                : '$wishlistItemCount',
                            // 100개 이상은 '99+', 그렇지 않으면 실제 갯수 표시
                            style: TextStyle(
                              color: WHITE_COLOR,
                              // 뱃지 텍스트 색상
                              fontSize: appBarWishlistItemCountTextFontSize,
                              // 텍스트 크기
                              fontWeight: FontWeight.bold, // 텍스트 두께
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          // 홈 버튼
          Container(
            width: homeBtnWidth, // 홈 버튼 너비 설정
            height: homeBtnHeight, // 홈 버튼 높이 설정
            margin: EdgeInsets.only(
              right: homeBtnX,
              top: homeBtnY,
            ),
            child: IconButton(
              icon: Icon(Icons.home_outlined, color: BLACK_COLOR), // 홈 아이콘
              onPressed: () => navigateToScreenAndRemoveUntil(
                  context, ref, MainHomeScreen(), 0), // 홈 화면으로 이동
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
          Consumer(
            builder: (context, ref, _) {
              // wishlistItemCountProvider를 구독하여 장바구니 아이템 수를 실시간으로 확인
              final wishlistItemCount =
                  ref.watch(wishlistItemCountProvider).value ?? 0;
              return Container(
                width: wishlistBtnWidth, // 찜 목록 버튼 너비 설정
                height: wishlistBtnHeight, // 찜 목록 버튼 높이 설정
                margin: EdgeInsets.only(
                    right: wishlistBtnX, top: wishlistBtnY), // 찜 목록 버튼의 위치 설정
                child: Stack(
                  alignment: Alignment.center, // 아이콘과 뱃지를 겹쳐 정렬
                  clipBehavior: Clip.none, // 배지가 아이콘 영역을 넘어도 표시되도록 설정
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border, color: BLACK_COLOR),
                      // 찜 목록 아이콘을 사용함.
                      // WishlistMainScreen()을 tabIndex=4로 한 것은 BottomNavigationBar에는 해당 버튼을 생성하지는 않았으므로
                      // 단순히 찜 목록 화면으로 이동할 때의 고유한 식별자 역할을 하는 인덱스 값이며, 상태 관리 로직에서는 다른 화면과 구분되기 위해 사용함.
                      // 그래서, 홈:0, 장바구니:1, 발주내역:2, 마이페이지:3의 숫자를 피해서 적용
                      onPressed: () => navigateToScreenAndRemoveUntil(context,
                          ref, WishlistMainScreen(), 4), // 찜 목록 화면으로 이동
                    ),
                    if (wishlistItemCount > 0)
                      Positioned(
                        top: -interval2Y, // 뱃지의 Y축 위치
                        right: interval2X, // 뱃지의 X축 위치
                        child: Container(
                          padding: EdgeInsets.all(2), // 뱃지 내부 여백
                          decoration: BoxDecoration(
                            color: ORANGE56_COLOR, // 뱃지 배경색 (주황색)
                            shape: BoxShape.circle, // 뱃지 모양 (원형)
                          ),
                          child: Text(
                            wishlistItemCount >= 100
                                ? '99+'
                                : '$wishlistItemCount',
                            // 100개 이상은 '99+', 그렇지 않으면 실제 갯수 표시
                            style: TextStyle(
                              color: WHITE_COLOR,
                              // 뱃지 텍스트 색상
                              fontSize: appBarWishlistItemCountTextFontSize,
                              // 텍스트 크기
                              fontWeight: FontWeight.bold, // 텍스트 두께
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          // 홈 버튼
          Container(
            width: homeBtnWidth, // 홈 버튼 너비 설정
            height: homeBtnHeight, // 홈 버튼 높이 설정
            margin: EdgeInsets.only(
              right: homeBtnX,
              top: homeBtnY,
            ),
            child: IconButton(
              icon: Icon(Icons.home_outlined, color: BLACK_COLOR), // 홈 아이콘
              onPressed: () => navigateToScreenAndRemoveUntil(
                  context, ref, MainHomeScreen(), 0), // 홈 화면으로 이동
            ),
          ),
          // 장바구니 버튼
          Consumer(
            builder: (context, ref, _) {
              // cartItemCountProvider를 구독하여 장바구니 아이템 수를 실시간으로 확인
              final cartItemCount = ref.watch(cartItemCountProvider).value ?? 0;

              return Container(
                width: cartlistBtnWidth, // 장바구니 버튼 너비
                height: cartlistBtnHeight, // 장바구니 버튼 높이
                margin: EdgeInsets.only(
                  right: cartlistBtnX, // 오른쪽 마진
                  top: cartlistBtnY, // 위쪽 마진
                ),
                child: Stack(
                  alignment: Alignment.center, // 아이콘과 뱃지를 겹쳐 정렬
                  clipBehavior: Clip.none, // 배지가 아이콘 영역을 넘어도 표시되도록 설정
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.shopping_cart_outlined, // 장바구니 아이콘
                        color: BLACK_COLOR,
                      ),
                      onPressed: () => navigateToScreenAndRemoveUntil(
                        context,
                        ref,
                        CartMainScreen(), // 장바구니 화면으로 이동
                        1,
                      ),
                    ),
                    if (cartItemCount > 0)
                      Positioned(
                        top: -interval1Y, // 뱃지의 Y축 위치
                        right: interval1X, // 뱃지의 X축 위치
                        child: Container(
                          padding: EdgeInsets.all(2), // 뱃지 내부 여백
                          decoration: BoxDecoration(
                            color: ORANGE56_COLOR, // 뱃지 배경색 (주황색)
                            shape: BoxShape.circle, // 뱃지 모양 (원형)
                          ),
                          child: Text(
                            cartItemCount >= 100 ? '99+' : '$cartItemCount',
                            // 100개 이상은 '99+', 그렇지 않으면 실제 갯수 표시
                            style: TextStyle(
                              color: WHITE_COLOR,
                              // 뱃지 텍스트 색상
                              fontSize: appBarCartItemCountTextFontSize,
                              // 텍스트 크기
                              fontWeight: FontWeight.bold, // 텍스트 두께
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ]);
      }
      break;
  }

  // AppBar를 반환
  return AppBar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    // AppBar의 배경 색상 설정, 앱의 기본 배경 색상을 사용함
    toolbarHeight: appBarHeight,
    // 앱 바의 높이를 설정
    title: Container(
      // alignment: Alignment.center,
      width: appBarTitleWidth,
      // 텍스트 너비 설정
      height: appBarTitleHeight,
      // 텍스트 높이 설정
      margin: EdgeInsets.only(left: appBarTitleX, top: appBarTitleY),
      // 텍스트 위치 설정
      child: Stack(
        alignment: Alignment.center, // 자식 위젯들이 중앙에 정렬되도록 설정함
        children: [
          if (eventImageWidget != null) eventImageWidget,
          Center(
            child: titleImage != null
                ? Image.network(
                    titleImage, // 네트워크에서 제목 이미지를 불러옴
                    fit: BoxFit.cover, // 이미지 크기를 조정하여 영역 내에 맞춤
                  )
                : (titleImagePath != null
                    ? Image.asset(
                        titleImagePath, // 로컬 자산에서 제목 이미지를 불러옴
                        fit: BoxFit.contain, // 이미지 크기를 조정하여 영역 내에 맞춤
                      )
                    : Text(
                        title, // 설정된 제목을 텍스트로 표시함
                        style: TextStyle(
                          color: BLACK_COLOR, // 텍스트 색상을 검정색으로 설정함
                          fontSize: titleFontSize, // 텍스트 크기를 설정함
                          fontWeight: FontWeight.bold, // 텍스트를 굵게 설정함
                          fontFamily: fontFamily, // 텍스트 폰트를 설정함
                        ),
                        maxLines: 1, // 텍스트가 한 줄로 표시되도록 설정함
                        overflow:
                            TextOverflow.ellipsis, // 텍스트가 길 경우 생략 부호(...)를 표시함
                      )),
          ),
        ],
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
Widget buildCommonBottomNavigationBar(int selectedIndex, WidgetRef ref,
    BuildContext context, int colorCase, int navigationCase,
    {ProductContent? product, required ScrollController scrollController}) {
  // FirebaseAuth로 현재 사용자 정보를 가져옴
  final user = FirebaseAuth.instance.currentUser;

  // 숫자 형식을 지정하기 위한 NumberFormat 객체 생성
  final numberFormat = NumberFormat('###,###'); // 천 단위일때마다 쉼표 표시

  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정

  // 하단 탭 바 내 장바구니 아이콘의 장바구니 아이템 갯수 구현 부분 관련 수치
  final double bottomNavigationIconSize =
      screenSize.width * (24 / referenceWidth);
  final double interval1X = screenSize.width * (25.5 / referenceWidth); // 세로 비율
  final double badgeSize = screenSize.width * (20 / referenceWidth); // 배지 크기
  final double badgeTextFontSize =
      screenSize.height * (12 / referenceHeight); // 배지 텍스트 크기
  final double badgeOffsetX =
      screenSize.width * (20 / referenceWidth); // 배지의 X축 오프셋
  final double badgeOffsetY =
      screenSize.height * (5 / referenceHeight); // 배지의 Y축 오프셋
  final double bottomNavigationIconTextFontSize =
      screenSize.height * (10 / referenceHeight); // 아이콘 하단 텍스트 수치

  switch (navigationCase) {
    // '홈', '장바구니', '발주내역', '마이페이지' 버튼을 UI로 구현한 케이스
    case 1:
      // 선택된 아이템의 색상을 초기화
      Color selectedColor = BLACK_COLOR;
      // 선택되지 않은 아이템의 색상을 초기화
      Color unselectedColor = WHITE_COLOR;

      // colorCase 값에 따라 선택된 아이템의 색상을 설정
      switch (colorCase) {
        case 1: // 홈 버튼만 선택된 경우
          selectedColor = BLACK_COLOR;
          break;
        case 2: // 장바구니 버튼만 선택된 경우
          selectedColor = BLACK_COLOR;
          break;
        case 3: // 발주 내역 버튼만 선택된 경우
          selectedColor = BLACK_COLOR;
          break;
        case 4: // 마이페이지 버튼만 선택된 경우
          selectedColor = BLACK_COLOR;
          break;
        case 5: // 모든 버튼이 선택되지 않은 경우
          selectedColor = WHITE_COLOR;
          break;
      }

      return Container(
        color: ORANGE56_COLOR, // 전체 배경색을 지정
        child: SafeArea(
          bottom: false, // 하단 SafeArea를 무효화하여 경계선을 제거
          child: Container(
            height: MediaQuery.of(context).size.height *
                0.098, // 화면 높이에 비례하여 동적 높이 설정
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              // BottomNavigationBar 타입을 고정형으로 설정
              backgroundColor: ORANGE56_COLOR,
              // 배경색을 0xFF6FAD96으로 설정,
              currentIndex:
                  selectedIndex >= 0 && selectedIndex < 4 ? selectedIndex : 0,
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
                          return MainHomeScreen();
                        case 1:
                          return CartMainScreen();
                        case 2:
                          return OrderListMainScreen();
                        case 3:
                          return ProfileMainScreen();
                        default:
                          return MainHomeScreen();
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
                    padding: EdgeInsets.symmetric(horizontal: interval1X),
                    // 간격을 51로 설정 (좌우 25.5씩)
                    child: Icon(
                      Icons.home_outlined,
                      size: bottomNavigationIconSize,
                    ), // 홈 아이콘
                  ),
                  label: '홈', // 홈 라벨
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: interval1X),
                    child: Consumer(
                      builder: (context, ref, _) {
                        final cartItemCount =
                            ref.watch(cartItemCountProvider).value ?? 0;

                        return Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none, // 배지가 아이콘 영역을 넘어도 표시되도록 설정
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: bottomNavigationIconSize,
                            ),
                            if (cartItemCount > 0)
                              Positioned(
                                right: -badgeOffsetX, // 아이콘의 우측 상단으로 위치 설정
                                top: -badgeOffsetY, // 아이콘의 상단 위로 위치 설정
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  // 뱃지 내부 여백
                                  decoration: BoxDecoration(
                                    color: BLUE49_COLOR, // 뱃지 배경색 (주황색)
                                    shape: BoxShape.circle, // 뱃지 모양 (원형)
                                  ),
                                  // child: Container(
                                  //   width: badgeSize,
                                  //   height: badgeSize,
                                  //   padding: EdgeInsets.all(1), // 뱃지 내부 여백
                                  //   alignment: Alignment.center,
                                  //   decoration: BoxDecoration(
                                  //   color: BLUE49_COLOR, // 뱃지 배경색 (주황색)
                                  //   shape: BoxShape.circle, // 뱃지 모양 (원형)
                                  //   // decoration: BoxDecoration(
                                  //   //   color: Colors.transparent, // 배경색을 투명으로 설정
                                  //   //   shape: BoxShape.circle, // 배지 모양을 원형으로 설정
                                  //   //   border: Border.all( // 테두리 설정
                                  //   //     color: BLUE49_COLOR, // 테두리 색상 흰색
                                  //   //     width: 2.0, // 테두리 두께
                                  //   //   ),
                                  //   // ),
                                  //   ),
                                  child: Text(
                                    cartItemCount >= 100
                                        ? '99+'
                                        : '$cartItemCount',
                                    // 100개 이상은 '99+'로 표시
                                    style: TextStyle(
                                      color: WHITE_COLOR, // 텍스트 색상
                                      fontSize: badgeTextFontSize, // 텍스트 크기
                                      fontWeight: FontWeight.bold, // 텍스트 두께
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  label: '장바구니',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: interval1X),
                    child: Icon(Icons.receipt_long_outlined,
                        size: bottomNavigationIconSize), // 발주 내역 아이콘
                  ),
                  label: '발주내역', // 발주 내역 라벨
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: interval1X),
                    child: Icon(Icons.person_outlined,
                        size: bottomNavigationIconSize), // 마이페이지 아이콘
                  ),
                  label: '마이페이지', // 마이페이지 라벨
                ),
              ],
              selectedItemColor: selectedColor,
              unselectedItemColor: unselectedColor,
              selectedFontSize: bottomNavigationIconTextFontSize,
              // 선택된 아이템의 폰트 크기
              unselectedFontSize: bottomNavigationIconTextFontSize,
              // 선택되지 않은 아이템의 폰트 크기
              selectedLabelStyle: TextStyle(
                fontFamily: 'NanumGothic', // 폰트 패밀리 설정
                fontWeight: FontWeight.bold, // 텍스트를 bold로 설정
                fontSize: bottomNavigationIconTextFontSize, // 텍스트 크기를 10으로 설정
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'NanumGothic', // 폰트 패밀리 설정
                fontWeight: FontWeight.bold, // 텍스트를 bold로 설정
                fontSize: bottomNavigationIconTextFontSize, // 텍스트 크기를 10으로 설정
              ),
            ),
          ),
        ),
      );

    // '장바구니', '바로 발주' 버튼을 UI로 구현한 케이스
    case 2:
      if (product == null) {
        throw ArgumentError(
            '네비게이션 케이스 2에서는 제품이 반드시 제공되어야 합니다'); // 제품이 제공되지 않은 경우 예외 처리
      }

      // 선택된 색상, 사이즈, 수량 등을 상태에서 가져옴
      final selectedColorUrl =
          ref.watch(colorSelectionUrlProvider); // 선택된 색상 URL 상태 값 가져오기
      final selectedColorText =
          ref.watch(colorSelectionTextProvider); // 선택된 색상 텍스트 상태 값 가져오기
      final selectedSize =
          ref.watch(sizeSelectionIndexProvider); // 선택된 사이즈 상태 값 가져오기
      final quantity =
          ref.watch(detailQuantityIndexProvider); // 선택된 수량 상태 값 가져오기

      // 선택된 수량을 반영하여 가격 계산
      double totalProductPrice =
          (product.originalPrice ?? 0).toDouble() * quantity; // 총 제품 가격 계산
      double productDiscountPrice = ((product.originalPrice ?? 0).toDouble() -
              (product.discountPrice ?? 0).toDouble()) *
          quantity; // 할인된 금액 계산
      double totalPaymentPrice =
          (product.discountPrice ?? 0).toDouble() * quantity; // 총 결제 금액 계산

      // 선택된 옵션과 수량을 반영한 ProductContent 객체 생성
      final orderProduct = ProductContent(
        docId: product.docId,
        // 제품 문서 ID 설정
        category: product.category ?? '',
        // 제품 카테고리 설정
        productNumber: product.productNumber ?? '',
        // 제품 번호 설정
        thumbnail: product.thumbnail ?? '',
        // 제품 썸네일 설정
        briefIntroduction: product.briefIntroduction ?? '',
        // 제품 간단 소개 설정
        originalPrice: (product.originalPrice ?? 0),
        // 원래 가격 설정
        discountPrice: (product.discountPrice ?? 0),
        // 할인 가격 설정
        discountPercent: (product.discountPercent ?? 0),
        // 할인 퍼센트 설정
        selectedCount: quantity,
        // 선택한 수량 설정
        selectedColorImage: selectedColorUrl ?? '',
        // 선택한 색상 이미지 URL 설정
        selectedColorText: selectedColorText ?? '',
        // 선택한 색상 텍스트 설정
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
      final double bottomBtnC2Height =
          screenSize.height * (50 / referenceHeight);
      final double bottomBtnC2X = screenSize.width * (20 / referenceWidth);
      final double bottomBtnC2Y = screenSize.height * (10 / referenceHeight);
      final double bottomBarC2Y = screenSize.height * (15 / referenceHeight);
      final double bottomBtnFontSize =
          screenSize.height * (14 / referenceHeight);

      // 컨텐츠 사이의 수치 적용
      final double interval1X = screenSize.width * (10 / referenceWidth);

      return Container(
        color: Theme.of(context).scaffoldBackgroundColor, // 전체 배경색을 지정
        child: SafeArea(
          bottom: false, // 하단 SafeArea를 무효화하여 경계선을 제거
          child: Container(
            height: MediaQuery.of(context).size.height *
                0.098, // 화면 높이에 비례하여 동적 높이 설정
            padding: EdgeInsets.only(bottom: bottomBarC2Y),
            // UI 패딩 설정
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: bottomBtnC2X, vertical: bottomBtnC2Y),
              // 좌우 bottomBtnC2X, 상하 bottomBtnC2Y의 여백 추가
              child: Row(
                // 수평으로 배치되는 Row 위젯 사용
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // Row 내부 위젯들을 양 끝에 배치
                children: [
                  Container(
                    width: bottomBtnC2Width,
                    height: bottomBtnC2Height,
                    child: ElevatedButton(
                      onPressed: () {
                        if (user == null) {
                          // 사용자 정보가 없으면 로그인 안내 알림창 표시
                          showSubmitAlertDialog(
                            context,
                            title: '[로그인 상태]',
                            content: '로그인 후 이용해주세요.',
                            actions: [
                              TextButton(
                                child: Text(
                                  '확인',
                                  style: TextStyle(
                                    color: ORANGE56_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NanumGothic',
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        } else {
                          onCartButtonPressed(context, ref, product);
                        }
                      },
                      // 요청품목 버튼 클릭 시 실행될 함수 지정
                      style: ElevatedButton.styleFrom(
                        foregroundColor: WHITE_COLOR, // 텍스트 색상
                        backgroundColor: ORANGE56_COLOR, // 배경 색상
                      ),
                      child: Text(
                        '장바구니 담기',
                        style: TextStyle(
                          fontFamily: 'NanumGothic',
                          fontSize: bottomBtnFontSize,
                          fontWeight: FontWeight.bold,
                          color: WHITE_COLOR,
                        ),
                      ), // 버튼 텍스트 설정
                    ),
                  ),
                  SizedBox(width: interval1X), // 버튼들 사이에 10픽셀 너비의 여백 추가
                  Container(
                    // 버튼의 가로 크기
                    width: bottomBtnC2Width,
                    // 버튼의 세로 크기
                    height: bottomBtnC2Height,
                    child: ElevatedButton(
                      // 버튼이 눌렸을 때 실행되는 동작 정의
                      onPressed: () {
                        if (user == null) {
                          // 사용자 정보가 없는 경우 로그인 안내 알림창 표시
                          showSubmitAlertDialog(
                            context,
                            // 알림창 제목
                            title: '[로그인 상태]',
                            // 알림창 내용
                            content: '로그인 후 이용해주세요.',
                            // 알림창의 동작 버튼 정의
                            actions: [
                              TextButton(
                                // 버튼 텍스트 정의
                                child: Text(
                                  '확인',
                                  style: TextStyle(
                                    // 텍스트 색상
                                    color: ORANGE56_COLOR,
                                    // 텍스트 두께
                                    fontWeight: FontWeight.bold,
                                    // 텍스트 폰트
                                    fontFamily: 'NanumGothic',
                                  ),
                                ),
                                // 확인 버튼 눌렀을 때 실행되는 동작
                                onPressed: () {
                                  Navigator.of(context).pop(); // 알림창 닫기
                                },
                              ),
                            ],
                          );
                        } else {
                          // 사용자 정보가 있는 경우 추가 조건 확인
                          if (totalPaymentPrice >= 30000) {
                            // 결제 금액이 30,000원 이상일 때 실행
                            ref
                                .read(orderItemsProvider.notifier)
                                .setOrderItems([orderProduct]);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => OrderMainScreen(
                                  // 총 상품 가격 전달
                                  totalProductPrice:
                                      totalProductPrice.toDouble(),
                                  // 할인 금액 전달
                                  productDiscountPrice:
                                      productDiscountPrice.toDouble(),
                                ),
                              ),
                            );
                          } else {
                            // 결제 금액이 30,000원 미만일 때 경고 메시지 표시
                            showCustomSnackBar(
                                context, '30,000원 이상 금액부터 발주 요청이 가능합니다.');
                          }
                        }
                      },
                      // ElevatedButton의 스타일 설정
                      style: ElevatedButton.styleFrom(
                        // 버튼 텍스트 색상
                        foregroundColor: WHITE_COLOR,
                        // 버튼 배경 색상
                        backgroundColor: ORANGE56_COLOR,
                      ),
                      // 버튼 내부 텍스트 정의
                      child: Text(
                        '바로 발주',
                        style: TextStyle(
                          // 텍스트 폰트
                          fontFamily: 'NanumGothic',
                          // 텍스트 크기
                          fontSize: bottomBtnFontSize,
                          // 텍스트 두께
                          fontWeight: FontWeight.bold,
                          // 텍스트 색상
                          color: WHITE_COLOR,
                        ),
                      ), // 버튼 텍스트 정의 끝
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

      // 선택된 아이템들의 합계 금액 계산
      int totalSelectedPrice = cartItems
          // 아이템 목록 중 선택된 아이템만 필터링
          .where((item) => item['bool_checked'] == true)
          // 선택된 아이템들의 합계 금액을 계산
          .fold(
              0,
              (sum, item) =>
                  sum +
                  (item['discount_price'] as num).toInt() *
                      (item['selected_count'] as num).toInt());

      int totalProductPrice = cartItems
          .where((item) => item['bool_checked'] == true) // 선택된 아이템들만 필터링
          .fold(
              0,
              (sum, item) =>
                  sum +
                  (item['original_price'] as num).toInt() *
                      (item['selected_count'] as num)
                          .toInt()); // 원래 가격과 선택된 수량을 곱한 값을 더하여 총 상품금액 계산

      int totalPaymentPrice = cartItems
          .where((item) => item['bool_checked'] == true) // 선택된 아이템들만 필터링
          .fold(
              0,
              (sum, item) =>
                  sum +
                  (item['discount_price'] as num).toInt() *
                      (item['selected_count'] as num)
                          .toInt()); // 할인된 가격과 선택된 수량을 곱한 값을 더하여 총 결제금액 계산

      int totalDiscountPrice = totalProductPrice -
          totalPaymentPrice; // 총 상품금액에서 총 결제금액을 빼서 총 할인금액 계산

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
          // ProductContent 객체의 selectedCount 필드를 item의 'selected_count' 값으로 설정
          selectedCount: item['selected_count'],
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

      // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
      final Size screenSize = MediaQuery.of(context).size;

      // 기준 화면 크기: 가로 393, 세로 852
      final double referenceWidth = 393.0;
      final double referenceHeight = 852.0;

      // 비율을 기반으로 동적으로 크기와 위치 설정

      // 버튼 관련 수치 동적 적용
      final double bottomBtnC2Width = screenSize.width * (100 / referenceWidth);
      final double bottomBtnC2Height =
          screenSize.height * (40 / referenceHeight);
      final double bottomBtnC1X = screenSize.width * (2 / referenceWidth);
      final double bottomBtnC2X = screenSize.width * (24 / referenceWidth);
      final double bottomBtnC2Y = screenSize.height * (10 / referenceHeight);
      final double bottomBarC2Y = screenSize.height * (15 / referenceHeight);
      final double bottomTextFontSize =
          screenSize.height * (14 / referenceHeight);
      final double bottomBtnFontSize =
          screenSize.height * (14 / referenceHeight);

      return Container(
        color: Theme.of(context).scaffoldBackgroundColor, // 전체 배경색을 지정
        child: SafeArea(
          bottom: false, // 하단 SafeArea를 무효화하여 경계선을 제거
          child: Container(
            height: MediaQuery.of(context).size.height *
                0.098, // 화면 높이에 비례하여 동적 높이 설정
            padding: EdgeInsets.only(bottom: bottomBarC2Y),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: bottomBtnC2X, vertical: bottomBtnC2Y),
              // 좌우 bottomBtnC2X, 상하 bottomBtnC2Y의 여백 추가
              child: Row(
                // Row의 주 축 방향에서의 정렬 방식을 공간을 동일하게 나눔
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 전체 선택 체크박스와 텍스트를 담을 Row
                  Row(
                    children: [
                      // 체크박스 크기를 1.3배로 확대
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          // 체크박스의 선택 여부를 allChecked 상태로 설정
                          value: allChecked,
                          activeColor: ORANGE56_COLOR, // 체크박스 색상 변경
                          // 체크박스 상태 변경 시 호출되는 함수
                          onChanged: (bool? value) {
                            // allCheckedProvider 상태 업데이트
                            ref.read(allCheckedProvider.notifier).state =
                                value!;
                            // cartItemsProvider 상태에서 모든 아이템의 체크 상태를 변경
                            ref
                                .read(cartItemsProvider.notifier)
                                .toggleAll(value);
                          },
                        ),
                      ),
                      // 체크박스와 텍스트 사이의 간격 설정
                      SizedBox(width: bottomBtnC1X),
                      // "전체" 텍스트를 표시
                      Text(
                        '전체',
                        // 텍스트 스타일 설정
                        style: TextStyle(
                          fontSize: bottomTextFontSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NanumGothic',
                          color: BLACK_COLOR,
                        ),
                      ),
                    ],
                  ),
                  // 합계 텍스트를 중앙에 위치하도록 Expanded로 감쌈
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '합계: ${totalSelectedPrice != null ? numberFormat.format(totalSelectedPrice) : ''}원',
                        style: TextStyle(
                          fontSize: bottomTextFontSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NanumGothic',
                          color: BLACK_COLOR,
                        ),
                      ),
                    ),
                  ),
                  // 오른쪽에 "발주하기" 버튼을 배치
                  Container(
                    // 버튼의 가로 크기
                    // width: bottomBtnC2Width,
                    // 버튼의 세로 크기
                    height: bottomBtnC2Height,
                    child: ElevatedButton(
                      // '발주하기' 버튼 클릭 시 동작
                      onPressed: () {
                        if (user == null) {
                          // 사용자 정보가 없으면 로그인 안내 알림창 표시
                          showSubmitAlertDialog(
                            context,
                            title: '[로그인 상태]',
                            content: '로그인 후 이용해주세요.',
                            actions: [
                              TextButton(
                                child: Text(
                                  '확인',
                                  style: TextStyle(
                                    color: ORANGE56_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NanumGothic',
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        } else {
                          if (orderProducts.isEmpty) {
                            // 선택된 상품이 없으면 경고 메시지 표시
                            showCustomSnackBar(context, '발주 요청할 상품을 선택해주세요.');
                          } else {
                            // 상품번호 앞 세 자리 확인 로직
                            final List<String> productPrefixes = orderProducts
                                .map((item) => item.productNumber != null
                                ? item.productNumber!.substring(0, 3)
                                : '') // productNumber가 null이면 빈 문자열 반환
                                .toList();

                            // 모든 앞 세 자리가 동일한지 검사
                            final bool allSamePrefix =
                            productPrefixes.every((prefix) => prefix == productPrefixes.first);

                            if (!allSamePrefix) {
                              // 앞 세 자리가 다른 경우 경고 메시지 표시
                              showCustomSnackBar(context, '동일한 상점 상품끼리만 묶음 발주가 가능합니다.',
                                  duration: Duration(milliseconds: 2000), // 2초 동안 유지
                              );
                              return; // 버튼 동작 중단
                            }

                            // 앞 세 자리가 동일하고 결제 금액 조건 검사
                            if (totalPaymentPrice >= 30000) {
                              // 정상 동작: 발주 화면으로 이동
                              ref.read(orderItemsProvider.notifier).setOrderItems(orderProducts);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => OrderMainScreen(
                                    totalProductPrice: totalProductPrice.toDouble(),
                                    productDiscountPrice: totalDiscountPrice.toDouble(),
                                  ),
                                ),
                              );
                            } else {
                              // 결제 금액이 30,000원 미만인 경우 경고 메시지 표시
                              showCustomSnackBar(context, '30,000원 이상 금액부터 발주 요청이 가능합니다.');
                            }
                          }
                        }
                      },
                      // 버튼 스타일 설정
                      style: ElevatedButton.styleFrom(
                        // 버튼 텍스트 색상
                        foregroundColor: WHITE_COLOR,
                        // 버튼 배경 색상
                        backgroundColor: ORANGE56_COLOR,
                      ),
                      // 버튼 텍스트 정의
                      child: Text(
                        '발주하기',
                        style: TextStyle(
                          // 폰트 패밀리
                          fontFamily: 'NanumGothic',
                          // 텍스트 크기
                          fontSize: bottomBtnFontSize,
                          // 텍스트 두께
                          fontWeight: FontWeight.bold,
                          // 텍스트 색상
                          color: WHITE_COLOR,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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

TextStyle topBarTextStyle(
    int currentIndex, int buttonIndex, BuildContext context) {
  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  final double topBarTextFontSize = screenSize.height * (16 / referenceHeight);

  return TextStyle(
    fontSize: topBarTextFontSize, // Figma에서 확인한 텍스트 크기
    fontWeight: FontWeight.bold, // 폰트 굵기 설정
    color: currentIndex == buttonIndex ? ORANGE56_COLOR : GRAY45_COLOR,
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
  final double topBarListHeight =
      screenSize.width * (52 / referenceWidth); // 탑 바 리스트 높이
  final double topBarListX =
      screenSize.width * (16 / referenceWidth); // 탑 바 리스트 X 좌표
  final double topBarBtnHeight =
      screenSize.height * (52 / referenceHeight); // 탑 바 버튼 높이
  final double topBarListPaddingX =
      screenSize.width * (22 / referenceWidth); // 탑 바 리스트 패딩 X 좌표

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
                alignment: Alignment.center,
                // Container 내부 내용을 중앙 정렬
                height: topBarBtnHeight,
                padding: EdgeInsets.symmetric(horizontal: topBarListPaddingX),
                // 좌우로 패딩 적용
                child: Text(category,
                    style: topBarTextStyle(currentIndex, index, context)),
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
  // FirebaseAuth에서 현재 로그인한 사용자의 이메일을 가져옴.
  final String? userEmail = FirebaseAuth.instance.currentUser?.email;

  // 사용자 이메일이 특정 관리자 이메일과 일치하는지 확인하여 관리자 여부를 결정
  // 관리자 이메일
  final List<String> adminEmail = ['gshe.couture@gmail.com'];

  // 상점주 이메일 (30개의 계정 포함)
  final List<String> subAdminEmails = [
    'wearcano.md.aaa@gmail.com',
    'wearcano.md.aab@gmail.com',
    'wearcano.md.aac@gmail.com',
    'wearcano.md.aad@gmail.com',
    'wearcano.md.aae@gmail.com',
    'wearcano.md.aaf@gmail.com',
    'wearcano.md.aag@gmail.com',
    'wearcano.md.aah@gmail.com',
    'wearcano.md.aai@gmail.com',
    'wearcano.md.aaj@gmail.com',
    'wearcano.md.aak@gmail.com',
    'wearcano.md.aal@gmail.com',
    'wearcano.md.aam@gmail.com',
    'wearcano.md.aan@gmail.com',
    'wearcano.md.aao@gmail.com',
    'wearcano.md.aap@gmail.com',
    'wearcano.md.aaq@gmail.com',
    'wearcano.md.aar@gmail.com',
    'wearcano.md.aas@gmail.com',
    'wearcano.md.aat@gmail.com',
    'wearcano.md.aau@gmail.com',
    'wearcano.md.aav@gmail.com',
    'wearcano.md.aaw@gmail.com',
    'wearcano.md.aax@gmail.com',
    'wearcano.md.aay@gmail.com',
    'wearcano.md.aaz@gmail.com',
    'wearcano.md.aba@gmail.com',
    'wearcano.md.abb@gmail.com',
    'wearcano.md.abc@gmail.com',
    'wearcano.md.abd@gmail.com',
  ];

// 사용자 이메일이 관리자 이메일 목록에 포함되어 있는지 확인
  // 관리자 여부 확인
  final bool isAdmin = adminEmail.contains(userEmail);
  // 상점주 여부 확인
  final bool isSubAdmin = subAdminEmails.contains(userEmail);
  // 사용자 로그인 상태 확인
  final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 260, 세로 852
  final double referenceWidth = 260.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정
  // 드로워 화면 내 아이콘 요소 수치
  final double drawerLogoIconWidth =
      screenSize.width * (130 / referenceWidth); // 가로 비율
  final double drawerLogoIconHeight =
      screenSize.height * (50 / referenceWidth); // 세로 비율
  final double drawerLogoIconX =
      screenSize.width * (33 / referenceWidth); // 왼쪽 여백 비율
  final double drawerLogoIconY =
      screenSize.height * (70 / referenceHeight); // 위쪽 여백 비율
  final double flowImageLeft = screenSize.width * (0 / referenceWidth);
  final double flowImageTop = screenSize.height * (260 / referenceHeight);
  final double flowImageWidth = screenSize.width * (180 / referenceWidth);
  final double flowImageHeight = screenSize.height * (20 / referenceHeight);

  // 이메일 부분 수치
  final double emailTextFontSize1 = screenSize.height * (20 / referenceHeight);
  final double emailTextFontSize2 = screenSize.height * (16 / referenceHeight);
  final double emailTextFontSize3 = screenSize.height * (10 / referenceHeight);

  // 에러 관련 텍스트 수치
  final double errorTextFontSize1 = screenSize.height * (14 / referenceHeight);
  final double errorTextFontSize2 = screenSize.height * (12 / referenceHeight);
  final double errorTextHeight = screenSize.height * (600 / referenceHeight);

  // 로그아웃 버튼 부분 수치
  final double logoutTextFontSize = screenSize.height * (20 / referenceHeight);
  final double logoutBtnSize = screenSize.height * (20 / referenceHeight);

  // 아이콘 사이의 간격 수치
  final double interval1Y = screenSize.height * (10 / referenceHeight);
  final double interval2Y = screenSize.height * (130 / referenceHeight);
  final double interval3Y = screenSize.height * (10 / referenceHeight);
  final double interval1X = screenSize.width * (10 / referenceWidth);
  final double interval2X = screenSize.width * (15 / referenceWidth);

  // Drawer 위젯을 반환. 이 위젯은 앱의 사이드 메뉴를 구현하는 데 사용.
  return Drawer(
    child: Container(
      color: WHITE_COLOR, // 전체 드로어의 배경색을 흰색으로 설정
      child: Stack(
        children: [
          // 로고 및 이메일 배치
          // Positioned(
          //   left: drawerLogoIconX, // 로고의 X 좌표 설정 (왼쪽 여백)
          //   top: drawerLogoIconY, // 로고의 Y 좌표 설정 (위쪽 여백)
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: drawerLogoIconY,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: drawerLogoIconWidth,
                    height: drawerLogoIconHeight,
                    padding: EdgeInsets.zero,
                    // 패딩 제거
                    margin: EdgeInsets.zero,
                    // 마진 제거
                    child: Image.asset(
                      'asset/img/misc/logo_img/wearcano_logo_v1.png',
                      // fit: BoxFit.contain, // 이미지의 fit 속성 설정
                    ),
                  ),
                  Consumer(builder: (context, ref, child) {
                    // 이메일 확인 및 FutureProvider 호출
                    // 사용자의 이메일 정보를 확인함
                    if (userEmail == null) {
                      // 이메일이 없는 경우 로그인 요청 메시지 출력
                      return Text(
                        '로그인 후 이용해주세요.', // 메시지 텍스트 설정
                        style: TextStyle(
                          fontSize: emailTextFontSize2, // 텍스트 폰트 크기 설정
                          color: BLACK_COLOR, // 텍스트 색상 설정
                          fontFamily: 'NanumGothic', // 텍스트 폰트 패밀리 설정
                          fontWeight: FontWeight.bold, // 텍스트 폰트 굵기 설정
                        ),
                      );
                    }

                    // 사용자 이름을 가져오기 위한 FutureProvider 호출
                    final userNameAsyncValue = ref.watch(drawerUserNameProvider(userEmail));

                    // 사용자 이름 데이터를 기반으로 위젯 생성
                    return userNameAsyncValue.when(
                      data: (userName) {
                        // userName 값이 없거나 비어 있는 경우 기본 메시지 출력
                        if (userName == null || userName.isEmpty) {
                          // 사용자 이름 정보를 불러올 수 없을 때 기본 메시지 출력
                          return Text(
                            '사용자 이름 정보를 불러올 수 없습니다.', // 기본 메시지 텍스트 설정
                            style: TextStyle(
                              fontSize: emailTextFontSize3, // 텍스트 폰트 크기 설정
                              color: BLACK_COLOR, // 텍스트 색상 설정
                              fontFamily: 'NanumGothic', // 텍스트 폰트 패밀리 설정
                              fontWeight: FontWeight.bold, // 텍스트 폰트 굵기 설정
                            ),
                          );
                        }

                        // RichText를 사용하여 사용자 이름과 환영 메시지를 표시함
                        return RichText(
                          text: TextSpan(
                            text: '$userName님', // 첫 번째 텍스트 (사용자 이름)
                            style: TextStyle(
                              fontSize: emailTextFontSize1, // 텍스트 폰트 크기 설정
                              color: BLACK_COLOR, // 텍스트 색상 설정
                              fontFamily: 'NanumGothic', // 텍스트 폰트 패밀리 설정
                              fontWeight: FontWeight.bold, // 텍스트 폰트 굵기 설정
                            ),
                            children: [
                              TextSpan(
                                text: ' 반가워요.', // 두 번째 텍스트 (환영 메시지)
                                style: TextStyle(
                                  fontSize: emailTextFontSize1, // 텍스트 폰트 크기 설정
                                  color: BLACK_COLOR, // 텍스트 색상 설정
                                  fontFamily: 'NanumGothic', // 텍스트 폰트 패밀리 설정
                                  fontWeight: FontWeight.normal, // 텍스트 폰트 굵기 설정
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      // 실시간 데이터 로드 중일 때 로딩 인디케이터 표시
                      loading: () => buildCommonLoadingIndicator(), // 공통 로딩 인디케이터 호출
                      // 실시간 데이터 로드 중 오류가 발생했을 때 처리
                      error: (error, stack) => Container( // 에러 상태에서 중앙 배치
                        height: errorTextHeight, // 컨테이너 높이 설정
                        alignment: Alignment.center, // 컨테이너 중앙 정렬 설정
                        child: buildCommonErrorIndicator(
                          message: '에러가 발생했으니, 앱을 재실행해주세요.', // 에러 메시지 텍스트 설정
                          fontSize1: errorTextFontSize1, // 첫 번째 폰트 크기 설정
                          fontSize2: errorTextFontSize2, // 두 번째 폰트 크기 설정
                          color: BLACK_COLOR, // 텍스트 색상 설정
                          showSecondMessage: false, // 두 번째 메시지 표시 여부 설정
                        ),
                      ),
                    );
                  },
                  ),
                ],
              ),
            ),
          ),
          // 물결 이미지 (Positioned 위젯 사용)
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                // left: flowImageLeft,
                top: flowImageTop,
              ),
              child: Image.asset(
                'asset/img/misc/drawer_img/flow_image.png',
                width: flowImageWidth,
                height: flowImageHeight,
                fit: BoxFit.cover, // 이미지 크기 조정
              ),
            ),
          ),
          // 콘텐츠 영역 관리
          Positioned(
            top: drawerLogoIconY + 1.5 * drawerLogoIconHeight, // 로고 아래의 간격을 최소화
            left: interval1X,
            right: 0,
            child: Column(
              children: <Widget>[
                _buildListTile(
                  context,
                  '네이버 카페 채널',
                  'https://cafe.naver.com/ottbayo',
                  'asset/img/misc/drawer_img/naver_logo_v1.png',
                ),
                SizedBox(height: interval1Y),
                // 간격을 위한 SizedBox
                _buildListTile(
                  context,
                  '카카오톡 채널',
                  'https://pf.kakao.com/_xjVrbG',
                  'asset/img/misc/drawer_img/kakao_logo_v1.png',
                ),
                SizedBox(height: interval1Y),
                // 간격을 위한 SizedBox
                _buildListTile(
                  context,
                  '유튜브 채널',
                  'https://www.youtube.com/@OTTBAYO',
                  'asset/img/misc/drawer_img/youtube_logo_v1.png',
                ),
                SizedBox(height: interval1Y),
                // 간격을 위한 SizedBox
                _buildListTile(
                  context,
                  '인스타그램 채널',
                  'https://www.instagram.com/ottbayo',
                  'asset/img/misc/drawer_img/instagram_logo_v1.png',
                ),
                // // 파이어베이스 내 파이어스토어 데이터베이스의 데이터 생성하는 로직 관련 버튼
                // // DB 생성 버튼
                // GestureDetector(
                //   onTap: () async {
                //     // await createFirestoreDocuments_1();
                //     // await createFirestoreDocuments_2();
                //     await createFirestoreDocuments_3();
                //     // await createFirestoreDocuments_4();
                //     // 사용자에게 완료 메시지를 보여줌
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(content: Text('DB 생성이 완료되었습니다.')),
                //     );
                //   },
                //   child: Center(
                //     child: Text(
                //       'DB 생성',
                //       style: TextStyle(
                //         fontFamily: 'NanumGothic',
                //         color: Colors.blue,
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),

                // 관리자 계정일 경우에만 추가적으로 표시되는 항목들
                if (isAdmin) ...[
                  SizedBox(height: interval1Y),
                  _buildAdminListTile(
                    context,
                    '리뷰 관리',
                    () =>
                        onReviewManagementClick(context, ref), // 클릭 시 실행될 함수 전달
                    'asset/img/misc/drawer_img/review_management_logo_v1.png',
                  ),
                  SizedBox(height: interval1Y), // 간격을 위한 SizedBox
                  _buildAdminListTile(
                    context,
                    '쪽지 관리',
                    () => onMessageManagementClick(
                        context, ref), // 클릭 시 실행될 함수 전달
                    'asset/img/misc/drawer_img/orderlist_management_logo_v1.png',
                  ),
                  SizedBox(height: interval1Y), // 간격을 위한 SizedBox
                  _buildAdminListTile(
                    context,
                    '발주내역 관리',
                    () => onOrderListClick(context, ref), // 클릭 시 실행될 함수 전달
                    'asset/img/misc/drawer_img/message_management_logo_v1.png',
                  ),
                ] else if (isSubAdmin) ...[
                  SizedBox(height: interval1Y),
                  _buildAdminListTile(
                    context,
                    '발주내역 관리',
                        () => onOrderListClick(context, ref),
                    'asset/img/misc/drawer_img/orderlist_management_logo_v1.png',
                  ),
                ],
                SizedBox(height: isAdmin ? interval3Y : interval2Y),
                // 관리자 여부에 따라 간격 조정
                // 로그아웃 또는 로그인 버튼 항목
                GestureDetector(
                  onTap: () async {
                    if (isLoggedIn) {
                      // 로그아웃 로직
                      await logoutAndLoginAfterProviderReset(ref);
                      // 화면 이동 없이 버튼 텍스트와 아이콘만 변경되도록 상태를 갱신해야 함
                      // 상태를 변경하고 UI를 업데이트하기 위해 setState를 호출해야 하지만,
                      // 현재 이 함수는 StatelessWidget 또는 함수 내에 있으므로 setState를 사용할 수 없음
                      // 따라서 화면 전체를 다시 빌드하도록 강제하기 위해 Navigator.pop을 사용하여 드로어를 닫고,
                      // setState가 호출된 효과를 내도록 함
                      // Navigator.of(context).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => MainHomeScreen()),
                        (Route<dynamic> route) => false,
                      );
                      showCustomSnackBar(context, '로그아웃이 되었습니다.');
                    } else {
                      // 로그인 로직
                      await logoutAndLoginAfterProviderReset(ref);
                      // 해당 간편 로그인 화면으로 이동하는 로직은 간편 로그인 화면 내 '닫기' 버튼을 클릭 시,
                      // 드로워 화면으로 복귀해야하므로 Navigator.pushReplacement 대신 Navigator.of(context).push를 사용
                      // Navigator.pushReplacement를 사용하면 이전 화면 스택을 제거하는 것이고, Navigator.of(context).push를 사용하면 이전 스택이 남는 것
                      // IOS 플랫폼은 IOS 화면으로 이동
                      if (Platform.isIOS) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => EasyLoginIosScreen()),
                        );
                      } else if (Platform.isAndroid) {
                        // AOS 플랫폼은 AOS 화면으로 이동
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => EasyLoginAosScreen()),
                        );
                      } else {
                        // 기타 플랫폼은 기본적으로 AOS 화면으로 이동
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => EasyLoginAosScreen()),
                        );
                      }
                    }
                  },
                  child: Center(
                    // 가로 기준 중앙 정렬을 위해 Center 위젯 사용
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Row 안의 요소들에 맞게 크기 조정
                      children: [
                        Text(
                          isLoggedIn ? 'Logout' : 'Login',
                          style: TextStyle(
                            fontFamily: 'NanumGothic',
                            color: GRAY47_COLOR,
                            fontSize: logoutTextFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ), // 로그아웃 또는 로그인 텍스트
                        SizedBox(width: interval2X), // 아이콘과 텍스트 사이의 간격
                        Icon(
                          isLoggedIn ? Icons.logout : Icons.login,
                          color: GRAY47_COLOR,
                          size: logoutBtnSize,
                        ), // 로그아웃 또는 로그인 아이콘
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

// ------ 관리자 계정인 경우 항목 클릭 시, 해당 화면으로 이동하도록 하는 함수 시작

Widget _buildAdminListTile(BuildContext context, String title,
    void Function()? onTap, String leadingImage) {
  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 260.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정
  // 드로워 화면 내 아이콘 요소 수치
  final double iconImageWidth =
      screenSize.width * (40 / referenceWidth); // 가로 비율

  // 아이콘 텍스트 부분 수치
  final double iconTextFontSize = screenSize.height * (16 / referenceHeight);

  // 아이콘 사이의 간격 수치
  final double interval1X = screenSize.width * (14 / referenceWidth);

  // ListTile 위젯을 반환합니다. 이 위젯은 드로어 내의 각 항목을 구성합니다.
  return ListTile(
    leading: Image.asset(leadingImage, width: iconImageWidth),
    // 아이콘을 왼쪽에 배치
    title: Text(title,
        style: TextStyle(
          fontSize: iconTextFontSize,
          color: BLACK_COLOR, // 텍스트 색상
          fontFamily: 'NanumGothic',
          fontWeight: FontWeight.bold,
        )),
    // 제목을 설정
    contentPadding: EdgeInsets.symmetric(horizontal: interval1X),
    // 좌우 간격 조정
    onTap: onTap, // 탭 이벤트 핸들러를 외부에서 전달받은 함수로 설정
  );
}

// 관리자 계정 항목 클릭 시, 실행될 함수들
void onReviewManagementClick(BuildContext context, WidgetRef ref) {
  navigateToScreenAndRemoveUntil(
      context, ref, AdminReviewMainScreen(), 4); // 화면 이동 함수 호출
}

void onMessageManagementClick(BuildContext context, WidgetRef ref) {
  navigateToScreenAndRemoveUntil(
      context, ref, AdminMessageMainScreen(), 4); // 화면 이동 함수 호출
}

void onOrderListClick(BuildContext context, WidgetRef ref) {
  navigateToScreenAndRemoveUntil(
      context, ref, AdminOrderlistMainScreen(), 4); // 화면 이동 함수 호출
}
// ------ 관리자 계정인 경우 항목 클릭 시, 해당 화면으로 이동하도록 하는 함수 끝

// ------ 웹 링크를 포함한 리스트 타일을 생성하는 함수(위젯) 시작
Widget _buildListTile(
    BuildContext context, String title, String url, String leadingImage) {
  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 260.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정
  // 드로워 화면 내 아이콘 요소 수치
  final double iconImageWidth =
      screenSize.width * (40 / referenceWidth); // 가로 비율

  // 아이콘 텍스트 부분 수치
  final double iconTextFontSize = screenSize.height * (16 / referenceHeight);

  // 아이콘 사이의 간격 수치
  final double interval1X = screenSize.width * (14 / referenceWidth);

  // ListTile 위젯 반환
  return ListTile(
    leading: Image.asset(leadingImage, width: iconImageWidth), // 이미지를 왼쪽에 배치
    title: Text(title,
        style: TextStyle(
          fontSize: iconTextFontSize,
          color: BLACK_COLOR, // 텍스트 색상
          fontFamily: 'NanumGothic',
          fontWeight: FontWeight.bold,
        )), // 제목을 설정
    contentPadding: EdgeInsets.symmetric(horizontal: interval1X), // 좌우 간격 조정
    onTap: () async {
      // 탭 이벤트 핸들러
      try {
        // URL을 파싱하여 외부 브라우저로 웹 페이지 열기 시도
        final bool launched = await launchUrl(Uri.parse(url),
            mode: LaunchMode.externalApplication);
        if (!launched) {
          // 웹 페이지를 열지 못할 경우 스낵바로 알림
          showCustomSnackBar(context, '웹 페이지를 열 수 없습니다.');
        }
      } catch (e) {
        // 예외 발생 시 스낵바로 에러 메시지 출력
        showCustomSnackBar(context, '에러가 발생했습니다.\n앱을 재실행해주세요.');
      }
    },
  );
}
// ------ 웹 링크를 포함한 리스트 타일을 생성하는 함수(위젯) 끝

// ------ Firestore 문서를 생성하는 함수 구현 시작
Future<void> createFirestoreDocuments_1() async {
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
    DocumentReference docRef = firestore.collection('wearcano').doc(docId);
    String briefIntroduction = briefIntroductionMap[i] ?? '해당 상품은 설명이 없습니다.';
    String category = categoryMap[i] ?? '';
    String categoryText = categoryTextMap[i] ?? '해당 상품은 카테고리가 없습니다.';
    String detailImagePath = detailImagePathMap[i] ?? '';

    for (int j = 1; j <= 7; j++) {
      String subCollectionId = 'a${i}b$j';
      CollectionReference subCollectionRef = docRef.collection(subCollectionId);
      String type = typeMap[j] ?? '';

      for (int k = 1; k < 16; k++) {
        int discountPercent = 9 + k; // k=1이면 10, k=2이면 11, ...
        int discountPrice =
            originalPrice - (originalPrice * discountPercent ~/ 100);
        String subDocId = 'a${i}b${j}_${k}';
        String productNumber = 'A${i}B${j}_${k.toString().padLeft(3, '0')}';
        DocumentReference subDocRef = subCollectionRef.doc(subDocId);

        String thumbnailUrl =
            'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/product_thumnail%2F$category\_$type.png?alt=media';

        // // 해당 필드값만 기존 필드값에서 새롭게 변경하고 싶을 때 사용하는 매서드
        // batch.update(subDocRef, {
        //   'detail_page_image1': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}1.png?alt=media',
        //   'detail_page_image2': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}2.png?alt=media',
        //   'detail_page_image3': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}3.png?alt=media',
        //   'detail_page_image4': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}4.png?alt=media',
        //   'detail_page_image5': 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}5.png?alt=media',
        // });

        // 해당 필드값으로 세팅하는 매서드 (SetOptions(merge: true)); // merge 옵션 사용을 해서 기존것이 날라가지않고 유지됨)
        batch.set(
            subDocRef,
            {
              'brief_introduction': briefIntroduction,
              'clothes_color1':
                  'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/clothes_color%2Fblack.png?alt=media&token=37afbb86-6b75-470d-b00c-98e03e23f3e4',
              'clothes_color2':
                  'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/clothes_color%2Fbrown.png?alt=media&token=5925c7d9-2966-4273-b1bb-3207475200cd',
              'clothes_color3':
                  'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/clothes_color%2Flavender.png?alt=media&token=45ee6a67-62bf-4aa7-a5f3-a12b13684bd1',
              'clothes_color4':
                  'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/clothes_color%2Fpink.png?alt=media&token=db961f7e-17da-4cd4-aad1-0ebb0e8ab8b2',
              'clothes_color5':
                  'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/clothes_color%2Fyellow.png?alt=media&token=869e517b-c07d-4744-acc9-592604438485',
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
              'detail_page_image1':
                  'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}1.png?alt=media',
              'detail_page_image2':
                  'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}2.png?alt=media',
              'detail_page_image3':
                  'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}3.png?alt=media',
              'detail_page_image4':
                  'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}4.png?alt=media',
              'detail_page_image5':
                  'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}5.png?alt=media',
              // 상품 상세 화면 내 상품 정보 관련 이미지 데이터
              // 'detail_color_image1': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fcolor_info%2Fdetail_color_image1.png?alt=media',
              // 'detail_color_image2': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fcolor_info%2Fdetail_color_image2.png?alt=media',
              // 'detail_color_image3': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fcolor_info%2Fdetail_color_image3.png?alt=media',
              // 'detail_color_image4': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fcolor_info%2Fdetail_color_image4.png?alt=media',
              // 'detail_color_image5': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fcolor_info%2Fdetail_color_image5.png?alt=media',
              // 'detail_details_image1': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fdetails_info%2Fdetail_details_image1.png?alt=media',
              // 'detail_fabric_image1': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Ffabric_info%2Fdetail_fabric_image1.png?alt=media',
              'detail_intro_image1':
                  'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fintro_info%2Fdetail_intro_image1.png?alt=media',
              'detail_intro_image2':
                  'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fintro_info%2Fdetail_intro_image2.png?alt=media',
              'detail_intro_image3':
                  'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fintro_info%2Fdetail_intro_image3.png?alt=media',
              'detail_intro_image4':
                  'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fintro_info%2Fdetail_intro_image4.png?alt=media',
              // 'detail_intro_image5': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fintro_info%2Fdetail_intro_image5.png?alt=media',
              // 'detail_size_image1': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fsize_info%2Fdetail_size_image1.png?alt=media',
              // 'detail_washing_image1': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fwashing_info%2Fdetail_washing_image1.png?alt=media',
              'discount_percent': discountPercent,
              'discount_price': discountPrice,
              'original_price': originalPrice,
              'thumbnails': thumbnailUrl,
              // thumbnails 필드값 추가
              'category': categoryText,
              // category 필드값 추가
              'product_number': productNumber,
              // product_number 필드 추가
            },
            SetOptions(merge: true)); // merge 옵션 사용

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

// ------ products 컬렉션 데이터 관련 Firestore 문서를 생성하는 함수 구현 시작
Future<void> createFirestoreDocuments_2() async {
  // final firestore = FirebaseFirestore.instance;
  // final batch = firestore.batch();
  // const int originalPrice = 10000;
  final firestore = FirebaseFirestore.instance;
  const int originalPrice = 10000;
  const int batchSize = 500; // 한 번에 커밋할 문서 수 제한
  int batchCounter = 0;
  WriteBatch batch = firestore.batch();

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
    10: '해당 상품은 아우터입니다.',
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
    10: '아우터',
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

  final int baseChar = 'a'.codeUnitAt(0); // 소문자 'a' 시작 문자

  for (int i = 1; i <= 30; i++) {
    String docId = 'product_$i';
    DocumentReference wearcanoDocRef =
        firestore.collection('products').doc('wearcano');
    CollectionReference productCollectionRef = wearcanoDocRef.collection(docId);

    // 기존에는 i를 12로 나눈 몫과 나머지를 이용해 'aa'~'al'까지만 커버했지만,
    // 확장성을 위해 26진법을 이용한다.
    // 예) i=1 → index=0: (0/26)=0 → 'a', (0%26)=0 → 'a' => "aa"
    //     i=12 → index=11: (11/26)=0 → 'a', (11%26)=11 → 'l' => "al"
    //     i=13 → index=12: (12/26)=0 → 'a', (12%26)=12 → 'm' => "am"
    //     ...
    //     i=26 → index=25: (25/26)=0 → 'a', (25%26)=25 → 'z' => "az"
    //     i=27 → index=26: (26/26)=1 → 'b', (26%26)=0 → 'a' => "ba"
    //     i=30 → index=29: (29/26)=1 → 'b', (29%26)=3 → 'd' => "bd"
    int index = i - 1;
    String secondChar = String.fromCharCode(baseChar + (index ~/ 26));
    String thirdChar = String.fromCharCode(baseChar + (index % 26));

    for (int j = 1; j <= 12; j++) {
      // 각 product에 맞춰 문서 ID를 생성 (예: Aaa1, Aaa2, ..., Aal12)
      String productDocId = 'A$secondChar$thirdChar$j';
      DocumentReference productDocRef = productCollectionRef.doc(productDocId);
      String briefIntroduction = briefIntroductionMap[j] ?? '설명이 없습니다.';
      String category = categoryMap[j] ?? '';
      String categoryText = categoryTextMap[j] ?? '카테고리가 없습니다.';
      String detailImagePath = detailImagePathMap[j] ?? '';

      for (int k = 1; k <= 7; k++) {
        String subCollectionId = '${productDocId}B$k';
        DocumentReference subWearcanoDocRef =
        productDocRef.collection(subCollectionId).doc('wearcano');
        CollectionReference wearcanoItemsCollectionRef =
        subWearcanoDocRef.collection('wearcano_items');
        String type = typeMap[k] ?? '';

        for (int l = 1; l <= 15; l++) {
          int discountPercent = 10 + l;
          int discountPrice = originalPrice - (originalPrice * discountPercent ~/ 100);
          String subDocId = '${subCollectionId}_$l';
          String productNumber = '${subDocId}_${l.toString().padLeft(3, '0')}';
          DocumentReference subDocRef = wearcanoItemsCollectionRef.doc(subDocId);

          String thumbnailUrl =
              'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/product_thumnail%2F$category\_$type.png?alt=media';

          batch.set(subDocRef, {
            'brief_introduction': briefIntroduction,
            'clothes_color1':
                'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/clothes_color%2Fblack.png?alt=media&token=37afbb86-6b75-470d-b00c-98e03e23f3e4',
            'clothes_color2':
                'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/clothes_color%2Fbrown.png?alt=media&token=5925c7d9-2966-4273-b1bb-3207475200cd',
            'clothes_color3':
                'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/clothes_color%2Flavender.png?alt=media&token=45ee6a67-62bf-4aa7-a5f3-a12b13684bd1',
            'clothes_size1': 'Free',
            'color1_text': 'black',
            'color2_text': 'brown',
            'color3_text': 'lavender',
            'detail_page_image1':
                'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}1.png?alt=media',
            'detail_page_image2':
                'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}2.png?alt=media',
            'detail_page_image3':
                'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}3.png?alt=media',
            'detail_page_image4':
                'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}4.png?alt=media',
            'detail_page_image5':
                'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2F$detailImagePath%2F${detailImagePath}5.png?alt=media',
            'detail_intro_image1':
                'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fintro_info%2FHG3314-d1.png?alt=media',
            'detail_intro_image2':
                'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fintro_info%2FHG3314-d2.png?alt=media',
            'detail_intro_image3':
                'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fintro_info%2FHG3314-d3.png?alt=media',
            'detail_intro_image4':
                'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/detail_image%2Fprod_info%2Fintro_info%2FHG3314-d4.png?alt=media',
            'discount_percent': discountPercent,
            'discount_price': discountPrice,
            'original_price': originalPrice,
            'thumbnails': thumbnailUrl,
            'category': categoryText,
            'product_number': productNumber,
            'boolExistence': false
          });

          batchCounter++;

          // 배치 한도를 넘으면 커밋하고 새 배치 생성
          if (batchCounter >= batchSize) {
            await batch.commit();
            batchCounter = 0; // 카운터 초기화
            batch = firestore.batch(); // 새 배치 시작
            await Future.delayed(Duration(milliseconds: 100)); // 서버 과부하 방지용 딜레이
          }
        }
      }
    }
  }

  // 남아 있는 문서 커밋
  if (batchCounter > 0) {
    await batch.commit();
  }
  print("모든 문서 생성이 완료되었습니다.");
}
// ------ products 컬렉션 데이터 관련 Firestore 문서를 생성하는 함수 구현 끝

// ------ banners 컬렉션 데이터 관련 Firestore 문서를 생성하는 함수 구현 시작
Future<void> createFirestoreDocuments_3() async {
  final firestore = FirebaseFirestore.instance;
  const int batchSize = 500;
  int batchCounter = 0;
  WriteBatch batch = firestore.batch();

  DocumentReference wearcanoDocRef =
      firestore.collection('banners').doc('wearcano');

  for (int i = 1; i <= 30; i++) {
    // 'banner_1' ~ 'banner_12' 컬렉션 참조 생성
    CollectionReference bannerCollectionRef =
        wearcanoDocRef.collection('banner_$i');

    final int baseChar = 'a'.codeUnitAt(0); // 소문자 'a' 시작 문자

    // 기존에는 i를 12로 나눈 몫과 나머지를 이용해 'aa'~'al'까지만 커버했지만,
    // 확장성을 위해 26진법을 이용한다.
    // 예) i=1 → index=0: (0/26)=0 → 'a', (0%26)=0 → 'a' => "aa"
    //     i=12 → index=11: (11/26)=0 → 'a', (11%26)=11 → 'l' => "al"
    //     i=13 → index=12: (12/26)=0 → 'a', (12%26)=12 → 'm' => "am"
    //     ...
    //     i=26 → index=25: (25/26)=0 → 'a', (25%26)=25 → 'z' => "az"
    //     i=27 → index=26: (26/26)=1 → 'b', (26%26)=0 → 'a' => "ba"
    //     i=30 → index=29: (29/26)=1 → 'b', (29%26)=3 → 'd' => "bd"
    int index = i - 1;
    String secondChar = String.fromCharCode(baseChar + (index ~/ 26));
    String thirdChar = String.fromCharCode(baseChar + (index % 26));

    // 각 product에 맞춰 문서 ID를 생성 (예: Aaa1, Aaa2, ..., Aal12)
    String docId1 = 'product_$i';
    String collectionId1 = 'A${secondChar}${thirdChar}1';
    String docId2 = '${collectionId1}B1';
    String docId3 = '${docId2}_1';

    String productId =
        'products/wearcano/$docId1/$collectionId1/$docId2/wearcano/wearcano_items/$docId3';

    // 각 배너 타입에 맞춰 하위 문서 생성
    List<String> bannerTypes = [
      'large_banner',
      'home_small_banner_1',
      'home_small_banner_2',
      'home_small_banner_3',
      'shirt_main_small_banner_1',
      'blouse_main_small_banner_1',
      'mtm_main_small_banner_1',
      'cardigan_main_small_banner_1',
      'coat_main_small_banner_1',
      'jean_main_small_banner_1',
      'neat_main_small_banner_1',
      'onepiece_main_small_banner_1',
      'paeding_main_small_banner_1',
      'pants_main_small_banner_1',
      'pola_main_small_banner_1',
      'skirt_main_small_banner_1',
      'new_sub_main_small_banner_1',
      'best_sub_main_small_banner_1',
      'sale_sub_main_small_banner_1',
      'spring_sub_main_small_banner_1',
      'summer_sub_main_small_banner_1',
      'autumn_sub_main_small_banner_1',
      'winter_sub_main_small_banner_1'
    ];

    int homeImgCounter = 1; // 홈 배너 이미지 순서 관리를 위한 카운터
    int othersImgCounter = 1; // 나머지 화면 이미지 순서 관리를 위한 카운터
    for (String bannerType in bannerTypes) {
      DocumentReference bannerDocRef = bannerCollectionRef.doc(bannerType);

      // 필드 설정
      if (bannerType == 'large_banner') {
        batch.set(bannerDocRef, {
          'ad_img_1':
              'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fdongdaemoon1.png?alt=media',
          'ad_img_2':
              'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fdongdaemoon2.png?alt=media',
          'ad_img_3':
              'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fdongdaemoon3.png?alt=media',
          'ad_img_4':
              'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fbb_test_4.png?alt=media',
          'ad_img_5':
              'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fbb_test_5.png?alt=media',
          'ad_url_1': 'https://www.naver.com',
          'ad_url_2': 'https://ko.aliexpress.com/',
          'ad_url_3': 'https://www.temu.com/kr',
          'category': '티셔츠',
          'product_id': productId,
          'sub_category': '신상',
        });
      } else if ([
        'home_small_banner_1',
        'home_small_banner_2',
        'home_small_banner_3'
      ].contains(bannerType)) {
        // home_small_banner는 ad_image1 ~ ad_image9
        batch.set(bannerDocRef, {
          'ad_img_1':
              'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fad_image${homeImgCounter++}.jpeg?alt=media',
          'ad_img_2':
              'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fad_image${homeImgCounter++}.jpeg?alt=media',
          'ad_img_3':
              'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fad_image${homeImgCounter++}.jpeg?alt=media',
          'category': '티셔츠',
          'product_id': productId,
        });
      // } else if (bannerType == 'profile_main_small_banner_1') {
      //   // profile_main_small_banner의 이미지 URL은 mb1 ~ mb3
      //   batch.set(bannerDocRef, {
      //     'ad_img_1':
      //         'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fmb1.png?alt=media',
      //     'ad_img_2':
      //         'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fmb2.png?alt=media',
      //     'ad_img_3':
      //         'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fmb3.png?alt=media',
      //     'category': '아우터',
      //     'product_id': productId,
      //   });
      } else {
        // 나머지 배너 타입들은 mb1 ~ mb57로 설정
        batch.set(bannerDocRef, {
          'ad_img_1':
              'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fmb${othersImgCounter++}.png?alt=media',
          'ad_img_2':
              'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fmb${othersImgCounter++}.png?alt=media',
          'ad_img_3':
              'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fmb${othersImgCounter++}.png?alt=media',
          'category': '티셔츠',
          'product_id': productId,
        });
      }

      batchCounter++;

      // 배치 한도에 도달하면 커밋하고 초기화
      if (batchCounter >= batchSize) {
        await batch.commit();
        batchCounter = 0;
        batch = firestore.batch();
        await Future.delayed(Duration(milliseconds: 100)); // 서버 과부하 방지용 딜레이
      }
    }
  }

  // -------------------------------------
  // 메인 홈 관련 배너(main_home_banner) 추가 로직
  // 기존 large_banner, home_small_banner_1 구성과 동일한 이미지/URL 패턴 사용
  // 단, category, product_id, sub_category는 추가하지 않는다.
  CollectionReference mainHomeBannerCollectionRef =
  wearcanoDocRef.collection('main_home_banner');

  // large_banner 문서
  DocumentReference largeBannerDocRef = mainHomeBannerCollectionRef.doc('large_banner');
  batch.set(largeBannerDocRef, {
    'ad_img_1': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fdongdaemoon1.png?alt=media',
    'ad_img_2': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fdongdaemoon2.png?alt=media',
    'ad_img_3': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fdongdaemoon3.png?alt=media',
    'ad_img_4': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fbb_test_4.png?alt=media',
    'ad_img_5': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fbb_test_5.png?alt=media',
    'ad_url_1': 'https://www.naver.com',
    'ad_url_2': 'https://ko.aliexpress.com/',
    'ad_url_3': 'https://www.temu.com/kr',
    'ad_url_4': 'https://www.google.com',
    'ad_url_5': 'https://www.yanolja.com/',
    // category, product_id, sub_category 없음
  });
  batchCounter++;
  if (batchCounter >= batchSize) {
    await batch.commit();
    batchCounter = 0;
    batch = firestore.batch();
    await Future.delayed(Duration(milliseconds: 100));
  }

  // home_small_banner_1 문서
  // 기존 home_small_banner_1 ~ 3에서 사용한 ad_img_1 ~ ad_img_3 패턴 그대로 사용
  // 예: ad_image1, ad_image2, ad_image3
  DocumentReference homeSmallBanner1DocRef = mainHomeBannerCollectionRef.doc('home_small_banner_1');
  batch.set(homeSmallBanner1DocRef, {
    'ad_img_1': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fad_image1.jpeg?alt=media',
    'ad_img_2': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fad_image2.jpeg?alt=media',
    'ad_img_3': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fad_image3.jpeg?alt=media',
    'ad_url_1': 'https://www.naver.com',
    'ad_url_2': 'https://ko.aliexpress.com/',
    'ad_url_3': 'https://www.temu.com/kr',
    // category, product_id 없음
  });
  batchCounter++;
  if (batchCounter >= batchSize) {
    await batch.commit();
    batchCounter = 0;
    batch = firestore.batch();
    await Future.delayed(Duration(milliseconds: 100));
  }

  // -------------------------------------
  // 프로필 관련 배너(profile_banner) 추가 로직
  CollectionReference profileBannerCollectionRef =
  wearcanoDocRef.collection('profile_banner');

  // profile_small_banner_1 문서
  // home_small_banner_1 ~ 3 케이스처럼 ad_img_1 ~ 3와 ad_url_1 ~ 3 사용
  DocumentReference profileSmallBanner1DocRef = profileBannerCollectionRef.doc('profile_small_banner_1');
  batch.set(profileSmallBanner1DocRef, {
    'ad_img_1': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fad_image1.jpeg?alt=media',
    'ad_img_2': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fad_image2.jpeg?alt=media',
    'ad_img_3': 'https://firebasestorage.googleapis.com/v0/b/wearcanopj.appspot.com/o/banner_image%2Fad_image3.jpeg?alt=media',
    'ad_url_1': 'https://www.naver.com',
    'ad_url_2': 'https://ko.aliexpress.com/',
    'ad_url_3': 'https://www.temu.com/kr',
    // category, product_id 없음
  });
  batchCounter++;
  if (batchCounter >= batchSize) {
    await batch.commit();
    batchCounter = 0;
    batch = firestore.batch();
    await Future.delayed(Duration(milliseconds: 100));
  }

  // 남은 데이터 커밋
  if (batchCounter > 0) {
    await batch.commit();
  }
  print("모든 배너 문서 생성이 완료되었습니다.");
}
// ------ banners 컬렉션 데이터 관련 Firestore 문서를 생성하는 함수 구현 끝

// ------ 홈 화면 내 상점 버튼 데이터 관련 Firestore 문서를 생성하는 함수 구현 시작
Future<void> createFirestoreDocuments_4() async {
  final firestore = FirebaseFirestore.instance; // Firestore 인스턴스 생성
  final batch = firestore.batch(); // Batch 작업 시작
  final DocumentReference docRef =
      firestore.collection('market_data').doc('wearcano');

  const String screenToMoveValue = 'HomeMainScreen()';
  const String stepValue = '0';

  // 문서 ID 생성에 필요한 알파벳 리스트
  const List<String> alphabet = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];

  int sequence = 1; // sequence 및 name 값 관리

  // 첫 번째 문자 'A'
  for (final char2 in alphabet) {
    for (final char3 in alphabet) {
      final String docId = 'A$char2$char3'; // 문서 ID 생성 (세 자리수)

      final DocumentReference subDocRef =
          docRef.collection('market').doc(docId);

      // Batch에 문서 생성 작업 추가
      batch.set(subDocRef, {
        'boolExistence': true, // Boolean 값
        'id': docId, // 문서명
        'step': stepValue, // step 값
        'name': '상점 $sequence', // 상점 이름
        'sequence': sequence, // 문서 순서
      });

      sequence++; // 순서를 증가
      if (sequence > 36) break; // 총 36개의 문서까지만 생성
    }
    if (sequence > 36) break; // 중첩 루프 종료 조건
  }

  // Batch 작업 커밋
  await batch.commit();
}
// ------ 홈 화면 내 상점 버튼 데이터 관련 Firestore 문서를 생성하는 함수 구현 끝
