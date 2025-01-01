
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/drawer_user_repository.dart';


// UserRepository() 인스턴스를 불러오는 drawerUserNameProvider
final drawerUserNameProvider = FutureProvider.family<String?, String>((ref, email) async {
  final userRepository = UserRepository();
  return await userRepository.getUserNameByEmail(email);
});
