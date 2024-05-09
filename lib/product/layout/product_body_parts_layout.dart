
// iOS 스타일의 인터페이스 요소를 사용하기 위해 Cupertino 디자인 패키지를 임포트합니다.
import 'package:flutter/cupertino.dart';
// Android 및 기본 플랫폼 스타일의 인터페이스 요소를 사용하기 위해 Material 디자인 패키지를 임포트합니다.
import 'package:flutter/material.dart';
// 상태 관리를 위해 사용되는 Riverpod 패키지를 임포트합니다.
// Riverpod는 애플리케이션의 다양한 상태를 관리하는 데 도움을 주는 강력한 도구입니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// 애플리케이션에서 사용할 색상 상수들을 정의한 파일을 임포트합니다.
import '../../common/const/colors.dart';
// 제품 데이터 모델을 정의한 파일을 임포트합니다.
// 이 모델은 제품의 속성을 정의하고, 애플리케이션에서 제품 데이터를 구조화하는 데 사용됩니다.
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

// ------ buildFirestoreDetailDocument 위젯 내용 구현 시작
// Firestore에서 상세한 문서 정보를 빌드하는 위젯임.
// 각 문서의 세부 정보를 UI에 표시함.
// 위젯 생성 함수, 필요한 매개변수로 WidgetRef, 문서 ID, 카테고리, 그리고 BuildContext를 받음.
Widget buildProdFirestoreDetailDocument(WidgetRef ref, String docId, String category, BuildContext context) {
  // 문서 ID를 사용하여 Firestore에서 상품 데이터를 비동기적으로 로드함.
  final asyncValue = ref.watch(prodFirestoreDataProvider(docId));

  // 상세 화면으로 이동하고 화면을 뒤로 돌아왔을 때 선택된 색상과 사이즈의 상태를 초기화하는 함수임.
  void navigateToDetailScreen(Widget screen) {
    // Navigator를 사용하여 새 화면으로 이동함. 화면 전환 후, 색상과 사이즈 선택 상태를 초기화함.
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen)).then((_) {
      ref.read(colorSelectionIndexProvider.state).state = null;
      ref.read(sizeSelectionProvider.state).state = null;
    });
  }

  // 로드된 데이터에 따라 UI를 동적으로 생성함.
  return asyncValue.when(
    data: (ProductContent product) {
      // 데이터 로드 완료 시 실행되는 부분, 제스처 인식 위젯을 사용하여 탭 시 동작을 정의함.
      return GestureDetector(
        onTap: () {
          // 문서 ID에 따라 해당 상세 페이지로 이동함. 각 ID는 다른 상품 카테고리를 나타냄.
          switch (docId) {
            case 'alpha':
              navigateToDetailScreen(CoatDetailProductScreen(docId: docId));
              break;
            case 'apple':
              navigateToDetailScreen(BlouseDetailProductScreen(docId: docId));
              break;
            case 'cat':
              navigateToDetailScreen(JeanDetailProductScreen(docId: docId));
              break;
            case 'flutter':
              navigateToDetailScreen(ShirtDetailProductScreen(docId: docId));
              break;
            case 'github':
              navigateToDetailScreen(PaedingDetailProductScreen(docId: docId));
              break;
            case 'samsung':
              navigateToDetailScreen(SkirtDetailProductScreen(docId: docId));
              break;
            case 'alpha1':
              navigateToDetailScreen(CardiganDetailProductScreen(docId: docId));
              break;
            case 'apple1':
              navigateToDetailScreen(MtmDetailProductScreen(docId: docId));
              break;
            case 'cat1':
              navigateToDetailScreen(NeatDetailProductScreen(docId: docId));
              break;
            case 'flutter1':
              navigateToDetailScreen(OnepieceDetailProductScreen(docId: docId));
              break;
            case 'github1':
              navigateToDetailScreen(PolaDetailProductScreen(docId: docId));
              break;
            case 'samsung1':
              navigateToDetailScreen(PantsDetailProductScreen(docId: docId));
              break;
          }
        },
        child: Container(
          width: 180,
          margin: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트와 색상 이미지들을 왼쪽으로 정렬
            children: [
              if (product.thumbnail != null) // 썸네일이 있는 경우 이미지 표시
                Center(
                  child: Image.network(product.thumbnail!, width: 90, fit: BoxFit.cover),
                ),
              SizedBox(height: 10),
              if (product.colors != null) // 제품의 색상 옵션이 있는 경우 표시
                Row(
                  children: product.colors!
                      .map((color) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Image.network(color, width: 13, height: 13),
                  ))
                      .toList(),
                ),
              if (product.briefIntroduction != null) // 제품의 간단한 소개가 있는 경우 텍스트로 표시
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    product.briefIntroduction!,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              if (product.originalPrice != null) // 원래 가격 표시, 가격 취소선 효과 적용
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    product.originalPrice!,
                    style: TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough),
                  ),
                ),
              if (product.discountPrice != null) // 할인된 가격이 있을 경우 강조하여 표시
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    product.discountPrice!,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      );
    },
    loading: () => CircularProgressIndicator(), // 데이터 로딩 중 표시
    error: (error, stack) => Text("오류 발생: $error"), // 오류 발생 시 메시지 표시
  );
}
// ------ buildFirestoreDetailDocument 위젯 내용 구현 끝

// ------ buildHorizontalDocumentsList 위젯 내용 구현 시작
// buildHorizontalDocumentsList 함수에서 Document 클릭 시 동작 추가
// 가로로 스크롤 가능한 문서 리스트를 생성하는 함수. 문서 클릭 시 설정된 동작을 실행함.
Widget buildHorizontalDocumentsList(WidgetRef ref, List<String> documentIds, String category, BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: documentIds.map((docId) => buildProdFirestoreDetailDocument(ref, docId, category, context)).toList(),
    ),
  );
}
// ------ buildHorizontalDocumentsList 위젯 내용 구현 끝

// ------ 상품 상세 화면 내 UI 관련 위젯 공통 코드 내용 시작
// ------ buildProductDetails 위젯 시작: 상품 상세 정보를 구성하는 위젯을 정의.
Widget buildProductDetails(BuildContext context, WidgetRef ref, ProductContent product) {
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