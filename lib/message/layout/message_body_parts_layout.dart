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

    // 현재 사용자의 이메일로 쪽지 목록을 실시간으로 가져옴.
    final messages = ref.watch(fetchMessagesProvider(currentUserEmail));

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
            String orderNumberText = '[발주번호: ${message['orderNumber']}]';

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
              child: CommonCardView(
                backgroundColor: BEIGE_COLOR, // 배경색을 베이지로 설정
                content: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
              ),
            );
          }).toList(),
        );
      },
      // 데이터를 로드 중인 경우
      loading: () => Center(child: CircularProgressIndicator()),
      // 데이터를 로드하는 도중 오류가 발생한 경우
      error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
    );
  }
}
// ------ 마이페이지용 쪽지 관리 화면 내 계정별 관련 쪽지 목록 불러와서 UI 구현하는 PrivateMessageBodyPartsContents 클래스 내용 끝
