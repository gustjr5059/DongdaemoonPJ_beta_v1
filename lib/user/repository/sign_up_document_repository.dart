
import 'package:cloud_firestore/cloud_firestore.dart';


// ------ 회원가입 화면 내 각 동의서 화면 관련 데이터 처리 로직인 SignUpDocumentRepository 내용 시작 부분
class SignUpDocumentRepository {
  final FirebaseFirestore firestore; // Firebase Firestore 인스턴스 변수 선언

  SignUpDocumentRepository({required this.firestore}); // 생성자를 통해 firestore를 초기화함

  // Firestore에서 단일 동의서 문서를 가져오는 함수임
  Future<Map<String, dynamic>> getDocumentDetailItem(String documentId) async {
    print("동의서 상세 데이터 요청 시작: documentId=$documentId"); // 동의서 상세 데이터를 요청한다는 메시지를 출력함
    try {
      // Firestore에서 특정 documentId에 해당하는 문서를 가져옴
      final DocumentSnapshot doc = await firestore.collection('sign_up_document_list').doc(documentId).get();

      // 문서가 존재하는 경우
      if (doc.exists) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // 문서 데이터를 Map<String, dynamic>으로 변환함
        data['document_id'] = doc.id; // 문서 ID를 'document_id'로 추가함
        data['snapshot'] = doc; // 문서 snapshot을 추가함
        print("동의서 문서 처리: document_id=${doc.id}, title=${data['title']}"); // 불러온 동의서 문서의 ID와 제목을 출력함
        return data; // 문서 데이터를 반환함
      } else {
        print("동의서 문서가 존재하지 않음: documentId=$documentId"); // 문서가 존재하지 않음을 알리는 메시지를 출력함
        return {}; // 빈 Map을 반환함
      }
    } catch (error) {
      print("동의서 상세 데이터 요청 실패: $error"); // 요청 실패 시 에러 메시지를 출력함
      throw error; // 에러를 던짐
    }
  }
}
// ------ 회원가입 화면 내 각 동의서 화면 관련 데이터 처리 로직인 SignUpDocumentRepository 내용 끝 부분