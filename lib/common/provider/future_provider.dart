
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// firestore 데이터를 불러오도록 하는 함수를 상태 관리하기 위한 StateProvider
final firestoreDataProvider = FutureProvider.family<DocumentSnapshot, String>((ref, docId) async {
  return FirebaseFirestore.instance.collection('item').doc(docId).get();
});