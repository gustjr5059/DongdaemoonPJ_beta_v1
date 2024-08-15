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

// 특정 발주번호에 해당하는 결제완료일을 가져오는 함수를 불러와서 사용 가능하도록 하는 paymentCompleteDateProvider
// FutureProvider.family를 사용하여 비동기적으로 데이터(DateTime?)를 제공하는 provider를 생성하며, String 타입의 인자를 받도록 했음.
final paymentCompleteDateProvider = FutureProvider.family<DateTime?, String>((ref, orderNumber) async {
  // 현재 로그인된 사용자의 이메일을 가져오기 위해 currentUserEmailProvider를 호출하고, 그 결과를 기다리도록 했음.
  final email = await ref.watch(currentUserEmailProvider.future);
  // 이메일이 null일 경우(사용자가 로그인되지 않은 경우) null을 반환하여 결제완료일을 가져오지 않도록 했음.
  if (email == null) return null;

  // 결제완료일을 가져오기 위해 privateMessageRepository 인스턴스를 읽어오도록 했음.
  final privateMessageRepository = ref.read(privateMessageRepositoryProvider);
  // privateMessageRepository의 fetchPaymentCompleteDate 함수를 호출하여 결제완료일을 가져오고 반환하도록 했음.
  return privateMessageRepository.fetchPaymentCompleteDate(email, orderNumber);
});

