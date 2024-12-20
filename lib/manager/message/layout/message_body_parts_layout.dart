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
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 세로 852
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정
    final double intervalY = screenSize.height * (20 / referenceHeight);

    // 현재 선택된 탭을 가져옴.
    final currentTab = ref.watch(adminMessageScreenTabProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 탭 버튼을 빌드하는 메서드를 호출.
        _buildTabButtons(context, ref, currentTab),
        SizedBox(height: intervalY),
        // 현재 선택된 탭의 내용을 빌드하는 메서드를 호출.
        _buildTabContent(currentTab),
      ],
    );
  }

  // 탭 버튼을 빌드하는 메서드.
  Widget _buildTabButtons(
      BuildContext context, WidgetRef ref, MessageScreenTab currentTab) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // '쪽지 작성' 탭 버튼을 빌드.
        _buildTabButton(
            context, ref, MessageScreenTab.create, currentTab, '쪽지 작성'),
        // '쪽지 목록' 탭 버튼을 빌드.
        _buildTabButton(
            context, ref, MessageScreenTab.list, currentTab, '쪽지 목록'),
      ],
    );
  }

  // 개별 탭 버튼을 빌드하는 메서드.
  Widget _buildTabButton(BuildContext context, WidgetRef ref,
      MessageScreenTab tab, MessageScreenTab currentTab, String text) {
    final isSelected = tab == currentTab; // 현재 선택된 탭인지 확인.

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정
    final double messageTabBtnFontSize =
        screenSize.height * (18 / referenceHeight);
    final double messageTabBtnLineWidth =
        screenSize.width * (70 / referenceWidth);
    final double messageTabBtnLineHeight =
        screenSize.height * (2 / referenceHeight);

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
              color: isSelected ? BLACK_COLOR : GRAY62_COLOR,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: messageTabBtnFontSize, // 텍스트 크기 조정
            ),
          ),
          // 현재 선택된 탭이면 아래에 밑줄을 표시.
          if (isSelected)
            Container(
              width: messageTabBtnLineWidth,
              height: messageTabBtnLineHeight,
              color: BLACK_COLOR,
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
        return AdminMessageListScreen(
            timeFrame: 30); // '쪽지 목록' 화면을 반환. (30일 시간 timeFrame 쪽지 데이터)
      default:
        return Container(); // 기본적으로 빈 컨테이너를 반환.
    }
  }
}
// ------ 관리자용 쪽지 관리 화면 내 '쪽지 작성', '쪽지 목록' 탭 선택해서 해당 내용을 보여주는 UI 관련 AdminMessageScreenTabs 클래스 내용 끝

// ------ 관리자용 쪽지 관리 화면 내 '쪽지 작성' 탭 관련 내용을 구현하는 AdminMessageCreateFormScreen 클래스 내용 시작
class AdminMessageCreateFormScreen extends ConsumerStatefulWidget {
  @override
  _AdminMessageCreateFormScreenState createState() =>
      _AdminMessageCreateFormScreenState();
}

class _AdminMessageCreateFormScreenState
    extends ConsumerState<AdminMessageCreateFormScreen> {
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
      ref.invalidate(orderNumbersProvider); // 발주목록 초기화
      ref.invalidate(receiversProvider); // 수신자 목록 초기화
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

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정
    final double sendingBtnWidth = screenSize.width * (130 / referenceWidth);
    final double sendingBtnHeight = screenSize.height * (50 / referenceHeight);
    final double sendingBtnX = screenSize.width * (12 / referenceWidth);
    final double sendingBtnY = screenSize.height * (10 / referenceHeight);
    final double sendingBtnFontSize =
        screenSize.height * (16 / referenceHeight);
    final double paddingX = screenSize.width * (16 / referenceWidth);
    final double paddingY = screenSize.height * (16 / referenceHeight);

    final double ordererDataTitleTextSize =
        screenSize.height * (14 / referenceHeight);
    final double ordererDataTextSize =
        screenSize.height * (12 / referenceHeight);
    final double RecipientDataTextSize =
        screenSize.height * (12 / referenceHeight);
    final double OrderNumberDataTextSize =
        screenSize.height * (12 / referenceHeight);
    final double ContentDataTextSize =
        screenSize.height * (12 / referenceHeight);
    final double RefundDataTextSize =
        screenSize.height * (12 / referenceHeight);
    final double messageContentDataTextSize =
        screenSize.height * (12 / referenceHeight);

    // 컨텐츠 사이의 간격 수치
    final double interval1Y = screenSize.height * (15 / referenceHeight);
    final double interval2Y = screenSize.height * (10 / referenceHeight);
    final double interval3Y = screenSize.height * (60 / referenceHeight);
    final double interval1X = screenSize.width * (25 / referenceWidth);
    final double interval2X = screenSize.width * (10 / referenceWidth);
    final double interval3X = screenSize.width * (12 / referenceWidth);
    final double interval4X = screenSize.width * (39 / referenceWidth);

    // 쪽지 작성 부분이 비어있는 경우의 알림 부분 수치
    final double messageEmptyTextWidth =
        screenSize.width * (200 / referenceWidth); // 가로 비율
    final double messageEmptyTextHeight =
        screenSize.height * (22 / referenceHeight); // 세로 비율
    final double messageEmptyTextX =
        screenSize.width * (45 / referenceWidth); // 가로 비율
    final double messageEmptyTextY =
        screenSize.height * (300 / referenceHeight); // 세로 비율
    final double messageEmptyTextFontSize =
        screenSize.height * (16 / referenceHeight);

    // 만약 현재 사용자가 없다면 로딩 스피너를 표시.
    if (currentUser == null) {
      // return Center(child: CircularProgressIndicator());
      // 쪽지 작성 부분이 비어있을 때 화면에 보여줄 텍스트 위젯을 반환.
      return Container(
        width: messageEmptyTextWidth,
        height: messageEmptyTextHeight,
        margin: EdgeInsets.only(top: messageEmptyTextY),
        // 텍스트를 중앙에 위치하도록 설정함.
        alignment: Alignment.center,
        child: Text(
          '발주 완료한 고객이 없습니다.',
          style: TextStyle(
            fontSize: messageEmptyTextFontSize,
            fontFamily: 'NanumGothic',
            fontWeight: FontWeight.bold,
            color: BLACK_COLOR,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingY, horizontal: paddingX),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 발신자 정보를 표시하는 행.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '발신자:',
                style: TextStyle(
                  fontSize: ordererDataTitleTextSize,
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.normal,
                  color: BLACK_COLOR,
                ),
              ),
              SizedBox(width: interval1X),
              // 발신자 이메일을 표시.
              Expanded(
                child: Text(
                  '${currentUser.email}',
                  style: TextStyle(
                    fontSize: ordererDataTextSize,
                    fontFamily: 'NanumGothic',
                    fontWeight: FontWeight.normal,
                    color: BLACK_COLOR,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: interval1Y),
          // 수신자를 선택하는 드롭다운 메뉴를 포함한 행.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '수신자:',
                style: TextStyle(
                  fontSize: ordererDataTitleTextSize,
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.normal,
                  color: BLACK_COLOR,
                ),
              ),
              SizedBox(width: interval1X),
              // 수신자 선택 드롭다운을 위한 입력 장식.
              Expanded(
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: interval2X),
                  ),
                  child: receivers.when(
                    // 수신자 목록이 성공적으로 로드된 경우 드롭다운을 표시.
                    data: (receiversList) => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text(
                          '수신자 선택',
                          style: TextStyle(
                            fontSize: RecipientDataTextSize,
                            fontFamily: 'NanumGothic',
                          ),
                        ),
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
                            child: Text(
                              receiver.email,
                              style: TextStyle(
                                fontSize: RecipientDataTextSize,
                                fontFamily: 'NanumGothic',
                                fontWeight: FontWeight.normal,
                                color: BLACK_COLOR,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // 데이터가 로딩 중인 경우
                    loading: () => buildCommonLoadingIndicator(),
                    // 에러가 발생한 경우
                    error: (e, stack) =>
                        const Center(child: Text('에러가 발생했으니, 앱을 재실행해주세요.')),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: interval1Y),
          // 발주번호를 선택하는 드롭다운 메뉴를 포함한 행.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '발주번호:',
                style: TextStyle(
                  fontSize: ordererDataTitleTextSize,
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.normal,
                  color: BLACK_COLOR,
                ),
              ),
              SizedBox(width: interval3X),
              // 발주번호 선택 드롭다운을 위한 입력 장식.
              Expanded(
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: interval2X),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: Text(
                        '발주번호 선택',
                        style: TextStyle(
                          fontSize: OrderNumberDataTextSize,
                          fontFamily: 'NanumGothic',
                        ),
                      ),
                      value: selectedOrderNumber,
                      // 수신자가 선택되지 않은 경우 드롭다운을 비활성화.
                      onChanged: selectedReceiver == null
                          ? null
                          : (value) {
                              setState(() {
                                selectedOrderNumber = value;
                              });
                            },
                      // 수신자가 선택된 경우 발주번호 목록을 드롭다운 항목으로 변환.
                      items: selectedReceiver == null
                          ? []
                          : orderNumbers.when(
                              data: (orderNumbersList) =>
                                  orderNumbersList.map((orderNumber) {
                                return DropdownMenuItem<String>(
                                  value: orderNumber,
                                  child: Text(
                                    orderNumber,
                                    style: TextStyle(
                                      fontSize: OrderNumberDataTextSize,
                                      fontFamily: 'NanumGothic',
                                      fontWeight: FontWeight.normal,
                                      color: BLACK_COLOR,
                                    ),
                                  ),
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
            buildCommonLoadingIndicator(),
          SizedBox(height: interval1Y),
          // 메시지 내용을 선택하는 드롭다운 메뉴를 포함한 행.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '내용:',
                style: TextStyle(
                  fontSize: ordererDataTitleTextSize,
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.normal,
                  color: BLACK_COLOR,
                ),
              ),
              SizedBox(width: interval4X),
              // 메시지 내용 선택 드롭다운을 위한 입력 장식.
              Expanded(
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: interval2X),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: Text(
                        '내용 선택',
                        style: TextStyle(
                          fontSize: ContentDataTextSize,
                          fontFamily: 'NanumGothic',
                        ),
                      ),
                      value: messageContent,
                      style: TextStyle(
                        fontSize: ContentDataTextSize,
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.normal,
                        color: BLACK_COLOR,
                      ),
                      // 메시지 내용 선택 시 상태를 업데이트.
                      onChanged: selectedOrderNumber == null
                          ? null
                          : (value) {
                              setState(() {
                                // 선택된 메시지 내용에 따라 텍스트를 설정.
                                if (value == '결제 완료 메세지') {
                                  messageContentText = '해당 발주 건은 결제 완료 되었습니다.';
                                } else if (value == '배송 중 메세지') {
                                  messageContentText = '해당 발주 건은 배송이 진행되었습니다.';
                                } else if (value == '환불 메세지') {
                                  messageContentText = '해당 발주 건은 환불 처리 되었습니다.';
                                } else if (value == '직접입력') {
                                  messageContentText = ''; // 직접입력 시 초기화
                                } else {
                                  messageContentText = '';
                                }
                                // 상태를 변경해 UI 업데이트를 유도.
                                ref
                                    .read(adminMessageContentProvider.notifier)
                                    .state = value;
                                ref
                                    .read(adminCustomMessageProvider.notifier)
                                    .state = messageContentText;
                              });
                            },
                      // 메시지 내용을 드롭다운 항목으로 변환.
                      items: [
                        DropdownMenuItem<String>(
                          value: '결제 완료 메세지',
                          child: Text(
                            '결제 완료 메세지',
                            style: TextStyle(
                              fontSize: ContentDataTextSize,
                              fontFamily: 'NanumGothic',
                              fontWeight: FontWeight.normal,
                              color: BLACK_COLOR,
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: '배송 중 메세지',
                          child: Text(
                            '배송 중 메세지',
                            style: TextStyle(
                              fontSize: ContentDataTextSize,
                              fontFamily: 'NanumGothic',
                              fontWeight: FontWeight.normal,
                              color: BLACK_COLOR,
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: '환불 메세지',
                          child: Text(
                            '환불 메세지',
                            style: TextStyle(
                              fontSize: ContentDataTextSize,
                              fontFamily: 'NanumGothic',
                              fontWeight: FontWeight.normal,
                              color: BLACK_COLOR,
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: '직접입력',
                          child: Text(
                            '직접입력',
                            style: TextStyle(
                              fontSize: ContentDataTextSize,
                              fontFamily: 'NanumGothic',
                              fontWeight: FontWeight.normal,
                              color: BLACK_COLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: interval1Y),
          // 메시지 내용에 따라 다르게 처리.
          if (messageContent == '결제 완료 메세지' || messageContent == '배송 중 메세지')
            AbsorbPointer(
              absorbing: true, // 입력 비활성화
              child: TextFormField(
                key: ValueKey(messageContentText),
                // TextFormField를 강제로 새로고침하는 키
                initialValue: messageContentText,
                style: TextStyle(fontSize: messageContentDataTextSize),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: interval2X),
                ),
              ),
            )
          else if (messageContent == '직접입력')
            // 직접 입력 시 입력창을 활성화.
            TextFormField(
              initialValue: '',
              maxLength: 200,
              maxLines: null,
              // 입력 시 자동으로 줄바꿈
              style: TextStyle(
                fontSize: ContentDataTextSize,
                fontFamily: 'NanumGothic',
              ),
              decoration: InputDecoration(
                hintText: '200자 이내로 작성 가능합니다.',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: GRAY51_COLOR, width: 1.0),
                  // 테두리 색상 및 두께 변경
                  borderRadius:
                      BorderRadius.circular(6), // 모서리 각도를 제목 라벨과 동일하게 설정
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: GRAY51_COLOR, width: 1.0),
                  // 비활성 상태의 테두리 설정
                  borderRadius:
                      BorderRadius.circular(6), // 모서리 각도를 제목 라벨과 동일하게 설정
                ),
                focusedBorder: OutlineInputBorder(
                  // 활성화 상태의 테두리 설정
                  borderSide: BorderSide(
                    color: ORANGE56_COLOR,
                    width: 1.0,
                  ), // 활성화 상태의 테두리 색상을 BUTTON_COLOR로 설정
                  borderRadius:
                      BorderRadius.circular(6), // 모서리 각도를 제목 라벨과 동일하게 설정
                ),
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
                  return await repository.fetchProductOptions(
                      selectedReceiver!, selectedOrderNumber!);
                },
              ).value,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildCommonLoadingIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text(
                    '해당 상품이 없습니다.',
                    style: TextStyle(
                      fontSize: RefundDataTextSize,
                      fontFamily: 'NanumGothic',
                      fontWeight: FontWeight.normal,
                      color: BLACK_COLOR,
                    ),
                  );
                }

                // 중복된 value가 없도록 확인하는 로직 추가
                final items =
                    snapshot.data!.toSet().toList().map((productOption) {
                  return DropdownMenuItem<String>(
                    value: productOption,
                    child: Text(
                      productOption,
                      style: TextStyle(
                        fontSize: RefundDataTextSize,
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.normal,
                        color: BLACK_COLOR,
                      ),
                    ),
                  );
                }).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "환불 신청 상품:" 라벨을 상단에 배치
                    Text(
                      '환불 신청 상품:',
                      style: TextStyle(
                        fontSize: ordererDataTitleTextSize,
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.normal,
                        color: BLACK_COLOR,
                      ),
                    ),
                    SizedBox(height: interval2Y), // 라벨과 드롭다운 메뉴 사이에 간격 추가
                    // 드롭다운 메뉴를 아래에 배치
                    _buildRefundProdSelectDropdown(
                      value: selectedProduct,
                      items: items,
                      onChanged: (value) {
                        setState(() {
                          selectedProduct = value;
                          selectedSeparatorKey = value?.split(' ')[0];
                          messageContentText = '해당 발주 건은 환불 처리 되었습니다.';
                          ref.read(adminCustomMessageProvider.notifier).state =
                              messageContentText;
                        });
                      },
                    ),
                    SizedBox(height: interval1Y),
                    AbsorbPointer(
                      absorbing: true, // 입력 비활성화
                      child: TextFormField(
                        key: ValueKey(messageContentText),
                        initialValue: messageContentText,
                        style: TextStyle(
                          fontSize: RefundDataTextSize,
                          fontFamily: 'NanumGothic',
                          fontWeight: FontWeight.normal,
                          color: BLACK_COLOR,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: interval2X),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          SizedBox(height: interval3Y),
          if (messageContent != null && messageContent!.isNotEmpty)
            Center(
              child: Container(
                width: sendingBtnWidth,
                height: sendingBtnHeight,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedReceiver != null &&
                        selectedOrderNumber != null) {
                      final customMessage =
                          ref.read(adminCustomMessageProvider);
                      try {
                        // 메시지 발송 로직
                        await ref.read(sendMessageProvider({
                          'sender': currentUser.email!,
                          'recipient': selectedReceiver!,
                          'order_number': selectedOrderNumber!,
                          'contents': customMessage!,
                          'selected_separator_key': selectedSeparatorKey,
                        }).future);

                        // 발송 완료 후 상태 초기화
                        setState(() {
                          // selectedReceiver = null;
                          selectedOrderNumber = null;
                          selectedProduct = null;
                          messageContentText = '';
                          ref.read(adminMessageContentProvider.notifier).state =
                              null;
                          ref.read(adminCustomMessageProvider.notifier).state =
                              null;
                        });

                        // 발송 성공 메시지 표시
                        showCustomSnackBar(context, '쪽지 발송에 성공했습니다.');
                      } catch (e) {
                        // 발송 실패 시 에러 메시지 표시
                        showCustomSnackBar(context, '쪽지 발송에 실패했습니다: $e');
                      }
                    } else {
                      // 필수 항목이 선택되지 않은 경우 경고 메시지 표시
                      showCustomSnackBar(context, '수신자와 발주번호를 선택해주세요.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ORANGE56_COLOR, // 텍스트 색상 설정
                    backgroundColor: Theme.of(context)
                        .scaffoldBackgroundColor, // 버튼 배경색을 앱 배경색으로 설정
                    side: BorderSide(color: ORANGE56_COLOR), // 버튼 테두리 색상 설정
                    padding: EdgeInsets.symmetric(
                        vertical: sendingBtnY,
                        horizontal: sendingBtnX), // 버튼 패딩
                  ),
                  child: Text(
                    '발송하기',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'NanumGothic',
                      fontSize: sendingBtnFontSize,
                      color: ORANGE56_COLOR,
                    ),
                  ),
                ),
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
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 세로 852
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정
    final double selectDataTextSize =
        screenSize.height * (12 / referenceHeight);

    // 컨텐츠 사이의 간격 수치
    final double interval1Y = screenSize.height * (10 / referenceHeight);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // 행의 수직 정렬을 중앙에 맞춤.
      children: [
        Expanded(
          // 드롭다운 메뉴가 가능한 공간을 모두 차지하도록 확장함.
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0), // 테두리 모서리를 둥글게 만듦.
              ),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: interval1Y), // 입력 필드 내부의 좌우 여백을 설정함.
            ),
            child: DropdownButtonHideUnderline(
              // 드롭다운 메뉴에서 기본 밑줄을 숨김.
              child: DropdownButton<String>(
                hint: Text(
                  '선택',
                  style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: selectDataTextSize,
                  ),
                ), // 드롭다운 메뉴에서 아무것도 선택되지 않았을 때 표시되는 힌트 텍스트임.
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
  final int timeFrame; // 쪽지 발송 시간

  // 생성자에서 timeFrame을 필수 인자로 받도록 설정
  AdminMessageListScreen({required this.timeFrame});

  @override
  _AdminMessageListScreenState createState() => _AdminMessageListScreenState();
}

class _AdminMessageListScreenState
    extends ConsumerState<AdminMessageListScreen> {

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
      ref.invalidate(selectedReceiverProvider);
      ref.invalidate(receiversProvider);
      ref.invalidate(adminMessageItemsListNotifierProvider);
    });
  }


// message_delete_time 필드의 데이터 타입이 Timestamp로 되어 있어, 이를 DateTime으로 변환한 후, 문자열로 포맷팅하는 함수
  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate(); // Timestamp를 DateTime으로 변환하는 코드
      return DateFormat('[yyyy년 MM월 dd일 HH시 mm분] ')
          .format(dateTime); // 변환된 DateTime을 포맷팅하여 문자열로 반환하는 코드
    } else {
      return ''; // timestamp가 Timestamp 타입이 아닌 경우 빈 문자열을 반환하는 코드
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedReceiver =
        ref.watch(selectedReceiverProvider); // 선택된 수신자 이메일을 구독하는 코드
    final receivers =
        ref.watch(receiversProvider); // 드롭다운 메뉴에 사용할 수신자 이메일 목록을 가져옴
    final messages = ref.watch(
        adminMessageItemsListNotifierProvider); // 선택된 수신자의 쪽지 목록을 구독하는 코드

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
        screenSize.width * (230 / referenceWidth);
    final double messageRecipientDropdownBtnHeight =
        screenSize.height * (50 / referenceHeight);

    final double messageDeleteTimeDataTextSize =
        screenSize.height * (13 / referenceHeight);
    final double messageStatusIconTextSize =
        screenSize.height * (13 / referenceHeight);

    final double messageRecipientSelectDataTextSize1 =
        screenSize.height * (12 / referenceHeight);
    final double messageRecipientSelectDataTextSize2 =
        screenSize.height * (12 / referenceHeight);
    final double messageDataTextSize1 =
        screenSize.height * (14 / referenceHeight);
    final double messageDataTextSize2 =
        screenSize.height * (16 / referenceHeight);

    // 삭제 버튼 수치
    final double deleteBtnHeight = screenSize.height * (30 / referenceHeight);
    final double deleteBtnWidth = screenSize.width * (60 / referenceWidth);
    final double intervalX = screenSize.width * (8 / referenceWidth);
    final double deleteBtnPaddingY = screenSize.height * (2 / referenceHeight);
    final double deleteBtnPaddingX = screenSize.width * (4 / referenceWidth);
    final double deleteBtnFontSize = screenSize.height * (12 / referenceHeight);

    // 컨텐츠 사이의 간격 수치
    final double interval1Y = screenSize.height * (20 / referenceHeight);
    final double interval2Y = screenSize.height * (4 / referenceHeight);
    final double interval3Y = screenSize.height * (60 / referenceHeight);
    final double interval1X = screenSize.width * (4 / referenceWidth);
    final double interval2X = screenSize.width * (10 / referenceWidth);
    final double interval3X = screenSize.width * (12 / referenceWidth);
    final double interval4X = screenSize.width * (39 / referenceWidth);

    // 쪽지 목록 부분이 비어있는 경우의 알림 부분 수치
    final double messageEmptyTextWidth =
        screenSize.width * (393 / referenceWidth); // 가로 비율
    final double messageEmptyTextHeight =
        screenSize.height * (22 / referenceHeight); // 세로 비율
    final double messageEmptyTextX =
        screenSize.width * (70 / referenceWidth); // 가로 비율
    final double messageEmptyTextY =
        screenSize.height * (200 / referenceHeight); // 세로 비율
    final double messageEmptyTextFontSize =
        screenSize.height * (16 / referenceHeight);

    return Column(
      children: [
        // 드롭다운 버튼을 중앙에 위치시키기 위해 Center 위젯을 추가
        Center(
          child: Container(
            width: messageRecipientDropdownBtnWidth,
            height: messageRecipientDropdownBtnHeight,
            decoration: BoxDecoration(
              // color: GRAY96_COLOR,
              color: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
              border: Border.all(color: GRAY83_COLOR, width: 1), // 윤곽선
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            // 텍스트 정렬
            child: DropdownButtonHideUnderline(
              child: receivers.when(
                data: (receiversList) {
                  final uniqueReceiversList =
                      receiversList.toSet().toList(); // 드롭다운 메뉴 이메일값들
                  final validSelectedreceivers = (selectedReceiver != null &&
                          uniqueReceiversList.contains(selectedReceiver))
                      ? selectedReceiver
                      : null; // 드롭다운 메뉴에서 선택된 이메일 값이 유효하지 않을 경우 null 처리

                  // 수신자 필터링을 위한 드롭다운 메뉴 버튼
                  return DropdownButton<String>(
                    hint: Center(
                      child: Text(
                        '쪽지 수신자 선택',
                        style: TextStyle(
                          fontFamily: 'NanumGothic',
                          fontSize: messageRecipientSelectDataTextSize1,
                        ),
                      ),
                    ), // 드롭다운 메뉴에서 선택할 수신자 선택 힌트 텍스트
                    value: selectedReceiver, // 현재 선택된 수신자 이메일 값 설정
                    onChanged: (value) {
                      // 선택한 수신자 이메일을 상태로 업데이트
                      ref.read(selectedReceiverProvider.notifier).state = value;
                    },
                    items: uniqueReceiversList.map((receiver) {
                      return DropdownMenuItem<String>(
                        value: receiver.email, // 수신자 이메일 값 설정
                        child: Text(
                          receiver.email,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'NanumGothic',
                            fontSize: messageRecipientSelectDataTextSize2,
                            color: BLACK_COLOR,
                          ),
                        ), // 드롭다운 메뉴에 표시될 이메일 텍스트 설정
                      );
                    }).toList(),
                  );
                },
                // 데이터가 로딩 중인 경우
                loading: () => buildCommonLoadingIndicator(),
                // 에러가 발생한 경우
                error: (e, stack) =>
                    const Center(child: Text('에러가 발생했으니, 앱을 재실행해주세요.')),
              ),
            ),
          ),
        ),
        SizedBox(height: interval1Y), // 드롭다운 메뉴와 메시지 목록 사이에 간격을 둠
        // 선택된 수신자의 쪽지 목록을 표시하는 부분
        if (messages.isEmpty)
          // 쪽지 목록이 비어있을 경우 "현재 쪽지 목록 내 쪽지가 없습니다." 메시지 표시
          Container(
            width: messageEmptyTextWidth,
            height: messageEmptyTextHeight,
            margin: EdgeInsets.only(top: messageEmptyTextY),
            // 텍스트를 중앙에 위치하도록 설정함.
            alignment: Alignment.center,
            child: Text(
              '현재 쪽지 목록 내 쪽지가 없습니다.',
              style: TextStyle(
                fontSize: messageEmptyTextFontSize,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
                color: BLACK_COLOR,
              ),
            ),
          )
        else
          // 쪽지 목록을 열의 형태로 표시.
          Column(
            children: messages.asMap().entries.map((entry) {
              final index = entry.key;
              final message = entry.value;
              // private_email_closed_button 필드값에 따라 '[O]' 또는 '[X]' 표시
              String statusIcon = message['private_email_closed_button'] == true
                  ? '[삭제 O]  '
                  : '[삭제 X]  '; // private_email_closed_button 값에 따라 상태 아이콘 설정
              String deleteTime = '';

              // 'message_delete_time' 필드값이 존재 유무에 따라 해당 필드값을 노출
              if (message.containsKey('message_delete_time')) {
                deleteTime = formatTimestamp(message['message_delete_time']);
              }

              // // 클립 위젯을 사용하여 모서리를 둥글게 설정함
              // return ClipRRect(
              //   borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
              //   child: Container(
              return Container(
                padding: EdgeInsets.zero, // 패딩을 없앰
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 지정함
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // 왼쪽 정렬
                              children: [
                                Text(
                                  statusIcon, // 쪽지 상태 아이콘 표시
                                  style: TextStyle(
                                    fontSize: messageStatusIconTextSize,
                                    // 텍스트 크기 설정
                                    fontWeight: FontWeight.bold,
                                    // 텍스트 굵기 설정
                                    fontFamily: 'NanumGothic',
                                    color:
                                        message['private_email_closed_button'] ==
                                                true
                                            ? RED46_COLOR
                                            : BLACK_COLOR, // 상태에 따라 텍스트 색상 변경
                                  ),
                                ),
                                if (deleteTime
                                    .isNotEmpty) // deleteTime이 존재하는 경우
                                  Padding(
                                    padding: EdgeInsets.only(left: interval1X),
                                    // 상태 아이콘과 간격 추가
                                    child: Text(
                                      deleteTime, // 삭제 시간을 표시
                                      style: TextStyle(
                                        fontSize: messageDeleteTimeDataTextSize,
                                        // 텍스트 크기 설정
                                        fontWeight: FontWeight.bold,
                                        // 텍스트 굵기 설정
                                        fontFamily: 'NanumGothic',
                                        color: BLACK_COLOR, // 텍스트 색상 설정
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            // 삭제 유무 및 삭제시간 데이터 부분과 삭제 버튼 사이의 공간을 차지하여 삭제 버튼이 오른쪽 끝에 위치하도록 함
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              width: deleteBtnWidth,
                              height: deleteBtnHeight,
                              margin: EdgeInsets.only(right: intervalX),
                              // 오른쪽 여백 설정
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
                                  // 리뷰 삭제 버튼 클릭 시 확인 다이얼로그를 표시함
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
                                        color: BLACK_COLOR,
                                        // 아니요 버튼 텍스트 색상 설정
                                        fontWeight:
                                            FontWeight.bold, // 아니요 버튼 텍스트 굵기 설정
                                      ),
                                      yesTextStyle: TextStyle(
                                        color: RED46_COLOR, // 예 버튼 텍스트 색상 설정
                                        fontWeight:
                                            FontWeight.bold, // 예 버튼 텍스트 굵기 설정
                                      ),
                                      onYesPressed: () async {
                                        try {
                                          final messageId = message['id'];
                                          // 쪽지 삭제 처리
                                          await ref
                                              .read(
                                                  adminMessageItemsListNotifierProvider
                                                      .notifier)
                                              .deleteMessage(
                                                  messageId, widget.timeFrame);
                                          Navigator.of(context)
                                              .pop(); // 다이얼로그 닫기
                                          showCustomSnackBar(
                                              context, '쪽지가 삭제되었습니다.');
                                        } catch (e) {
                                          showCustomSnackBar(context,
                                              '쪽지 삭제 중 오류가 발생했습니다: $e');
                                        }
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  '삭제', // 버튼 텍스트 설정
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
                          message['order_number']?.toString().isNotEmpty == true
                              ? message['order_number']
                              : '',
                          bold: true,
                          fontSize: messageDataTextSize1, // 쪽지 내용 텍스트 글꼴 크기 설정함
                          color: GRAY62_COLOR,
                        ),
                        // 메시지 내용 표시 부분
                        SizedBox(height: interval2Y),
                        _buildMessageInfoRow(
                          context,
                          '내용: ',
                          message['contents']?.toString().isNotEmpty == true
                              ? message['contents']
                              : '',
                          bold: true,
                          fontSize: messageDataTextSize1,
                        ),
                        SizedBox(height: interval2Y),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
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
// ------ 관리자용 쪽지 관리 화면 내 모든 계정의 쪽지 목록 불러와서 UI 구현하는 AdminMessageListScreen 클래스 내용 끝
