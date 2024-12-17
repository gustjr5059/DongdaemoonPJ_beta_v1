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
import '../../../../home/provider/home_state_provider.dart';
import '../../../../product/view/product_detail_original_image_screen.dart';
import '../../product/layout/aae_product_body_parts_layout.dart';
import '../../product/provider/aae_product_all_providers.dart';
import '../../product/view/main_screen/aae_blouse_main_screen.dart';
import '../../product/view/main_screen/aae_cardigan_main_screen.dart';
import '../../product/view/main_screen/aae_coat_main_screen.dart';
import '../../product/view/main_screen/aae_jean_main_screen.dart';
import '../../product/view/main_screen/aae_mtm_main_screen.dart';
import '../../product/view/main_screen/aae_neat_main_screen.dart';
import '../../product/view/main_screen/aae_onepiece_main_screen.dart';
import '../../product/view/main_screen/aae_paeding_main_screen.dart';
import '../../product/view/main_screen/aae_pants_main_screen.dart';
import '../../product/view/main_screen/aae_pola_main_screen.dart';
import '../../product/view/main_screen/aae_shirt_main_screen.dart';
import '../../product/view/main_screen/aae_skirt_main_screen.dart';
import '../provider/aae_home_state_provider.dart';


// 홈 카테고리 버튼이 탭되었을 때 호출되는 함수
void aaeOnMidCategoryTap(BuildContext context, WidgetRef ref, int index) {
  final List<Widget> midcategoryPages = [
    // 각 카테고리에 해당하는 페이지 위젯들을 리스트로 정의함.
    AaeShirtMainScreen(),
    AaeBlouseMainScreen(),
    AaeMtmMainScreen(),
    AaeNeatMainScreen(),
    AaePolaMainScreen(),
    AaeOnepieceMainScreen(),
    AaePantsMainScreen(),
    AaeJeanMainScreen(),
    AaeSkirtMainScreen(),
    AaePaedingMainScreen(),
    AaeCoatMainScreen(),
    AaeCardiganMainScreen(),
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
Widget aaeBuildNewProductsSection(WidgetRef ref, BuildContext context) {
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
            child: AaeProductsSectionList(
              category: '신상', // '신상' 카테고리를 설정
              fetchProducts: (limit, startAfter) async {
                // 신상품 데이터를 가져오는 비동기 함수를 설정
                final repository = ref.watch(
                    aaeNewProductRepositoryProvider); // aaeNewProductRepositoryProvider를 사용하여 레포지토리를 가져옴
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
Widget aaeBuildBestProductsSection(WidgetRef ref, BuildContext context) {
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
            child: AaeProductsSectionList(
              category: '스테디 셀러', // '스테디 셀러' 카테고리를 설정
              fetchProducts: (limit, startAfter) async {
                // 스테디 셀러 상품 데이터를 가져오는 비동기 함수를 설정
                final repository = ref.watch(
                    aaeBestProductRepositoryProvider); // aaeBestProductRepositoryProvider를 사용하여 레포지토리를 가져옴
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
Widget aaeBuildSaleProductsSection(WidgetRef ref, BuildContext context) {
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
            child: AaeProductsSectionList(
              category: '특가 상품', // '특가 상품' 카테고리를 설정
              fetchProducts: (limit, startAfter) async {
                // 할인 상품 데이터를 가져오는 비동기 함수를 설정
                final repository = ref.watch(
                    aaeSaleProductRepositoryProvider); // aaeSaleProductRepositoryProvider를 사용하여 레포지토리를 가져옴
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
Widget aaeBuildSpringProductsSection(WidgetRef ref, BuildContext context) {
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
            child: AaeProductsSectionList(
              category: '봄', // '봄' 카테고리를 설정
              fetchProducts: (limit, startAfter) async {
                // 봄 상품 데이터를 가져오는 비동기 함수를 설정
                final repository = ref.watch(
                    aaeSpringProductRepositoryProvider); // aaeSpringProductRepositoryProvider를 사용하여 레포지토리를 가져옴
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
Widget aaeBuildSummerProductsSection(WidgetRef ref, BuildContext context) {
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
            child: AaeProductsSectionList(
              category: '여름', // '여름' 카테고리를 설정
              fetchProducts: (limit, startAfter) async {
                // 여름 상품 데이터를 가져오는 비동기 함수를 설정
                final repository = ref.watch(
                    aaeSummerProductRepositoryProvider); // aaeSummerProductRepositoryProvider를 사용하여 레포지토리를 가져옴
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
Widget aaeBuildAutumnProductsSection(WidgetRef ref, BuildContext context) {
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
            child: AaeProductsSectionList(
              category: '가을', // '가을' 카테고리를 설정
              fetchProducts: (limit, startAfter) async {
                // 가을 상품 데이터를 가져오는 비동기 함수를 설정
                final repository = ref.watch(
                    aaeAutumnProductRepositoryProvider); // aaeAutumnProductRepositoryProvider를 사용하여 레포지토리를 가져옴
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
Widget aaeBuildWinterProductsSection(WidgetRef ref, BuildContext context) {
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
            child: AaeProductsSectionList(
              category: '겨을', // '겨을' 카테고리를 설정
              fetchProducts: (limit, startAfter) async {
                // 겨을 상품 데이터를 가져오는 비동기 함수를 설정
                final repository = ref.watch(
                    aaeWinterProductRepositoryProvider); // aaeWinterProductRepositoryProvider를 사용하여 레포지토리를 가져옴
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

// ------- AaeEventPosterImgSectionList 클래스 내용 구현 시작
// 홈 화면 내 이벤트 포스터 이미지 섹션에서 데이터를 4개 단위로 표시하며 스크롤 가능한 UI 구현 관련 클래스
class AaeEventPosterImgSectionList extends ConsumerStatefulWidget {
  // 생성자 선언
  AaeEventPosterImgSectionList();

  @override
  _AaeEventPosterImgSectionListState createState() =>
      _AaeEventPosterImgSectionListState(); // 상태 객체 생성 함수 호출
}

class _AaeEventPosterImgSectionListState
    extends ConsumerState<AaeEventPosterImgSectionList> {
  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러 초기화

  @override
  void initState() {
    super.initState();

    // [변경사항 추가]: 이벤트 섹션 가로 스크롤 위치 복원
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final savedOffset = ref.read(aaeEventPosterScrollPositionProvider);
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(savedOffset);
      }
    });

    _scrollController.addListener(() {
      // 이벤트 섹션 가로 스크롤 offset 저장
      ref.read(aaeEventPosterScrollPositionProvider.notifier).state =
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
Widget aaeBuildEventPosterImgProductsSection(WidgetRef ref, BuildContext context) {
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
            child: AaeEventPosterImgSectionList(), // AaeEventPosterImgSectionList 위젯 사용하여 이벤트 이미지 리스트 표시
          ),
        ),
      ),
    ],
  );
}
// ------ 이벤트 섹션을 위젯으로 구현한 부분 내용 끝