import 'package:cloud_firestore/cloud_firestore.dart';


// ------ 관리자용 리뷰 관리 화면에서 리뷰 데이터를 처리하는 로직인 AdminReviewRepository 내용 시작 부분
class AdminReviewRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스를 저장하는 변수

  AdminReviewRepository(
      {required this.firestore}); // Firestore 인스턴스를 초기화하는 생성자

  // ——— 모든 사용자 이메일을 가져오는 함수 시작 부분
  // Firestore의 'users' 컬렉션에서 모든 사용자 이메일을 가져오고 특정 이메일을 필터링하여 반환함
  Future<List<String>> fetchAllUserEmails() async {
    try {
      print(
          'Firestore에서 모든 사용자 이메일을 가져오는 중...'); // Firestore에서 사용자 이메일 가져오기 시도 중임을 디버깅 로그로 출력
      final querySnapshot = await firestore
          .collection('users')
          .get(); // Firestore의 'users' 컬렉션에서 모든 문서를 가져오는 코드

      print(
          'Firestore에서 ${querySnapshot.docs.length}명의 사용자를 가져옴.'); // Firestore에서 몇 명의 사용자를 가져왔는지 디버깅 로그로 출력

      final emailList = querySnapshot.docs // 가져온 문서들에서
          .map((doc) =>
      doc.data()['email'] as String) // 각 문서 데이터의 'email' 필드를 추출함
          .where((email) =>
      email.isNotEmpty &&
          email !=
              'gshe.couture@gmail.com') // 이메일이 비어 있지 않고 특정 이메일이 아닌 경우에만 필터링함
          .toList(); // 필터링된 이메일을 리스트로 변환함

      print(
          '유효한 이메일 ${emailList.length}개를 필터링함.'); // 필터링된 이메일 수를 디버깅 로그로 출력
      return emailList; // 필터링된 이메일 리스트를 반환함
    } catch (e) {
      print('사용자 이메일 가져오기 중 오류 발생: $e'); // 이메일 가져오는 중 발생한 오류를 디버깅 로그로 출력
      throw Exception('사용자 이메일을 가져오는 데 실패: $e'); // 예외를 발생시켜 외부로 오류를 전달함
    }
  }
  // ——— 모든 사용자 이메일을 가져오는 함수 끝 부분

  // ——— 특정 사용자의 모든 리뷰 데이터를 페이징 처리하여 가져오는 함수 시작 부분
  // Firestore에서 특정 사용자의 리뷰 데이터를 정렬 및 페이징 처리하여 가져옴
  Future<List<Map<String, dynamic>>> getPagedReviewItemsList({
    required String userEmail, // 사용자 이메일
    DocumentSnapshot? lastDocument, // 이전 페이지의 마지막 문서 (페이징 시작점)
    required int limit, // 가져올 리뷰 데이터 수의 제한
  }) async {
    try {
      print("사용자 $userEmail의 리뷰 $limit개를 가져오는 중"); // 리뷰 데이터 가져오기 시작 로그 출력

      // Firestore 쿼리 생성
      Query query = firestore
          .collection('wearcano_review_list') // 리뷰 리스트 컬렉션 참조
          .doc(userEmail) // 사용자별 문서를 참조함
          .collection('reviews') // 하위 'reviews' 컬렉션 참조
          .orderBy('review_write_time', descending: true) // 작성 시간 내림차순 정렬
          .limit(limit); // 데이터 개수 제한 설정

      // 이전 페이지 마지막 문서부터 데이터 가져오기 설정
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument); // 페이징 시작점을 설정함
      }

      // 쿼리 실행 및 결과 가져오기
      final querySnapshot = await query.get();

      print("사용자 $userEmail의 리뷰 ${querySnapshot.docs.length}개를 성공적으로 가져옴"); // 가져온 리뷰 개수 디버깅 로그로 출력

      // 가져온 데이터를 리스트로 변환하여 반환
      return querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data =
        doc.data() as Map<String, dynamic>; // 문서 데이터를 Map으로 변환함
        data['id'] = doc.id; // 문서 ID를 데이터에 추가함
        data['separator_key'] = doc.id; // 문서 ID를 고유 키로 설정함
        data['snapshot'] = doc; // 원본 문서 Snapshot을 저장함
        return data; // 변환된 데이터를 반환함
      }).toList();
    } catch (e) {
      print('사용자 $userEmail의 리뷰 데이터를 가져오는 중 오류 발생: $e'); // 리뷰 데이터 가져오기 중 오류를 디버깅 로그로 출력
      throw Exception('리뷰 데이터를 가져오는 데 실패: $e'); // 예외를 발생시켜 외부로 오류를 전달함
    }
  }
  // ——— 특정 사용자의 모든 리뷰 데이터를 페이징 처리하여 가져오는 함수 끝 부분

  // ——— 특정 리뷰를 삭제하는 함수 시작 부분
  // Firestore에서 특정 사용자의 특정 리뷰 데이터를 삭제함
  Future<void> deleteReview({
    required String userEmail, // 특정 사용자의 이메일
    required String separatorKey, // 삭제할 리뷰의 고유 키
  }) async {
    try {
      print(
          '사용자 $userEmail의 리뷰 $separatorKey 삭제 시도 중...'); // 특정 리뷰 삭제 시도를 디버깅 로그로 출력
      final reviewDoc = firestore
          .collection('wearcano_review_list') // 리뷰 리스트 컬렉션 참조
          .doc(userEmail) // 사용자별 문서를 참조
          .collection('reviews') // 하위 'reviews' 컬렉션 참조
          .doc(separatorKey); // 삭제할 리뷰 문서 참조

      // 문서 존재 여부 확인
      final docSnapshot = await reviewDoc.get();

      if (docSnapshot.exists) {
        await reviewDoc.delete(); // 문서가 존재하면 삭제를 수행함
        print(
            '사용자 $userEmail의 리뷰 $separatorKey 삭제 성공.'); // 리뷰 삭제 성공 로그 출력
      } else {
        print("고유 키: $separatorKey에 해당하는 문서를 찾을 수 없음"); // 문서가 없음을 디버깅 로그로 출력
        throw Exception('고유 키: $separatorKey에 해당하는 문서를 찾을 수 없음'); // 예외 발생
      }
    } catch (e) {
      print(
          '사용자 $userEmail의 리뷰 $separatorKey 삭제 중 오류 발생: $e'); // 리뷰 삭제 중 오류 디버깅 로그로 출력
      throw Exception('리뷰 삭제 실패: $e'); // 예외를 발생시켜 외부로 오류를 전달함
    }
  }
// ——— 특정 리뷰를 삭제하는 함수 끝 부분
}
// ------ 관리자용 리뷰 관리 화면에서 리뷰 데이터를 처리하는 로직인 AdminReviewRepository 내용 끝 부분