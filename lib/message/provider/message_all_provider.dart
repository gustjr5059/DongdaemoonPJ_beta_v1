import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/message_repository.dart';

// PrivateMessageRepository를 사용하기 위한 인스턴스를 불러오는 프로바이더를 정의.
final privateMessageRepositoryProvider = Provider((ref) => PrivateMessageRepository(firestore: FirebaseFirestore.instance));

// 메시지를 실시간으로 불러오는 프로바이더 fetchMessagesProvider를 정의.
// 사용자 이메일을 매개변수로 받아 해당 사용자의 메시지를 리스트 형태로 반환.
final fetchMessagesProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, email) {
  // privateMessageRepositoryProvider를 통해 PrivateMessageRepository 인스턴스를 읽어옴.
  final privateMessageRepository = ref.read(privateMessageRepositoryProvider);
  // PrivateMessageRepository의 fetchMessages 메서드를 호출하여 실시간으로 메시지를 가져옴.
  return privateMessageRepository.fetchMessages(email);
});

// 로그인한 사용자의 이메일 계정을 가져오는 프로바이더 currentUserEmailProvider를 정의.
// FirebaseAuth의 현재 사용자 스트림을 통해 이메일을 반환.
final currentUserEmailProvider = StreamProvider<String?>((ref) async* {
  // FirebaseAuth 인스턴스를 통해 현재 사용자 정보를 가져옴.
  final user = FirebaseAuth.instance.currentUser;
  // 현재 사용자의 이메일을 반환.
  yield user?.email;
});
