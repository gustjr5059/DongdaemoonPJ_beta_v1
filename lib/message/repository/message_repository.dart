import 'package:cloud_firestore/cloud_firestore.dart';

// ------ 마이페이지용 쪽지 관리 화면에서 파이어베이스 내 쪽지 관련 데이터를 불러오는 로직인 PrivateMessageRepository 클래스 내용 시작
class PrivateMessageRepository {
  final FirebaseFirestore firestore;

  // PrivateMessageRepository 클래스의 생성자.
  PrivateMessageRepository({required this.firestore});

  // 특정 이메일 계정의 쪽지 목록을 가져오는 함수.
  Future<List<Map<String, dynamic>>> fetchMessages(String email) async {
    // Firestore에서 해당 이메일의 쪽지 목록을 가져옴.
    final snapshot = await firestore
        .collection('message_list')
        .doc(email)
        .collection('message')
        .get();

    // 각 문서의 데이터를 Map 형태로 변환하여 리스트로 반환.
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
// ------ 마이페이지용 쪽지 관리 화면에서 파이어베이스 내 쪽지 관련 데이터를 불러오는 로직인 PrivateMessageRepository 클래스 내용 끝
