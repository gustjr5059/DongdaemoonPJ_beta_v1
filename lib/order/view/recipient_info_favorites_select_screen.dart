// Dart의 IO 라이브러리에서 Platform 클래스를 가져옵니다. 이 클래스는 운영 체제에 대한 정보를 제공합니다.
import 'dart:io' show Platform;

// Dart 비동기 프로그래밍을 위한 라이브러리에서 Future와 Stream 등을 사용할 수 있게 합니다.
import 'dart:async';

// Firebase의 사용자 인증 기능을 사용하기 위한 패키지를 임포트합니다.
import 'package:firebase_auth/firebase_auth.dart';

// Flutter의 기본 디자인과 인터페이스 요소들을 사용하기 위한 Material 패키지를 임포트합니다.
import 'package:flutter/material.dart';

// 플랫폼 특정 기능을 제어하기 위한 서비스 인터페이스를 제공합니다.
import 'package:flutter/services.dart';

// Riverpod 패키지를 사용한 상태 관리 기능을 추가합니다. Riverpod는 상태 관리를 위한 외부 패키지입니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';

// url_launcher 패키지를 가져옵니다.
// 이 패키지는 URL을 열거나, 이메일, 전화 등을 실행할 수 있는 기능을 제공합니다.
import 'package:url_launcher/url_launcher.dart';

// 공통적으로 사용될 상태 관리 로직을 포함하는 파일을 임포트합니다.
import '../../../common/provider/common_state_provider.dart';

// 애플리케이션의 공통 UI 컴포넌트를 구성하는 파일을 임포트합니다.
import '../../../common/layout/common_body_parts_layout.dart';

// 다양한 색상을 정의하는 파일을 임포트합니다.
import '../../common/const/colors.dart';

// 예외 발생 시 사용할 공통 UI 부분을 정의한 파일을 임포트합니다.
import '../../common/layout/common_exception_parts_of_body_layout.dart';

// banner_model.dart 파일을 common 디렉토리의 model 폴더에서 가져옵니다.
// 이 파일에는 배너와 관련된 데이터 모델이 정의되어 있을 것입니다.
import '../../common/model/banner_model.dart';

// common_all_providers.dart 파일을 common 디렉토리의 provider 폴더에서 가져옵니다.
// 이 파일에는 Future Provider와 관련된 기능이 정의되어 있을 것입니다.
import '../../common/provider/common_all_providers.dart';

// 수령자 정보 즐겨찾기 선택 화면의 상태를 관리하기 위한 Provider 파일을 임포트합니다.
import '../layout/order_body_parts_layout.dart';
import '../provider/order_state_provider.dart';

// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용 권장
// GlobalKey 사용 시 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// RecipientInfoFavoritesSelectScreen 클래스는 ConsumerWidget 상속, Riverpod를 통한 상태 관리 지원
class RecipientInfoFavoritesSelectScreen extends ConsumerStatefulWidget {
  const RecipientInfoFavoritesSelectScreen({Key? key}) : super(key: key);

  @override
  _RecipientInfoFavoritesSelectScreenState createState() => _RecipientInfoFavoritesSelectScreenState();
}

// _RecipientInfoFavoritesSelectScreenState 클래스 시작
// _RecipientInfoFavoritesSelectScreenState 클래스는 RecipientInfoFavoritesSelectScreen 위젯의 상태를 관리함.
// WidgetsBindingObserver 믹스인을 통해 앱 생명주기 상태 변화를 감시함.
class _RecipientInfoFavoritesSelectScreenState extends ConsumerState<RecipientInfoFavoritesSelectScreen>
    with WidgetsBindingObserver {
  // 사용자 인증 상태 변경을 감지하는 스트림 구독 객체임.
  // 이를 통해 사용자 로그인 또는 로그아웃 상태 변경을 실시간으로 감지하고 처리할 수 있음.
  StreamSubscription<User?>? authStateChangesSubscription;

  late ScrollController recipientInfoFavoritesSelectScreenPointScrollController; // 스크롤 컨트롤러 선언

  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // ScrollController를 초기화
    recipientInfoFavoritesSelectScreenPointScrollController = ScrollController();

    // 스크롤이 끝에 도달했을 때 추가 데이터를 로드하도록 구현
    recipientInfoFavoritesSelectScreenPointScrollController.addListener(() {
      if (recipientInfoFavoritesSelectScreenPointScrollController.position.pixels ==
          recipientInfoFavoritesSelectScreenPointScrollController.position.maxScrollExtent) {
        // 스크롤이 끝에 도달했을 때, 추가 데이터를 로드하는 함수 호출
        ref.read(recipientInfoItemsProvider.notifier).loadMoreRecipientInfoItems();
      }
    });

    // initState에서 저장된 스크롤 위치로 이동
    // initState에서 실행되는 코드. initState는 위젯이 생성될 때 호출되는 초기화 단계
    // WidgetsBinding.instance.addPostFrameCallback 메서드를 사용하여 프레임이 렌더링 된 후 콜백을 등록함.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 스크롤 컨트롤러가 활성 스크롤 뷰를 가지고 있는지 확인함.
      if (recipientInfoFavoritesSelectScreenPointScrollController.hasClients) {
        // savedScrollPosition 변수에 저장된 스크롤 위치를 읽어옴.
        // ref.read(scrollPositionProvider)는 Riverpod 상태 관리 라이브러리를 사용하여
        // scrollPositionProvider에서 마지막으로 저장된 스크롤 위치를 가져옴.
        double savedScrollPosition = ref.read(recipientInfoFavoritesSelectScrollPositionProvider);
        // recipientInfoFavoritesSelectScreenPointScrollController.jumpTo 메서드를 사용하여 스크롤 위치를 savedScrollPosition으로 즉시 이동함.
        // 이는 스크롤 애니메이션이나 다른 복잡한 동작 없이 바로 지정된 위치로 점프함.
        recipientInfoFavoritesSelectScreenPointScrollController.jumpTo(savedScrollPosition);
      }

      // tabIndexProvider의 상태를 하단 탭 바 내 버튼과 매칭이 되면 안되므로 0~3이 아닌 -1로 매핑
      // -> 수령자 정보 즐겨찾기 선택 화면 초기화 시, 하단 탭 바 내 모든 버튼 비활성화
      ref.read(tabIndexProvider.notifier).state = -1;
      // 수령자 정보 즐겨찾기 선택 화면으로 돌아왔을 때 데이터를 초기화하고 다시 불러옴
      ref.read(recipientInfoItemsProvider.notifier).resetRecipientInfoItems();
      ref.read(recipientInfoItemsProvider.notifier).loadMoreRecipientInfoItems();
    });

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        // 수령자 정보 즐겨찾기 선택 화면에서 로그아웃 이벤트를 실시간으로 감지하고 처리하는 로직 (여기에도 수령자 정보 즐겨찾기 선택 화면 내 프로바이더 중 초기화해야하는 것을 로직 구현)
        ref.read(recipientInfoFavoritesSelectScrollPositionProvider.notifier).state =
        0.0; // 수령자 정보 즐겨찾기 선택 화면 자체의 스크롤 위치 인덱스를 초기화
      }
    });

    // WidgetsBindingObserver를 추가하여 앱의 생명주기 변화 감지
    WidgetsBinding.instance.addObserver(this); // 생명주기 옵저버 등록

    // 상태표시줄 색상을 안드로이드와 ios 버전에 맞춰서 변경하는데 사용되는 함수-앱 실행 생명주기에 맞춰서 변경
    updateStatusBar();

    // 네트워크 상태 체크 시작
    _networkChecker = NetworkChecker(context);
    _networkChecker?.checkNetworkStatus();
  }

  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 끝 (앱 실행 생명주기 관련 함수)

  // ------ 페이지 뷰 자동 스크롤 타이머 함수인 startAutoScrollTimer() 시작 및 정지 관린 함수인
  // didChangeAppLifecycleState 함수 관련 구현 내용 시작
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      updateStatusBar();
    }
  }

  // ------ 페이지 뷰 자동 스크롤 타이머 함수인 startAutoScrollTimer() 시작 및 정지 관린 함수인
  // didChangeAppLifecycleState 함수 관련 구현 내용 끝

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void dispose() {
    // WidgetsBinding 인스턴스에서 이 객체를 옵저버 목록에서 제거함.
    // 앱 생명주기 이벤트를 더 이상 수신하지 않겠다는 의도임.
    WidgetsBinding.instance.removeObserver(this);

    // 사용자 인증 상태 감지 구독 해제함.
    authStateChangesSubscription?.cancel();

    recipientInfoFavoritesSelectScreenPointScrollController.dispose(); // ScrollController 해제

    // 네트워크 체크 해제
    _networkChecker?.dispose();

    super.dispose(); // 위젯의 기본 정리 작업 수행
  }

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 끝 (앱 실행 생명주기 관련 함수)
  // ------ 앱 실행 생명주기 관리 관련 함수 끝

  // ------ 위젯이 UI를 어떻게 그릴지 결정하는 기능인 build 위젯 구현 내용 시작
  @override
  Widget build(BuildContext context) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // AppBar 관련 수치 동적 적용
    final double recipientInfoAppBarTitleWidth = screenSize.width * (160 / referenceWidth);
    final double recipientInfoAppBarTitleHeight = screenSize.height * (22 / referenceHeight);
    final double recipientInfoAppBarTitleX = screenSize.height * (70 / referenceHeight);
    final double recipientInfoAppBarTitleY = screenSize.height * (11 / referenceHeight);

    // 이전화면으로 이동 아이콘 관련 수치 동적 적용
    final double recipientInfoChevronIconWidth = screenSize.width * (24 / referenceWidth);
    final double recipientInfoChevronIconHeight = screenSize.height * (24 / referenceHeight);
    final double recipientInfoChevronIconX = screenSize.width * (12 / referenceWidth);
    final double recipientInfoChevronIconY = screenSize.height * (8 / referenceHeight);

    // 수령자 정보 즐겨찾기 목록 비어있는 경우의 알림 부분 수치
    final double recipientInfoEmptyTextWidth =
        screenSize.width * (170 / referenceWidth); // 가로 비율
    final double recipientInfoEmptyTextHeight =
        screenSize.height * (22 / referenceHeight); // 세로 비율
    final double recipientInfoEmptyTextX =
        screenSize.width * (100 / referenceWidth); // 가로 비율
    final double recipientInfoEmptyTextY =
        screenSize.height * (300 / referenceHeight); // 세로 비율
    final double recipientInfoEmptyTextFontSize =
        screenSize.height * (16 / referenceHeight);

    // ------ SliverAppBar buildCommonSliverAppBar 함수를 재사용하여 앱 바와 상단 탭 바의 스크롤 시, 상태 변화 동작 시작
    // ------ 기존 buildCommonAppBar 위젯 내용과 동일하며,
    // 플러터 기본 SliverAppBar 위젯을 활용하여 앱 바의 상태 동적 UI 구현에 수월한 부분을 정의해서 해당 위젯을 바로 다른 화면에 구현하여
    // 기본 SliverAppBar의 드로워화면 토글 옵션을 삭제하는 등의 작업이 필요없는 방식-현재는 이슈가 있어 사용 안함..
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: recipientInfoFavoritesSelectScreenPointScrollController, // 스크롤 컨트롤러 연결
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
                // 확장 높이 설정
                // FlexibleSpaceBar를 사용하여 AppBar 부분의 확장 및 축소 효과 제공함.
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  // 앱 바 부분을 고정시키는 옵션->앱 바가 스크롤에 의해 사라지고, 그 자리에 상단 탭 바가 있는 bottom이 상단에 고정되도록 하는 기능
                  background: buildCommonAppBar(
                    // 공통 AppBar 빌드
                    context: context,
                    // 현재 context 전달
                    ref: ref,
                    // 참조(ref) 전달
                    title: '즐겨찾기 목록',
                    // AppBar의 제목을 '즐겨찾기 목록'으로 설정
                    leadingType: LeadingType.back,
                    // 버튼 없음.
                    buttonCase: 1,
                    // 1번 케이스 (버튼 없음)
                    appBarTitleWidth: recipientInfoAppBarTitleWidth,
                    appBarTitleHeight: recipientInfoAppBarTitleHeight,
                    appBarTitleX: recipientInfoAppBarTitleX,
                    appBarTitleY: recipientInfoAppBarTitleY,
                    chevronIconWidth: recipientInfoChevronIconWidth,
                    chevronIconHeight: recipientInfoChevronIconHeight,
                    chevronIconX: recipientInfoChevronIconX,
                    chevronIconY: recipientInfoChevronIconY,
                  ),
                ),
                leading: null,
                // 좌측 상단의 메뉴 버튼 등을 제거함.
                // iOS에서는 AppBar의 배경색을 사용
                // SliverAppBar 배경색 설정  // AppBar 배경을 투명하게 설정 -> 투명하게 해서 스크롤 내리면 다른 컨텐츠가 비쳐서 보이는 것!!
                // backgroundColor: BUTTON_COLOR,
              ),
              // 실제 컨텐츠를 나타내는 슬리버 리스트
              // 슬리버 패딩을 추가하여 위젯 간 간격 조정함.
              // 상단에 여백을 주는 SliverPadding 위젯
              SliverPadding(
                padding: EdgeInsets.only(top: 0),
                // Consumer 위젯을 사용하여 recipientInfoProvider의 상태를 구독
                sliver: Consumer(
                  builder: (context, ref, child) {
                    // recipientInfoProvider의 상태를 가져옴
                    final recipientInfo = ref.watch(recipientInfoItemsProvider);
                    // 저장된 수령자 정보가 없을 경우 '저장된 수령자 정보가 없습니다.' 텍스트를 중앙에 표시
                    return recipientInfo.isEmpty
                        ? SliverToBoxAdapter(
                      child: Container(
                        width: recipientInfoEmptyTextWidth,
                        height: recipientInfoEmptyTextHeight,
                        margin: EdgeInsets.only(left: recipientInfoEmptyTextX, top: recipientInfoEmptyTextY),
                        child: Text('저장된 수령자 정보가 없습니다.',
                          style: TextStyle(
                            fontSize: recipientInfoEmptyTextFontSize,
                            fontFamily: 'NanumGothic',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                    // 저장된 수령자 정보가 있을 경우 SliverList를 사용하여 아이템 목록을 표시
                        : SliverList(
                      // SliverChildBuilderDelegate를 사용하여 아이템 목록을 빌드
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return Column(
                            // 아이템 사이에 여백을 주기 위한 SizedBox 위젯
                            children: [
                              // RecipientInfoItemsList 위젯을 사용하여 수령자 정보 즐겨찾기 목록 내 아이템을 표시
                              RecipientInfoItemsList(),
                            ],
                          );
                        },
                        // 아이템 개수를 1로 설정
                        childCount: 1,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // 상단 버튼을 빌드하는 함수 호출
          buildTopButton(context, recipientInfoFavoritesSelectScreenPointScrollController),
        ],
      ),
      // 하단 네비게이션 바를 빌드하는 함수 호출
      bottomNavigationBar:
      buildCommonBottomNavigationBar(0, ref, context, 5, 1, scrollController: recipientInfoFavoritesSelectScreenPointScrollController),
    );
  }
}
// _RecipientInfoFavoritesSelectScreenState 클래스 끝
