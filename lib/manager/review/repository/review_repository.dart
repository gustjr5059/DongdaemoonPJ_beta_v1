import 'package:cloud_firestore/cloud_firestore.dart';


// ------ 관리자용 리뷰 관리 화면에서 리뷰 데이터를 처리하는 로직인 AdminReviewRepository 내용 시작 부분
class AdminReviewRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스를 저장하는 변수

  AdminReviewRepository({required this.firestore}); // 생성자를 통해 Firestore 인스턴스를 초기화하는 코드

  // 모든 사용자 이메일을 가져오는 함수
  // 특정 이메일('gshe.couture@gmail.com')을 필터링하여 사용자 목록 반환
  Future<List<String>> fetchAllUserEmails() async {
    try {
      print('Fetching all user emails from Firestore...'); // Firestore에서 모든 사용자 이메일을 가져오려는 시도임을 로그에 기록
      final querySnapshot = await firestore.collection('users').get(); // Firestore의 'users' 컬렉션에서 모든 문서를 가져오는 코드

      print('Fetched ${querySnapshot.docs.length} users from Firestore.'); // 몇 명의 사용자를 가져왔는지 로그에 기록

      final emailList = querySnapshot.docs // 가져온 문서들에서
          .map((doc) => doc.data()['email'] as String) // 각 문서의 데이터에서 이메일 필드를 추출한 후
          .where((email) => email.isNotEmpty && email != 'gshe.couture@gmail.com') // 이메일이 비어 있지 않거나 특정 이메일이 아닌 경우에만
          .toList(); // 리스트로 변환하는 코드

      print('Filtered email list: ${emailList.length} valid emails found.'); // 필터링된 이메일 수를 로그에 기록
      return emailList; // 필터링된 이메일 리스트를 반환
    } catch (e) {
      print('Error fetching user emails: $e'); // 이메일을 가져오는 중에 발생한 오류를 로그에 기록
      throw Exception('Failed to fetch user emails: $e'); // 예외를 발생시켜 오류를 외부로 전달
    }
  }

  // 특정 사용자의 모든 리뷰 데이터를 실시간으로 가져오는 함수
  Stream<List<Map<String, dynamic>>> streamAllReviewsByEmail(String userEmail) {
    try {
      print('Starting to stream reviews for user: $userEmail...'); // 특정 사용자의 리뷰 데이터를 스트리밍 시작하는 로그를 기록
      return firestore
          .collection('review_list') // 'review_list' 컬렉션에서
          .doc(userEmail) // 특정 사용자의 이메일 문서를 참조한 후
          .collection('reviews') // 그 안의 'reviews' 하위 컬렉션에서
          .orderBy('review_write_time', descending: true) // 'review_write_time' 기준으로 내림차순 정렬하여
          .snapshots() // 실시간 스트리밍을 수행하는 코드
          .map((snapshot) {
        print('Received ${snapshot.docs.length} reviews for user: $userEmail.'); // 스트리밍을 통해 몇 개의 리뷰를 받았는지 로그에 기록
        return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList(); // 각 리뷰 데이터를 리스트로 변환하여 반환
      });
    } catch (e) {
      print('Error streaming reviews for user $userEmail: $e'); // 리뷰 스트리밍 중 발생한 오류를 로그에 기록
      throw Exception('Failed to stream reviews: $e'); // 예외를 발생시켜 오류를 외부로 전달
    }
  }

  // 특정 리뷰를 삭제하는 함수
  Future<void> deleteReview({
    required String userEmail, // 특정 사용자의 이메일
    required String separatorKey, // 삭제할 리뷰의 고유 키
  }) async {
    try {
      print('Attempting to delete review for user: $userEmail, key: $separatorKey...'); // 특정 리뷰를 삭제하려는 시도를 로그에 기록
      final reviewDoc = firestore
          .collection('review_list') // 'review_list' 컬렉션에서
          .doc(userEmail) // 특정 사용자의 이메일 문서를 참조한 후
          .collection('reviews') // 그 안의 'reviews' 하위 컬렉션에서
          .doc(separatorKey); // 삭제할 리뷰의 문서를 참조하는 코드

      await reviewDoc.delete(); // 해당 리뷰 문서를 삭제하는 코드
      print('Successfully deleted review for user: $userEmail, key: $separatorKey.'); // 리뷰 삭제 성공을 로그에 기록
    } catch (e) {
      print('Error deleting review for user $userEmail, key $separatorKey: $e'); // 리뷰 삭제 중 발생한 오류를 로그에 기록
      throw Exception('Failed to delete review: $e'); // 예외를 발생시켜 오류를 외부로 전달
    }
  }
}
// ------ 관리자용 리뷰 관리 화면에서 리뷰 데이터를 처리하는 로직인 AdminReviewRepository 내용 끝 부분