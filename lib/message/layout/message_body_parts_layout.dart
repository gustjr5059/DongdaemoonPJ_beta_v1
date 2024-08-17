import 'package:cloud_firestore/cloud_firestore.dart';
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

    // 가져온 쪽지 데이터의 상태에 따라 UI를 구성.
    return messages.when(
      // 데이터가 성공적으로 로드된 경우
      data: (messagesList) {
        // 쪽지 목록이 비어 있는 경우
        if (messagesList.isEmpty) {
          return Center(child: Text('쪽지가 없습니다.'));
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

            // 쪽지를 탭하면 상세 정보를 보여주는 팝업을 띄움.
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // 팝업 내용을 구성.
                    return AlertDialog(
                      backgroundColor: LIGHT_YELLOW_COLOR, // 팝업 배경색을 베이지로 설정
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            // 쪽지 내용을 강조하여 표시.
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: recipientText,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red, // 빨간색 텍스트
                                    ),
                                  ),
                                  TextSpan(
                                    text: '님께서 발주 완료한 ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // 기본 텍스트 색상
                                    ),
                                  ),
                                  TextSpan(
                                    text: orderNumberText,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red, // 빨간색 텍스트
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' 건 관련 ${message['contents']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // 기본 텍스트 색상
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        // 닫기 버튼을 구성.
                        TextButton(
                          child: Text(
                            '닫기',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // 닫기 텍스트 색상을 검은색으로 설정
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              // 쪽지 목록 카드 뷰를 구성.
              child: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        // Expanded 위젯을 사용하여 가로로 공간을 최대한 차지하도록 설정
                        child: CommonCardView(
                          // CommonCardView 위젯을 사용하여 카드 뷰를 구성
                          backgroundColor: BEIGE_COLOR, // 카드 뷰의 배경색을 BEIGE_COLOR로 설정
                          content: RichText(
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
                                    fontWeight: FontWeight.bold, // 텍스트를 볼드체로 설정
                                    color: Colors.red, // 텍스트 색상을 빨간색으로 설정
                                  ),
                                ),
                                TextSpan(
                                  // 두 번째 텍스트 스팬
                                  text: '님께서 발주 완료한 ', // 고정된 안내 텍스트
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // 텍스트를 볼드체로 설정
                                    color: Colors.black, // 텍스트 색상을 검은색으로 설정
                                  ),
                                ),
                                TextSpan(
                                  // 세 번째 텍스트 스팬
                                  text: orderNumberText, // 주문 번호 텍스트를 설정
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // 텍스트를 볼드체로 설정
                                    color: Colors.red, // 텍스트 색상을 빨간색으로 설정
                                  ),
                                ),
                                TextSpan(
                                  // 네 번째 텍스트 스팬
                                  text: ' 건 관련 ${message['contents']}', // 메시지 내용을 설정
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // 텍스트를 볼드체로 설정
                                    color: Colors.black, // 텍스트 색상을 검은색으로 설정
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // 컨테이너를 사용하여 아이콘 배경을 설정
                        color: LIGHT_PURPLE_COLOR, // 아이콘 배경색을 LIGHT_PURPLE_COLOR로 설정
                        child: IconButton(
                          // IconButton 위젯을 사용하여 닫기 버튼을 구성
                          icon: Icon(Icons.close), // 닫기 아이콘을 설정
                          onPressed: () {
                            // 닫기 버튼 클릭 시, 해당 메시지의 'private_email_closed_button' 필드를 'true'로 변경
                            ref.read(fetchDeleteMessagesProvider(message['id']));
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(), // 쪽지 목록을 반복하여 각 항목을 리스트로 구성
        );
      },
      loading: () => Center(child: CircularProgressIndicator()), // 로딩 상태에서 로딩 인디케이터를 중앙에 표시
      error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')), // 오류 상태에서 오류 메시지를 중앙에 표시
    );
  }
}
// ------ 마이페이지용 쪽지 관리 화면 내 계정별 관련 쪽지 목록 불러와서 UI 구현하는 PrivateMessageBodyPartsContents 클래스 내용 끝
