
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/wishlist_repository.dart';

// wishlistItemRepositoryProvider를 정의 - WishlistItemRepository 인스턴스를 제공하는 Provider를 생성
// 다른 클래스나 위젯에서 WishlistItemRepository의 메서드를 쉽게 사용할 수 있게하는 역할
final wishlistItemRepositoryProvider = Provider((ref) => WishlistItemRepository(
  firestore: FirebaseFirestore.instance, // Firebase Firestore 인스턴스를 전달
  storage: FirebaseStorage.instance, // Firebase Storage 인스턴스를 전달
));

// wishlistItemsStreamProvider를 정의 - Firestore에서 wishlist_item 컬렉션의 실시간 스트림을 제공
final wishlistItemsStreamProvider = StreamProvider.family.autoDispose((ref, String userId) {
  // wishlistItemRepositoryProvider를 사용하여 WishlistItemRepository 인스턴스를 가져옴
  final wishlistRepository = ref.watch(wishlistItemRepositoryProvider);
  // Firestore에서 wishlist_item 컬렉션을 구독하여 실시간 스트림을 반환
  return wishlistRepository.firestore
      .collection('wishlist_item')
      .doc(userId)
      .collection('items')
      .orderBy('timestamp', descending: true) // timestamp 필드 기준으로 내림차순 정렬
      .snapshots()
      .map((snapshot) {
    // 문서를 변환하여 필요한 필드만 포함하는 맵으로 반환
    return snapshot.docs.map((doc) {
      return {
        'product_id': doc['product_id'],
        'thumbnails': doc['thumbnails'],
        'brief_introduction': doc['brief_introduction'],
        'original_price': doc['original_price'],
        'discount_price': doc['discount_price'],
        'discount_percent': doc['discount_percent'],
      };
    }).toList();
  });
});