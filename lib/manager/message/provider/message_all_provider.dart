import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth; // 'auth'로 임포트
import '../repository/message_repository.dart';


// AdminMessageRepository를 사용하기 위한 인스턴스를 불러오는 프로바이더
final adminMessageRepositoryProvider = Provider((ref) => AdminMessageRepository(firestore: FirebaseFirestore.instance));

// ------ Local User 클래스 정의하는 내용 시작
class User {
  final String email;
  final String uid;

  User({required this.email, required this.uid});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return User(
      email: data['email'] ?? '',
      uid: data['uid'] ?? '',
    );
  }
}
// ------ Local User 클래스 정의하는 내용 끝

// MessageScreenTab enum 정의
enum MessageScreenTab { create, list }

// 발신자 관련 로그인한 이메일 계정 데이터를 불러오는 currentUserProvider 정의
final currentUserProvider = StreamProvider<auth.User?>((ref) {
  return auth.FirebaseAuth.instance.authStateChanges();
});

// 수신자 관련 이메일 계정 데이터를 불러오는 receiversProvider 정의
final receiversProvider = FutureProvider<List<User>>((ref) async {
  // Firestore에서 사용자 목록 가져오기
  final snapshot = await FirebaseFirestore.instance.collection('users').get();
  // 'gshe.couture@gmail.com'을 필터링하여 사용자 목록 반환
  return snapshot.docs
      .map((doc) => User.fromFirestore(doc))
      .where((user) => user.email != 'gshe.couture@gmail.com')
      .toList();
});

// 선택한 수신자 이메일 계정 관련 발주번호 데이터를 불러오는 orderNumbersProvider 정의
final orderNumbersProvider = FutureProvider.family<List<String>, String?>((ref, receiver) async {
  if (receiver == null) return ['없음'];
  final AdminMessageRepository = ref.read(adminMessageRepositoryProvider);
  return await AdminMessageRepository.fetchOrderNumbers(receiver);
});

// 메시지 발송을 위한 프로바이더인 sendMessageProvider
final sendMessageProvider = FutureProvider.family<void, Map<String, String>>((ref, data) async {
  // adminMessageRepositoryProvider를 통해 AdminMessageRepository 인스턴스를 읽어옴.
  final AdminMessageRepository = ref.read(adminMessageRepositoryProvider);

  // AdminMessageRepository의 sendMessage 메서드를 호출하여 메시지를 발송함.
  // data 매개변수에서 sender, recipient, orderNumber, contents 값을 추출하여 사용함.
  await AdminMessageRepository.sendMessage(
    sender: data['sender']!,          // 발신자 정보를 전달.
    recipient: data['recipient']!,    // 수신자 정보를 전달.
    orderNumber: data['orderNumber']!, // 주문 번호를 전달.
    contents: data['contents']!,      // 메시지 내용을 전달.
  );
});

// 모든 계정의 쪽지 목록을 불러오는 프로바이더 fetchAllMessagesProvider를 정의.
final fetchAllMessagesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  // adminMessageRepositoryProvider를 통해 AdminMessageRepository 인스턴스를 읽어옴.
  final adminMessageRepository = ref.read(adminMessageRepositoryProvider);
  // AdminMessageRepository의 fetchAllMessages 메서드를 호출하여 모든 계정의 쪽지를 실시간으로 가져옴.
  return adminMessageRepository.fetchAllMessages();
});

// 메시지 삭제를 위한 프로바이더 deleteMessageProvider를 정의.
final deleteMessageProvider = FutureProvider.family<void, Map<String, String>>((ref, data) async {
  // adminMessageRepositoryProvider를 통해 AdminMessageRepository 인스턴스를 읽어옴.
  final adminMessageRepository = ref.read(adminMessageRepositoryProvider);
  // AdminMessageRepository의 deleteMessage 메서드를 호출하여 메시지를 삭제.
  await adminMessageRepository.deleteMessage(data['messageId']!, data['recipient']!);
});






