
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/user_info_modify_and_secession_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final userInfoModifyRepositoryProvider = Provider<UserInfoModifyRepository>(
      (ref) => UserInfoModifyRepository(firestore: FirebaseFirestore.instance),
);

final modifyUserInfoProvider = FutureProvider.family<Map<String, dynamic>?, String>(
      (ref, email) async {
    final repository = ref.watch(userInfoModifyRepositoryProvider);
    return await repository.modifyGetUserInfoByEmail(email);
  },
);
