
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// firestore 데이터를 불러오도록 하는 함수를 상태 관리하기 위한 FutureProvider
final firestoreDataProvider = FutureProvider.family<DocumentSnapshot, String>((ref, docId) async {
  return FirebaseFirestore.instance.collection('item').doc(docId).get();
});

// Firestore에서 banners 컬렉션의 이미지 URL을 불러오는 FutureProvider
final bannerImagesProvider = FutureProvider<List<String>>((ref) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('item').doc('banners').get();
  if (snapshot.exists) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return [data['dongdaemoon1'], data['dongdaemoon2'], data['dongdaemoon3']].whereType<String>().toList();
  }
  return [];
});