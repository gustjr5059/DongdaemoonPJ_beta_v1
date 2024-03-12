import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리를 위한 패키지
import '../../common/provider/future_provider.dart';
import '../../common/provider/state_provider.dart'; // 공통 상태 관리를 위한 provider 파일
import '../../common/view/common_parts.dart'; // 공통 UI 부품을 위한 파일


// 제품 상세 페이지를 나타내는 위젯 클래스, Riverpod의 ConsumerWidget을 상속받아 상태 관리 가능
class DetailProductScreen extends ConsumerWidget {
  final String docId; // 문서 ID를 저장할 변수 선언
  const DetailProductScreen({Key? key, required this.docId}) : super(key: key); // 생성자 수정

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 선택된 탭 인덱스를 관찰합니다.
    final tabIndex = ref.watch(tabIndexProvider);
    // Firestore에서 문서 데이터를 조회하는 로직 추가(비동기 방식으로 데이터 조회)
    final docData = ref.watch(firestoreDataProvider(docId)); // 예시로 사용된 Provider, 실제 구현 필요

    // TopBar 카테고리 리스트를 생성하고 사용자가 탭했을 때의 동작을 정의
    Widget topBarList = buildTopBarList(context, (index) {
      // 각 카테고리 인덱스에 따른 동작을 여기에 정의합니다.
      // 예: Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLayout()));
      // 위에서 정의한 switch-case 로직을 여기에 포함시킵니다.
    });

// pageViewWithArrows 위젯을 사용하여 이미지 슬라이더 섹션을 생성하는 코드
// Firestore에서 가져온 데이터를 기반으로 이미지 URL 리스트를 생성하고,
// 해당 URL 리스트를 사용하여 이미지 슬라이더를 구성함.
    Widget pageViewSection = docData.when(
      // 데이터가 성공적으로 로드되었을 때
      data: (data) {
        // Firestore 문서에서 이미지 URL을 추출하여 String 리스트로 변환
        // 'detail_page_imageX' 필드에서 X는 1부터 5까지의 숫자로, 각 이미지의 URL을 나타냄
        // 비어 있지 않은 URL만 필터링하여 최종 리스트를 생성합니다.
        List<String> imageUrls = [
          for (int i = 1; i <= 5; i++) data['detail_page_image$i'] ?? '',
        ].where((url) => url.isNotEmpty).map<String>((url) => url).toList(); // 비어있지 않은 URL만 선택하여 리스트를 생성

        // pageViewWithArrows 위젯을 반환하고, 이 위젯은 이미지 슬라이더 기능을 제공함.
        return pageViewWithArrows(
          context, // 현재 context
          PageController(), // 페이지 컨트롤러를 새로 생성
          ref, // Riverpod의 WidgetRef, 상태 관리를 위해 사용
          currentPageProvider, // 현재 페이지의 인덱스를 관리하는 StateProvider
          itemCount: imageUrls.length, // 이미지 URL 리스트의 길이, 즉 총 슬라이드 개수를 나타냄
          itemBuilder: (BuildContext context, int index) {
            // itemBuilder는 각 슬라이드를 구성하는 위젯을 반환합니다.
            // 여기서는 NetworkImage를 사용하여 각 URL로부터 이미지를 로드하고 표시합니다.
            return Image.network(imageUrls[index], fit: BoxFit.cover); // 각 이미지 URL에 대한 네트워크 이미지 위젯
          },
        );
      },
      loading: () => CircularProgressIndicator(), // 데이터 로딩 중 표시할 위젯
      error: (error, stack) => Text('오류 발생: $error'), // 에러 발생 시 표시할 위젯
    );


    return Scaffold(
      // GlobalKey 제거
      // key: scaffoldKey, // common_parts.dart에서 정의한 GlobalKey 사용
      // 기존 GlobalKey의 사용은 제거됨.
      // 공통 AppBar 구성 함수 호출
      appBar: buildCommonAppBar('DETAIL PRODUCT', context),// common_parts.dart의 AppBar 재사용
      // body에 카테고리 리스트 포함
      body: SingleChildScrollView( // 스크롤 가능한 뷰로 컨텐츠를 감싸기
        child: Column( // 세로로 배열되는 위젯들
          crossAxisAlignment: CrossAxisAlignment.start, // 자식들을 시작 지점(왼쪽)으로 정렬
          children: [
            Container(
              height: 100,
              child: topBarList, // 카테고리 리스트 표시
            ),
            SizedBox(height: 300, child: pageViewSection), // 이미지 슬라이더 섹션
            SizedBox(height: 20), // 간격 추가
            // 각 텍스트 정보를 Padding으로 감싸서 좌우 여백 추가
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: docData.when(
                data: (data) => Text(data['brief_introduction'], style: TextStyle(fontSize: 30)),
                loading: () => CircularProgressIndicator(),
                error: (error, stack) => Text('오류 발생: $error'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: docData.when(
                data: (data) => Text(
                  "${data['original_price']}",
                  style: TextStyle(fontSize: 20, decoration: TextDecoration.lineThrough),
                ),
                loading: () => CircularProgressIndicator(),
                error: (error, stack) => Text('오류 발생: $error'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: docData.when(
                data: (data) => Text(
                  "${data['discount_price']}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                loading: () => CircularProgressIndicator(),
                error: (error, stack) => Text('오류 발생: $error'),
              ),
            ),
          ],
        ),
      ),
      // buildCommonBottomNavigationBar 함수 호출 시 context 인자 추가
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref, context),
      drawer: buildCommonDrawer(context), // 드로어 메뉴, 공통 구성 함수 호출
    );
  }
}