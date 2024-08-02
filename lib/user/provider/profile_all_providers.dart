import 'package:flutter_riverpod/flutter_riverpod.dart'; // flutter_riverpod 패키지를 임포트합니다.
import 'package:cloud_firestore/cloud_firestore.dart'; // Cloud Firestore 패키지를 임포트합니다.
import '../repository/profile_repository.dart'; // profile_repository.dart 파일을 임포트합니다.


// ProfileRepository의 인스턴스를 제공하는 Provider를 정의하고, 여기서 FirebaseFirestore 인스턴스를 전달.
final profileRepositoryProvider = Provider((ref) => ProfileRepository(firestore: FirebaseFirestore.instance));

// 이메일을 매개변수로 받아 사용자 정보를 제공하는 FutureProvider.family를 정의.
final userInfoProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, email) async {
  // profileRepositoryProvider를 사용하여 ProfileRepository 인스턴스를 가져옴.
  final repository = ref.watch(profileRepositoryProvider);
  // ProfileRepository의 getUserInfoByEmail 메서드를 호출하여 사용자 정보를 반환.
  return repository.getUserInfoByEmail(email);
});
