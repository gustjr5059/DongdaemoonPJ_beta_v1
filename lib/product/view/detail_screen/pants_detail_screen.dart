// Dart의 IO 라이브러리에서 Platform 클래스를 가져옵니다. 이 클래스는 운영 체제에 대한 정보를 제공합니다.
import 'dart:io' show Platform;
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/const/colors.dart';
import '../../../common/layout/common_exception_parts_of_body_layout.dart';
import '../../../common/provider/common_state_provider.dart';
import '../../layout/product_body_parts_layout.dart';
import '../../provider/product_future_provider.dart';
import '../../provider/product_state_provider.dart';

// flutter 패키지의 services 라이브러리를 가져옵니다.
// 이 라이브러리는 플러터 애플리케이션에서 네이티브 서비스에 접근할 수 있게 해줍니다.
// 예를 들어, 클립보드, 네트워크 상태, 시스템 설정 등을 제어할 수 있습니다.
import 'package:flutter/services.dart';

// 애플리케이션의 여러 부분에서 재사용될 수 있는 공통 UI 컴포넌트 파일을 임포트합니다.
// 이 파일은 통일된 디자인과 구조를 제공하여 UI 개발을 효율적으로 할 수 있도록 돕습니다.
import '../../../common/layout/common_body_parts_layout.dart'; // 공통 UI 컴포넌트 파일

// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용 권장
// GlobalKey 사용 시 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// PantsDetailProductScreen 클래스는 ConsumerWidget 상속, Riverpod를 통한 상태 관리 지원
class PantsDetailProductScreen extends ConsumerStatefulWidget {
  final String fullPath; // 전체 경로를 나타내는 문자열 변수
  final String title; // 타이틀을 나타내는 문자열 변수

  const PantsDetailProductScreen({
    Key? key, // 위젯의 키를 나타내는 매개변수
    required this.fullPath, // 전체 경로를 필수 매개변수로 받음
    required this.title, // 타이틀을 필수 매개변수로 받음
  }) : super(key: key); // 부모 클래스의 생성자를 호출하여 초기화함

  @override
  _PantsDetailProductScreenState createState() =>
      _PantsDetailProductScreenState();
}

// _PantsDetailProductScreenState 클래스 시작
// _PantsDetailProductScreenState 클래스는 PantsDetailProductScreen 위젯의 상태를 관리함.
// WidgetsBindingObserver 믹스인을 통해 앱 생명주기 상태 변화를 감시함.
class _PantsDetailProductScreenState
    extends ConsumerState<PantsDetailProductScreen>
    with WidgetsBindingObserver {
  // 사용자 인증 상태 변경을 감지하는 스트림 구독 객체임.
  // 이를 통해 사용자 로그인 또는 로그아웃 상태 변경을 실시간으로 감지하고 처리할 수 있음.
  StreamSubscription<User?>? authStateChangesSubscription;

  // pantsDetailScrollPositionProvider에서 ScrollController를 읽어와서 scrollController에 할당
  // ref.read(pantsDetailScrollPositionProvider)는 provider를 이용해 상태를 읽는 방식.
  // ScrollController는 스크롤 가능한 위젯의 스크롤 동작을 제어하기 위해 사용됨.
  // 1.상단 탭바 버튼 클릭 시 해당 섹션으로 스크롤 이동하는 기능,
  // 2.하단 탭바의 버튼 클릭 시  화면 초기 위치로 스크롤 이동하는 기능,
  // 3.사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을때 마지막으로 본 위치로 자동으로 스크롤되도록 하는 기능,
  // 4.단순 스크롤을 내리거나 올릴 시, 상단 탭 바 버튼 텍스트 색상이 변경되도록 하는 기능,
  // 5. 'top' 버튼 클릭 시 홈 화면 초기 위치로 스크롤 이동하는 기능,
  // => 5개의 기능인 전체 화면의 스크롤을 제어하는 컨트롤러-화면 내의 여러 섹션으로의 이동 역할

  // pantsDetailScrollPositionProvider : 여러 위젯에서 동일한 ScrollController를 공유하고,
  // 상태를 유지하기 위해 Riverpod의 Provider를 사용하여 관리함.
  // 이를 통해 앱의 다른 부분에서도 동일한 ScrollController에 접근할 수 있으며, 상태를 일관성 있게 유지함.
  // ScrollController를 late 변수로 선언
  // ScrollController가 여러 ScrollView에 attach 되어서 ScrollController가 동시에 여러 ScrollView에서 사용될 때 발생한 문제를 해결한 방법
  // => late로 변수 선언 / 해당 변수를 초기화(initState()) / 해당 변수를 해제 (dispose())
  late ScrollController
      pantsDetailProductScreenPointScrollController; // 스크롤 컨트롤러 선언

  late PageController pageController;

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // StateProvider 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // getImagePageProvider의 상태를 0으로 초기화함.
      ref.read(getImagePageProvider(widget.fullPath).notifier).state = 0;
    });

    // 페이지 컨트롤러를 초기 페이지로 초기화함.
    pageController = PageController(initialPage: ref.read(getImagePageProvider(widget.fullPath)));

    pageController.addListener(() {
      // 페이지 컨트롤러의 현재 페이지를 반올림하여 getImagePageProvider 상태에 업데이트함.
      ref.read(getImagePageProvider(widget.fullPath).notifier).state =
          pageController.page!.round();
    });

    // ScrollController를 초기화
    pantsDetailProductScreenPointScrollController = ScrollController();


    // initState에서 저장된 스크롤 위치로 이동
    // initState에서 실행되는 코드. initState는 위젯이 생성될 때 호출되는 초기화 단계
    // WidgetsBinding.instance.addPostFrameCallback 메서드를 사용하여 프레임이 렌더링 된 후 콜백을 등록함.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 스크롤 컨트롤러가 활성 스크롤 뷰를 가지고 있는지 확인함.
      if (pantsDetailProductScreenPointScrollController.hasClients) {
        // savedScrollPosition 변수에 저장된 스크롤 위치를 읽어옴.
        // ref.read(scrollPositionProvider)는 Riverpod 상태 관리 라이브러리를 사용하여
        // scrollPositionProvider에서 마지막으로 저장된 스크롤 위치를 가져옴.
        double savedScrollPosition =
            ref.read(pantsDetailScrollPositionProvider);
        // pantsDetailProductScreenPointScrollController.jumpTo 메서드를 사용하여 스크롤 위치를 savedScrollPosition으로 즉시 이동함.
        // 이는 스크롤 애니메이션이나 다른 복잡한 동작 없이 바로 지정된 위치로 점프함.
        pantsDetailProductScreenPointScrollController
            .jumpTo(savedScrollPosition);
      }
    });

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        ref.read(pantsDetailScrollPositionProvider.notifier).state = 0; // pantsDetailScrollPositionProvider의 상태를 0으로 설정
        ref.read(getImagePageProvider(widget.fullPath).notifier).state = 0; // getImagePageProvider의 상태를 0으로 설정
        pageController.jumpToPage(0); // pageController를 사용하여 페이지를 0으로 이동시킴.
      }
    });

    // WidgetsBindingObserver를 추가하여 앱의 생명주기 변화 감지
    WidgetsBinding.instance.addObserver(this); // 생명주기 옵저버 등록

    // 상태표시줄 색상을 안드로이드와 ios 버전에 맞춰서 변경하는데 사용되는 함수-앱 실행 생명주기에 맞춰서 변경
    _updateStatusBar();
  }

  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 끝 (앱 실행 생명주기 관련 함수)

  // didChangeAppLifecycleState 함수 관련 구현 내용 시작
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _updateStatusBar();
    }
  }

  // didChangeAppLifecycleState 함수 관련 구현 내용 끝

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void dispose() {
    // WidgetsBinding 인스턴스에서 이 객체를 옵저버 목록에서 제거함.
    // 앱 생명주기 이벤트를 더 이상 수신하지 않겠다는 의도임.
    WidgetsBinding.instance.removeObserver(this);

    // 사용자 인증 상태 감지 구독 해제함.
    authStateChangesSubscription?.cancel();

    pantsDetailProductScreenPointScrollController
        .dispose(); // ScrollController 해제
    pageController.dispose(); // PageController 해제
    super.dispose(); // 위젯의 기본 정리 작업 수행
  }

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 끝 (앱 실행 생명주기 관련 함수)
  // ------ 앱 실행 생명주기 관리 관련 함수 끝

  // 상태표시줄 색상을 안드로이드와 ios 버전에 맞춰서 변경하는데 사용되는 함수-앱 실행 생명주기에 맞춰서 변경
  void _updateStatusBar() {
    Color statusBarColor = BUTTON_COLOR; // 여기서 원하는 색상을 지정

    if (Platform.isAndroid) {
      // 안드로이드에서는 상태표시줄 색상을 직접 지정
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: Brightness.light,
      ));
    } else if (Platform.isIOS) {
      // iOS에서는 앱 바 색상을 통해 상태표시줄 색상을 간접적으로 조정
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light, // 밝은 아이콘 사용
      ));
    }
  }

  // ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 시작
  @override
  Widget build(BuildContext context) {
    // Firestore 데이터 제공자를 통해 특정 문서 ID(docId)의 상품 데이터를 구독.
    final productContent =
        ref.watch(pantsDetailProdFirestoreDataProvider(widget.fullPath));
    // ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 시작
    // ------ 기존 buildCommonAppBar 위젯 내용과 동일하며,
    // 플러터 기본 SliverAppBar 위젯을 활용하여 앱 바의 상태 동적 UI 구현에 수월한 부분을 정의해서 해당 위젯을 바로 다른 화면에 구현하여
    // 기본 SliverAppBar의 드로워화면 토글 옵션을 삭제하는 등의 작업이 필요없는 방식-현재는 이슈가 있어 사용 안함..
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: pantsDetailProductScreenPointScrollController,
            // 스크롤 컨트롤러 연결
            slivers: <Widget>[
              // SliverAppBar를 사용하여 기존 AppBar 기능을 재사용
              SliverAppBar(
                // 'automaticallyImplyLeading: false'를 추가하여 SliverAppBar가 자동으로 leading 버튼을 생성하지 않도록 설정함.
                automaticallyImplyLeading: false,
                floating: true,
                // 스크롤 시 SliverAppBar가 빠르게 나타남.
                pinned: true,
                // 스크롤 다운시 AppBar가 상단에 고정됨.
                expandedHeight: 0.0,
                // 확장된 높이를 0으로 설정하여 확장 기능 제거
                title: buildCommonAppBar(
                  // 공통 AppBar 빌드
                  context: context,
                  // 현재 context 전달
                  ref: ref,
                  // 참조(ref) 전달
                  title: widget.title,
                  // AppBar의 제목을 '팬츠 상세'로 설정
                  leadingType: LeadingType.back,
                  // AppBar의 리딩 타입을 뒤로가기 버튼으로 설정
                  buttonCase: 4, // 버튼 케이스를 4로 설정
                ),
                leading: null,
                // 좌측 상단의 메뉴 버튼 등을 제거함.
                // iOS에서는 AppBar의 배경색을 사용
                // SliverAppBar 배경색 설정  // AppBar 배경을 투명하게 설정 -> 투명하게 해서 스크롤 내리면 다른 컨텐츠가 비쳐서 보이는 것!!
                backgroundColor: BUTTON_COLOR,
              ),
              // 실제 컨텐츠를 나타내는 슬리버 리스트
              // 슬리버 패딩을 추가하여 위젯 간 간격 조정함.
              SliverPadding(
                padding: EdgeInsets.zero, // 컨텐츠 내용 부분 패딩이 없음.
                // SliverList를 사용하여 목록 아이템을 동적으로 생성함.
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Column(
                          children: [
                            // productContent의 상태에 따라 위젯을 빌드.
                            productContent.when(
                              // 데이터가 로드되었을 때 실행되는 코드 블록.
                              // data 함수에서 product를 받아옴
                              data: (product) {
                                // 리뷰 내용 리스트를 생성하여 reviewsContent에 할당
                                final List<ProductReviewContents> reviewsContent = [
                                  // 첫 번째 리뷰 내용을 ProductReviewContents 객체로 생성
                                  // 임시로 데이터를 생성한 부분
                                  // - 리뷰 작성 화면에서 작성한 내용을 파이어베이스에 저장 후 저장된 내용을 불러오도록 로직을 재설계해야함!!
                                  ProductReviewContents(
                                    thumbnailUrl: 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/product_thumnail%2Fshirt_new.png?alt=media', // 상품 썸네일 URL
                                    productName: 'Example Product', // 상품명
                                    orderNumber: '12345', // 발주 번호
                                    orderDate: '2024-06-30', // 발주 일자
                                    reviewerName: '고딩12', // 리뷰 작성자
                                    reviewDate: '2024-06-30', // 리뷰 작성 일자
                                    reviewImageUrl: 'https://firebasestorage.googleapis.com/v0/b/dongdaemoonproject1.appspot.com/o/detail_image%2Fprod_info%2Fsize_info%2Fdetail_size_image1.png?alt=media', // 리뷰 이미지 URL
                                    reviewContent: '만족해요', // 리뷰 내용
                                  ),
                                  // 더 많은 리뷰 내용을 여기에 추가할 수 있습니다.
                                ];
                                // Column 위젯을 반환하여 여러 위젯을 세로로 배치
                                return Column(
                                  children: [
                                    // buildProdDetailScreenContents 함수를 호출하여 상품 상세 화면 콘텐츠를 생성
                                    buildProdDetailScreenContents(context, ref, product, pageController),
                                    SizedBox(height: 40), // 여백
                                    // ProductDetailScreenTabs 위젯을 사용하여 탭을 생성
                                    ProductDetailScreenTabs(
                                      productInfoContent: ProductInfoContents(product: product), // 상품 정보 콘텐츠
                                      reviewsContent: reviewsContent, // 리뷰 내용 리스트
                                      inquiryContent: ProductInquiryContents(), // 상품 문의 콘텐츠
                                    ),
                                  ],
                                );
                              },
                              // 로딩 중일 때 실행되는 코드 블록.
                              loading: () => Center(child: CircularProgressIndicator()),
                              // 에러가 발생했을 때 실행되는 코드 블록.
                              error: (error, _) => Center(child: Text('오류 발생: $error')),
                            ),
                          ],
                      );
                    },
                    childCount: 1, // 하나의 큰 Column이 모든 카드뷰를 포함하고 있기 때문에 1로 설정
                  ),
                ),
              ),
            ],
          ),
          // buildTopButton 함수는 주어진 context와 pantsDetailProductScreenPointScrollController를 사용하여
          // 화면 상단으로 스크롤하기 위한 버튼 생성 위젯이며, common_body_parts_layout.dart 내에 있는 곳에서 재사용하여 구현한 부분
          buildTopButton(
              context, pantsDetailProductScreenPointScrollController),
        ],
      ),
      // 하단 탭 바 - 2번 케이스인 '장바구니' 버튼과 '바로 발주' 버튼이 UI로 구현됨.
      bottomNavigationBar: buildCommonBottomNavigationBar(
          ref.watch(tabIndexProvider), ref, context, 5, 2),
    );
    // ------ 화면구성 끝
  }
// ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 끝
// ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 끝
}
// _PantsDetailProductScreenState 클래스 끝
