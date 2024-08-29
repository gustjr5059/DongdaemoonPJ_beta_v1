// Dart의 IO 라이브러리에서 Platform 클래스를 가져옵니다. 이 클래스는 운영 체제에 대한 정보를 제공합니다.
import 'dart:io' show Platform;

// Dart의 비동기 프로그래밍 기능을 지원하는 'dart:async' 라이브러리를 가져옵니다.
// 이 라이브러리를 사용하여 Future와 Stream 객체를 통해 비동기 작업을 쉽게 처리할 수 있습니다.
import 'dart:async';

// Firebase의 사용자 인증 기능을 제공하는 FirebaseAuth 패키지를 임포트합니다.
// 이를 통해 이메일, 비밀번호, 소셜 미디어 계정을 이용한 로그인 기능 등을 구현할 수 있습니다.
import 'package:firebase_auth/firebase_auth.dart';

// Flutter의 기본 디자인 및 UI 요소를 제공하는 Material 디자인 패키지를 임포트합니다.
// 이 패키지는 버튼, 카드, 앱 바 등 다양한 머티리얼 디자인 위젯을 포함하고 있습니다.
import 'package:flutter/material.dart';

// flutter 패키지의 services 라이브러리를 가져옵니다.
// 이 라이브러리는 플러터 애플리케이션에서 네이티브 서비스에 접근할 수 있게 해줍니다.
// 예를 들어, 클립보드, 네트워크 상태, 시스템 설정 등을 제어할 수 있습니다.
import 'package:flutter/services.dart';

// 상태 관리를 위한 현대적인 라이브러리인 Riverpod를 임포트합니다.
// Riverpod는 애플리케이션의 상태를 효율적으로 관리하고, 상태 변화에 따라 UI를 자동으로 업데이트합니다.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod를 사용한 상태 관리를 위한 import
// url_launcher 패키지를 가져옵니다.
// 이 패키지는 Flutter 애플리케이션에서 URL을 열거나 이메일, 전화, 문자 메시지 등을 실행할 수 있는 기능을 제공합니다.
// 예를 들어, 웹 브라우저에서 특정 웹 페이지를 열거나, 메일 앱을 열어 이메일을 작성하거나, 전화 앱을 열어 전화를 걸 수 있습니다.
import 'package:url_launcher/url_launcher.dart';

// 애플리케이션에서 발생할 수 있는 예외 상황을 처리하기 위한 공통 UI 레이아웃 파일을 임포트합니다.
// 이 레이아웃은 에러 발생 시 사용자에게 보여질 UI 컴포넌트를 정의합니다.
import '../../../common/layout/common_exception_parts_of_body_layout.dart';

// colors.dart 파일을 common 디렉토리의 const 폴더에서 가져옵니다.
// 이 파일에는 애플리케이션 전반에서 사용할 색상 상수들이 정의되어 있을 것입니다.
// 상수로 정의된 색상들을 사용하여 일관된 색상 테마를 유지할 수 있습니다.
import '../../../common/const/colors.dart';

// 애플리케이션의 여러 부분에서 재사용될 수 있는 공통 UI 컴포넌트 파일을 임포트합니다.
// 이 파일은 통일된 디자인과 구조를 제공하여 UI 개발을 효율적으로 할 수 있도록 돕습니다.
import '../../../common/layout/common_body_parts_layout.dart'; // 공통 UI 컴포넌트 파일
// 홈 화면의 레이아웃을 구성하는 파일을 임포트합니다.
// 이 파일은 홈 화면의 주요 구성 요소들을 정의하며, 사용자에게 첫 인상을 제공하는 중요한 역할을 합니다.
import '../../../common/provider/common_state_provider.dart';

// banner_model.dart 파일을 common 디렉토리의 model 폴더에서 가져옵니다.
// 이 파일에는 배너와 관련된 데이터 모델이 정의되어 있습니다.
// 배너 데이터를 구조화하고 관리하기 위해 사용됩니다.
import '../../../common/model/banner_model.dart';

// common_all_providers.dart 파일을 common 디렉토리의 provider 폴더에서 가져옵니다.
// 이 파일에는 Future Provider와 관련된 기능이 정의되어 있습니다.
// 비동기 데이터 호출 및 상태 관리를 위해 사용됩니다.
import '../../../common/provider/common_all_providers.dart';

// 제품 상태 관리를 위해 사용되는 상태 제공자 파일을 임포트합니다.
// 이 파일은 제품 관련 데이터의 상태를 관리하고, 필요에 따라 상태를 업데이트하는 로직을 포함합니다.
import '../../product/model/product_model.dart';
import '../layout/wishlist_body_parts_layout.dart';
import '../provider/wishlist_state_provider.dart';

// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용 권장
// GlobalKey 사용 시 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// WishlistScreen 클래스는 ConsumerWidget 상속, Riverpod를 통한 상태 관리 지원
class WishlistMainScreen extends ConsumerStatefulWidget {
  const WishlistMainScreen({Key? key}) : super(key: key);

  @override
  _WishlistMainScreenState createState() => _WishlistMainScreenState();
}

// _WishlistScreenState 클래스 시작
// _WishlistScreenState 클래스는 WishlistScreen 위젯의 상태를 관리함.
// WidgetsBindingObserver 믹스인을 통해 앱 생명주기 상태 변화를 감시함.
class _WishlistMainScreenState extends ConsumerState<WishlistMainScreen>
    with WidgetsBindingObserver {
  // 사용자 인증 상태 변경을 감지하는 스트림 구독 객체임.
  // 이를 통해 사용자 로그인 또는 로그아웃 상태 변경을 실시간으로 감지하고 처리할 수 있음.
  StreamSubscription<User?>? authStateChangesSubscription;

  // wishlistScrollControllerProvider에서 ScrollController를 읽어와서 scrollController에 할당
  // ref.read(wishlistScrollControllerProvider)는 provider를 이용해 상태를 읽는 방식.
  // ScrollController는 스크롤 가능한 위젯의 스크롤 동작을 제어하기 위해 사용됨.
  // 1.상단 탭바 버튼 클릭 시 해당 섹션으로 스크롤 이동하는 기능,
  // 2.하단 탭바의 버튼 클릭 시  화면 초기 위치로 스크롤 이동하는 기능,
  // 3.사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을때 마지막으로 본 위치로 자동으로 스크롤되도록 하는 기능,
  // 4.단순 스크롤을 내리거나 올릴 시, 상단 탭 바 버튼 텍스트 색상이 변경되도록 하는 기능,
  // 5. 'top' 버튼 클릭 시 홈 화면 초기 위치로 스크롤 이동하는 기능,
  // => 5개의 기능인 전체 화면의 스크롤을 제어하는 컨트롤러-화면 내의 여러 섹션으로의 이동 역할

  // wishlistScrollControllerProvider : 여러 위젯에서 동일한 ScrollController를 공유하고,
  // 상태를 유지하기 위해 Riverpod의 Provider를 사용하여 관리함.
  // 이를 통해 앱의 다른 부분에서도 동일한 ScrollController에 접근할 수 있으며, 상태를 일관성 있게 유지함.
  // ScrollController를 late 변수로 선언
  // ScrollController가 여러 ScrollView에 attach 되어서 ScrollController가 동시에 여러 ScrollView에서 사용될 때 발생한 문제를 해결한 방법
  // => late로 변수 선언 / 해당 변수를 초기화(initState()) / 해당 변수를 해제 (dispose())
  late ScrollController wishlistScreenPointScrollController; // 스크롤 컨트롤러 선언

  // // ------ 스크롤 위치를 업데이트하기 위한 '_updateScrollPosition' 함수 관련 구현 내용 시작
  // // 사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을 때 마지막으로 본 위치로 자동으로 스크롤되도록 함.
  // void _updateScrollPosition() {
  //   // 'wishlistScreenPointScrollController'에서 현재의 스크롤 위치(offset)를 가져와서 'currentScrollPosition' 변수에 저장함.
  //   double currentScrollPosition = wishlistScreenPointScrollController.offset;
  //
  //   // 'ref'를 사용하여 'wishlistScrollPositionProvider'의 notifier를 읽어옴.
  //   // 읽어온 notifier의 'state' 값을 'currentScrollPosition'으로 설정함.
  //   // 이렇게 하면 앱의 다른 부분에서 해당 스크롤 위치 정보를 참조할 수 있게 됨.
  //   ref.read(wishlistScrollPositionProvider.notifier).state =
  //       currentScrollPosition;
  // }
  //
  // // ------ 스크롤 위치를 업데이트하기 위한 '_updateScrollPosition' 함수 관련 구현 내용 끝

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // ScrollController를 초기화
    wishlistScreenPointScrollController = ScrollController();
    // initState에서 저장된 스크롤 위치로 이동
    // initState에서 실행되는 코드. initState는 위젯이 생성될 때 호출되는 초기화 단계
    // WidgetsBinding.instance.addPostFrameCallback 메서드를 사용하여 프레임이 렌더링 된 후 콜백을 등록함.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 스크롤 컨트롤러가 활성 스크롤 뷰를 가지고 있는지 확인함.
      if (wishlistScreenPointScrollController.hasClients) {
        // savedScrollPosition 변수에 저장된 스크롤 위치를 읽어옴.
        // ref.read(scrollPositionProvider)는 Riverpod 상태 관리 라이브러리를 사용하여
        // scrollPositionProvider에서 마지막으로 저장된 스크롤 위치를 가져옴.
        double savedScrollPosition = ref.read(wishlistScrollPositionProvider);
        // wishlistScreenPointScrollController.jumpTo 메서드를 사용하여 스크롤 위치를 savedScrollPosition으로 즉시 이동함.
        // 이는 스크롤 애니메이션이나 다른 복잡한 동작 없이 바로 지정된 위치로 점프함.
        wishlistScreenPointScrollController.jumpTo(savedScrollPosition);
      }

      // tabIndexProvider의 상태를 하단 탭 바 내 버튼과 매칭이 되면 안되므로 0~3이 아닌 -1로 매핑
      // -> 찜 목록 화면 초기화 시, 하단 탭 바 내 모든 버튼 비활성화
      ref.read(tabIndexProvider.notifier).state = -1;
      ref.invalidate(wishlistItemProvider); // 찜 목록 데이터 초기화
    });
    // // 사용자가 스크롤할 때마다 현재의 스크롤 위치를 wishlistScreenPointScrollController에 저장하는 코드
    // // 상단 탭바 버튼 클릭 시, 해당 섹션으로 화면 이동하는 위치를 저장하는거에 해당 부분도 추가하여
    // // 사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을 때 마지막으로 본 위치로 자동으로 스크롤되도록 함.
    // wishlistScreenPointScrollController.addListener(_updateScrollPosition);

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        ref.read(wishlistScrollPositionProvider.notifier).state = 0;
        ref.invalidate(wishlistItemProvider); // 찜 목록 데이터 초기화
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

    // // 'wishlistScreenPointScrollController'의 리스너 목록에서 '_updateScrollPosition' 함수를 제거함.
    // // 이는 '_updateScrollPosition' 함수가 더 이상 스크롤 이벤트에 반응하지 않도록 설정함.
    // wishlistScreenPointScrollController.removeListener(_updateScrollPosition);

    wishlistScreenPointScrollController.dispose(); // ScrollController 해제
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

    // List<ProductContent> wishlistItems = ref.watch(wishlistProvider);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: wishlistScreenPointScrollController,
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                floating: false,
                pinned: true,
                expandedHeight: 0.0,
                title: buildCommonAppBar(
                  context: context,
                  ref: ref,
                  title: '찜 목록',
                  leadingType: LeadingType.none,
                  buttonCase: 1,
                ),
                leading: null,
                backgroundColor: BUTTON_COLOR,
              ),
              // 실제 컨텐츠를 나타내는 슬리버 리스트
              // 슬리버 패딩을 추가하여 위젯 간 간격 조정함.
              SliverPadding(
              padding: EdgeInsets.only(top: 5),
              // SliverList를 사용하여 목록 아이템을 동적으로 생성함.
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                      // 각 항목의 좌우 간격을 4.0으로 설정함.
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        children: [
                          SizedBox(height: 8),
                          WishlistItemsList(), // WishlistItemsList 클래스 사용
                          SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                  childCount: 1, // 하나의 큰 Column이 모든 카드뷰를 포함하고 있기 때문에 1로 설정
                ),
              ),
              ),
            ],
          ),
          buildTopButton(context, wishlistScreenPointScrollController),
        ],
      ),
      bottomNavigationBar: buildCommonBottomNavigationBar(
          ref.watch(tabIndexProvider),
          ref,
          context,
          5, 1),
    );
  }
}
//     // ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 시작
//     // ------ 기존 buildCommonAppBar 위젯 내용과 동일하며,
//     // 플러터 기본 SliverAppBar 위젯을 활용하여 앱 바의 상태 동적 UI 구현에 수월한 부분을 정의해서 해당 위젯을 바로 다른 화면에 구현하여
//     // 기본 SliverAppBar의 드로워화면 토글 옵션을 삭제하는 등의 작업이 필요없는 방식-현재는 이슈가 있어 사용 안함..
//     return Scaffold(
//       body: Stack(
//         children: [
//           CustomScrollView(
//             controller: wishlistScreenPointScrollController, // 스크롤 컨트롤러 연결
//             slivers: <Widget>[
//               // SliverAppBar를 사용하여 기존 AppBar 기능을 재사용
//               SliverAppBar(
//                 // 'automaticallyImplyLeading: false'를 추가하여 SliverAppBar가 자동으로 leading 버튼을 생성하지 않도록 설정함.
//                 automaticallyImplyLeading: false,
//                 floating: false,
//                 // 스크롤 시 SliverAppBar가 빠르게 나타남.
//                 pinned: true,
//                 // 스크롤 다운시 AppBar가 상단에 고정됨.
//                 expandedHeight: 0.0,
//                 // 확장된 높이를 0으로 설정하여 확장 기능 제거
//                 // FlexibleSpaceBar를 사용하여 AppBar 부분의 확장 및 축소 효과 제공함.
//                 title: buildCommonAppBar(
//                   // 공통 AppBar 빌드
//                   context: context,
//                   // 현재 context 전달
//                   ref: ref,
//                   // 참조(ref) 전달
//                   title: '찜 목록',
//                   // AppBar의 제목을 '찜 목록'로 설정
//                   leadingType: LeadingType.none,
//                   // 버튼 없음.
//                   buttonCase: 1, // 1번 케이스 (버튼 없음)
//                 ),
//                 leading: null,
//                 // 좌측 상단의 메뉴 버튼 등을 제거함.
//                 // iOS에서는 AppBar의 배경색을 사용
//                 // SliverAppBar 배경색 설정  // AppBar 배경을 투명하게 설정 -> 투명하게 해서 스크롤 내리면 다른 컨텐츠가 비쳐서 보이는 것!!
//                 backgroundColor: BUTTON_COLOR,
//               ),
//               // 실제 컨텐츠를 나타내는 슬리버 리스트
//               // 슬리버 패딩을 추가하여 위젯 간 간격 조정함.
//               SliverPadding(
//                 padding: EdgeInsets.only(top: 5),
//                 // SliverList를 사용하여 목록 아이템을 동적으로 생성함.
//                 sliver: SliverList(
//                   delegate: SliverChildBuilderDelegate(
//                     (BuildContext context, int index) {
//                       return Padding(
//                         // 각 항목의 좌우 간격을 4.0으로 설정함.
//                         padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                         child: Column(
//                           children: [
//                             SizedBox(height: 5), // 높이 20으로 간격 설정
//                             Text('찜 목록 내용'),
//                             SizedBox(height: 3000), // 높이 임의로 3000으로 간격 설정
//                           ],
//                         ),
//                       );
//                     },
//                     childCount: 1, // 하나의 큰 Column이 모든 카드뷰를 포함하고 있기 때문에 1로 설정
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           // buildTopButton 함수는 주어진 context와 wishlistScreenPointScrollController를 사용하여
//           // 화면 상단으로 스크롤하기 위한 버튼 생성 위젯이며, common_body_parts_layout.dart 내에 있는 곳에서 재사용하여 구현한 부분
//           buildTopButton(context, wishlistScreenPointScrollController),
//         ],
//       ),
//       bottomNavigationBar: buildCommonBottomNavigationBar(
//           ref.watch(tabIndexProvider),
//           ref,
//           context,
//           5), // 공통으로 사용되는 하단 네비게이션 바를 가져옴.
//     );
//     // ------ 화면구성 끝
//   }
// // ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 끝
// // ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 끝
// }
// }
// // _WishlistScreenState 클래스 끝
