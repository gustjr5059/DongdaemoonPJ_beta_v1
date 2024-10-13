
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../provider/message_all_provider.dart';

// ------ 마이페이지용 쪽지 관리 화면 내 계정별 관련 쪽지 목록 불러와서 UI 구현하는 PrivateMessageBodyPartsContents 클래스 내용 시작
class PrivateMessageBodyPartsContents extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 로그인한 사용자의 이메일 계정을 가져옴.
    final currentUserEmail = ref.watch(currentUserEmailProvider).asData?.value;

    // 만약 이메일이 없다면, 로딩 스피너를 표시.
    if (currentUserEmail == null) {
      return Center(child: CircularProgressIndicator());
    }

    // // 현재 사용자의 이메일로 1분 이내에 발송된 쪽지 목록을 실시간으로 가져옴.
    // final messages = ref.watch(fetchMinutesMessagesProvider(currentUserEmail));

    // 현재 사용자의 이메일로 30일 이내에 발송된 쪽지 목록을 실시간으로 가져옴.
    final messages = ref.watch(fetchDaysMessagesProvider(currentUserEmail));

    // // 현재 사용자의 이메일로 1년 이내에 발송된 쪽지 목록을 실시간으로 가져옴.
    // final messages = ref.watch(fetchYearMessagesProvider(currentUserEmail));

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 쪽지 관리 화면 내 쪽지 목록 탭 내 카드뷰 섹션의 가로와 세로 비율 계산
    final double messageInfoCardViewWidth =
        screenSize.width * (393 / referenceWidth); // 가로 비율 계산
    final double messageInfoCardViewHeight =
        screenSize.height * (110 / referenceHeight); // 세로 비율 계산

    // body 부분 전체 패딩 수치 계산
    final double messageInfoCardViewPaddingX = screenSize.width * (15 / referenceWidth); // 좌우 패딩 계산
    final double messageInfoCardViewPadding1Y = screenSize.height * (10 / referenceHeight); // 상하 패딩 계산


    // 비율을 기반으로 동적으로 크기와 위치 설정
    final double sendingBtnWidth = screenSize.width * (130 / referenceWidth);
    final double sendingBtnHeight = screenSize.height * (50 / referenceHeight);
    final double sendingBtnX = screenSize.width * (12 / referenceWidth);
    final double sendingBtnY = screenSize.height * (10 / referenceHeight);
    final double sendingBtnFontSize = screenSize.height * (16 / referenceHeight);
    final double paddingX = screenSize.width * (2 / referenceWidth);
    final double messageRecipientDropdownBtnWidth = screenSize.width * (210 / referenceWidth);
    final double messageRecipientDropdownBtnHeight = screenSize.height * (50 / referenceHeight);

    final double messageRecipientSelectDataTextSize = screenSize.height * (16 / referenceHeight);
    final double messageDataTextSize1 = screenSize.height * (14 / referenceHeight);
    final double messageDataTextSize2 = screenSize.height * (16 / referenceHeight);

    // 삭제 버튼 수치
    final double deleteBtnHeight =
        screenSize.height * (30 / referenceHeight);
    final double deleteBtnWidth =
        screenSize.width * (60 / referenceWidth);
    final double intervalX =
        screenSize.width * (8 / referenceWidth);
    final double deleteBtnPaddingY =
        screenSize.height * (2 / referenceHeight);
    final double deleteBtnPaddingX =
        screenSize.width * (4 / referenceWidth);
    final double deleteBtnFontSize =
        screenSize.height * (12 / referenceHeight);

    // 컨텐츠 사이의 간격 수치
    final double interval1Y = screenSize.height * (20 / referenceHeight);
    final double interval2Y = screenSize.height * (10 / referenceHeight);
    final double interval3Y = screenSize.height * (60 / referenceHeight);
    final double interval1X = screenSize.width * (4 / referenceWidth);
    final double interval2X = screenSize.width * (10 / referenceWidth);
    final double interval3X = screenSize.width * (12 / referenceWidth);
    final double interval4X = screenSize.width * (39 / referenceWidth);

    // 쪽지 목록 부분이 비어있는 경우의 알림 부분 수치
    final double messageEmptyTextWidth =
        screenSize.width * (250 / referenceWidth); // 가로 비율
    final double messageEmptyTextHeight =
        screenSize.height * (22 / referenceHeight); // 세로 비율
    final double messageEmptyTextX =
        screenSize.width * (70 / referenceWidth); // 가로 비율
    final double messageEmptyTextY =
        screenSize.height * (200 / referenceHeight); // 세로 비율
    final double messageEmptyTextFontSize =
        screenSize.height * (16 / referenceHeight);


    // 가져온 쪽지 데이터의 상태에 따라 UI를 구성.
    return messages.when(
      // 데이터가 성공적으로 로드된 경우
      data: (messagesList) {
        // 쪽지 목록이 비어 있는 경우
        if (messagesList.isEmpty) {
          // 쪽지 목록이 비어있을 경우 "쪽지가 없습니다" 메시지 표시
          return Container(
            width: messageEmptyTextWidth,
            height: messageEmptyTextHeight,
            margin: EdgeInsets.only(left: messageEmptyTextX, top: messageEmptyTextY),
            child: Text('쪽지 목록 내 쪽지가 없습니다.',
              style: TextStyle(
                fontSize: messageEmptyTextFontSize,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          );
        }

        // 최신 쪽지가 위로 오도록 리스트를 역순으로 정렬.
        final reversedMessages = messagesList.reversed.toList();

        // 쪽지 목록을 열의 형태로 표시.
        return Column(
          // 각 쪽지를 맵핑하여 위젯을 생성.
          children: reversedMessages.map((message) {
            // 수신자와 주문 번호 텍스트를 구성.
            String recipientText = '${message['recipient']}';
            String orderNumberText = '[발주번호: ${message['order_number']}]';

            // '[자세히]' 버튼을 클릭했을 때 팝업을 띄우는 함수
            // showMessageDetailDialog: 쪽지의 자세한 내용을 팝업으로 표시하는 함수
            void showMessageDetailDialog(BuildContext context) async {
              // showSubmitAlertDialog 함수를 호출하여 팝업을 띄움
              await showSubmitAlertDialog(
                context,
                title: '[쪽지 내용]', // 팝업의 제목 설정
                contentWidget: RichText(
                  // RichText 위젯을 사용하여 다양한 스타일의 텍스트를 구성함
                  text: TextSpan(
                    children: [
                      // $recipientText 부분을 빨간색으로 설정하고 Bold로 표시함
                      TextSpan(
                        text: recipientText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      // '님께서 발주 완료한 ' 부분을 검정색으로 설정함
                      TextSpan(
                        text: '님께서 발주 완료한 ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      // $orderNumberText 부분을 빨간색으로 설정하고 Bold로 표시함
                      TextSpan(
                        text: orderNumberText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      // 기본 텍스트 색상으로 나머지 문구를 표시함
                      TextSpan(
                        text: ' 건 관련 ${message['contents']}',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: buildAlertActions(
                  context,
                  noText: '닫기', // '닫기' 버튼 텍스트 설정
                  noTextStyle: TextStyle( // '닫기' 버튼 텍스트 스타일을 검정색 Bold로 설정함
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            // 쪽지 목록 카드 뷰를 구성.
            // return Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 1.0), // 화면의 가로 길이에 맞게 패딩 조정
            //   child: Column(
                // children: [
                //   Row(
                //     children: [
                //       Expanded(
                //         // Expanded 위젯을 사용하여 가로로 공간을 최대한 차지하도록 설정
                //         child: CommonCardView(
                //           // CommonCardView 위젯을 사용하여 카드 뷰를 구성
                //           backgroundColor: BEIGE_COLOR, // 카드 뷰의 배경색을 BEIGE_COLOR로 설정
                //           content: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
            // 클립 위젯을 사용하여 모서리를 둥글게 설정함
            return ClipRRect(
              borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
              child: Container(
                width: messageInfoCardViewWidth, // 카드뷰 가로 크기 설정
                height: messageInfoCardViewHeight, // 카드뷰 세로 크기 설정
                padding: EdgeInsets.symmetric(horizontal: interval1X),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFCECECE), width: 2.0), // 하단 테두리 색상을 지정함
                  ),
                ),
                child: CommonCardView( // 공통 카드뷰 위젯 사용
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                  elevation: 0, // 그림자 깊이 설정
                  content: Padding( // 패딩 설정
                    padding: EdgeInsets.zero, // 패딩을 없앰
                    // Column 위젯을 사용하여 여러 위젯을 수직으로 배치함
                    child: Column(
                            children: [
                              RichText(
                                // RichText 위젯을 사용하여 다양한 스타일의 텍스트를 포함
                                maxLines: 2, // 최대 두 줄까지만 텍스트를 표시
                                overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 생략 부호로 처리
                                text: TextSpan(
                                  // TextSpan을 사용하여 스타일이 다른 텍스트들을 결합
                                  children: [
                                    TextSpan(
                                      // 첫 번째 텍스트 스팬
                                      text: recipientText, // 수신자 텍스트를 설정
                                      style: TextStyle(
                                        fontFamily: 'NanumGothic',
                                        fontSize: messageDataTextSize1,
                                        fontWeight: FontWeight.bold, // 텍스트를 볼드체로 설정
                                        color: Colors.red, // 텍스트 색상을 빨간색으로 설정
                                      ),
                                    ),
                                    TextSpan(
                                      // 두 번째 텍스트 스팬
                                      text: '님께서 발주 완료한 ', // 고정된 안내 텍스트
                                      style: TextStyle(
                                        fontFamily: 'NanumGothic',
                                        fontSize: messageDataTextSize1,
                                        fontWeight: FontWeight.bold, // 텍스트를 볼드체로 설정
                                        color: Colors.black, // 텍스트 색상을 검은색으로 설정
                                      ),
                                    ),
                                    TextSpan(
                                      // 세 번째 텍스트 스팬
                                      text: orderNumberText, // 주문 번호 텍스트를 설정
                                      style: TextStyle(
                                        fontFamily: 'NanumGothic',
                                        fontSize: messageDataTextSize1,
                                        fontWeight: FontWeight.bold, // 텍스트를 볼드체로 설정
                                        color: Colors.red, // 텍스트 색상을 빨간색으로 설정
                                      ),
                                    ),
                                    TextSpan(
                                      // 네 번째 텍스트 스팬
                                      text: ' 건 관련 ${message['contents']}', // 메시지 내용을 설정
                                      style: TextStyle(
                                        fontFamily: 'NanumGothic',
                                        fontSize: messageDataTextSize1,
                                        fontWeight: FontWeight.bold, // 텍스트를 볼드체로 설정
                                        color: Colors.black, // 텍스트 색상을 검은색으로 설정
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // [자세히] 버튼을 중앙에 위치시키고, '삭제' 버튼을 오른쪽 끝에 배치
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Spacer(), // 왼쪽을 비우기 위해 Spacer 추가
                                  TextButton(
                                    onPressed: () {
                                      showMessageDetailDialog(context); // '[자세히]' 버튼을 클릭했을 때 showMessageDetailDialog 함수를 호출함
                                    },
                                    child: Text(
                                      '[자세히]', // [자세히] 텍스트를 표시
                                      style: TextStyle(
                                        fontFamily: 'NanumGothic',
                                        color: Colors.blue, // 텍스트 색상을 파란색으로 설정
                                        fontWeight: FontWeight.bold, // 텍스트를 볼드체로 설정
                                        fontSize: messageDataTextSize2, // 텍스트 크기 설정
                                      ),
                                    ),
                                  ),
                                  Spacer(), // 중앙에 위치시키기 위해 Spacer 추가
                                  // 카드뷰 내부 오른쪽 끝에 위치하는 삭제 버튼
                                  Container(
                                    width: deleteBtnWidth,
                                    height: deleteBtnHeight,
                                    margin: EdgeInsets.only(right: intervalX), // 오른쪽 여백 설정
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Color(0xFF6FAD96), // 텍스트 색상 설정
                                        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 버튼 배경색을 앱 배경색으로 설정
                                        side: BorderSide(color: Color(0xFF6FAD96)), // 버튼 테두리 색상 설정
                                        padding: EdgeInsets.symmetric(vertical: deleteBtnPaddingY, horizontal: deleteBtnPaddingX), // 버튼 패딩
                                      ),
                                    onPressed: () async {
                                      // 쪽지 삭제 버튼 클릭 시 확인 다이얼로그를 표시함
                                      await showSubmitAlertDialog(
                                        context,
                                        title: '[쪽지 삭제]', // 다이얼로그 제목 설정
                                        content: '쪽지를 삭제하시면 더이상 해당 쪽지를 확인하실 수 없습니다.\n해당 쪽지를 삭제하시겠습니까?', // 다이얼로그 내용 설정
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
                                            try{
                                              await ref.read(fetchDeleteMessagesProvider(message['id']));
                                              Navigator.of(context).pop(); // 다이얼로그 닫기
                                              // ScaffoldMessenger.of(context).showSnackBar(
                                              //   SnackBar(content: Text('쪽지가 삭제되었습니다.')), // 리뷰 삭제 완료 메시지 표시
                                              // );
                                              showCustomSnackBar(context, '쪽지가 삭제되었습니다.');
                                            } catch (e) {
                                              // ScaffoldMessenger.of(context).showSnackBar(
                                              //   SnackBar(content: Text('쪽지 삭제 중 오류가 발생했습니다: $e')), // 오류 메시지 표시
                                              // );
                                              showCustomSnackBar(context, '쪽지 삭제 중 오류가 발생했습니다: $e');
                                            }
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      '삭제', // '삭제' 버튼 텍스트 설정
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'NanumGothic',
                                        fontSize: deleteBtnFontSize,
                                        color: Color(0xFF6FAD96),
                                      ),
                                    ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()), // 로딩 상태에서 로딩 인디케이터를 중앙에 표시
      error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')), // 오류 상태에서 오류 메시지를 중앙에 표시
    );
  }
}
// ------ 마이페이지용 쪽지 관리 화면 내 계정별 관련 쪽지 목록 불러와서 UI 구현하는 PrivateMessageBodyPartsContents 클래스 내용 끝