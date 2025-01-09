
import 'package:cloud_firestore/cloud_firestore.dart';


// ------ 드로워화면 내 'users' 컬렉션 내 문서의 'name' 필드값을 불러오는 데이터 처리 로직인 UserRepository 클래스 시작 부분
class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getUserNameByEmail(String email) async {
    print('사용자 이름 가져오기 시작: 이메일 - $email'); // 이메일로 시작하는 메시지

    try {
      print('Firestore에서 사용자 문서 가져오기 시도 중...'); // Firestore 문서 조회 시도 메시지

      final snapshot = await _firestore.collection('users').doc(email).get();

      if (snapshot.exists) {
        print('Firestore 문서 가져오기 성공: ${snapshot.data()}'); // 가져온 데이터 출력

        final userName = snapshot.data()?['name'] as String?;
        if (userName != null) {
          print('가져온 사용자 이름: $userName'); // 사용자 이름이 성공적으로 추출된 경우
          return userName;
        } else {
          print('사용자 이름이 null입니다.'); // 사용자 이름이 null인 경우
        }
      } else {
        print('Firestore 문서가 존재하지 않습니다: 이메일 - $email'); // 문서가 없는 경우
      }
    } catch (e) {
      print('Firestore에서 사용자 이름을 가져오는 중 오류 발생: $e'); // 오류 발생 메시지
    }

    print('사용자 이름 가져오기 실패: null 반환'); // 최종적으로 null 반환되는 경우
    return null;
  }
}
// ------ 드로워화면 내 'users' 컬렉션 내 문서의 'name' 필드값을 불러오는 데이터 처리 로직인 UserRepository 클래스 끝 부분