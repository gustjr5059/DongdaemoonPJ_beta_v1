import 'package:cloud_firestore/cloud_firestore.dart';


// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 관련 데이터 불러오는 OrderlistRepository 클래스 내용 시작 부분
class OrderlistRepository {
  final FirebaseFirestore firestore;

  // OrderlistRepository 클래스의 생성자, FirebaseFirestore 인스턴스를 받아옴
  OrderlistRepository({required this.firestore});

  // 모든 사용자의 이메일 데이터를 가져오는 함수
  Future<List<String>> fetchAllUserEmails() async {
    try {
      print('Fetching all user emails for admin...');
      // 'users' 컬렉션의 모든 문서를 가져옴
      final querySnapshot = await firestore.collection('users').get();
      print('Fetched users: ${querySnapshot.docs.length}');

      // 각 문서에서 'email' 필드를 추출하여 리스트로 만듦
      final List<String> userEmails = querySnapshot.docs.map((doc) {
        final userEmail = doc.data()?['email'] as String? ?? '';
        print('Processing user: $userEmail');
        return userEmail;
      }).where((email) => email.isNotEmpty).toList(); // 이메일이 비어있지 않은 경우만 리스트에 추가

      print('Finished fetching all user emails for admin');
      return userEmails;
    } catch (e) {
      print('Failed to fetch user emails: $e');
      // 에러 발생 시 예외를 던짐
      throw Exception('Failed to fetch user emails: $e');
    }
  }

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
        // 발주 내역이 없는 경우 예외를 던짐
        throw Exception('No orders found for email $userEmail');
      }

      final List<Map<String, dynamic>> allOrders = [];

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

      print('Finished fetching orders for email: $userEmail');
      return allOrders;
    } catch (e) {
      print('Failed to fetch orders for email $userEmail: $e');
      // 에러 발생 시 예외를 던짐
      throw Exception('Failed to fetch orders for email $userEmail: $e');
    }
  }
}
// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 관련 데이터 불러오는 OrderlistRepository 클래스 내용 끝 부분
