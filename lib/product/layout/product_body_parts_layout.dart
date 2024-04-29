
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/provider/common_future_provider.dart';
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
// Firestore 데이터를 기반으로 세부 정보를 표시하는 위젯.
// 각 문서의 세부 정보를 UI에 표시함.
// 위젯 생성 함수, 필요한 매개변수로 WidgetRef, 문서 ID, 카테고리, 그리고 BuildContext를 받음.
Widget buildProdFirestoreDetailDocument(WidgetRef ref, String docId, String category, BuildContext context) {
  // ref를 사용하여 Firestore에서 문서 ID에 해당하는 데이터를 비동기적으로 로드
  final asyncValue = ref.watch(prodFirestoreDataProvider(docId));

  // 상세 화면으로 이동하고, 화면 반환 시 선택된 색상과 사이즈 상태를 초기화하는 함수 정의함.
  void navigateToDetailScreen(Widget screen) {
    // Navigator를 사용하여 새로운 화면으로 이동. 이동 후 콜백에서 색상과 사이즈 선택 상태 초기화함.
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen)).then((_) {
      // 디테일 화면에서 선택한 '색상'과 '사이즈' 데이터 상태를 초기화
      ref.read(colorSelectionIndexProvider.state).state = null;
      ref.read(sizeSelectionProvider.state).state = null;
    });
  }
  // 비동기 데이터 로드 결과에 따른 UI 처리
  return asyncValue.when(
    data: (DocumentSnapshot snapshot) {
      // Firestore에서 데이터를 Map 형태로 변환함.
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      // 데이터가 존재할 경우 UI 구성함.
      if (data != null) {
        return GestureDetector(
          onTap: () {
            // 문서 ID에 따른 상세 페이지로 이동
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
                // 썸네일 이미지 표시
                if (data['thumbnails'] != null)
                  Center( // thumbnails 이미지를 중앙에 배치
                    child: Image.network(data['thumbnails'], width: 90, fit: BoxFit.cover),// width: 90 : 전체인 Container 180 너비 중 thumbnails가 90 차지하도록 설정
                  ),
                SizedBox(height: 10), // thumbnails와 clothes_color 사이의 간격 설정
                // 색상 이미지 URL 처리
                // 색상 정보 표시
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // 색상 이미지들을 왼쪽으로 정렬
                  children: List.generate(5, (index) => index + 1) // 1부터 5까지의 숫자 생성
                      .map((i) => data['clothes_color$i'] != null
                      ? Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.network(
                      data['clothes_color$i'],
                      width: 13,
                      height: 13,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Container()) // 색상 정보가 없으면 표시하지 않음
                      .toList(),
                ),
                // 짧은 소개 텍스트
                if (data['brief_introduction'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      data['brief_introduction'],
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                // 원가 표시
                if (data['original_price'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "${data['original_price']}",
                      style: TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough),
                    ),
                  ),
                // 할인가 표시
                if (data['discount_price'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "${data['discount_price']}",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        );
      } else {
        return Text("데이터 없음"); // 데이터가 없는 경우 표시
      }
    },
    loading: () => CircularProgressIndicator(), // 로딩 중 표시
    error: (error, stack) => Text("오류 발생: $error"), // 오류 발생 시 표시
  );
}
// ------ buildFirestoreDetailDocument 위젯 내용 구현 끝

// ------ buildHorizontalDocumentsList 위젯 내용 구현 시작
// buildHorizontalDocumentsList 함수에서 Document 클릭 시 동작 추가
// 가로로 스크롤 가능한 문서 리스트를 생성하는 함수. 문서 클릭 시 설정된 동작을 실행함.
Widget buildHorizontalDocumentsList(WidgetRef ref, List<String> documentIds, String category, BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal, // 가로 스크롤 설정
    child: Row(
      children: documentIds.map((docId) => buildProdFirestoreDetailDocument(ref, docId, category, context)).toList(),
    ),
  );
}
// ------ buildHorizontalDocumentsList 위젯 내용 구현 끝