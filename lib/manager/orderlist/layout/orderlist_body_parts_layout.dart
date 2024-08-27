import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common/const/colors.dart';
import '../../../common/layout/common_body_parts_layout.dart';
import '../provider/orderlist_all_provider.dart';
import '../provider/orderlist_state_provider.dart';


// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 및 버튼 클릭 시, 나오는 데이터 UI 내용을 구현하는 AdminOrderListContents 클래스 시작
class AdminOrderListContents extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUserEmailsAsyncValue = ref.watch(allUserEmailsProvider);
    // 모든 사용자의 이메일 데이터를 제공하는 Provider를 구독
    final selectedUserEmail = ref.watch(selectedUserEmailProvider);
    // 선택된 사용자 이메일 데이터를 제공하는 Provider를 구독

    return allUserEmailsAsyncValue.when(
      data: (userEmails) {
        // 이메일 데이터를 성공적으로 가져온 경우
        if (userEmails.isEmpty) {
          return Center(child: Text('해당 계정이 없습니다.'));
          // 이메일 데이터가 비어있을 경우 메시지를 표시
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              hint: Text('발주자 선택'),
              // 드롭다운 버튼에 힌트 텍스트 설정
              value: selectedUserEmail.isNotEmpty ? selectedUserEmail : null,
              // 선택된 사용자 이메일이 비어있지 않으면 해당 이메일을 드롭다운 값으로 설정
              onChanged: (String? newValue) {
                // 드롭다운 값이 변경되었을 때 실행되는 콜백
                if (newValue != null) {
                  ref.read(selectedUserEmailProvider.notifier).state = newValue;
                  // 선택된 사용자 이메일 상태를 변경
                }
              },
              items: userEmails.map<DropdownMenuItem<String>>((userEmail) {
                // 이메일 데이터 리스트를 드롭다운 메뉴 아이템 리스트로 변환
                return DropdownMenuItem<String>(
                  value: userEmail,
                  child: Text(userEmail),
                  // 각 이메일 데이터를 드롭다운 메뉴 아이템으로 설정
                );
              }).toList(),
            ),
            if (selectedUserEmail.isNotEmpty) ...[
              // 선택된 이메일이 있을 경우
              Consumer(
                builder: (context, ref, child) {
                  final userOrdersAsyncValue = ref.watch(userOrdersProvider(selectedUserEmail));
                  // 선택된 사용자의 발주 데이터를 제공하는 Provider를 구독
                  return userOrdersAsyncValue.when(
                    data: (userOrders) {
                      // 발주 데이터를 성공적으로 가져온 경우
                      if (userOrders.isEmpty) {
                        return Center(child: Text('해당 고객의 발주 내역이 없습니다.'));
                        // 발주 데이터가 비어있을 경우 메시지를 표시
                      }

                      return Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: userOrders.map((order) {
                              // 각 발주 데이터를 UI로 변환
                              final numberInfo = order['numberInfo'] ?? {};
                              // 발주 번호 정보를 가져옴
                              final amountInfo = order['amountInfo'] ?? {};
                              // 결제 금액 정보를 가져옴
                              final ordererInfo = order['ordererInfo'] ?? {};
                              // 발주자 정보를 가져옴
                              final productInfoList = order['productInfo'] as List<dynamic>? ?? [];
                              // 제품 정보를 리스트로 가져옴

                              final formatter = NumberFormat('#,###');
                              // 숫자 포맷 설정

                              // 발주 상태 저장할 상태 프로바이더 선언
                              // (orderStatusStateProvider를 구독(subscribe)하여 그 상태를 가져오는 역할)
                              final orderStatusProvider = ref.watch(orderStatusStateProvider);

                              return CommonCardView(
                                backgroundColor: BEIGE_COLOR,
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('발주번호: ${numberInfo['order_number'] ?? '없음'}'),
                                    // 발주 번호를 텍스트로 표시
                                    Text('발주자 이름: ${ordererInfo['name'] ?? '없음'}'),
                                    // 발주자 이름을 텍스트로 표시
                                    Text('발주자 이메일: ${ordererInfo['email'] ?? '없음'}'),
                                    // 발주자 이메일을 텍스트로 표시
                                    Text('발주자 연락처: ${ordererInfo['phone_number'] ?? '없음'}'),
                                    // 발주자 연락처를 텍스트로 표시
                                    Divider(color: Colors.grey),
                                    // 구분선
                                    Text('총 결제금액: ${amountInfo['total_payment_price'] != null ? formatter.format(amountInfo['total_payment_price']) + '원' : '없음'}'),
                                    // 총 결제 금액을 텍스트로 표시
                                    Divider(color: Colors.grey),
                                    // 구분선
                                    ...productInfoList.map((product) {
                                      // 각 제품 정보를 UI로 변환
                                      final productMap = product as Map<String, dynamic>;
                                      // 제품 정보를 맵으로 변환
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('상품 번호: ${productMap['product_number'] ?? '없음'}'),
                                          // 제품 번호를 텍스트로 표시
                                          Text('상품 가격: ${productMap['discount_price'] != null ? formatter.format(productMap['discount_price']) + '원' : '없음'}'),
                                          // 제품 가격을 텍스트로 표시
                                          Text('상품 수량: ${productMap['selected_count'] ?? '없음'} 개'),
                                          // 제품 수량을 텍스트로 표시
                                          Text('상품 색상: ${productMap['selected_color_text'] ?? '없음'}'),
                                          // 제품 색상을 텍스트로 표시
                                          Text('상품 사이즈: ${productMap['selected_size'] ?? '없음'}'),
                                          // 제품 사이즈를 텍스트로 표시
                                          Divider(color: Colors.grey),
                                          // 구분선
                                        ],
                                      );
                                    }).toList(),
                                    SizedBox(height: 10),
                                    // 드롭다운 버튼 위에 공간을 주기 위해 10픽셀 높이의 SizedBox 추가
                                    DropdownButton<String>(
                                      value: orderStatusProvider.isEmpty ? '발주신청 완료' : orderStatusProvider,
                                      // orderStatusProvider가 비어 있으면 기본 값으로 '발주신청 완료'를 설정하고, 그렇지 않으면 현재 상태를 설정
                                      onChanged: (String? newStatus) {
                                        // 드롭다운의 값이 변경되었을 때 호출되는 콜백 함수
                                        if (newStatus != null) {
                                          ref.read(orderStatusStateProvider.notifier).state = newStatus;
                                          // 선택된 새로운 상태로 orderStatusStateProvider의 상태를 업데이트
                                        }
                                      },
                                      items: ['발주신청 완료', '배송 준비', '배송 중', '배송 완료', '환불']
                                          .map<DropdownMenuItem<String>>((String status) {
                                        // 드롭다운에 표시될 각 항목을 리스트로 생성
                                        return DropdownMenuItem<String>(
                                          value: status,
                                          child: Text(status),
                                          // 각 항목의 텍스트를 드롭다운 메뉴로 표시
                                        );
                                      }).toList(),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        // 버튼이 눌렸을 때 비동기 작업을 수행
                                        try {
                                          await ref.read(adminOrderlistRepositoryProvider).updateOrderStatus(
                                              selectedUserEmail,
                                              numberInfo['order_number'],
                                              orderStatusProvider);
                                          // 선택된 사용자 이메일과 발주 번호, 새로운 발주 상태를 이용해 발주 상태를 업데이트
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('\'$orderStatusProvider\'로 발주상태가 변경되었습니다.'),
                                              // 발주 상태 변경이 성공적으로 이루어졌음을 사용자에게 알림
                                            ),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('발주상태 변경에 실패했습니다: $e'),
                                              // 발주 상태 변경에 실패했을 때 오류 메시지를 사용자에게 알림
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: BUTTON_COLOR, // 버튼 텍스트 색상
                                        backgroundColor: BACKGROUND_COLOR, // 버튼 배경 색상
                                        side: BorderSide(color: BUTTON_COLOR), // 버튼 테두리 색상
                                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // 버튼 패딩
                                      ),
                                      child: Text('변경', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                      // 버튼에 '변경'이라는 텍스트를 굵은 글씨로 표시
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    loading: () => Center(child: CircularProgressIndicator()),
                    // 발주 데이터를 로딩 중일 때 로딩 인디케이터 표시
                    error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
                    // 발주 데이터를 가져오는 중 에러가 발생했을 때 에러 메시지 표시
                  );
                },
              ),
            ]
          ],
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      // 이메일 데이터를 로딩 중일 때 로딩 인디케이터 표시
      error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
      // 이메일 데이터를 가져오는 중 에러가 발생했을 때 에러 메시지 표시
    );
  }
}
// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 및 버튼 클릭 시, 나오는 데이터 UI 내용을 구현하는 AdminOrderListContents 클래스 끝
