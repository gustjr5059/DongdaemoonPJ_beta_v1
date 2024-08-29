
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
  String? selectedProduct; // 선택된 상품 저장
  String? selectedSeparatorKey; // 선택된 separator_key 저장

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
      selectedProduct = null; // 상품 선택 초기화
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
                          } else if (value == '환불 메세지') {
                            messageContentText = '해당 발주 건은 환불 처리 되었습니다.';
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
                          value: '환불 메세지',
                          child: Text('환불 메세지'),
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
            )
          else if (messageContent == '환불 메세지')
              FutureBuilder<List<String>>(
                future: ref.read(orderNumbersProvider(selectedReceiver)).whenData(
                      (orderNumbersList) async {
                    final repository = ref.read(adminMessageRepositoryProvider);
                    return await repository.fetchProductOptions(selectedReceiver!, selectedOrderNumber!);
                  },
                ).value,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('상품이 없습니다.');
                  }

                  // 중복된 value가 없도록 확인하는 로직 추가
                  final items = snapshot.data!.toSet().toList().map((productOption) {
                    return DropdownMenuItem<String>(
                      value: productOption,
                      child: Text(productOption),
                    );
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "환불 신청 상품:" 라벨을 상단에 배치
                      Text('환불 신청 상품:', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8), // 라벨과 드롭다운 메뉴 사이에 간격 추가
                      // 드롭다운 메뉴를 아래에 배치
                      _buildRefundProdSelectDropdown(
                        value: selectedProduct,
                        items: items,
                        onChanged: (value) {
                          setState(() {
                            selectedProduct = value;
                            selectedSeparatorKey = value?.split(' ')[0];
                            messageContentText = '해당 발주 건은 환불 처리 되었습니다.';
                            ref.read(adminCustomMessageProvider.notifier).state = messageContentText;
                          });
                        },
                      ),
                      SizedBox(height: 15),
                      AbsorbPointer(
                        absorbing: true, // 입력 비활성화
                        child: TextFormField(
                          key: ValueKey(messageContentText),
                          initialValue: messageContentText,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
          SizedBox(height: 50),

          if (messageContent != null && messageContent!.isNotEmpty)
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final customMessage = ref.read(adminCustomMessageProvider);
                  await ref.read(sendMessageProvider({
                    'sender': currentUser.email!,
                    'recipient': selectedReceiver!,
                    'order_number': selectedOrderNumber!,
                    'contents': customMessage!,
                    'selected_separator_key': selectedSeparatorKey,
                  }).future);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('쪽지 발송에 성공했습니다.'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: BUTTON_COLOR,
                  backgroundColor: BACKGROUND_COLOR,
                  side: BorderSide(color: BUTTON_COLOR),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                ),
                child: Text('발송하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRefundProdSelectDropdown({
    required String? value, // 현재 선택된 값을 저장하는 매개변수임.
    required List<DropdownMenuItem<String>>? items, // 드롭다운 메뉴 항목들의 리스트임.
    required ValueChanged<String?>? onChanged, // 값이 변경될 때 호출되는 콜백 함수임.
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // 행의 수직 정렬을 중앙에 맞춤.
      children: [
        Expanded( // 드롭다운 메뉴가 가능한 공간을 모두 차지하도록 확장함.
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0), // 테두리 모서리를 둥글게 만듦.
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0), // 입력 필드 내부의 좌우 여백을 설정함.
            ),
            child: DropdownButtonHideUnderline( // 드롭다운 메뉴에서 기본 밑줄을 숨김.
              child: DropdownButton<String>(
                hint: Text('선택'), // 드롭다운 메뉴에서 아무것도 선택되지 않았을 때 표시되는 힌트 텍스트임.
                value: value, // 현재 선택된 값으로, 드롭다운의 기본 선택 항목을 나타냄.
                onChanged: onChanged, // 드롭다운 항목이 선택될 때 호출되는 함수임.
                items: items, // 드롭다운 메뉴의 항목들을 나타냄.
              ),
            ),
          ),
        ),
      ],
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

// message_delete_time 필드의 데이터 타입이 Timestamp로 되어 있어, 이를 DateTime으로 변환한 후, 문자열로 포맷팅하는 함수
  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate(); // Timestamp를 DateTime으로 변환하는 코드
      return DateFormat('[yyyy년 MM월 dd일 HH시 mm분] ').format(dateTime); // 변환된 DateTime을 포맷팅하여 문자열로 반환하는 코드
    } else {
      return ''; // timestamp가 Timestamp 타입이 아닌 경우 빈 문자열을 반환하는 코드
    }
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
              hint: Text('쪽지 수신자 선택'), // 드롭다운 메뉴에서 선택할 수신자 선택 힌트 텍스트
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
                String deleteTime = '';

                // 'message_delete_time' 필드값이 존재 유무에 따라 해당 필드값을 노출
                if (message.containsKey('message_delete_time')) {
                  deleteTime = formatTimestamp(message['message_delete_time']);
                }

                // '[자세히]' 버튼을 클릭했을 때 팝업을 띄우는 함수
                void showMessageDetailDialog(BuildContext context) async {
                  // showSubmitAlertDialog 함수를 호출하여 쪽지 내용을 보여주는 팝업을 띄움
                  await showSubmitAlertDialog(
                    context,
                    title: '쪽지 내용', // 팝업의 제목 설정
                    contentWidget: RichText(
                      // RichText 위젯을 사용하여 다양한 스타일의 텍스트를 구성함
                      text: TextSpan(
                        children: [
                          if (deleteTime.isNotEmpty)
                            TextSpan(
                              text: deleteTime,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          // $statusIcon 부분을 파란색으로 설정하고 Bold로 표시함
                          TextSpan(
                            text: statusIcon,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          // $recipientText 부분을 빨간색으로 설정하고 Bold로 표시함
                          TextSpan(
                            text: recipientText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          // '님께서 발주 완료한 ' 부분을 기본 색상(검정)으로 표시함
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
                      noTextStyle: TextStyle( // '닫기' 버튼 스타일을 검은색 Bold로 설정
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  // Column 위젯을 사용하여 여러 위젯을 수직으로 배치함
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Expanded 위젯을 사용하여 자식 위젯이 가용 공간을 모두 차지하도록 설정함
                          Expanded(
                            child: CommonCardView(
                              backgroundColor: BEIGE_COLOR, // 배경색을 베이지색으로 설정함
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // 자식 위젯들을 왼쪽 정렬함
                                children: [
                                  RichText(
                                    maxLines: 2, // 최대 두 줄까지 텍스트를 표시함
                                    overflow: TextOverflow.ellipsis, // 넘치는 텍스트는 '...'로 표시함
                                    text: TextSpan(
                                      children: [
                                        if (deleteTime.isNotEmpty)
                                          TextSpan(
                                            text: deleteTime,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        // $statusIcon 부분을 파란색으로 설정하고 Bold로 표시함
                                        TextSpan(
                                          text: statusIcon,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        // $recipientText 부분을 빨간색으로 설정하고 Bold로 표시함
                                        TextSpan(
                                          text: recipientText,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                        // '님께서 발주 완료한 ' 부분을 검정색으로 표시함
                                        TextSpan(
                                          text: '님께서 발주 완료한 ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
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
                                        // ' 건 관련 ${message['contents']}' 부분을 검정색으로 표시함
                                        TextSpan(
                                          text: ' 건 관련 ${message['contents']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    // 자식 위젯들을 양 끝에 정렬함
                                    children: [
                                      Spacer(), // 자식 위젯들 간에 빈 공간을 추가함
                                      TextButton(
                                        onPressed: () {
                                          showMessageDetailDialog(context); // '[자세히]' 버튼을 클릭했을 때 showMessageDetailDialog 함수를 호출함
                                        },
                                        child: Text(
                                          '[자세히]', // '[자세히]' 버튼 텍스트 설정
                                          style: TextStyle(
                                            color: Colors.blue, // 텍스트 색상을 파란색으로 설정함
                                            fontWeight: FontWeight.bold, // 텍스트를 Bold로 설정함
                                            fontSize: 16, // 텍스트 크기를 16으로 설정함
                                          ),
                                        ),
                                      ),
                                      Spacer(), // 자식 위젯들 간에 빈 공간을 추가함
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: BUTTON_COLOR, // 버튼 텍스트 색상을 BUTTON_COLOR로 설정함
                                          backgroundColor: BACKGROUND_COLOR, // 버튼 배경색을 BACKGROUND_COLOR로 설정함
                                          side: BorderSide(color: BUTTON_COLOR), // 버튼 테두리 색상을 BUTTON_COLOR로 설정함
                                          padding: EdgeInsets.symmetric(vertical: 8), // 버튼의 수직 패딩을 8로 설정함
                                        ),
                                        onPressed: () async {
                                          // 쪽지 삭제 버튼 클릭 시 확인 다이얼로그를 표시함
                                          await showSubmitAlertDialog(
                                            context,
                                            title: '쪽지 삭제', // 다이얼로그 제목 설정
                                            content: '쪽지를 삭제하면 데이터베이스에서 영구적으로 삭제됩니다.\n해당 쪽지를 삭제하시겠습니까?', // 다이얼로그 내용 설정
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
                                                  await ref.read(fetchDeleteAllMessageProvider({
                                                    'messageId': message['id'],
                                                    'recipient': message['recipient'],
                                                    }).future); // '삭제' 버튼 클릭 시 쪽지를 삭제하는 함수 호출함
                                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('쪽지가 삭제되었습니다.')), // 리뷰 삭제 완료 메시지 표시
                                                    );
                                                 } catch (e) {
                                                   ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('쪽지 삭제 중 오류가 발생했습니다: $e')), // 오류 메시지 표시
                                                   );
                                                 }
                                               },
                                            ),
                                          );
                                        },
                                        child: Text(
                                          '삭제', // '삭제' 버튼 텍스트 설정
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold, // 텍스트를 Bold로 설정함
                                            fontSize: 16, // 텍스트 크기를 16으로 설정함
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
              }).toList(),
            );
          },
          loading: () => Center(child: CircularProgressIndicator()), // 데이터 로딩 중에는 로딩 애니메이션 표시함
          error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')), // 오류 발생 시 오류 메시지를 표시함
        ),
      ],
    );
  }
}
// ------ 관리자용 쪽지 관리 화면 내 모든 계정의 쪽지 목록 불러와서 UI 구현하는 AdminMessageListScreen 클래스 내용 끝