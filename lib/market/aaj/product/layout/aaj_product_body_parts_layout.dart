
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/const/colors.dart';
import '../../../../common/layout/common_body_parts_layout.dart';
import '../../../../product/layout/product_body_parts_layout.dart';
import '../../../../product/model/product_model.dart';
import '../../home/provider/aaj_home_state_provider.dart';
import '../provider/aaj_product_state_provider.dart';


// ------- AajProductsSectionList 클래스 내용 구현 시작
// 주로, 홈 화면 내 2차 카테고리별 섹션 내 데이터를 4개 단위로 스크롤뷰로 UI 구현하는 부분 관련 로직
class AajProductsSectionList extends ConsumerStatefulWidget {
  final String category; // 카테고리 이름을 저장하는 필드
  final Future<List<ProductContent>> Function(
      int limit, DocumentSnapshot? startAfter) fetchProducts; // 제품을 가져오는 비동기 함수

  // 생성자
  AajProductsSectionList({required this.category, required this.fetchProducts});

  @override
  _AajProductsSectionListState createState() =>
      _AajProductsSectionListState(); // 상태 객체 생성
}

class _AajProductsSectionListState extends ConsumerState<AajProductsSectionList> {
  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러 초기화
  bool _isFetching = false; // 데이터 가져오는 중인지 확인하는 플래그
  DocumentSnapshot? _lastDocument; // 마지막 문서 스냅샷 저장

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener); // 스크롤 리스너 추가
    // 이미 저장된 홈 화면 내 섹션 데이터를 로드
    final savedProducts = ref
        .read(aajHomeSectionDataStateProvider.notifier)
        .getSectionProducts(widget.category);
    if (savedProducts.isNotEmpty) {
      setState(() {
        _lastDocument = savedProducts.last.documentSnapshot; // 마지막 문서 스냅샷 업데이트
      });
    } else {
      _fetchInitialProducts(); // 초기 데이터를 가져오는 함수 호출
    }

    // 저장된 홈 화면 내 섹션 스크롤 위치를 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // _scrollController가 뷰에 attach되었는지 확인
        final savedScrollPosition =
            ref.read(aajHomeSectionScrollPositionsProvider)[widget.category] ?? 0;
        _scrollController.jumpTo(savedScrollPosition); // 스크롤 위치 설정
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener); // 스크롤 리스너 제거
    _scrollController.dispose(); // 스크롤 컨트롤러 해제
    super.dispose();
  }

  // 스크롤 리스너 함수
  void _scrollListener() {
    // 스크롤이 끝에 도달하고 데이터를 가져오는 중이 아닐 때
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !_isFetching) {
      _fetchMoreProducts(); // 추가 제품 데이터 가져오기 호출
    }

    // 현재 홈 화면 내 섹션 스크롤 위치를 저장
    ref.read(aajHomeSectionScrollPositionsProvider.notifier).state = {
      ...ref.read(aajHomeSectionScrollPositionsProvider),
      widget.category: _scrollController.position.pixels,
    };
  }

  // 초기 제품 데이터를 가져오는 함수
  Future<void> _fetchInitialProducts() async {
    setState(() {
      _isFetching = true; // 데이터 가져오는 중 상태로 설정
    });
    try {
      final products = await widget.fetchProducts(4, null); // 초기 4개 제품 데이터 가져오기
      setState(() {
        ref
            .read(aajHomeSectionDataStateProvider.notifier)
            .updateSection(widget.category, products); // 섹션 내 제품 데이터 상태 업데이트
        if (products.isNotEmpty) {
          _lastDocument = products.last.documentSnapshot; // 마지막 문서 스냅샷 업데이트
        }
      });
    } catch (e) {
      debugPrint('초기 상품 데이터를 가져오는 중 오류 발생: $e'); // 에러 출력
    } finally {
      setState(() {
        _isFetching = false; // 데이터 가져오기 완료 상태로 설정
      });
    }
  }

  // 추가 제품 데이터를 가져오는 함수
  Future<void> _fetchMoreProducts() async {
    if (_isFetching) return; // 이미 데이터를 가져오는 중이면 반환
    setState(() {
      _isFetching = true; // 데이터 가져오는 중 상태로 설정
    });
    try {
      final products =
      await widget.fetchProducts(4, _lastDocument); // 추가 4개 제품 데이터 가져오기
      setState(() {
        final currentProducts = ref
            .read(aajHomeSectionDataStateProvider.notifier)
            .getSectionProducts(widget.category); // 현재 섹션 내 제품 리스트 가져오기
        final updatedProducts =
            currentProducts + products; // 새로운 섹션 내 제품 리스트와 병합
        ref.read(aajHomeSectionDataStateProvider.notifier).updateSection(
            widget.category, updatedProducts); // 섹션 내 제품 데이터 상태 업데이트
        if (products.isNotEmpty) {
          _lastDocument = products.last.documentSnapshot; // 마지막 문서 스냅샷 업데이트
        }
      });
    } catch (e) {
      debugPrint('추가 상품 데이터를 가져오는 중 오류 발생: $e'); // 에러 출력
    } finally {
      setState(() {
        _isFetching = false; // 데이터 가져오기 완료 상태로 설정
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(aajHomeSectionDataStateProvider)[widget.category] ??
        []; // 현재 카테고리의 제품 리스트 가져오기
    return Column(
      children: [
        // 데이터를 불러옲 때 로딩되고 있는 경우
        if (_isFetching) buildCommonLoadingIndicator(), // 로딩 중일 때 로딩 인디케이터 표시
        // 데이터가 있어서 불러온 경우
        if (products.isNotEmpty)
          buildHorizontalDocumentsList(
              ref, products, context, widget.category, _scrollController),
        // 데이터가 없는 경우
        if (products.isEmpty && !_isFetching)
          SizedBox.shrink(), // 데이터가 없을 때 아무것도 표시하지 않음
      ],
    );
  }
}
// ------- AajProductsSectionList 클래스 내용 구현 끝

// ------ 가격 순, 할인율 순 관련 분류가능하도록 하는 버튼인 AajPriceAndDiscountPercentSortButtons 클래스 내용 구현 시작
class AajPriceAndDiscountPercentSortButtons<T extends AajBaseProductListNotifier>
    extends ConsumerWidget {
  // StateNotifierProvider와 StateProvider를 필드로 선언
  final StateNotifierProvider<T, List<ProductContent>> productListProvider;
  final StateProvider<String> sortButtonProvider;

  // 생성자: 필수 인자 productListProvider와 sortButtonProvider를 받아서 초기화
  AajPriceAndDiscountPercentSortButtons({
    required this.productListProvider,
    required this.sortButtonProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정
    // sortBtn 관련 수치 동적 적용
    final double sortBtnX = screenSize.width * (8 / referenceWidth);
    final double sortBtneY = screenSize.height * (4 / referenceHeight);

    // 현재 선택된 정렬 타입을 감시
    final selectedSortType = ref.watch(sortButtonProvider);
    // print("현재 정렬 상태: $selectedSortType");
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sortBtnX, vertical: sortBtneY),
      // 좌우 및 상하 패딩 설정
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // 자식 위젯 사이의 공간을 고르게 분배
        children: [
          _buildExpandedSortButton(context, '가격 높은 순', ref, selectedSortType),
          // 가격 높은 순 버튼 생성
          _buildExpandedSortButton(context, '가격 낮은 순', ref, selectedSortType),
          // 가격 낮은 순 버튼 생성
          _buildExpandedSortButton(context, '할인율 높은 순', ref, selectedSortType),
          // 할인율 높은 순 버튼 생성
          _buildExpandedSortButton(context, '할인율 낮은 순', ref, selectedSortType),
          // 할인율 낮은 순 버튼 생성
        ],
      ),
    );
  }

  // 버튼 세부 내용인 _buildExpandedSortButton 위젯
  Widget _buildExpandedSortButton(BuildContext context, String title,
      WidgetRef ref, String selectedSortType) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정
    // sortBtn 관련 수치 동적 적용
    final double sortBtn1X = screenSize.width * (4 / referenceWidth);
    final double sortBtn2X = screenSize.width * (8 / referenceWidth);
    final double sortBtnTextFontSize =
        screenSize.height * (12 / referenceHeight);

    // 현재 버튼이 선택된 상태인지 여부를 결정
    final bool isSelected = selectedSortType == title;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sortBtn1X), // 좌우 패딩 설정
        child: ElevatedButton(
          onPressed: () {
            ref.read(sortButtonProvider.notifier).state =
                title; // 버튼 클릭 시 정렬 상태 업데이트
            ref.read(productListProvider.notifier).sortType =
                title; // 상품 데이터 정렬 상태 업데이트
            // print("정렬 버튼 클릭: $title");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? ORANGE56_COLOR : GRAY79_COLOR,
            // 선택된 버튼 배경 색상 설정
            minimumSize: Size(0, 40),
            // 최소 버튼 크기 설정
            padding: EdgeInsets.symmetric(horizontal: sortBtn2X), // 버튼 내 패딩 설정
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(67),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown, // 텍스트 크기를 버튼 크기에 맞게 조절
            child: Text(
              title,
              textAlign: TextAlign.center, // 텍스트 가운데 정렬
              style: TextStyle(
                fontSize: sortBtnTextFontSize,
                color: WHITE_COLOR,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.w800, // ExtraBold
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// ------ 가격 순, 할인율 순 관련 분류가능하도록 하는 버튼인 AajPriceAndDiscountPercentSortButtons 클래스 내용 구현 끝

// ------- provider로부터 데이터 받아와서 UI에 구현하는 3개씩 열로 데이터를 보여주는 UI 구현 관련
// AajGeneralProductList 클래스 내용 구현 시작
// 1차 카테고리 관련 메인 화면과 섹션 더보기 화면에서 데이터를 불러올 때 사용하는 UI 구현 부분
class AajGeneralProductList<T extends AajBaseProductListNotifier>
    extends ConsumerStatefulWidget {
  final ScrollController scrollController; // 스크롤 컨트롤러 선언
  final StateNotifierProvider<T, List<ProductContent>>
  productListProvider; // 제품 목록 provider 선언
  final String category; // 카테고리 선언

  AajGeneralProductList({
    required this.scrollController,
    required this.productListProvider,
    required this.category,
  }); // 생성자 정의

  @override
  _ProductListState createState() => _ProductListState(); // 상태 생성 메소드 정의
}

class _ProductListState extends ConsumerState<AajGeneralProductList> {
  @override
  void initState() {
    super.initState(); // 부모 클래스의 initState 호출
    widget.scrollController.addListener(_scrollListener); // 스크롤 리스너 추가
    // 위젯이 완전히 빌드된 후에 초기 데이터 로드 작업을 수행하기 위해 Future.delayed(Duration.zero)를 사용
    Future.delayed(Duration.zero, () {
      if (ref.read(widget.productListProvider).isEmpty) {
        // 제품 목록이 비어있다면
        ref
            .read(widget.productListProvider.notifier)
            .fetchInitialProducts(widget.category); // 초기 제품 가져오기 호출
      }
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener); // 스크롤 리스너 제거
    super.dispose(); // 부모 클래스의 dispose 호출
  }

  // 스크롤 리스너 함수
  void _scrollListener() {
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent - 200) {
      // 스크롤이 끝에 가까워지면
      ref
          .read(widget.productListProvider.notifier)
          .fetchMoreProducts(widget.category); // 더 많은 제품 가져오기 호출
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(widget.productListProvider); // 제품 목록 상태 감시
    final isFetching = ref.watch(widget.productListProvider.notifier
        .select((notifier) => notifier.isFetching)); // 가져오는 중인지 상태 감시

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    final double interval1X = screenSize.width * (8 / referenceWidth);
    final double interval1Y = screenSize.height * (8 / referenceHeight);
    final double interval2Y = screenSize.height * (10 / referenceHeight);

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          // 높이 제한
          physics: NeverScrollableScrollPhysics(),
          // 스크롤 비활성화
          padding: EdgeInsets.symmetric(vertical: interval2Y),
          // 상하 패딩 설정
          itemCount: (products.length / 3).ceil(),
          // 행의 개수 계산
          itemBuilder: (context, index) {
            int startIndex = index * 3; // 시작 인덱스 계산
            int endIndex = startIndex + 3; // 끝 인덱스 계산
            if (endIndex > products.length) {
              // 끝 인덱스가 제품 개수보다 많으면
              endIndex = products.length; // 끝 인덱스를 제품 개수로 조정
            }
            List<ProductContent> productRow =
            products.sublist(startIndex, endIndex); // 행에 들어갈 제품들 추출
            return buildGeneralProductRow(
                ref, productRow, context); // 행 빌드 함수 호출
          },
        ),
        if (isFetching) // 가져오는 중이라면
          Padding(
              padding: EdgeInsets.symmetric(
                  vertical: interval1Y, horizontal: interval1X),
              child: buildCommonLoadingIndicator() // 로딩 표시
          ),
      ],
    );
  }
}
// ------- provider로부터 데이터 받아와서 UI에 구현하는 3개씩 열로 데이터를 보여주는 UI 구현 관련
// GeneralProductList 클래스 내용 구현 끝

// ------- 데이터를 열로 나열하는 UI 구현 관련 buildGeneralProductRow 위젯 내용 구현 시작
Widget buildGeneralProductRow(
    WidgetRef ref, List<ProductContent> products, BuildContext context) {
  final productInfo =
  ProductInfoDetailScreenNavigation(ref); // 제품 정보 상세 화면 내비게이션 객체 생성

  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  final double interval1X = screenSize.width * (2 / referenceWidth);
  final double interval1Y = screenSize.height * (2 / referenceHeight);

  final itemWidth =
      (screenSize.width / 3) - interval1X; // 아이템 너비 설정 (3개가 들어가도록 계산)

  return Row(
    // mainAxisAlignment: MainAxisAlignment.spaceAround, // 아이템을 수평 중앙 정렬
    children: products.map((product) {
      return SizedBox(
        width: itemWidth, // 아이템의 너비를 설정
        // 각 제품을 확장된 위젯으로 변환
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: interval1Y), // 패딩 설정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬 설정
            children: [
              productInfo.buildProdFirestoreDetailDocument(
                  context, product, ref),
              // 제품 정보 상세 화면 빌드 함수 호출
            ],
          ),
        ),
      );
    }).toList(), // 리스트로 변환
  );
}
// ------- 데이터를 열로 나열하는 UI 구현 관련 buildGeneralProductRow 위젯 내용 구현 끝
