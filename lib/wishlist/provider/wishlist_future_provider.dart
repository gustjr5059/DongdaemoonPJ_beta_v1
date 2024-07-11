
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