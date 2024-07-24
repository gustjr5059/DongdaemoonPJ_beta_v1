
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../product/model/product_model.dart';
import '../repository/order_repository.dart';


// 이메일을 기반으로 사용자 정보를 가져오는 FutureProvider
final userInfoProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, email) async {
  final repository = OrderRepository(firestore: FirebaseFirestore.instance);
  return repository.getUserInfoByEmail(email);
});

// 주소 검색 기능을 제공하는 FutureProvider
final addressSearchProvider = FutureProvider.family<List<dynamic>, String>((ref, query) async {
  final repository = OrderRepository(firestore: FirebaseFirestore.instance);
  return repository.searchAddress(query);
});

// 주문 레포지토리를 제공하는 프로바이더
final orderRepositoryProvider = Provider((ref) => OrderRepository(firestore: FirebaseFirestore.instance));

// 발주 처리 함수
final placeOrderProvider = FutureProvider.family<void, List<ProductContent>>((ref, items) async {
  final repository = ref.read(orderRepositoryProvider);
  await repository.placeOrder(items);
});