import 'package:flutter/material.dart'; // 플러터 위젯 및 머터리얼 디자인 라이브러리 임포트
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위한 플러터 리버팟 라이브러리 임포트
import 'package:intl/intl.dart'; // 숫자 및 날짜 포맷을 위한 intl 라이브러리 임포트
import '../../common/const/colors.dart'; // 공통 색상 상수 파일 임포트
import '../../common/layout/common_body_parts_layout.dart';
import '../../home/view/home_screen.dart'; // 홈 화면 관련 파일 임포트
import '../../product/model/product_model.dart';


// ------- 업데이트 요청 완료 화면에 표시할 정보를 구성하는 UpdateRequestCompleteInfoWidget 클래스 내용 시작 부분
class UpdateRequestCompleteInfoWidget extends ConsumerWidget {
  // 필요한 결제 정보들을 필드로 선언
  final String orderNumber; // 주문 번호
  final String orderDate; // 주문 날짜
  final String customerName; // 고객 이름
  final List<ProductContent> orderItems; // 주문 상품 목록

  // 생성자를 통해 필요한 결제 정보들을 초기화
  UpdateRequestCompleteInfoWidget({
    required this.orderNumber,
    required this.orderDate,
    required this.customerName,
    required this.orderItems,
  });

  // 위젯의 UI를 구성하는 build 함수
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 숫자 포맷을 설정 (천 단위 콤마 추가)
    final numberFormat = NumberFormat('###,###');

        return Padding(
          padding: const EdgeInsets.all(16.0), // 전체 패딩 설정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: [
              Text(
                '업데이트 요청 완료', // 발주 완료 제목
                style: TextStyle(
                  fontSize: 24, // 폰트 크기 설정
                  fontWeight: FontWeight.bold, // 폰트 굵기 설정
                ),
              ),
              SizedBox(height: 16), // 간격
              Text(
                '[업데이트 요청이 완료되었습니다.]', // 설명 텍스트
                style: TextStyle(
                  fontSize: 16, // 폰트 크기 설정
                ),
              ),
              SizedBox(height: 16), // 간격
              // 각 정보 행을 표시하기 위한 함수 호출
              _buildInfoRow('발주 번호', orderNumber),
              _buildInfoRow('발주 일자', orderDate),
              _buildInfoRow('발주자 성함', customerName),
              SizedBox(height: 16), // 간격
              ...orderItems.map((product) {
                final int originalPrice = product.originalPrice?.round() ?? 0;
                final int discountPrice = product.discountPrice?.round() ?? 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: CommonCardView(
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.briefIntroduction ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            if (product.thumbnail != null)
                              Image.network(
                                product.thumbnail!,
                                height: 130,
                                width: 130,
                                fit: BoxFit.cover,
                              ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (product.productNumber != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      '상품번호: ${product.productNumber}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                Text(
                                  '${numberFormat.format(originalPrice)}원',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${numberFormat.format(discountPrice)}원',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${product.discountPercent?.round() ?? 0}%',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    if (product.selectedColorImage != null)
                                      Image.network(
                                        product.selectedColorImage!,
                                        height: 20,
                                        width: 20,
                                        fit: BoxFit.cover,
                                      ),
                                    SizedBox(width: 8),
                                    Text(
                                      product.selectedColorText ?? '',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: Text(
                                    product.selectedSize ?? '',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    backgroundColor: BEIGE_COLOR,
                    elevation: 2,
                    padding: const EdgeInsets.all(8),
                  ),
                );
              }).toList(),
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
// ------- 업데이트 요청 완료 화면에 표시할 정보를 구성하는 UpdateRequestCompleteInfoWidget 클래스 내용 끝 부분
