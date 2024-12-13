// Cupertino 스타일의 위젯을 사용하기 위한 패키지를 임포트합니다. 주로 iOS 스타일의 디자인을 구현할 때 사용합니다.
import 'package:flutter/cupertino.dart';

// Flutter의 기본 디자인과 인터페이스 요소들을 사용하기 위한 Material 패키지를 임포트합니다.
import 'package:flutter/material.dart';

// 상태 관리를 위한 Riverpod 패키지를 임포트합니다. Riverpod는 강력하고 유연한 상태 관리 솔루션을 제공합니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 애플리케이션에서 사용될 색상 상수들을 정의한 파일을 임포트합니다.
import '../../../../../common/const/colors.dart';
import '../../../../../common/layout/common_body_parts_layout.dart';
import '../../../../../product/layout/product_body_parts_layout.dart';
import '../../product/provider/aaa_product_all_providers.dart';
import '../../product/view/main_screen/aaa_blouse_main_screen.dart';
import '../../product/view/main_screen/aaa_cardigan_main_screen.dart';
import '../../product/view/main_screen/aaa_coat_main_screen.dart';
import '../../product/view/main_screen/aaa_jean_main_screen.dart';
import '../../product/view/main_screen/aaa_mtm_main_screen.dart';
import '../../product/view/main_screen/aaa_neat_main_screen.dart';
import '../../product/view/main_screen/aaa_onepiece_main_screen.dart';
import '../../product/view/main_screen/aaa_paeding_main_screen.dart';
import '../../product/view/main_screen/aaa_pants_main_screen.dart';
import '../../product/view/main_screen/aaa_pola_main_screen.dart';
import '../../product/view/main_screen/aaa_shirt_main_screen.dart';
import '../../product/view/main_screen/aaa_skirt_main_screen.dart';


// 홈 카테고리 버튼이 탭되었을 때 호출되는 함수
void aaaOnMidCategoryTap(BuildContext context, WidgetRef ref, int index) {
  final List<Widget> midcategoryPages = [
    // 각 카테고리에 해당하는 페이지 위젯들을 리스트로 정의함.
    AaaShirtMainScreen(),
    AaaBlouseMainScreen(),
    AaaMtmMainScreen(),
    AaaNeatMainScreen(),
    AaaPolaMainScreen(),
    AaaOnepieceMainScreen(),
    AaaPantsMainScreen(),
    AaaJeanMainScreen(),
    AaaSkirtMainScreen(),
    AaaPaedingMainScreen(),
    AaaCoatMainScreen(),
    AaaCardiganMainScreen(),
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

// 상단 탭 바 버튼 관련 섹션을 구현한 위젯 내용 시작
// 신상 섹션을 위젯으로 구현한 부분
// 신상 섹션에서 ProductsSectionList 위젯 사용하여 데이터 UI 구현
Widget aaaBuildNewProductsSection(WidgetRef ref, BuildContext context) {
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
            color: BLACK_COLOR, // 텍스트 색상
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
                    aaaNewProductRepositoryProvider); // aaaNewProductRepositoryProvider를 사용하여 레포지토리를 가져옴
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
Widget aaaBuildBestProductsSection(WidgetRef ref, BuildContext context) {
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
            color: BLACK_COLOR, // 텍스트 색상
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
                    aaaBestProductRepositoryProvider); // aaaBestProductRepositoryProvider를 사용하여 레포지토리를 가져옴
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
Widget aaaBuildSaleProductsSection(WidgetRef ref, BuildContext context) {
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
            color: BLACK_COLOR, // 텍스트 색상
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
                    aaaSaleProductRepositoryProvider); // aaaSaleProductRepositoryProvider를 사용하여 레포지토리를 가져옴
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
Widget aaaBuildSpringProductsSection(WidgetRef ref, BuildContext context) {
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
            color: BLACK_COLOR, // 텍스트 색상
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
                    aaaSpringProductRepositoryProvider); // aaaSpringProductRepositoryProvider를 사용하여 레포지토리를 가져옴
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
Widget aaaBuildSummerProductsSection(WidgetRef ref, BuildContext context) {
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
            color: BLACK_COLOR, // 텍스트 색상
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
                    aaaSummerProductRepositoryProvider); // aaaSummerProductRepositoryProvider를 사용하여 레포지토리를 가져옴
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
Widget aaaBuildAutumnProductsSection(WidgetRef ref, BuildContext context) {
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
            color: BLACK_COLOR, // 텍스트 색상
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
                    aaaAutumnProductRepositoryProvider); // aaaAutumnProductRepositoryProvider를 사용하여 레포지토리를 가져옴
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
Widget aaaBuildWinterProductsSection(WidgetRef ref, BuildContext context) {
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
            color: BLACK_COLOR, // 텍스트 색상
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
                    aaaWinterProductRepositoryProvider); // aaaWinterProductRepositoryProvider를 사용하여 레포지토리를 가져옴
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
