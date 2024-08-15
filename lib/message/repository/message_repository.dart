import 'package:cloud_firestore/cloud_firestore.dart';

// ------ 마이페이지용 쪽지 관리 화면에서 파이어베이스 내 쪽지 관련 데이터를 불러오는 로직인 PrivateMessageRepository 클래스 내용 시작
class PrivateMessageRepository {
  final FirebaseFirestore firestore;

  // PrivateMessageRepository 클래스의 생성자.
  PrivateMessageRepository({required this.firestore});

  // 특정 이메일 계정의 쪽지 목록을 실시간으로 가져오는 함수.
  Stream<List<Map<String, dynamic>>> fetchMessages(String email) {
    // Firestore에서 해당 이메일의 쪽지 목록을 실시간으로 가져옴.
    return firestore
        .collection('message_list')
        .doc(email)
        .collection('message')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {
      'id': doc.id,  // 문서 ID를 포함
      ...doc.data() as Map<String, dynamic>
    }).toList());
  }

  // 특정 발주번호에 해당하는 결제완료일을 가져오는 함수.
  Future<DateTime?> fetchPaymentCompleteDate(String email, String orderNumber) async {
    // Firestore에서 'message_list' 컬렉션 내의 특정 이메일에 해당하는 문서(doc)를 참조하고,
    // 그 하위 컬렉션인 'message'에서 주어진 발주번호(order_number)와 특정 내용('해당 발주 건은 결제 완료 되었습니다.')을 가진 문서를 조회하도록 했음.
    final querySnapshot = await firestore
        .collection('message_list')
        .doc(email)
        .collection('message')
        .where('order_number', isEqualTo: orderNumber)
        .where('contents', isEqualTo: '해당 발주 건은 결제 완료 되었습니다.')
        .get();

    // 조회된 문서가 하나라도 있을 경우, 첫 번째 문서의 'message_sendingTime' 필드를 Timestamp로 가져오도록 했음.
    if (querySnapshot.docs.isNotEmpty) {
      final sendingTime = querySnapshot.docs.first.data()['message_sendingTime'] as Timestamp?;
      // Timestamp가 존재하면 이를 DateTime으로 변환하여 반환하도록 했음.
      return sendingTime?.toDate();
    }
    // 조건에 맞는 문서가 없으면 null을 반환하도록 했음.
    return null;
  }
}
// ------ 마이페이지용 쪽지 관리 화면에서 파이어베이스 내 쪽지 관련 데이터를 불러오는 로직인 PrivateMessageRepository 클래스 내용 끝
