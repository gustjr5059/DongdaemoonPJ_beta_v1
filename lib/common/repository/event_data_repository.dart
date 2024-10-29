import 'package:cloud_firestore/cloud_firestore.dart';

// EventRepository 클래스 정의
class EventRepository {
  final FirebaseFirestore firestore; // FirebaseFirestore 인스턴스를 저장함

  // 생성자, firestore 인스턴스를 전달받아 초기화함
  EventRepository({required this.firestore});

  // event 이미지 URL을 가져오는 함수
  Future<String?> fetchEventImage() async {
    try {
      // Firestore에서 'event_data' 컬렉션의 'appbar' 문서를 가져옴
      DocumentSnapshot doc = await firestore
          .collection('event_data')
          .doc('appbar')
          .get();

      // event_img 필드 값을 콘솔에 출력하여 확인함
      print('Fetched event_img: ${doc['event_img']}');

      // event_img 필드 값을 String으로 변환하여 반환함
      return doc['event_img'] as String?;
    } catch (e) {
      // 에러 발생 시, 에러 메시지를 콘솔에 출력함
      print('Error fetching event image: $e');
      return null; // 에러가 발생하면 null을 반환함
    }
  }

  // title 이미지 URL을 가져오는 함수
  Future<String?> fetchTitleImage() async {
    try {
      // Firestore에서 'event_data' 컬렉션의 'appbar' 문서를 가져옴
      DocumentSnapshot doc = await firestore
          .collection('event_data')
          .doc('appbar')
          .get();

      // title_img 필드 값을 콘솔에 출력하여 확인함
      print('Fetched title_img: ${doc['title_img']}');

      // title_img 필드 값을 String으로 변환하여 반환함
      return doc['title_img'] as String?;
    } catch (e) {
      // 에러 발생 시, 에러 메시지를 콘솔에 출력함
      print('Error fetching title image: $e');
      return null; // 에러가 발생하면 null을 반환함
    }
  }
}