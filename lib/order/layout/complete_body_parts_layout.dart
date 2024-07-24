import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/const/colors.dart';
import '../../home/view/home_screen.dart'; // 숫자 포맷을 위해 임포트


class CompletePaymentInfoWidget extends StatelessWidget {
  final String bankAccount;
  final String orderNumber;
  final String orderDate;
  final double totalPayment;
  final String customerName;
  final String address;

  CompletePaymentInfoWidget({
    required this.bankAccount,
    required this.orderNumber,
    required this.orderDate,
    required this.totalPayment,
    required this.customerName,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('###,###'); // 숫자를 포맷하기 위한 NumberFormat 객체 생성

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '주문완료',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            '주문이 완료되었습니다.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            '아래 계좌 정보로 입금해 주시면 결제가 완료처리가 됩니다.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 16),
          Table(
            border: TableBorder.all(color: Colors.grey.shade300),
            columnWidths: {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            children: [
              _buildTableRow('입금계좌안내', bankAccount),
              _buildTableRow('발주 번호', orderNumber),
              _buildTableRow('발주 일자', orderDate),
              _buildTableRow('총 결제 금액', '${numberFormat.format(totalPayment)}원'),
              _buildTableRow('발주자 성함', customerName),
              _buildTableRow('배송지', address),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeMainScreen()),
              ); // HomeMainScreen으로 이동
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: BUTTON_COLOR,
              backgroundColor: BACKGROUND_COLOR,
              side: BorderSide(color: BUTTON_COLOR),
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            child: Text('홈으로 이동', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Container(
          color: Colors.grey.shade200,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
}
