import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/const/colors.dart';
import '../../../common/layout/common_body_parts_layout.dart';
import '../provider/message_all_provider.dart';
import '../provider/message_state_provider.dart'; // Provider 파일 임포트

// ------ 관리자용 쪽지 관리 화면 내 '쪽지 작성', '쪽지 목록' 탭 선택해서 해당 내용을 보여주는 UI 관련 AdminMessageScreenTabs 클래스 내용 시작
class AdminMessageScreenTabs extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 선택된 탭을 가져옴.
    final currentTab = ref.watch(adminMessageScreenTabProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 탭 버튼을 빌드하는 메서드를 호출.
        _buildTabButtons(ref, currentTab),
        SizedBox(height: 20),
        // 현재 선택된 탭의 내용을 빌드하는 메서드를 호출.
        _buildTabContent(currentTab),
      ],
    );
  }

  // 탭 버튼을 빌드하는 메서드.
  Widget _buildTabButtons(WidgetRef ref, MessageScreenTab currentTab) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // '쪽지 작성' 탭 버튼을 빌드.
        _buildTabButton(ref, MessageScreenTab.create, currentTab, '쪽지 작성'),
        // '쪽지 목록' 탭 버튼을 빌드.
        _buildTabButton(ref, MessageScreenTab.list, currentTab, '쪽지 목록'),
      ],
    );
  }

  // 개별 탭 버튼을 빌드하는 메서드.
  Widget _buildTabButton(WidgetRef ref, MessageScreenTab tab, MessageScreenTab currentTab, String text) {
    final isSelected = tab == currentTab; // 현재 선택된 탭인지 확인.

    return GestureDetector(
      onTap: () {
        // 탭을 클릭했을 때 현재 탭 상태를 변경.
        ref.read(adminMessageScreenTabProvider.notifier).state = tab;
      },
      child: Column(
        children: [
          // 탭 텍스트를 빌드.
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 18, // 텍스트 크기 조정
            ),
          ),
          // 현재 선택된 탭이면 아래에 밑줄을 표시.
          if (isSelected)
            Container(
              width: 60,
              height: 2,
              color: Colors.black,
            ),
        ],
      ),
    );
  }

  // 현재 선택된 탭의 내용을 빌드하는 메서드.
  Widget _buildTabContent(MessageScreenTab tab) {
    switch (tab) {
      case MessageScreenTab.create:
        return AdminMessageCreateFormScreen(); // '쪽지 작성' 화면을 반환.
      case MessageScreenTab.list:
        return AdminMessageListScreen(); // '쪽지 목록' 화면을 반환.
      default:
        return Container(); // 기본적으로 빈 컨테이너를 반환.
    }
  }
}
// ------ 관리자용 쪽지 관리 화면 내 '쪽지 작성', '쪽지 목록' 탭 선택해서 해당 내용을 보여주는 UI 관련 AdminMessageScreenTabs 클래스 내용 끝

// ------ 관리자용 쪽지 관리 화면 내 '쪽지 작성' 탭 관련 내용을 구현하는 AdminMessageCreateFormScreen 클래스 내용 시작
class AdminMessageCreateFormScreen extends ConsumerStatefulWidget {
  @override
  _AdminMessageCreateFormScreenState createState() => _AdminMessageCreateFormScreenState();
}

class _AdminMessageCreateFormScreenState extends ConsumerState<AdminMessageCreateFormScreen> {
  String? selectedReceiver; // 선택된 수신자를 저장하는 변수.
  String? selectedOrderNumber; // 선택된 발주번호를 저장하는 변수.
  String? messageContentText; // 메시지 내용을 저장하는 변수.

  @override
  void initState() {
    super.initState();
    // 초기화 함수를 지연 호출
    // 위젯이 생성될 때 바로 _resetForm 함수를 호출하면,
    // 다른 위젯들이 아직 완전히 초기화되지 않았을 가능성이 있으므로,
    // Future.microtask를 사용하여 이벤트 루프가 한 번 돌아간 후
    // 초기화 함수를 호출하도록 합니다. 이렇게 하면 다른 위젯들이
    // 초기화된 후 _resetForm 함수가 실행되므로 안정성이 보장됨.
    Future.microtask(() => _resetForm());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 초기화 함수를 지연 호출
    // 위젯의 종속성이 변경될 때, 동일하게 Future.microtask를 사용하여
    // _resetForm 함수를 지연 호출. 이는 위젯 트리의 변경 사항이
    // 완전히 반영된 후 초기화 로직이 실행되도록 하여,
    // 안정성을 높이고 의도하지 않은 동작을 방지.
    Future.microtask(() => _resetForm());
  }

  void _resetForm() {
    // 상태 초기화
    // 이 함수는 사용자의 선택 항목을 초기 상태로 리셋.
    setState(() {
      // 선택된 수신자를 초기화 (null로 설정)
      selectedReceiver = null;
      // 선택된 주문 번호를 초기화 (null로 설정)
      selectedOrderNumber = null;
      // 상태 관리에서 adminMessageContentProvider의 상태를 초기화 (null로 설정)
      ref.read(adminMessageContentProvider.notifier).state = null;
      // 상태 관리에서 adminCustomMessageProvider의 상태를 초기화 (null로 설정)
      ref.read(adminCustomMessageProvider.notifier).state = null;
      messageContentText = ''; // 초기 메시지 내용을 빈 문자열로 설정
    });
  }

  @override
  Widget build(BuildContext context) {
    // 현재 로그인한 사용자 정보를 가져옴.
    final currentUser = ref.watch(currentUserProvider).asData?.value;
    // 수신자 목록을 가져옴.
    final receivers = ref.watch(receiversProvider);
    // 선택된 수신자에 따른 발주번호 목록을 가져옴.
    final orderNumbers = ref.watch(orderNumbersProvider(selectedReceiver));
    // 현재 입력된 메시지 내용을 가져옴.
    final messageContent = ref.watch(adminMessageContentProvider);

    // 만약 현재 사용자가 없다면 로딩 스피너를 표시.
    if (currentUser == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 발신자 정보를 표시하는 행.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('발신자:', style: TextStyle(fontSize: 16)),
              SizedBox(width: 23),
              // 발신자 이메일을 표시.
              Expanded(child: Text('${currentUser.email}', style: TextStyle(fontSize: 16))),
            ],
          ),
          SizedBox(height: 15),
          // 수신자를 선택하는 드롭다운 메뉴를 포함한 행.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('수신자:', style: TextStyle(fontSize: 16)),
              SizedBox(width: 23),
              // 수신자 선택 드롭다운을 위한 입력 장식.
              Expanded(
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  child: receivers.when(
                    // 수신자 목록이 성공적으로 로드된 경우 드롭다운을 표시.
                    data: (receiversList) => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text('수신자 선택'),
                        value: selectedReceiver,
                        // 수신자 선택 시 상태를 업데이트.
                        onChanged: (value) {
                          setState(() {
                            selectedReceiver = value;
                            selectedOrderNumber = null;
                          });
                        },
                        // 수신자 목록을 드롭다운 항목으로 변환.
                        items: receiversList.map((receiver) {
                          return DropdownMenuItem<String>(
                            value: receiver.email,
                            child: Text(receiver.email),
                          );
                        }).toList(),
                      ),
                    ),
                    // 로딩 중일 경우 로딩 스피너를 표시.
                    loading: () => CircularProgressIndicator(),
                    // 오류가 발생한 경우 오류 메시지를 표시.
                    error: (error, stack) => Text('오류가 발생했습니다: $error'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          // 발주번호를 선택하는 드롭다운 메뉴를 포함한 행.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('발주번호:', style: TextStyle(fontSize: 16)),
              SizedBox(width: 10),
              // 발주번호 선택 드롭다운을 위한 입력 장식.
              Expanded(
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: Text('발주번호 선택'),
                      value: selectedOrderNumber,
                      // 수신자가 선택되지 않은 경우 드롭다운을 비활성화.
                      onChanged: selectedReceiver == null ? null : (value) {
                        setState(() {
                          selectedOrderNumber = value;
                        });
                      },
                      // 수신자가 선택된 경우 발주번호 목록을 드롭다운 항목으로 변환.
                      items: selectedReceiver == null ? [] : orderNumbers.when(
                        data: (orderNumbersList) => orderNumbersList.map((orderNumber) {
                          return DropdownMenuItem<String>(
                            value: orderNumber,
                            child: Text(orderNumber),
                          );
                        }).toList(),
                        loading: () => [],
                        error: (error, stack) => [],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // 발주번호를 로딩 중이면 로딩 스피너를 표시.
          if (selectedReceiver != null && orderNumbers.isLoading)
            CircularProgressIndicator(),
          SizedBox(height: 15),
          // 메시지 내용을 선택하는 드롭다운 메뉴를 포함한 행.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('내용:', style: TextStyle(fontSize: 16)),
              SizedBox(width: 37),
              // 메시지 내용 선택 드롭다운을 위한 입력 장식.
              Expanded(
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: Text('내용 선택'),
                      value: messageContent,
                      // 메시지 내용 선택 시 상태를 업데이트.
                      onChanged: selectedOrderNumber == null ? null : (value) {
                        setState(() {
                          // 선택된 메시지 내용에 따라 텍스트를 설정.
                          if (value == '결제 완료 메세지') {
                            messageContentText = '해당 발주 건은 결제 완료 되었습니다.';
                          } else if (value == '배송 중 메세지') {
                            messageContentText = '해당 발주 건은 배송이 진행되었습니다.';
                          } else if (value == '직접입력') {
                            messageContentText = '';  // 직접입력 시 초기화
                          } else {
                            messageContentText = '';
                          }
                          // 상태를 변경해 UI 업데이트를 유도.
                          ref.read(adminMessageContentProvider.notifier).state = value;
                          ref.read(adminCustomMessageProvider.notifier).state = messageContentText;
                        });
                      },
                      // 메시지 내용을 드롭다운 항목으로 변환.
                      items: [
                        DropdownMenuItem<String>(
                          value: '결제 완료 메세지',
                          child: Text('결제 완료 메세지'),
                        ),
                        DropdownMenuItem<String>(
                          value: '배송 중 메세지',
                          child: Text('배송 중 메세지'),
                        ),
                        DropdownMenuItem<String>(
                          value: '직접입력',
                          child: Text('직접입력'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          // 메시지 내용에 따라 다르게 처리.
          if (messageContent == '결제 완료 메세지' || messageContent == '배송 중 메세지')
            AbsorbPointer(
              absorbing: true, // 입력 비활성화
              child: TextFormField(
                key: ValueKey(messageContentText), // TextFormField를 강제로 새로고침하는 키
                initialValue: messageContentText,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            )
          else if (messageContent == '직접입력')
          // 직접 입력 시 입력창을 활성화.
            TextFormField(
              initialValue: '',
              maxLength: 200,
              maxLines: null, // 입력 시 자동으로 줄바꿈
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0), // 테두리 색상 및 두께 변경
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: BUTTON_COLOR, width: 2.0), // 포커스 시 테두리 색상 및 두께 변경
                ),
                hintText: '200자 이내로 작성 가능합니다.',
              ),
              // 사용자가 입력한 메시지 내용을 상태로 업데이트.
              onChanged: (value) {
                ref.read(adminCustomMessageProvider.notifier).state = value;
              },
            ),
          SizedBox(height: 50), // 입력칸 아래에 간격을 추가.
          // 메시지 내용이 선택된 경우, 발송 버튼을 표시.
          if (messageContent != null && messageContent!.isNotEmpty)
            Center(
              child: ElevatedButton(
                // 발송 버튼을 눌렀을 때 메시지를 전송.
                onPressed: () async {
                  final customMessage = ref.read(adminCustomMessageProvider);
                  await ref.read(sendMessageProvider({
                    'sender': currentUser.email!,
                    'recipient': selectedReceiver!,
                    'orderNumber': selectedOrderNumber!,
                    'contents': customMessage!,
                  }).future);

                  // 쪽지 발송 성공 시 스낵바를 이용해 메시지를 표시.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('쪽지 발송에 성공했습니다.'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: BUTTON_COLOR, // 버튼 텍스트 색상
                  backgroundColor: BACKGROUND_COLOR, // 버튼 배경 색상
                  side: BorderSide(color: BUTTON_COLOR), // 버튼 테두리 색상
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50), // 버튼 패딩
                ),
                child: Text('발송하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // 버튼 텍스트
              ),
            ),
        ],
      ),
    );
  }
}
// ------ 관리자용 쪽지 관리 화면 내 '쪽지 작성' 탭 관련 내용을 구현하는 AdminMessageCreateFormScreen 클래스 내용 끝

// ------ 관리자용 쪽지 관리 화면 내 모든 계정의 쪽지 목록 불러와서 UI 구현하는 AdminMessageListScreen 클래스 내용 시작
class AdminMessageListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 모든 계정의 쪽지 목록을 가져옴.
    final messages = ref.watch(fetchAllMessagesProvider);

    // 가져온 쪽지 데이터의 상태에 따라 UI를 구성.
    return messages.when(
      // 데이터가 성공적으로 로드된 경우
      data: (messagesList) {
        // 현재 시간을 가져옴.
        final currentTime = DateTime.now();

        // 30일 이내에 발송된 쪽지만 필터링.
        final filteredMessagesList = messagesList.where((message) {
          final sendingTime = (message['message_sendingTime'] as Timestamp?)?.toDate();
          if (sendingTime == null) return false;
          // return currentTime.difference(sendingTime).inMinutes < 1;
             return currentTime.difference(sendingTime).inDays < 30;
        }).toList();

        // 쪽지 목록이 비어 있는 경우
        if (filteredMessagesList.isEmpty) {
          return Center(child: Text('쪽지가 없습니다.'));
        }

        // 최신 쪽지가 위로 오도록 리스트를 역순으로 정렬.
        final reversedMessages = filteredMessagesList.reversed.toList();

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
                            // 버튼이 눌렸을 때 실행할 함수 설정
                            ref.read(deleteMessageProvider({
                              'messageId': message['id'], // 메시지 ID를 전달
                              'recipient': message['recipient'], // 수신자를 전달
                            }).future);
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
// ------ 관리자용 쪽지 관리 화면 내 모든 계정의 쪽지 목록 불러와서 UI 구현하는 AdminMessageListScreen 클래스 내용 끝
