import 'package:cloud_firestore/cloud_firestore.dart';

class OrderlistRepository {
  final FirebaseFirestore firestore;

  OrderlistRepository({required this.firestore});

  // 모든 사용자의 발주 데이터를 가져오는 함수
  Future<List<Map<String, dynamic>>> fetchAllOrdersForAdmin() async {
    try {
      final querySnapshot = await firestore.collectionGroup('orders').get();
      final List<Future<Map<String, dynamic>>> futures = querySnapshot.docs.map((doc) async {
        final data = doc.data();
        final userId = doc.reference.parent.parent?.id ?? '';

        // number_info, orderer_info, amount_info, product_info 가져오기
        final numberInfoDoc = await doc.reference.collection('number_info').doc('info').get();
        final ordererInfoDoc = await doc.reference.collection('orderer_info').doc('info').get();
        final amountInfoDoc = await doc.reference.collection('amount_info').doc('info').get();
        final productInfoQuery = await doc.reference.collection('product_info').get();

        // 상품 정보를 리스트로 변환
        final productInfo = productInfoQuery.docs.map((doc) => doc.data()).toList();

        return {
          'userId': userId,
          'numberInfo': numberInfoDoc.data() ?? {},
          'ordererInfo': ordererInfoDoc.data() ?? {},
          'amountInfo': amountInfoDoc.data() ?? {},
          'productInfo': productInfo,
        };
      }).toList();

      return await Future.wait(futures);
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  // 특정 사용자의 발주 데이터를 가져오는 함수
  Future<List<Map<String, dynamic>>> fetchOrdersByUser(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('order_list')
          .doc(userId)
          .collection('orders')
          .get();
      final List<Future<Map<String, dynamic>>> futures = querySnapshot.docs.map((doc) async {
        final data = doc.data();

        // number_info, orderer_info, amount_info, product_info 가져오기
        final numberInfoDoc = await doc.reference.collection('number_info').doc('info').get();
        final ordererInfoDoc = await doc.reference.collection('orderer_info').doc('info').get();
        final amountInfoDoc = await doc.reference.collection('amount_info').doc('info').get();
        final productInfoQuery = await doc.reference.collection('product_info').get();

        // 상품 정보를 리스트로 변환
        final productInfo = productInfoQuery.docs.map((doc) => doc.data()).toList();

        return {
          'numberInfo': numberInfoDoc.data() ?? {},
          'ordererInfo': ordererInfoDoc.data() ?? {},
          'amountInfo': amountInfoDoc.data() ?? {},
          'productInfo': productInfo,
        };
      }).toList();

      return await Future.wait(futures);
    } catch (e) {
      throw Exception('Failed to fetch orders for user $userId: $e');
    }
  }
}
