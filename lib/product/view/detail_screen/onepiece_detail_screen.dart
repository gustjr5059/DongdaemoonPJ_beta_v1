
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리를 위한 패키지
import '../../../common/const/colors.dart';
import '../../../common/provider/common_future_provider.dart';
import '../../../common/provider/common_state_provider.dart'; // 공통 상태 관리를 위한 provider 파일
import '../../../common/layout/common_parts_layout.dart';
import '../../provider/product_state_provider.dart'; // 공통 UI 부품을 위한 파일


// 제품 상세 페이지를 나타내는 위젯 클래스, Riverpod의 ConsumerWidget을 상속받아 상태 관리 가능
class OnepieceDetailProductScreen extends ConsumerWidget {
  final String docId; // 문서 ID를 저장할 변수 선언
  const OnepieceDetailProductScreen({Key? key, required this.docId}) : super(key: key); // 생성자 수정

  // 이미지의 크기를 비동기적으로 가져오는 함수
  Future<Size> _getImageSize(String imageUrl) async {
    Image image = Image.network(imageUrl);
    Completer<Size> completer = Completer<Size>();

    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo image, bool synchronousCall) {
        var myImage = image.image;
        Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
        completer.complete(size);
      }),
    );

    return completer.future;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 선택된 탭 인덱스를 관찰함.
    final tabIndex = ref.watch(tabIndexProvider);
    // Firestore에서 문서 데이터를 조회하는 로직 추가(비동기 방식으로 데이터 조회)
    final docData = ref.watch(firestoreDataProvider(docId)); // 예시로 사용된 Provider, 실제 구현 필요
    // 파이어스토어 내 '사이즈' 데이터를 선택할 때마다 그에 해당하는 데이터로 변경용 상태 관리를 위한 StateProvider
    final selectedSize = ref.watch(sizeSelectionProvider.state);

    // TopBar 카테고리 리스트를 생성하고 사용자가 탭했을 때의 동작을 정의
    Widget topBarList = buildTopBarList(context, (index) {
      // 각 카테고리 인덱스에 따른 동작을 여기에 정의함.
      // 예: Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLayout()));
      // 위에서 정의한 switch-case 로직을 여기에 포함시킴.
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
          onepieceDetailBannerPageProvider, // 현재 페이지의 인덱스를 관리하는 StateProvider(onepieceDetailBannerPageProvider와 분리하여 홈 화면의 배너 페이지 뷰의 페이지 인덱스와 따로 관리)
          itemCount: imageUrls.length, // 이미지 URL 리스트의 길이, 즉 총 슬라이드 개수를 나타냄
          itemBuilder: (BuildContext context, int index) {
            // itemBuilder는 각 슬라이드를 구성하는 위젯을 반환합니다.
            // 여기서는 Image.network를 사용하여 각 URL로부터 이미지를 로드하고 표시합니다.
            // AspectRatio를 사용하여 이미지의 원본 비율을 유지합니다.
            // FutureBuilder를 사용하여 이미지의 비율을 동적으로 계산
            return FutureBuilder<Size>(
              future: _getImageSize(imageUrls[index]),
              builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  // 이미지 로드 완료 및 크기 데이터가 있는 경우
                  // 이미지의 실제 비율에 맞게 AspectRatio 위젯을 사용
                  // BoxFit.contain을 사용하여 이미지가 공간에 꽉 차게 나오면서도 원본 비율이 유지되도록 함
                  return AspectRatio(
                    aspectRatio: snapshot.data!.width / snapshot.data!.height,
                    child: Image.network(imageUrls[index], fit: BoxFit.contain),
                  );
                } else {
                  // 이미지 로딩 중 표시할 위젯
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          },
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('오류 발생: $error'),
    );

    return Scaffold(
      // GlobalKey 제거
      // key: scaffoldKey, // common_parts.dart에서 정의한 GlobalKey 사용
      // 기존 GlobalKey의 사용은 제거됨.
      // 공통 AppBar 구성 함수 호출
      appBar: buildCommonAppBar('원피스 상세', context),// common_parts.dart의 AppBar 재사용
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0), // 좌우로 20의 간격을 줌
              child: docData.when(
                data: (data) => Text(
                  data['brief_introduction'] ?? '', // null 안전성 체크
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // 텍스트 스타일 적용
                ),
                loading: () => CircularProgressIndicator(),
                error: (error, stack) => Text('오류 발생: $error'),
              ),
            ),
            SizedBox(height: 10), // brief_introduction 아래에 간격 추가
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20), // 선의 좌우 간격을 20으로 설정
              child: Divider(), // 선 추가
            ),
            SizedBox(height: 20), // 선 아래에 간격 추가
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0), // 좌우 간격 20으로 설정
              child: docData.when(
                data: (data) {
                  final originalPrice = data['original_price'] ?? ''; // null 체크
                  return Row( // Row 위젯을 사용하여 가로로 배열
                    children: [
                      Text(
                        '판매가', // '판매가' 텍스트
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(width: 50), // '판매가'와 가격 사이에 10의 간격 추가
                      Text(
                        '$originalPrice', // 가격 데이터
                        style: TextStyle(fontSize: 14, decoration: TextDecoration.lineThrough, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
                loading: () => CircularProgressIndicator(),
                error: (error, stack) => Text('오류 발생: $error'),
              ),
            ),
            SizedBox(height: 10), // '판매가'와 '색상' 할인판매가 사이의 간격
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0), // 좌우 간격 20으로 설정
              child: docData.when(
                data: (data) {
                  final discountPrice = data['discount_price'] ?? ''; // null 체크
                  return Row( // Row 위젯을 사용하여 가로로 배열
                    children: [
                      Text(
                        '할인판매가', // '할인판매가' 텍스트
                        style: TextStyle(fontSize: 14, color: DISCOUNT_COLOR),
                      ),
                      SizedBox(width: 25), // '판매가'와 가격 사이에 10의 간격 추가
                      Text(
                        '$discountPrice', // 가격 데이터
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: DISCOUNT_COLOR),
                      ),
                    ],
                  );
                },
                loading: () => CircularProgressIndicator(),
                error: (error, stack) => Text('오류 발생: $error'),
              ),
            ),
            SizedBox(height: 10), // '할인판매가'와 '색상' 드롭다운 사이의 간격
            // Firestore로부터 가져온 문서 데이터를 사용하여 UI를 동적으로 구성하는 부분
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0), // 좌우 여백을 20으로 설정함.
              child: docData.when(
                data: (data) {
                  // Firestore 문서로부터 '색상' 옵션 데이터를 가져옴.
                  List<Map<String, dynamic>> colorOptions = [];
                  for (int i = 1; i <= 5; i++) {
                    String? colorText = data['color${i}_text']; // 색상의 텍스트 설명
                    String? colorUrl = data['clothes_color$i']; // 색상을 나타내는 이미지의 URL
                    if (colorText != null && colorUrl != null) {
                      colorOptions.add({'text': colorText, 'url': colorUrl}); // 유효한 데이터만 리스트에 추가함.
                    }
                  }
                  // Firestore 문서로부터 '사이즈' 옵션 데이터를 가져옴.
                  List<String> sizes = [];
                  for (int i = 1; i <= 4; i++) {
                    String? size = data['clothes_size$i']; // 사이즈 옵션
                    if (size != null) {
                      sizes.add(size); // 유효한 데이터만 리스트에 추가함.
                    }
                  }
                  return Column(
                    children: [
                      Row( // '색상' 텍스트와 DropdownButton을 가로로 배열하기 위해 Row 위젯 사용
                        mainAxisAlignment: MainAxisAlignment.start, // 항목들을 시작 지점(왼쪽)으로 정렬
                        children: [
                          // '색상' 선택을 위한 드롭다운 메뉴입니다.
                          Text('색상', style: TextStyle(fontSize: 14)), // '색상' 라벨을 표시함.
                          SizedBox(width: 63), // '색상' 텍스트와 DropdownButton 사이에 50의 간격 추가
                          Expanded( // DropdownButton을 확장하여 나머지 공간을 차지하도록 함.
                            child: DropdownButton<int>(
                              isExpanded: true, // 드롭다운의 너비를 부모 컨테이너에 맞춤.
                              value: ref.watch(colorSelectionIndexProvider.state).state, // 현재 선택된 '색상'의 인덱스
                              hint: Text('- [필수] 옵션을 선택해 주세요 -'), // 선택하지 않았을 때 보이는 안내 메시지
                              onChanged: (int? newValue) {
                                ref.read(colorSelectionIndexProvider.state).state = newValue; // 새로운 선택값으로 상태를 업데이트 함.
                              },
                              items: colorOptions.asMap().entries.map((entry) {
                                int idx = entry.key; // 색상 옵션의 인덱스
                                Map<String, dynamic> color = entry.value; // 색상 옵션의 데이터
                                return DropdownMenuItem<int>(
                                  value: idx,
                                  child: Row(
                                    children: [
                                      Image.network(color['url'], width: 20, height: 20), // 색상을 나타내는 이미지
                                      SizedBox(width: 8), // 이미지와 텍스트 사이의 간격
                                      Text(color['text']), // 색상의 텍스트 설명
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10), // '색상' 드롭다운과 '사이즈' 드롭다운 사이의 간격
                      // '사이즈' 선택을 위한 드롭다운 메뉴
                      Row( // '색상' 텍스트와 DropdownButton을 가로로 배열하기 위해 Row 위젯 사용
                        mainAxisAlignment: MainAxisAlignment.start, // 항목들을 시작 지점(왼쪽)으로 정렬
                        children: [
                          Text('사이즈', style: TextStyle(fontSize: 14)), // '사이즈' 라벨을 표시함.
                          SizedBox(width: 52), // '색상' 텍스트와 DropdownButton 사이에 50의 간격 추가
                          Expanded( // DropdownButton을 확장하여 나머지 공간을 차지하도록 함.
                            child: DropdownButton<String>(
                              isExpanded: true, // 드롭다운의 너비를 부모 컨테이너에 맞춤
                              value: selectedSize.state, // 현재 선택된 '사이즈'
                              hint: Text('- [필수] 옵션을 선택해 주세요 -'), // 선택하지 않았을 때 보이는 안내 메시지
                              onChanged: (newValue) {
                                selectedSize.state = newValue; // 새로운 선택값으로 상태를 업데이트 함.
                              },
                              items: sizes.map<DropdownMenuItem<String>>((String size) {
                                return DropdownMenuItem<String>(
                                  value: size, // 사이즈 옵션의 값
                                  child: Text(size), // 사이즈 옵션을 표시하는 텍스트
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                loading: () => CircularProgressIndicator(), // 데이터를 로딩 중일 때 표시할 위젯
                error: (error, stack) => Text('오류 발생: $error'), // 오류가 발생했을 때 표시할 위젯
              ),
            ),
            SizedBox(height: 30), // '사이즈' 드롭다운과 '수량 체크 및 가격' 사이의 간격
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20), // 선의 좌우 간격을 20으로 설정
              child: Divider(), // 선 추가
            ),
            SizedBox(height: 10), // '수량 체크 및 가격'과 '결제금액' 사이의 간격

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20), // 선의 좌우 간격을 20으로 설정
              child: Divider(), // 선 추가
            ),

            SizedBox(height: 30), // '사이즈' 드롭다운과 '장바구니 및 구매' 버튼 사이의 간격
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0), // 좌우 여백 설정
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 버튼을 화면 양쪽 끝으로 정렬
                children: [
                  Expanded( // '장바구니에 추가' 버튼
                    child: ElevatedButton(
                      onPressed: () {
                        // '장바구니에 추가' 버튼 클릭 시 수행될 로직
                        // 예: 장바구니에 제품 추가 로직 구현
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BUTTON_COLOR, // 버튼 배경색 설정
                        foregroundColor: INPUT_BG_COLOR, // 버튼 텍스트 색상 설정
                      ),
                      child: Text('장바구니'),
                    ),
                  ),
                  SizedBox(width: 10), // 버튼 사이의 간격 설정
                  Expanded( // '바로 구매' 버튼
                    child: ElevatedButton(
                      onPressed: () {
                        // '바로 구매' 버튼 클릭 시 수행될 로직
                        // 예: 결제 페이지로 이동하는 로직 구현
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BUTTON_COLOR, // 버튼 배경색 설정
                        foregroundColor: INPUT_BG_COLOR, // 버튼 텍스트 색상 설정
                      ),
                      child: Text('주문'),
                    ),
                  ),
                ],
              ),
            )



          ],
        ),
      ),
      // buildCommonBottomNavigationBar 함수 호출 시 context 인자 추가
      bottomNavigationBar: buildCommonBottomNavigationBar(tabIndex, ref, context),
      drawer: buildCommonDrawer(context), // 드로어 메뉴, 공통 구성 함수 호출
    );
  }
}