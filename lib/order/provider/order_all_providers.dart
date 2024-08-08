import 'package:cloud_firestore/cloud_firestore.dart'; // 클라우드 파이어스토어 라이브러리 임포트
import 'package:firebase_auth/firebase_auth.dart'; // 파이어베이스 인증 라이브러리 임포트
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위한 Riverpod 라이브러리 임포트
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

// 발주 목록 내 특정 계정의 발주 관련 데이터를 불러오는 OrderlistRepository 인스턴스를 제공하는 FutureProvider
final orderListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  // Firestore 인스턴스를 사용하여 OrderlistRepository 인스턴스를 생성.
  final repository = OrderlistRepository(firestore: FirebaseFirestore.instance);
  // 현재 로그인된 사용자의 이메일을 가져옴.
  final userEmail = FirebaseAuth.instance.currentUser?.email;
  // 만약 사용자가 로그인되어 있지 않으면 예외를 발생시킴.
  if (userEmail == null) {
    throw Exception('User not logged in');
  }
  // 사용자 이메일로 발주 목록을 가져와서 반환.
  return repository.fetchOrdersByEmail(userEmail);
});