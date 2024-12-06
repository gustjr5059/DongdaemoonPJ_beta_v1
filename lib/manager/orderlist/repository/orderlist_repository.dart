import 'package:cloud_firestore/cloud_firestore.dart';

// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 관련 데이터 불러오는 AdminOrderlistRepository 클래스 내용 시작 부분
class AdminOrderlistRepository {
  final FirebaseFirestore firestore;

  // AdminOrderlistRepository 클래스의 생성자, FirebaseFirestore 인스턴스를 받아옴
  AdminOrderlistRepository({required this.firestore});

  // ——— 모든 사용자 이메일을 가져오는 함수 시작 부분
  // Firestore의 'users' 컬렉션에서 모든 사용자 이메일을 가져오고 특정 이메일을 필터링하여 반환함
  Future<List<String>> fetchAllUserEmails() async {
    try {
      print(
          'Firestore에서 모든 사용자 이메일을 가져오는 중...'); // Firestore에서 사용자 이메일 가져오기 시도 중임을 디버깅 로그로 출력
      final querySnapshot = await firestore
          .collection('users')
          .get(); // Firestore의 'users' 컬렉션에서 모든 문서를 가져오는 코드

      print(
          'Firestore에서 ${querySnapshot.docs.length}명의 사용자를 가져옴.'); // Firestore에서 몇 명의 사용자를 가져왔는지 디버깅 로그로 출력

      final emailList = querySnapshot.docs // 가져온 문서들에서
          .map((doc) =>
      doc.data()['email'] as String) // 각 문서 데이터의 'email' 필드를 추출함
          .where((email) =>
      email.isNotEmpty &&
          email !=
              'gshe.couture@gmail.com') // 이메일이 비어 있지 않고 특정 이메일이 아닌 경우에만 필터링함
          .toList(); // 필터링된 이메일을 리스트로 변환함

      print(
          '유효한 이메일 ${emailList.length}개를 필터링함.'); // 필터링된 이메일 수를 디버깅 로그로 출력
      return emailList; // 필터링된 이메일 리스트를 반환함
    } catch (e) {
      print('사용자 이메일 가져오기 중 오류 발생: $e'); // 이메일 가져오는 중 발생한 오류를 디버깅 로그로 출력
      throw Exception('사용자 이메일을 가져오는 데 실패: $e'); // 예외를 발생시켜 외부로 오류를 전달함
    }
  }
  // ——— 모든 사용자 이메일을 가져오는 함수 끝 부분

  // 주어진 이메일 주소를 기반으로 발주 내역을 페이징 처리하여 가져오는 함수
  Future<List<Map<String, dynamic>>> fetchOrdersByEmail({
    required String userEmail,
    DocumentSnapshot? lastDocument,
    required int limit,
  }) async {
    try {
      print('Firestore에서 발주 데이터를 가져옵니다: 사용자 이메일 - $userEmail, 불러올 개수 - $limit');
      if (lastDocument != null) {
        print('마지막 문서 이후의 데이터를 가져옵니다.');
      }

      // 'wearcano_order_list' 컬렉션에서 해당 사용자 이메일의 문서를 참조
      final userDocRef = firestore.collection('wearcano_order_list').doc(userEmail);

      // 'orders' 컬렉션에서 'private_orderList_closed_button' 값이 false인 문서들만 조회하며, 최신순으로 정렬하고 제한된 개수만큼 가져옴
      Query query = userDocRef.collection('orders')
          .orderBy('numberInfo.order_number', descending: true)
          .limit(limit);

      // 마지막 문서가 있으면, 그 이후의 데이터를 가져옴
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final ordersQuerySnapshot = await query.get();

      if (ordersQuerySnapshot.docs.isEmpty) return [];

      final List<Map<String, dynamic>> allOrders = [];

      for (var orderDoc in ordersQuerySnapshot.docs) {
        final numberInfo = await orderDoc.reference
            .collection('number_info')
            .doc('info')
            .get();
        final orderStatus = await orderDoc.reference
            .collection('order_status_info')
            .doc('info')
            .get();

        final Timestamp? orderTimestamp = numberInfo.data()?['order_date'];
        final DateTime? orderDate = orderTimestamp != null
            ? orderTimestamp.toDate()
            : null; // Timestamp를 DateTime으로 변환

        allOrders.add({
          'order_number': numberInfo.data()?['order_number'] ?? '',
          'order_date': orderDate, // 변환된 DateTime 사용
          'order_status': orderStatus.data()?['order_status'] ?? '',
          'snapshot': orderDoc,
        });
      }
      return allOrders;
    } catch (e) {
      print("발주 데이터 가져오기 오류: $e");
      return [];
    }
  }

  // 특정 발주 번호에 해당하는 데이터를 가져오는 함수임
  Future<Map<String, dynamic>> fetchOrderlistItemByOrderNumber(String userEmail, String orderNumber) async {
    // 발주 상세 데이터를 요청한다는 메시지를 출력함
    print("발주 상세 데이터 요청 시작: orderNumber=$orderNumber, userEmail=$userEmail");

    try {
      // Firestore의 'couture_order_list' 컬렉션에서 사용자의 이메일을 기준으로 문서 참조를 가져옴
      final userDocRef = firestore.collection('wearcano_order_list').doc(userEmail);

      // 'orders' 서브 컬렉션에서 'numberInfo.order_number' 필드와 일치하는 주문 번호를 가진 문서를 조회함
      final ordersQuerySnapshot = await userDocRef.collection('orders')
          .where('numberInfo.order_number', isEqualTo: orderNumber)
          .get();

      // 조회된 문서 개수를 출력함
      print('발주 문서 조회 결과: ${ordersQuerySnapshot.docs.length}건의 데이터가 조회됨');

      // 조회된 문서가 없을 경우, 빈 Map을 반환함
      if (ordersQuerySnapshot.docs.isEmpty) {
        print('해당 발주 번호에 해당하는 발주 데이터가 없음: orderNumber=$orderNumber');
        return {}; // 빈 Map 반환
      }

      // 첫 번째로 조회된 문서의 참조를 가져옴
      final orderDocRef = ordersQuerySnapshot.docs.first.reference;
      print('처리 중인 발주 문서: ${orderDocRef.id}');

      // 'number_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final numberInfoDoc = await orderDocRef.collection('number_info').doc(
          'info').get();
      print('발주 번호 정보 조회: ${numberInfoDoc.exists ? '존재함' : '존재하지 않음'}');

      // 'orderer_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final ordererInfoDoc = await orderDocRef.collection('orderer_info').doc(
          'info').get();
      print('주문자 정보 조회: ${ordererInfoDoc.exists ? '존재함' : '존재하지 않음'}');

      // 'amount_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final amountInfoDoc = await orderDocRef.collection('amount_info').doc(
          'info').get();
      print('수량 정보 조회: ${amountInfoDoc.exists ? '존재함' : '존재하지 않음'}');

      // 'recipient_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final recipientInfoDoc = await orderDocRef.collection('recipient_info')
          .doc('info')
          .get();
      print('수령자 정보 조회: ${recipientInfoDoc.exists ? '존재함' : '존재하지 않음'}');

      // 'product_info' 서브 컬렉션의 모든 문서를 조회하여 제품 정보를 가져옴
      final productInfoQuery = await orderDocRef.collection('product_info')
          .get();
      print('제품 정보 조회 결과: ${productInfoQuery.docs.length}개의 제품 데이터가 조회됨');

      // 'order_status_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final orderStatusDoc = await orderDocRef.collection('order_status_info')
          .doc('info')
          .get();
      print('발주 상태 정보 조회: ${orderStatusDoc.exists ? '존재함' : '존재하지 않음'}');

      // 조회된 제품 정보 문서들을 순회하며 Map 형식으로 변환함
      final productInfo = productInfoQuery.docs.map((doc) {
        // 처리 중인 제품의 ID를 출력함
        print('처리 중인 제품: ${doc.id}');
        // 문서 데이터를 Map으로 변환함
        return doc.data() as Map<String, dynamic>;
      }).toList();

      // 각 정보들을 하나의 Map으로 합쳐 반환, 없을 경우 빈 맵을 반환
      final orderData = {
        'numberInfo': numberInfoDoc.data() as Map<String, dynamic>? ?? {},
        // 주문 번호 정보
        'ordererInfo': ordererInfoDoc.data() as Map<String, dynamic>? ?? {},
        // 주문자 정보
        'amountInfo': amountInfoDoc.data() as Map<String, dynamic>? ?? {},
        // 금액 정보
        'recipientInfo': recipientInfoDoc.data() as Map<String, dynamic>? ?? {},
        // 수령인 정보
        'productInfo': productInfo,
        // 제품 정보 리스트
        'orderStatus': orderStatusDoc.data()?['order_status'] ?? '',
        // 주문 상태 정보
      };

      // 발주 상세 데이터 요청이 완료되었다는 메시지를 출력함
      print('발주 상세 데이터 요청 완료: orderNumber=$orderNumber');

      // 발주 데이터를 반환함
      return orderData;
    } catch (error) {
      // 오류 발생 시 에러 메시지를 출력함
      print('발주 상세 데이터 요청 실패: $error');
      // 발생한 오류를 상위로 던져 처리하도록 함
      throw error;
    }
  }
}
// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 관련 데이터 불러오는 OrderlistRepository 클래스 내용 끝 부분
