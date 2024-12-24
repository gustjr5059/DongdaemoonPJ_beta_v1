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
class PrivateMessageBodyPartsContents extends ConsumerStatefulWidget {
  final int timeFrame; // 쪽지 발송 시간

  PrivateMessageBodyPartsContents({required this.timeFrame});

  @override
  _PrivateMessageBodyPartsContentsState createState() =>
      _PrivateMessageBodyPartsContentsState();
}

class _PrivateMessageBodyPartsContentsState
    extends ConsumerState<PrivateMessageBodyPartsContents> {

  @override
  Widget build(BuildContext context) {
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
    final double messageInfoCardViewPaddingX =
        screenSize.width * (15 / referenceWidth); // 좌우 패딩 계산
    final double messageInfoCardViewPadding1Y =
        screenSize.height * (10 / referenceHeight); // 상하 패딩 계산

    // 비율을 기반으로 동적으로 크기와 위치 설정
    final double sendingBtnWidth = screenSize.width * (130 / referenceWidth);
    final double sendingBtnHeight = screenSize.height * (50 / referenceHeight);
    final double sendingBtnX = screenSize.width * (12 / referenceWidth);
    final double sendingBtnY = screenSize.height * (10 / referenceHeight);
    final double sendingBtnFontSize =
        screenSize.height * (16 / referenceHeight);
    final double paddingX = screenSize.width * (2 / referenceWidth);
    final double messageRecipientDropdownBtnWidth =
        screenSize.width * (210 / referenceWidth);
    final double messageRecipientDropdownBtnHeight =
        screenSize.height * (50 / referenceHeight);

    final double messageRecipientSelectDataTextSize =
        screenSize.height * (16 / referenceHeight);
    final double messageDataTextSize1 =
        screenSize.height * (14 / referenceHeight);
    final double messageDataTextSize2 =
        screenSize.height * (16 / referenceHeight);

    // 펼치기 및 닫기 버튼 수치
    final double messageExpandedBtnFontSize =
        screenSize.height * (14 / referenceHeight); // 펼치기 및 닫기 버튼 크기
    final double messageExpandedBtnHeight =
        screenSize.height * (30 / referenceHeight);
    final double messageExpandedBtnWidth =
        screenSize.width * (300 / referenceWidth);

    // 삭제 버튼 수치
    final double deleteBtnHeight = screenSize.height * (30 / referenceHeight);
    final double deleteBtnWidth = screenSize.width * (60 / referenceWidth);
    final double deleteBtnPaddingY = screenSize.height * (2 / referenceHeight);
    final double deleteBtnPaddingX = screenSize.width * (4 / referenceWidth);
    final double deleteBtnFontSize = screenSize.height * (12 / referenceHeight);

    // 컨텐츠 사이의 간격 수치
    final double intervalX = screenSize.width * (8 / referenceWidth);
    final double interva2X = screenSize.width * (10 / referenceWidth);
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

    // 날짜 형식을 'yyyy년 MM월 dd일 HH시 MM분'로 지정함
    final dateFormat = DateFormat('yyyy년 MM월 dd일 HH시 mm분');

    final messageItems = ref.watch(privateMessageItemsListNotifierProvider);

    // 쪽지 목록이 비어 있는 경우
    if (messageItems.isEmpty) {
      // 쪽지 목록이 비어있을 경우 "'현재 쪽지 목록 내 쪽지가 없습니다." 메시지 표시
      return Container(
        width: messageEmptyTextWidth,
        height: messageEmptyTextHeight,
        margin:
            EdgeInsets.only(left: messageEmptyTextX, top: messageEmptyTextY),
        child: Text(
          '현재 쪽지 목록 내 쪽지가 없습니다.',
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
      children: messageItems.asMap().entries.map((entry) {
        final index = entry.key;
        final message = entry.value;

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
              bottom:
                  BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 지정함
            ),
          ),
          child: CommonCardView(
            // 공통 카드뷰 위젯 사용
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
            elevation: 0, // 그림자 깊이 설정
            content: Padding(
              // 패딩 설정
              padding: EdgeInsets.zero, // 패딩을 없앰
              // Column 위젯을 사용하여 여러 위젯을 수직으로 배치함
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                children: [
                  Row(
                    children: [
                      _buildMessageInfoRow(
                        context,
                        '수신일시: ',
                        message['message_sendingTime'] != null &&
                            message['message_sendingTime'] is Timestamp
                            ? dateFormat.format(
                            (message['message_sendingTime'] as Timestamp)
                                .toDate())
                            : '',
                        bold: true,
                        fontSize:
                        messageDataTextSize1, // 쪽지 내용 텍스트 글꼴 크기 설정함
                        color: GRAY41_COLOR,
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      // 카드뷰 내부 오른쪽 끝에 위치하는 삭제 버튼
                      Container(
                        width: deleteBtnWidth,
                        height: deleteBtnHeight,
                        margin: EdgeInsets.only(
                            left: intervalX, right: intervalX), // 오른쪽 여백 설정
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: GRAY44_COLOR,
                            // 텍스트 색상 설정
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            // 버튼 배경색을 앱 배경색으로 설정
                            side: BorderSide(color: GRAY44_COLOR),
                            // 버튼 테두리 색상 설정
                            padding: EdgeInsets.symmetric(
                                vertical: deleteBtnPaddingY,
                                horizontal: deleteBtnPaddingX), // 버튼 패딩
                          ),
                          onPressed: () async {
                            // 쪽지 삭제 버튼 클릭 시 확인 다이얼로그를 표시함
                            await showSubmitAlertDialog(
                              context,
                              title: '[쪽지 삭제]',
                              // 다이얼로그 제목 설정
                              content:
                                  '삭제 시, 해당 쪽지는 영구적으로 삭제됩니다.\n해당 쪽지를 삭제하시겠습니까?',
                              // 다이얼로그 내용 설정
                              actions: buildAlertActions(
                                context,
                                noText: '아니요',
                                // 아니요 버튼 텍스트 설정
                                yesText: '예',
                                // 예 버튼 텍스트 설정
                                noTextStyle: TextStyle(
                                  color: BLACK_COLOR, // 아니요 버튼 텍스트 색상 설정
                                  fontWeight:
                                      FontWeight.bold, // 아니요 버튼 텍스트 굵기 설정
                                ),
                                yesTextStyle: TextStyle(
                                  color: RED46_COLOR, // 예 버튼 텍스트 색상 설정
                                  fontWeight: FontWeight.bold, // 예 버튼 텍스트 굵기 설정
                                ),
                                onYesPressed: () async {
                                  try {
                                    final messageId = message['id'];
                                    await ref
                                        .read(
                                            privateMessageItemsListNotifierProvider
                                                .notifier)
                                        .deleteMessage(messageId, widget.timeFrame);
                                    // 클래스 유형이 ConsumerStatefulWidget이면 데이터 변수 앞에 widget읇 붙여함 (해당 유형이 아니면 그냥 변수를 사용하면 됨)
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                    showCustomSnackBar(context, '쪽지가 삭제되었습니다.');
                                  } catch (e) {
                                    showCustomSnackBar(
                                        context, '쪽지 삭제 중 오류가 발생했습니다: $e');
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
                  _buildMessageInfoRow(
                    context,
                    '발주번호: ',
                    message['order_number'] ?.toString().isNotEmpty == true ? message['order_number'] : '',
                    bold: true,
                    fontSize:
                    messageDataTextSize1, // 쪽지 내용 텍스트 글꼴 크기 설정함
                    color: RED46_COLOR,
                  ),
                  // 메시지 내용 표시 부분
                  SizedBox(height: interval1Y),
                    _buildMessageInfoRow(
                      context,
                      '내용: ',
                      message['contents']?.toString().isNotEmpty == true
                          ? message['contents']
                          : '',
                      bold: true,
                      fontSize: messageDataTextSize1,
                    ),
                    SizedBox(height: interval1Y),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // _buildMessageInfoRow 함수는 쪽지의 정보 항목을 텍스트 형태로 표시하는 행(Row)을 생성함.
  // 쪽지 정보의 라벨과 값은 파라미터로 전달되며, 필요에 따라 굵은 텍스트로 표시할 수 있음.
  Widget _buildMessageInfoRow(BuildContext context, String label, String value,
      {bool bold = false, double fontSize = 16, Color color = BLACK_COLOR}) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 컨텐츠 사이의 간격 수치
    final double interval1X = screenSize.width * (4 / referenceWidth);
    final double interval1Y = screenSize.height * (4 / referenceHeight);

    if (label.length + value.length <= 30) {
      return Padding(
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'NanumGothic',
                color: color,
              ),
            ),
            // 정보의 라벨을 텍스트로 표시함. 글꼴 크기와 굵기는 파라미터에 따라 설정됨.

            SizedBox(width: interval1X),
              Text(
                value ?? '',
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: 'NanumGothic',
                  color: color,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.start,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            // 정보의 값을 텍스트로 표시함. 값이 길 경우 줄임말로 표시되고,
            // 텍스트가 여러 줄에 걸쳐 표시될 수 있도록 설정됨.
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: BLACK_COLOR,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'NanumGothic',
              ),
            ),
            // 정보의 라벨을 텍스트로 표시함. 글꼴 크기와 굵기는 파라미터에 따라 설정됨.

            SizedBox(height: interval1Y),
            Text(
              value ?? '',
              style: TextStyle(
                fontSize: fontSize,
                color: BLACK_COLOR,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'NanumGothic',
              ),
              textAlign: TextAlign.start,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            // 정보의 값을 텍스트로 표시함. 텍스트가 여러 줄에 걸쳐 표시될 수 있도록 설정되며,
            // 줄임말이 아닌 전체 텍스트가 표시됨.
          ],
        ),
      );
    }
    // 정보의 길이에 따라 Row 또는 Column으로 구성된 정보를 표시함.
    // 정보의 라벨과 값이 짧을 경우 Row로 표시되며, 길 경우 Column으로 표시됨.
  }
}
// ------ 마이페이지용 쪽지 관리 화면 내 계정별 관련 쪽지 목록 불러와서 UI 구현하는 PrivateMessageBodyPartsContents 클래스 내용 끝
