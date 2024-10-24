// Cupertino 스타일의 위젯을 사용하기 위한 패키지를 임포트합니다. 주로 iOS 스타일의 디자인을 구현할 때 사용합니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

// Flutter의 기본 디자인과 인터페이스 요소들을 사용하기 위한 Material 패키지를 임포트합니다.
import 'package:flutter/material.dart';

// 상태 관리를 위한 Riverpod 패키지를 임포트합니다. Riverpod는 강력하고 유연한 상태 관리 솔루션을 제공합니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 애플리케이션에서 사용될 색상 상수들을 정의한 파일을 임포트합니다.
import '../../common/const/colors.dart';

// 공통적으로 사용될 상태 관리 로직을 포함하는 Provider 파일을 임포트합니다.
import '../../common/provider/common_state_provider.dart';

// 제품 카테고리별 메인 화면의 레이아웃을 정의하는 파일을 임포트합니다.
import '../../product/layout/product_body_parts_layout.dart';

// 다양한 의류 카테고리에 대한 메인 화면 파일들을 임포트합니다.
import '../../product/model/product_model.dart';
import '../../product/provider/product_all_providers.dart';
import '../../product/repository/product_repository.dart';
import '../../product/view/main_screen/blouse_main_screen.dart'; // 블라우스 카테고리 메인 화면
import '../../product/view/main_screen/cardigan_main_screen.dart'; // 카디건 카테고리 메인 화면
import '../../product/view/main_screen/coat_main_screen.dart'; // 코트 카테고리 메인 화면
import '../../product/view/main_screen/jean_main_screen.dart'; // 청바지 카테고리 메인 화면
import '../../product/view/main_screen/mtm_main_screen.dart'; // 맨투맨 카테고리 메인 화면
import '../../product/view/main_screen/neat_main_screen.dart'; // 니트 카테고리 메인 화면
import '../../product/view/main_screen/onepiece_main_screen.dart'; // 원피스 카테고리 메인 화면
import '../../product/view/main_screen/paeding_main_screen.dart'; // 패딩 카테고리 메인 화면
import '../../product/view/main_screen/pants_main_screen.dart'; // 바지 카테고리 메인 화면
import '../../product/view/main_screen/pola_main_screen.dart'; // 폴라(터틀넥) 카테고리 메인 화면
import '../../product/view/main_screen/shirt_main_screen.dart'; // 셔츠 카테고리 메인 화면
import '../../product/view/main_screen/skirt_main_screen.dart'; // 스커트 카테고리 메인 화면


// ------ midCategories 부분의 버튼을 화면 크기에 동적으로 한 열당 버튼 갯수를 정해서 열로 정렬하기 위한 클래스 시작
// MidCategoryButtonList 위젯 정의
class MidCategoryButtonList extends ConsumerWidget {
  // 카테고리 버튼 클릭시 실행할 함수를 정의 (이 함수는 BuildContext와 카테고리의 인덱스를 매개변수로 받음)
  final void Function(BuildContext context, WidgetRef ref, int index)
  onCategoryTap;

  // 생성자에서 필수적으로 클릭 이벤트 함수를 받음
  MidCategoryButtonList({Key? key, required this.onCategoryTap})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 선택된 카테고리의 인덱스를 상태 관리 도구에서 가져옴
    final selectedMidCategoryIndex = ref.watch(selectedMidCategoryProvider);
    // 카테고리 확장 상태를 관리하는 상태 변수를 가져옴.
    final boolExpanded =
    ref.watch(midCategoryViewBoolExpandedProvider);

    // 현재 화면의 너비를 MediaQuery를 통해 얻음
    final screenWidth = MediaQuery.of(context).size.width;
    // 화면의 너비에 따라 한 줄에 표시할 카테고리 버튼의 수를 결정
    int midCategoryPerRow = screenWidth > 900
        ? 6
        : screenWidth > 600
        ? 5
        : screenWidth > 300
        ? 4
        : 3;
    // 전체적인 좌우 패딩 값을 설정
    double totalPadding = 16.0;
    // 버튼들 사이의 간격을 설정
    double spacingBetweenButtons = 8.0;
    // 버튼의 너비를 계산 (화면 너비에서 좌우 패딩과 버튼 사이 간격을 제외한 너비를 버튼 수로 나눔)
    double buttonWidth = (screenWidth -
        totalPadding * 2 -
        (midCategoryPerRow - 1) * spacingBetweenButtons) /
        midCategoryPerRow;

    // 지퍼 버튼의 높이 설정 (기기마다의 다른 길이에 맞춰서 모두 구현되도록 재설정)
    final zipperButtonHeight = buttonWidth * 0.9;
    // 전체 카테고리의 행 수를 계산함.
    final rowCount = (midCategories.length / midCategoryPerRow).ceil();
    // 확장 시 카테고리의 전체 줄 높이를 계산함.
    double expandedCategoryRowsHeight = (rowCount * zipperButtonHeight) +
        (rowCount - 1) * spacingBetweenButtons;
    // 축소 시 카테고리의 두 줄 높이를 계산함.
    double compressedCategoryRowsHeight =
        zipperButtonHeight * 2 + spacingBetweenButtons;

    // 카테고리 확장/축소 상태를 토글하는 함수
    void toggleCategoryView() {
      ref.read(midCategoryViewBoolExpandedProvider.notifier).state =
      !boolExpanded;
    }

    // 카테고리 버튼을 포함하는 애니메이션 컨테이너를 반환하고, 이 컨테이너는 확장/축소 시 높이가 변경됨.
    return Column(
      mainAxisSize: MainAxisSize.min, // 카드 안의 내용물 크기에 맞게 최소화
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          // 축소 시, 노출 범위에 들어오지 않는 열의 버튼은 화면에 잘라서 보이지 않도록 하는 위젯
          child: ClipRect(
            // Wrap 위젯을 사용하여 화면 너비에 따라 자동으로 줄바꿈을 처리
            child: Wrap(
              spacing: spacingBetweenButtons, // 버튼 사이의 가로 간격
              runSpacing: spacingBetweenButtons, // 버튼 사이의 세로 간격
              // midCategories 배열의 길이만큼 버튼을 생성
              children: List.generate(midCategories.length, (index) {
                // 각 카테고리의 정보와 인덱스를 이용하여 버튼을 생성하는 함수를 호출
                return buildDetailMidCategoryButton(
                  context: context,
                  index: index,
                  category: midCategories[index],
                  onCategoryTap: onCategoryTap,
                  selectedCategoryIndex: selectedMidCategoryIndex,
                  buttonWidth: buttonWidth,
                  ref: ref, // 상태 관리를 위해 ref 전달
                );
              }),
            ),
          ),
          // 높이 조건을 추가하여 축소 상태일 때는 compressedHeight만큼만 보여줌
          height: boolExpanded
              ? expandedCategoryRowsHeight
              : compressedCategoryRowsHeight,
        ),
        // 지퍼 아이콘(확장/축소 아이콘)을 위한 버튼이며, 클릭 시 카테고리 뷰가 토글됨.
        IconButton(
          iconSize: 30, // 아이콘 크기 설정
          icon: Image.asset(
            boolExpanded
                ? 'asset/img/misc/button_img/expand_button_top.png'
                : 'asset/img/misc/button_img/expand_button_bottom.png',
            // 확장일 때와 축소일 때의 이미지 경로
            width: 30, // 아이콘 너비 설정
            height: 30, // 아이콘 높이 설정
          ),
          onPressed: toggleCategoryView,
        ),
      ],
    );
  }
}
// ------ midCategories 부분의 버튼을 화면 크기에 동적으로 한 열당 버튼 갯수를 정해서 열로 정렬하기 위한 클래스 끝

// buildCommonMidScrollCategoryButtons인 중간 카테고리 버튼 화면에 표시될 카테고리명 변수
final List<String> midCategories = [
  "티셔츠",
  "블라우스",
  "맨투맨",
  "니트",
  "폴라티",
  "원피스",
  "팬츠",
  "청바지",
  "스커트",
  "아우터",
  "코트",
  "가디건"
];

// 카테고리명과 해당하는 이미지 파일명을 매핑하는 변수
final Map<String, String> midCategoryImageMap = {
  "티셔츠": "shirt_button_v1.png",
  "블라우스": "blouse_button_v1.png",
  "맨투맨": "mtm_button_v1.png",
  "니트": "neat_button_v1.png",
  "폴라티": "pola_button_v1.png",
  "원피스": "onepiece_button_v1.png",
  "팬츠": "pants_button_v1.png",
  "청바지": "jean_button_v1.png",
  "스커트": "skirt_button_v1.png",
  "아우터": "paeding_button_v1.png",
  "코트": "coat_button_v1.png",
  "가디건": "cardigan_button_v1.png"
};

// 홈 카테고리 버튼이 탭되었을 때 호출되는 함수
void onMidCategoryTap(BuildContext context, WidgetRef ref, int index) {
  final List<Widget> midcategoryPages = [
    // 각 카테고리에 해당하는 페이지 위젯들을 리스트로 정의함.
    ShirtMainScreen(),
    BlouseMainScreen(),
    MtmMainScreen(),
    NeatMainScreen(),
    PolaMainScreen(),
    OnepieceMainScreen(),
    PantsMainScreen(),
    JeanMainScreen(),
    SkirtMainScreen(),
    PaedingMainScreen(),
    CoatMainScreen(),
    CardiganMainScreen(),
  ];
  // 네비게이터를 사용하여, 사용자가 선택한 카테고리에 해당하는 페이지로 화면을 전환함.
  // 여기서는 MaterialApp의 Navigator 기능을 사용하여 새로운 페이지로 이동함.
  Navigator.push(
      context, // 현재 컨텍스트
      MaterialPageRoute(
          builder: (context) =>
              midcategoryPages[index]) // 선택된 카테고리에 해당하는 페이지로의 루트를 생성함.
      ).then((_) {
    // 페이지 이동 후 카테고리 버튼 열 노출 관련 상태를 초기화함.
    resetCategoryView(ref);
  });
}

// 페이지 전환 시 카테고리 버튼 열 노출 관련 뷰를 항상 축소된 상태로 초기화하는 함수
void resetCategoryView(WidgetRef ref) {
  ref.read(midCategoryViewBoolExpandedProvider.notifier).state = false;
}

// ------ buildDetailMidCategoryButton 위젯 내용 시작
// 각 카테고리 버튼을 생성하는 위젯
Widget buildDetailMidCategoryButton({
  required BuildContext context, // 위젯 빌드에 필요한 컨텍스트
  required int index, // 카테고리의 인덱스
  required String category, // 카테고리 이름
  required void Function(BuildContext, WidgetRef, int)
      onCategoryTap, // 카테고리 탭 시 실행될 함수
  required int? selectedCategoryIndex, // 선택된 카테고리 인덱스
  required double buttonWidth, // 버튼의 너비
  required WidgetRef ref, // 상태 관리를 위한 WidgetRef 매개변수
}) {
  // 카테고리 이름을 기반으로 영어로 된 이미지 파일명을 찾아서 imageAsset 경로에 설정함.
  String imageAsset =
      'asset/img/misc/button_img/${midCategoryImageMap[category]}'; // 해당 카테고리에 매핑된 이미지 파일의 경로.

  return GestureDetector(
    onTap: () {
      onCategoryTap(context, ref, index); // 해당 카테고리를 탭했을 때 실행할 함수 호출
      ref.read(midCategoryViewBoolExpandedProvider.notifier).state =
          false; // 홈 화면 내 카테고리 버튼 뷰 확장 상태 관련 provider를 초기화
    },
    child: Container(
      width: buttonWidth, // 매개변수로 받은 너비를 사용
      padding: EdgeInsets.all(5.0), // 모든 방향에 5.0의 패딩 설정
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
        // 카드뷰 배경 색상 : 앱 기본 배경색
        // borderRadius: BorderRadius.circular(20), // 테두리를 둥글게 처리
        // border: Border.all(color: GOLD_COLOR, width: 2), // 선택 상태에 따라 테두리 색상 변경
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 컬럼 내부의 아이템들을 중앙에 위치시킴.
        children: <Widget>[
          AspectRatio(
            // 이미지의 원본 비율을 유지하는 AspectRatio 위젯 사용
            aspectRatio: 1.8, // 너비와 높이의 비율을 1.8:1로 설정
            child: Image.asset(imageAsset, fit: BoxFit.contain), // 이미지 파일을 보여줌
          ),
          SizedBox(height: 8), // 이미지와 텍스트 사이의 공간을 8로 설정함.
          Text(
            category, // 카테고리 이름 표시
            style: TextStyle(
              color: Colors.black, // 텍스트 색상
              fontSize: 10, // 텍스트 크기
              fontFamily: 'NanumGothic',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center, // 텍스트를 중앙 정
          ),
        ],
      ),
    ),
  );
}
// ------ buildDetailMidCategoryButton 위젯 내용 끝
// ------ 카테고리 12개를 버튼 형식의 두줄로 표시한 부분 관련 위젯 구현 내용 끝

// 상단 탭 바 버튼 관련 섹션을 구현한 위젯 내용 시작
// 신상 섹션을 위젯으로 구현한 부분
// 신상 섹션에서 ProductsSectionList 위젯 사용하여 데이터 UI 구현
Widget buildNewProductsSection(WidgetRef ref, BuildContext context) {
  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정
  // 신상 섹션 내 요소들의 수치
  final double SectionX =
      screenSize.width * (16 / referenceWidth); // 왼쪽 여백 비율
  final double SectionY =
      screenSize.height * (8 / referenceHeight);
  final double SectionTextFontSize =
      screenSize.height * (20 / referenceHeight);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: SectionX),
        child: Text(
          '신상', // 섹션 제목을 '신상'으로 설정
          style: TextStyle(
              color: Colors.black, // 텍스트 색상
              fontSize: SectionTextFontSize, // 텍스트 크기
              fontFamily: 'NanumGothic',
              fontWeight: FontWeight.bold,
              ),
        ),
      ),
      SizedBox(height: SectionY), // 제목과 리스트 사이에 간격 추가
      Padding(
        padding: EdgeInsets.only(left: SectionX),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), // 모서리 반경을 10으로 설정
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
              ),
              child: ProductsSectionList(
                category: '신상', // '신상' 카테고리를 설정
                fetchProducts: (limit, startAfter) async {
                  // 신상품 데이터를 가져오는 비동기 함수를 설정
                  final repository = ref.watch(
                      newProductRepositoryProvider); // newProductRepositoryProvider를 사용하여 레포지토리를 가져옴
                  return await repository.fetchNewProductContents(
                      limit: limit); // 레포지토리에서 신상품 데이터를 가져옴
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

// 최고 섹션을 위젯으로 구현한 부분
// 최고 섹션에서 ProductsSectionList 위젯 사용하여 데이터 UI 구현
Widget buildBestProductsSection(WidgetRef ref, BuildContext context) {
  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정
  // 신상 섹션 내 요소들의 수치
  final double SectionX =
      screenSize.width * (16 / referenceWidth); // 왼쪽 여백 비율
  final double SectionY =
      screenSize.height * (8 / referenceHeight);
  final double SectionTextFontSize =
      screenSize.height * (20 / referenceHeight);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: SectionX),
        child: Text(
          '스테디 셀러', // 섹션 제목을 '최고'로 설정
          style: TextStyle(
            color: Colors.black, // 텍스트 색상
            fontSize: SectionTextFontSize, // 텍스트 크기
            fontFamily: 'NanumGothic',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(height: SectionY), // 제목과 리스트 사이에 간격 추가
      Padding(
        padding: EdgeInsets.only(left: SectionX),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), // 모서리 반경을 10으로 설정
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
            ),
            child: ProductsSectionList(
              category: '스테디 셀러', // '스테디 셀러' 카테고리를 설정
              fetchProducts: (limit, startAfter) async {
                // 스테디 셀러 상품 데이터를 가져오는 비동기 함수를 설정
                final repository = ref.watch(
                    bestProductRepositoryProvider); // bestProductRepositoryProvider를 사용하여 레포지토리를 가져옴
                return await repository.fetchBestProductContents(
                    limit: limit); // 레포지토리에서 최고 상품 데이터를 가져옴
              },
            ),
          ),
        ),
      ),
    ],
  );
}

// 특가 상품 섹션을 위젯으로 구현한 부분
// 특가 상품 섹션에서 ProductsSectionList 위젯 사용하여 데이터 UI 구현
Widget buildSaleProductsSection(WidgetRef ref, BuildContext context) {
  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정
  // 신상 섹션 내 요소들의 수치
  final double SectionX =
      screenSize.width * (16 / referenceWidth); // 왼쪽 여백 비율
  final double SectionY =
      screenSize.height * (8 / referenceHeight);
  final double SectionTextFontSize =
      screenSize.height * (20 / referenceHeight);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: SectionX),
        child: Text(
          '특가 상품', // 섹션 제목을 '특가 상품'으로 설정
          style: TextStyle(
            color: Colors.black, // 텍스트 색상
            fontSize: SectionTextFontSize, // 텍스트 크기
            fontFamily: 'NanumGothic',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(height: SectionY), // 제목과 리스트 사이에 간격 추가
      Padding(
        padding: EdgeInsets.only(left: SectionX),
        child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // 모서리 반경을 10으로 설정
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
            ),
            child: ProductsSectionList(
              category: '특가 상품', // '특가 상품' 카테고리를 설정
              fetchProducts: (limit, startAfter) async {
                // 할인 상품 데이터를 가져오는 비동기 함수를 설정
                final repository = ref.watch(
                    saleProductRepositoryProvider); // saleProductRepositoryProvider를 사용하여 레포지토리를 가져옴
                return await repository.fetchSaleProductContents(
                    limit: limit); // 레포지토리에서 할인 상품 데이터를 가져옴
              },
            ),
          ),
        ),
      ),
    ],
  );
}

// 봄 섹션을 위젯으로 구현한 부분
// 봄 섹션에서 ProductsSectionList 위젯 사용하여 데이터 UI 구현
Widget buildSpringProductsSection(WidgetRef ref, BuildContext context) {
  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정
  // 신상 섹션 내 요소들의 수치
  final double SectionX =
      screenSize.width * (16 / referenceWidth); // 왼쪽 여백 비율
  final double SectionY =
      screenSize.height * (8 / referenceHeight);
  final double SectionTextFontSize =
      screenSize.height * (20 / referenceHeight);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: SectionX),
        child: Text(
          '봄', // 섹션 제목을 '봄'으로 설정
          style: TextStyle(
            color: Colors.black, // 텍스트 색상
            fontSize: SectionTextFontSize, // 텍스트 크기
            fontFamily: 'NanumGothic',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(height: SectionY), // 제목과 리스트 사이에 간격 추가
      Padding(
        padding: EdgeInsets.only(left: SectionX),
        child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // 모서리 반경을 10으로 설정
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
            ),
            child: ProductsSectionList(
              category: '봄', // '봄' 카테고리를 설정
              fetchProducts: (limit, startAfter) async {
                // 봄 상품 데이터를 가져오는 비동기 함수를 설정
                final repository = ref.watch(
                    springProductRepositoryProvider); // springProductRepositoryProvider를 사용하여 레포지토리를 가져옴
                return await repository.fetchSpringProductContents(
                    limit: limit); // 레포지토리에서 봄 상품 데이터를 가져옴
              },
            ),
          ),
        ),
      ),
    ],
  );
}

// 여름 섹션을 위젯으로 구현한 부분
// 여름 섹션에서 ProductsSectionList 위젯 사용하여 데이터 UI 구현
Widget buildSummerProductsSection(WidgetRef ref, BuildContext context) {
  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정
  // 신상 섹션 내 요소들의 수치
  final double SectionX =
      screenSize.width * (16 / referenceWidth); // 왼쪽 여백 비율
  final double SectionY =
      screenSize.height * (8 / referenceHeight);
  final double SectionTextFontSize =
      screenSize.height * (20 / referenceHeight);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: SectionX),
        child: Text(
          '여름', // 섹션 제목을 '여름'으로 설정
          style: TextStyle(
            color: Colors.black, // 텍스트 색상
            fontSize: SectionTextFontSize, // 텍스트 크기
            fontFamily: 'NanumGothic',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(height: SectionY), // 제목과 리스트 사이에 간격 추가
      Padding(
        padding: EdgeInsets.only(left: SectionX),
        child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // 모서리 반경을 10으로 설정
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
            ),
            child: ProductsSectionList(
              category: '여름', // '여름' 카테고리를 설정
              fetchProducts: (limit, startAfter) async {
                // 여름 상품 데이터를 가져오는 비동기 함수를 설정
                final repository = ref.watch(
                    summerProductRepositoryProvider); // summerProductRepositoryProvider를 사용하여 레포지토리를 가져옴
                return await repository.fetchSummerProductContents(
                    limit: limit); // 레포지토리에서 여름 상품 데이터를 가져옴
              },
            ),
          ),
        ),
      ),
     ],
  );
}

// 가을 섹션을 위젯으로 구현한 부분
// 가을 섹션에서 ProductsSectionList 위젯 사용하여 데이터 UI 구현
Widget buildAutumnProductsSection(WidgetRef ref, BuildContext context) {
  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정
  // 신상 섹션 내 요소들의 수치
  final double SectionX =
      screenSize.width * (16 / referenceWidth); // 왼쪽 여백 비율
  final double SectionY =
      screenSize.height * (8 / referenceHeight);
  final double SectionTextFontSize =
      screenSize.height * (20 / referenceHeight);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: SectionX),
        child: Text(
          '가을', // 섹션 제목을 '가을'로 설정
          style: TextStyle(
            color: Colors.black, // 텍스트 색상
            fontSize: SectionTextFontSize, // 텍스트 크기
            fontFamily: 'NanumGothic',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(height: SectionY), // 제목과 리스트 사이에 간격 추가
      Padding(
        padding: EdgeInsets.only(left: SectionX),
        child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // 모서리 반경을 10으로 설정
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
            ),
            child: ProductsSectionList(
              category: '가을', // '가을' 카테고리를 설정
              fetchProducts: (limit, startAfter) async {
                // 가을 상품 데이터를 가져오는 비동기 함수를 설정
                final repository = ref.watch(
                    autumnProductRepositoryProvider); // autumnProductRepositoryProvider를 사용하여 레포지토리를 가져옴
                return await repository.fetchAutumnProductContents(
                    limit: limit); // 레포지토리에서 가을 상품 데이터를 가져옴
              },
            ),
          ),
        ),
      ),
    ],
  );
}

// 겨울 섹션을 위젯으로 구현한 부분
// 겨울 섹션에서 ProductsSectionList 위젯 사용하여 데이터 UI 구현
Widget buildWinterProductsSection(WidgetRef ref, BuildContext context) {
  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정
  // 신상 섹션 내 요소들의 수치
  final double SectionX =
      screenSize.width * (16 / referenceWidth); // 왼쪽 여백 비율
  final double SectionY =
      screenSize.height * (8 / referenceHeight);
  final double SectionTextFontSize =
      screenSize.height * (20 / referenceHeight);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: SectionX),
        child: Text(
          '겨울', // 섹션 제목을 '겨울'로 설정
          style: TextStyle(
            color: Colors.black, // 텍스트 색상
            fontSize: SectionTextFontSize, // 텍스트 크기
            fontFamily: 'NanumGothic',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(height: SectionY), // 제목과 리스트 사이에 간격 추가
      Padding(
        padding: EdgeInsets.only(left: SectionX),
        child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // 모서리 반경을 10으로 설정
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
            ),
            child: ProductsSectionList(
              category: '겨을', // '겨을' 카테고리를 설정
              fetchProducts: (limit, startAfter) async {
                // 겨을 상품 데이터를 가져오는 비동기 함수를 설정
                final repository = ref.watch(
                    winterProductRepositoryProvider); // winterProductRepositoryProvider를 사용하여 레포지토리를 가져옴
                return await repository.fetchWinterProductContents(
                    limit: limit); // 레포지토리에서 겨을 상품 데이터를 가져옴
              },
            ),
          ),
        ),
      ),
    ],
  );
}
// 상단 탭 바 버튼 관련 섹션을 구현한 위젯 내용 끝
