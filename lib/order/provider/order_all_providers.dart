import 'package:cloud_firestore/cloud_firestore.dart'; // 클라우드 파이어스토어 라이브러리 임포트
import 'package:firebase_auth/firebase_auth.dart'; // 파이어베이스 인증 라이브러리 임포트
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위한 Riverpod 라이브러리 임포트
import '../../message/provider/message_all_provider.dart';
import '../../product/model/product_model.dart'; // 제품 모델 파일 임포트
import '../repository/order_repository.dart'; // 발주 레포지토리 파일 임포트

// 이메일을 기반으로 사용자 정보를 가져오는 FutureProvider
final userInfoProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, email) async {
  // OrderRepository 인스턴스를 생성하여 이메일로 사용자 정보를 가져옴
  final repository = OrderRepository(firestore: FirebaseFirestore.instance);
  return repository.getUserInfoByEmail(email); // 사용자 정보를 반환
});

// 주소 검색 기능을 제공하는 FutureProvider
final addressSearchProvider = FutureProvider.family<List<dynamic>, String>((ref, query) async {
  // OrderRepository 인스턴스를 생성하여 주소를 검색함
  final repository = OrderRepository(firestore: FirebaseFirestore.instance);
  return repository.searchAddress(query); // 검색된 주소 목록을 반환
});

// 발주 레포지토리를 제공하는 프로바이더
final orderRepositoryProvider = Provider((ref) => OrderRepository(firestore: FirebaseFirestore.instance));

// 발주 처리 함수
final placeOrderProvider = FutureProvider.family<String, PlaceOrderParams>((ref, params) async {
  // orderRepositoryProvider를 통해 발주 레포지토리 인스턴스를 가져옴
  final repository = ref.read(orderRepositoryProvider);
  // 발주 요청을 처리하고 결과를 반환함
  return await repository.placeOrder(
    ordererInfo: params.ordererInfo, // 발주자 정보
    recipientInfo: params.recipientInfo, // 수령자 정보
    amountInfo: params.amountInfo, // 결제 정보
    productInfo: params.productInfo, // 상품 정보 리스트
  );
});

// 발주 처리에 필요한 매개변수를 담는 클래스
class PlaceOrderParams {
  final Map<String, dynamic> ordererInfo; // 발주자 정보
  final Map<String, dynamic> recipientInfo; // 수령자 정보
  final Map<String, dynamic> amountInfo; // 결제 정보
  final List<ProductContent> productInfo; // 상품 정보 리스트

  PlaceOrderParams({
    required this.ordererInfo, // 생성자에서 발주자 정보를 받아옴
    required this.recipientInfo, // 생성자에서 수령자 정보를 받아옴
    required this.amountInfo, // 생성자에서 결제 정보를 받아옴
    required this.productInfo, // 생성자에서 상품 정보 리스트를 받아옴
  });
}

// 발주 데이터를 가져오는 FutureProvider
final orderDataProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, orderId) async {
  // orderRepositoryProvider를 통해 발주 레포지토리 인스턴스를 가져옴
  final repository = ref.watch(orderRepositoryProvider);
  // 현재 로그인한 사용자의 이메일을 가져옴
  final userEmail = FirebaseAuth.instance.currentUser?.email;

  // 사용자가 로그인되어 있지 않으면 예외를 발생시킴
  if (userEmail == null) {
    throw Exception('User not logged in');
  }

  // 발주 데이터를 가져와 반환함
  return await repository.fetchOrderData(userEmail, orderId);
});

// 입금 계좌 정보를 가져오는 FutureProvider
final accountNumberProvider = FutureProvider<String>((ref) async {
  // orderRepositoryProvider를 통해 발주 레포지토리 인스턴스를 가져옴
  final repository = ref.read(orderRepositoryProvider);
  // 입금 계좌 정보를 가져와 반환함
  return await repository.fetchAccountNumber();
});

// OrderlistRepository를 제공하는 Provider
final orderlistRepositoryProvider = Provider((ref) => OrderlistRepository(firestore: FirebaseFirestore.instance));

// // 발주 목록 화면 내 특정 계정의 발주 관련 데이터를 불러오는 OrderlistRepository 인스턴스를 제공하여
// // 해당 레퍼지토리의 fetchOrdersByEmail 메서드를 활용하는 FutureProvider
// final orderListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
//   // Firestore 인스턴스를 사용하여 OrderlistRepository 인스턴스를 생성.
//   final repository = OrderlistRepository(firestore: FirebaseFirestore.instance);
//   // 현재 로그인된 사용자의 이메일을 가져옴.
//   final userEmail = FirebaseAuth.instance.currentUser?.email;
//   // 만약 사용자가 로그인되어 있지 않으면 예외를 발생시킴.
//   if (userEmail == null) {
//     throw Exception('User not logged in');
//   }
//   // 사용자 이메일로 발주 목록을 가져와서 반환.
//   return repository.fetchOrdersByEmail(userEmail);
// });
//
// // 발주 삭제를 위한 provider
// final deleteOrderProvider = FutureProvider.family<void, Map<String, String>>((ref, params) async {
//   final repository = OrderlistRepository(firestore: FirebaseFirestore.instance);
//   final userEmail = FirebaseAuth.instance.currentUser?.email;
//
//   if (userEmail == null) {
//     throw Exception('User not logged in');
//   }
//
//   // 발주 삭제 함수 호출
//   await repository.fetchDeleteOrders(userEmail, params['orderNumber']!);
//
//   // 삭제 후 발주 목록을 다시 불러오도록 orderListProvider를 무효화
//   ref.invalidate(orderListProvider);
// });
//
//
// // 발주 목록 상세 화면 내 특정 발주번호의 발주 관련 데이터를 불러오는 OrderlistRepository 인스턴스를 제공하여
// // 해당 레퍼지토리의 fetchOrderByOrderNumber 메서드를 활용하는 FutureProvider
// final orderListDetailProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, orderNumber) async {
//   // FirebaseFirestore 인스턴스를 사용하여 OrderlistRepository 인스턴스를 생성
//   final repository = OrderlistRepository(firestore: FirebaseFirestore.instance);
//
//   // 현재 로그인한 사용자의 이메일을 가져옴
//   final userEmail = FirebaseAuth.instance.currentUser?.email;
//
//   // 사용자가 로그인하지 않은 경우 예외를 발생시킴
//   if (userEmail == null) {
//     throw Exception('User not logged in');
//   }
//
//   // 레포지토리의 fetchOrderByOrderNumber 메서드를 호출하여 발주 번호에 맞는 데이터를 가져옴
//   return repository.fetchOrderByOrderNumber(userEmail, orderNumber);
// });

// '환불' 버튼과 '리뷰 작성' 버튼의 활성화 체크에 필요한 데이터를 받아오는 buttonInfoProvider
// FutureProvider.family를 사용하여 비동기적으로 데이터를 제공하는 provider를 생성하며, String 타입의 발주번호(orderNumber)를 인자로 받도록 했음.
final buttonInfoProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, orderNumber) async {
  // 현재 로그인된 사용자의 이메일을 가져오기 위해 currentUserEmailProvider를 호출하고, 그 결과를 기다리도록 했음.
  final userEmail = await ref.watch(currentUserEmailProvider.future);
  // 이메일이 null일 경우(사용자가 로그인되지 않은 경우) 빈 Map을 반환하여 이후 로직을 실행하지 않도록 했음.
  if (userEmail == null) return {};

  // Firestore에서 'order_list' 컬렉션 내의 특정 이메일에 해당하는 문서(doc)를 참조하고,
  // 그 하위 컬렉션인 'orders'에서 주어진 발주번호(order_number)와 일치하는 문서를 조회하도록 했음.
  final orderDoc = await FirebaseFirestore.instance
      .collection('order_list')
      .doc(userEmail)
      .collection('orders')
      .where('numberInfo.order_number', isEqualTo: orderNumber)
      .get();

  // 조회된 문서가 하나라도 있을 경우, 첫 번째 문서의 참조를 사용하여 하위 컬렉션 'button_info'의 'info' 문서를 가져오도록 했음.
  if (orderDoc.docs.isNotEmpty) {
    final buttonInfoDoc = await orderDoc.docs.first.reference.collection('button_info').doc('info').get();
    // 'info' 문서의 데이터를 반환하며, 문서가 존재하지 않으면 빈 Map을 반환하도록 했음.
    return buttonInfoDoc.data() ?? {};
  } else {
    // 조건에 맞는 문서가 없으면 빈 Map을 반환하도록 했음.
    return {};
  }
});
