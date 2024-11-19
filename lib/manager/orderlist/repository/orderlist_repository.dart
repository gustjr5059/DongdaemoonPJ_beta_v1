import 'package:cloud_firestore/cloud_firestore.dart';

// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 관련 데이터 불러오는 AdminOrderlistRepository 클래스 내용 시작 부분
class AdminOrderlistRepository {
  final FirebaseFirestore firestore;

  // AdminOrderlistRepository 클래스의 생성자, FirebaseFirestore 인스턴스를 받아옴
  AdminOrderlistRepository({required this.firestore});

  // 모든 사용자의 이메일 데이터를 가져오는 함수
  Future<List<String>> fetchAllUserEmails() async {
    try {
      print('Fetching all user emails for admin...'); // 시작 디버깅 메시지
      // 'users' 컬렉션의 모든 문서를 가져옴
      final querySnapshot = await firestore.collection('users').get();
      print('Fetched users: ${querySnapshot.docs.length}'); // 가져온 문서 수 출력

      // 각 문서에서 'email' 필드를 추출하여 리스트로 만듦
      final List<String> userEmails = querySnapshot.docs.map((doc) {
        final userEmail = doc.data()?['email'] as String? ?? '';
        print('Processing user: $userEmail'); // 각 이메일 처리 디버깅 메시지
        return userEmail;
      })
          .where((email) => email.isNotEmpty && email != 'gshe.couture@gmail.com')
          .toList(); // 'gshe.couture@gmail.com'을 제외하고 리스트에 추가

      print('Finished fetching all user emails for admin'); // 완료 메시지
      return userEmails;
    } catch (e) {
      print('Failed to fetch user emails: $e'); // 오류 발생 시 메시지 출력
      // 에러 발생 시 예외를 던짐
      throw Exception('Failed to fetch user emails: $e');
    }
  }

  // 특정 사용자의 발주 데이터를 가져오는 함수
  Future<List<Map<String, dynamic>>> fetchOrdersByEmail(String userEmail) async {
    try {
      print('Fetching orders for email: $userEmail'); // 시작 디버깅 메시지
      // 'order_list' 컬렉션에서 사용자 이메일에 해당하는 문서를 가져옴
      final userDocRef = firestore.collection('wearcano_order_list').doc(userEmail);

      // 해당 문서의 'orders' 하위 컬렉션의 모든 문서를 가져옴
      final ordersQuerySnapshot = await userDocRef.collection('orders').get();
      print('Fetched orders: ${ordersQuerySnapshot.docs.length} for email: $userEmail'); // 가져온 주문 수 출력

      if (ordersQuerySnapshot.docs.isEmpty) {
        print('No orders found for email $userEmail'); // 주문이 없을 때 메시지 출력
        return []; // 빈 리스트 반환
      }

      final List<Map<String, dynamic>> allOrders = [];

      for (var orderDoc in ordersQuerySnapshot.docs) {
        print('Processing order: ${orderDoc.id}'); // 각 주문 처리 디버깅 메시지

        // 각 발주 문서의 하위 컬렉션에서 필요한 정보를 가져옴
        final numberInfoDoc = await orderDoc.reference.collection('number_info').doc('info').get();
        final ordererInfoDoc = await orderDoc.reference.collection('orderer_info').doc('info').get();
        final amountInfoDoc = await orderDoc.reference.collection('amount_info').doc('info').get();
        final productInfoQuery = await orderDoc.reference.collection('product_info').get();

        // 'product_info' 하위 컬렉션의 모든 문서를 리스트로 변환
        final productInfo = productInfoQuery.docs.map((doc) {
          print('Processing product: ${doc.id}'); // 각 제품 처리 디버깅 메시지
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

      print('Finished fetching orders for email: $userEmail'); // 완료 메시지
      return allOrders;
    } catch (e) {
      print('Failed to fetch orders for email $userEmail: $e'); // 오류 발생 시 메시지 출력
      return []; // 빈 리스트 반환
    }
  }

  // 발주 상태를 업데이트하는 비동기 함수 정의
  Future<void> updateOrderStatus(String userEmail, String orderNumber, String newStatus) async {
    try {
      print('Updating order status for email: $userEmail, order number: $orderNumber to $newStatus'); // 시작 디버깅 메시지
      // Firestore에서 'order_list' 컬렉션에서 해당 유저의 문서(userEmail)를 선택하고,
      // 그 문서 내 'orders' 컬렉션에서 'numberInfo.order_number'가 orderNumber와 일치하는 발주 문서들을 가져옴
      final orderDoc = await firestore
          .collection('wearcano_order_list')
          .doc(userEmail)
          .collection('orders')
          .where('numberInfo.order_number', isEqualTo: orderNumber)
          .get();

      // 발주 문서가 없을 경우 예외를 발생시켜 "해당 발주를 찾을 수 없습니다." 메시지 출력
      if (orderDoc.docs.isEmpty) {
        print('Order not found for number: $orderNumber'); // 발주를 찾을 수 없는 경우 메시지 출력
        throw Exception('해당 발주를 찾을 수 없습니다.');
      }

      // 가져온 첫 번째 발주 문서의 'order_status_info' 하위 컬렉션에 있는 'info' 문서의
      // 'order_status' 필드를 새로운 상태(newStatus)로 업데이트
      await orderDoc.docs.first.reference.collection('order_status_info').doc('info').update({
        'order_status': newStatus,
      });
      print('Order status updated successfully for number: $orderNumber'); // 성공 메시지
    } catch (e) {
      // 발주 상태 업데이트에 실패할 경우 오류 메시지를 출력하고 예외를 발생시킴
      print('Failed to update order status: $e');
      throw Exception('Failed to update order status: $e');
    }
  }
}
// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 관련 데이터 불러오는 OrderlistRepository 클래스 내용 끝 부분