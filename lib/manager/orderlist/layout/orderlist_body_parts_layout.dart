import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common/const/colors.dart';
import '../../../common/layout/common_body_parts_layout.dart';
import '../provider/orderlist_all_provider.dart';
import '../provider/orderlist_state_provider.dart';


// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 및 버튼 클릭 시, 나오는 데이터 UI 내용을 구현하는 AdminOrderListContents 클래스 시작
class AdminOrderListContents extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUserEmailsAsyncValue = ref.watch(allUserEmailsProvider);
    // 모든 사용자의 이메일 데이터를 제공하는 Provider를 구독
    final selectedUserEmail = ref.watch(selectedUserEmailProvider);
    // 선택된 사용자 이메일 데이터를 제공하는 Provider를 구독

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 리뷰 관리 화면 내 리뷰 목록 탭 내 카드뷰 섹션의 가로와 세로 비율 계산
    final double reviewInfoCardViewWidth =
        screenSize.width * (393 / referenceWidth); // 가로 비율 계산
    final double reviewInfoCardViewHeight =
        screenSize.height * (480 / referenceHeight); // 세로 비율 계산

    // body 부분 전체 패딩 수치 계산
    final double reviewInfoCardViewPaddingX = screenSize.width * (15 / referenceWidth); // 좌우 패딩 계산
    final double reviewInfoCardViewPadding1Y = screenSize.height * (10 / referenceHeight); // 상하 패딩 계산


    // 비율을 기반으로 동적으로 크기와 위치 설정
    final double reviewBtnWidth = screenSize.width * (130 / referenceWidth);
    final double reviewBtnHeight = screenSize.height * (50 / referenceHeight);
    final double reviewBtnX = screenSize.width * (12 / referenceWidth);
    final double reviewBtnY = screenSize.height * (10 / referenceHeight);
    final double reviewBtnFontSize = screenSize.height * (16 / referenceHeight);
    final double paddingX = screenSize.width * (2 / referenceWidth);
    final double reviewRecipientDropdownBtnWidth = screenSize.width * (210 / referenceWidth);
    final double reviewRecipientDropdownBtnHeight = screenSize.height * (50 / referenceHeight);

    final double reviewWriterSelectDataTextSize = screenSize.height * (16 / referenceHeight);
    final double reviewDataTextSize1 = screenSize.height * (14 / referenceHeight);
    final double reviewDataTextSize2 = screenSize.height * (16 / referenceHeight);
    final double reviewDeleteTimeDataTextSize = screenSize.height * (14 / referenceHeight);
    final double reviewStatusIconTextSize = screenSize.height * (14 / referenceHeight);
    final double orderlistDataFontSize1 =
        screenSize.height * (14 / referenceHeight);
    final double reviewDiscountPercentFontSize =
        screenSize.height * (14 / referenceHeight); // 할인 퍼센트 글꼴 크기 설정함
    final double reviewDiscountPriceFontSize =
        screenSize.height * (15 / referenceHeight); // 할인 가격 글꼴 크기 설정함
    final double reviewSelectedColorTextFontSize =
        screenSize.height * (14 / referenceHeight); // 선택된 색상 텍스트 글꼴 크기 설정함
    final double reviewSelectedSizeTextFontSize =
        screenSize.height * (14 / referenceHeight); // 선택된 사이즈 텍스트 글꼴 크기 설정함
    final double reviewSelectedCountTextFontSize =
        screenSize.height * (14 / referenceHeight); // 선택된 수량 텍스트 글꼴 크기 설정함
    // 상품 색상 이미지 크기 설정
    final double reviewSelctedColorImageDataWidth =
        screenSize.width * (16 / referenceWidth); // 색상 이미지 가로 크기 설정함
    final double reviewSelctedColorImageDataHeight =
        screenSize.width * (16 / referenceWidth); // 색상 이미지 세로 크기 설정함
    final double reviewTitleTextFontSize =
        screenSize.height * (14 / referenceHeight); // 리뷰 제목 텍스트 글꼴 크기 설정함
    final double reviewContentsTextFontSize =
        screenSize.height * (14 / referenceHeight); // 리뷰 내용 텍스트 글꼴 크기 설정함
    final double reviewWriteDateTextFontSize =
        screenSize.height * (14 / referenceHeight); // 리뷰 작성일자 텍스트 글꼴 크기 설정함
    final double reviewExpandedBtnFontSize = screenSize.height * (18 / referenceHeight); // 펼치기 및 닫기 버튼 크기

    // 삭제 버튼 수치
    final double changeBtnHeight =
        screenSize.height * (30 / referenceHeight);
    final double changeBtnWidth =
        screenSize.width * (60 / referenceWidth);
    final double changeBtnPaddingY =
        screenSize.height * (2 / referenceHeight);
    final double changeBtnPaddingX =
        screenSize.width * (4 / referenceWidth);
    final double changeBtnFontSize =
        screenSize.height * (12 / referenceHeight);

    // 컨텐츠 사이의 간격 수치
    final double interval1Y = screenSize.height * (10 / referenceHeight);
    final double interval2Y = screenSize.height * (2 / referenceHeight);
    final double interval3Y = screenSize.height * (4 / referenceHeight);
    final double interval4Y = screenSize.height * (6 / referenceHeight);
    final double interval5Y = screenSize.height * (8 / referenceHeight);
    final double interval1X = screenSize.width * (8 / referenceWidth);
    final double interval2X = screenSize.width * (19 / referenceWidth);
    final double interval3X = screenSize.width * (20 / referenceWidth);

    // 발주 내역 부분이 비어있는 경우의 알림 부분 수치
    final double orderlistEmptyTextWidth =
        screenSize.width * (260 / referenceWidth); // 가로 비율
    final double orderlistEmptyTextHeight =
        screenSize.height * (22 / referenceHeight); // 세로 비율
    final double orderlistEmptyTextX =
        screenSize.width * (50 / referenceWidth); // 가로 비율
    final double orderlistEmptyTextY =
        screenSize.height * (200 / referenceHeight); // 세로 비율
    final double orderlistEmptyTextFontSize =
        screenSize.height * (16 / referenceHeight);


    return allUserEmailsAsyncValue.when(
      data: (userEmails) {
        // 이메일 데이터를 성공적으로 가져온 경우
        if (userEmails.isEmpty) {
          // 이메일 데이터가 비어있을 경우 메시지를 표시
          return Container(
            width: orderlistEmptyTextWidth,
            height: orderlistEmptyTextHeight,
            margin: EdgeInsets.only(left: orderlistEmptyTextX, top: orderlistEmptyTextY),
            child: Text('  해당 계정이 없습니다.  ',
              style: TextStyle(
                fontSize: orderlistEmptyTextFontSize,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              hint: Text('발주자 선택'),
              // 드롭다운 버튼에 힌트 텍스트 설정
              value: selectedUserEmail.isNotEmpty ? selectedUserEmail : null,
              // 선택된 사용자 이메일이 비어있지 않으면 해당 이메일을 드롭다운 값으로 설정
              onChanged: (String? newValue) {
                // 드롭다운 값이 변경되었을 때 실행되는 콜백
                if (newValue != null) {
                  ref.read(selectedUserEmailProvider.notifier).state = newValue;
                  // 선택된 사용자 이메일 상태를 변경
                }
              },
              items: userEmails.map<DropdownMenuItem<String>>((userEmail) {
                // 이메일 데이터 리스트를 드롭다운 메뉴 아이템 리스트로 변환
                return DropdownMenuItem<String>(
                  value: userEmail,
                  child: Text(userEmail),
                  // 각 이메일 데이터를 드롭다운 메뉴 아이템으로 설정
                );
              }).toList(),
            ),
            if (selectedUserEmail.isNotEmpty) ...[
              // 선택된 이메일이 있을 경우
              Consumer(
                builder: (context, ref, child) {
                  final userOrdersAsyncValue = ref.watch(userOrdersProvider(selectedUserEmail));
                  // 선택된 사용자의 발주 데이터를 제공하는 Provider를 구독
                  return userOrdersAsyncValue.when(
                    data: (userOrders) {
                      // 발주 데이터를 성공적으로 가져온 경우
                      if (userOrders.isEmpty) {
                        // 발주 데이터가 비어있을 경우 메시지를 표시
                        return Container(
                          width: orderlistEmptyTextWidth,
                          height: orderlistEmptyTextHeight,
                          margin: EdgeInsets.only(left: orderlistEmptyTextX, top: orderlistEmptyTextY),
                          child: Text('해당 고객의 발주 내역이 없습니다.',
                            style: TextStyle(
                              fontSize: orderlistEmptyTextFontSize,
                              fontFamily: 'NanumGothic',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }

                      return Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: userOrders.map((order) {
                              // 각 발주 데이터를 UI로 변환
                              final numberInfo = order['numberInfo'] ?? {};
                              // 발주 번호 정보를 가져옴
                              final amountInfo = order['amountInfo'] ?? {};
                              // 결제 금액 정보를 가져옴
                              final ordererInfo = order['ordererInfo'] ?? {};
                              // 발주자 정보를 가져옴
                              final productInfoList = order['productInfo'] as List<dynamic>? ?? [];
                              // 제품 정보를 리스트로 가져옴

                              final formatter = NumberFormat('#,###');
                              // 숫자 포맷 설정

                              // 발주 상태 저장할 상태 프로바이더 선언
                              // (orderStatusStateProvider를 구독(subscribe)하여 그 상태를 가져오는 역할)
                              final orderStatusProvider = ref.watch(orderStatusStateProvider);
                              return CommonCardView(
                                backgroundColor: Color(0xFFF3F3F3),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('발주번호: ${numberInfo['order_number'] ?? '없음'}',
                                      style: TextStyle(
                                        fontSize: orderlistDataFontSize1, // 텍스트 크기 설정
                                        fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                        fontFamily: 'NanumGothic',
                                        color: Colors.black,
                                      ),
                                    ),
                                    // 발주 번호를 텍스트로 표시
                                    Text('발주자 이름: ${ordererInfo['name'] ?? '없음'}',
                                      style: TextStyle(
                                        fontSize: orderlistDataFontSize1, // 텍스트 크기 설정
                                        fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                        fontFamily: 'NanumGothic',
                                        color: Colors.black,
                                      ),
                                    ),
                                    // 발주자 이름을 텍스트로 표시
                                    Text('발주자 이메일: ${ordererInfo['email'] ?? '없음'}',
                                      style: TextStyle(
                                        fontSize: orderlistDataFontSize1, // 텍스트 크기 설정
                                        fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                        fontFamily: 'NanumGothic',
                                        color: Colors.black,
                                      ),
                                    ),
                                    // 발주자 이메일을 텍스트로 표시
                                    Text('발주자 연락처: ${ordererInfo['phone_number'] ?? '없음'}',
                                      style: TextStyle(
                                        fontSize: orderlistDataFontSize1, // 텍스트 크기 설정
                                        fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                        fontFamily: 'NanumGothic',
                                        color: Colors.black,
                                      ),
                                    ),
                                    // 발주자 연락처를 텍스트로 표시
                                    Divider(color: Colors.grey),
                                    // 구분선
                                    Text('총 결제금액: ${amountInfo['total_payment_price'] != null ? formatter.format(amountInfo['total_payment_price']) + '원' : '없음'}',
                                      style: TextStyle(
                                        fontSize: orderlistDataFontSize1, // 텍스트 크기 설정
                                        fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                        fontFamily: 'NanumGothic',
                                        color: Colors.black,
                                      ),
                                    ),
                                    // 총 결제 금액을 텍스트로 표시
                                    Divider(color: Colors.grey),
                                    // 구분선
                                    ...productInfoList.map((product) {
                                      // 각 제품 정보를 UI로 변환
                                      final productMap = product as Map<String, dynamic>;
                                      // 제품 정보를 맵으로 변환
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('상품 번호: ${productMap['product_number'] ?? '없음'}',
                                            style: TextStyle(
                                              fontSize: orderlistDataFontSize1, // 텍스트 크기 설정
                                              fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                              fontFamily: 'NanumGothic',
                                              color: Colors.black,
                                            ),
                                          ),
                                          // 제품 번호를 텍스트로 표시
                                          Text('상품 가격: ${productMap['discount_price'] != null ? formatter.format(productMap['discount_price']) + '원' : '없음'}',
                                            style: TextStyle(
                                              fontSize: orderlistDataFontSize1, // 텍스트 크기 설정
                                              fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                              fontFamily: 'NanumGothic',
                                              color: Colors.black,
                                            ),
                                          ),
                                          // 제품 가격을 텍스트로 표시
                                          Text('상품 수량: ${productMap['selected_count'] ?? '없음'} 개',
                                            style: TextStyle(
                                              fontSize: orderlistDataFontSize1, // 텍스트 크기 설정
                                              fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                              fontFamily: 'NanumGothic',
                                              color: Colors.black,
                                            ),
                                          ),
                                          // 제품 수량을 텍스트로 표시
                                          Text('상품 색상: ${productMap['selected_color_text'] ?? '없음'}',
                                            style: TextStyle(
                                              fontSize: orderlistDataFontSize1, // 텍스트 크기 설정
                                              fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                              fontFamily: 'NanumGothic',
                                              color: Colors.black,
                                            ),
                                          ),
                                          // 제품 색상을 텍스트로 표시
                                          Text('상품 사이즈: ${productMap['selected_size'] ?? '없음'}',
                                            style: TextStyle(
                                              fontSize: orderlistDataFontSize1, // 텍스트 크기 설정
                                              fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                              fontFamily: 'NanumGothic',
                                              color: Colors.black,
                                            ),
                                          ),
                                          // 제품 사이즈를 텍스트로 표시
                                          Divider(color: Colors.grey),
                                          // 구분선
                                        ],
                                      );
                                    }).toList(),
                                    SizedBox(height: interval1Y),
                                    // 드롭다운 버튼 위에 공간을 주기 위해 10픽셀 높이의 SizedBox 추가
                                    DropdownButton<String>(
                                      value: orderStatusProvider.isEmpty ? '발주신청 완료' : orderStatusProvider,
                                      // orderStatusProvider가 비어 있으면 기본 값으로 '발주신청 완료'를 설정하고, 그렇지 않으면 현재 상태를 설정
                                      onChanged: (String? newStatus) {
                                        // 드롭다운의 값이 변경되었을 때 호출되는 콜백 함수
                                        if (newStatus != null) {
                                          ref.read(orderStatusStateProvider.notifier).state = newStatus;
                                          // 선택된 새로운 상태로 orderStatusStateProvider의 상태를 업데이트
                                        }
                                      },
                                      items: ['발주신청 완료', '배송 준비', '배송 중', '배송 완료', '환불']
                                          .map<DropdownMenuItem<String>>((String status) {
                                        // 드롭다운에 표시될 각 항목을 리스트로 생성
                                        return DropdownMenuItem<String>(
                                          value: status,
                                          child: Text(status,
                                            style: TextStyle(
                                              fontSize: orderlistDataFontSize1, // 텍스트 크기 설정
                                              fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                              fontFamily: 'NanumGothic',
                                              color: Colors.black,
                                            ),
                                          ),
                                          // 각 항목의 텍스트를 드롭다운 메뉴로 표시
                                        );
                                      }).toList(),
                                    ),
                                    Container(
                                      width: changeBtnWidth,
                                      height: changeBtnHeight,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Color(0xFF6FAD96), // 텍스트 색상 설정
                                          backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 버튼 배경색을 앱 배경색으로 설정
                                          side: BorderSide(color: Color(0xFF6FAD96)), // 버튼 테두리 색상 설정
                                          padding: EdgeInsets.symmetric(vertical: changeBtnPaddingY, horizontal: changeBtnPaddingX), // 버튼 패딩
                                        ),
                                        onPressed: () async {
                                          // 리뷰 삭제 버튼 클릭 시 확인 다이얼로그를 표시함
                                          await showSubmitAlertDialog(
                                            context,
                                            title: '[발주 내역 상태 변경]', // 다이얼로그 제목 설정
                                            content: '해당 발주 내역 상태를 변경하시겠습니까?', // 다이얼로그 내용 설정
                                            actions: buildAlertActions(
                                              context,
                                              noText: '아니요', // 아니요 버튼 텍스트 설정
                                              yesText: '예', // 예 버튼 텍스트 설정
                                              noTextStyle: TextStyle(
                                                color: Colors.black, // 아니요 버튼 텍스트 색상 설정
                                                fontWeight: FontWeight.bold, // 아니요 버튼 텍스트 굵기 설정
                                              ),
                                              yesTextStyle: TextStyle(
                                                color: Colors.red, // 예 버튼 텍스트 색상 설정
                                                fontWeight: FontWeight.bold, // 예 버튼 텍스트 굵기 설정
                                              ),
                                              onYesPressed: () async {
                                                // 버튼이 눌렸을 때 비동기 작업을 수행
                                                try {
                                                  await ref.read(adminOrderlistRepositoryProvider).updateOrderStatus(
                                                    selectedUserEmail,
                                                    numberInfo['order_number'],
                                                    orderStatusProvider);
                                                  // 선택된 사용자 이메일과 발주 번호, 새로운 발주 상태를 이용해 발주 상태를 업데이트
                                                   showCustomSnackBar(context, '\'$orderStatusProvider\'로 발주상태가 변경되었습니다.');
                                                    // 발주 상태 변경이 성공적으로 이루어졌음을 사용자에게 알림
                                                    } catch (e) {
                                                    showCustomSnackBar(context, '발주상태 변경에 실패했습니다: $e');
                                                    // 발주 상태 변경에 실패했을 때 오류 메시지를 사용자에게 알림
                                                    }
                                                 },
                                              ),
                                            );
                                          },
                                          child: Text('변경',
                                            style: TextStyle(
                                              fontSize: orderlistDataFontSize1, // 텍스트 크기 설정
                                              fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                              fontFamily: 'NanumGothic',
                                              color: Colors.black,
                                            ),
                                          ),
                                          // 버튼에 '변경'이라는 텍스트를 굵은 글씨로 표시
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    loading: () => Center(child: CircularProgressIndicator()),
                    // 발주 데이터를 로딩 중일 때 로딩 인디케이터 표시
                    error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
                    // 발주 데이터를 가져오는 중 에러가 발생했을 때 에러 메시지 표시
                  );
                },
              ),
            ]
          ],
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      // 이메일 데이터를 로딩 중일 때 로딩 인디케이터 표시
      error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
      // 이메일 데이터를 가져오는 중 에러가 발생했을 때 에러 메시지 표시
    );
  }
}
// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 및 버튼 클릭 시, 나오는 데이터 UI 내용을 구현하는 AdminOrderListContents 클래스 끝
