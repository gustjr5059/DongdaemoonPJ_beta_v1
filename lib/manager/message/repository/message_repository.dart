import 'package:cloud_firestore/cloud_firestore.dart';

// ------- 관리자용 쪽지 관리 화면에서 데이터를 파이어베이스에서 불러오고, 저장하는 로직 관련 AdminMessageRepository 클래스 내용 시작
class AdminMessageRepository {
  final FirebaseFirestore firestore;

  // AdminMessageRepository 클래스의 생성자.
  AdminMessageRepository({required this.firestore});

  // Firestore에 메시지를 읽음 상태로 업데이트하는 함수
  Future<void> markMessageAsRead(String messageId, String recipientId) async {
    final messageRef = firestore
        .collection('message_list')
        .doc(recipientId)
        .collection('message')
        .doc(messageId);

    await messageRef.update({
      'read': true,  // 메시지를 읽음 상태로 업데이트
    });
  }

  // Firestore에서 수신자 이메일 목록을 가져오는 함수.
  Future<List<String>> fetchReceivers() async {
    try {
      print('모든 사용자 이메일을 가져오는 중...');
      // 'users' 컬렉션의 모든 문서를 가져옴.
      final querySnapshot = await firestore.collection('users').get();
      print('가져온 사용자 수: ${querySnapshot.docs.length}');

      // 각 문서에서 'email' 필드를 추출하여 리스트로 만듦.
      final List<String> userEmails = querySnapshot.docs.map((doc) {
        final userEmail = doc.data()['email'] as String? ?? '';
        print('사용자 처리 중: $userEmail');
        return userEmail;
      }).where((email) => email.isNotEmpty && email != 'gshe.couture@gmail.com').toList(); // 'gshe.couture@gmail.com'을 제외하고 리스트에 추가

      print('필터링된 사용자 이메일 목록: $userEmails');
      print('모든 사용자 이메일 가져오기 완료');
      return userEmails;
    } catch (e) {
      print('사용자 이메일을 가져오는 데 실패했습니다: $e');
      // 에러 발생 시 예외를 던짐
      throw Exception('사용자 이메일을 가져오는 데 실패했습니다: $e');
    }
  }

  // 특정 수신자의 발주번호 목록을 가져오는 함수.
  Future<List<String>> fetchOrderNumbers(String receiver) async {
    try {
      print('수신자 $receiver 의 발주번호를 가져오는 중...');
      // Firestore에서 사용자의 이메일을 기준으로 검색.
      final querySnapshot = await firestore
          .collection('order_list')
          .doc(receiver)
          .collection('orders')
          .get();

      // 만약 주문이 없다면 '없음'을 반환.
      if (querySnapshot.docs.isEmpty) {
        print('해당 이메일에 대한 주문이 없습니다: $receiver');
        return ['없음'];
      }

      print('이메일 $receiver 에 대한 주문 수: ${querySnapshot.docs.length}');

      // 각 order 문서의 number_info 하위 컬렉션에서 order_number 필드를 가져옴.
      List<String> orderNumbers = [];
      for (var doc in querySnapshot.docs) {
        print('발주 확인 중: ${doc.id}');
        final numberInfoDoc = await doc.reference.collection('number_info').doc('info').get();
        if (numberInfoDoc.exists) {
          final orderNumber = numberInfoDoc.data()?['order_number'];
          if (orderNumber != null) {
            orderNumbers.add(orderNumber as String);
            print('발주 번호 찾음: $orderNumber (발주 ID: ${doc.id})');
          } else {
            print('발주 ID ${doc.id} 의 number_info 에 order_number 필드가 없습니다.');
          }
        } else {
          print('발주 ID ${doc.id} 에 number_info 가 존재하지 않습니다.');
        }
      }

      // 발주번호가 없으면 '없음'을 반환.
      return orderNumbers.isEmpty ? ['없음'] : orderNumbers;
    } catch (e) {
      print('발주 번호를 가져오는 중 오류 발생: $e');
      return ['없음'];
    }
  }

  // 쪽지 작성 탭 화면 내 환불 신청 상품 관련 드롭다운 메뉴 버튼 내 메뉴 내용
  Future<List<String>> fetchProductOptions(String receiver, String orderNumber) async {
    try {
      // Firestore에서 특정 수신자와 발주번호에 해당하는 문서를 조회함.
      final querySnapshot = await firestore
          .collection('order_list')
          .doc(receiver)
          .collection('orders')
          .where('numberInfo.order_number', isEqualTo: orderNumber)
          .get();

      // 조회된 문서가 없으면 '상품 없음'을 반환함.
      if (querySnapshot.docs.isEmpty) {
        return ['상품 없음'];
      }

      List<String> productOptions = []; // 상품 옵션을 저장할 리스트임.
      for (var doc in querySnapshot.docs) {
        // 각 주문 문서의 'product_info' 하위 컬렉션을 가져옴.
        final productInfoDocs = await doc.reference.collection('product_info').get();
        for (var productDoc in productInfoDocs.docs) {
          final separatorKey = productDoc.data()['separator_key']; // 상품의 separator_key를 가져옴.
          final selectedSize = productDoc.data()['selected_size']; // 선택된 사이즈를 가져옴.
          final selectedColorText = productDoc.data()['selected_color_text']; // 선택된 색상을 가져옴.
          // 상품 옵션을 'separator_key (selected_size / selected_color_text)' 형식으로 리스트에 추가함.
          productOptions.add('$separatorKey ($selectedSize / $selectedColorText)');
        }
      }

      return productOptions; // 상품 옵션 리스트를 반환함.
    } catch (e) {
      // 오류가 발생하면 오류 메시지를 출력하고 '상품 없음'을 반환함.
      print('상품 옵션을 가져오는 중 오류 발생: $e');
      return ['상품 없음'];
    }
  }

  // Firestore에 메시지를 저장하는 함수.
  Future<void> sendMessage({
    required String sender,    // 발신자 ID를 나타내는 필수 파라미터
    required String recipient, // 수신자 ID를 나타내는 필수 파라미터
    required String orderNumber, // 주문 번호를 나타내는 필수 파라미터
    required String contents, // 메시지 내용을 나타내는 필수 파라미터
    String? selectedSeparatorKey, // 선택된 separator_key, nullable로 변경
  }) async {
    print('메시지를 Firestore에 저장하는 중...');
    print('발신자: $sender, 수신자: $recipient, 주문 번호: $orderNumber, 내용: $contents');

    // Firestore에 저장할 문서의 참조를 생성.
    final messageDoc = firestore.collection('message_list') // Firestore의 'message_list' 컬렉션을 참조
        .doc(recipient) // 수신자 ID를 문서 ID로 사용하여 하위 컬렉션에 접근
        .collection('message') // 수신자별 메시지를 저장하는 하위 컬렉션 'message'에 접근
        .doc('${DateTime.now().millisecondsSinceEpoch}'); // 현재 시간을 기반으로 고유한 문서 ID를 생성

    // 저장할 데이터 맵 생성
    final messageData = {
      'sender': sender, // 발신자 ID를 저장
      'recipient': recipient, // 수신자 ID를 저장
      'order_number': orderNumber, // 주문 번호를 저장
      'contents': contents, // 메시지 내용을 저장
      'message_sendingTime': FieldValue.serverTimestamp(), // 서버 시간을 기준으로 메시지 전송 시간을 저장
      'private_email_closed_button': false, // 'private_email_closed_button' 필드에 기본값으로 false를 저장
      'read': false,
    };

        // 만약 쪽지 내용이 '환불 처리'인 경우 selected_separator_key 추가
        if (contents == '해당 발주 건은 환불 처리 되었습니다.' && selectedSeparatorKey != null) {
      messageData['selected_separator_key'] = selectedSeparatorKey;
    }

    // 문서에 데이터를 설정하여 메시지를 저장.
    await messageDoc.set(messageData);

    print('메시지 저장 완료');

    // 발주 상태 업데이트 로직
    String newStatus; // 업데이트될 주문 상태를 저장할 변수 선언
    if (contents == '해당 발주 건은 결제 완료 되었습니다.') { // 메시지 내용이 결제 완료임을 나타내는 경우
      newStatus = '배송 준비'; // 새로운 상태를 '배송 준비'로 설정
    } else if (contents == '해당 발주 건은 배송이 진행되었습니다.') { // 메시지 내용이 배송 중임을 나타내는 경우
      newStatus = '배송 중'; // 새로운 상태를 '배송 중'으로 설정
    } else {
      print('상태 업데이트가 필요하지 않음');
      return; // 위의 조건에 해당하지 않으면 상태 업데이트 없이 함수 종료
    }

    // 발주 상태 업데이트
    print('발주 상태를 업데이트합니다: $newStatus');
    await updateOrderStatus(recipient, orderNumber, newStatus); // 상태 업데이트를 위해 updateOrderStatus 함수 호출
    print('발주 상태 업데이트 완료');
  }

  // 발주 상태를 Firestore에 업데이트하는 함수
  Future<void> updateOrderStatus(String recipient, String orderNumber, String newStatus) async {
    try {
      print('발주 상태를 Firestore에 업데이트 중...');
      final orderDoc = await firestore // Firestore 참조
          .collection('order_list') // 'order_list' 컬렉션 참조
          .doc(recipient) // 수신자 ID를 문서 ID로 사용하여 해당 사용자의 주문 목록에 접근
          .collection('orders') // 사용자의 주문 목록에 접근
          .where('numberInfo.order_number', isEqualTo: orderNumber) // 주어진 주문 번호와 일치하는 주문 검색
          .get(); // 해당 주문 정보를 가져옴

      if (orderDoc.docs.isEmpty) { // 일치하는 주문이 없을 경우
        print('해당 발주를 찾을 수 없습니다: $orderNumber');
        throw Exception('해당 발주를 찾을 수 없습니다.'); // 예외 발생
      }

      await orderDoc.docs.first.reference.collection('order_status_info').doc('info').update({
        'order_status': newStatus, // 주문 상태 정보를 새 상태로 업데이트
      });
      print('발주 상태 업데이트 성공: $newStatus');
    } catch (e) {
      print('발주 상태 업데이트 실패: $e');
      throw Exception('Failed to update order status: $e'); // 상태 업데이트 실패 시 예외 발생
    }
  }

  // ------ 모든 이메일 계정의 특정 조건에 맞는 쪽지 목록을 실시간으로 가져오는 함수 모음 내용 시작
  // <원리>
  // 해당 쿼리 로직 :
  // 파이어스토어 내 인덱스 저장 (컬렉션 ID: message, 'private_email_closed_button' : ascending, 'message_sendingTime' : ascending)
  // 해당 인덱스 순서에 맞게 쿼리 순서를 짜서,
  // 우선, 해당 message_sendingTime 이내인 쪽지를 가져오고,
  // 'message_sendingTime'의 오름차순으로 가져오는데 descending: false로 해서 ascending을 표현함
  // 이러면 최신순으로 정렬됨 (message_sendingTime : 오름차순)
  // 여기선, 관리자용 쪽지 관리 화면이라서 'x' 버튼을 클릭하면 fetchDeleteAllMessage 함수를 활용해서 파이어베이스 내 데이터까지 삭제함!!

  // 특정 이메일 계정의 1분 이내 발송된 쪽지 목록을 실시간으로 가져오는 함수
  Stream<List<Map<String, dynamic>>> fetchMinutesAllMessages(String email, int minutes) {
    print('수신자 $email 의 최근 $minutes 분 내 발송된 쪽지 목록을 가져오는 중...');
    // 1분 전의 날짜와 시간을 계산
    final oneMinuteAgo = DateTime.now().subtract(Duration(minutes: minutes));

    return firestore
        .collection('message_list') // 'message_list' 컬렉션에 접근
        .doc(email) // 주어진 이메일에 해당하는 문서에 접근
        .collection('message') // 해당 문서 내의 'message' 서브컬렉션에 접근
        .where('message_sendingTime', isGreaterThanOrEqualTo: oneMinuteAgo) // 'message_sendingTime' 필드가 1분 전보다 늦은(즉, 최근) 문서들만 필터링
        .orderBy('message_sendingTime', descending: false) // 'message_sendingTime' 필드를 기준으로 오름차순(과거 -> 현재) 정렬
        .snapshots() // 실시간으로 데이터 변경을 감지하고 스트림으로 반환
        .map((snapshot) {
      print('수신자 $email 의 쪽지 ${snapshot.docs.length} 건을 실시간으로 가져왔습니다.');
      return snapshot.docs.map((doc) => {
      'id': doc.id, // 문서 ID를 'id'로 저장
      ...doc.data() as Map<String, dynamic> // 문서의 나머지 데이터를 맵 형식으로 저장
    }).toList(); // 각 문서를 맵으로 변환한 후 리스트로 변환
  });
}

  // 특정 이메일 계정의 30일 이내 발송된 쪽지 목록을 실시간으로 가져오는 함수
  Stream<List<Map<String, dynamic>>> fetchDaysAllMessages(String email, int days) {
    // 30일 전의 날짜와 시간을 계산
    final thirtyDaysAgo = DateTime.now().subtract(Duration(days: days));

    return firestore
        .collection('message_list') // 'message_list' 컬렉션에 접근
        .doc(email) // 주어진 이메일에 해당하는 문서에 접근
        .collection('message') // 해당 문서 내의 'message' 서브컬렉션에 접근
        .where('message_sendingTime', isGreaterThanOrEqualTo: thirtyDaysAgo) // 'message_sendingTime' 필드가 30일 전보다 늦은(즉, 최근) 문서들만 필터링
        .orderBy('message_sendingTime', descending: false) // 'message_sendingTime' 필드를 기준으로 오름차순(과거 -> 현재) 정렬
        .snapshots() // 실시간으로 데이터 변경을 감지하고 스트림으로 반환
        .map((snapshot) {
      print('수신자 $email 의 쪽지 ${snapshot.docs.length} 건을 실시간으로 가져왔습니다.');
      return snapshot.docs.map((doc) => {
        'id': doc.id, // 문서 ID를 'id'로 저장
        ...doc.data() as Map<String, dynamic> // 문서의 나머지 데이터를 맵 형식으로 저장
      }).toList(); // 각 문서를 맵으로 변환한 후 리스트로 변환
    });
  }

  // 특정 이메일 계정의 1년 이내 발송된 쪽지 목록을 실시간으로 가져오는 함수
  Stream<List<Map<String, dynamic>>> fetchYearsAllMessages(String email, int days) {
    // 1년(365일) 전의 날짜와 시간을 계산
    final oneYearAgo = DateTime.now().subtract(Duration(days: days));

    return firestore
        .collection('message_list') // 'message_list' 컬렉션에 접근
        .doc(email) // 주어진 이메일에 해당하는 문서에 접근
        .collection('message') // 해당 문서 내의 'message' 서브컬렉션에 접근
        .where('message_sendingTime', isGreaterThanOrEqualTo: oneYearAgo) // 'message_sendingTime' 필드가 1년 전보다 늦은(즉, 최근) 문서들만 필터링
        .orderBy('message_sendingTime', descending: false) // 'message_sendingTime' 필드를 기준으로 오름차순(과거 -> 현재) 정렬
        .snapshots() // 실시간으로 데이터 변경을 감지하고 스트림으로 반환
        .map((snapshot) {
      print('수신자 $email 의 쪽지 ${snapshot.docs.length} 건을 실시간으로 가져왔습니다.');
      return snapshot.docs.map((doc) => {
        'id': doc.id, // 문서 ID를 'id'로 저장
        ...doc.data() as Map<String, dynamic> // 문서의 나머지 데이터를 맵 형식으로 저장
      }).toList(); // 각 문서를 맵으로 변환한 후 리스트로 변환
    });
  }
  // ------ 모든 이메일 계정의 특정 조건에 맞는 쪽지 목록을 실시간으로 가져오는 함수 모음 내용 끝

  // Firestore에서 특정 메시지를 삭제하는 함수.
  Future<void> fetchDeleteAllMessage(String messageId, String recipient) async {
    print('메시지 삭제 중 (ID: $messageId, 수신자: $recipient)...');
    // Firestore에서 해당 메시지를 삭제.
    await firestore.collection('message_list')
        .doc(recipient)
        .collection('message')
        .doc(messageId)
        .delete();
    print('메시지 삭제 완료 (ID: $messageId, 수신자: $recipient)');
  }
}
// ------- 관리자용 쪽지 관리 화면에서 데이터를 파이어베이스에서 불러오고, 저장하는 로직 관련 AdminMessageRepository 클래스 내용 끝
