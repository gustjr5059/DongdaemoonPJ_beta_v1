import 'package:cloud_firestore/cloud_firestore.dart';

// ------- 관리자용 쪽지 관리 화면에서 데이터를 파이어베이스에서 불러오고, 저장하는 로직 관련 AdminMessageRepository 클래스 내용 시작
class AdminMessageRepository {
  final FirebaseFirestore firestore;

  // AdminMessageRepository 클래스의 생성자.
  AdminMessageRepository({required this.firestore});

  // Firestore에서 수신자 이메일 목록을 가져오는 함수.
  Future<List<String>> fetchReceivers() async {
    try {
      print('Fetching all user emails for admin...');
      // 'users' 컬렉션의 모든 문서를 가져옴.
      final querySnapshot = await firestore.collection('users').get();
      print('Fetched users: ${querySnapshot.docs.length}');

      // 각 문서에서 'email' 필드를 추출하여 리스트로 만듦.
      final List<String> userEmails = querySnapshot.docs.map((doc) {
        final userEmail = doc.data()['email'] as String? ?? '';
        print('Processing user: $userEmail');
        return userEmail;
      }).where((email) => email.isNotEmpty && email != 'gshe.couture@gmail.com').toList(); // 'gshe.couture@gmail.com'을 제외하고 리스트에 추가

      print('Filtered user emails: $userEmails');
      print('Finished fetching all user emails for admin');
      return userEmails;
    } catch (e) {
      print('Failed to fetch user emails: $e');
      // 에러 발생 시 예외를 던짐
      throw Exception('Failed to fetch user emails: $e');
    }
  }

  // 특정 수신자의 발주번호 목록을 가져오는 함수.
  Future<List<String>> fetchOrderNumbers(String receiver) async {
    try {
      // Firestore에서 사용자의 이메일을 기준으로 검색.
      final querySnapshot = await firestore
          .collection('order_list')
          .doc(receiver)
          .collection('orders')
          .get();

      // 만약 주문이 없다면 '없음'을 반환.
      if (querySnapshot.docs.isEmpty) {
        print('No orders found for email: $receiver');
        return ['없음'];
      }

      print('Found ${querySnapshot.docs.length} orders for email: $receiver');

      // 각 order 문서의 number_info 하위 컬렉션에서 order_number 필드를 가져옴.
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

      // 발주번호가 없으면 '없음'을 반환.
      return orderNumbers.isEmpty ? ['없음'] : orderNumbers;
    } catch (e) {
      print('Error fetching order numbers: $e');
      return ['없음'];
    }
  }

  // Firestore에 메시지를 저장하는 함수.
  Future<void> sendMessage({
    required String sender,
    required String recipient,
    required String orderNumber,
    required String contents,
  }) async {
    // Firestore에 저장할 문서의 참조를 생성.
    final messageDoc = firestore.collection('message_list')
        .doc(recipient)
        .collection('message')
        .doc('${DateTime.now().millisecondsSinceEpoch}');

    // 문서에 데이터를 설정하여 메시지를 저장.
    await messageDoc.set({
      'sender': sender,
      'recipient': recipient,
      'orderNumber': orderNumber,
      'contents': contents,
      'message_sendingTime': FieldValue.serverTimestamp(),
    });
  }

  // 모든 이메일 계정의 쪽지 목록을 가져오는 함수.
  Stream<List<Map<String, dynamic>>> fetchAllMessages() {
    // Firestore에서 모든 쪽지 목록을 실시간으로 가져옴.
    return firestore.collectionGroup('message').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ({
        'id': doc.id,  // 문서 ID를 포함하도록 수정
        ...doc.data() as Map<String, dynamic>
      })).toList();
    });
  }

  // Firestore에서 특정 메시지를 삭제하는 함수.
  Future<void> deleteMessage(String messageId, String recipient) async {
    // Firestore에서 해당 메시지를 삭제.
    await firestore.collection('message_list')
        .doc(recipient)
        .collection('message')
        .doc(messageId)
        .delete();
  }
}
// ------- 관리자용 쪽지 관리 화면에서 데이터를 파이어베이스에서 불러오고, 저장하는 로직 관련 AdminMessageRepository 클래스 내용 끝
