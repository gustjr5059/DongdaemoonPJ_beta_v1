import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/orderlist_repository.dart';

// Repository Provider 설정
final orderlistRepositoryProvider = Provider((ref) => OrderlistRepository(firestore: FirebaseFirestore.instance));

// 모든 사용자의 발주 데이터를 가져오는 Provider
final allOrdersProvider = FutureProvider((ref) async {
  final repository = ref.read(orderlistRepositoryProvider);
  return await repository.fetchAllOrdersForAdmin();
});

// 특정 사용자의 발주 데이터를 가져오는 Provider
final userOrdersProvider = FutureProvider.family((ref, String userId) async {
  final repository = ref.read(orderlistRepositoryProvider);
  return await repository.fetchOrdersByUser(userId);
});
