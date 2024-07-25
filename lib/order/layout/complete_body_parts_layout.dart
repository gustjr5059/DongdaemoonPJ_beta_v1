import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/const/colors.dart';
import '../../home/view/home_screen.dart'; // 숫자 포맷을 위해 임포트


// ------ 결제완료 화면 내 UI 구현 관련 CompletePaymentInfoWidget 클래스 내용 시작 부분
class CompletePaymentInfoWidget extends StatelessWidget {
  // 필요한 정보를 받기 위한 필드들
  final String bankAccount;  // 은행 계좌 정보
  final String orderNumber;  // 주문 번호
  final String orderDate;  // 주문 날짜
  final double totalPayment;  // 총 결제 금액
  final String customerName;  // 고객 이름
  final String address;  // 배송지

  CompletePaymentInfoWidget({
    // 생성자에서 필요한 정보를 모두 받아옴
    required this.bankAccount,
    required this.orderNumber,
    required this.orderDate,
    required this.totalPayment,
    required this.customerName,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    // 숫자를 포맷하기 위한 NumberFormat 객체 생성
    final numberFormat = NumberFormat('###,###');

    return Padding(
      // 전체 패딩 설정
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // 열 정렬 설정
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 주문완료 텍스트
          Text(
            '주문완료',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16), // 간격
          // 주문이 완료되었습니다 텍스트
          Text(
            '주문이 완료되었습니다.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          // 계좌 정보 안내 텍스트
          Text(
            '아래 계좌 정보로 입금해 주시면 결제가 완료처리가 됩니다.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 16), // 간격
          // 정보를 보여주기 위한 테이블
          Table(
            border: TableBorder.all(color: Colors.grey.shade300),
            columnWidths: {
              0: FlexColumnWidth(1), // 첫 번째 열의 너비 설정
              1: FlexColumnWidth(2), // 두 번째 열의 너비 설정
            },
            children: [
              // 각 행을 생성하여 테이블에 추가
              _buildTableRow('입금계좌안내', bankAccount),
              _buildTableRow('발주 번호', orderNumber),
              _buildTableRow('발주 일자', orderDate),
              _buildTableRow('총 결제 금액', '${numberFormat.format(totalPayment)}원'),
              _buildTableRow('발주자 성함', customerName),
              _buildTableRow('배송지', address),
            ],
          ),
          SizedBox(height: 16), // 간격
          // 홈으로 이동 버튼
          ElevatedButton(
            onPressed: () {
              // 버튼 클릭 시 HomeMainScreen으로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeMainScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: BUTTON_COLOR, // 버튼 텍스트 색상
              backgroundColor: BACKGROUND_COLOR, // 버튼 배경 색상
              side: BorderSide(color: BUTTON_COLOR), // 버튼 테두리 색상
              padding: EdgeInsets.symmetric(vertical: 10), // 버튼 패딩
            ),
            child: Text('홈으로 이동', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // 테이블의 각 행을 생성하는 함수
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        // 첫 번째 셀
        Container(
          color: Colors.grey.shade200, // 배경색 설정
          padding: const EdgeInsets.all(8.0), // 패딩 설정
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold), // 텍스트 스타일 설정
          ),
        ),
        // 두 번째 셀
        Container(
          color: Colors.white, // 배경색 설정
          padding: const EdgeInsets.all(8.0), // 패딩 설정
          child: Text(value), // 전달받은 값을 텍스트로 표시
        ),
      ],
    );
  }
}
// ------ 결제완료 화면 내 UI 구현 관련 CompletePaymentInfoWidget 클래스 내용 끝 부분