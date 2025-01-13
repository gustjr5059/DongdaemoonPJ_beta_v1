
import 'package:cloud_firestore/cloud_firestore.dart';


// ------ 드로워화면 내 'users' 컬렉션 내 문서의 'name' 필드값을 불러오는 데이터 처리 로직인 UserRepository 클래스 시작 부분
class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getUserNameByEmail(String email) async {
    print('사용자 이름 가져오기 시작: 이메일 - $email'); // 이메일로 시작하는 메시지

    try {
      print('Firestore에서 사용자 문서 가져오기 시도 중...'); // Firestore 문서 조회 시도 메시지

      // final snapshot = await _firestore.collection('users').doc(email).get();
      //
      // if (snapshot.exists) {
      //   print('Firestore 문서 가져오기 성공: ${snapshot.data()}'); // 가져온 데이터 출력

      // 기존: doc(email).get() -> 문서가 없으면 snapshot.exists = false
      // 변경: where('registration_id', isEqualTo: email)
      // 위 쿼리로 문서를 찾고, 첫 문서만 name 필드를 읽어오도록 로직 수정
      // signInWithApple()에서 신규 회원 처리 부분 내 signUpEmail: user.email ?? ''로
      // 첫 애플 로그인 하면서 저장된 가리기를 통한 특별한 이메일 형식 또는 원래 이메일 형식 상관없이 담은 'registration_id' 필드값으로
      // 이메일 값으로 인식해서 해당 문서 내 'name' 필드값을 불러오도록 로직 변경
      final querySnapshot = await _firestore
          .collection('users')
          .where('registration_id', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('해당 email로 가입된 문서가 없습니다: 이메일 - $email');
        return null; // 문서가 없으면 null
      }

      // 여러 문서가 있더라도 limit(1)로 제한했으므로 첫 번째 문서만 사용
      final userDoc = querySnapshot.docs.first;
      print('Firestore 문서 가져오기 성공: ${userDoc.data()}');

        final userName = userDoc.data()?['name'] as String?;
        if (userName != null) {
          print('가져온 사용자 이름: $userName'); // 사용자 이름이 성공적으로 추출된 경우
          return userName;
        } else {
          print('사용자 이름이 null입니다.'); // 사용자 이름이 null인 경우
        }
    } catch (e) {
      print('Firestore에서 사용자 이름을 가져오는 중 오류 발생: $e'); // 오류 발생 메시지
    }

    print('사용자 이름 가져오기 실패: null 반환'); // 최종적으로 null 반환되는 경우
    return null;
  }
}
// ------ 드로워화면 내 'users' 컬렉션 내 문서의 'name' 필드값을 불러오는 데이터 처리 로직인 UserRepository 클래스 끝 부분