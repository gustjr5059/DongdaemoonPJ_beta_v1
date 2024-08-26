import 'package:cloud_firestore/cloud_firestore.dart';

// ------ 마이페이지용 쪽지 관리 화면에서 파이어베이스 내 쪽지 관련 데이터를 불러오는 로직인 PrivateMessageRepository 클래스 내용 시작
class PrivateMessageRepository {
  final FirebaseFirestore firestore;

  // PrivateMessageRepository 클래스의 생성자.
  PrivateMessageRepository({required this.firestore});


// ------ 특정 이메일 계정의 특정 조건에 맞는 쪽지 목록을 실시간으로 가져오는 함수 모음 내용 시작
  // <원리>
  // 해당 쿼리 로직 :
  // 파이어스토어 내 인덱스 저장 (컬렉션 ID: message, 'private_email_closed_button' : ascending, 'message_sendingTime' : ascending)
  // 해당 인덱스 순서에 맞게 쿼리 순서를 짜서,
  // 우선, 해당 message_sendingTime 이내인 쪽지를 가져오고,
  // 'x' 버튼을 클릭하면 fetchDeleteMessages 함수를 활용한 'private_email_closed_button' 필드값이 'true'로 변경되는 것을 활용해서 'false' 값만 가져옴
  // 이러면 UI 상으로는 해당 쪽지를 삭제한 것으로 보이지만, 파이어스토어 내에선 해당 데이터가 존재하도록 함

// 특정 이메일 계정의 1분 이내에 발송된 쪽지 목록을 실시간으로 가져오는 함수.
  Stream<List<Map<String, dynamic>>> fetchMinutesMessages(String email, int minutes) {
    // 1분 전의 날짜와 시간을 계산
    final oneMinuteAgo = DateTime.now().subtract(Duration(minutes: minutes));

    // Firestore에서 1분 이내에 발송된 쪽지들만 가져오기 위한 쿼리
    return firestore
        .collection('message_list') // 'message_list' 컬렉션에 접근
        .doc(email) // 주어진 이메일에 해당하는 문서에 접근
        .collection('message') // 해당 문서 내의 'message' 서브컬렉션에 접근
        .where('message_sendingTime', isGreaterThanOrEqualTo: oneMinuteAgo) // 'message_sendingTime' 필드가 1분 전보다 늦은(즉, 최근) 문서들만 필터링
        .where('private_email_closed_button', isEqualTo: false) // 'private_email_closed_button' 필드가 false인 문서들만 필터링
        .orderBy('message_sendingTime', descending: false) // 'message_sendingTime' 필드를 기준으로 오름차순(과거 -> 현재) 정렬
        .snapshots() // 실시간으로 데이터 변경을 감지하고 스트림으로 반환
        .map((snapshot) => snapshot.docs.map((doc) => {
      'id': doc.id,  // 문서 ID를 'id'로 포함
      ...doc.data() as Map<String, dynamic> // 문서의 나머지 데이터를 맵 형식으로 저장
    }).toList()); // 각 문서를 맵으로 변환한 후 리스트로 변환
  }

// 특정 이메일 계정의 30일 이내에 발송된 쪽지 목록을 실시간으로 가져오는 함수.
  Stream<List<Map<String, dynamic>>> fetchDaysMessages(String email, int days) {
    // 30일 전의 날짜와 시간을 계산
    final thirtyDaysAgo = DateTime.now().subtract(Duration(days: days));

    // Firestore에서 30일 이내에 발송된 쪽지들만 가져오기 위한 쿼리
    return firestore
        .collection('message_list') // 'message_list' 컬렉션에 접근
        .doc(email) // 주어진 이메일에 해당하는 문서에 접근
        .collection('message') // 해당 문서 내의 'message' 서브컬렉션에 접근
        .where('message_sendingTime', isGreaterThanOrEqualTo: thirtyDaysAgo) // 'message_sendingTime' 필드가 30일 전보다 늦은(즉, 최근) 문서들만 필터링
        .where('private_email_closed_button', isEqualTo: false) // 'private_email_closed_button' 필드가 false인 문서들만 필터링
        .orderBy('message_sendingTime', descending: false) // 'message_sendingTime' 필드를 기준으로 오름차순(과거 -> 현재) 정렬
        .snapshots() // 실시간으로 데이터 변경을 감지하고 스트림으로 반환
        .map((snapshot) => snapshot.docs.map((doc) => {
      'id': doc.id,  // 문서 ID를 'id'로 포함
      ...doc.data() as Map<String, dynamic> // 문서의 나머지 데이터를 맵 형식으로 저장
    }).toList()); // 각 문서를 맵으로 변환한 후 리스트로 변환
  }

// 특정 이메일 계정의 1년 이내에 발송된 쪽지 목록을 실시간으로 가져오는 함수.
  Stream<List<Map<String, dynamic>>> fetchYearMessages(String email, int days) {
    // 1년(365일) 전의 날짜와 시간을 계산
    final oneYearAgo = DateTime.now().subtract(Duration(days: days));

    // Firestore에서 1년 이내에 발송된 쪽지들만 가져오기 위한 쿼리
    return firestore
        .collection('message_list') // 'message_list' 컬렉션에 접근
        .doc(email) // 주어진 이메일에 해당하는 문서에 접근
        .collection('message') // 해당 문서 내의 'message' 서브컬렉션에 접근
        .where('message_sendingTime', isGreaterThanOrEqualTo: oneYearAgo) // 'message_sendingTime' 필드가 1년 전보다 늦은(즉, 최근) 문서들만 필터링
        .where('private_email_closed_button', isEqualTo: false) // 'private_email_closed_button' 필드가 false인 문서들만 필터링
        .orderBy('message_sendingTime', descending: false) // 'message_sendingTime' 필드를 기준으로 오름차순(과거 -> 현재) 정렬
        .snapshots() // 실시간으로 데이터 변경을 감지하고 스트림으로 반환
        .map((snapshot) => snapshot.docs.map((doc) => {
      'id': doc.id,  // 문서 ID를 'id'로 포함
      ...doc.data() as Map<String, dynamic> // 문서의 나머지 데이터를 맵 형식으로 저장
    }).toList()); // 각 문서를 맵으로 변환한 후 리스트로 변환
  }

// 특정 쪽지의 'private_email_closed_button' 필드값을 'true'로 변경하는 함수.
  Future<void> fetchDeleteMessages(String email, String messageId) async {
    // Firestore에서 특정 이메일의 메시지 컬렉션을 참조하여 해당 문서 ID를 찾음.
    final messageDoc = firestore
        .collection('message_list') // 'message_list' 컬렉션에 접근
        .doc(email) // 주어진 이메일에 해당하는 문서에 접근
        .collection('message') // 해당 문서 내의 'message' 서브컬렉션에 접근
        .doc(messageId); // 주어진 메시지 ID에 해당하는 문서에 접근

    // 삭제 시간 기록을 위한 현재 시간 저장
    final DateTime messageDeleteTime = DateTime.now();

    // 해당 문서의 'private_email_closed_button' 필드값을 'true'로 업데이트하고
    // 'message_delete_time': messageDeleteTime로 쪽지 삭제 시간도 저장
    await messageDoc.update({
      'private_email_closed_button': true, // 해당 필드를 true로 변경
      'message_delete_time': messageDeleteTime, // 쪽지 삭제 시간
    });
  }
// ------ 특정 이메일 계정의 특정 조건에 맞는 쪽지 목록을 실시간으로 가져오는 함수 모음 내용 끝

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

// 특정 발주번호에 해당하는 배송 시작일을 가져오는 함수
  Future<DateTime?> fetchDeliveryStartDate(String email, String orderNumber) async {

    // Firestore에서 'message_list' 컬렉션의 특정 이메일 문서 안의 'message' 하위 컬렉션을 참조하는 쿼리 스냅샷을 가져옴
    final querySnapshot = await firestore
        .collection('message_list')
        .doc(email)
        .collection('message')
    // 주어진 발주번호와 일치하는 메시지를 필터링함
        .where('order_number', isEqualTo: orderNumber)
    // 내용이 '해당 발주 건은 배송이 진행되었습니다.'와 일치하는 메시지를 필터링함
        .where('contents', isEqualTo: '해당 발주 건은 배송이 진행되었습니다.')
        .get();

    // 쿼리 결과가 비어 있지 않으면, 즉 하나 이상의 문서가 있으면 실행됨
    if (querySnapshot.docs.isNotEmpty) {
      // 첫 번째 문서의 'message_sendingTime' 필드를 Timestamp 타입으로 가져옴
      final sendingTime = querySnapshot.docs.first.data()['message_sendingTime'] as Timestamp?;
      // Timestamp를 DateTime으로 변환하여 반환함
      return sendingTime?.toDate();
    }
    // 쿼리 결과가 비어 있으면 null을 반환함
    return null;
  }
}
// ------ 마이페이지용 쪽지 관리 화면에서 파이어베이스 내 쪽지 관련 데이터를 불러오는 로직인 PrivateMessageRepository 클래스 내용 끝
