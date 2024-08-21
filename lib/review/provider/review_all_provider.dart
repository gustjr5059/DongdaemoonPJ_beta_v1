import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/review_repository.dart';

// ReviewScreenTab enum 정의
enum ReviewScreenTab { create, list }

// Firestore 인스턴스를 사용하여 ReviewRepository를 생성하는 Provider
final reviewRepositoryProvider = Provider((ref) => ReviewRepository(firestore: FirebaseFirestore.instance));

// 특정 사용자의 발주 데이터를 가져오는 Provider
final reviewUserOrdersProvider = FutureProvider.family((ref, String userEmail) async {
  // reviewRepositoryProvider를 읽어서 ReviewRepository 인스턴스를 가져옴
  final repository = ref.read(reviewRepositoryProvider);
  // fetchOrdersByEmail 함수를 호출하여 특정 사용자의 발주 데이터를 가져옴
  return await repository.fetchOrdersByEmail(userEmail);
});
