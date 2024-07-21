
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/order_repository.dart';


// 이메일을 기반으로 사용자 정보를 가져오는 FutureProvider
final userInfoProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, email) async {
  final repository = OrderRepository();
  return repository.getUserInfoByEmail(email);
});