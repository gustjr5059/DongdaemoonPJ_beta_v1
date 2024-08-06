import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepository {
  final FirebaseFirestore firestore;

  MessageRepository({required this.firestore});

  Future<List<String>> fetchReceivers() async {
    final querySnapshot = await firestore.collection('users').get();
    return querySnapshot.docs
        .map((doc) => doc.data()['email'] as String)
        .where((email) => email != 'capjs06@gmail.com')
        .toList();
  }

  Future<List<String>> fetchOrderNumbers(String receiver) async {
    try {
      // Firestore에서 사용자의 이메일을 기준으로 검색
      final querySnapshot = await firestore
          .collection('order_list')
          .doc(receiver)
          .collection('orders')
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No orders found for email: $receiver');
        return ['없음'];
      }

      print('Found ${querySnapshot.docs.length} orders for email: $receiver');

      // 각 order 문서의 number_info 하위 컬렉션에서 order_number 필드 가져오기
      List<String> orderNumbers = [];
      for (var doc in querySnapshot.docs) {
        print('Checking order: ${doc.id}');
        final numberInfoDoc = await doc.reference.collection('number_info').doc('info').get();
        if (numberInfoDoc.exists) {
          final orderNumber = numberInfoDoc.data()?['order_number'];
          if (orderNumber != null) {
            orderNumbers.add(orderNumber as String);
            print('Found order number: $orderNumber for order: ${doc.id}');
          } else {
            print('order_number field is missing in number_info for order: ${doc.id}');
          }
        } else {
          print('No number_info found for order: ${doc.id}');
        }
      }

      return orderNumbers.isEmpty ? ['없음'] : orderNumbers;
    } catch (e) {
      print('Error fetching order numbers: $e');
      return ['없음'];
    }
  }
}
