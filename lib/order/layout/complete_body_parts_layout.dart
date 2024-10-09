import 'package:flutter/material.dart'; // 플러터 위젯 및 머터리얼 디자인 라이브러리 임포트
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위한 플러터 리버팟 라이브러리 임포트
import 'package:intl/intl.dart'; // 숫자 및 날짜 포맷을 위한 intl 라이브러리 임포트
import '../../common/const/colors.dart'; // 공통 색상 상수 파일 임포트
import '../../home/view/home_screen.dart'; // 홈 화면 관련 파일 임포트
import '../../product/model/product_model.dart';
import '../provider/order_all_providers.dart'; // 주문 관련 프로바이더 파일 임포트


// ------- 결제 완료 화면에 표시할 정보를 구성하는 CompletePaymentInfoWidget 클래스 내용 시작 부분
class CompletePaymentInfoWidget extends ConsumerWidget {
  // 필요한 결제 정보들을 필드로 선언
  final String orderNumber; // 주문 번호
  final String orderDate; // 주문 날짜
  final double totalPayment; // 총 결제 금액
  final String customerName; // 고객 이름
  final Map<String, dynamic> recipientInfo; // 수령인 정보
  final List<ProductContent> orderItems; // 주문 상품 목록

  // 생성자를 통해 필요한 결제 정보들을 초기화
  CompletePaymentInfoWidget({
    required this.orderNumber,
    required this.orderDate,
    required this.totalPayment,
    required this.customerName,
    required this.recipientInfo,
    required this.orderItems,
  });

  // 위젯의 UI를 구성하는 build 함수
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 업데이트 요청 완료 부분 수치
    final double updateRequireCompletePaddingX =
        screenSize.width * (32 / referenceWidth);
    final double updateRequireCompletePaddingY =
        screenSize.width * (24 / referenceWidth);
    final double updateRequireCompleteTitleFontSize =
        screenSize.height * (18 / referenceHeight);
    final double updateRequireCompleteSubTitleFontSize =
        screenSize.height * (16 / referenceHeight);

    final double updateRequireCompleteInfo1Y =
        screenSize.height * (20 / referenceHeight);
    final double updateRequireCompleteInfo2Y =
        screenSize.height * (40 / referenceHeight);

    // 버튼 관련 수치 동적 적용
    final double combackHomeBtn1X = screenSize.width * (15 / referenceWidth);
    final double combackHomeBtn1Y = screenSize.height * (50 / referenceHeight);
    final double combackHomeBtn2Y = screenSize.height * (200 / referenceHeight);
    final double combackHomeBtnFontSize = screenSize.height * (16 / referenceHeight);

    // 숫자 포맷을 설정 (천 단위 콤마 추가)
    final numberFormat = NumberFormat('###,###');
    // 계좌 번호를 비동기로 가져오기 위해 프로바이더를 구독
    final accountNumberFuture = ref.watch(accountNumberProvider);

    // 계좌 번호의 상태에 따라 다른 UI를 표시
    return accountNumberFuture.when(
      data: (accountNumber) {
        return Padding(
          padding: const EdgeInsets.all(16.0), // 전체 패딩 설정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: [
              Text(
                '발주완료', // 발주 완료 제목
                style: TextStyle(
                  fontSize: 24, // 폰트 크기 설정
                  fontWeight: FontWeight.bold, // 폰트 굵기 설정
                ),
              ),
              SizedBox(height: 16), // 간격
              Text(
                '[발주가 완료되었습니다.]', // 설명 텍스트
                style: TextStyle(
                  fontSize: 16, // 폰트 크기 설정
                ),
              ),
              SizedBox(height: 5), // 간격
              Text(
                '[안내 사항]', // 설명 텍스트
                style: TextStyle(
                  fontSize: 16, // 폰트 크기 설정
                ),
              ),
              SizedBox(height: 3), // 간격
              Text(
                '아래 계좌 정보로 입금해주시면 결제완료 처리 됩니다.',
                style: TextStyle(
                  fontSize: 14, // 폰트 크기 설정
                  color: Colors.grey, // 텍스트 색상 설정
                ),
              ),
              Text(
                '발주자와 입금자 성함은 같아야 합니다.',
                style: TextStyle(
                  fontSize: 14, // 폰트 크기 설정
                  color: Colors.grey, // 텍스트 색상 설정
                ),
              ),
              SizedBox(height: 16), // 간격
              // 각 정보 행을 표시하기 위한 함수 호출
              _buildInfoRow(context, '입금계좌안내', accountNumber),
              _buildInfoRow(context, '발주 번호', orderNumber),
              _buildInfoRow(context, '발주 일자', orderDate),
              _buildInfoRow(context, '총 결제 금액', '${numberFormat.format(totalPayment)}원'),
              _buildInfoRow(context, '발주자 성함', customerName),
              _buildInfoRow(context, '우편번호', recipientInfo['postal_code']),
              _buildInfoRow(context, '주소', recipientInfo['address']),
              _buildInfoRow(context, '상세주소', recipientInfo['detail_address']),
              SizedBox(height: 16), // 간격
              // 홈으로 이동하는 버튼
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeMainScreen()), // 홈 화면으로 이동
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: BUTTON_COLOR, // 버튼 텍스트 색상
                    backgroundColor: BACKGROUND_COLOR, // 버튼 배경 색상
                    side: BorderSide(color: BUTTON_COLOR), // 버튼 테두리 색상
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50), // 버튼 패딩
                  ),
                  child: Text('홈으로 이동', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // 버튼 텍스트
                ),
              ),
            ],
          ),
        );
      },
      loading: () => CircularProgressIndicator(), // 로딩 중일 때 표시할 위젯
      error: (error, stack) => Text('Error: $error'), // 에러 발생 시 표시할 텍스트
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
    final double updateRequireCompleteInfoTextFontSize =
        screenSize.height * (15 / referenceHeight);
    final double updateRequireCompleteInfoDataFontSize =
        screenSize.height * (14 / referenceHeight);
    final double updateRequireCompleteInfoTextPartWidth =
        screenSize.width * (110 / referenceWidth);
    final double updateRequireCompleteInfoTextPartHeight =
        screenSize.height * (40 / referenceHeight);
    // 행 간 간격 수치
    final double updateRequireCompleteInfo4Y =
        screenSize.height * (3 / referenceHeight);
    final double updateRequireCompleteInfo5Y =
        screenSize.height * (6 / referenceHeight);
    // 데이터 부분 패딩 수치
    final double updateRequireCompleteInfoDataPartX =
        screenSize.width * (8 / referenceWidth);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: updateRequireCompleteInfo4Y), // 행 간 간격 조정
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
          children: [
            Container(
              height: updateRequireCompleteInfoTextPartHeight,
              width: updateRequireCompleteInfoTextPartWidth,
              color: Color(0xFFF2F2F2), // 배경 색상 설정
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NanumGothic',
                  fontSize: updateRequireCompleteInfoTextFontSize,
                  color: Colors.black,
                ),  // 텍스트 스타일 설정
              ),
            ),
            SizedBox(width: updateRequireCompleteInfo5Y), // 왼쪽과 오른쪽 사이 간격 추가
            Expanded(
              child: Container(
                color: Color(0xFFFBFBFB), // 배경 색상 설정
                padding: EdgeInsets.only(left: updateRequireCompleteInfoDataPartX),
                alignment: Alignment.centerLeft, // 텍스트 정렬
                child: Text(value,
                  style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: updateRequireCompleteInfoDataFontSize,
                    color: Colors.black,
                  ),), // 값 표시
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ------- 결제 완료 화면에 표시할 정보를 구성하는 CompletePaymentInfoWidget 클래스 내용 끝 부분
