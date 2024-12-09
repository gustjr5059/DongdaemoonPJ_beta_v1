import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import '../../../common/const/colors.dart';
import '../../../common/layout/common_body_parts_layout.dart';
import '../../../message/provider/message_all_provider.dart';
import '../../../order/view/order_detail_list_screen.dart';
import '../../../product/layout/product_body_parts_layout.dart';
import '../../../product/model/product_model.dart';
import '../provider/orderlist_all_provider.dart';
import '../provider/orderlist_state_provider.dart';
import '../view/orderlist_detail_screen.dart';


// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 및 버튼 클릭 시, 나오는 데이터 UI 내용을 구현하는 AdminOrderListContents 클래스 시작
// ——— AdminOrderListItemWidget 클래스 시작 부분
class AdminOrderListItemWidget extends ConsumerStatefulWidget {
  // AdminOrderListItemWidget를 생성하는 클래스임
  @override
  _AdminOrderListItemWidgetState createState() =>
      _AdminOrderListItemWidgetState(); // 상태를 생성하는 메서드를 호출함
}
// ——— AdminOrderListItemWidget 클래스 끝 부분

// ——— _AdminOrderListItemWidgetState 클래스 시작 부분
class _AdminOrderListItemWidgetState
    extends ConsumerState<AdminOrderListItemWidget> {
  @override
  void initState() {
    super.initState(); // 상위 클래스의 initState를 호출하는 초기화 구문임
  }

  @override
  Widget build(BuildContext context) {
    final selectedUserEmail =
    ref.watch(adminSelectedOrdererEmailProvider); // 선택된 발주자 이메일 상태를 구독하는 동작임
    final usersEmail =
    ref.watch(adminOrdererEmailProvider); // 모든 발주자 이메일 목록을 구독하는 동작임
    final orderlistItems = ref.watch(
        adminOrderlistItemsListNotifierProvider); // 선택된 발주자의 발주 내역 리스트를 구독하는 동작임

    // 날짜 형식을 'yyyy년 MM월 dd일 HH시 MM분'로 지정하는 형식 객체임
    final dateFormat = DateFormat('yyyy년 MM월 dd일 HH시 MM분'); // 날짜 포맷터 임

    // 기기 화면 크기를 가져오는 구문임
    final Size screenSize = MediaQuery.of(context).size; // 기기 화면 크기 정보 획득용임

    // 기준 화면 크기 설정값임
    final double referenceWidth = 393.0; // 기준 화면 가로 크기임
    final double referenceHeight = 852.0; // 기준 화면 세로 크기임

    final double ordererDropdownBtnWidth =
        screenSize.width * (230 / referenceWidth); // 드롭다운 버튼의 가로 비율 크기임
    final double ordererDropdownBtnHeight =
        screenSize.height * (50 / referenceHeight); // 드롭다운 버튼의 세로 비율 크기임
    final double ordererSelectDataTextSize =
        screenSize.height * (16 / referenceHeight); // 드롭다운 버튼 내 텍스트 크기 비율 계산용임

    // 컨텐츠 사이 간격 수치임
    final double interval1Y =
        screenSize.height * (8 / referenceHeight); // 세로 간격 1 계산용임
    final double interval2Y =
        screenSize.height * (12 / referenceHeight); // 세로 간격 2 계산용임
    final double interval3Y =
        screenSize.height * (4 / referenceHeight); // 세로 간격 3 계산용임
    final double interval1X = screenSize.width * (8 / referenceWidth); // 가로 간격 계산용임

    // 발주 내역이 없을 경우 표시할 메시지 관련 사이즈 비율 계산용임
    final double orderlistEmptyTextWidth =
        screenSize.width * (250 / referenceWidth); // 발주 내역 없음 텍스트 가로 비율임
    final double orderlistEmptyTextHeight =
        screenSize.height * (22 / referenceHeight); // 발주 내역 없음 텍스트 세로 비율임
    final double orderlistEmptyTextX =
        screenSize.width * (50 / referenceWidth); // 발주 내역 없음 텍스트 가로 위치 비율임
    final double orderlistEmptyTextY =
        screenSize.height * (200 / referenceHeight); // 발주 내역 없음 텍스트 세로 위치 비율임
    final double orderlistEmptyTextFontSize =
        screenSize.height * (16 / referenceHeight); // 발주 내역 없음 텍스트 크기 비율임

    // 텍스트 크기 비율 계산용임
    final double orderlistInfoOrderStatusDataFontSize =
        screenSize.height * (16 / referenceHeight); // 발주 상태 텍스트 크기 비율임
    final double orderlistInfoOrderNumberDataFontSize =
        screenSize.height * (16 / referenceHeight); // 발주 번호 텍스트 크기 비율임
    final double orderlistInfoOrderDateDataFontSize =
        screenSize.height * (14 / referenceHeight); // 발주 날짜 텍스트 크기 비율임

    // 발주내역 상세보기 버튼 크기 비율 계산용임
    final double orderlistInfoDetailViewBtn1X =
        screenSize.width * (220 / referenceWidth); // 상세보기 버튼 가로 비율임
    final double orderlistInfoDetailViewBtn1Y =
        screenSize.height * (40 / referenceHeight); // 상세보기 버튼 세로 비율임
    final double orderlistInfoDetailViewBtnFontSize =
        screenSize.height * (14 / referenceHeight); // 상세보기 버튼 텍스트 크기 비율임

    return Column(
      children: [
        SizedBox(height: interval3Y), // 상단 여백용임
        // 드롭다운 버튼을 중앙에 위치시키는 Center 위젯임
        Center(
          child: Container(
            width: ordererDropdownBtnWidth, // 드롭다운 버튼 가로 크기 설정임
            height: ordererDropdownBtnHeight, // 드롭다운 버튼 세로 크기 설정임
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색 지정임
              border: Border.all(color: GRAY83_COLOR, width: 1), // 윤곽선 설정임
              borderRadius: BorderRadius.circular(6), // 모서리를 둥글게 처리함
            ),
            padding: EdgeInsets.symmetric(horizontal: interval1X), // 드롭다운 내부 좌우 패딩 설정임
            alignment: Alignment.center, // 드롭다운 콘텐츠 중앙 정렬용임
            child: DropdownButtonHideUnderline(
              child: usersEmail.when(
                data: (usersEmailList) {
                  final uniqueUsersEmailList =
                  usersEmailList.toSet().toList(); // 발주자 이메일 목록 중복 제거용임
                  final validSelectedUserEmail = (selectedUserEmail != null &&
                      uniqueUsersEmailList.contains(selectedUserEmail))
                      ? selectedUserEmail
                      : null; // 선택된 이메일이 유효하지 않을 경우 null 처리함

                  return DropdownButton<String>(
                    hint: Center(
                      child: Text(
                        '발주자 선택', // 드롭다운에 표시될 힌트 텍스트임
                        style: TextStyle(
                          fontFamily: 'NanumGothic',
                          fontSize: ordererSelectDataTextSize, // 텍스트 크기 설정임
                        ),
                      ),
                    ),
                    value: validSelectedUserEmail, // 선택된 이메일 값 설정임
                    onChanged: (value) {
                      // 이메일 선택 시 상태 업데이트용임
                      ref
                          .read(adminSelectedOrdererEmailProvider.notifier)
                          .state = value; // 선택된 이메일 값 변경 동작임
                    },
                    items: uniqueUsersEmailList.map((email) {
                      return DropdownMenuItem<String>(
                        value: email, // 이메일 값 설정임
                        child: Text(
                          email, // 드롭다운 항목으로 표시할 이메일 텍스트임
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'NanumGothic',
                            fontSize: ordererSelectDataTextSize, // 텍스트 크기 설정임
                            color: BLACK_COLOR, // 텍스트 색상 설정임
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => buildCommonLoadingIndicator(), // 로딩 상태 시 로딩 인디케이터 표시용임
                error: (e, stack) =>
                const Center(child: Text('에러가 발생했으니, 앱을 재실행해주세요.')), // 에러 발생 시 안내 메시지 표시용임
              ),
            ),
          ),
        ),
        SizedBox(height: interval1Y), // 드롭다운 버튼 아래 여백용임
        if (orderlistItems.isEmpty)
        // 발주 내역이 없을 경우 알림 메시지 표시용임
          Container(
            width: orderlistEmptyTextWidth, // 알림 메시지 컨테이너 가로 크기임
            height: orderlistEmptyTextHeight, // 알림 메시지 컨테이너 세로 크기임
            margin: EdgeInsets.only(top: orderlistEmptyTextY), // 상단 여백 설정임
            alignment: Alignment.center, // 텍스트 중앙 정렬용임
            child: Text(
              '현재 발주 내역이 없습니다.', // 발주 내역 없음 메시지 텍스트임
              style: TextStyle(
                fontSize: orderlistEmptyTextFontSize, // 텍스트 크기 비율 적용임
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
                color: BLACK_COLOR, // 텍스트 색상 설정임
              ),
            ),
          )
        else
        // 발주 내역이 있을 경우 해당 내역을 리스트 형태로 표시함
          Column(
            children: orderlistItems.asMap().entries.map((entry) {
              final index = entry.key; // 현재 아이템의 인덱스 번호임
              final orderlistItem = entry.value; // 현재 아이템의 데이터임

              return Container(
                padding: EdgeInsets.zero, // 패딩 없음 설정임
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: BLACK_COLOR, width: 1.0), // 하단 테두리 설정임
                  ),
                ),
                child: CommonCardView(
                  backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor, // 카드뷰 배경색 설정임
                  elevation: 0, // 카드뷰 그림자 깊이 설정임
                  content: Padding(
                    padding: EdgeInsets.zero, // 패딩 없음 설정임
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬용임
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝 정렬용임
                          children: [
                            // 발주번호 표시 텍스트
                            Text(
                              '발주번호:  ${orderlistItem['order_number'] ?? ''}', // 발주 번호 정보 표시용임
                              style: TextStyle(
                                fontSize: orderlistInfoOrderNumberDataFontSize,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NanumGothic',
                                color: BLACK_COLOR,
                              ),
                            ),
                            // 발주상태 표시 텍스트
                            Text(
                              orderlistItem['order_status']
                                  ?.toString()
                                  .isNotEmpty ==
                                  true
                                  ? orderlistItem['order_status']
                                  : '',
                              style: TextStyle(
                                fontSize: orderlistInfoOrderStatusDataFontSize,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NanumGothic',
                                color: RED46_COLOR,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: interval1Y), // 간격 추가용임
                        // 발주일자 표시 텍스트
                        Text(
                          '발주일시:  ${orderlistItem['order_date'] != null ? dateFormat.format(orderlistItem['order_date']) : ''}',
                          style: TextStyle(
                            fontSize: orderlistInfoOrderDateDataFontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NanumGothic',
                            color: GRAY41_COLOR,
                          ),
                        ),
                        SizedBox(height: interval2Y), // 간격 추가용임
                        // 상세보기 버튼을 배치하는 행임
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬용임
                          children: [
                            Container(
                              width: orderlistInfoDetailViewBtn1X, // 상세보기 버튼 가로 크기 설정임
                              height: orderlistInfoDetailViewBtn1Y, // 상세보기 버튼 세로 크기 설정임
                              margin:
                              EdgeInsets.symmetric(vertical: interval3Y), // 상하 간격 설정임
                              child: ElevatedButton(
                                onPressed: () {
                                  // 상세보기 버튼 클릭 시 발주 상세 화면으로 이동함
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AdminOrderListDetailScreen(
                                            orderNumber:
                                            orderlistItem['order_number'] ?? '', // 발주 번호 전달용임
                                            userEmail: selectedUserEmail ?? '', // 발주자 이메일 전달용임
                                          ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: ORANGE56_COLOR,
                                  backgroundColor: ORANGE56_COLOR,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(45), // 모서리를 둥글게 처리함
                                  ),
                                ),
                                child: Text(
                                  '발주 내역 상세보기', // 버튼 텍스트 표시용임
                                  style: TextStyle(
                                    fontSize: orderlistInfoDetailViewBtnFontSize,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NanumGothic',
                                    color: WHITE_COLOR,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
// ——— _AdminOrderListItemWidgetState 클래스 끝 부분
// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 및 버튼 클릭 시, 나오는 데이터 UI 내용을 구현하는 AdminOrderListContents 클래스 끝

// ------  발주 목록 상세 화면 내 발주 목록 상세 내용을 표시하는 위젯 클래스인 AdminOrderListDetailItemWidget 시작
class AdminOrderListDetailItemWidget extends ConsumerStatefulWidget {
  // 발주 데이터를 담고 있는 Map<String, dynamic> 형태의 order 필드를 선언
  final Map<String, dynamic>? order;

  // 생성자에서 order 필드를 필수로 받도록 설정함
  AdminOrderListDetailItemWidget({required this.order});

  // 위젯의 상태를 생성하는 메서드를 오버라이드함
  @override
  _AdminOrderListDetailItemWidgetState createState() =>
      _AdminOrderListDetailItemWidgetState();
}

// 위젯의 상태를 정의하는 클래스 _AdminOrderListDetailItemWidgetState 시작
class _AdminOrderListDetailItemWidgetState
    extends ConsumerState<AdminOrderListDetailItemWidget> {
  @override
  Widget build(BuildContext context) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 발주내역 상세 화면 내 카드뷰 섹션의 가로와 세로 비율 계산
    final double orderlistDtInfo3CardViewWidth =
        screenSize.width * (360 / referenceWidth); // 가로 비율 계산
    final double orderlistDtInfo3CardViewHeight =
        screenSize.height * (200 / referenceHeight); // 세로 비율 계산

    // body 부분 전체 패딩 수치 계산
    final double orderlistDtInfoCardViewPaddingX =
        screenSize.width * (5 / referenceWidth); // 좌우 패딩 계산
    final double orderlistDtInfoCardViewPadding1Y =
        screenSize.height * (5 / referenceHeight); // 상하 패딩 계산

    // 텍스트 크기 계산
    final double orderlistDtInfoOrderNumberDataFontSize =
        screenSize.height * (16 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoOrderDateDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoPaymentCompletionDateDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfodeliveryStartDateDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoPaymentInfoDataFontSize1 =
        screenSize.height * (16 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoPaymentInfoDataFontSize2 =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoOrdererInfoDataFontSize1 =
        screenSize.height * (16 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoOrdererInfoDataFontSize2 =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoRecipientInfoDataFontSize1 =
        screenSize.height * (16 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoRecipientInfoDataFontSize2 =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoRefundCompletionDateDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoBriefIntroDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoProdNumberDataFontSize =
        screenSize.height * (12 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoOriginalPriceDataFontSize =
        screenSize.height * (12 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoDiscountPriceDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoDiscountPercentDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoColorImageDataWidth =
        screenSize.width * (14 / referenceWidth); // 색상 이미지 가로 크기 설정함
    final double orderlistDtInfoColorImageDataHeight =
        screenSize.width * (14 / referenceWidth); // 색상 이미지 세로 크기 설정함
    final double orderlistDtInfoColorTextDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoSizeTextDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoCountTextDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산

    // 발주내역 카드뷰 섹션 내 컨텐츠 사이의 간격 계산
    final double interval1Y =
        screenSize.height * (4 / referenceHeight); // 세로 간격 1 계산
    final double interval2Y =
        screenSize.height * (8 / referenceHeight); // 세로 간격 2 계산
    final double interval3Y =
        screenSize.height * (16 / referenceHeight); // 세로 간격 3 계산
    final double interval4Y =
        screenSize.height * (10 / referenceHeight); // 세로 간격 4 계산
    final double interval1X =
        screenSize.width * (20 / referenceWidth); // 가로 간격 1 계산
    final double interval2X =
        screenSize.width * (10 / referenceWidth); // 가로 간격 2 계산
    final double interval3X =
        screenSize.width * (20 / referenceWidth); // 가로 간격 3 계산
    final double interval4X =
        screenSize.width * (70 / referenceWidth); // 가로 간격 4 계산

    // 에러 메시지 텍스트 크기 설정
    final double errorTextFontSize1 =
        screenSize.height * (14 / referenceHeight); // 첫 번째 에러 텍스트 크기
    final double errorTextFontSize2 =
        screenSize.height * (12 / referenceHeight); // 두 번째 에러 텍스트 크기
    final double errorTextHeight = screenSize.height * (600 / referenceHeight);

    // 날짜 형식을 'yyyy년 MM월 dd일 HH시 MM분'로 지정함
    final dateFormat = DateFormat('yyyy년 MM월 dd일 HH시 MM분');

    // order 정보에서 발주 날짜를 가져오고, 값이 유효하면 Timestamp를 DateTime으로 변환함
    final orderDate =
        widget.order!['numberInfo']['order_date']?.toString().isNotEmpty == true
            ? (widget.order!['numberInfo']['order_date'] as Timestamp).toDate()
            : null;

    // order 정보에서 발주 번호를 가져오고, 값이 유효하지 않으면 ''을 반환함
    final orderNumber =
        widget.order!['numberInfo']['order_number']?.toString().isNotEmpty ==
                true
            ? widget.order!['numberInfo']['order_number']
            : '';

    // 선택된 이메일 계정 데이터를 불러오고, 값이 유효하지 않으면 ''을 반환함
    final selectedUserEmail = ref.watch(adminSelectedOrdererEmailProvider) ?? '';

    // 결제 완료일 데이터(선택된 이메일 계정과 발주번호 관련)를 비동기로 가져오는 provider를 호출하고 결과를 paymentCompleteDateAsyncValue에 저장함
    final paymentCompleteDateAsyncValue = ref.watch(
        paymentCompleteDateForSelectedEmailProvider(Tuple2(selectedUserEmail, orderNumber))
    );

    // 배송 시작 날짜 데이터(선택된 이메일 계정과 발주번호 관련)를 비동기로 가져오는 provider를 호출하고 결과를 deliveryStartDateAsyncValue에 저장함
    final deliveryStartDateAsyncValue = ref.watch(
        deliveryStartDateForSelectedEmailProvider(Tuple2(selectedUserEmail, orderNumber))
    );

    // 숫자 형식을 '###,###'로 지정함
    final numberFormat = NumberFormat('###,###');

    // order 정보에서 총 상품 금액, 상품 할인 금액, 배송비용, 배송비 포함 총 결제 금액을 가져오고, 값이 유효하지 않으면 0.0으로 설정함
    final totalProductPrice = widget.order!['amountInfo']['total_product_price']
                ?.toString()
                .isNotEmpty ==
            true
        ? (widget.order!['amountInfo']['total_product_price'] as num).toDouble()
        : 0;
    final productDiscountPrice = widget.order!['amountInfo']
                    ['product_discount_price']
                ?.toString()
                .isNotEmpty ==
            true
        ? (widget.order!['amountInfo']['product_discount_price'] as num)
            .toDouble()
        : 0;
    final deliveryFee =
        widget.order!['amountInfo']['delivery_fee']?.toString().isNotEmpty ==
                true
            ? (widget.order!['amountInfo']['delivery_fee'] as num).toDouble()
            : 0;
    final totalPaymentPriceIncludedDeliveryFee = widget.order!['amountInfo']
                    ['total_payment_price_included_delivery_fee']
                ?.toString()
                .isNotEmpty ==
            true
        ? (widget.order!['amountInfo']
                ['total_payment_price_included_delivery_fee'] as num)
            .toDouble()
        : 0;

    // 발주자 정보가 null인지 확인하고 각 필드를 안전하게 접근함
    final ordererInfo = widget.order!['ordererInfo'] ?? {};

    // 발주자 정보에서 이름, 이메일, 휴대폰 번호를 가져오고, 값이 유효하지 않으면 기본 메시지를 설정함
    final ordererName = ordererInfo['name']?.toString().isNotEmpty == true ? ordererInfo['name'] : '';
    final ordererPhone = ordererInfo['phone_number']?.toString().isNotEmpty == true ? ordererInfo['phone_number'] : '';
    final ordererEmail = ordererInfo['email']?.toString().isNotEmpty == true ? ordererInfo['email'] : '';

    // 수령자 정보가 null인지 확인하고 각 필드를 안전하게 접근함
    final recipientInfo = widget.order!['recipientInfo'] ?? {};

    // 수령자 정보에서 이름, 연락처, 주소, 상세주소, 우편번호를 가져오고, 값이 유효하지 않으면 기본 메시지를 설정함
    final recipientName = recipientInfo['name']?.toString().isNotEmpty == true
        ? recipientInfo['name']
        : '';
    final recipientPhone =
        recipientInfo['phone_number']?.toString().isNotEmpty == true
            ? recipientInfo['phone_number']
            : '';
    final recipientAddress =
        recipientInfo['address']?.toString().isNotEmpty == true
            ? recipientInfo['address']
            : '';
    final recipientDetailAddress =
        recipientInfo['detail_address']?.toString().isNotEmpty == true
            ? recipientInfo['detail_address']
            : '';
    final recipientPostalCode =
        recipientInfo['postal_code']?.toString().isNotEmpty == true
            ? recipientInfo['postal_code']
            : '';

    // 배송 메모 데이터를 처리하고, '직접입력'일 경우 추가 메모를 가져옴
    String deliveryMemo = recipientInfo['memo']?.toString().isNotEmpty == true
        ? recipientInfo['memo']
        : '';
    if (deliveryMemo == '직접입력') {
      deliveryMemo = recipientInfo['extra_memo']?.toString().isNotEmpty == true
          ? recipientInfo['extra_memo']
          : '';
    }

    // productInfo 리스트를 가져와서 해당 발주번호 관련 상품별로 productInfo 데이터를 구현 가능하도록 하는 로직
    final List<dynamic> productInfoList = widget.order!['productInfo'] ?? [];

    // ProductInfoDetailScreenNavigation 인스턴스를 생성하여 상품 상세 화면으로 이동할 수 있도록 설정함
    final navigatorProductDetailScreen = ProductInfoDetailScreenNavigation(ref);

    // 발주 상세 정보를 화면에 렌더링하는 위젯을 구성함
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // // 클립 위젯을 사용하여 모서리를 둥글게 설정함
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
        //   child: Container(
        Container(
          // width: orderlistDtInfo1CardViewWidth, // 카드뷰 가로 크기 설정
          // height: orderlistDtInfo1CardViewHeight, // 카드뷰 세로 크기 설정
          // color: Theme.of(context).scaffoldBackgroundColor, // 배경색 설정
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
            ),
          ),
          // 발주 날짜와 발주 번호, 결제 완료일을 표시하는 섹션
          child: CommonCardView(
            // 공통 카드뷰 위젯 사용
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor, // 배경색 설정
            elevation: 0, // 그림자 깊이 설정
            content: Padding(
              // 패딩 설정
              padding: EdgeInsets.symmetric(
                  vertical: orderlistDtInfoCardViewPadding1Y,
                  horizontal: orderlistDtInfoCardViewPaddingX), // 상하 좌우 패딩 설정
              child: Column(
                // 컬럼 위젯으로 구성함
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 발주 번호를 표시
                  Text(
                    '발주번호: ${orderNumber ?? ''}',
                    style: TextStyle(
                      fontSize: orderlistDtInfoOrderNumberDataFontSize,
                      // 텍스트 크기 설정
                      fontWeight: FontWeight.bold,
                      // 텍스트 굵기 설정
                      fontFamily: 'NanumGothic',
                      // 글꼴 설정
                      color: BLACK_COLOR, // 텍스트 색상 설정
                    ),
                  ),
                  SizedBox(height: interval2Y),
                  // 발주 일자를 표시
                  Text(
                    '발주일시: ${orderDate != null ? dateFormat.format(orderDate) : ''}',
                    style: TextStyle(
                      fontSize: orderlistDtInfoOrderDateDataFontSize,
                      // 텍스트 크기 설정
                      fontWeight: FontWeight.bold,
                      // 텍스트 굵기 설정
                      fontFamily: 'NanumGothic',
                      // 글꼴 설정
                      color: GRAY41_COLOR, // 텍스트 색상 설정
                    ),
                  ),
                  SizedBox(height: interval1Y),
                  // 결제완료일 데이터를 표시, 비동기 데이터 처리 로직을 추가
                  paymentCompleteDateAsyncValue.when(
                    data: (date) {
                      if (date != null) {
                        return Text(
                          '결제완료일시: ${date != null ? dateFormat.format(date) : ''}',
                          style: TextStyle(
                            fontSize:
                                orderlistDtInfoPaymentCompletionDateDataFontSize,
                            // 텍스트 크기 설정
                            fontWeight: FontWeight.bold,
                            // 텍스트 굵기 설정
                            fontFamily: 'NanumGothic',
                            // 글꼴 설정
                            color: GRAY41_COLOR, // 텍스트 색상 설정
                          ),
                        );
                      } else {
                        return SizedBox.shrink(); // UI에 아무것도 표시하지 않음
                      }
                    },
                    loading: () => buildCommonLoadingIndicator(),
                    // 공통 로딩 인디케이터 호출
                    error: (error, stack) => Container(
                      // 에러 상태에서 중앙 배치
                      height: errorTextHeight, // 전체 화면 높이 설정
                      alignment: Alignment.center, // 중앙 정렬
                      child: buildCommonErrorIndicator(
                        message: '에러가 발생했으니, 앱을 재실행해주세요.',
                        // 첫 번째 메시지 설정
                        secondMessage: '에러가 반복될 시, \'문의하기\'에서 문의해주세요.',
                        // 두 번째 메시지 설정
                        fontSize1: errorTextFontSize1,
                        // 폰트1 크기 설정
                        fontSize2: errorTextFontSize2,
                        // 폰트2 크기 설정
                        color: BLACK_COLOR,
                        // 색상 설정
                        showSecondMessage: true, // 두 번째 메시지를 표시하도록 설정
                      ),
                    ),
                  ),
                  SizedBox(height: interval1Y),
                  // 배송 시작 일자를 표시하거나 로딩 중 표시 또는 오류 메시지를 표시함
                  deliveryStartDateAsyncValue.when(
                    data: (date) {
                      if (date != null) {
                        return Text(
                          '배송시작일시: ${date != null ? dateFormat.format(date) : ''}',
                          style: TextStyle(
                            fontSize:
                                orderlistDtInfodeliveryStartDateDataFontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NanumGothic',
                            color: GRAY41_COLOR,
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                    loading: () => buildCommonLoadingIndicator(),
                    // 공통 로딩 인디케이터 호출
                    error: (error, stack) => Container(
                      // 에러 상태에서 중앙 배치
                      height: errorTextHeight, // 전체 화면 높이 설정
                      alignment: Alignment.center, // 중앙 정렬
                      child: buildCommonErrorIndicator(
                        message: '에러가 발생했으니, 앱을 재실행해주세요.',
                        // 첫 번째 메시지 설정
                        secondMessage: '에러가 반복될 시, \'문의하기\'에서 문의해주세요.',
                        // 두 번째 메시지 설정
                        fontSize1: errorTextFontSize1,
                        // 폰트1 크기 설정
                        fontSize2: errorTextFontSize2,
                        // 폰트2 크기 설정
                        color: BLACK_COLOR,
                        // 색상 설정
                        showSecondMessage: true, // 두 번째 메시지를 표시하도록 설정
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // ),
        // SizedBox(height: interval1Y),
        // 결제 정보를 표시하는 카드뷰
        // 클립 위젯을 사용하여 모서리를 둥글게 설정함
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
        //   child: Container(
        Container(
          // width: orderlistDtInfo1CardViewWidth, // 카드뷰 가로 크기 설정
          // height: orderlistDtInfo1CardViewHeight, // 카드뷰 세로 크기 설정
          // color: Color(0xFFF3F3F3), // 배경색 설정
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
            ),
          ),
          child: CommonCardView(
            // 공통 카드뷰 위젯 사용
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor, // 배경색 설정
            elevation: 0, // 그림자 깊이 설정
            content: Padding(
              // 패딩 설정
              padding: EdgeInsets.symmetric(
                  vertical: orderlistDtInfoCardViewPadding1Y,
                  horizontal: orderlistDtInfoCardViewPaddingX), // 상하 좌우 패딩 설정
              child: Column(
                // 컬럼 위젯으로 구성함
                // 자식 위젯들을 왼쪽 정렬.
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 결제 정보를 나타내는 제목 텍스트
                  Text(
                    '결제 정보',
                    style: TextStyle(
                      fontSize: orderlistDtInfoPaymentInfoDataFontSize1,
                      // 텍스트 크기 설정
                      fontWeight: FontWeight.bold,
                      // 텍스트 굵기 설정
                      fontFamily: 'NanumGothic',
                      // 글꼴 설정
                      color: BLACK_COLOR, // 텍스트 색상 설정
                    ),
                  ),
                  SizedBox(height: interval3Y),
                  // 각 결제 정보 항목을 표시하는 _buildAmountRow 함수 호출
                  _buildAmountRow(context, '총 상품금액',
                      '${numberFormat.format(totalProductPrice)}원',
                      fontSize: orderlistDtInfoPaymentInfoDataFontSize2),
                  _buildAmountRow(context, '상품 할인금액',
                      '-${numberFormat.format(productDiscountPrice)}원',
                      fontSize: orderlistDtInfoPaymentInfoDataFontSize2),
                  _buildAmountRow(
                      context, '배송비', '+${numberFormat.format(deliveryFee)}원',
                      fontSize: orderlistDtInfoPaymentInfoDataFontSize2),
                  Divider(color: GRAY62_COLOR),
                  _buildAmountRow(context, '총 결제금액',
                      '${numberFormat.format(totalPaymentPriceIncludedDeliveryFee)}원',
                      isTotal: true,
                      fontSize: orderlistDtInfoPaymentInfoDataFontSize2),
                ],
              ),
            ),
          ),
        ),
        Container(
          // width: orderlistDtInfo1CardViewWidth, // 카드뷰 가로 크기 설정
          // height: orderlistDtInfo1CardViewHeight, // 카드뷰 세로 크기 설정
          // color: Color(0xFFF3F3F3), // 배경색 설정
          decoration: BoxDecoration(
            border: Border(
              bottom:
              BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
            ),
          ),
          child: CommonCardView(
            // 공통 카드뷰 위젯 사용
            backgroundColor:
            Theme.of(context).scaffoldBackgroundColor, // 배경색 설정
            elevation: 0, // 그림자 깊이 설정
            content: Padding(
              // 패딩 설정
              padding: EdgeInsets.symmetric(
                  vertical: orderlistDtInfoCardViewPadding1Y,
                  horizontal: orderlistDtInfoCardViewPaddingX), // 상하 좌우 패딩 설정
              child: Column(
                // 컬럼 위젯으로 구성함
                // 자식 위젯들을 왼쪽 정렬.
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 수령자 정보를 나타내는 제목 텍스트
                  Text(
                    '발주자 정보',
                    style: TextStyle(
                      fontSize: orderlistDtInfoOrdererInfoDataFontSize1,
                      // 텍스트 크기 설정
                      fontWeight: FontWeight.bold,
                      // 텍스트 굵기 설정
                      fontFamily: 'NanumGothic',
                      // 글꼴 설정
                      color: BLACK_COLOR, // 텍스트 색상 설정
                    ),
                  ),
                  SizedBox(height: interval3Y),
                  // 발주자 정보 각 항목을 표시하는 _buildOrdererInfoRow 함수 호출
                  _buildOrdererInfoRow(context, '이름', ordererName,
                      fontSize: orderlistDtInfoOrdererInfoDataFontSize2),
                  _buildOrdererInfoRow(context, '이메일', ordererEmail,
                      fontSize: orderlistDtInfoOrdererInfoDataFontSize2),
                  _buildOrdererInfoRow(context, '휴대폰 번호', ordererPhone,
                      fontSize: orderlistDtInfoOrdererInfoDataFontSize2),
                ],
              ),
            ),
          ),
        ),
        // ),
        // SizedBox(height: interval1Y),
        // 수령자 정보를 표시하는 카드뷰
        // 클립 위젯을 사용하여 모서리를 둥글게 설정함
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
        //   child: Container(
        Container(
          // width: orderlistDtInfo1CardViewWidth, // 카드뷰 가로 크기 설정
          // height: orderlistDtInfo1CardViewHeight, // 카드뷰 세로 크기 설정
          // color: Color(0xFFF3F3F3), // 배경색 설정
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
            ),
          ),
          child: CommonCardView(
            // 공통 카드뷰 위젯 사용
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor, // 배경색 설정
            elevation: 0, // 그림자 깊이 설정
            content: Padding(
              // 패딩 설정
              padding: EdgeInsets.symmetric(
                  vertical: orderlistDtInfoCardViewPadding1Y,
                  horizontal: orderlistDtInfoCardViewPaddingX), // 상하 좌우 패딩 설정
              child: Column(
                // 컬럼 위젯으로 구성함
                // 자식 위젯들을 왼쪽 정렬.
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 수령자 정보를 나타내는 제목 텍스트
                  Text(
                    '수령자 정보',
                    style: TextStyle(
                      fontSize: orderlistDtInfoRecipientInfoDataFontSize1,
                      // 텍스트 크기 설정
                      fontWeight: FontWeight.bold,
                      // 텍스트 굵기 설정
                      fontFamily: 'NanumGothic',
                      // 글꼴 설정
                      color: BLACK_COLOR, // 텍스트 색상 설정
                    ),
                  ),
                  SizedBox(height: interval3Y),
                  // 수령자 정보 각 항목을 표시하는 _buildRecipientInfoRow 함수 호출
                  _buildRecipientInfoRow(context, '이름', recipientName,
                      fontSize: orderlistDtInfoRecipientInfoDataFontSize2),
                  _buildRecipientInfoRow(context, '휴대폰 번호', recipientPhone,
                      fontSize: orderlistDtInfoRecipientInfoDataFontSize2),
                  _buildRecipientInfoRow(context, '주소 (상세주소) (우편번호)', '',
                      fontSize: orderlistDtInfoRecipientInfoDataFontSize2),
                  _buildRecipientInfoRow(
                      context,
                      '$recipientAddress ($recipientDetailAddress) ($recipientPostalCode)',
                      '',
                      isLongText: true,
                      fontSize: orderlistDtInfoRecipientInfoDataFontSize2),
                  _buildRecipientInfoRow(context, '배송메모', '',
                      fontSize: orderlistDtInfoRecipientInfoDataFontSize2),
                  _buildRecipientInfoRow(context, deliveryMemo, '',
                      isLongText: true,
                      fontSize: orderlistDtInfoRecipientInfoDataFontSize2),
                ],
              ),
            ),
          ),
        ),
        // ),
        // SizedBox(height: interval4Y),
        // 각 상품 정보를 표시하는 로직을 반복문으로 구성함
        for (var productInfo in productInfoList) ...[
          // // 클립 위젯을 사용하여 모서리를 둥글게 설정함
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(20), // 모서리 반경 설정
          //   child: Container(
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
              ),
            ),
            child: CommonCardView(
              // backgroundColor: Color(0xFFF3F3F3), // 배경색 설정
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              // backgroundColor: GRAY97_COLOR,
              elevation: 0, // 그림자 깊이 설정
              content: Padding(
                padding: EdgeInsets.zero, // 패딩을 없앰
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 환불 완료 상태인 경우 '환불 완료' 텍스트를 표시함.
                    if (productInfo['boolRefundCompleteBtn'] == true)
                      Text(
                        '  환불 완료', // '환불 완료' 텍스트를 표시함.(앞에 두 칸을 띄워서 작성)
                        style: TextStyle(
                          color: RED46_COLOR,
                          // 텍스트 색상을 빨간색으로 설정함.
                          fontWeight: FontWeight.bold,
                          // 텍스트를 굵게 표시함.
                          fontSize:
                              orderlistDtInfoRefundCompletionDateDataFontSize,
                          // 텍스트 크기를 16으로 설정함.
                          fontFamily: 'NanumGothic', // 글꼴 설정
                        ),
                      ),
                    SizedBox(height: interval1Y),
                    // 새로운 흰색 카드뷰 섹션을 추가함
                    GestureDetector(
                      onTap: () {
                        // 상품 상세 화면으로 이동함
                        final product = ProductContent(
                          docId: productInfo['product_id'] ?? '',
                          category: productInfo['category']?.toString() ?? '',
                          productNumber:
                              productInfo['product_number']?.toString() ?? '',
                          thumbnail:
                              productInfo['thumbnails']?.toString() ?? '',
                          briefIntroduction:
                              productInfo['brief_introduction']?.toString() ??
                                  '',
                          originalPrice: productInfo['original_price'] ?? 0,
                          discountPrice: productInfo['discount_price'] ?? 0,
                          discountPercent: productInfo['discount_percent'] ?? 0,
                        );
                        navigatorProductDetailScreen.navigateToDetailScreen(
                            context, product);
                      },
                      child: Container(
                        // width: orderlistDtInfo3CardViewWidth,
                        // // 카드뷰 가로 크기 설정
                        // height: orderlistDtInfo3CardViewHeight,
                        // // 카드뷰 세로 크기 설정
                        color:
                            Theme.of(context).scaffoldBackgroundColor, // 배경색 설정
                        // color: GRAY97_COLOR,
                        child: CommonCardView(
                          backgroundColor: Theme.of(context)
                              .scaffoldBackgroundColor, // 배경색 설정
                          // backgroundColor: GRAY97_COLOR,
                          elevation: 0, // 그림자 깊이 설정
                          content: Padding(
                            padding: EdgeInsets.zero, // 패딩을 없앰
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 상품 번호와 간략 소개를 표시하는 _buildProductInfoRow 함수 호출
                                _buildProductInfoRow(
                                    context,
                                    productInfo['brief_introduction']
                                                ?.toString()
                                                .isNotEmpty ==
                                            true
                                        ? productInfo['brief_introduction']
                                        : '',
                                    '',
                                    bold: true,
                                    fontSize:
                                        orderlistDtInfoBriefIntroDataFontSize),
                                SizedBox(height: interval1Y),
                                _buildProductInfoRow(
                                    context,
                                    productInfo['product_number']
                                                ?.toString()
                                                .isNotEmpty ==
                                            true
                                        ? '상품번호: ${productInfo['product_number']}'
                                        : '',
                                    '',
                                    bold: true,
                                    fontSize:
                                        orderlistDtInfoProdNumberDataFontSize),
                                SizedBox(height: interval1Y),
                                // 상품의 썸네일 이미지와 가격 정보를 표시하는 행
                                Row(
                                  children: [
                                    // 썸네일 이미지를 표시하고, 없을 경우 대체 아이콘 표시
                                    Expanded(
                                      flex: 4,
                                      child: productInfo['thumbnails']
                                                  ?.toString()
                                                  .isNotEmpty ==
                                              true
                                          ? Image.network(
                                              productInfo['thumbnails'],
                                              fit: BoxFit.cover,
                                              // 이미지 로드 실패 시 아이콘 표시
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Icon(
                                                Icons.image_not_supported,
                                                color: GRAY88_COLOR,
                                                size: interval4X,
                                              ),
                                            )
                                          : Icon(
                                              Icons.image_not_supported,
                                              color: GRAY88_COLOR,
                                              size: interval4X,
                                            ),
                                    ), // 썸네일이 없을 때 아이콘을 표시
                                    SizedBox(width: interval1X),
                                    // 상품의 가격, 색상, 사이즈, 수량 정보를 표시
                                    Expanded(
                                      flex: 6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${numberFormat.format(productInfo['original_price']?.toString().isNotEmpty == true ? productInfo['original_price'] as num : '')}원',
                                            style: TextStyle(
                                              fontSize:
                                                  orderlistDtInfoOriginalPriceDataFontSize,
                                              fontFamily: 'NanumGothic',
                                              color: GRAY60_COLOR,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '${numberFormat.format(productInfo['discount_price']?.toString().isNotEmpty == true ? productInfo['discount_price'] as num : '')}원',
                                                style: TextStyle(
                                                  fontSize:
                                                      orderlistDtInfoDiscountPriceDataFontSize,
                                                  fontFamily: 'NanumGothic',
                                                  fontWeight: FontWeight.bold,
                                                  color: BLACK_COLOR,
                                                ),
                                              ),
                                              SizedBox(width: interval2X),
                                              Text(
                                                '${numberFormat.format(productInfo['discount_percent']?.toString().isNotEmpty == true ? productInfo['discount_percent'] as num : '')}%',
                                                style: TextStyle(
                                                  fontSize:
                                                      orderlistDtInfoDiscountPercentDataFontSize,
                                                  fontFamily: 'NanumGothic',
                                                  color: RED46_COLOR,
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
                                                      height:
                                                          orderlistDtInfoColorImageDataHeight,
                                                      width:
                                                          orderlistDtInfoColorImageDataWidth,
                                                      fit: BoxFit.cover,
                                                      // 이미지 로드 실패 시 아이콘 표시
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        color: GRAY88_COLOR,
                                                        size:
                                                            orderlistDtInfoColorImageDataHeight,
                                                      ),
                                                    )
                                                  : Icon(
                                                      Icons.image_not_supported,
                                                      color: GRAY88_COLOR,
                                                      size:
                                                          orderlistDtInfoColorImageDataHeight,
                                                    ),
                                              SizedBox(width: interval2X),
                                              // 선택된 색상 텍스트를 표시
                                              Text(
                                                productInfo['selected_color_text']
                                                            ?.toString()
                                                            .isNotEmpty ==
                                                        true
                                                    ? productInfo[
                                                        'selected_color_text']
                                                    : '',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize:
                                                      orderlistDtInfoColorTextDataFontSize,
                                                  fontFamily: 'NanumGothic',
                                                  fontWeight: FontWeight.bold,
                                                  color: BLACK_COLOR,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: interval1Y),
                                          // 선택된 사이즈와 수량을 표시
                                          Text(
                                            '${productInfo['selected_size']?.toString().isNotEmpty == true ? productInfo['selected_size'] : ''}',
                                            style: TextStyle(
                                              fontSize:
                                                  orderlistDtInfoSizeTextDataFontSize,
                                              fontFamily: 'NanumGothic',
                                              fontWeight: FontWeight.bold,
                                              color: BLACK_COLOR,
                                            ),
                                          ),
                                          SizedBox(height: interval1Y),
                                          Text(
                                            '${productInfo['selected_count']?.toString().isNotEmpty == true ? productInfo['selected_count'] : ''}개',
                                            style: TextStyle(
                                              fontSize:
                                                  orderlistDtInfoCountTextDataFontSize,
                                              fontFamily: 'NanumGothic',
                                              fontWeight: FontWeight.bold,
                                              color: BLACK_COLOR,
                                            ),
                                          ),
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
                    ),
                    SizedBox(height: interval4Y),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
// ------ 발주 목록 상세 화면 내 발주 목록 상세 내용을 표시하는 위젯 클래스인 OrderListDetailItemWidget 끝

// 결제 정보를 표시하는 행을 구성하는 함수
Widget _buildAmountRow(BuildContext context, String label, String value,
    {bool isTotal = false, double fontSize = 16}) {
  return Padding(
    padding: EdgeInsets.zero, // 패딩을 없앰
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 라벨을 표시하는 텍스트
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: 'NanumGothic',
            color: isTotal ? BLACK_COLOR : GRAY41_COLOR,
          ),
        ),
        // 값을 표시하는 텍스트
        Text(
          value ?? '',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: isTotal ? RED46_COLOR : BLACK_COLOR,
            fontFamily: 'NanumGothic',
          ),
        ),
      ],
    ),
  );
}

// 발주자 정보를 표시하는 행을 구성하는 함수
Widget _buildOrdererInfoRow(BuildContext context, String label, String value,
    {double fontSize = 16}) {
  return Padding(
    padding: EdgeInsets.zero, // 패딩을 없앰
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 라벨을 표시하는 텍스트
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: 'NanumGothic',
            color: GRAY41_COLOR,
          ),
        ),
        // 값을 표시하는 텍스트
        Text(
            value ?? '',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'NanumGothic',
              color: BLACK_COLOR,
            ),
          ),
      ],
    ),
  );
}

// 수령자 정보를 표시하는 행을 구성하는 함수
Widget _buildRecipientInfoRow(BuildContext context, String label, String value,
    {bool isLongText = false, double fontSize = 16}) {
  return Padding(
    padding: EdgeInsets.zero, // 패딩을 없앰
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 라벨을 표시하는 텍스트
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: 'NanumGothic',
            color: isLongText ? BLACK_COLOR : GRAY41_COLOR,
          ),
        ),
        // 값을 표시하는 텍스트 (말줄임 표시와 줄바꿈 가능)
        Expanded(
          child: Text(
            value ?? '',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'NanumGothic',
              color: BLACK_COLOR,
            ),
            textAlign: TextAlign.end,
            softWrap: true, // 텍스트가 한 줄을 넘길 때 자동으로 줄바꿈이 되도록 설정함
          ),
        ),
      ],
    ),
  );
}

// 상품 정보를 표시하는 행을 구성하는 함수
Widget _buildProductInfoRow(BuildContext context, String label, String value,
    {bool bold = false, double fontSize = 16}) {
  return Padding(
    padding: EdgeInsets.zero, // 패딩을 없앰
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 라벨을 표시하는 텍스트
        Text(
          label,
          style: TextStyle(
            fontFamily: 'NanumGothic',
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: BLACK_COLOR,
          ),
        ),
        // 값을 표시하는 텍스트 (말줄임 표시와 줄바꿈 가능)
        Expanded(
          child: Text(
            value ?? '',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'NanumGothic',
              color: BLACK_COLOR,
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
