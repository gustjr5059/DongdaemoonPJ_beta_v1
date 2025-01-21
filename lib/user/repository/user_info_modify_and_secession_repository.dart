
import 'package:cloud_firestore/cloud_firestore.dart';


class UserInfoModifyRepository {
  final FirebaseFirestore firestore;

  UserInfoModifyRepository({required this.firestore});

  // 로그인한 사용자의 이메일을 통해 Firestore에서 사용자 정보를 가져오는 함수
  Future<Map<String, dynamic>?> modifyGetUserInfoByEmail(String email) async {
    try {
      print('사용자 정보 불러오기 시작: $email');

      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('registration_id', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('사용자 정보 찾음: $email');
        return querySnapshot.docs.first.data() as Map<String, dynamic>?;
      } else {
        print('사용자 정보 없음: $email');
        return null;
      }
    } catch (e) {
      print('사용자 정보 불러오기 오류: $e');
      return null;
    }
  }

  // Firestore에 수정된 사용자 정보를 저장하는 함수
  Future<void> updateUserInfo(String email, Map<String, dynamic> updatedData) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('registration_id', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        await firestore.collection('users').doc(docId).update(updatedData);
        print('사용자 정보 업데이트 완료: $updatedData');
      } else {
        print('업데이트할 사용자 정보 없음: $email');
      }
    } catch (e) {
      print('사용자 정보 업데이트 오류: $e');
    }
  }
}
