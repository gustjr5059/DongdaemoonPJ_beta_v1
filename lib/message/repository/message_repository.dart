import 'package:cloud_firestore/cloud_firestore.dart';

// ------ 마이페이지용 쪽지 관리 화면에서 파이어베이스 내 쪽지 관련 데이터를 불러오는 로직인 PrivateMessageRepository 클래스 내용 시작
class PrivateMessageRepository {
  final FirebaseFirestore firestore;

  // PrivateMessageRepository 클래스의 생성자.
  PrivateMessageRepository({required this.firestore});

  // <원리>
  // 해당 쿼리 로직 :
  // 파이어스토어 내 인덱스 저장 (컬렉션 ID: message, 'private_email_closed_button' : ascending, 'message_sendingTime' : ascending)
  // 해당 인덱스 순서에 맞게 쿼리 순서를 짜서,
  // 우선, 해당 message_sendingTime 이내인 쪽지를 가져오고,
  // 'x' 버튼을 클릭하면 fetchDeleteMessages 함수를 활용한 'private_email_closed_button' 필드값이 'true'로 변경되는 것을 활용해서 'false' 값만 가져옴
  // 이러면 UI 상으로는 해당 쪽지를 삭제한 것으로 보이지만, 파이어스토어 내에선 해당 데이터가 존재하도록 함

  // ------- 특정 이메일 계정의 특정 조건에 맞는 쪽지 목록을 페이징 처리해서 가져오는 함수인 getPagedMessageItemsList 시작 부분
  Future<List<Map<String, dynamic>>> getPagedMessageItemsList({
    required String userEmail, // 특정 사용자 이메일 주소
    DocumentSnapshot? lastDocument, // 이전 페이지의 마지막 문서 스냅샷
    required int limit, // 한 페이지에 가져올 문서 수 제한
    required int timeFrame, // 시간 프레임: 10분, 30일, 1년 단위
  }) async {
    try {
      // 디버깅: 사용자 이메일과 쪽지 개수 출력
      print("사용자 $userEmail에 대한 쪽지 $limit개 가져오는 중");

      // 현재 시간에서 시간 프레임을 뺀 날짜를 계산함
      final dateLimit = DateTime.now().subtract(Duration(
        minutes: timeFrame == 10 ? 10 : 0, // 10분 전
        days: timeFrame == 30 ? 30 : (timeFrame == 365 ? 365 : 0), // 30일 또는 365일 전
      ));

      // Firestore에서 쿼리를 생성함
      Query query = firestore
          .collection('wearcano_message_list') // 최상위 컬렉션
          .doc(userEmail) // 사용자 이메일 문서 참조
          .collection('message') // 쪽지 하위 컬렉션
          .where('message_sendingTime', isGreaterThanOrEqualTo: dateLimit) // 메시지 전송 시간이 기준 날짜 이상인 문서 필터링
          .where('private_email_closed_button', isEqualTo: false) // 닫힌 쪽지가 아닌 문서 필터링
          .orderBy('message_sendingTime', descending: true) // 메시지 전송 시간을 기준으로 내림차순 정렬
          .limit(limit); // 제한된 개수만큼 가져옴

      // 마지막 문서가 있는 경우 페이징 처리 시작점 설정
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      // Firestore에서 쿼리를 실행하고 결과를 가져옴
      final querySnapshot = await query.get();

      // 디버깅: 가져온 쪽지 개수 출력
      print("사용자 $userEmail의 쪽지 ${querySnapshot.docs.length}개를 성공적으로 가져옴");

      // 가져온 문서를 매핑하여 데이터와 ID를 포함한 목록으로 반환함
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>; // 문서 데이터를 Map 형태로 변환함
        data['id'] = doc.id; // 문서 ID를 추가함
        data['snapshot'] = doc; // 문서 스냅샷을 추가함
        return data; // 결과 데이터 반환
      }).toList();
    } catch (e) {
      // 디버깅: 에러 발생 시 메시지 출력
      print('사용자 $userEmail의 쪽지 데이터를 가져오는 데 실패: $e');
      // 예외 발생
      throw Exception('쪽지 데이터를 가져오는 데 실패: $e');
    }
  }

// ------- 특정 이메일 계정의 특정 조건에 맞는 쪽지 목록을 페이징 처리해서 가져오는 함수인 getPagedMessageItemsList 끝 부분

  // ------- 특정 이메일 계정의 특정 메시지를 삭제하는 함수인 deleteMessage 시작 부분
  Future<void> deleteMessage({
    required String userEmail, // 특정 사용자 이메일 주소
    required String messageId, // 삭제할 쪽지의 ID
  }) async {
    try {
      // 디버깅: 삭제할 메시지 ID와 사용자 이메일 출력
      print('사용자 $userEmail의 메시지 $messageId 삭제 중');

      // Firestore에서 해당 문서 참조를 가져옴
      final messageDoc = firestore
          .collection('wearcano_message_list') // 최상위 컬렉션
          .doc(userEmail) // 사용자 이메일 문서 참조
          .collection('message') // 쪽지 하위 컬렉션
          .doc(messageId); // 특정 메시지 문서 참조

      // 문서의 현재 상태를 가져옴
      final docSnapshot = await messageDoc.get();

      // 문서가 존재하는 경우 삭제 처리
      if (docSnapshot.exists) {
        final DateTime messageDeleteTime = DateTime.now(); // 현재 시간
        await messageDoc.update({
          'private_email_closed_button': true, // 닫힌 상태로 업데이트
          'message_delete_time': messageDeleteTime, // 삭제 시간 기록
        });
        // 디버깅: 삭제 성공 메시지 출력
        print('사용자 $userEmail의 메시지 $messageId를 삭제 처리함');
      } else {
        // 문서를 찾을 수 없는 경우 에러 처리
        print("메시지 $messageId에 해당하는 문서를 찾을 수 없음");
        throw Exception('메시지 $messageId에 해당하는 문서를 찾을 수 없음');
      }
    } catch (e) {
      // 디버깅: 에러 발생 시 메시지 출력
      print('메시지 $messageId 삭제 처리 실패: $e');
      // 예외 발생
      throw Exception('메시지 삭제 처리 실패: $e');
    }
  }
  // ------- 특정 이메일 계정의 특정 메시지를 삭제하는 함수인 deleteMessage 끝 부분

  // 특정 발주번호에 해당하는 결제완료일을 가져오는 함수.
  Future<DateTime?> fetchPaymentCompleteDate(String email, String orderNumber) async {
    print('Fetching payment complete date for order number: $orderNumber for email: $email');
    // Firestore에서 'message_list' 컬렉션 내의 특정 이메일에 해당하는 문서(doc)를 참조하고,
    // 그 하위 컬렉션인 'message'에서 주어진 발주번호(order_number)와 특정 내용('해당 발주 건은 결제 완료 되었습니다.')을 가진 문서를 조회하도록 했음.
    final querySnapshot = await firestore
        .collection('wearcano_message_list')
        .doc(email)
        .collection('message')
        .where('order_number', isEqualTo: orderNumber)
        .where('contents', isEqualTo: '해당 발주 건은 결제 완료 되었습니다.')
        .get();

    // 조회된 문서가 하나라도 있을 경우, 첫 번째 문서의 'message_sendingTime' 필드를 Timestamp로 가져오도록 했음.
    if (querySnapshot.docs.isNotEmpty) {
      final sendingTime = querySnapshot.docs.first.data()['message_sendingTime'] as Timestamp?;
      print('Found payment complete date for order number: $orderNumber for email: $email');
      // Timestamp가 존재하면 이를 DateTime으로 변환하여 반환하도록 했음.
      return sendingTime?.toDate();
    }
    print('No payment complete date found for order number: $orderNumber for email: $email');
    // 조건에 맞는 문서가 없으면 null을 반환하도록 했음.
    return null;
  }

  // 특정 발주번호에 해당하는 배송 시작일을 가져오는 함수
  Future<DateTime?> fetchDeliveryStartDate(String email, String orderNumber) async {
    print('Fetching delivery start date for order number: $orderNumber for email: $email');
    // Firestore에서 'message_list' 컬렉션의 특정 이메일 문서 안의 'message' 하위 컬렉션을 참조하는 쿼리 스냅샷을 가져옴
    final querySnapshot = await firestore
        .collection('wearcano_message_list')
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
      print('Found delivery start date for order number: $orderNumber for email: $email');
      // Timestamp를 DateTime으로 변환하여 반환함
      return sendingTime?.toDate();
    }
    print('No delivery start date found for order number: $orderNumber for email: $email');
    // 쿼리 결과가 비어 있으면 null을 반환함
    return null;
  }
}
// ------ 마이페이지용 쪽지 관리 화면에서 파이어베이스 내 쪽지 관련 데이터를 불러오는 로직인 PrivateMessageRepository 클래스 내용 끝