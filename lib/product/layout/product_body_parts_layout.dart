
// iOS 스타일의 인터페이스 요소를 사용하기 위해 Cupertino 디자인 패키지를 임포트합니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
// Android 및 기본 플랫폼 스타일의 인터페이스 요소를 사용하기 위해 Material 디자인 패키지를 임포트합니다.
import 'package:flutter/material.dart';
// 상태 관리를 위해 사용되는 Riverpod 패키지를 임포트합니다.
// Riverpod는 애플리케이션의 다양한 상태를 관리하는 데 도움을 주는 강력한 도구입니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// 애플리케이션에서 사용할 색상 상수들을 정의한 파일을 임포트합니다.
import '../../common/const/colors.dart';
// 제품 데이터 모델을 정의한 파일을 임포트합니다.
// 이 모델은 제품의 속성을 정의하고, 애플리케이션에서 제품 데이터를 구조화하는 데 사용됩니다.
import '../../home/provider/home_state_provider.dart';
import '../model/product_model.dart';
// 제품 데이터를 비동기적으로 가져오기 위한 FutureProvider 파일을 임포트합니다.
import '../provider/product_future_provider.dart';
// 제품 상태 관리를 위한 StateProvider 파일을 임포트합니다.
import '../provider/product_state_provider.dart';
// 각 의류 카테고리에 대한 상세 화면 구현 파일들을 임포트합니다.
// 이 파일들은 각 카테고리별 제품의 상세 정보를 표시하는 화면을 정의합니다.
import '../view/detail_screen/blouse_detail_screen.dart'; // 블라우스 상세 화면
import '../view/detail_screen/cardigan_detail_screen.dart'; // 가디건 상세 화면
import '../view/detail_screen/coat_detail_screen.dart'; // 코트 상세 화면
import '../view/detail_screen/jean_detail_screen.dart'; // 청바지 상세 화면
import '../view/detail_screen/mtm_detail_screen.dart'; // 맨투맨 상세 화면
import '../view/detail_screen/neat_detail_screen.dart'; // 니트 상세 화면
import '../view/detail_screen/onepiece_detail_screen.dart'; // 원피스 상세 화면
import '../view/detail_screen/paeding_detail_screen.dart'; // 패딩 상세 화면
import '../view/detail_screen/pants_detail_screen.dart'; // 바지 상세 화면
import '../view/detail_screen/pola_detail_screen.dart'; // 폴라(터틀넥) 상세 화면
import '../view/detail_screen/shirt_detail_screen.dart'; // 셔츠 상세 화면
import '../view/detail_screen/skirt_detail_screen.dart'; // 스커트 상세 화면


// ------ pageViewWithArrows 위젯 내용 구현 시작
// PageView와 화살표 버튼을 포함하는 위젯
// 사용자가 페이지를 넘길 수 있도록 함.
Widget pageViewWithArrows(
    BuildContext context,
    PageController pageController, // 페이지 전환을 위한 컨트롤러
    WidgetRef ref, // Riverpod 상태 관리를 위한 ref
    StateProvider<int> currentPageProvider, { // 현재 페이지 인덱스를 관리하기 위한 StateProvider
      required IndexedWidgetBuilder itemBuilder, // 각 페이지를 구성하기 위한 함수
      required int itemCount, // 전체 페이지 수
    }) {
  int currentPage = ref.watch(currentPageProvider); // 현재 페이지 인덱스를 관찰
  return Stack(
    alignment: Alignment.center,
    children: [
      PageView.builder(
        controller: pageController, // 페이지 컨트롤러 할당
        itemCount: itemCount, // 페이지 수 설정
        onPageChanged: (index) {
          ref.read(currentPageProvider.notifier).state = index; // 페이지가 변경될 때마다 인덱스 업데이트
        },
        itemBuilder: itemBuilder, // 페이지를 구성하는 위젯을 생성
      ),
      // 왼쪽 화살표 버튼. 첫 페이지가 아닐 때만 활성화됩니다.
      arrowButton(context, Icons.arrow_back_ios, currentPage > 0,
              () => pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut), currentPageProvider, ref),
      // 오른쪽 화살표 버튼. 마지막 페이지가 아닐 때만 활성화됩니다.
      // 현재 페이지 < 전체 페이지 수 - 1 의 조건으로 변경하여 마지막 페이지 검사를 보다 정확하게 합니다.
      arrowButton(context, Icons.arrow_forward_ios, currentPage < itemCount - 1,
              () => pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut), currentPageProvider, ref),
    ],
  );
}
// ------ pageViewWithArrows 위젯 내용 구현 끝

// ------ arrowButton 위젯 내용 구현 시작
// 화살표 버튼을 생성하는 위젯(함수)
// 화살표 버튼을 통해 사용자는 페이지를 앞뒤로 넘길 수 있음.
Widget arrowButton(BuildContext context, IconData icon, bool isActive, VoidCallback onPressed, StateProvider<int> currentPageProvider, WidgetRef ref) {
  return Positioned(
    left: icon == Icons.arrow_back_ios ? 10 : null, // 왼쪽 화살표 위치 조정
    right: icon == Icons.arrow_forward_ios ? 10 : null, // 오른쪽 화살표 위치 조정
    child: IconButton(
      icon: Icon(icon),
      color: isActive ? Colors.black : Colors.grey, // 활성화 여부에 따라 색상 변경
      onPressed: isActive ? onPressed : null, // 활성화 상태일 때만 동작
    ),
  );
}
// ------ arrowButton 위젯 내용 구현 끝

// ------ 가격 순, 할인율 순 관련 분류가능하도록 하는 버튼인 PriceAndDiscountPercentSortButtons 클래스 내용 구현 시작
class PriceAndDiscountPercentSortButtons extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildExpandedSortButton(context, '가격 높은 순'),
          _buildExpandedSortButton(context, '가격 낮은 순'),
          _buildExpandedSortButton(context, '할인율 높은 순'),
          _buildExpandedSortButton(context, '할인율 낮은 순'),
        ],
      ),
    );
  }
// 버튼 세부 내용인 _buildExpandedSortButton 위젯
  Widget _buildExpandedSortButton(BuildContext context, String title) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () {
            // 정렬 로직을 여기에 추가합니다.
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: BUTTON_COLOR, // 버튼 색상 설정
            foregroundColor: INPUT_BORDER_COLOR, // 텍스트 색상 설정
            minimumSize: Size(0, 40), // 최소 버튼 크기 설정
            padding: EdgeInsets.symmetric(horizontal: 8.0), // 패딩 조정
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              textAlign: TextAlign.center, // 텍스트 가운데 정렬
              style: TextStyle(fontSize: 14), // 텍스트 크기를 14로 설정
            ),
          ),
        ),
      ),
    );
  }
}
// ------ 가격 순, 할인율 순 관련 분류가능하도록 하는 버튼인 PriceAndDiscountPercentSortButtons 클래스 내용 구현 끝


// ------- ProductsSectionList 클래스 내용 구현 시작
// 주로, 홈 화면 내 2차 카테고리별 섹션 내 데이터를 4개 단위로 스크롤뷰로 UI 구현하는 부분 관련 로직
class ProductsSectionList extends ConsumerStatefulWidget {
  final String category; // 카테고리 이름을 저장하는 필드
  final Future<List<ProductContent>> Function(int limit, DocumentSnapshot? startAfter) fetchProducts; // 제품을 가져오는 비동기 함수

  // 생성자
  ProductsSectionList({required this.category, required this.fetchProducts});

  @override
  _ProductsSectionListState createState() => _ProductsSectionListState(); // 상태 객체 생성
}

class _ProductsSectionListState extends ConsumerState<ProductsSectionList> {
  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러 초기화
  bool _isFetching = false; // 데이터 가져오는 중인지 확인하는 플래그
  DocumentSnapshot? _lastDocument; // 마지막 문서 스냅샷 저장

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener); // 스크롤 리스너 추가
    // 이미 저장된 홈 화면 내 섹션 데이터를 로드
    final savedProducts = ref.read(homeSectionDataStateProvider.notifier).getSectionProducts(widget.category);
    if (savedProducts.isNotEmpty) {
      setState(() {
        _lastDocument = savedProducts.last.documentSnapshot; // 마지막 문서 스냅샷 업데이트
      });
    } else {
      _fetchInitialProducts(); // 초기 데이터를 가져오는 함수 호출
    }

    // 저장된 홈 화면 내 섹션 스크롤 위치를 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final savedScrollPosition = ref.read(homeSectionScrollPositionsProvider)[widget.category] ?? 0;
      _scrollController.jumpTo(savedScrollPosition); // 스크롤 위치 설정
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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isFetching) {
      _fetchMoreProducts();  // 추가 제품 데이터 가져오기 호출
    }

    // 현재 홈 화면 내 섹션 스크롤 위치를 저장
    ref.read(homeSectionScrollPositionsProvider.notifier).state = {
      ...ref.read(homeSectionScrollPositionsProvider),
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
        ref.read(homeSectionDataStateProvider.notifier).updateSection(widget.category, products); // 섹션 내 제품 데이터 상태 업데이트
        if (products.isNotEmpty) {
          _lastDocument = products.last.documentSnapshot; // 마지막 문서 스냅샷 업데이트
        }
      });
    } catch (e) {
      debugPrint('Error fetching initial products: $e'); // 에러 출력
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
      final products = await widget.fetchProducts(4, _lastDocument); // 추가 4개 제품 데이터 가져오기
      setState(() {
        final currentProducts = ref.read(homeSectionDataStateProvider.notifier).getSectionProducts(widget.category); // 현재 섹션 내 제품 리스트 가져오기
        final updatedProducts = currentProducts + products; // 새로운 섹션 내 제품 리스트와 병합
        ref.read(homeSectionDataStateProvider.notifier).updateSection(widget.category, updatedProducts); // 섹션 내 제품 데이터 상태 업데이트
        if (products.isNotEmpty) {
          _lastDocument = products.last.documentSnapshot; // 마지막 문서 스냅샷 업데이트
        }
      });
    } catch (e) {
      debugPrint('Error fetching more products: $e'); // 에러 출력
    } finally {
      setState(() {
        _isFetching = false; // 데이터 가져오기 완료 상태로 설정
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(homeSectionDataStateProvider)[widget.category] ?? []; // 현재 카테고리의 제품 리스트 가져오기
    return Column(
      children: [
        buildHorizontalDocumentsList(ref, products, context, widget.category, _scrollController), // 가로 스크롤 문서 리스트 빌드
        if (_isFetching) CircularProgressIndicator(), // 데이터 가져오는 중일 때 로딩 인디케이터 표시
      ],
    );
  }
}
// ------- ProductsSectionList 클래스 내용 구현 끝

// ------- BlouseProductList 클래스 내용 구현 시작
class BlouseProductList extends ConsumerStatefulWidget {
  final ScrollController scrollController; // 스크롤 컨트롤러
  BlouseProductList({required this.scrollController}); // 생성자

  @override
  _BlouseProductListState createState() => _BlouseProductListState(); // 상태 생성
}

class _BlouseProductListState extends ConsumerState<BlouseProductList> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener); // 스크롤 리스너 추가
    ref.read(blouseProductListProvider.notifier).fetchInitialProducts(); // 초기 제품 가져오기
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener); // 스크롤 리스너 제거
    super.dispose();
  }

  // 스크롤 리스너 함수
  void _scrollListener() {
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent - 200) {
      ref.read(blouseProductListProvider.notifier).fetchMoreProducts(); // 스크롤이 끝에 도달하면 더 많은 제품 가져오기
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(blouseProductListProvider); // 제품 목록 상태 감시
    final isFetching = ref.watch(blouseProductListProvider.notifier.select((notifier) => notifier.isFetching)); // 가져오는 중인지 상태 감시

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true, // 높이 제한
          physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
          padding: EdgeInsets.symmetric(vertical: 10.0), // 패딩을 최소화하여 설정
          itemCount: (products.length / 3).ceil(), // 행 개수
          itemBuilder: (context, index) {
            int startIndex = index * 3; // 시작 인덱스
            int endIndex = startIndex + 3; // 끝 인덱스
            if (endIndex > products.length) {
              endIndex = products.length; // 끝 인덱스 조정
            }
            List<ProductContent> productRow = products.sublist(startIndex, endIndex); // 행에 들어갈 제품들
            return buildBlouseProductRow(ref, productRow, context); // 행 빌드
          },
        ),
        if (isFetching)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(), // 가져오는 중이면 로딩 표시
          ),
      ],
    );
  }
}
// ------- BlouseProductList 클래스 내용 구현 끝

// ------- buildBlouseProductRow 위젯 내용 구현 시작
Widget buildBlouseProductRow(WidgetRef ref, List<ProductContent> products, BuildContext context) {
  final productInfo = ProductInfoDetailScreenNavigation(ref, '블라우스'); // 제품 정보 상세 화면 내비게이션

  return Row(
    children: products.map((product) => Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0), // 패딩
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            productInfo.buildProdFirestoreDetailDocument(context, product), // 제품 정보 상세 화면 빌드
          ],
        ),
      ),
    )).toList(), // 각 제품을 확장된 위젯으로 변환
  );
}
// ------- buildBlouseProductRow 위젯 내용 구현 끝

// 로그아웃 및 자동로그인 체크 상태에서 앱 종료 후 재실행 시,
// 홈 화면 내 섹션의 데이터 초기화 / 홈 화면 내 섹션의 스크롤 위치 초기화 /  화면 자체의 스크롤 위치 초기화 관련 함수
Future<void> logoutSecDataAndHomeScrollPointReset(WidgetRef ref) async {
  // 로그아웃 기능 수행
  await FirebaseAuth.instance.signOut(); // Firebase 인증 로그아웃
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.remove('autoLogin'); // 자동 로그인 정보 삭제
  prefs.remove('username'); // 저장된 사용자명 삭제
  prefs.remove('password'); // 저장된 비밀번호 삭제

  // 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(homeScrollPositionProvider.notifier).state = 0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(homeCurrentTabProvider.notifier).state = 0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  // 홈 화면 내 섹션의 스크롤 위치 초기화
  ref.read(homeSectionScrollPositionsProvider.notifier).state = {};
}

// ------ buildHorizontalDocumentsList 위젯 내용 구현 시작
// 주로, 홈 화면 내 2차 카테고리별 섹션 내 데이터를 스크롤뷰로 UI 구현하는 부분 관련 로직
// buildHorizontalDocumentsList 함수에서 Document 클릭 시 동작 추가
// 가로로 스크롤 가능한 문서 리스트를 생성하는 함수. 문서 클릭 시 설정된 동작을 실행함.
Widget buildHorizontalDocumentsList(WidgetRef ref, List<ProductContent> products, BuildContext context, String category, ScrollController horizontalScrollViewScrollController) {
  // ProductInfoDetailScreenNavigation 클래스 인스턴스를 생성하여 제품 정보 상세 화면 네비게이션을 설정함.
  final productInfo = ProductInfoDetailScreenNavigation(ref, category);

  return NotificationListener<ScrollNotification>(
    onNotification: (scrollNotification) {
      // debugPrint('Scroll notification: ${scrollNotification.metrics.pixels}');
      return false; // 스크롤 알림 수신시 false 반환하여 기본 동작 유지
    },
    child: SingleChildScrollView(
      controller: horizontalScrollViewScrollController, // 가로 스크롤 컨트롤러 설정
      scrollDirection: Axis.horizontal, // 스크롤 방향을 가로로 설정
      child: Row(
        // 각 제품에 대해 buildProdFirestoreDetailDocument 함수를 호출하여 가로로 나열된 문서 리스트를 생성함.
        children: products.map((product) => productInfo.buildProdFirestoreDetailDocument(context, product)).toList(),
      ),
    ),
  );
}
// ------ buildHorizontalDocumentsList 위젯 내용 구현 끝

// -------- ProductInfoDetailScreenNavigation 클래스 내용 구현 시작
// 홈 화면과 2차 메인화면(1차 카테고리별 메인화면)에 주로 사용될 예정
// 상품별 간단하게 데이터를 보여주는 UI 부분과 해당 상품 클릭 시, 상품 상세화면으로 이동하도록 하는 로직
class ProductInfoDetailScreenNavigation {
  final WidgetRef ref; // ref 변수는 상태 관리를 위해 사용.
  final String category; // category 변수는 제품의 카테고리를 나타냄.

  // 생성자에서 ref와 category를 초기화함.
  ProductInfoDetailScreenNavigation(this.ref, this.category);

  // 상세 화면으로 이동하고 화면을 뒤로 돌아왔을 때 선택된 색상과 사이즈의 상태를 초기화하는 함수.
  void navigateToDetailScreen(BuildContext context, String fullPath) {
    Widget detailScreen;

    // 카테고리에 따라 적절한 상세 화면 위젯을 선택함.
    switch (category) {
      case "티셔츠":
        detailScreen = ShirtDetailProductScreen(fullPath: fullPath);
        break;
      case "블라우스":
        detailScreen = BlouseDetailProductScreen(fullPath: fullPath);
        break;
      case "가디건":
        detailScreen = CardiganDetailProductScreen(fullPath: fullPath);
        break;
      case "코트":
        detailScreen = CoatDetailProductScreen(fullPath: fullPath);
        break;
      case "청바지":
        detailScreen = JeanDetailProductScreen(fullPath: fullPath);
        break;
      case "맨투맨":
        detailScreen = MtmDetailProductScreen(fullPath: fullPath);
        break;
      case "니트":
        detailScreen = NeatDetailProductScreen(fullPath: fullPath);
        break;
      case "원피스":
        detailScreen = OnepieceDetailProductScreen(fullPath: fullPath);
        break;
      case "패딩":
        detailScreen = PaedingDetailProductScreen(fullPath: fullPath);
        break;
      case "팬츠":
        detailScreen = PantsDetailProductScreen(fullPath: fullPath);
        break;
      case "폴라티":
        detailScreen = PolaDetailProductScreen(fullPath: fullPath);
        break;
      case "스커트":
        detailScreen = SkirtDetailProductScreen(fullPath: fullPath);
        break;
      default:
        detailScreen = ShirtDetailProductScreen(fullPath: fullPath);
    }

    // 네비게이션을 통해 상세 화면으로 이동하고, 뒤로 돌아왔을 때 색상과 사이즈 선택 상태를 초기화함.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => detailScreen),
    ).then((_) {
      ref
          .read(colorSelectionIndexProvider.notifier)
          .state = null;
      ref
          .read(sizeSelectionProvider.notifier)
          .state = null;
    });

    // 상품의 문서명을 로그로 출력함. - 해당 로그값으로, 상세화면 내 데이터와 파이어베이스 내 문서의 데이터 일치성을 확인하고자 하는 부분
    debugPrint('Navigating to detail screen for document: $fullPath');
  }

  // Firestore에서 상세한 문서 정보를 빌드하여 UI에 구현하는 위젯.
  Widget buildProdFirestoreDetailDocument(BuildContext context,
      ProductContent product) {
    return GestureDetector(
      // 문서 클릭 시 navigateToDetailScreen 함수를 호출함.
      onTap: () {
        navigateToDetailScreen(
            context, product.docId); // product.docId를 사용하여 해당 문서로 이동함.
      },
      child: Container(
        // height: 180, // 항목의 높이를 명시적으로 지정하여 충분한 공간 확보
        // width: 180,
        padding: EdgeInsets.all(4.0),
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제품 썸네일을 표시함.
            if (product.thumbnail != null && product.thumbnail!.isNotEmpty)
              Center(
                child: Image.network(
                    product.thumbnail!, width: 100, fit: BoxFit.cover),
              ),
            SizedBox(height: 5),
            // 제품 간단한 소개를 표시함.
            if (product.briefIntroduction != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  product.briefIntroduction!,
                  style: TextStyle(fontSize: 14),
                  maxLines: 2, // 최대 2줄까지 표시함.
                  overflow: TextOverflow.visible, // 넘치는 텍스트는 '...'으로 표시함.
                ),
              ),
            // 원래 가격을 표시함. 소수점은 표시하지 않음.
            if (product.originalPrice != null)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  '${product.originalPrice!.toStringAsFixed(0)}원',
                  style: TextStyle(
                      fontSize: 12, decoration: TextDecoration.lineThrough),
                ),
              ),
            // 할인된 가격을 표시함. 소수점은 표시하지 않음.
            if (product.discountPrice != null)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  children: [
                    Text(
                      '${product.discountPrice!.toStringAsFixed(0)}원',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    // 할인율을 빨간색으로 표시함.
                    if (product.discountPercent != null)
                      Text(
                        '${product.discountPercent!.toStringAsFixed(0)}%',
                        style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            SizedBox(height: 10),
            // 제품 색상 옵션을 표시함.
            if (product.colors != null)
              Row(
                children: product.colors!
                    .map((color) =>
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Image.network(color, width: 13, height: 13),
                    ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
// -------- ProductInfoDetailScreenNavigation 클래스 내용 구현 끝

// ------ 상품 상세 화면 내 UI 관련 위젯 공통 코드 내용 시작
// ------ buildProductDetails 위젯 시작: 상품 상세 정보를 구성하는 위젯을 정의.
Widget buildProductDetails(BuildContext context, WidgetRef ref, ProductContent product) {
  // print('buildProductDetails 호출');
  // print('상품 소개: ${product.briefIntroduction}');
  return SingleChildScrollView(
    // 스크롤이 가능하도록 SingleChildScrollView 위젯을 사용.
    child: Column(
      // 세로 방향으로 위젯들을 나열하는 Column 위젯을 사용.
      crossAxisAlignment: CrossAxisAlignment.start,
      // 자식 위젯들을 왼쪽 정렬로 배치.
      children: [
        SizedBox(height: 10), // 상단 여백을 10으로 설정.
        buildProductIntroduction(product), // 제품 소개 부분을 표시하는 위젯을 호출.
        SizedBox(height: 10), // 제품 소개와 다음 섹션 사이의 여백을 10으로 설정.
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20), // 좌우 여백을 20으로 설정.
          child: Divider(), // 세로 구분선을 추가.
        ),
        SizedBox(height: 20), // 구분선 아래 여백을 20으로 설정.
        buildPriceInformation(product), // 가격 정보 부분을 표시하는 위젯을 호출.
        buildColorAndSizeSelection(context, ref, product), // 색상 및 사이즈 선택 부분을 표시하는 위젯을 호출.
        SizedBox(height: 30), // 여백을 30으로 설정.
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20), // 좌우 여백을 20으로 설정.
          child: Divider(), // 세로 구분선을 추가.
        ),
        SizedBox(height: 10), // 구분선 아래 여백을 10으로 설정.
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20), // 좌우 여백을 20으로 설정.
          child: Divider(), // 세로 구분선을 추가.
        ),
        SizedBox(height: 30), // 여백을 30으로 설정.
        buildPurchaseButtons(context, ref, product), // 구매 버튼 부분을 표시하는 위젯을 호출.
      ],
    ),
  );
}
// ------ buildProductDetails 위젯의 구현 끝

// ------ buildProductIntroduction 위젯 시작: 제품 소개 부분을 구현.
Widget buildProductIntroduction(ProductContent product) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    // 좌우 여백을 20으로 설정.
    child: Text(
      product.briefIntroduction ?? '제품 정보가 없습니다.',
      // 제품 소개 내용을 표시하거나, 내용이 없는 경우 기본 텍스트를 표시.
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      // 폰트 크기는 25, 굵은 글씨로 설정.
    ),
  );
}
// ------ buildProductIntroduction 위젯의 구현 끝

// ------ buildPriceInformation 위젯 시작: 가격 정보 부분을 구현.
Widget buildPriceInformation(ProductContent product) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0), // 좌우 여백을 20으로 설정.
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // 자식 위젯들을 왼쪽 정렬로 배치.
      children: [
        Row(
          children: [
            if (product.originalPrice != null) // 원래 가격이 설정되어 있으면 표시.
              Text('판매가', style: TextStyle(fontSize: 14)),
            SizedBox(width: 50), // '판매가'와 가격 사이의 간격을 50으로 설정.
            Text('${product.originalPrice ?? "정보 없음"}', style: TextStyle(fontSize: 14, decoration: TextDecoration.lineThrough, fontWeight: FontWeight.bold)),
            // 원래 가격을 표시하고, 정보가 없으면 '정보 없음'을 표시. 가격은 취소선 처리.
          ],
        ),
        SizedBox(height: 10), // 가격 정보 간의 수직 간격을 10으로 설정.
        Row(
          children: [
            if (product.discountPrice != null) // 할인 가격이 설정되어 있으면 표시.
              Text('할인판매가', style: TextStyle(fontSize: 14, color: DISCOUNT_COLOR)),
            SizedBox(width: 26), // '할인판매가'와 가격 사이의 간격을 26으로 설정.
            Text('${product.discountPrice ?? "정보 없음"}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: DISCOUNT_COLOR)),
            // 할인된 가격을 표시하고, 정보가 없으면 '정보 없음'을 표시. 할인가는 강조된 색상으로 표시.
          ],
        ),
      ],
    ),
  );
}
// ------ buildPriceInformation 위젯의 구현 끝

// ------ buildColorAndSizeSelection 위젯 시작: 색상 및 사이즈 선택 부분을 구현.
Widget buildColorAndSizeSelection(BuildContext context, WidgetRef ref, ProductContent product) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0), // 좌우 여백을 20으로 설정.
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // 자식 위젯들을 왼쪽 정렬로 배치.
          children: [
            Text('색상', style: TextStyle(fontSize: 14)), // '색상' 라벨을 표시.
            SizedBox(width: 63), // '색상' 라벨과 드롭다운 버튼 사이의 간격을 63으로 설정.
            Expanded(
              // 드롭다운 버튼을 화면 너비에 맞게 확장.
              child: DropdownButton<String>(
                isExpanded: true, // 드롭다운 버튼의 너비를 최대로 확장.
                value: ref.watch(colorSelectionIndexProvider), // 선택된 색상 값을 가져옴.
                hint: Text('- [필수] 옵션을 선택해 주세요 -'), // 선택하지 않았을 때 표시되는 텍스트.
                onChanged: (newValue) {
                  ref.read(colorSelectionIndexProvider.notifier).state = newValue!;
                  // 새로운 색상이 선택되면 상태를 업데이트.
                },
                items: product.colorOptions?.map((option) => DropdownMenuItem<String>(
                  value: option['url'], // 각 옵션의 URL을 값으로 사용.
                  child: Row(
                    children: [
                      Image.network(option['url'], width: 20, height: 20), // 색상을 나타내는 이미지를 표시.
                      SizedBox(width: 8), // 이미지와 텍스트 사이의 간격을 8로 설정.
                      Text(option['text']), // 색상의 텍스트 설명을 표시.
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
        SizedBox(height: 10), // 색상 선택과 사이즈 선택 사이의 수직 간격을 10으로 설정.
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // 자식 위젯들을 왼쪽 정렬로 배치.
          children: [
            Text('사이즈', style: TextStyle(fontSize: 14)), // '사이즈' 라벨을 표시.
            SizedBox(width: 52), // '사이즈' 라벨과 드롭다운 버튼 사이의 간격을 52로 설정.
            Expanded(
              // 드롭다운 버튼을 화면 너비에 맞게 확장.
              child: DropdownButton<String>(
                isExpanded: true, // 드롭다운 버튼의 너비를 최대로 확장.
                value: ref.watch(sizeSelectionProvider), // 선택된 사이즈 값을 가져옴.
                hint: Text('- [필수] 옵션을 선택해 주세요 -'), // 선택하지 않았을 때 표시되는 텍스트.
                onChanged: (newValue) {
                  ref.read(sizeSelectionProvider.notifier).state = newValue!;
                  // 새로운 사이즈가 선택되면 상태를 업데이트.
                },
                items: product.sizes?.map((size) => DropdownMenuItem<String>(
                  value: size,
                  child: Text(size),
                )).toList(),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
// ------ buildColorAndSizeSelection 위젯의 구현 끝

// ------ buildPurchaseButtons 위젯 시작: 구매 관련 버튼을 구현.
Widget buildPurchaseButtons(BuildContext context, WidgetRef ref, ProductContent product) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0), // 좌우 여백을 20으로 설정.
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // 버튼들을 화면 양쪽 끝에 배치.
      children: [
        Expanded(
          // '장바구니' 버튼을 화면 너비에 맞게 확장.
          child: ElevatedButton(
            onPressed: () {},  // 장바구니 추가 로직을 구현. (현재는 비어 있음)
            style: ElevatedButton.styleFrom(
              backgroundColor: BUTTON_COLOR, // 버튼의 배경색을 설정.
              foregroundColor: INPUT_BG_COLOR, // 버튼의 글자색을 설정.
            ),
            child: Text('장바구니'), // 버튼의 텍스트를 '장바구니'로 설정.
          ),
        ),
        SizedBox(width: 10), // '장바구니'와 '주문' 버튼 사이의 간격을 10으로 설정.
        Expanded(
          // '주문' 버튼을 화면 너비에 맞게 확장.
          child: ElevatedButton(
            onPressed: () {},  // 주문 로직을 구현. (현재는 비어 있음)
            style: ElevatedButton.styleFrom(
              backgroundColor: BUTTON_COLOR, // 버튼의 배경색을 설정.
              foregroundColor: INPUT_BG_COLOR, // 버튼의 글자색을 설정.
            ),
            child: Text('주문'), // 버튼의 텍스트를 '주문'으로 설정.
          ),
        ),
      ],
    ),
  );
}
// ------ buildPurchaseButtons 위젯의 구현 끝
// ------ 상품 상세 화면 내 UI 관련 위젯 공통 코드 내용 끝