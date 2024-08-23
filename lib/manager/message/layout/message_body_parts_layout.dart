
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
                    'order_number': selectedOrderNumber!,
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
class AdminMessageListScreen extends ConsumerStatefulWidget {
  @override
  _AdminMessageListScreenState createState() => _AdminMessageListScreenState();
}

class _AdminMessageListScreenState extends ConsumerState<AdminMessageListScreen> {
  @override
  void initState() {
    super.initState();
    // 초기화 함수를 지연 호출하여 위젯이 완전히 초기화된 후 실행되도록 함.
    Future.microtask(() => _resetForm());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 종속성이 변경될 때 초기화 함수를 지연 호출하여 변경된 종속성에 따라
    // 상태를 초기화함.
    Future.microtask(() => _resetForm());
  }

  void _resetForm() {
    // 화면의 상태를 초기화하는 로직
    setState(() {
      // 선택된 수신자 상태를 초기화 (null로 설정)
      ref.read(selectedReceiverProvider.notifier).state = null;
    });
  }

  @override
  Widget build(BuildContext context) {

    // 선택된 수신자 이메일을 관리하는 상태를 가져옴
    final selectedReceiver = ref.watch(selectedReceiverProvider);

    // 드롭다운 메뉴에 사용할 수신자 이메일 목록을 가져옴
    final receivers = ref.watch(receiversProvider);

    // // 선택된 수신자의 1분 이내 발송된 쪽지 목록을 가져옴
    // final messages = ref.watch(fetchMinutesAllMessagesProvider(selectedReceiver));

    // 선택된 수신자의 30일 이내 발송된 쪽지 목록을 가져옴
    final messages = ref.watch(fetchDaysAllMessagesProvider(selectedReceiver));

    // // 선택된 수신자의 1년(365일) 이내 발송된 쪽지 목록을 가져옴
    // final messages = ref.watch(fetchYearsAllMessagesProvider(selectedReceiver));

    return Column(
      children: [
        // 수신자 필터링을 위한 드롭다운 메뉴 버튼
        receivers.when(
          data: (receiversList) {
            return DropdownButton<String>(
              hint: Text('수신자 선택'), // 드롭다운 메뉴에서 선택할 수신자 선택 힌트 텍스트
              value: selectedReceiver, // 현재 선택된 수신자 이메일 값 설정
              onChanged: (value) {
                // 선택한 수신자 이메일을 상태로 업데이트
                ref.read(selectedReceiverProvider.notifier).state = value;
              },
              items: receiversList.map((receiver) {
                return DropdownMenuItem<String>(
                  value: receiver.email, // 수신자 이메일 값 설정
                  child: Text(receiver.email), // 드롭다운 메뉴에 표시될 이메일 텍스트 설정
                );
              }).toList(),
            );
          },
          loading: () => CircularProgressIndicator(), // 수신자 목록을 불러오는 중일 때 로딩 인디케이터 표시
          error: (error, stack) => Text('오류가 발생했습니다: $error'), // 수신자 목록을 불러오는 중 오류 발생 시 오류 메시지 표시
        ),
        SizedBox(height: 20), // 드롭다운 메뉴와 메시지 목록 사이에 간격을 둠
        // 선택된 수신자의 쪽지 목록을 표시하는 부분
        messages.when(
          data: (messagesList) {
            if (messagesList.isEmpty) {
              return Center(child: Text('쪽지가 없습니다.')); // 쪽지 목록이 비어있을 경우 "쪽지가 없습니다" 메시지 표시
            }

            // 최신 쪽지가 위로 오도록 리스트를 역순으로 정렬.
            final reversedMessages = messagesList.reversed.toList(); // 쪽지 목록을 최신 순으로 정렬

            // 쪽지 목록을 열의 형태로 표시.
            return Column(
              children: reversedMessages.map((message) {
                // private_email_closed_button 필드값에 따라 '[O]' 또는 '[X]' 표시
                String statusIcon = message['private_email_closed_button'] == true ? '[삭제 O]  ' : '[삭제 X]  '; // private_email_closed_button 값에 따라 상태 아이콘 설정
                String recipientText = '${message['recipient']}'; // 수신자 이메일 텍스트 설정
                String orderNumberText = '[발주번호: ${message['order_number']}]'; // 발주번호 텍스트 설정

                // 팝업을 띄우는 함수를 정의
                void showAlertDialog(BuildContext context) {
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
                                      text: statusIcon, // 상태 아이콘 텍스트 설정
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue, // 파란색 텍스트 색상 설정
                                      ),
                                    ),
                                    TextSpan(
                                      text: recipientText, // 수신자 이메일 텍스트 설정
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red, // 빨간색 텍스트 색상 설정
                                      ),
                                    ),
                                    TextSpan(
                                      text: '님께서 발주 완료한 ', // 고정된 안내 텍스트
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black, // 기본 텍스트 색상 설정
                                      ),
                                    ),
                                    TextSpan(
                                      text: orderNumberText, // 발주번호 텍스트 설정
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red, // 빨간색 텍스트 색상 설정
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' 건 관련 ${message['contents']}', // 쪽지 내용 텍스트 설정
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black, // 기본 텍스트 색상 설정
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
                              Navigator.of(context).pop(); // 닫기 버튼을 눌렀을 때 팝업 닫기
                            },
                          ),
                        ],
                      );
                    },
                  );
                }

                // 쪽지 목록 카드 뷰를 구성.
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0), // 화면의 가로 길이에 맞게 패딩 조정
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            // Expanded 위젯을 사용하여 가로로 공간을 최대한 차지하도록 설정
                            child: CommonCardView(
                              // CommonCardView 위젯을 사용하여 카드 뷰를 구성
                              backgroundColor: BEIGE_COLOR, // 카드 뷰의 배경색을 BEIGE_COLOR로 설정
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    // RichText 위젯을 사용하여 다양한 스타일의 텍스트를 포함
                                    maxLines: 2, // 최대 두 줄까지만 텍스트를 표시
                                    overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 생략 부호로 처리
                                    text: TextSpan(
                                      // TextSpan을 사용하여 스타일이 다른 텍스트들을 결합
                                      children: [
                                        TextSpan(
                                          text: statusIcon, // 상태 아이콘 텍스트 설정
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue, // 파란색 텍스트 색상 설정
                                          ),
                                        ),
                                        TextSpan(
                                          text: recipientText, // 수신자 이메일 텍스트 설정
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red, // 텍스트 색상을 빨간색으로 설정
                                          ),
                                        ),
                                        TextSpan(
                                          text: '님께서 발주 완료한 ', // 고정된 안내 텍스트 설정
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black, // 텍스트 색상을 검은색으로 설정
                                          ),
                                        ),
                                        TextSpan(
                                          text: orderNumberText, // 발주번호 텍스트 설정
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red, // 텍스트 색상을 빨간색으로 설정
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' 건 관련 ${message['contents']}', // 메시지 내용 텍스트 설정
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
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
                                          showAlertDialog(context);
                                        },
                                        child: Text(
                                          '[자세히]', // [자세히] 텍스트를 표시
                                          style: TextStyle(
                                            color: Colors.blue, // 텍스트 색상을 파란색으로 설정
                                            fontWeight: FontWeight.bold, // 텍스트를 볼드체로 설정
                                            fontSize: 16, // 텍스트 크기 설정
                                          ),
                                        ),
                                      ),
                                      Spacer(), // 중앙에 위치시키기 위해 Spacer 추가
                                      // 카드뷰 내부 오른쪽 끝에 위치하는 삭제 버튼
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: BUTTON_COLOR,
                                          backgroundColor: BACKGROUND_COLOR,
                                          side: BorderSide(color: BUTTON_COLOR),
                                          padding: EdgeInsets.symmetric(vertical: 8),
                                        ),
                                        onPressed: () {
                                          ref.read(fetchDeleteAllMessageProvider({
                                            'messageId': message['id'],
                                            'recipient': message['recipient'],
                                          }).future);
                                        },
                                        child: Text(
                                          '삭제',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16, // 텍스트 크기 설정
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
        ),
      ],
    );
  }
}
// ------ 관리자용 쪽지 관리 화면 내 모든 계정의 쪽지 목록 불러와서 UI 구현하는 AdminMessageListScreen 클래스 내용 끝