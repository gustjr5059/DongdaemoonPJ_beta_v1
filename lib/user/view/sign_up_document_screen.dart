
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../common/layout/common_exception_parts_of_body_layout.dart';
import '../../common/provider/common_state_provider.dart';
import '../layout/sign_up_document_body_parts_layout.dart';
import '../provider/sign_up_document_state_provider.dart';


// 각 화면에서 Scaffold 위젯을 사용할 때 GlobalKey 대신 로컬 context 사용
// GlobalKey를 사용하면 여러 위젯에서 사용이 안되는거라 로컬 context를 사용
// Scaffold 위젯 사용 시 GlobalKey 대신 local context 사용 권장
// GlobalKey 사용 시 여러 위젯에서 동작하지 않을 수 있음
// GlobalKey 대신 local context 사용 방법 설명 클래스
// SignUpDocumentScreen 클래스는 ConsumerWidget 상속, Riverpod를 통한 상태 관리 지원
class SignUpDocumentScreen extends ConsumerStatefulWidget {
  final String documentId;
  final String title;

  const SignUpDocumentScreen({
    required this.documentId,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  _SignUpDocumentScreenState createState() => _SignUpDocumentScreenState();
}

// _SignUpDocumentScreenState 클래스 시작
// _SignUpDocumentScreenState 클래스는 SignUpDocumentScreen 위젯의 상태를 관리함.
// WidgetsBindingObserver 믹스인을 통해 앱 생명주기 상태 변화를 감시함.
class _SignUpDocumentScreenState extends ConsumerState<SignUpDocumentScreen>
    with WidgetsBindingObserver {
  // 사용자 인증 상태 변경을 감지하는 스트림 구독 객체임.
  // 이를 통해 사용자 로그인 또는 로그아웃 상태 변경을 실시간으로 감지하고 처리할 수 있음.
  StreamSubscription<User?>? authStateChangesSubscription;

  // signUpDocumentScrollControllerProvider에서 ScrollController를 읽어와서 scrollController에 할당
  // ref.read(signUpDocumentScrollControllerProvider에서)는 provider를 이용해 상태를 읽는 방식.
  // ScrollController는 스크롤 가능한 위젯의 스크롤 동작을 제어하기 위해 사용됨.
  // 1.상단 탭바 버튼 클릭 시 해당 섹션으로 스크롤 이동하는 기능,
  // 2.하단 탭바의 버튼 클릭 시  화면 초기 위치로 스크롤 이동하는 기능,
  // 3.사용자가 앱을 종료하거나 다른 화면으로 이동한 후 돌아왔을때 마지막으로 본 위치로 자동으로 스크롤되도록 하는 기능,
  // 4.단순 스크롤을 내리거나 올릴 시, 상단 탭 바 버튼 텍스트 색상이 변경되도록 하는 기능,
  // 5. 'top' 버튼 클릭 시 홈 화면 초기 위치로 스크롤 이동하는 기능,
  // => 5개의 기능인 전체 화면의 스크롤을 제어하는 컨트롤러-화면 내의 여러 섹션으로의 이동 역할

  // signUpDocumentScrollControllerProvider : 여러 위젯에서 동일한 ScrollController를 공유하고,
  // 상태를 유지하기 위해 Riverpod의 Provider를 사용하여 관리함.
  // 이를 통해 앱의 다른 부분에서도 동일한 ScrollController에 접근할 수 있으며, 상태를 일관성 있게 유지함.
  // ScrollController를 late 변수로 선언
  // ScrollController가 여러 ScrollView에 attach 되어서 ScrollController가 동시에 여러 ScrollView에서 사용될 때 발생한 문제를 해결한 방법
  // => late로 변수 선언 / 해당 변수를 초기화(initState()) / 해당 변수를 해제 (dispose())
  late ScrollController
  signUpDocumentScreenPointScrollController; // 스크롤 컨트롤러 선언

  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // ScrollController를 초기화
    signUpDocumentScreenPointScrollController = ScrollController();

    // initState에서 저장된 스크롤 위치로 이동
    // initState에서 실행되는 코드. initState는 위젯이 생성될 때 호출되는 초기화 단계
    // WidgetsBinding.instance.addPostFrameCallback 메서드를 사용하여 프레임이 렌더링 된 후 콜백을 등록함.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 스크롤 컨트롤러가 활성 스크롤 뷰를 가지고 있는지 확인함.
      if (signUpDocumentScreenPointScrollController.hasClients) {
        // savedScrollPosition 변수에 저장된 스크롤 위치를 읽어옴.
        // ref.read(scrollPositionProvider)는 Riverpod 상태 관리 라이브러리를 사용하여
        // scrollPositionProvider에서 마지막으로 저장된 스크롤 위치를 가져옴.
        double savedScrollPosition =
        ref.read(signUpDocumentScrollPositionProvider);
        // signUpDocumentScreenPointScrollController.jumpTo 메서드를 사용하여 스크롤 위치를 savedScrollPosition으로 즉시 이동함.
        // 이는 스크롤 애니메이션이나 다른 복잡한 동작 없이 바로 지정된 위치로 점프함.
        signUpDocumentScreenPointScrollController.jumpTo(savedScrollPosition);
      }

      // tabIndexProvider의 상태를 하단 탭 바 내 버튼과 매칭이 되면 안되므로 0~3이 아닌 -1로 매핑
      // -> 동의서 화면 초기화 시, 하단 탭 바 내 모든 버튼 비활성화
      ref.read(tabIndexProvider.notifier).state = -1;
      // 동의서 상세 데이터를 초기화하는 함수 호출
      ref
          .read(signUpDocumentDetailItemProvider(widget.documentId).notifier)
          .resetDocumentDetailItem();
      // 동의서 상세 데이터를 다시 로드하는 함수 호출
      ref
          .read(signUpDocumentDetailItemProvider(widget.documentId).notifier)
          .loadMoreDocumentDetailItem(widget.documentId);
    });

    // FirebaseAuth 상태 변화를 감지하여 로그인 상태 변경 시 페이지 인덱스를 초기화함.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return; // 위젯이 비활성화된 상태면 바로 반환
      if (user == null) {
        // 사용자가 로그아웃한 경우, 현재 페이지 인덱스를 0으로 설정
        ref.read(signUpDocumentScrollPositionProvider.notifier).state = 0;
        // 동의서 상세 데이터를 초기화하는 함수 호출
        ref
            .read(signUpDocumentDetailItemProvider(widget.documentId).notifier)
            .resetDocumentDetailItem();
        // 동의서 상세 데이터를 다시 로드하는 함수 호출
        ref
            .read(signUpDocumentDetailItemProvider(widget.documentId).notifier)
            .loadMoreDocumentDetailItem(widget.documentId);
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

  // didChangeAppLifecycleState 함수 관련 구현 내용 시작
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      updateStatusBar();
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

    signUpDocumentScreenPointScrollController.dispose(); // ScrollController 해제

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
    final double documentDtAppBarTitleWidth =
        screenSize.width * (240 / referenceWidth);
    final double documentDtAppBarTitleHeight =
        screenSize.height * (22 / referenceHeight);
    final double documentDtAppBarTitleX =
        screenSize.width * (5 / referenceHeight);
    final double documentDtAppBarTitleY =
        screenSize.height * (11 / referenceHeight);

    // body 부분 데이터 내용의 전체 패딩 수치
    final double documentDtlistPaddingX =
        screenSize.width * (17 / referenceWidth);
    final double documentDtlistPaddingY =
        screenSize.height * (8 / referenceHeight);

    // 이전화면으로 이동 아이콘 관련 수치 동적 적용
    final double documentDtChevronIconWidth =
        screenSize.width * (24 / referenceWidth);
    final double documentDtChevronIconHeight =
        screenSize.height * (24 / referenceHeight);
    final double documentDtChevronIconX =
        screenSize.width * (10 / referenceWidth);
    final double documentDtChevronIconY =
        screenSize.height * (9 / referenceHeight);

    // 동의서 화면 내 비어있는 경우의 알림 부분 수치임
    final double documentDetailEmptyTextWidth =
        screenSize.width * (393 / referenceWidth); // 가로 비율임
    final double documentDetailEmptyTextHeight =
        screenSize.height * (22 / referenceHeight); // 세로 비율임
    final double documentDetailEmptyTextY =
        screenSize.height * (300 / referenceHeight); // 세로 비율임
    final double documentDetailEmptyTextFontSize =
        screenSize.height * (16 / referenceHeight); // 폰트 크기를 비율로 설정함

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: signUpDocumentScreenPointScrollController,
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                floating: true,
                pinned: true,
                expandedHeight: 0.0,
                // 확장 높이 설정
                // FlexibleSpaceBar를 사용하여 AppBar 부분의 확장 및 축소 효과 제공함.
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  // 앱 바 부분을 고정시키는 옵션->앱 바가 스크롤에 의해 사라지고, 그 자리에 상단 탭 바가 있는 bottom이 상단에 고정되도록 하는 기능
                    background: buildCommonAppBar(
                      context: context,
                      ref: ref,
                      title: widget.title, // 동적으로 전달받은 title 사용
                      fontFamily: 'NanumGothic',
                      leadingType: LeadingType.back,
                      buttonCase: 1,
                      appBarTitleWidth: documentDtAppBarTitleWidth,
                      appBarTitleHeight: documentDtAppBarTitleHeight,
                      appBarTitleX: documentDtAppBarTitleX,
                      appBarTitleY: documentDtAppBarTitleY,
                      chevronIconWidth: documentDtChevronIconWidth,
                      chevronIconHeight: documentDtChevronIconHeight,
                      chevronIconX: documentDtChevronIconX,
                      chevronIconY: documentDtChevronIconY,
                    ),
                ),
                leading: null,
                // backgroundColor: BUTTON_COLOR,
              ),
              // 실제 컨텐츠를 나타내는 슬리버 리스트
              // 슬리버 패딩을 추가하여 위젯 간 간격 조정함.
              // 상단에 5픽셀의 여백을 추가하는 SliverPadding 위젯.
              SliverPadding(
                padding: EdgeInsets.only(top: 5),
                // SliverList를 사용하여 목록 아이템을 동적으로 생성함.
                sliver: Consumer(
                  // Consumer 위젯은 Riverpod 상태 관리 값을 구독하는 역할을 함.
                  builder: (context, ref, child) {
                    // signUpDocumentDetailItemProvider를 사용해 공지사항 상세 아이템을 구독함.
                    final documentDetailItem = ref
                        .watch(signUpDocumentDetailItemProvider(widget.documentId));
                    final isLoading = ref.watch(isLoadingProvider);
                    // 동의서 내용이 비어있으면 '현재 관련 내용이 없습니다.'라는 텍스트를 출력함.
                    // StateNotifierProvider를 사용한 로직에서는 AsyncValue를 사용하여 상태를 처리할 수 없으므로
                    // loading: (), error: (err, stack)를 구분해서 구현 못함
                    // 그래서, 이렇게 isEmpty 경우로 해서 구현하면 error와 동일하게 구현은 됨
                    // 로딩 표시는 아래의 (documentDetailItem.isEmpty && isLoading) 경우로 표시함

                    // 데이터가 비어 있고 로딩 중일 때 로딩 인디케이터 표시
                    if (documentDetailItem.isEmpty && isLoading) {
                      // SliverToBoxAdapter 위젯을 사용하여 리스트의 단일 항목을 삽입함
                      return SliverToBoxAdapter(
                        // 전체 컨테이너를 설정
                        child: Container(
                          height: screenSize.height * 0.7, // 화면 높이의 70%로 설정함
                          alignment: Alignment.center, // 컨테이너 안의 내용물을 중앙 정렬함
                          child: buildCommonLoadingIndicator(), // 로딩 인디케이터를 표시함
                        ),
                      );
                    }

                    // 데이터가 비어 있는 경우
                    return documentDetailItem.isEmpty
                        ? SliverToBoxAdapter(
                      // 동의서 관련 내용이 없을 때, 텍스트가 포함된 컨테이너를 화면에 표시함.
                      child: Container(
                        // 동의서 관련 내용이 비어있을 때 텍스트의 너비를 설정함.
                        width: documentDetailEmptyTextWidth,
                        // 동의서 관련 내용이 비어있을 때 텍스트의 높이를 설정함.
                        height: documentDetailEmptyTextHeight,
                        // 텍스트의 위치를 화면 상단으로부터 조정함.
                        margin: EdgeInsets.only(
                            top: documentDetailEmptyTextY),
                        // 텍스트를 중앙에 위치하도록 설정함.
                        alignment: Alignment.center,
                        // '에러가 발생했으니, 앱을 재실행해주세요.'라는 텍스트를 표시함.
                        child: Text(
                          '에러가 발생했으니, 앱을 재실행해주세요.',
                          style: TextStyle(
                            // 텍스트의 폰트 크기를 설정함.
                            fontSize: documentDetailEmptyTextFontSize,
                            // 폰트 패밀리를 'NanumGothic'으로 설정함.
                            fontFamily: 'NanumGothic',
                            // 폰트 굵기를 'bold'로 설정함.
                            fontWeight: FontWeight.bold,
                            // 텍스트 색상을 검은색으로 설정함.
                            color: BLACK_COLOR,
                          ),
                        ),
                      ),
                    )
                    // 동의서 관련 내용이 있을 경우, SliverList로 아이템을 표시함.
                        : SliverList(
                      // SliverChildBuilderDelegate를 사용하여 각 항목을 빌드함.
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          // 각 항목을 패딩으로 감싸 좌우 간격을 documentDtlistPaddingX로 설정함.
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: documentDtlistPaddingX),
                            child: Column(
                              children: [
                                SizedBox(height: documentDtlistPaddingY),
                                // SignUpDocumentDetailBodyPartsLayout을 재사용하여 공지사항 상세 내용을 표시함.
                                SignUpDocumentDetailBodyPartsLayout(
                                    documentId: widget.documentId),
                                SizedBox(height: documentDtlistPaddingY),
                              ],
                            ),
                          );
                        },
                        // 전체 아이템을 하나의 큰 Column으로 구성하기 때문에 childCount를 1로 설정함.
                        childCount: 1,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          buildTopButton(context, signUpDocumentScreenPointScrollController),
        ],
      ),
    );
  }
}
// _SignUpDocumentScreenState 클래스 끝