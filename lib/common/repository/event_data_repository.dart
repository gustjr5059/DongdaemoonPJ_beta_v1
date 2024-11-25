import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ------ EventRepository 클래스 내용 시작
class EventRepository {
  final FirebaseFirestore firestore; // FirebaseFirestore 인스턴스를 저장함

  // 생성자, firestore 인스턴스를 전달받아 초기화함
  EventRepository({required this.firestore});

  // ------ event 이미지 URL을 가져오는 함수 시작 부분
  // event 이미지 URL을 가져오는 함수
  Future<String?> fetchEventImage() async {
    try {
      // Firestore에서 'event_data' 컬렉션의 'appbar' 문서를 가져옴
      DocumentSnapshot doc = await firestore
          .collection('event_data')
          .doc('appbar')
          .get();

      // event_img 필드 값을 콘솔에 출력하여 확인함
      print('가져온 event_img: ${doc['event_img']}');

      // event_img 필드 값을 String으로 변환하여 반환함
      return doc['event_img'] as String?;
    } catch (e) {
      // 에러 발생 시, 에러 메시지를 콘솔에 출력함
      print('event 이미지 가져오는 중 오류 발생: $e');
      return null; // 에러가 발생하면 null을 반환함
    }
  }

  // ------ title 이미지 URL을 가져오는 함수 시작 부분
  // title 이미지 URL을 가져오는 함수
  Future<String?> fetchTitleImage() async {
    try {
      // Firestore에서 'event_data' 컬렉션의 'appbar' 문서를 가져옴
      DocumentSnapshot doc = await firestore
          .collection('event_data')
          .doc('appbar')
          .get();

      // title_img 필드 값을 콘솔에 출력하여 확인함
      print('가져온 title_img: ${doc['title_img']}');

      // title_img 필드 값을 String으로 변환하여 반환함
      return doc['title_img'] as String?;
    } catch (e) {
      // 에러 발생 시, 에러 메시지를 콘솔에 출력함
      print('title 이미지 가져오는 중 오류 발생: $e');
      return null; // 에러가 발생하면 null을 반환함
    }
  }

  // ------ 이벤트 포스터 상품 데이터를 가져오는 함수 시작 부분
  // 이벤트 포스터 상품 데이터를 가져오는 함수
  Future<List<Map<String, dynamic>>> getPagedEventPosterImgItems(
      {DocumentSnapshot? lastDocument, required int limit}) async {
    // final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보를 가져옴
    // final userEmail = user?.email; // 사용자의 이메일 주소를 가져옴
    // if (userEmail == null) throw Exception('사용자가 로그인하지 않았습니다'); // 사용자가 로그인하지 않은 경우 예외를 발생시킴

    print("Firestore에서 ${limit}개씩 데이터를 불러옵니다. 마지막 문서: $lastDocument"); // Firestore에서 지정한 갯수만큼 데이터를 불러온다는 메시지를 출력함

    // Firestore 쿼리에서 boolExistence가 true인 문서만 가져오고, boolExistence와 sequence 필드로 정렬
    Query query = firestore
        .collection('event_data')
        .doc('event_poster_image')
        .collection('poster_img')
        .where('boolExistence', isEqualTo: true) // boolExistence가 true인 문서만 가져옴
        .orderBy('sequence', descending: false) // sequence 필드를 오름차순으로 정렬
        .limit(limit);

    // 마지막 문서가 있을 경우, 해당 문서 이후의 데이터를 불러옴
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument); // 마지막 문서 이후부터 데이터를 불러옴
      print("이전 데이터 이후로 데이터를 불러옵니다."); // 마지막 문서 이후 데이터를 불러온다는 메시지를 출력함
    }

    final querySnapshot = await query.get(); // Firestore 쿼리를 실행하여 결과를 가져옴

    print("가져온 문서 수: ${querySnapshot.docs.length}"); // 가져온 문서의 수를 출력함

    // querySnapshot.docs.map()에서 반환되는 데이터를 정확히 Map<String, dynamic>으로 변환함
    return querySnapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String,
          dynamic>; // 명시적으로 데이터를 Map<String, dynamic>으로 캐스팅함
      data['id'] = doc.id; // 문서의 ID를 명시적으로 추가함
      data['snapshot'] = doc; // 마지막 문서를 기록함
      print("이벤트 포스터 이미지 문서 처리: id=${doc.id}, poster_img=${data['poster_img']}"); // 불러온 이벤트 포스터 이미지 문서의 ID와 이미지 데이터를 출력함
      return data;
    }).toList(); // 데이터를 리스트로 변환하여 반환함
  }

  // ------ 이벤트 포스터 상품의 모든 이미지 URL을 가져오는 함수 getEventPosterOriginalImages 시작 부분
  // 특정 documentId를 통해 이벤트 포스터의 원본 이미지를 Firestore에서 가져오는 함수 정의
  Future<List<String>> getEventPosterOriginalImages(String documentId) async {
    try {
      // Firestore에서 'event_data' 컬렉션의 'event_poster_image' 문서 하위의
      // 'poster_img' 컬렉션 내에서 documentId에 해당하는 문서를 가져옴
      DocumentSnapshot doc = await firestore
          .collection('event_data')
          .doc('event_poster_image')
          .collection('poster_img')
          .doc(documentId)
          .get();

      // 이미지 URL들을 저장할 리스트 초기화
      List<String> images = [];

      // 최대 10개의 포스터 이미지 URL을 불러오기 위해 반복문 실행
      for (int i = 1; i <= 10; i++) {
        // 각 포스터 필드 이름을 'poster_i'로 지정하여 이미지 URL을 가져옴
        final String? imageUrl = doc['poster_$i'] as String?;

        // 유효한 이미지 URL이 있으면 리스트에 추가하고 해당 URL을 콘솔에 출력
        if (imageUrl != null && imageUrl.isNotEmpty) {
          images.add(imageUrl);
          print("포스터_$i 필드에서 이미지 URL 추가: $imageUrl");
        } else {
          // 해당 포스터 필드에 이미지 URL이 없을 경우 메시지 출력
          print("포스터_$i 필드에 유효한 이미지 URL이 없습니다.");
        }
      }

      // 가져온 이미지 URL 리스트가 비어 있는지 확인하고, 상태에 따른 메시지 출력
      if (images.isEmpty) {
        print("가져온 이미지가 없습니다."); // 이미지가 없을 경우 메시지 출력
      } else {
        print("총 ${images.length}개의 이미지를 불러왔습니다."); // 이미지 수를 출력
      }

      // 최종적으로 이미지 URL 리스트를 반환
      return images;
    } catch (e) {
      // 오류가 발생할 경우, 오류 메시지를 출력하고 빈 리스트를 반환
      print("이벤트 이미지 가져오는 중 오류 발생: $e");
      return [];
    }
  }
// ------ 이벤트 포스터 상품의 모든 이미지 URL을 가져오는 함수 getEventPosterOriginalImages 끝 부분
}
// ------ EventRepository 클래스 내용 끝