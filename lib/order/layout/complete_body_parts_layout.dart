import 'package:flutter/material.dart'; // 플러터 위젯 및 머터리얼 디자인 라이브러리 임포트
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위한 플러터 리버팟 라이브러리 임포트
import 'package:intl/intl.dart'; // 숫자 및 날짜 포맷을 위한 intl 라이브러리 임포트
import '../../common/const/colors.dart'; // 공통 색상 상수 파일 임포트
import '../../home/view/home_screen.dart'; // 홈 화면 관련 파일 임포트
import '../provider/order_all_providers.dart'; // 주문 관련 프로바이더 파일 임포트


// ------- 결제 완료 화면에 표시할 정보를 구성하는 CompletePaymentInfoWidget 클래스 내용 시작 부분
class CompletePaymentInfoWidget extends ConsumerWidget {
  // 필요한 결제 정보들을 필드로 선언
  final String orderNumber; // 주문 번호
  final String orderDate; // 주문 날짜
  final double totalPayment; // 총 결제 금액
  final String customerName; // 고객 이름
  final Map<String, dynamic> recipientInfo; // 수령인 정보

  // 생성자를 통해 필요한 결제 정보들을 초기화
  CompletePaymentInfoWidget({
    required this.orderNumber,
    required this.orderDate,
    required this.totalPayment,
    required this.customerName,
    required this.recipientInfo,
  });

  // 위젯의 UI를 구성하는 build 함수
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              _buildInfoRow('입금계좌안내', accountNumber),
              _buildInfoRow('발주 번호', orderNumber),
              _buildInfoRow('발주 일자', orderDate),
              _buildInfoRow('총 결제 금액', '${numberFormat.format(totalPayment)}원'),
              _buildInfoRow('발주자 성함', customerName),
              _buildInfoRow('우편번호', recipientInfo['postal_code']),
              _buildInfoRow('주소', recipientInfo['address']),
              _buildInfoRow('상세주소', recipientInfo['detail_address']),
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
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // 행 간 간격 조정
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
          children: [
            Container(
              width: 100, // 라벨 셀의 너비 설정
              color: Colors.grey.shade200, // 배경 색상 설정
              padding: const EdgeInsets.all(8.0), // 패딩 설정
              alignment: Alignment.topLeft, // 텍스트 정렬
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold), // 텍스트 스타일 설정
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white, // 배경 색상 설정
                padding: const EdgeInsets.all(8.0), // 패딩 설정
                alignment: Alignment.topLeft, // 텍스트 정렬
                child: Text(value), // 값 표시
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ------- 결제 완료 화면에 표시할 정보를 구성하는 CompletePaymentInfoWidget 클래스 내용 끝 부분
