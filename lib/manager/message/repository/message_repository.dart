
import 'package:cloud_firestore/cloud_firestore.dart';


class MessageRepository {
  final FirebaseFirestore firestore;

  MessageRepository({required this.firestore});

  Future<List<String>> fetchReceivers() async {
    final querySnapshot = await firestore.collection('users').get();
    return querySnapshot.docs
        .map((doc) => doc.data()['email'] as String)
        .where((email) => email != 'capjs06@gmail.com')
        .toList();
  }

  Future<List<String>> fetchOrderNumbers(String receiver) async {
    final querySnapshot = await firestore.collection('orderer_info')
        .where('email', isEqualTo: receiver)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return ['없음']; // 데이터가 없으면 '없음' 반환
    }

    return querySnapshot.docs.map((doc) => doc.data()['order_number'] as String).toList();
  }
}
