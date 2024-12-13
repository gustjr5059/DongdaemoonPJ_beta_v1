import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


// ------ 공지사항 화면 관련 데이터 처리 로직인 AnnouncementRepository 내용 시작 부분
class AnnouncementRepository {
  final FirebaseFirestore firestore; // Firebase Firestore 인스턴스 변수 선언

  AnnouncementRepository({required this.firestore}); // 생성자를 통해 firestore를 초기화함

  // Firestore에서 공지사항 아이템을 페이징하여 가져오는 함수임
  Future<List<Map<String, dynamic>>> getPagedAnnounceItems(
      {DocumentSnapshot? lastDocument, required int limit}) async {
    // final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보를 가져옴
    // final userEmail = user?.email; // 사용자의 이메일 주소를 가져옴
    // if (userEmail == null) throw Exception('사용자가 로그인되어 있지 않습니다.'); // 사용자가 로그인하지 않은 경우 예외를 발생시킴

    print("Firestore에서 ${limit}개씩 데이터를 불러옵니다. 마지막 문서: $lastDocument"); // Firestore에서 지정한 개수만큼 데이터를 불러온다는 메시지를 출력함

    // Firestore에서 공지사항 아이템을 'time' 필드로 내림차순 정렬하고 지정된 개수만큼 데이터를 불러오는 쿼리를 작성함
    Query query = firestore.collection('announcement_list').orderBy('time', descending: true).limit(limit);

    // 마지막 문서가 있을 경우, 해당 문서 이후의 데이터를 불러옴
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument); // 마지막 문서 이후 데이터를 불러오도록 쿼리를 수정함
      print("이전 데이터 이후로 데이터를 불러옵니다."); // 마지막 문서 이후 데이터를 불러온다는 메시지를 출력함
    }

    final querySnapshot = await query.get(); // Firestore 쿼리를 실행하여 결과를 가져옴

    print("가져온 문서 수: ${querySnapshot.docs.length}"); // 가져온 문서의 수를 출력함

    // Firestore에서 가져온 문서를 Map<String, dynamic> 형태로 변환하여 반환함
    return querySnapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // 명시적으로 데이터를 Map<String, dynamic>으로 변환함
      data['document_id'] = doc.id; // 문서의 ID를 'document_id'로 추가함
      data['snapshot'] = doc; // 문서 snapshot을 추가하여 마지막 문서 정보를 기록함
      print("공지사항 문서 처리: document_id=${doc.id}, title=${data['title']}"); // 불러온 공지사항 문서의 ID와 제목을 출력함
      return data; // 변환된 데이터를 반환함
    }).toList(); // 데이터를 리스트로 변환하여 반환함
  }

  // Firestore에서 단일 공지사항 문서를 가져오는 함수임
  Future<Map<String, dynamic>> getAnnounceDetailItem(String documentId) async {
    print("공지사항 상세 데이터 요청 시작: documentId=$documentId"); // 공지사항 상세 데이터를 요청한다는 메시지를 출력함
    try {
      // Firestore에서 특정 documentId에 해당하는 문서를 가져옴
      final DocumentSnapshot doc = await firestore.collection('announcement_list').doc(documentId).get();

      // 문서가 존재하는 경우
      if (doc.exists) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // 문서 데이터를 Map<String, dynamic>으로 변환함
        data['document_id'] = doc.id; // 문서 ID를 'document_id'로 추가함
        data['snapshot'] = doc; // 문서 snapshot을 추가함
        print("공지사항 문서 처리: document_id=${doc.id}, title=${data['title']}"); // 불러온 공지사항 문서의 ID와 제목을 출력함
        return data; // 문서 데이터를 반환함
      } else {
        print("공지사항 문서가 존재하지 않음: documentId=$documentId"); // 문서가 존재하지 않음을 알리는 메시지를 출력함
        return {}; // 빈 Map을 반환함
      }
    } catch (error) {
      print("공지사항 상세 데이터 요청 실패: $error"); // 요청 실패 시 에러 메시지를 출력함
      throw error; // 에러를 던짐
    }
  }
}
// ------ 공지사항 화면 관련 데이터 처리 로직인 AnnouncementRepository 내용 끝 부분