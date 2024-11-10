
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../common/layout/common_exception_parts_of_body_layout.dart';
import '../../product/layout/product_body_parts_layout.dart';
import '../../product/model/product_model.dart';
import '../provider/order_all_providers.dart';
import '../provider/order_state_provider.dart';
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
        screenSize.height * (10 / referenceHeight);
    final double updateRequireNoticeFontSize2 =
        screenSize.height * (9 / referenceHeight);

    final double ordererInfo1Y =
        screenSize.height * (16 / referenceHeight);
    final double ordererInfo2Y =
        screenSize.height * (24 / referenceHeight);
    final double ordererInfo3Y =
        screenSize.height * (8 / referenceHeight);

    // 에러 관련 텍스트 수치
    final double errorTextFontSize1 = screenSize.height * (14 / referenceHeight);
    final double errorTextFontSize2 = screenSize.height * (12 / referenceHeight);
    final double errorTextHeight = screenSize.height * (600 / referenceHeight);

    final userInfoAsyncValue = ref.watch(
        userInfoProvider(email)); // Riverpod을 사용하여 사용자 정보 프로바이더를 구독

    return userInfoAsyncValue.when(
      data: (userInfo) {
        // userInfo가 null인 경우에도 표를 유지하고, 데이터 필드에 ''를 표시
        final name = userInfo?['name'] ?? '';
        final email = userInfo?['email'] ?? '';
        final phoneNumber = userInfo?['phone_number'] ?? '';

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
                '요청자 정보', // 발주자 정보 제목 텍스트
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: ordererInfoTitleFontSize,
                  fontWeight: FontWeight.bold, // 텍스트 굵게 설정
                  color: BLACK_COLOR,
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
                '[정보 불일치로 인한 불이익시 당사가 책임지지 않습니다.]', // 안내문 텍스트
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: updateRequireNoticeFontSize1,
                  color: GRAY35_COLOR,
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
                  color: GRAY35_COLOR,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => buildCommonLoadingIndicator(), // 공통 로딩 인디케이터 호출
      error: (error, stack) => Container( // 에러 상태에서 중앙 배치
        height: errorTextHeight, // 전체 화면 높이 설정
        alignment: Alignment.center, // 중앙 정렬
        child: buildCommonErrorIndicator(
          message: '에러가 발생했으니, 앱을 재실행해주세요.', // 첫 번째 메시지 설정
          secondMessage: '에러가 반복될 시, \'문의하기\'에서 문의해주세요.', // 두 번째 메시지 설정
          fontSize1: errorTextFontSize1, // 폰트1 크기 설정
          fontSize2: errorTextFontSize2, // 폰트2 크기 설정
          color: BLACK_COLOR, // 색상 설정
          showSecondMessage: true, // 두 번째 메시지를 표시하도록 설정
        ),
      ),
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
              color: GRAY96_COLOR,
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
                    color: BLACK_COLOR,
                ), // 텍스트 스타일 설정
              ),
            ),
            SizedBox(width: ordererInfo5Y), // 왼쪽과 오른쪽 사이 간격 추가
            Expanded(
              child: Container(
                color: GRAY98_COLOR, // 배경 색상 설정
              // color: Colors.red, // 배경 색상 설정
                padding: EdgeInsets.only(left: ordererInfoDataPartX),
                alignment: Alignment.centerLeft, // 텍스트 정렬
                child: Text(value,
                  style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: ordererInfoDataFontSize,
                    color: BLACK_COLOR,
                  ),
                ), // 값 표시
              ),
            ),
          ],
        ),
      ),
    );
  }
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
    final double updateRequirePadding1X =
        screenSize.width * (24 / referenceWidth);
    final double updateRequirePadding2X =
        screenSize.width * (20 / referenceWidth);
    final double updateRequirePadding3X =
        screenSize.width * (110 / referenceWidth);
    final double updateRequirePaddingY =
        screenSize.height * (60 / referenceHeight);
    final double updateInfoTitleFontSize =
        screenSize.height * (18 / referenceHeight);
    final double updateRequireNoticeFontSize1 =
        screenSize.height * (13 / referenceHeight);
    final double guidelineText1FontSize =
        screenSize.height * (11 / referenceHeight); // 텍스트 크기
    final double guidelineText2FontSize =
        screenSize.height * (11 / referenceHeight); // 텍스트 크기

    final double updateInfo1Y =
        screenSize.height * (12 / referenceHeight);
    final double updateInfo2Y =
        screenSize.height * (10 / referenceHeight);
    final double updateInfo3Y =
        screenSize.height * (30 / referenceHeight);

    return Padding(
      padding: EdgeInsets.only(left: updateRequirePadding1X, right: updateRequirePadding1X, top: updateRequirePaddingY),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
        children: [
          Text(
            '업데이트 정보', // 결제 방법 제목 텍스트
            style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: updateInfoTitleFontSize,
              fontWeight: FontWeight.bold, // 텍스트 굵게 설정
              color: BLACK_COLOR,
            ),
          ),
          SizedBox(height: updateInfo1Y),
          Text(
            "* 품목별로 유통사 재고 확인 후 별도 안내 예정입니다.", // 설명 텍스트
            style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: updateRequireNoticeFontSize1,
              // fontWeight: FontWeight.bold, // 텍스트 굵게 설정
              color: BLACK_COLOR,
            ),
          ),
          SizedBox(height: updateInfo2Y),
          Text(
            "* 해당 요청 품목 업데이트는 1~2일 소요될 수 있습니다.", // 설명 텍스트
            style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: updateRequireNoticeFontSize1,
              // fontWeight: FontWeight.bold, // 텍스트 굵게 설정
              color: BLACK_COLOR,
            ),
          ),
          SizedBox(height: updateInfo2Y),
          Text(
            "* 중간 도매 가격은 별도 소통 진행합니다.", // 설명 텍스트
            style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: updateRequireNoticeFontSize1,
              // fontWeight: FontWeight.bold, // 텍스트 굵게 설정
              color: BLACK_COLOR,
            ),
          ),
          SizedBox(height: updateInfo3Y),
          // 개인정보 처리방침 안내 텍스트
          Padding(
            padding: EdgeInsets.only(left: updateRequirePadding2X),
            child: Text(
              '업데이트 요청을 완료함으로써 개인정보 처리방침에 동의합니다.',
              style: TextStyle(
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.normal,
                fontSize: guidelineText1FontSize,
                color: BLACK_COLOR, // 텍스트 색상을 검정으로 설정
              ),
            ),
          ),
          SizedBox(height: updateInfo2Y),
          // 개인정보 처리방침 보기 링크
          Padding(
            padding: EdgeInsets.only(left: updateRequirePadding3X),
            child: GestureDetector( // GestureDetector 사용하여 탭 이벤트 처리
              onTap: () async {
                const url = 'https://gshe.oopy.io/couture/privacy'; // 열려는 URL
                try {
                  final bool launched = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication); // 외부 브라우저에서 URL 열기
                  if (!launched) {
                    // 웹 페이지를 열지 못할 경우 스낵바로 알림
                    showCustomSnackBar(context, '웹 페이지를 열 수 없습니다.');
                  }
                } catch (e) {
                  // 예외 발생 시 스낵바로 에러 메시지 출력
                  showCustomSnackBar(context, '에러가 발생했습니다.\n앱을 재실행해주세요.');
                }
              },
              child: Text(
                '개인정보 처리방침 보기',
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.normal,
                  fontSize: guidelineText2FontSize,
                  color: BLUE49_COLOR, // 텍스트 색상을 파란색으로 설정
                  decoration: TextDecoration.underline, // 밑줄 추가하여 링크처럼 보이게
                  decorationColor: BLUE49_COLOR, // 밑줄 색상도 파란색으로 설정
                  decorationStyle: TextDecorationStyle.solid, // 밑줄 스타일 설정
                ),
              ),
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
    final double updateRequireBtn1Y = screenSize.height * (15 / referenceHeight);
    final double updateRequireBtn2Y = screenSize.height * (50 / referenceHeight);
    final double updateRequireBtnFontSize = screenSize.height * (16 / referenceHeight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // 자식 위젯들을 중앙 정렬
      children: [
        SizedBox(height: updateRequireBtn1Y), // 개인정보 처리방침 텍스트와 버튼 사이에 여백 추가
        // '업데이트 요청하기' 버튼을 중앙에 위치시킴
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: SOFTGREEN60_COLOR, // 버튼 텍스트 색상 설정
              backgroundColor: SOFTGREEN60_COLOR,  // 버튼 배경 색상 설정
              side: BorderSide(color: SOFTGREEN60_COLOR,), // 버튼 테두리 색상 설정
              padding: EdgeInsets.symmetric(vertical: updateRequireBtn1X, horizontal: updateRequireBtn2Y), // 패딩을 늘려 버튼 크기를 조정
            ),
            onPressed: () async {
              // 쪽지 삭제 버튼 클릭 시 확인 다이얼로그를 표시함
              await showSubmitAlertDialog(
                context,
                title: '[업데이트 요청]', // 다이얼로그 제목 설정
                content: '업데이트 요청 시, 1~2일 소요될 수 있습니다.\n유통사 재고 확인 후 별도 안내하겠습니다.', // 다이얼로그 내용 설정
                actions: buildAlertActions(
                  context,
                  noText: '아니요', // 아니요 버튼 텍스트 설정
                  yesText: '예', // 예 버튼 텍스트 설정
                  noTextStyle: TextStyle(
                    fontFamily: 'NanumGothic',
                    color: BLACK_COLOR, // 아니요 버튼 텍스트 색상 설정
                    fontWeight: FontWeight.bold, // 아니요 버튼 텍스트 굵기 설정
                  ),
                  yesTextStyle: TextStyle(
                    fontFamily: 'NanumGothic',
                    color: RED46_COLOR, // 예 버튼 텍스트 색상 설정
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

    // 발주내역 화면 내 카드뷰 섹션의 가로와 세로 비율 계산
    final double orderlistInfoCardViewWidth =
        screenSize.width * (360 / referenceWidth); // 가로 비율 계산
    final double orderlistInfoCardViewHeight =
        screenSize.height * (160 / referenceHeight); // 세로 비율 계산

    // body 부분 전체 패딩 수치 계산
    final double orderlistInfoCardViewPaddingX = screenSize.width * (15 / referenceWidth); // 좌우 패딩 계산
    final double orderlistInfoCardViewPadding1Y = screenSize.height * (10 / referenceHeight); // 상하 패딩 계산

    // 텍스트 크기 계산
    final double orderlistInfoOrderDateDataFontSize =
        screenSize.height * (18 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistInfoOrderNumberDataFontSize =
        screenSize.height * (15 / referenceHeight); // 텍스트 크기 비율 계산

    // 발주내역 상세보기 버튼과 삭제 버튼의 가로, 세로 비율 계산
    final double orderlistInfoDetailViewBtn1X =
        screenSize.width * (150 / referenceWidth); // 발주내역 상세보기 버튼 가로 비율 계산
    final double orderlistInfoDetailViewBtn1Y =
        screenSize.height * (45 / referenceHeight); // 발주내역 상세보기 버튼 세로 비율 계산
    final double orderlistInfoDetailViewBtnFontSize =
        screenSize.height * (14 / referenceHeight); // 발주내역 상세보기 버튼 텍스트 크기 비율 계산
    final double orderlistInfoDetailViewBtnPaddingX = screenSize.width * (12 / referenceWidth); // 발주내역 상세보기 버튼 좌우 패딩 계산
    final double orderlistInfoDetailViewBtnPaddingY = screenSize.height * (5 / referenceHeight); // 발주내역 상세보기 버튼 상하 패딩 계산
    final double deleteBtn1X =
        screenSize.width * (80 / referenceWidth); // 삭제 버튼 가로 비율 계산
    final double deleteBtn1Y =
        screenSize.height * (45 / referenceHeight); // 삭제 버튼 세로 비율 계산
    final double deleteBtnFontSize =
        screenSize.height * (14 / referenceHeight); // 삭제 버튼 텍스트 크기 비율 계산
    final double deleteBtnPaddingX = screenSize.width * (12 / referenceWidth); // 삭제 버튼 좌우 패딩 계산
    final double deleteBtnPaddingY = screenSize.height * (5 / referenceHeight); // 삭제 버튼 상하 패딩 계산

    // 발주내역 카드뷰 섹션 내 컨텐츠 사이의 간격 계산
    final double interval1Y = screenSize.height * (8 / referenceHeight); // 세로 간격 1 계산
    final double interval2Y = screenSize.height * (12 / referenceHeight); // 세로 간격 2 계산
    final double interval1X = screenSize.width * (50 / referenceWidth); // 가로 간격 1 계산
    final double interval2X = screenSize.width * (10 / referenceWidth); // 가로 간격 2 계산

    // 날짜 포맷을 지정.
    final dateFormat = DateFormat('yyyy.MM.dd');
    // 발주일자를 타임스탬프에서 DateTime 객체로 변환.
    final orderDate = (order!['numberInfo']['order_date'] as Timestamp).toDate();
    // 발주번호를 가져옴.
    final orderNumber = order!['numberInfo']['order_number'];


    // 클립 위젯을 사용하여 모서리를 둥글게 설정함
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
      child: Container(
        width: orderlistInfoCardViewWidth, // 카드뷰 가로 크기 설정
        height: orderlistInfoCardViewHeight, // 카드뷰 세로 크기 설정
        color: GRAY97_COLOR, // 배경색 설정
        child: CommonCardView( // 공통 카드뷰 위젯 사용
          backgroundColor: GRAY97_COLOR, // 배경색 설정
          elevation: 0, // 그림자 깊이 설정
          content: Padding( // 패딩 설정
            padding: EdgeInsets.symmetric(vertical: orderlistInfoCardViewPadding1Y, horizontal: orderlistInfoCardViewPaddingX), // 상하 좌우 패딩 설정
            child: Column( // 컬럼 위젯으로 구성함
              // 자식 위젯들을 왼쪽 정렬.
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 발주일자를 텍스트로 표시.
                Text(
                  '요청 일자: ${orderDate != null ? dateFormat.format(orderDate) : ''}',
                  style: TextStyle(
                    fontSize: orderlistInfoOrderDateDataFontSize, // 텍스트 크기 설정
                    fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                    fontFamily: 'NanumGothic', // 글꼴 설정
                    color: BLACK_COLOR, // 텍스트 색상 설정
                  ),
                ),
                // 여백을 추가.
                SizedBox(height: interval1Y),
                // 발주번호를 텍스트로 표시.
                Text(
                  '요청 접수번호: ${orderNumber ?? ''}',
                  style: TextStyle(
                    fontSize: orderlistInfoOrderNumberDataFontSize, // 텍스트 크기 설정
                    fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                    fontFamily: 'NanumGothic', // 글꼴 설정
                    color: GRAY41_COLOR, // 텍스트 색상 설정
                  ),
                ),
                // 여백을 추가.
                SizedBox(height: interval2Y),
                // 회원정보 수정 및 로그아웃 버튼을 행(Row)으로 배치함
                Row(
                  children: [
                    Container(
                      width: orderlistInfoDetailViewBtn1X, // 발주내역 상세보기 버튼 가로 설정
                      height: orderlistInfoDetailViewBtn1Y, // 발주내역 상세보기 버튼 세로 설정
                      margin: EdgeInsets.only(left: interval1X), // 왼쪽 여백 설정
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
                            foregroundColor: SOFTGREEN60_COLOR, // 버튼의 글자 색상을 설정함
                            backgroundColor: SOFTGREEN60_COLOR, // 버튼의 배경 색상을 설정함
                            padding: EdgeInsets.symmetric(vertical: orderlistInfoDetailViewBtnPaddingY, horizontal: orderlistInfoDetailViewBtnPaddingX), // 패딩 설정
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45), // 모서리 둥글게 설정
                            ),
                          ),
                          child: Text( // 버튼에 표시될 텍스트를 정의함
                            '요청 내역 상세보기', // 텍스트 내용으로 '발주 내역 상세보기'를 설정함
                            style: TextStyle(
                              fontSize: orderlistInfoDetailViewBtnFontSize, // 텍스트 크기 설정
                              fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                              fontFamily: 'NanumGothic', // 글꼴 설정
                              color: WHITE_COLOR, // 텍스트 색상 설정
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: deleteBtn1X, // 삭제 버튼 가로 설정
                        height: deleteBtn1Y, // 삭제 버튼 세로 설정
                        margin: EdgeInsets.only(left: interval2X), // 왼쪽 여백 설정
                        child: ElevatedButton( // 두 번째 ElevatedButton 위젯을 생성함
                          onPressed: () async { // 비동기 함수로 버튼이 눌렸을 때 실행될 함수를 정의함
                            await showSubmitAlertDialog( // 알림 대화상자를 표시하기 위해 showSubmitAlertDialog를 호출함
                              context, // 현재 화면의 컨텍스트를 전달함
                              title: '[요청 내역 삭제]', // 대화상자의 제목으로 '발주 내역 삭제'를 설정함
                              content: '삭제 시, 해당 내역은 영구적으로 삭제됩니다.\n작성하신 요청 내역을 삭제하시겠습니까?', // 대화상자의 내용으로 경고 메시지를 설정함
                              actions: buildAlertActions( // 대화상자에 표시될 액션 버튼들을 설정함
                                context, // 현재 화면의 컨텍스트를 전달함
                                noText: '아니요', // '아니요' 버튼의 텍스트를 설정함
                                yesText: '예', // '예' 버튼의 텍스트를 설정함
                                noTextStyle: TextStyle( // '아니요' 버튼의 텍스트 스타일을 설정함
                                  color: BLACK_COLOR, // '아니요' 버튼의 글자 색상을 검정색으로 설정함
                                  fontWeight: FontWeight.bold, // '아니요' 버튼의 글자 굵기를 굵게 설정함
                                ),
                                yesTextStyle: TextStyle( // '예' 버튼의 텍스트 스타일을 설정함
                                  color: RED46_COLOR, // '예' 버튼의 글자 색상을 빨간색으로 설정함
                                  fontWeight: FontWeight.bold, // '예' 버튼의 글자 굵기를 굵게 설정함
                                ),
                                onYesPressed: () async { // '예' 버튼이 눌렸을 때 실행될 비동기 함수를 정의함
                                  try {
                                    // orderlistItemsProvider에서 OrderlistItemsNotifier를 읽어와 호출함.
                                    await ref.read(orderlistItemsProvider.notifier)
                                    // deleteOrderItem 함수에 발주 번호를 매개변수로 전달하여 발주 항목 삭제 요청을 보냄.
                                        .deleteOrderItems(orderNumber);
                                    Navigator.of(context).pop(); // 성공적으로 삭제된 후 대화상자를 닫음
                                    showCustomSnackBar(context, '요청 내역이 삭제되었습니다.'); // 삭제 성공 메시지를 스낵바로 표시함(성공 메시지 텍스트를 설정함)
                                  } catch (e) { // 삭제 중 오류가 발생했을 때의 예외 처리를 정의함
                                    showCustomSnackBar(context, '요청 내역 삭제 중 오류가 발생했습니다: $e'); // 오류 메시지를 스낵바로 표시함
                                  }
                                },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom( // 두 번째 버튼의 스타일을 설정함
                            foregroundColor: SOFTGREEN60_COLOR, // 두 번째 버튼의 글자 색상을 설정함
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 버튼 배경색을 앱 배경색으로 설정
                            side: BorderSide(color: SOFTGREEN60_COLOR), // 버튼 테두리 색상 설정
                            padding: EdgeInsets.symmetric(vertical: deleteBtnPaddingY, horizontal: deleteBtnPaddingX), // 패딩 설정
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45), // 모서리 둥글게 설정
                            ),
                          ),
                        child: Text( // 두 번째 버튼에 표시될 텍스트를 정의함
                          '삭제', // 텍스트 내용으로 '삭제'를 설정함
                          style: TextStyle(
                            fontSize: deleteBtnFontSize, // 텍스트 크기 설정
                            fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                            fontFamily: 'NanumGothic', // 글꼴 설정
                            color: SOFTGREEN60_COLOR, // 텍스트 색상 설정
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
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 발주내역 상세 화면 내 카드뷰 섹션의 가로와 세로 비율 계산
    final double orderlistDtInfo1CardViewWidth =
        screenSize.width * (360 / referenceWidth); // 가로 비율 계산
    final double orderlistDtInfo1CardViewHeight =
        screenSize.height * (95 / referenceHeight); // 세로 비율 계산
    final double orderlistDtInfo2CardViewWidth =
        screenSize.width * (360 / referenceWidth); // 가로 비율 계산
    final double orderlistDtInfo2CardViewHeight =
        screenSize.height * (220 / referenceHeight); // 세로 비율 계산
    final double orderlistDtInfo3CardViewWidth =
        screenSize.width * (360 / referenceWidth); // 가로 비율 계산
    final double orderlistDtInfo3CardViewHeight =
        screenSize.height * (200 / referenceHeight); // 세로 비율 계산

    // body 부분 전체 패딩 수치 계산
    final double orderlistDtInfoCardViewPaddingX = screenSize.width * (5 / referenceWidth); // 좌우 패딩 계산
    final double orderlistDtInfoCardViewPadding1Y = screenSize.height * (5 / referenceHeight); // 상하 패딩 계산

    // 텍스트 크기 계산
    final double orderlistDtInfoOrderDateDataFontSize =
        screenSize.height * (18 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoOrderNumberDataFontSize =
        screenSize.height * (15 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoBriefIntroDataFontSize =
        screenSize.height * (16 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoProdNumberDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoOriginalPriceDataFontSize =
        screenSize.height * (15 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoDiscountPriceDataFontSize =
        screenSize.height * (18 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoDiscountPercentDataFontSize =
        screenSize.height * (22 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoColorImageDataWidth =
        screenSize.width * (16 / referenceWidth); // 색상 이미지 가로 크기 설정함
    final double orderlistDtInfoColorImageDataHeight =
        screenSize.width * (16 / referenceWidth); // 색상 이미지 세로 크기 설정함
    final double orderlistDtInfoColorTextDataFontSize =
        screenSize.height * (16 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoSizeTextDataFontSize =
        screenSize.height * (15 / referenceHeight); // 텍스트 크기 비율 계산

    // 발주내역 카드뷰 섹션 내 컨텐츠 사이의 간격 계산
    final double interval1Y = screenSize.height * (4 / referenceHeight); // 세로 간격 1 계산
    final double interval2Y = screenSize.height * (8 / referenceHeight); // 세로 간격 2 계산
    final double interval3Y = screenSize.height * (15 / referenceHeight); // 세로 간격 3 계산
    final double interval4Y = screenSize.height * (2 / referenceHeight); // 세로 간격 4 계산
    final double interval1X = screenSize.width * (40 / referenceWidth); // 가로 간격 1 계산
    final double interval2X = screenSize.width * (10 / referenceWidth); // 가로 간격 2 계산
    final double interval3X = screenSize.width * (70 / referenceWidth); // 가로 간격 3 계산

    // 날짜 형식을 'yyyy-MM-dd'로 지정함
    final dateFormat = DateFormat('yyyy.MM.dd');

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
        : '';

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
          // 클립 위젯을 사용하여 모서리를 둥글게 설정함
          ClipRRect(
            borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
            child: Container(
              width: orderlistDtInfo1CardViewWidth, // 카드뷰 가로 크기 설정
              height: orderlistDtInfo1CardViewHeight, // 카드뷰 세로 크기 설정
              color: GRAY97_COLOR, // 배경색 설정
              child: CommonCardView( // 공통 카드뷰 위젯 사용
                backgroundColor: GRAY97_COLOR, // 배경색 설정
                elevation: 0, // 그림자 깊이 설정
                content: Padding( // 패딩 설정
                  padding: EdgeInsets.symmetric(vertical: orderlistDtInfoCardViewPadding1Y, horizontal: orderlistDtInfoCardViewPaddingX), // 상하 좌우 패딩 설정
                  child: Column( // 컬럼 위젯으로 구성함
                    // 자식 위젯들을 왼쪽 정렬.
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    // 발주일자를 텍스트로 표시.
                    Text(
                    '요청 일자: ${orderDate != null ? dateFormat.format(orderDate) : ''}',
                    style: TextStyle(
                      fontSize: orderlistDtInfoOrderDateDataFontSize, // 텍스트 크기 설정
                      fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                      fontFamily: 'NanumGothic', // 글꼴 설정
                      color: BLACK_COLOR, // 텍스트 색상 설정
                      ),
                    ),
                    // 여백을 추가.
                    SizedBox(height: interval2Y),
                    // 발주번호를 텍스트로 표시.
                    Text(
                      '요청 접수번호: ${orderNumber ?? ''}',
                      style: TextStyle(
                        fontSize: orderlistDtInfoOrderNumberDataFontSize, // 텍스트 크기 설정
                        fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                        fontFamily: 'NanumGothic', // 글꼴 설정
                        color: GRAY41_COLOR, // 텍스트 색상 설정
                      ),
                     ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: interval3Y),
          // 각 상품 정보를 표시하는 로직을 반복문으로 구성함
          for (var productInfo in productInfoList)...[
            // 클립 위젯을 사용하여 모서리를 둥글게 설정함
            ClipRRect(
              borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
              child: Container(
                // width: orderlistDtInfo2CardViewWidth, // 카드뷰 가로 크기 설정
                // height: orderlistDtInfo2CardViewHeight, // 카드뷰 세로 크기 설정
                color: GRAY97_COLOR, // 배경색 설정
                child: CommonCardView(
                  backgroundColor: GRAY97_COLOR, // 배경색 설정
                  elevation: 0, // 그림자 깊이 설정
                  content: Padding(
                    padding: EdgeInsets.zero, // 패딩을 없앰
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 새로운 흰색 카드뷰 섹션을 추가함
                        GestureDetector(
                          onTap: () {
                            // 상품 상세 화면으로 이동함
                            final product = ProductContent(
                              docId: productInfo['product_id'] ?? '',
                              category: productInfo['category']?.toString() ??
                                  '',
                              productNumber: productInfo['product_number']
                                  ?.toString() ??
                                  '',
                              thumbnail:
                              productInfo['thumbnails']?.toString() ?? '',
                              briefIntroduction: productInfo['brief_introduction']
                                  ?.toString() ??
                                  '',
                              originalPrice: productInfo['original_price'] ?? '',
                              discountPrice: productInfo['discount_price'] ?? '',
                              discountPercent: productInfo['discount_percent'] ?? '',
                            );
                            navigatorProductDetailScreen.navigateToDetailScreen(
                                context, product);
                          },
                          child: Container(
                            // width: orderlistDtInfo3CardViewWidth, // 카드뷰 가로 크기 설정
                            // height: orderlistDtInfo3CardViewHeight, // 카드뷰 세로 크기 설정
                            color: GRAY97_COLOR, // 배경색 설정
                            child: CommonCardView(
                              backgroundColor: GRAY97_COLOR, // 배경색 설정
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
                                        fontSize: orderlistDtInfoBriefIntroDataFontSize),
                                    SizedBox(height: interval1Y),
                                    _buildProductInfoRow(
                                        context,
                                        productInfo['product_number']?.toString().isNotEmpty ==
                                            true
                                            ? '상품 번호: ${productInfo['product_number']}'
                                            : '',
                                        '',
                                        bold: true,
                                        fontSize: orderlistDtInfoProdNumberDataFontSize),
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
                                                ? Image.network(productInfo['thumbnails'],
                                                fit: BoxFit.cover)
                                                : Icon(Icons.image_not_supported, size: interval3X)),
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
                                                  fontSize: orderlistDtInfoOriginalPriceDataFontSize,
                                                  fontFamily: 'NanumGothic',
                                                  color: GRAY60_COLOR,
                                                  decoration: TextDecoration.lineThrough,
                                                ),
                                              ),
                                              SizedBox(height: interval4Y),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${numberFormat.format(productInfo['discount_price']?.toString().isNotEmpty == true ? productInfo['discount_price'] as num : '')}원',
                                                    style: TextStyle(
                                                      fontSize: orderlistDtInfoDiscountPriceDataFontSize,
                                                      fontFamily: 'NanumGothic',
                                                      fontWeight: FontWeight.bold,
                                                      color: BLACK_COLOR,
                                                    ),
                                                  ),
                                                  // SizedBox(width: interval2X),
                                                  // Text(
                                                  //   '${(productInfo['discount_percent']?.toString().isNotEmpty == true ? productInfo['discount_percent'] as num : 0.0).toInt()}%',
                                                  //   style: TextStyle(
                                                  //     fontSize: orderlistDtInfoDiscountPercentDataFontSize,
                                                  //     fontFamily: 'NanumGothic',
                                                  //     color: Colors.red,
                                                  //     fontWeight: FontWeight.bold,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              SizedBox(height: interval4Y),
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
                                                    height: orderlistDtInfoColorImageDataHeight,
                                                    width: orderlistDtInfoColorImageDataWidth,
                                                    fit: BoxFit.cover,
                                                  )
                                                      : Icon(
                                                      Icons.image_not_supported,
                                                      size: orderlistDtInfoColorImageDataHeight),
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
                                                      fontSize: orderlistDtInfoColorTextDataFontSize,
                                                      fontFamily: 'NanumGothic',
                                                      fontWeight: FontWeight.bold,
                                                      color: BLACK_COLOR,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: interval4Y),
                                              // 선택된 사이즈와 수량을 표시
                                              Text(
                                                  '${productInfo['selected_size']?.toString().isNotEmpty == true ? productInfo['selected_size'] : ''}',
                                                style: TextStyle(
                                                  fontSize: orderlistDtInfoSizeTextDataFontSize,
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
                     ],
                   ),
                 ),
               ),
             ),
           ),
           SizedBox(height: interval2Y), // 각 카드뷰 섹션 사이에 간격 interval2Y 추가
        ],
       ],
     );
   }
 }
 // 발주 목록 상세 화면 내 발주 목록 상세 내용을 표시하는 위젯 클래스인 OrderListDetailItemWidget 끝

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
