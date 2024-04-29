
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/provider/common_future_provider.dart';
import '../model/product_model.dart';
import '../provider/product_future_provider.dart';
import '../provider/product_state_provider.dart';
import '../view/detail_screen/blouse_detail_screen.dart';
import '../view/detail_screen/cardigan_detail_screen.dart';
import '../view/detail_screen/coat_detail_screen.dart';
import '../view/detail_screen/jean_detail_screen.dart';
import '../view/detail_screen/mtm_detail_screen.dart';
import '../view/detail_screen/neat_detail_screen.dart';
import '../view/detail_screen/onepiece_detail_screen.dart';
import '../view/detail_screen/paeding_detail_screen.dart';
import '../view/detail_screen/pants_detail_screen.dart';
import '../view/detail_screen/pola_detail_screen.dart';
import '../view/detail_screen/shirt_detail_screen.dart';
import '../view/detail_screen/skirt_detail_screen.dart';


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
            // case 'alpha':
            //   navigateToDetailScreen(CoatDetailProductScreen(docId: docId));
            //   break;
            // case 'apple':
            //   navigateToDetailScreen(BlouseDetailProductScreen(docId: docId));
            //   break;
            // case 'cat':
            //   navigateToDetailScreen(JeanDetailProductScreen(docId: docId));
            //   break;
            // case 'flutter':
            //   navigateToDetailScreen(ShirtDetailProductScreen(docId: docId));
            //   break;
            // case 'github':
            //   navigateToDetailScreen(PaedingDetailProductScreen(docId: docId));
            //   break;
            // case 'samsung':
            //   navigateToDetailScreen(SkirtDetailProductScreen(docId: docId));
            //   break;
            // case 'alpha1':
            //   navigateToDetailScreen(CardiganDetailProductScreen(docId: docId));
            //   break;
            // case 'apple1':
            //   navigateToDetailScreen(MtmDetailProductScreen(docId: docId));
            //   break;
            // case 'cat1':
            //   navigateToDetailScreen(NeatDetailProductScreen(docId: docId));
            //   break;
            // case 'flutter1':
            //   navigateToDetailScreen(OnepieceDetailProductScreen(docId: docId));
            //   break;
            // case 'github1':
            //   navigateToDetailScreen(PolaDetailProductScreen(docId: docId));
            //   break;
            // case 'samsung1':
            //   navigateToDetailScreen(PantsDetailProductScreen(docId: docId));
            //   break;
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