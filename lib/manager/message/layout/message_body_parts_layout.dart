import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/message_all_provider.dart';
import '../provider/message_state_provider.dart'; // Provider 파일 임포트


// ------ 관리자용 쪽지 관리 화면 내 '쪽지 작성', '쪽지 목록' 탭 선택해서 해당 내용을 보여주는 UI 관련 MessageScreenTabs 클래스 내용 시작
class MessageScreenTabs extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(messageScreenTabProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabButtons(ref, currentTab),
        SizedBox(height: 20),
        _buildTabContent(currentTab),
      ],
    );
  }

  Widget _buildTabButtons(WidgetRef ref, MessageScreenTab currentTab) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildTabButton(ref, MessageScreenTab.create, currentTab, '쪽지 작성'),
        _buildTabButton(ref, MessageScreenTab.list, currentTab, '쪽지 목록'),
      ],
    );
  }

  Widget _buildTabButton(WidgetRef ref, MessageScreenTab tab, MessageScreenTab currentTab, String text) {
    final isSelected = tab == currentTab;

    return GestureDetector(
      onTap: () {
        ref.read(messageScreenTabProvider.notifier).state = tab;
      },
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 18, // 텍스트 크기 조정
            ),
          ),
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

  Widget _buildTabContent(MessageScreenTab tab) {
    switch (tab) {
      case MessageScreenTab.create:
        return MessageCreateScreen();
      case MessageScreenTab.list:
        return MessageListScreen();
      default:
        return Container();
    }
  }
}
// ------ 관리자용 쪽지 관리 화면 내 '쪽지 작성', '쪽지 목록' 탭 선택해서 해당 내용을 보여주는 UI 관련 MessageScreenTabs 클래스 내용 끝

// ------ 관리자용 쪽지 관리 화면 내 '쪽지 작성' 탭 관련 내용을 구현하는 MessageCreateScreen 클래스 내용 시작
class MessageCreateScreen extends ConsumerStatefulWidget {
  @override
  _MessageCreateScreenState createState() => _MessageCreateScreenState();
}

class _MessageCreateScreenState extends ConsumerState<MessageCreateScreen> {
  String? selectedReceiver;
  String? selectedOrderNumber;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).asData?.value;
    final receivers = ref.watch(receiversProvider);
    final orderNumbers = ref.watch(orderNumbersProvider(selectedReceiver));

    if (currentUser == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '발신자:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: 23),
              Expanded(
                child: Text(
                  '${currentUser.email}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '수신자:',
                style: TextStyle(fontSize: 16),
              ),
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
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '발주번호:',
                style: TextStyle(fontSize: 16),
              ),
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
                      onChanged: selectedReceiver == null
                          ? null
                          : (value) {
                        setState(() {
                          selectedOrderNumber = value;
                        });
                      },
                      items: selectedReceiver == null
                          ? []
                          : orderNumbers.when(
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
          if (selectedReceiver != null && orderNumbers.isLoading)
            CircularProgressIndicator(),
        ],
      ),
    );
  }
}
// ------ 관리자용 쪽지 관리 화면 내 '쪽지 작성' 탭 관련 내용을 구현하는 MessageCreateScreen 클래스 내용 끝

// ------ 관리자용 쪽지 관리 화면 내 '쪽지 목록' 탭 관련 내용을 구현하는 MessageListScreen 클래스 내용 시작
class MessageListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 여기에 쪽지 목록 화면 UI를 구현
    return Center(child: Text('쪽지 목록 화면'));
  }
}
// ------ 관리자용 쪽지 관리 화면 내 '쪽지 목록' 탭 관련 내용을 구현하는 MessageListScreen 클래스 내용 끝