import 'package:cloud_firestore/cloud_firestore.dart';

// ------ 리뷰 관리 화면 내 데이터 처리 로직인 ReviewRepository 내용 시작 부분
// Firestore와 상호작용하여 리뷰 관련 데이터를 처리하는 ReviewRepository 클래스 정의
class ReviewRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스를 저장하는 변수

  // ReviewRepository 생성자, firestore 매개변수를 필수로 받음
  ReviewRepository({required this.firestore});

  // 특정 사용자의 발주 데이터를 가져오는 함수
  Future<List<Map<String, dynamic>>> fetchOrdersByEmail(String userEmail) async {
    try {
      print('Fetching orders for email: $userEmail');
      // 'order_list' 컬렉션에서 사용자 이메일에 해당하는 문서를 가져옴
      final userDocRef = firestore.collection('order_list').doc(userEmail);

      // 해당 문서의 'orders' 하위 컬렉션의 모든 문서를 가져옴
      final ordersQuerySnapshot = await userDocRef.collection('orders').get();
      print('Fetched orders: ${ordersQuerySnapshot.docs.length} for email: $userEmail');

      if (ordersQuerySnapshot.docs.isEmpty) {
        print('No orders found for email $userEmail');
        return []; // 빈 리스트 반환
      }

      final List<Map<String, dynamic>> allOrders = []; // 발주 데이터를 저장할 리스트

      for (var orderDoc in ordersQuerySnapshot.docs) {
        print('Processing order: ${orderDoc.id}');

        // 각 발주 문서의 하위 컬렉션에서 필요한 정보를 가져옴
        final numberInfoDoc = await orderDoc.reference.collection('number_info').doc('info').get();
        final ordererInfoDoc = await orderDoc.reference.collection('orderer_info').doc('info').get();
        final amountInfoDoc = await orderDoc.reference.collection('amount_info').doc('info').get();
        final productInfoQuery = await orderDoc.reference.collection('product_info').get();

        // 'product_info' 하위 컬렉션의 모든 문서를 리스트로 변환
        final productInfo = productInfoQuery.docs.map((doc) {
          print('Processing product: ${doc.id}');
          return doc.data() as Map<String, dynamic>;
        }).toList();

        // 발주 데이터를 리스트에 추가
        allOrders.add({
          'numberInfo': numberInfoDoc.data() as Map<String, dynamic>? ?? {},
          'ordererInfo': ordererInfoDoc.data() as Map<String, dynamic>? ?? {},
          'amountInfo': amountInfoDoc.data() as Map<String, dynamic>? ?? {},
          'productInfo': productInfo,
        });
      }

      // 발주일자 기준으로 내림차순 정렬
      allOrders.sort((a, b) {
        final dateA = a['numberInfo']['order_date'] as Timestamp?;
        final dateB = b['numberInfo']['order_date'] as Timestamp?;
        if (dateA != null && dateB != null) {
          return dateB.compareTo(dateA); // 내림차순 정렬
        }
        return 0;
      });

      print('Finished fetching and sorting orders for email: $userEmail');
      return allOrders; // 정렬된 발주 데이터를 반환
    } catch (e) {
      print('Failed to fetch orders for email $userEmail: $e');
      return []; // 오류 발생 시 빈 리스트 반환
    }
  }
}
// ------ 리뷰 관리 화면 내 데이터 처리 로직인 ReviewRepository 내용 끝 부분