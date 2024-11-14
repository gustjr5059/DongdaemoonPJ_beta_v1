import 'package:cloud_firestore/cloud_firestore.dart'; // Cloud Firestore 패키지를 임포트

// ------ 마이페이지 화면 내 파이어베이스에서 데이터를 불러오기 위한 레퍼지토리인 ProfileRepository 클래스 내용 시작 부분
class ProfileRepository {
  final FirebaseFirestore firestore; // FirebaseFirestore 인스턴스를 저장할 변수를 선언.

  ProfileRepository({required this.firestore}); // 생성자를 통해 firestore 인스턴스를 초기화.

  // ------ 마이페이지 화면 내 회원정보에 관련 정보를 파이어베이스에서 불러오는 로직인 getUserInfoByEmail 함수 내용 시작 부분
  Future<Map<String, dynamic>?> getUserInfoByEmail(String email) async { // 이메일을 통해 사용자 정보를 가져오는 비동기 함수를 정의.
    try {
      print('이메일로 사용자 정보 가져오는 중: $email'); // 이메일을 통해 사용자 정보를 가져오기 시작함을 알림.

      QuerySnapshot querySnapshot = await firestore // Firestore에 쿼리를 보내기 위해 QuerySnapshot 객체를 선언.
          .collection('users') // 'users' 컬렉션을 참조.
          .where('email', isEqualTo: email) // 이메일 필드가 주어진 이메일과 일치하는 문서를 찾음.
          .get(); // 쿼리를 실행하여 결과를 가져옴.

      print('검색된 문서 수: ${querySnapshot.docs.length}'); // 검색된 문서의 수를 출력.

      if (querySnapshot.docs.isNotEmpty) { // 쿼리 결과에 문서가 하나 이상 있는지 확인.
        print('해당 이메일의 사용자 문서를 찾음: $email'); // 해당 이메일에 대한 사용자 문서를 찾았음을 알림.
        return querySnapshot.docs.first.data() as Map<String, dynamic>?; // 첫 번째 문서의 데이터를 Map<String, dynamic> 형으로 반환.
      } else {
        print('해당 이메일의 사용자 문서를 찾지 못함: $email'); // 해당 이메일에 대한 사용자 문서를 찾지 못했음을 알림.
        return null; // 문서가 없으면 null을 반환.
      }
    } catch (e) { // 오류가 발생하면 catch 블록이 실행.
      print('이메일 $email의 사용자 데이터를 가져오는 중 오류 발생: $e'); // 오류 메시지를 콘솔에 출력.
      return null; // null을 반환.
    }
  }
}
// ------ 마이페이지 화면 내 회원정보에 관련 정보를 파이어베이스에서 불러오는 로직인 getUserInfoByEmail 함수 내용 끝 부분
// ------ 마이페이지 화면 내 파이어베이스에서 데이터를 불러오기 위한 레퍼지토리인 ProfileRepository 클래스 내용 끝 부분