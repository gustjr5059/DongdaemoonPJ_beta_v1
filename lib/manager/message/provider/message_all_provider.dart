import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth; // 'auth'로 임포트
import '../repository/message_repository.dart';


final messageRepositoryProvider = Provider((ref) => MessageRepository(firestore: FirebaseFirestore.instance));

// Local User 클래스 정의
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

// MessageScreenTab enum 정의
enum MessageScreenTab { create, list }

// currentUserProvider 정의
final currentUserProvider = StreamProvider<auth.User?>((ref) {
  return auth.FirebaseAuth.instance.authStateChanges();
});

// receiversProvider 정의
final receiversProvider = FutureProvider<List<User>>((ref) async {
  // Firestore에서 사용자 목록 가져오기
  final snapshot = await FirebaseFirestore.instance.collection('users').get();
  return snapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
});

// orderNumbersProvider 정의
final orderNumbersProvider = FutureProvider.family<List<String>, String?>((ref, receiver) async {
  if (receiver == null) return ['없음'];
  final messageRepository = ref.read(messageRepositoryProvider);
  return await messageRepository.fetchOrderNumbers(receiver);
});


