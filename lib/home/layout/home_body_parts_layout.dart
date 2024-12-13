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
import '../../market/aaa/home/view/aaa_home_screen.dart';

import '../provider/home_state_provider.dart';


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
      return Center(child: CircularProgressIndicator());
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
          // case 'Aab':
          //   targetScreen = AabHomeMainScreen();
          //   break;
          // case 'Aac':
          //   targetScreen = AacHomeMainScreen();
          //   break;
          // case 'Aad':
          //   targetScreen = AadHomeMainScreen();
          //   break;
          // case 'Aae':
          //   targetScreen = AaeHomeMainScreen();
          //   break;
          // case 'Aaf':
          //   targetScreen = AafHomeMainScreen();
          //   break;
          // case 'Aag':
          //   targetScreen = AagHomeMainScreen();
          //   break;
          // case 'Aah':
          //   targetScreen = AahHomeMainScreen();
          //   break;
          // case 'Aai':
          //   targetScreen = AaiHomeMainScreen();
          //   break;
          // case 'Aaj':
          //   targetScreen = AajHomeMainScreen();
          //   break;
          // case 'Aak':
          //   targetScreen = AakHomeMainScreen();
          //   break;
          // case 'Aal':
          //   targetScreen = AalHomeMainScreen();
          //   break;
          // case 'Aam':
          //   targetScreen = AamHomeMainScreen();
          //   break;
          // case 'Aan':
          //   targetScreen = AanHomeMainScreen();
          //   break;
          // case 'Aao':
          //   targetScreen = AaoHomeMainScreen();
          //   break;
          // case 'Aap':
          //   targetScreen = AapHomeMainScreen();
          //   break;
          // case 'Aaq':
          //   targetScreen = AaqHomeMainScreen();
          //   break;
          // case 'Aar':
          //   targetScreen = AarHomeMainScreen();
          //   break;
          // case 'Aas':
          //   targetScreen = AasHomeMainScreen();
          //   break;
          // case 'Aat':
          //   targetScreen = AatHomeMainScreen();
          //   break;
          // case 'Aau':
          //   targetScreen = AauHomeMainScreen();
          //   break;
          // case 'Aav':
          //   targetScreen = AavHomeMainScreen();
          //   break;
          // case 'Aaw':
          //   targetScreen = AawHomeMainScreen();
          //   break;
          // case 'Aax':
          //   targetScreen = AaxHomeMainScreen();
          //   break;
          // case 'Aay':
          //   targetScreen = AayHomeMainScreen();
          //   break;
          // case 'Aaz':
          //   targetScreen = AazHomeMainScreen();
          //   break;
          // case 'Aba':
          //   targetScreen = AbaHomeMainScreen();
          //   break;
          // case 'Abb':
          //   targetScreen = AbbHomeMainScreen();
          //   break;
          // case 'Abc':
          //   targetScreen = AbcHomeMainScreen();
          //   break;
          // case 'Abd':
          //   targetScreen = AbdHomeMainScreen();
          //   break;
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