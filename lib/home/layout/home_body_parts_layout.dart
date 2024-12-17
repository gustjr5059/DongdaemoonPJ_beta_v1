// Cupertino 스타일의 위젯을 사용하기 위한 패키지를 임포트합니다. 주로 iOS 스타일의 디자인을 구현할 때 사용합니다.
import 'package:flutter/cupertino.dart';

// Flutter의 기본 디자인과 인터페이스 요소들을 사용하기 위한 Material 패키지를 임포트합니다.
import 'package:flutter/material.dart';

// 상태 관리를 위한 Riverpod 패키지를 임포트합니다. Riverpod는 강력하고 유연한 상태 관리 솔루션을 제공합니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 애플리케이션에서 사용될 색상 상수들을 정의한 파일을 임포트합니다.
import '../../common/const/colors.dart';

// 공통적으로 사용될 상태 관리 로직을 포함하는 Provider 파일을 임포트합니다.
import '../../common/layout/common_body_parts_layout.dart';

// 제품 카테고리별 메인 화면의 레이아웃을 정의하는 파일을 임포트합니다.
import '../../common/provider/common_state_provider.dart';
import '../../market/aaa/home/view/aaa_home_screen.dart';

import '../../market/aab/home/view/aab_home_screen.dart';
import '../../market/aac/home/view/aac_home_screen.dart';
import '../../market/aad/home/view/aad_home_screen.dart';
import '../../market/aae/home/view/aae_home_screen.dart';
import '../../market/aaf/home/view/aaf_home_screen.dart';
import '../../market/aag/home/view/aag_home_screen.dart';
import '../../market/aah/home/view/aah_home_screen.dart';
import '../../market/aai/home/view/aai_home_screen.dart';
import '../../market/aaj/home/view/aaj_home_screen.dart';
import '../../market/aak/home/view/aak_home_screen.dart';
import '../../market/aal/home/view/aal_home_screen.dart';
import '../../market/aam/home/view/aam_home_screen.dart';
import '../../market/aan/home/view/aan_home_screen.dart';
import '../../market/aao/home/view/aao_home_screen.dart';
import '../../market/aap/home/view/aap_home_screen.dart';
import '../../market/aaq/home/view/aaq_home_screen.dart';
import '../../market/aar/home/view/aar_home_screen.dart';
import '../../market/aas/home/view/aas_home_screen.dart';
import '../../market/aat/home/view/aat_home_screen.dart';
import '../../market/aau/home/view/aau_home_screen.dart';
import '../../market/aav/home/view/aav_home_screen.dart';
import '../../market/aaw/home/view/aaw_home_screen.dart';
import '../../market/aax/home/view/aax_home_screen.dart';
import '../../market/aay/home/view/aay_home_screen.dart';
import '../../market/aaz/home/view/aaz_home_screen.dart';
import '../../market/aba/home/view/aba_home_screen.dart';
import '../../market/abb/home/view/abb_home_screen.dart';
import '../../market/abc/home/view/abc_home_screen.dart';
import '../../market/abd/home/view/abd_home_screen.dart';


import '../../product/view/product_detail_original_image_screen.dart';
import '../provider/home_state_provider.dart';


// ------- EventPosterImgSectionList 클래스 내용 구현 시작
// 홈 화면 내 이벤트 포스터 이미지 섹션에서 데이터를 4개 단위로 표시하며 스크롤 가능한 UI 구현 관련 클래스
class EventPosterImgSectionList extends ConsumerStatefulWidget {
  // 생성자 선언
  EventPosterImgSectionList();

  @override
  _EventPosterImgSectionListState createState() =>
      _EventPosterImgSectionListState(); // 상태 객체 생성 함수 호출
}

class _EventPosterImgSectionListState
    extends ConsumerState<EventPosterImgSectionList> {
  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러 초기화

  @override
  void initState() {
    super.initState();

    // [변경사항 추가]: 이벤트 섹션 가로 스크롤 위치 복원
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final savedOffset = ref.read(eventPosterScrollPositionProvider);
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(savedOffset);
      }
    });

    _scrollController.addListener(() {
      // 이벤트 섹션 가로 스크롤 offset 저장
      ref.read(eventPosterScrollPositionProvider.notifier).state =
          _scrollController.offset;

      // 스크롤 위치가 스크롤 끝에 가까워지고, 추가 데이터를 로드 중이 아니며 더 로드할 데이터가 남아 있을 때
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !ref.read(eventPosterImgItemsProvider.notifier).isLoadingMore &&
          ref.read(eventPosterImgItemsProvider.notifier).hasMoreData) {
        ref
            .read(eventPosterImgItemsProvider.notifier)
            .loadMoreEventPosterImgItems();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 이벤트 포스터 이미지 항목 데이터 가져오기
    final eventPosterImgItems = ref.watch(eventPosterImgItemsProvider);

    // 화면 크기를 동적으로 가져오기 위한 MediaQuery
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852 (비율 계산에 사용)
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 화면 비율에 따른 가로 크기 설정
    final double DetailDocWidth = screenSize.width * (160 / referenceWidth);
    // 화면 비율에 따른 세로 크기 설정
    final double DetailDocHeight = screenSize.height * (250 / referenceHeight);
    // 아이템 간 여백 비율 설정
    final double DetailDoc1X = screenSize.width * (4 / referenceWidth);

    // 에러 관련 텍스트 수치
    final double errorTextFontSize1 =
        screenSize.height * (12 / referenceHeight);
    final double errorTextFontSize2 =
        screenSize.height * (10 / referenceHeight);

    return SingleChildScrollView(
        controller: _scrollController, // 수평 스크롤 컨트롤러 설정
        scrollDirection: Axis.horizontal, // 수평 스크롤 방향 설정
        child: Row(
          children: eventPosterImgItems.map((eventPosterImgItem) {
            // 각 항목의 이미지 URL 가져오기, 이미지가 없을 경우 '' 빈 칸 사용
            final posterImg = eventPosterImgItem['poster_1'] as String? ?? '';

            return Container(
              width: DetailDocWidth,
              // 설정된 가로 크기 사용
              padding: EdgeInsets.all(DetailDoc1X),
              // 아이템 간 여백 설정
              margin: EdgeInsets.all(DetailDoc1X),
              // 아이템 외부 여백 설정
              decoration: BoxDecoration(
                color: WHITE_COLOR, // 배경색 설정
                borderRadius: BorderRadius.circular(10.0), // 둥근 모서리 설정
                boxShadow: [
                  BoxShadow(
                    color: GRAY62_COLOR.withOpacity(0.5), // 그림자 색상 및 불투명도 설정
                    spreadRadius: 0, // 그림자 퍼짐 정도 설정
                    blurRadius: 1, // 그림자 흐림 정도 설정
                    offset: Offset(0, 4), // 그림자 위치 설정
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () async {
                  // ------ 이벤트 포스터 이미지 클릭 시, 원본 이미지를 로드하는 로직 시작 부분
                  // eventPosterImgItemsProvider의 notifier를 통해 원본 이미지를 비동기적으로 로드
                  final images = await ref
                      .read(eventPosterImgItemsProvider.notifier)
                      .loadEventPosterOriginalImages(eventPosterImgItem['id']);

                  // ------ 이미지 클릭 시 상세 이미지 화면으로 이동 시작 부분
                  // 로드된 이미지가 있을 경우, 상세 이미지 화면으로 네비게이션
                  if (images.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // 클릭된 이미지의 상세 화면으로 이동 라우트 정의
                        builder: (_) => ProductDetailOriginalImageScreen(
                          images: images, // 클릭한 이미지 리스트를 전달
                          initialPage: 0, // 첫 번째 페이지로 시작
                        ),
                      ),
                    );
                  }
                },
                // 포스터 이미지가 있으면 이미지를 표시하고, 없으면 아이콘을 표시
                child: posterImg != null && posterImg!.isNotEmpty
                    ? Image.network(
                  posterImg, // 네트워크 이미지 URL 설정
                  width: DetailDocWidth, // 이미지 가로 크기 설정
                  height: DetailDocHeight, // 이미지 세로 크기 설정
                  fit: BoxFit.cover, // 이미지 맞춤 방식 설정
                  // 이미지 로드 실패 시 아이콘 표시
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: DetailDocHeight, // 전체 화면 높이 설정
                    alignment: Alignment.center, // 중앙 정렬
                    child: buildCommonErrorIndicator(
                      message: '에러가 발생했습니다.',
                      // 첫 번째 메시지 설정
                      secondMessage: '재실행해주세요.',
                      // 두 번째 메시지 설정
                      fontSize1: errorTextFontSize1,
                      // 폰트1 크기 설정
                      fontSize2: errorTextFontSize2,
                      // 폰트2 크기 설정
                      color: BLACK_COLOR,
                      // 색상 설정
                      showSecondMessage: true, // 두 번째 메시지를 표시하도록 설정
                    ),
                  ),
                )
                    : Container(
                  height: DetailDocHeight, // 전체 화면 높이 설정
                  alignment: Alignment.center, // 중앙 정렬
                  child: buildCommonErrorIndicator(
                    message: '에러가 발생했습니다.',
                    // 첫 번째 메시지 설정
                    secondMessage: '재실행해주세요.',
                    // 두 번째 메시지 설정
                    fontSize1: errorTextFontSize1,
                    // 폰트1 크기 설정
                    fontSize2: errorTextFontSize2,
                    // 폰트2 크기 설정
                    color: BLACK_COLOR,
                    // 색상 설정
                    showSecondMessage: true, // 두 번째 메시지를 표시하도록 설정
                  ),
                ),
              ),
            );
          }).toList(),
        ));
  }
}
// ------- EventPosterImgSectionList 클래스 내용 구현 끝

// ------ 이벤트 섹션을 위젯으로 구현한 부분 내용 시작
// 이벤트 섹션에서 ProductsSectionList 위젯을 사용하여 데이터 UI를 구현하는 함수
Widget buildEventPosterImgProductsSection(WidgetRef ref, BuildContext context) {
  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852 (비율 계산의 기준이 됨)
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 크기와 위치를 동적으로 설정함
  // 섹션 내 요소들의 수치
  final double SectionX = screenSize.width * (16 / referenceWidth); // 왼쪽 여백 비율
  final double SectionY = screenSize.height * (8 / referenceHeight); // 위쪽 여백 비율
  final double SectionTextFontSize = screenSize.height * (20 / referenceHeight); // 텍스트 크기 비율

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start, // 컬럼 내부 요소를 왼쪽 정렬로 설정
    children: [
      Padding(
        padding: EdgeInsets.only(left: SectionX), // 왼쪽 여백 적용
        child: Text(
          '이벤트', // 섹션 제목을 '이벤트'로 설정함
          style: TextStyle(
            color: BLACK_COLOR, // 텍스트 색상 설정
            fontSize: SectionTextFontSize, // 텍스트 크기 설정
            fontFamily: 'NanumGothic', // 폰트 스타일 설정
            fontWeight: FontWeight.bold, // 텍스트 굵기 설정
          ),
        ),
      ),
      SizedBox(height: SectionY), // 제목과 리스트 사이의 간격 추가
      Padding(
        padding: EdgeInsets.only(left: SectionX), // 왼쪽 여백 적용
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), // 모서리 반경을 10으로 설정함
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
            ),
            child: EventPosterImgSectionList(), // EventPosterImgSectionList 위젯 사용하여 이벤트 이미지 리스트 표시
          ),
        ),
      ),
    ],
  );
}
// ------ 이벤트 섹션을 위젯으로 구현한 부분 내용 끝

// ------ 메인 홈 화면 내 마켓 버튼 UI 관련 로직인 MarketButtonList 클래스 시작 부분
class MarketButtonList extends ConsumerStatefulWidget {
  const MarketButtonList({Key? key}) : super(key: key);

  @override
  ConsumerState<MarketButtonList> createState() => _MarketButtonListState();
}

class _MarketButtonListState extends ConsumerState<MarketButtonList> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 Firestore 데이터 로드
    Future.microtask(() =>
        ref.read(marketBtnProvider.notifier).loadAllMarketButtons());
  }

  @override
  Widget build(BuildContext context) {
    final marketButtons = ref.watch(marketBtnProvider);
    final int buttonsPerRow = 5; // 한 행에 5개 버튼

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정
    final double interval1X = screenSize.width * (8 / referenceWidth);
    final double interval2X = screenSize.width * (48 / referenceWidth);
    final double interval1Y = screenSize.height * (8 / referenceHeight);
    final double interval2Y = screenSize.height * (10 / referenceHeight);


    if (marketButtons.isEmpty) {
      return buildCommonLoadingIndicator();
    }

    return IntrinsicHeight(
      child: Wrap(
        spacing: interval1X,
        runSpacing: interval1Y,
        children: List.generate(
          marketButtons.length,
              (index) {
            final item = marketButtons[index];
            return _buildMarketButton(
              context: context,
              name: item['name'],
              step: item['step'],
              id: item['id'],
              buttonWidth: (screenSize.width - interval2X) / buttonsPerRow,
            );
          },
        ),
      ),
    );
  }

  // 개별 버튼 위젯
  Widget _buildMarketButton({
    required BuildContext context,
    required String name,
    required String step,
    required String id,
    required double buttonWidth,
  }) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    final double buttonHeight = screenSize.height * (100 / referenceHeight);
    final double interval1Y = screenSize.height * (2 / referenceHeight);
    final double marketBtnTextFontSize = screenSize.height * (10 / referenceHeight);

    final String imagePath = 'asset/img/misc/button_img/market_button_$step.png';

    return GestureDetector(
      onTap: () {
        // 기존 코드에서는 dynamicScreenName을 사용했으나, 이제는 switch문으로 id에 따른 화면 전환
        Widget? targetScreen;

        switch (id) {
          case 'Aaa':
            targetScreen = AaaHomeMainScreen();
            break;
          case 'Aab':
            targetScreen = AabHomeMainScreen();
            break;
          case 'Aac':
            targetScreen = AacHomeMainScreen();
            break;
          case 'Aad':
            targetScreen = AadHomeMainScreen();
            break;
          case 'Aae':
            targetScreen = AaeHomeMainScreen();
            break;
          case 'Aaf':
            targetScreen = AafHomeMainScreen();
            break;
          case 'Aag':
            targetScreen = AagHomeMainScreen();
            break;
          case 'Aah':
            targetScreen = AahHomeMainScreen();
            break;
          case 'Aai':
            targetScreen = AaiHomeMainScreen();
            break;
          case 'Aaj':
            targetScreen = AajHomeMainScreen();
            break;
          case 'Aak':
            targetScreen = AakHomeMainScreen();
            break;
          case 'Aal':
            targetScreen = AalHomeMainScreen();
            break;
          case 'Aam':
            targetScreen = AamHomeMainScreen();
            break;
          case 'Aan':
            targetScreen = AanHomeMainScreen();
            break;
          case 'Aao':
            targetScreen = AaoHomeMainScreen();
            break;
          case 'Aap':
            targetScreen = AapHomeMainScreen();
            break;
          case 'Aaq':
            targetScreen = AaqHomeMainScreen();
            break;
          case 'Aar':
            targetScreen = AarHomeMainScreen();
            break;
          case 'Aas':
            targetScreen = AasHomeMainScreen();
            break;
          case 'Aat':
            targetScreen = AatHomeMainScreen();
            break;
          case 'Aau':
            targetScreen = AauHomeMainScreen();
            break;
          case 'Aav':
            targetScreen = AavHomeMainScreen();
            break;
          case 'Aaw':
            targetScreen = AawHomeMainScreen();
            break;
          case 'Aax':
            targetScreen = AaxHomeMainScreen();
            break;
          case 'Aay':
            targetScreen = AayHomeMainScreen();
            break;
          case 'Aaz':
            targetScreen = AazHomeMainScreen();
            break;
          case 'Aba':
            targetScreen = AbaHomeMainScreen();
            break;
          case 'Abb':
            targetScreen = AbbHomeMainScreen();
            break;
          case 'Abc':
            targetScreen = AbcHomeMainScreen();
            break;
          case 'Abd':
            targetScreen = AbdHomeMainScreen();
            break;
          default:
          // id에 해당하는 화면이 없는 경우(예외 처리)
            print('지원하지 않는 ID입니다: $id');
            break;
        }

        if (targetScreen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen!),
          );
          print('화면 이동 성공: ${id}HomeMainScreen');
        } else {
          print('화면 이동 실패: ${id}HomeMainScreen');
        }
      },
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        padding: EdgeInsets.zero, // 패딩을 없앰
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          // boxShadow를 통해 하단 그림자 효과를 줌
          boxShadow: [
            BoxShadow(
              color: BLACK_COLOR.withOpacity(0.2), // 그림자 색상 (살짝 어두운 회색)
              offset: Offset(0, 2), // 수직 방향으로 2만큼 아래로 그림자를 이동
              blurRadius: 2, // 그림자 퍼짐 정도
              spreadRadius: 0, // 그림자 확산 정도
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: interval1Y),
            Text(
              name,
              style: TextStyle(
                fontSize: marketBtnTextFontSize,
                fontWeight: FontWeight.bold,
                fontFamily: 'NanumGothic',
                color: BLACK_COLOR, // 텍스트 색상 설정
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
// ------ 메인 홈 화면 내 마켓 버튼 UI 관련 로직인 MarketButtonList 클래스 끝 부분