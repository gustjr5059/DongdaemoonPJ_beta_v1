
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

// ------- 회원 탈퇴 시, 데이터 처리 로직 관련 UserSecessionRepository 시작 부분
class UserSecessionRepository {
  final FirebaseFirestore firestore;

  UserSecessionRepository({required this.firestore});

  // ——— 사용자 탈퇴 로직 시작 부분
  // 1) users → secession_users 옮겨담기
  // 2) couture_order_list is_deleted = true
  // 3) couture_request_item 삭제
  // 4) couture_wishlist_item 삭제
  // 5) users 문서 삭제
  Future<void> secessionUser(String userEmail) async {
    // ——— 1) users 컬렉션에서 현재 사용자 문서를 찾는 로직 시작
    // `registration_id` 필드 값이 userEmail과 일치하는 문서를 찾음
    final querySnapshot = await firestore
        .collection('users')
        .where('registration_id', isEqualTo: userEmail)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userDoc = querySnapshot.docs.first;
      final userDocId = userDoc.id; // 원본 users 문서의 문서 ID
      final userData = userDoc.data(); // 해당 문서의 데이터 Map
      print('users 컬렉션에서 사용자 문서를 찾았습니다: $userDocId');

      // ——— 2) secession_users 컬렉션에 사용자 데이터를 저장하는 로직 시작
      // 동일 문서 ID, 동일 필드명/값으로 새 문서 생성하는데 여기에, "secession_time"이라는 새로운 필드를 추가

      // userData는 이미 DB에 있던 필드들만 들어있음.
      // 여기에서 'secession_time'을 새로 추가하기 위해, 아래와 같이 확장(merge)합니다.
      final Map<String, dynamic> updatedUserData = {
        ...userData,  // 기존 userData를 모두 펼쳐서 넣음
        'secession_time': FieldValue.serverTimestamp(),
      };

      // 이제 secession_users 컬렉션의 동일한 문서 ID로 저장
      await firestore
          .collection('secession_users')
          .doc(userDocId)
          .set(updatedUserData);
      print('secession_users 컬렉션에 사용자 데이터를 복사하였습니다: $userDocId');

      // ——— 3) couture_order_list 컬렉션의 각 주문 문서를 업데이트하는 로직 시작
      final orderListRef = firestore
          .collection('couture_order_list')
          .doc(userEmail)
          .collection('orders');

      final orderListSnapshot = await orderListRef.get();

      for (var orderDoc in orderListSnapshot.docs) {
        final buttonInfoRef = orderDoc.reference
            .collection('button_info')
            .doc('info');

        final buttonInfoDoc = await buttonInfoRef.get();
        if (buttonInfoDoc.exists) {
          await buttonInfoRef.update({
            'is_deleted': true,
          });
          print('button_info/info 문서의 is_deleted 필드를 true로 업데이트하였습니다: ${orderDoc.id}');
        } else {
          await buttonInfoRef.set({'is_deleted': true});
          print('button_info/info 문서가 없어 새로 생성하였습니다: ${orderDoc.id}');
        }

        // 해당 발주 문서(`orderDocRef`) 자체도 is_deleted = true로 업데이트
        await orderDoc.reference.update({
          'is_deleted': true,  // 삭제 처리
        });
        print('주문 문서 자체의 is_deleted 필드도 true로 업데이트: ${orderDoc.id}');
      }

      // ——— 4) couture_request_item 컬렉션의 하위 문서를 삭제하는 로직 시작
      final requestRef = firestore
          .collection('couture_request_item')
          .doc(userEmail)
          .collection('items');
      final requestSnapshot = await requestRef.get();

      for (var doc in requestSnapshot.docs) {
        await doc.reference.delete();
        print('couture_request_item 컬렉션의 문서를 삭제하였습니다: ${doc.id}');
      }

      // ——— 5) couture_wishlist_item 컬렉션의 하위 문서를 삭제하는 로직 시작
      final wishlistRef = firestore
          .collection('couture_wishlist_item')
          .doc(userEmail)
          .collection('items');
      final wishlistSnapshot = await wishlistRef.get();

      for (var doc in wishlistSnapshot.docs) {
        await doc.reference.delete();
        print('couture_wishlist_item 컬렉션의 문서를 삭제하였습니다: ${doc.id}');
      }

      // ——— 6) users 컬렉션에서 사용자 문서를 삭제하는 로직 시작
      await firestore
          .collection('users')
          .doc(userDocId)
          .delete();
      print('users 컬렉션에서 사용자 문서를 삭제하였습니다: $userDocId');

      // 회원 탈퇴 로직 완료
    } else {
      // 해당 userEmail로 registration_id를 가진 문서를 찾을 수 없을 경우
      print('users 컬렉션에서 해당 유저의 문서를 찾을 수 없습니다: $userEmail');
      throw Exception('users 컬렉션에서 해당 유저의 문서를 찾을 수 없습니다.');
    }
  }
// ——— 사용자 탈퇴 로직 끝 부분
}
// ------- 회원 탈퇴 시, 데이터 처리 로직 관련 UserSecessionRepository 끝 부분
