
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/user_info_modify_and_secession_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 회원정보 수정 관련 UserInfoModifyRepository 인스턴스를 생성하는 Provider1
final userInfoModifyRepositoryProvider = Provider<UserInfoModifyRepository>(
      (ref) => UserInfoModifyRepository(firestore: FirebaseFirestore.instance),
);

// // 회원정보 수정 관련 UserInfoModifyRepository 인스턴스를 생성하는 Provider2
final modifyUserInfoProvider = FutureProvider.family<Map<String, dynamic>?, String>(
      (ref, email) async {
    final repository = ref.watch(userInfoModifyRepositoryProvider);
    return await repository.modifyGetUserInfoByEmail(email);
  },
);

// 회원탈퇴용 UserSecessionRepository 인스턴스를 생성하는 Provider
final userSecessionRepositoryProvider = Provider<UserSecessionRepository>(
      (ref) => UserSecessionRepository(firestore: FirebaseFirestore.instance),
);


