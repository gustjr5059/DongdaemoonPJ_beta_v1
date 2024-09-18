
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../common/layout/common_exception_parts_of_body_layout.dart';
import '../../product/layout/product_body_parts_layout.dart';
import '../../product/model/product_model.dart';
import '../provider/order_all_providers.dart';
import '../view/complete_payment_screen.dart';
import '../view/order_detail_list_screen.dart';


// ------- 발주 화면 내 발주자 정보 관련 UI 내용을 구현하는 UserInfoWidget 클래스 내용 시작
// UserInfoWidget 클래스는 구매자의 정보를 화면에 표시하는 역할을 담당.
class UserInfoWidget extends ConsumerWidget {
  final String email; // 이메일 정보를 저장하는 필드

  UserInfoWidget({required this.email}); // 생성자에서 이메일을 받아옴

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치를 설정함

    // 업데이트 요청 화면 내 요소들의 수치 설정
    final double updateRequirePadding =
        screenSize.width * (32 / referenceWidth);
    final double ordererInfoTitleFontSize =
        screenSize.height * (18 / referenceHeight);
    final double updateRequireNoticeFontSize1 =
        screenSize.height * (12 / referenceHeight);
    final double updateRequireNoticeFontSize2 =
        screenSize.height * (10 / referenceHeight);

    final double ordererInfo1Y =
        screenSize.height * (16 / referenceHeight);
    final double ordererInfo2Y =
        screenSize.height * (24 / referenceHeight);
    final double ordererInfo3Y =
        screenSize.height * (8 / referenceHeight);


    final userInfoAsyncValue = ref.watch(
        userInfoProvider(email)); // Riverpod을 사용하여 사용자 정보 프로바이더를 구독

    return userInfoAsyncValue.when(
      data: (userInfo) {
        // userInfo가 null인 경우에도 표를 유지하고, 데이터 필드에 '-'를 표시
        final name = userInfo?['name'] ?? '-';
        final email = userInfo?['email'] ?? '-';
        final phoneNumber = userInfo?['phone_number'] ?? '-';

        // // 휴대폰 번호 입력 필드에 사용할 컨트롤러 생성
        // // 파이어베이스 내 휴대폰 번호 데이터가 있을 시, 불러오고 없으면 직접 입력 부분이 바로 구현
        // // 휴대폰 번호를 불러온 경우에도 커서를 갖다대면 직접 입력 부분이 활성화
        // TextEditingController phoneNumberController = TextEditingController(
        //     text: phoneNumber);

        return Padding(
          padding: EdgeInsets.only(left: updateRequirePadding, right: updateRequirePadding, top: updateRequirePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
            mainAxisSize: MainAxisSize.min, // 부모의 제약 조건을 준수하도록 설정
            children: [
              Text(
                '발주자 정보', // 발주자 정보 제목 텍스트
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: ordererInfoTitleFontSize,
                  fontWeight: FontWeight.bold, // 텍스트 굵게 설정
                  color: Colors.black,
                ),
              ),
              SizedBox(height: ordererInfo1Y),
              // _buildInfoRow를 사용하여 이름과 이메일 정보를 표시
              _buildInfoRow(context, '이름', name),
              _buildInfoRow(context, '이메일', email),
              _buildInfoRow(context, '휴대폰 번호', phoneNumber),
              // // 수정 가능한 휴대폰 번호 행 추가
              // _buildEditablePhoneNumberRow(context, '휴대폰 번호', phoneNumberController),
              SizedBox(height: ordererInfo2Y),
              Text(
                '[연락처 미입력으로 인한 불이익시 당사가 책임지지 않습니다.]', // 안내문 텍스트
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: updateRequireNoticeFontSize1,
                  color: Color(0xFF585858),
                  fontWeight: FontWeight.bold, // 텍스트 색상을 회색으로 설정
                ),
              ),
              SizedBox(height: ordererInfo3Y),
              Text(
                '* 해당 정보의 변경이 필요할 시, 로그인 화면 내 회원가입 절차를 통해 변경된 내용으로 재전송 해주세요.',
                // 안내문 텍스트
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: updateRequireNoticeFontSize2, // 텍스트 크기 12
                  color: Color(0xFF585858),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()), // 로딩 상태 처리
      error: (error, stack) => Center(child: Text('Error: $error')), // 에러 상태 처리
    );
  }

  // 각 정보 행을 구성하는 함수
  Widget _buildInfoRow(BuildContext context, String label, String value) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 발주자 정보 표 부분 수치
    final double ordererInfoTextFontSize =
        screenSize.height * (13 / referenceHeight);
    final double ordererInfoDataFontSize =
        screenSize.height * (12 / referenceHeight);
    final double ordererInfoTextPartWidth =
        screenSize.width * (97 / referenceWidth);
    final double ordererInfoTextPartHeight =
        screenSize.height * (30 / referenceHeight);
    // 행 간 간격 수치
    final double ordererInfo4Y =
        screenSize.height * (2 / referenceHeight);
    final double ordererInfo5Y =
        screenSize.height * (4 / referenceHeight);
    // 데이터 부분 패딩 수치
    final double ordererInfoDataPartX =
        screenSize.width * (8 / referenceWidth);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: ordererInfo4Y),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
          children: [
            Container(
              height: ordererInfoTextPartHeight,
              width: ordererInfoTextPartWidth,
              // 라벨 셀의 너비 설정
              color: Color(0xFFF2F2F2),
              // color: Colors.green,
              // 배경 색상 설정
              alignment: Alignment.center,
              // 텍스트 정렬
              child: Text(
                label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NanumGothic',
                    fontSize: ordererInfoTextFontSize,
                    color: Colors.black,
                ), // 텍스트 스타일 설정
              ),
            ),
            SizedBox(width: ordererInfo5Y), // 왼쪽과 오른쪽 사이 간격 추가
            Expanded(
              child: Container(
                color: Color(0xFFFBFBFB), // 배경 색상 설정
              // color: Colors.red, // 배경 색상 설정
                padding: EdgeInsets.only(left: ordererInfoDataPartX),
                alignment: Alignment.centerLeft, // 텍스트 정렬
                child: Text(value,
                  style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: ordererInfoDataFontSize,
                    color: Colors.black,
                  ),
                ), // 값 표시
              ),
            ),
          ],
        ),
      ),
    );
  }

// // 수정된 _buildEditablePhoneNumberRow 함수
//   Widget _buildEditablePhoneNumberRow(BuildContext context, String label,
//       TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0), // 위아래 간격 추가
//       child: IntrinsicHeight(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
//           children: [
//             Container(
//               width: 100,
//               // 라벨 셀의 너비 설정
//               color: Colors.grey.shade200,
//               // 배경 색상 설정
//               padding: const EdgeInsets.all(8.0),
//               // 패딩 설정
//               alignment: Alignment.topLeft,
//               // 텍스트 정렬
//               child: Text(
//                 label,
//                 style: TextStyle(fontWeight: FontWeight.bold), // 텍스트 스타일 설정
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 color: Colors.white, // 배경 색상 설정
//                 padding: const EdgeInsets.all(8.0), // 패딩 설정
//                 child: TextField(
//                   controller: controller, // 휴대폰 번호 입력 컨트롤러 설정
//                   style: TextStyle(fontSize: 14), // 텍스트 스타일 설정
//                   decoration: InputDecoration(
//                     hintText: "'-'을 붙여서 기입해주세요.",
//                     // 힌트 텍스트 설정
//                     hintStyle: TextStyle(color: Colors.grey.shade400),
//                     // 힌트 텍스트 색상 설정
//                     border: InputBorder.none,
//                     // 입력 경계선 제거
//                     isDense: true,
//                     // 간격 설정
//                     contentPadding: EdgeInsets.zero, // 내용 여백 제거
//                   ),
//                   maxLines: 1, // 최대 줄 수 설정
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
}
// ------ 발주 화면 내 발주자 정보 관련 UI 내용을 구현하는 UserInfoWidget 클래스 내용 끝

// ------- 발주 화면 내 업데이트 안내 정보 관련 UI 내용을 구현하는 UpdateInfoWidget 클래스 내용 시작
// UpdateInfoWidget 클래스는 결제 방법 정보를 화면에 표시하는 역할을 담당.
class UpdateInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치를 설정함

    // 업데이트 요청 화면 내 요소들의 수치 설정
    final double updateRequirePaddingX =
        screenSize.width * (24 / referenceWidth);
    final double updateRequirePaddingY =
        screenSize.height * (60 / referenceHeight);
    final double updateInfoTitleFontSize =
        screenSize.height * (18 / referenceHeight);
    final double updateRequireNoticeFontSize1 =
        screenSize.height * (14 / referenceHeight);

    final double updateInfo1Y =
        screenSize.height * (12 / referenceHeight);
    final double updateInfo2Y =
        screenSize.height * (10 / referenceHeight);

    return Padding(
      padding: EdgeInsets.only(left: updateRequirePaddingX, right: updateRequirePaddingX, top: updateRequirePaddingY),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
        children: [
          Text(
            '업데이트 정보', // 결제 방법 제목 텍스트
            style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: updateInfoTitleFontSize,
              fontWeight: FontWeight.bold, // 텍스트 굵게 설정
              color: Colors.black,
            ),
          ),
          SizedBox(height: updateInfo1Y),
          Text(
            "* 품목별로 유통사 재고 확인 후 별도 안내 예정입니다.", // 설명 텍스트
            style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: updateRequireNoticeFontSize1,
              // fontWeight: FontWeight.bold, // 텍스트 굵게 설정
              color: Colors.black,
            ),
          ),
          SizedBox(height: updateInfo2Y),
          Text(
            "* 해당 요청 품목은 1~2일 소요될 수 있습니다.", // 설명 텍스트
            style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: updateRequireNoticeFontSize1,
              // fontWeight: FontWeight.bold, // 텍스트 굵게 설정
              color: Colors.black,
            ),
          ),
          SizedBox(height: updateInfo2Y),
          Text(
            "* 어플에 업로드 할 가격은 꾸띠르 카카오톡 채널을 통해 소통할 예정입니다.", // 설명 텍스트
            style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: updateRequireNoticeFontSize1,
              // fontWeight: FontWeight.bold, // 텍스트 굵게 설정
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
// ------ 발주 화면 내 결제 방법 정보 관련 UI 내용을 구현하는 UpdateInfoWidget 클래스 내용 끝

// ------- 업데이트 요청 버튼을 구성하는 UI 관련 UpdateOrderButton 클래스 내용 시작 부분
class UpdateOrderButton extends ConsumerWidget {
  final Map<String, dynamic> ordererInfo; // 발주자 정보
  final List<ProductContent> orderItems; // 주문 상품 목록

  UpdateOrderButton({
    required this.ordererInfo, // 생성자에서 발주자 정보를 받아옴
    required this.orderItems, // 생성자에서 주문 상품 목록을 받아옴
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치를 설정함

    // 버튼 관련 수치 동적 적용
    final double updateRequireBtn1X = screenSize.width * (15 / referenceWidth);
    final double updateRequireBtn1Y = screenSize.height * (70 / referenceHeight);
    final double updateRequireBtn2Y = screenSize.height * (50 / referenceHeight);
    final double updateRequireBtnFontSize = screenSize.height * (16 / referenceHeight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // 자식 위젯들을 중앙 정렬
      children: [
        SizedBox(height: updateRequireBtn1Y), // 알림 텍스트와 버튼 사이에 여백 추가
        Center( // '결제하기' 버튼을 중앙에 위치시킴
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Color(0xFF6FAD96), // 버튼 텍스트 색상 설정
              backgroundColor: Color(0xFF6FAD96),  // 버튼 배경 색상 설정
              side: BorderSide(color: Color(0xFF6FAD96),), // 버튼 테두리 색상 설정
              padding: EdgeInsets.symmetric(vertical: updateRequireBtn1X, horizontal: updateRequireBtn2Y), // 패딩을 늘려 버튼 크기를 조정
            ),
            onPressed: () async {
              // 쪽지 삭제 버튼 클릭 시 확인 다이얼로그를 표시함
              await showSubmitAlertDialog(
                context,
                title: '[업데이트 요청]', // 다이얼로그 제목 설정
                content: '업데이트를 요청하시면 1~2일 소요될 수 있습니다.\n품목별로 유통사 재고 확인 후 별도 안내하겠습니다.', // 다이얼로그 내용 설정
                actions: buildAlertActions(
                  context,
                  noText: '아니요', // 아니요 버튼 텍스트 설정
                  yesText: '예', // 예 버튼 텍스트 설정
                  noTextStyle: TextStyle(
                    fontFamily: 'NanumGothic',
                    color: Colors.black, // 아니요 버튼 텍스트 색상 설정
                    fontWeight: FontWeight.bold, // 아니요 버튼 텍스트 굵기 설정
                  ),
                  yesTextStyle: TextStyle(
                    fontFamily: 'NanumGothic',
                    color: Colors.red, // 예 버튼 텍스트 색상 설정
                    fontWeight: FontWeight.bold, // 예 버튼 텍스트 굵기 설정
                  ),
                  onYesPressed: () async {
                    try{
                      // 발주 요청을 보내고 결과로 발주 ID를 받아옴
                      final orderId = await ref.read(placeOrderProvider(PlaceOrderParams(
                        ordererInfo: ordererInfo, // 발주자 정보
                        productInfo: orderItems, // 상품 정보 리스트
                      )).future);

                      Navigator.of(context).pop(); // 다이얼로그 닫기
                      // // 발주 완료 메시지를 스낵바로 표시
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('업데이트 요청이 완료되었습니다. 이메일이 전송되었습니다.')));
                      // navigateToScreenAndRemoveUntil 함수를 사용하여 발주완료 화면으로 이동
                      navigateToScreenAndRemoveUntil(
                        context,
                        ref,
                        CompletePaymentScreen(orderId: orderId), // 발주 ID를 전달
                        4, // 탭 인덱스 업데이트 (하단 탭 바 내 4개 버튼 모두 비활성화)
                      );
                    } catch (e) {
                      showCustomSnackBar(context, '업데이트 요청 중 오류가 발생했습니다: $e'); // 오류 메시지 표시
                    }
                  },
                ),
              );
            },
            child: Text('업데이트 요청하기',
                style: TextStyle(
                    fontSize: updateRequireBtnFontSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NanumGothic',
                    color: Theme.of(context).scaffoldBackgroundColor,
                ),
            ), // 버튼 텍스트 설정
          ),
        ),
      ],
    );
  }
}
// ------- 업데이트 요청 버튼을 구성하는 UI 관련 UpdateOrderButton 클래스 내용 끝 부분

// // ------- 상품 상세 화면과 장바구니 화면에서 상품 데이터를 발주 화면으로 전달되는 부분을 UI로 구현한 OrderItemWidget 클래스 내용 시작
// // OrderItemWidget 클래스는 상품의 상세 정보를 화면에 표시하는 역할을 담당.
// class OrderItemWidget extends StatelessWidget {
//   final ProductContent product; // 상품 정보를 저장하는 필드
//
//   OrderItemWidget({required this.product}); // 생성자에서 상품 정보를 받아옴
//
//   @override
//   Widget build(BuildContext context) {
//     final numberFormat = NumberFormat('###,###'); // 숫자를 포맷하기 위한 NumberFormat 객체 생성
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0), // 카드 내부 여백 설정
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
//           children: [
//             if (product.briefIntroduction != null) // briefIntroduction가 null이 아닌 경우에만 표시
//               Text(
//                 product.briefIntroduction!,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // 글자 크기 18, 굵게 설정
//               ),
//             if (product.productNumber != null) // productNumber가 null이 아닌 경우에만 표시
//               Text(
//                 '상품번호: ${product.productNumber}', // productNumber 내용을 표시
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // 글자 크기를 14로 설정
//               ),
//             SizedBox(height: 8), // 텍스트와 이미지 사이에 8 픽셀 높이의 여백 추가
//             Row(
//               children: [
//                 if (product.thumbnail != null) // thumbnail이 null이 아닌 경우에만 표시
//                   Image.network(
//                     product.thumbnail!,
//                     height: 100, // 이미지 높이 100 픽셀
//                     width: 100, // 이미지 너비 100 픽셀
//                     fit: BoxFit.cover, // 이미지를 잘라서 맞춤
//                   ),
//                 SizedBox(width: 8), // 이미지와 텍스트 사이에 8 픽셀 너비의 여백 추가
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
//                   children: [
//                     Text(
//                       '${numberFormat.format(product.originalPrice)}원',
//                       style: TextStyle(
//                         fontSize: 14, // 글자 크기 14
//                         color: Colors.grey[500], // 글자 색상 회색
//                         decoration: TextDecoration.lineThrough, // 취소선 스타일 적용
//                       ),
//                     ),
//                     Text(
//                       '${numberFormat.format(product.discountPrice)}원',
//                       style: TextStyle(
//                         fontSize: 18, // 글자 크기 18
//                         fontWeight: FontWeight.bold, // 글자 굵게 설정
//                       ),
//                     ),
//                     Text(
//                       '${product.discountPercent?.round()}%',
//                       style: TextStyle(
//                         fontSize: 18, // 글자 크기 18
//                         color: Colors.red, // 글자 색상 빨간색
//                         fontWeight: FontWeight.bold, // 글자 굵게 설정
//                       ),
//                     ),
//                     if (product.selectedColorImage != null) // selectedColorImage가 null이 아닌 경우에만 표시
//                       Image.network(
//                         product.selectedColorImage!,
//                         height: 20, // 이미지 높이 20 픽셀
//                         width: 20, // 이미지 너비 20 픽셀
//                         fit: BoxFit.cover, // 이미지를 잘라서 맞춤
//                       ),
//                     Text('색상: ${product.selectedColorText}'), // 색상 텍스트 표시
//                     Text('사이즈: ${product.selectedSize}'), // 사이즈 텍스트 표시
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // ------ 상품 상세 화면과 장바구니 화면에서 상품 데이터를 발주 화면으로 전달되는 부분을 UI로 구현한 OrderItemWidget 클래스 내용 끝

// ------ 발주 목록 화면 내 발주 리스트 아이템을 표시하는 위젯 클래스인 OrderListItemWidget 내용 시작
class OrderListItemWidget extends ConsumerWidget {
  // 발주 데이터를 담고 있는 맵 객체를 멤버 변수로 선언.
  final Map<String, dynamic>? order;

  // 생성자를 통해 발주 데이터를 초기화.
  OrderListItemWidget({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 발주내역이 비어있는 경우의 알림 부분 수치
    final double orderlistEmptyTextWidth =
        screenSize.width * (170 / referenceWidth); // 가로 비율
    final double orderlistEmptyTextHeight =
        screenSize.height * (22 / referenceHeight); // 세로 비율
    final double orderlistEmptyTextX =
        screenSize.width * (140 / referenceWidth); // 가로 비율
    final double orderlistEmptyTextY =
        screenSize.height * (300 / referenceHeight); // 세로 비율
    final double orderlistEmptyTextFontSize =
        screenSize.height * (16 / referenceHeight);

    // 발주 데이터가 없는 경우 '발주 내역이 없습니다.' 메시지 표시
    if (order == null || order!.isEmpty) {
      return Container(
        width: orderlistEmptyTextWidth,
        height: orderlistEmptyTextHeight,
        margin: EdgeInsets.only(left: orderlistEmptyTextX, top: orderlistEmptyTextY),
        child: Text('발주 내역이 없습니다.',
          style: TextStyle(
            fontSize: orderlistEmptyTextFontSize,
            fontFamily: 'NanumGothic',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    }

    // 날짜 포맷을 지정.
    final dateFormat = DateFormat('yyyy-MM-dd');
    // 발주일자를 타임스탬프에서 DateTime 객체로 변환.
    final orderDate = (order!['numberInfo']['order_date'] as Timestamp).toDate();
    // 발주번호를 가져옴.
    final orderNumber = order!['numberInfo']['order_number'];

    // 공통 카드 뷰 위젯을 사용하여 발주 아이템을 표시.
    return CommonCardView(
      // 카드 배경색을 지정.
      backgroundColor: BEIGE_COLOR,
      // 카드 내용으로 컬럼을 배치.
      content: Column(
        // 자식 위젯들을 왼쪽 정렬.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              // 발주일자를 텍스트로 표시.
          Text(
            '발주일자: ${orderDate != null ? dateFormat.format(orderDate) : '에러 발생'}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // 여백을 추가.
          SizedBox(height: 8),
          // 발주번호를 텍스트로 표시.
          Text(
            '발주번호: $orderNumber',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          // 여백을 추가.
          SizedBox(height: 8),
          // 버튼을 가운데 배치.
          Center(
            child: Row( // Row 위젯을 자식으로 설정함
              children: [ // Row 위젯의 자식 위젯 목록을 설정함
                Expanded( // 버튼이 남은 공간을 차지하도록 Expanded 위젯을 사용함
                  child: ElevatedButton( // ElevatedButton 위젯을 사용하여 버튼을 생성함
                    onPressed: () { // 버튼이 눌렸을 때 실행될 함수를 정의함
                      Navigator.push( // 새 화면으로 전환하기 위해 Navigator.push를 호출함
                        context, // 현재 화면의 컨텍스트를 전달함
                        MaterialPageRoute( // 새로운 화면으로 전환하기 위한 MaterialPageRoute를 생성함
                          builder: (context) => // 새 화면을 빌드할 함수를 전달함
                          OrderListDetailScreen(orderNumber: orderNumber), // OrderListDetailScreen을 생성하고, orderNumber를 전달함
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom( // 버튼의 스타일을 설정함
                      foregroundColor: BUTTON_COLOR, // 버튼의 글자 색상을 설정함
                      backgroundColor: BACKGROUND_COLOR, // 버튼의 배경 색상을 설정함
                      side: BorderSide(color: BUTTON_COLOR), // 버튼의 테두리 색상을 설정함
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30), // 버튼의 내부 여백을 설정함
                    ),
                    child: Text( // 버튼에 표시될 텍스트를 정의함
                      '발주 내역 상세보기', // 텍스트 내용으로 '발주 내역 상세보기'를 설정함
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // 텍스트의 스타일을 설정함
                    ),
                  ),
                ),
                SizedBox(width: 8), // 버튼 사이에 8픽셀의 간격을 추가함
                ElevatedButton( // 두 번째 ElevatedButton 위젯을 생성함
                  onPressed: () async { // 비동기 함수로 버튼이 눌렸을 때 실행될 함수를 정의함
                    await showSubmitAlertDialog( // 알림 대화상자를 표시하기 위해 showSubmitAlertDialog를 호출함
                      context, // 현재 화면의 컨텍스트를 전달함
                      title: '발주 내역 삭제', // 대화상자의 제목으로 '발주 내역 삭제'를 설정함
                      content: '발주 내역을 삭제하시면 해당 발주 내역은 영구적으로 삭제됩니다.\n작성하신 발주 내역을 삭제하시겠습니까?', // 대화상자의 내용으로 경고 메시지를 설정함
                      actions: buildAlertActions( // 대화상자에 표시될 액션 버튼들을 설정함
                        context, // 현재 화면의 컨텍스트를 전달함
                        noText: '아니요', // '아니요' 버튼의 텍스트를 설정함
                        yesText: '예', // '예' 버튼의 텍스트를 설정함
                        noTextStyle: TextStyle( // '아니요' 버튼의 텍스트 스타일을 설정함
                          color: Colors.black, // '아니요' 버튼의 글자 색상을 검정색으로 설정함
                          fontWeight: FontWeight.bold, // '아니요' 버튼의 글자 굵기를 굵게 설정함
                        ),
                        yesTextStyle: TextStyle( // '예' 버튼의 텍스트 스타일을 설정함
                          color: Colors.red, // '예' 버튼의 글자 색상을 빨간색으로 설정함
                          fontWeight: FontWeight.bold, // '예' 버튼의 글자 굵기를 굵게 설정함
                        ),
                        onYesPressed: () async { // '예' 버튼이 눌렸을 때 실행될 비동기 함수를 정의함
                          try {
                            await ref.read(deleteOrderProvider({ // deleteOrderProvider를 호출하여 발주 내역을 삭제함
                              'orderNumber': orderNumber, // 발주 번호를 전달함
                            }).future);
                            Navigator.of(context).pop(); // 성공적으로 삭제된 후 대화상자를 닫음
                            showCustomSnackBar(context, '발주 내역이 삭제되었습니다.'); // 삭제 성공 메시지를 스낵바로 표시함(성공 메시지 텍스트를 설정함)
                          } catch (e) { // 삭제 중 오류가 발생했을 때의 예외 처리를 정의함
                            showCustomSnackBar(context, '발주 내역 삭제 중 오류가 발생했습니다: $e'); // 오류 메시지를 스낵바로 표시함
                          }
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom( // 두 번째 버튼의 스타일을 설정함
                    foregroundColor: BUTTON_COLOR, // 두 번째 버튼의 글자 색상을 설정함
                    backgroundColor: BACKGROUND_COLOR, // 두 번째 버튼의 배경 색상을 설정함
                    side: BorderSide(color: BUTTON_COLOR), // 두 번째 버튼의 테두리 색상을 설정함
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30), // 두 번째 버튼의 내부 여백을 설정함
                  ),
                  child: Text( // 두 번째 버튼에 표시될 텍스트를 정의함
                    '삭제', // 텍스트 내용으로 '삭제'를 설정함
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // 텍스트의 스타일을 설정함
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// ------ 발주 목록 화면 내 발주 리스트 아이템을 표시하는 위젯 클래스인 OrderListItemWidget 내용 끝

// 발주 목록 상세 화면 내 발주 목록 상세 내용을 표시하는 위젯 클래스인 OrderListDetailItemWidget 시작
class OrderListDetailItemWidget extends ConsumerStatefulWidget {
  // 발주 데이터를 담고 있는 Map<String, dynamic> 형태의 order 필드를 선언
  final Map<String, dynamic>? order;

  // 생성자에서 order 필드를 필수로 받도록 설정함
  OrderListDetailItemWidget({required this.order});

  // 위젯의 상태를 생성하는 메서드를 오버라이드함
  @override
  _OrderListDetailItemWidgetState createState() =>
      _OrderListDetailItemWidgetState();
}

// 위젯의 상태를 정의하는 클래스 _OrderListDetailItemWidgetState 시작
class _OrderListDetailItemWidgetState
    extends ConsumerState<OrderListDetailItemWidget> {
  @override
  Widget build(BuildContext context) {
    // order가 null이거나 비어있으면 발주 데이터를 불러올 수 없음을 알리는 메시지를 화면에 표시함
    if (widget.order == null || widget.order!.isEmpty) {
      return Center(
        child: Text('발주 데이터를 불러올 수 없습니다.'),
      );
    }

    // 날짜 형식을 'yyyy-MM-dd'로 지정함
    final dateFormat = DateFormat('yyyy-MM-dd');

    // order 정보에서 발주 날짜를 가져오고, 값이 유효하면 Timestamp를 DateTime으로 변환함
    final orderDate = widget.order!['numberInfo']['order_date']
        ?.toString()
        .isNotEmpty ==
        true
        ? (widget.order!['numberInfo']['order_date'] as Timestamp).toDate()
        : null;

    // order 정보에서 발주 번호를 가져오고, 값이 유효하지 않으면 '에러 발생'을 반환함
    final orderNumber = widget.order!['numberInfo']['order_number']
        ?.toString()
        .isNotEmpty ==
        true
        ? widget.order!['numberInfo']['order_number']
        : '에러 발생';

    // 숫자 형식을 '###,###'로 지정함
    final numberFormat = NumberFormat('###,###');

    // productInfo 리스트를 가져와서 해당 발주번호 관련 상품별로 productInfo 데이터를 구현 가능하도록 하는 로직
    final List<dynamic> productInfoList = widget.order!['productInfo'] ?? [];

    // ProductInfoDetailScreenNavigation 인스턴스를 생성하여 상품 상세 화면으로 이동할 수 있도록 설정함
    final navigatorProductDetailScreen =
    ProductInfoDetailScreenNavigation(ref);

    // 발주 상세 정보를 화면에 렌더링하는 위젯을 구성함
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 발주 날짜와 발주 번호, 결제 완료일을 표시하는 섹션
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 발주 일자를 표시
              Text(
                '발주일자: ${orderDate != null ? dateFormat.format(orderDate) : '에러 발생'}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              // 발주 번호를 표시
              Text(
                '발주번호: $orderNumber',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        // 각 상품 정보를 표시하는 로직을 반복문으로 구성함
        for (var productInfo in productInfoList)
          CommonCardView(
            backgroundColor: BEIGE_COLOR,
            content: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상품 번호와 간략 소개를 표시하는 _buildProductInfoRow 함수 호출
                  _buildProductInfoRow(
                      productInfo['product_number']?.toString().isNotEmpty ==
                          true
                          ? productInfo['product_number']
                          : '에러 발생',
                      '',
                      bold: true,
                      fontSize: 14),
                  _buildProductInfoRow(
                      productInfo['brief_introduction']
                          ?.toString()
                          .isNotEmpty ==
                          true
                          ? productInfo['brief_introduction']
                          : '에러 발생',
                      '',
                      bold: true,
                      fontSize: 18),
                  SizedBox(height: 8),
                  // 새로운 흰색 카드뷰 섹션을 추가함
                  GestureDetector(
                    onTap: () {
                      // 상품 상세 화면으로 이동함
                      final product = ProductContent(
                        docId: productInfo['product_id'] ?? '',
                        category: productInfo['category']?.toString() ??
                            '에러 발생',
                        productNumber: productInfo['product_number']
                            ?.toString() ??
                            '에러 발생',
                        thumbnail:
                        productInfo['thumbnails']?.toString() ?? '',
                        briefIntroduction: productInfo['brief_introduction']
                            ?.toString() ??
                            '에러 발생',
                        originalPrice: productInfo['original_price'] ?? 0,
                        discountPrice: productInfo['discount_price'] ?? 0,
                        discountPercent: productInfo['discount_percent'] ?? 0,
                      );
                      navigatorProductDetailScreen.navigateToDetailScreen(
                          context, product);
                    },
                    child: CommonCardView(
                      backgroundColor: Colors.white, // 배경색을 흰색으로 설정함
                      content: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 상품의 썸네일 이미지와 가격 정보를 표시하는 행
                            Row(
                              children: [
                                // 썸네일 이미지를 표시하고, 없을 경우 대체 아이콘 표시
                                Expanded(
                                    flex: 3,
                                    child: productInfo['thumbnails']
                                        ?.toString()
                                        .isNotEmpty ==
                                        true
                                        ? Image.network(productInfo['thumbnails'],
                                        fit: BoxFit.cover)
                                        : Icon(Icons.image_not_supported)),
                                SizedBox(width: 8),
                                // 상품의 가격, 색상, 사이즈, 수량 정보를 표시
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${numberFormat.format(productInfo['original_price']?.toString().isNotEmpty == true ? productInfo['original_price'] as num : 0.0)} 원',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14,
                                          decoration:
                                          TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${numberFormat.format(productInfo['discount_price']?.toString().isNotEmpty == true ? productInfo['discount_price'] as num : 0.0)} 원',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            '${(productInfo['discount_percent']?.toString().isNotEmpty == true ? productInfo['discount_percent'] as num : 0.0).toInt()}%',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          // 선택된 색상 이미지를 표시하고, 없을 경우 대체 아이콘 표시
                                          productInfo['selected_color_image']
                                              ?.toString()
                                              .isNotEmpty ==
                                              true
                                              ? Image.network(
                                            productInfo[
                                            'selected_color_image'],
                                            height: 18,
                                            width: 18,
                                            fit: BoxFit.cover,
                                          )
                                              : Icon(
                                              Icons.image_not_supported,
                                              size: 20),
                                          SizedBox(width: 8),
                                          // 선택된 색상 텍스트를 표시
                                          Text(
                                            productInfo['selected_color_text']
                                                ?.toString()
                                                .isNotEmpty ==
                                                true
                                                ? productInfo[
                                            'selected_color_text']
                                                : '에러 발생',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      // 선택된 사이즈와 수량을 표시
                                      Text(
                                          '사이즈: ${productInfo['selected_size']?.toString().isNotEmpty == true ? productInfo['selected_size'] : '에러 발생'}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
       ],
    );
  }
}
// 발주 목록 상세 화면 내 발주 목록 상세 내용을 표시하는 위젯 클래스인 OrderListDetailItemWidget 끝

// 상품 정보를 표시하는 행을 구성하는 함수
Widget _buildProductInfoRow(String label, String value,
    {bool bold = false, double fontSize = 16}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 라벨을 표시하는 텍스트
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        // 값을 표시하는 텍스트 (말줄임 표시와 줄바꿈 가능)
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.end,
            softWrap: true, // 텍스트가 한 줄을 넘길 때 자동으로 줄바꿈이 되도록 설정함
            overflow: TextOverflow.ellipsis, // 텍스트가 길 경우 말줄임 표시
          ),
        ),
      ],
    ),
  );
}
