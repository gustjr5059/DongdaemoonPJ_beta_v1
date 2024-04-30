
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리를 위한 패키지
import '../../../common/layout/common_exception_parts_of_body_layout.dart';
import '../../layout/product_body_parts_layout.dart';
import '../../provider/product_future_provider.dart';


// 제품 상세 페이지를 나타내는 위젯 클래스, Riverpod의 ConsumerWidget을 상속받아 상태 관리 가능
class CoatDetailProductScreen extends ConsumerWidget {
  final String docId; // 문서 ID를 저장할 변수 선언
  const CoatDetailProductScreen({Key? key, required this.docId}) : super(key: key); // 생성자 수정

  // // 이미지의 크기를 비동기적으로 가져오는 함수
  // Future<Size> _getImageSize(String imageUrl) async {
  //   Image image = Image.network(imageUrl);
  //   Completer<Size> completer = Completer<Size>();
  //
  //   image.image.resolve(const ImageConfiguration()).addListener(
  //     ImageStreamListener((ImageInfo image, bool synchronousCall) {
  //       var myImage = image.image;
  //       Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
  //       completer.complete(size);
  //     }),
  //   );
  //
  //   return completer.future;
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

// // pageViewWithArrows 위젯을 사용하여 이미지 슬라이더 섹션을 생성하는 코드
// // Firestore에서 가져온 데이터를 기반으로 이미지 URL 리스트를 생성하고,
// // 해당 URL 리스트를 사용하여 이미지 슬라이더를 구성함.
//     Widget pageViewSection = docData.when(
//       // 데이터가 성공적으로 로드되었을 때
//       data: (data) {
//         // Firestore 문서에서 이미지 URL을 추출하여 String 리스트로 변환
//         // 'detail_page_imageX' 필드에서 X는 1부터 5까지의 숫자로, 각 이미지의 URL을 나타냄
//         // 비어 있지 않은 URL만 필터링하여 최종 리스트를 생성합니다.
//         List<String> imageUrls = [
//           for (int i = 1; i <= 5; i++) data['detail_page_image$i'] ?? '',
//         ].where((url) => url.isNotEmpty).map<String>((url) => url).toList(); // 비어있지 않은 URL만 선택하여 리스트를 생성
//
//         // pageViewWithArrows 위젯을 반환하고, 이 위젯은 이미지 슬라이더 기능을 제공함.
//         return pageViewWithArrows(
//           context, // 현재 context
//           PageController(), // 페이지 컨트롤러를 새로 생성
//           ref, // Riverpod의 WidgetRef, 상태 관리를 위해 사용
//           coatDetailBannerPageProvider, // 현재 페이지의 인덱스를 관리하는 StateProvider(coatDetailBannerPageProvider와 분리하여 홈 화면의 배너 페이지 뷰의 페이지 인덱스와 따로 관리)
//           itemCount: imageUrls.length, // 이미지 URL 리스트의 길이, 즉 총 슬라이드 개수를 나타냄
//           itemBuilder: (BuildContext context, int index) {
//             // itemBuilder는 각 슬라이드를 구성하는 위젯을 반환합니다.
//             // 여기서는 Image.network를 사용하여 각 URL로부터 이미지를 로드하고 표시합니다.
//             // AspectRatio를 사용하여 이미지의 원본 비율을 유지합니다.
//             // FutureBuilder를 사용하여 이미지의 비율을 동적으로 계산
//             return FutureBuilder<Size>(
//               future: _getImageSize(imageUrls[index]),
//               builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
//                   // 이미지 로드 완료 및 크기 데이터가 있는 경우
//                   // 이미지의 실제 비율에 맞게 AspectRatio 위젯을 사용
//                   // BoxFit.contain을 사용하여 이미지가 공간에 꽉 차게 나오면서도 원본 비율이 유지되도록 함
//                   return AspectRatio(
//                     aspectRatio: snapshot.data!.width / snapshot.data!.height,
//                     child: Image.network(imageUrls[index], fit: BoxFit.contain),
//                   );
//                 } else {
//                   // 이미지 로딩 중 표시할 위젯
//                   return Center(child: CircularProgressIndicator());
//                 }
//               },
//             );
//           },
//         );
//       },
//       loading: () => CircularProgressIndicator(),
//       error: (error, stack) => Text('오류 발생: $error'),
//     );

// 해당 함수 내부에서 Firestore에서 상품 데이터를 불러오고 UI를 구성.
    final productContent = ref.watch(prodFirestoreDataProvider(docId));
// Firestore 데이터 제공자를 통해 특정 문서 ID(docId)의 상품 데이터를 구독.
    return Scaffold(
      // Scaffold를 사용하여 기본적인 머티리얼 디자인 레이아웃을 제공.
      appBar: buildCommonAppBar(
          context: context, title: '코트 상세', pageBackButton: true),
      // 앱바를 구성하며, '블라우스 상세'라는 제목과 페이지 뒤로 가기 버튼을 포함.
      body: productContent.when(
        // productContent의 상태에 따라 다른 위젯을 반환.
        data: (product) => buildProductDetails(context, ref, product),
        // 데이터가 있는 경우, buildProductDetails 함수를 호출하여 상품 상세 정보를 구성하고 표시.
        loading: () => CircularProgressIndicator(),
        // 데이터 로딩 중인 경우, 로딩 인디케이터를 표시.
        error: (error, _) => Text('오류 발생: $error'),
        // 오류가 발생한 경우, 오류 메시지를 화면에 표시.
      ),
    );
  }
}