import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/const/colors.dart';
import '../provider/message_all_provider.dart';
import '../provider/message_state_provider.dart'; // Provider 파일 임포트

// ------ 관리자용 쪽지 관리 화면 내 '쪽지 작성', '쪽지 목록' 탭 선택해서 해당 내용을 보여주는 UI 관련 MessageScreenTabs 클래스 내용 시작
class MessageScreenTabs extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 선택된 탭을 가져옴.
    final currentTab = ref.watch(messageScreenTabProvider);

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
        ref.read(messageScreenTabProvider.notifier).state = tab;
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
        return MessageCreateFormScreen(); // '쪽지 작성' 화면을 반환.
      case MessageScreenTab.list:
        return MessageListScreen(); // '쪽지 목록' 화면을 반환.
      default:
        return Container(); // 기본적으로 빈 컨테이너를 반환.
    }
  }
}
// ------ 관리자용 쪽지 관리 화면 내 '쪽지 작성', '쪽지 목록' 탭 선택해서 해당 내용을 보여주는 UI 관련 MessageScreenTabs 클래스 내용 끝

// ------ 관리자용 쪽지 관리 화면 내 '쪽지 작성' 탭 관련 내용을 구현하는 MessageCreateFormScreen 클래스 내용 시작
class MessageCreateFormScreen extends ConsumerStatefulWidget {
  @override
  _MessageCreateFormScreenState createState() => _MessageCreateFormScreenState();
}

class _MessageCreateFormScreenState extends ConsumerState<MessageCreateFormScreen> {
  String? selectedReceiver; // 선택된 수신자를 저장하는 변수.
  String? selectedOrderNumber; // 선택된 발주번호를 저장하는 변수.

  @override
  Widget build(BuildContext context) {
    // 현재 로그인한 사용자 정보를 가져옴.
    final currentUser = ref.watch(currentUserProvider).asData?.value;
    // 수신자 목록을 가져옴.
    final receivers = ref.watch(receiversProvider);
    // 선택된 수신자에 따른 발주번호 목록을 가져옴.
    final orderNumbers = ref.watch(orderNumbersProvider(selectedReceiver));
    // 현재 입력된 메시지 내용을 가져옴.
    final messageContent = ref.watch(messageContentProvider);

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
              Expanded(
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  child: receivers.when(
                    data: (receiversList) => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text('수신자 선택'),
                        value: selectedReceiver,
                        onChanged: (value) {
                          setState(() {
                            selectedReceiver = value;
                            selectedOrderNumber = null;
                          });
                        },
                        items: receiversList.map((receiver) {
                          return DropdownMenuItem<String>(
                            value: receiver.email,
                            child: Text(receiver.email),
                          );
                        }).toList(),
                      ),
                    ),
                    loading: () => CircularProgressIndicator(),
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
                      onChanged: selectedReceiver == null ? null : (value) {
                        setState(() {
                          selectedOrderNumber = value;
                        });
                      },
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
                      onChanged: selectedOrderNumber == null ? null : (value) {
                        ref.read(messageContentProvider.notifier).state = value;
                        if (value == '결제 완료 메세지') {
                          ref.read(customMessageProvider.notifier).state = '해당 발주 건은 결제 완료 되었습니다.';
                        } else {
                          ref.read(customMessageProvider.notifier).state = '';
                        }
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: '결제 완료 메세지',
                          child: Text('결제 완료 메세지'),
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
          // '결제 완료 메세지'가 선택된 경우, 수정 불가능한 텍스트 필드를 표시.
          if (messageContent == '결제 완료 메세지')
            AbsorbPointer(
              absorbing: true, // 클릭 비활성화
              child: TextFormField(
                initialValue: '해당 발주 건은 결제 완료 되었습니다.',
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          // '직접입력'이 선택된 경우, 수정 가능한 텍스트 필드를 표시.
          if (messageContent == '직접입력')
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
                hintText: '200자 이내로 작성가능합니다.',
              ),
              onChanged: (value) {
                ref.read(customMessageProvider.notifier).state = value;
              },
            ),
          SizedBox(height: 50), // 입력칸 아래에 간격 추가
          // 메시지 내용이 선택된 경우, 발송 버튼을 표시.
          if (messageContent != null && messageContent!.isNotEmpty)
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final customMessage = ref.read(customMessageProvider);
                  await ref.read(sendMessageProvider({
                    'sender': currentUser.email!,
                    'recipient': selectedReceiver!,
                    'orderNumber': selectedOrderNumber!,
                    'contents': customMessage!,
                  }).future);
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
// ------ 관리자용 쪽지 관리 화면 내 '쪽지 작성' 탭 관련 내용을 구현하는 MessageCreateFormScreen 클래스 내용 끝

// ------ 관리자용 쪽지 관리 화면 내 '쪽지 목록' 탭 관련 내용을 구현하는 MessageListScreen 클래스 내용 시작
class MessageListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 여기에 쪽지 목록 화면 UI를 구현
    return Center(child: Text('쪽지 목록 화면'));
  }
}
// ------ 관리자용 쪽지 관리 화면 내 '쪽지 목록' 탭 관련 내용을 구현하는 MessageListScreen 클래스 내용 끝
