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
        screenSize.height * (16 / referenceHeight);
    final double updateRequireCompleteSubTitleFontSize =
        screenSize.height * (14 / referenceHeight);
    final double updateRequireNoticeFontSize1 =
        screenSize.height * (12 / referenceHeight);
    final double updateRequireNoticeFontSize2 =
        screenSize.height * (11 / referenceHeight);

    final double updateRequireCompleteInfo1Y =
        screenSize.height * (20 / referenceHeight);
    final double updateRequireCompleteInfo2Y =
        screenSize.height * (40 / referenceHeight);
    final double updateRequireCompleteInfo3Y =
        screenSize.height * (10 / referenceHeight);

    // 버튼 관련 수치 동적 적용
    final double combackHomeBtn1X = screenSize.width * (15 / referenceWidth);
    final double combackHomeBtn1Y = screenSize.height * (50 / referenceHeight);
    final double combackHomeBtn2Y = screenSize.height * (100 / referenceHeight);
    final double combackHomeBtnFontSize = screenSize.height * (16 / referenceHeight);


    // 숫자 포맷을 설정 (천 단위 콤마 추가)
    final numberFormat = NumberFormat('###,###');

        return Padding(
          padding: EdgeInsets.only(left: updateRequireCompletePaddingX, right: updateRequireCompletePaddingX, top: updateRequireCompletePaddingY),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: [
              Text(
                '업데이트 요청 완료', // 발주 완료 제목
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: updateRequireCompleteTitleFontSize,
                  fontWeight: FontWeight.bold, // 텍스트 굵게 설정
                  color: BLACK_COLOR,
                ),
              ),
              SizedBox(height: updateRequireCompleteInfo1Y), // 간격
              Text(
                '업데이트 요청이 완료되었습니다.', // 설명 텍스트
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: updateRequireCompleteSubTitleFontSize,
                  // fontWeight: FontWeight.bold, // 텍스트 굵게 설정
                  color: BLACK_COLOR,
                ),
              ),
              SizedBox(height: updateRequireCompleteInfo2Y), // 간격
              // 각 정보 행을 표시하기 위한 함수 호출
              _buildInfoRow(context, '요청 접수번호', orderNumber),
              _buildInfoRow(context, '요청 일자', orderDate),
              _buildInfoRow(context, '요청자 성함', customerName),
              SizedBox(height: updateRequireCompleteInfo2Y), // 간격
              Text(
                "품목별로 유통사 재고 확인 후 별도 안내 예정입니다.", // 설명 텍스트
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: updateRequireNoticeFontSize1,
                  // fontWeight: FontWeight.bold, // 텍스트 굵게 설정
                  color: BLACK_COLOR,
                ),
              ),
              SizedBox(height: updateRequireCompleteInfo3Y),
              Text(
                "해당 요청 품목 업데이트는 1~2일 소요될 수 있습니다.", // 설명 텍스트
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: updateRequireNoticeFontSize1,
                  // fontWeight: FontWeight.bold, // 텍스트 굵게 설정
                  color: BLACK_COLOR,
                ),
              ),
              SizedBox(height: updateRequireCompleteInfo1Y),
              Text(
                "요청 실수 등의 문의사항이 있을 시,", // 설명 텍스트
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: updateRequireNoticeFontSize2,
                  // fontWeight: FontWeight.bold, // 텍스트 굵게 설정
                  color: BLACK_COLOR,
                ),
              ),
              Text(
                "[마이페이지] => [문의하기] 절차로 진행해주세요.", // 설명 텍스트
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: updateRequireNoticeFontSize2,
                  // fontWeight: FontWeight.bold, // 텍스트 굵게 설정
                  color: BLACK_COLOR,
                ),
              ),
              SizedBox(height: combackHomeBtn2Y),
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
                    foregroundColor: SOFTGREEN60_COLOR, // 버튼 텍스트 색상
                    backgroundColor: SOFTGREEN60_COLOR, // 버튼 배경 색상
                    side: BorderSide(color: SOFTGREEN60_COLOR,), // 버튼 테두리 색상
                    padding: EdgeInsets.symmetric(vertical: combackHomeBtn1X, horizontal: combackHomeBtn1Y), // 버튼 패딩
                  ),
                  child: Text('홈으로 이동',
                    style: TextStyle(
                      fontSize: combackHomeBtnFontSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NanumGothic',
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ), // 버튼 텍스트
                ),
              ),
            ],
          ),
        );
  }

  // 각 정보 행을 구성하는 함수
  Widget _buildInfoRow(BuildContext context, String label, String? value) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 발주자 정보 표 부분 수치
    final double updateRequireCompleteInfoTextFontSize =
        screenSize.height * (13 / referenceHeight);
    final double updateRequireCompleteInfoDataFontSize =
        screenSize.height * (13 / referenceHeight);
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
              color: GRAY96_COLOR, // 배경 색상 설정
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NanumGothic',
                  fontSize: updateRequireCompleteInfoTextFontSize,
                  color: BLACK_COLOR,
                ),  // 텍스트 스타일 설정
              ),
            ),
            SizedBox(width: updateRequireCompleteInfo5Y), // 왼쪽과 오른쪽 사이 간격 추가
            Expanded(
              child: Container(
                color: GRAY98_COLOR, // 배경 색상 설정
                padding: EdgeInsets.only(left: updateRequireCompleteInfoDataPartX),
                alignment: Alignment.centerLeft, // 텍스트 정렬
                child: Text(
                  value ?? '', // value가 null일 경우 빈 문자열로 처리
                  style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: updateRequireCompleteInfoDataFontSize,
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
// ------- 업데이트 요청 완료 화면에 표시할 정보를 구성하는 UpdateRequestCompleteInfoWidget 클래스 내용 끝 부분
