import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/orderlist_repository.dart';


// Repository Provider 설정
final adminOrderlistRepositoryProvider = Provider((ref) => AdminOrderlistRepository(firestore: FirebaseFirestore.instance));
// OrderlistRepository 클래스를 Provider로 설정하여 FirebaseFirestore 인스턴스를 전달

// 모든 사용자의 이메일 데이터를 가져오는 Provider
final allUserEmailsProvider = FutureProvider((ref) async {
  final repository = ref.read(adminOrderlistRepositoryProvider);
  // orderlistRepositoryProvider를 읽어서 OrderlistRepository 인스턴스를 가져옴
  return await repository.fetchAllUserEmails();
  // fetchAllUserEmails 함수를 호출하여 모든 사용자의 이메일 데이터를 가져옴
});

// 특정 사용자의 발주 데이터를 가져오는 Provider
final userOrdersProvider = FutureProvider.family((ref, String userEmail) async {
  final repository = ref.read(adminOrderlistRepositoryProvider);
  // adminOrderlistRepositoryProvider를 읽어서 AdminOrderlistRepository 인스턴스를 가져옴
  return await repository.fetchOrdersByEmail(userEmail);
  // fetchOrdersByEmail 함수를 호출하여 특정 사용자의 발주 데이터를 가져옴
});
