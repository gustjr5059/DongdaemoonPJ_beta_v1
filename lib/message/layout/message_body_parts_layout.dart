
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../provider/message_all_provider.dart';
import '../provider/message_state_provider.dart';

// ------ 마이페이지용 쪽지 관리 화면 내 계정별 관련 쪽지 목록 불러와서 UI 구현하는 PrivateMessageBodyPartsContents 클래스 내용 시작
class PrivateMessageBodyPartsContents extends ConsumerWidget {
  final int timeFrame; // 쪽지 발송 시간

  PrivateMessageBodyPartsContents({required this.timeFrame});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 로그인한 사용자의 이메일 계정을 가져옴.
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    // 만약 이메일이 없다면, 로딩 스피너를 표시.
    if (userEmail == null) {
      return Center(child: CircularProgressIndicator());
    }

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
    final double deleteBtnPaddingY =
        screenSize.height * (2 / referenceHeight);
    final double deleteBtnPaddingX =
        screenSize.width * (4 / referenceWidth);
    final double deleteBtnFontSize =
        screenSize.height * (12 / referenceHeight);

    // 전체보기 버튼 수치
    final double allViewBtnHeight =
        screenSize.height * (30 / referenceHeight);
    final double allViewBtnWidth =
        screenSize.width * (250 / referenceWidth);
    final double allViewBtnPaddingY =
        screenSize.height * (2 / referenceHeight);
    final double allViewBtnPaddingX =
        screenSize.width * (4 / referenceWidth);
    final double allViewBtnFontSize =
        screenSize.height * (14 / referenceHeight);

    // 컨텐츠 사이의 간격 수치
    final double intervalX =
        screenSize.width * (8 / referenceWidth);
    final double interva2X =
        screenSize.width * (10 / referenceWidth);
    final double interval1Y = screenSize.height * (4 / referenceHeight);


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

    // 날짜 형식을 'yyyy.MM.dd HH:MM'로 지정함
    final dateFormat = DateFormat('yyyy.MM.dd HH:MM');

    final messageItems = ref.watch(privateMessageItemsListNotifierProvider);

        // 쪽지 목록이 비어 있는 경우
        if (messageItems.isEmpty) {
          // 쪽지 목록이 비어있을 경우 "'현재 쪽지 목록 내 쪽지가 없습니다." 메시지 표시
          return Container(
            width: messageEmptyTextWidth,
            height: messageEmptyTextHeight,
            margin: EdgeInsets.only(left: messageEmptyTextX, top: messageEmptyTextY),
            child: Text('현재 쪽지 목록 내 쪽지가 없습니다.',
              style: TextStyle(
                fontSize: messageEmptyTextFontSize,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
                color: BLACK_COLOR,
              ),
            ),
          );
        }

        // 쪽지 목록을 열의 형태로 표시.
        return Column(
          // 각 쪽지를 맵핑하여 위젯을 생성.
          children: messageItems.map((message) {
            // 수신자와 주문 번호 텍스트를 구성.
            final recipientText = '${message['recipient'] ?.toString().isNotEmpty == true ? message['recipient'] : ''}';
            final orderNumberText = '[발주번호: ${message['order_number'] ?.toString().isNotEmpty == true ? message['order_number'] : ''}]';
            final contentsText = ' 건 관련 ${message['contents'] ?.toString().isNotEmpty == true ? message['contents'] : ''}';
            final messageReceptionTime = (message['message_sendingTime'] as Timestamp).toDate();


            // '전체보기' 버튼을 클릭했을 때 팝업을 띄우는 함수
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
                          color: RED46_COLOR,
                        ),
                      ),
                      // '님께서 발주 완료한 ' 부분을 검정색으로 설정함
                      TextSpan(
                        text: '님께서 발주 완료한 ',
                        style: TextStyle(
                          color: BLACK_COLOR,
                        ),
                      ),
                      // $orderNumberText 부분을 빨간색으로 설정하고 Bold로 표시함
                      TextSpan(
                        text: orderNumberText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: RED46_COLOR,
                        ),
                      ),
                      // 기본 텍스트 색상으로 나머지 문구를 표시함
                      TextSpan(
                        text: contentsText,
                        style: TextStyle(
                          color: BLACK_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: buildAlertActions(
                  context,
                  noText: '닫기', // '닫기' 버튼 텍스트 설정
                  noTextStyle: TextStyle( // '닫기' 버튼 텍스트 스타일을 검정색 Bold로 설정함
                    color: BLACK_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            // // 클립 위젯을 사용하여 모서리를 둥글게 설정함
            // return ClipRRect(
            //   borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
            //   child: Container(
                // width: messageInfoCardViewWidth, // 카드뷰 가로 크기 설정
                // height: messageInfoCardViewHeight, // 카드뷰 세로 크기 설정
            return Container(
                padding: EdgeInsets.zero, // 패딩을 없앰
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 지정함
                  ),
                ),
                child: CommonCardView( // 공통 카드뷰 위젯 사용
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                  elevation: 0, // 그림자 깊이 설정
                  content: Padding( // 패딩 설정
                    padding: EdgeInsets.zero, // 패딩을 없앰
                    // Column 위젯을 사용하여 여러 위젯을 수직으로 배치함
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                            children: [
                              Text('수신일시: ${messageReceptionTime != null ? dateFormat.format(messageReceptionTime) : ''}',
                                style: TextStyle(
                                  fontSize: messageDataTextSize1,
                                  // 텍스트 크기 설정
                                  fontWeight: FontWeight.bold,
                                  // 텍스트 굵기 설정
                                  fontFamily: 'NanumGothic',
                                  // 글꼴 설정
                                  color: GRAY41_COLOR, // 텍스트 색상 설정
                                ),
                              ),
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
                                        color: RED46_COLOR, // 텍스트 색상을 빨간색으로 설정
                                      ),
                                    ),
                                    TextSpan(
                                      // 두 번째 텍스트 스팬
                                      text: '님께서 발주 완료한 ', // 고정된 안내 텍스트
                                      style: TextStyle(
                                        fontFamily: 'NanumGothic',
                                        fontSize: messageDataTextSize1,
                                        fontWeight: FontWeight.bold, // 텍스트를 볼드체로 설정
                                        color: BLACK_COLOR, // 텍스트 색상을 검은색으로 설정
                                      ),
                                    ),
                                    TextSpan(
                                      // 세 번째 텍스트 스팬
                                      text: orderNumberText, // 주문 번호 텍스트를 설정
                                      style: TextStyle(
                                        fontFamily: 'NanumGothic',
                                        fontSize: messageDataTextSize1,
                                        fontWeight: FontWeight.bold, // 텍스트를 볼드체로 설정
                                        color: RED46_COLOR, // 텍스트 색상을 빨간색으로 설정
                                      ),
                                    ),
                                    TextSpan(
                                      // 네 번째 텍스트 스팬
                                      text: contentsText, // 메시지 내용을 설정
                                      style: TextStyle(
                                        fontFamily: 'NanumGothic',
                                        fontSize: messageDataTextSize1,
                                        fontWeight: FontWeight.bold, // 텍스트를 볼드체로 설정
                                        color: BLACK_COLOR, // 텍스트 색상을 검은색으로 설정
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // '전체보기' 버튼과 '삭제' 버튼을 중앙에 배치
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: allViewBtnHeight,
                                    width: allViewBtnWidth,
                                    margin: EdgeInsets.symmetric(vertical: interval1Y), // 위아래 여백 설정
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          showMessageDetailDialog(context); // '전체보기' 버튼을 클릭했을 때 showMessageDetailDialog 함수를 호출함
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: GRAY44_COLOR, // 아이콘 및 텍스트 색상 설정
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor, // 앱 기본 배경색
                                          side: BorderSide(color: GRAY44_COLOR), // 버튼 테두리 색상 설정
                                          padding: EdgeInsets.zero, // 버튼 내부 여백 제거
                                        ),
                                        icon: Icon(
                                              Icons.all_out_outlined, // 전체보기 아이콘 설정
                                          size: allViewBtnFontSize, // 아이콘 크기
                                          color: BLACK_COLOR,
                                        ),
                                        label: Text(
                                          '전체보기',
                                          style: TextStyle(
                                            fontFamily: 'NanumGothic',
                                            fontSize: allViewBtnFontSize, // 텍스트 크기 설정
                                            fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                            color: BLACK_COLOR, // 텍스트 색상 설정
                                          ),
                                        ),
                                      ),
                                  ),
                                  // 카드뷰 내부 오른쪽 끝에 위치하는 삭제 버튼
                                  Container(
                                    width: deleteBtnWidth,
                                    height: deleteBtnHeight,
                                    margin: EdgeInsets.only(left: intervalX, right: intervalX), // 오른쪽 여백 설정
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: GRAY44_COLOR, // 텍스트 색상 설정
                                        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 버튼 배경색을 앱 배경색으로 설정
                                        side: BorderSide(color: GRAY44_COLOR), // 버튼 테두리 색상 설정
                                        padding: EdgeInsets.symmetric(vertical: deleteBtnPaddingY, horizontal: deleteBtnPaddingX), // 버튼 패딩
                                      ),
                                    onPressed: () async {
                                      // 쪽지 삭제 버튼 클릭 시 확인 다이얼로그를 표시함
                                      await showSubmitAlertDialog(
                                        context,
                                        title: '[쪽지 삭제]', // 다이얼로그 제목 설정
                                        content: '삭제 시, 해당 쪽지는 영구적으로 삭제됩니다.\n해당 쪽지를 삭제하시겠습니까?', // 다이얼로그 내용 설정
                                        actions: buildAlertActions(
                                          context,
                                          noText: '아니요', // 아니요 버튼 텍스트 설정
                                          yesText: '예', // 예 버튼 텍스트 설정
                                          noTextStyle: TextStyle(
                                            color: BLACK_COLOR, // 아니요 버튼 텍스트 색상 설정
                                            fontWeight: FontWeight.bold, // 아니요 버튼 텍스트 굵기 설정
                                          ),
                                          yesTextStyle: TextStyle(
                                            color: RED46_COLOR, // 예 버튼 텍스트 색상 설정
                                            fontWeight: FontWeight.bold, // 예 버튼 텍스트 굵기 설정
                                          ),
                                          onYesPressed: () async {
                                            try{
                                              final messageId = message['id'];
                                              await ref.read(privateMessageItemsListNotifierProvider.notifier)
                                                  .deleteMessage(messageId, timeFrame);
                                              Navigator.of(context).pop(); // 다이얼로그 닫기
                                              showCustomSnackBar(context, '쪽지가 삭제되었습니다.');
                                            } catch (e) {
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
                                        color: BLACK_COLOR,
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
        );
  }
}
// ------ 마이페이지용 쪽지 관리 화면 내 계정별 관련 쪽지 목록 불러와서 UI 구현하는 PrivateMessageBodyPartsContents 클래스 내용 끝