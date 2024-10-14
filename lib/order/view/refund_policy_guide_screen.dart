import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';

// -------- 환불방침 안내 화면 관련 RefundPolicyGuideScreen 클래스 정의 내용 시작
class RefundPolicyGuideScreen extends StatelessWidget {
  final String orderNumber; // orderNumber 매개변수로 받아옴

  // 생성자를 통해 orderNumber를 받아오는 부분을 추가
  RefundPolicyGuideScreen({required this.orderNumber});

  @override
  Widget build(BuildContext context) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // body 부분 데이터 내용의 전체 패딩 수치
    final double refundPaddingX = screenSize.width * (4 / referenceWidth);

    // 컨텐츠 사이의 간격 계산
    final double interval1Y = screenSize.height * (350 / referenceHeight); // 세로 간격 1 계산
    final double interval2Y = screenSize.height * (40 / referenceHeight); // 세로 간격 2 계산
    final double interval3Y = screenSize.height * (50 / referenceHeight); // 세로 간격 3 계산
    final double interval1X = screenSize.width * (15 / referenceWidth); // 가로 간격 1 계산
    final double interval2X = screenSize.width * (10 / referenceWidth); // 가로 간격 2 계산

    // 텍스트 폰트 크기 수치
    final double refundGuideFontSize1 =
        screenSize.height * (18 / referenceHeight); // 텍스트 크기 비율 계산
    final double refundGuideFontSize2 =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산

    // 환불 신청하기로 이동 버튼 수치
    final double refundBtnWidth =
        screenSize.width * (280 / referenceWidth); // 환불 신청하기로 이동 버튼 가로 비율 계산
    final double refundBtnHeight =
        screenSize.height * (45 / referenceHeight); // 환불 신청하기로 이동 버튼 세로 비율 계산
    final double refundBtnPaddingX = screenSize.width * (12 / referenceWidth); // 환불 신청하기로 이동 버튼 좌우 패딩 계산
    final double refundBtnPaddingY = screenSize.height * (5 / referenceHeight); // 환불 신청하기로 이동 버튼 상하 패딩 계산
    final double refundBtnFontSize =
        screenSize.height * (14 / referenceHeight); // 환불 신청하기로 이동 버튼 텍스트 크기 비율 계산
    final double refundBtnX = screenSize.width * (80 / referenceWidth);

    return Scaffold(
      body: Stack( // 여러 위젯을 겹쳐서 배치
        children: [
          Center(
            child: Padding(
                          // 각 항목의 좌우 간격을 inquiryPaddingX로 설정함.
                          padding: EdgeInsets.symmetric(horizontal: refundPaddingX),
                          child: Column(
                            // 자식 위젯들을 왼쪽 정렬.
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: interval1Y),
                              Container(
                                padding: EdgeInsets.only(left: interval1X), // 패딩 설정
                                child: Text('* 환불 신청은 아래 절차에 따라 진행해주세요.',
                                  style: TextStyle(
                                    fontSize: refundGuideFontSize1, // 텍스트 크기 설정
                                    fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                    fontFamily: 'NanumGothic', // 글꼴 설정
                                    color: Colors.black, // 텍스트 색상 설정
                                  ),
                                ),
                              ),
                              SizedBox(height: interval2Y),
                              Container(
                                padding: EdgeInsets.only(left: interval2X), // 패딩 설정
                                child: Text('1. [환불 신청 하러가기] 버튼을 클릭해주세요.',
                                  style: TextStyle(
                                    fontSize: refundGuideFontSize2, // 텍스트 크기 설정
                                    fontWeight: FontWeight.normal, // 텍스트 굵기 설정
                                    fontFamily: 'NanumGothic', // 글꼴 설정
                                    color: Colors.black, // 텍스트 색상 설정
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: interval2X), // 패딩 설정
                                child: Text('2. 이동한 웹 페이지에서 내용 작성 후, 제출해주세요.',
                                  style: TextStyle(
                                    fontSize: refundGuideFontSize2, // 텍스트 크기 설정
                                    fontWeight: FontWeight.normal, // 텍스트 굵기 설정
                                    fontFamily: 'NanumGothic', // 글꼴 설정
                                    color: Colors.black, // 텍스트 색상 설정
                                  ),
                                ),
                              ),
                              SizedBox(height: interval3Y),
                              Container(
                                width: refundBtnWidth,
                                height: refundBtnHeight,
                                padding: EdgeInsets.only(left: refundBtnX), // 패딩 설정
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // 버튼이 눌렸을 때 해당 링크로 이동함
                                    final Uri url = Uri.parse('https://pf.kakao.com/_xjVrbG');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url); // url_launcher 패키지를 사용하여 링크를 엶
                                    } else {
                                      throw 'Could not launch $url'; // 링크를 열 수 없는 경우 예외를 발생시킴
                                    }
                                  },
                                  style: ElevatedButton.styleFrom( // 버튼의 스타일을 설정함
                                    foregroundColor: Color(0xFFE17735), // 버튼의 글자 색상을 설정함
                                    backgroundColor: Color(0xFFE17735), // 버튼의 배경 색상을 설정함
                                    padding: EdgeInsets.symmetric(vertical: refundBtnPaddingY, horizontal: refundBtnPaddingX), // 패딩 설정
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(45), // 모서리 둥글게 설정
                                    ),
                                  ),
                                  child: Text(
                                    '환불 신청 하러가기', // 버튼에 표시될 텍스트
                                    style: TextStyle(
                                      fontSize: refundBtnFontSize, // 텍스트 크기 설정
                                      fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                      fontFamily: 'NanumGothic', // 글꼴 설정
                                      color: Theme.of(context).scaffoldBackgroundColor, // 텍스트 색상 설정
                                    ), // 텍스트 스타일
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40, // 위쪽에서 40픽셀 아래에 위치
                        right: 10, // 오른쪽에서 20픽셀 안쪽에 위치
                        child: IconButton(
                          icon: Icon(Icons.close), // 닫기 아이콘 설정
                          color: Colors.black, // 색상 설정
                          onPressed: () {
                            Navigator.pop(context); // 누르면 이전 화면으로 돌아가기
                          },
                        ),
                      ),
                ],
            ),
        );
    }
}
// -------- 환불방침 안내 화면 관련 RefundPolicyGuideScreen 클래스 정의 내용 끝
