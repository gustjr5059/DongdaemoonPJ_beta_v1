import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리 패키지를 사용하기 위해 import
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore를 사용하기 위해 import
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage를 사용하기 위해 import
import '../repository/cart_repository.dart'; // CartItemRepository 클래스를 사용하기 위해 import

// cartItemRepositoryProvider를 정의 - CartItemRepository 인스턴스를 제공하는 Provider를 생성
// 다른 클래스나 위젯에서 CartItemRepository의 메서드를 쉽게 사용할 수 있게하는 역할
final cartItemRepositoryProvider = Provider((ref) => CartItemRepository(
  firestore: FirebaseFirestore.instance, // Firebase Firestore 인스턴스를 전달
  storage: FirebaseStorage.instance, // Firebase Storage 인스턴스를 전달
));

// cartIconRepositoryProvider를 정의 - CartIconRepository 인스턴스를 제공하는 Provider를 생성
final cartIconRepositoryProvider = Provider<CartIconRepository>((ref) {
  return CartIconRepository(firestore: FirebaseFirestore.instance);
});
