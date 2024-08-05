import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common/const/colors.dart';
import '../../../common/layout/common_body_parts_layout.dart';
import '../provider/orderlist_all_provider.dart';
import '../provider/orderlist_state_provider.dart';

class ManagerOrderListContents extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrdersAsyncValue = ref.watch(allOrdersProvider);
    final selectedUserId = ref.watch(selectedUserProvider);

    return allOrdersAsyncValue.when(
      data: (allOrders) {
        final userIds = allOrders.map((order) => order['userId']).whereType<String>().toSet().toList();

        if (userIds.isEmpty) {
          return Center(child: Text('해당 계정이 없습니다.'));
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              hint: Text('사용자 선택'),
              value: selectedUserId.isNotEmpty ? selectedUserId : null,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  ref.read(selectedUserProvider.notifier).state = newValue;
                }
              },
              items: userIds.map<DropdownMenuItem<String>>((userId) {
                return DropdownMenuItem<String>(
                  value: userId,
                  child: FutureBuilder<String>(
                    future: fetchUserEmail(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      } else if (snapshot.hasError) {
                        return Text('Error');
                      } else {
                        return Text(snapshot.data ?? 'Unknown');
                      }
                    },
                  ),
                );
              }).toList(),
            ),
            if (selectedUserId.isNotEmpty) ...[
              Consumer(
                builder: (context, ref, child) {
                  final userOrdersAsyncValue = ref.watch(userOrdersProvider(selectedUserId));
                  return userOrdersAsyncValue.when(
                    data: (userOrders) {
                      if (userOrders.isEmpty) {
                        return Center(child: Text('해당 사용자의 발주 내역이 없습니다.'));
                      }

                      return Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: userOrders.map((order) {
                              print('Order data: $order');

                              final numberInfo = order['numberInfo'] ?? {};
                              final amountInfo = order['amountInfo'] ?? {};
                              final ordererInfo = order['ordererInfo'] ?? {};
                              final productInfoList = order['productInfo'] as List<dynamic>? ?? [];

                              // 숫자 형식을 위한 formatter
                              final formatter = NumberFormat('#,###');

                              return CommonCardView(
                                backgroundColor: BEIGE_COLOR, // 배경색을 BEIGE_COLOR로 설정
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('발주번호: ${numberInfo['order_number'] ?? '없음'}'),
                                    Text('발주자 이름: ${ordererInfo['name'] ?? '없음'}'),
                                    Text('발주자 이메일: ${ordererInfo['email'] ?? '없음'}'),
                                    Text('발주자 연락처: ${ordererInfo['phone_number'] ?? '없음'}'),
                                    Divider(color: Colors.grey), // 구분선 추가
                                    Text('총 결제금액: ${amountInfo['total_payment_price'] != null ? formatter.format(amountInfo['total_payment_price']) + '원' : '없음'}'),
                                    Divider(color: Colors.grey), // 구분선 추가
                                    ...productInfoList.map((product) {
                                      final productMap = product as Map<String, dynamic>;
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('상품 번호: ${productMap['productNumber'] ?? '없음'}'),
                                          Text('상품 가격: ${productMap['discountPrice'] != null ? formatter.format(productMap['discountPrice']) + '원' : '없음'}'),
                                          Text('상품 수량: ${productMap['selectedCount'] ?? '없음'} 개'),
                                          Text('상품 색상: ${productMap['selectedColorText'] ?? '없음'}'),
                                          Text('상품 사이즈: ${productMap['selectedSize'] ?? '없음'}'),
                                          Divider(color: Colors.grey), // 각 상품 사이에 구분선 추가
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
                    error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
                  );
                },
              ),
            ]
          ],
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
    );
  }

  Future<String> fetchUserEmail(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('order_list')
        .doc(userId)
        .collection('orders')
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('No orders found for user $userId');
    }

    final orderDocRef = querySnapshot.docs.first.reference;

    final ordererInfoDoc = await orderDocRef.collection('orderer_info').doc('info').get();

    if (!ordererInfoDoc.exists) {
      throw Exception('Orderer info not found for user $userId');
    }

    return ordererInfoDoc.data()?['email'] ?? 'Unknown';
  }
}
