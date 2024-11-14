
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

// 찜 목록 데이터를 FutureProvider로 불러오는 로직을 구현함.
// wishlistItemsLoadFutureProvider는 FutureProvider.autoDispose.family로 선언되었으며,
// 데이터를 불러올 때 중복 호출을 방지하기 위해 캐싱 기능을 적용함.
final wishlistItemsLoadFutureProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, userEmail) async {

  // Firestore에서 찜 목록 데이터를 불러오기 시작함을 출력함.
  print('Firestore에서 찜 목록 데이터를 불러오기 시작');

  // WishlistItemRepository 인스턴스를 가져옴.
  final wishlistRepository = ref.watch(wishlistItemRepositoryProvider);
  print('WishlistItemRepository 인스턴스 획득 완료');

  // Firestore의 'wearcano_wishlist_item' 컬렉션 내에서 해당 사용자의 찜 목록 데이터를 불러옴.
  // 최신 항목이 위로 오도록 timestamp 기준으로 내림차순 정렬함.
  final wishlistSnapshot = await wishlistRepository.firestore
      .collection('wearcano_wishlist_item')
      .doc(userEmail)
      .collection('items')
      .orderBy('timestamp', descending: true)
      .get();

  // Firestore에서 데이터를 불러왔음을 알림
  print('Firestore에서 찜 목록 데이터 획득 - 항목 수: ${wishlistSnapshot.docs.length}개');

  // Firestore에서 불러온 데이터를 map 함수를 사용하여 변환함.
  return wishlistSnapshot.docs.map((doc) {
    // 각 찜 목록 항목의 데이터를 변환함을 출력함.
    print('찜 목록 항목 데이터 변환 - product_id: ${doc['product_id']}');

    // 찜 목록의 각 항목의 데이터를 Map 형식으로 반환함.
    return {
      'product_id': doc['product_id'],
      'thumbnails': doc['thumbnails'],
      'brief_introduction': doc['brief_introduction'],
      'original_price': doc['original_price'],
      'discount_price': doc['discount_price'],
      'discount_percent': doc['discount_percent'],
    };
  }).toList();  // 변환된 데이터를 리스트로 반환함.
});

// 찜 목록에서 실시간으로 삭제된 항목이 반영되도록 StreamProvider를 통해 데이터를 구독함.
// 실시간 데이터 업데이트를 위해 wishlistItemLoadStreamProvider는 StreamProvider.autoDispose.family로 선언됨.
final wishlistItemLoadStreamProvider = StreamProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, userEmail) {

  // Firestore의 실시간 데이터 스트림 구독을 시작함을 출력함.
  print('Firestore 실시간 데이터 스트림 구독 시작');

  // WishlistItemRepository 인스턴스를 가져옴.
  final wishlistRepository = ref.watch(wishlistItemRepositoryProvider);
  print('WishlistItemRepository 인스턴스 획득 완료');

  // Firestore의 'wearcano_wishlist_item' 컬렉션 내 해당 사용자의 찜 목록 데이터를 실시간으로 스트리밍함.
  // timestamp 기준으로 내림차순 정렬하여 최신 항목을 먼저 불러옴.
  return wishlistRepository.firestore
      .collection('wearcano_wishlist_item')
      .doc(userEmail)
      .collection('items')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) {

    // 실시간으로 가져온 데이터 개수를 출력함.
    print('실시간 찜 목록 업데이트 - 항목 수: ${snapshot.docs.length}개');

    // 실시간으로 가져온 데이터를 map 함수로 변환하여 반환함.
    return snapshot.docs.map((doc) {
      // 각 항목을 변환할 때 product_id와 관련 정보를 출력함.
      print('실시간 데이터 항목 변환 - product_id: ${doc['product_id']}');

      // Firestore에서 가져온 데이터를 Map 형식으로 반환함.
      return {
        'product_id': doc['product_id'],
        'thumbnails': doc['thumbnails'],
        'brief_introduction': doc['brief_introduction'],
        'original_price': doc['original_price'],
        'discount_price': doc['discount_price'],
        'discount_percent': doc['discount_percent'],
      };
    }).toList();  // 변환된 데이터를 리스트로 반환함.
  });
});