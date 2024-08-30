import 'package:cloud_firestore/cloud_firestore.dart';


// ------ 공지사항 화면 관련 데이터 처리 로직인 AnnouncementRepository 내용 시작 부분
class AnnouncementRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에서 공지사항 데이터를 가져오는 함수
  Future<List<Map<String, dynamic>>> fetchAnnouncements() async {
    final snapshot = await _firestore
        .collection('announcement_list')
        .orderBy('time', descending: true)
        .get();

    // 각 문서에서 'document_id' 필드값을 가져와서 데이터에 추가
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['document_id'] = doc.id; // Firestore 문서의 ID를 추가
      return data;
    }).toList();
  }

  // 주어진 documentId로 문서 데이터를 가져오는 함수
  Future<Map<String, dynamic>> fetchAnnouncementById(String documentId) async {
    final doc = await _firestore.collection('announcement_list').doc(documentId).get();

    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      return {}; // 문서가 없을 때 빈 Map 반환
    }
  }
}
// ------ 공지사항 화면 관련 데이터 처리 로직인 AnnouncementRepository 내용 끝 부분