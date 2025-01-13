
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/drawer_user_repository.dart';


// UserRepository() 인스턴스를 불러오는 drawerUserNameProvider
final drawerUserNameProvider = FutureProvider.family<String?, String>((ref, email) async {
  final userRepository = UserRepository();
  if (email == null || email.isEmpty) {
    // 이메일이 null이거나 빈 문자열이면 null 반환
    return null;
  }
  return await userRepository.getUserNameByEmail(email);
});