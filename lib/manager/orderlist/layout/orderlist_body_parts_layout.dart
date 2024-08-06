import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common/const/colors.dart';
import '../../../common/layout/common_body_parts_layout.dart';
import '../provider/orderlist_all_provider.dart';
import '../provider/orderlist_state_provider.dart';


// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 및 버튼 클릭 시, 나오는 데이터 UI 내용을 구현하는 ManagerOrderListContents 클래스 시작
class ManagerOrderListContents extends ConsumerWidget {
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
              hint: Text('사용자 선택'),
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
                        return Center(child: Text('해당 사용자의 발주 내역이 없습니다.'));
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
                                          Text('상품 번호: ${productMap['productNumber'] ?? '없음'}'),
                                          // 제품 번호를 텍스트로 표시
                                          Text('상품 가격: ${productMap['discountPrice'] != null ? formatter.format(productMap['discountPrice']) + '원' : '없음'}'),
                                          // 제품 가격을 텍스트로 표시
                                          Text('상품 수량: ${productMap['selectedCount'] ?? '없음'} 개'),
                                          // 제품 수량을 텍스트로 표시
                                          Text('상품 색상: ${productMap['selectedColorText'] ?? '없음'}'),
                                          // 제품 색상을 텍스트로 표시
                                          Text('상품 사이즈: ${productMap['selectedSize'] ?? '없음'}'),
                                          // 제품 사이즈를 텍스트로 표시
                                          Divider(color: Colors.grey),
                                          // 구분선
                                        ],
                                      );
                                    }).toList(),
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
// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 및 버튼 클릭 시, 나오는 데이터 UI 내용을 구현하는 ManagerOrderListContents 클래스 끝
