import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../product/model/product_model.dart';
import '../repository/order_repository.dart';

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

// 주문 레포지토리를 제공하는 프로바이더
final orderRepositoryProvider = Provider((ref) => OrderRepository(firestore: FirebaseFirestore.instance));

// 발주 처리 함수
final placeOrderProvider = FutureProvider.family<void, PlaceOrderParams>((ref, params) async {
  // orderRepositoryProvider를 통해 OrderRepository 인스턴스를 가져옴
  final repository = ref.read(orderRepositoryProvider);
  await repository.placeOrder(
    ordererInfo: params.ordererInfo, // 발주자 정보 전달
    recipientInfo: params.recipientInfo, // 수령자 정보 전달
    amountInfo: params.amountInfo, // 결제 정보 전달
    productInfo: params.productInfo, // 상품 정보 전달
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
