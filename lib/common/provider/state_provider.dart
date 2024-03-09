import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// home_screen.dart 내 pageViewWithArrows로 페이지1~5로 구현 관련 StateProvider
final currentPageProvider = StateProvider<int>((ref) => 0);
// onTopBarTap 함수를 상태 관리하기 위한 사용한 StateProvider
final selectedTabIndexProvider = StateProvider<int>((ref) => 0);
// buildCommonBottomNavigationBar 상태 관리를 위한 StateProvider
final tabIndexProvider = StateProvider<int>((ref) => 0);
// firestore 데이터를 불러오도록 하는 함수를 상태 관리하기 위한 StateProvider
final firestoreDataProvider = FutureProvider.family<DocumentSnapshot, String>((ref, docId) async {
  return FirebaseFirestore.instance.collection('item').doc(docId).get();
});
