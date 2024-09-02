import 'dart:async';  // 비동기 프로그래밍을 위한 라이브러리 임포트
import 'package:dongdaemoon_beta_v1/wishlist/provider/wishlist_all_providers.dart';  // 찜 목록 프로바이더 파일 임포트
import 'package:flutter/cupertino.dart';  // Cupertino 디자인 시스템을 위한 Flutter 패키지 임포트
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Riverpod 상태 관리를 위한 패키지 임포트
import '../repository/wishlist_repository.dart';  // 찜 목록 레포지토리 파일 임포트

// 찜 목록 화면에서 화면 자체 스크롤로 이동한 위치를 저장하는 StateProvider
final wishlistScrollPositionProvider = StateProvider<double>((ref) => 0);

// -------- wishlist_screen.dart 관련 ScrollControllerProvider 시작
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 wishlistScrollControllerProvider라는 이름의 Provider를 정의함.
final wishlistScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 함.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});
// -------- wishlist_screen.dart 관련 ScrollControllerProvider 끝

// ------ Firestore와의 상호작용을 위해 WishlistItemRepository를 사용하여 상태를 관리하는 WishlistItemNotifier 클래스 내용 시작
class WishlistItemNotifier extends StateNotifier<AsyncValue<Set<String>>> {
  // WishlistItemRepository 인스턴스 저장
  final WishlistItemRepository wishlistItemRepository;
  final String userEmail; // 로그인한 이메일 계정 변수
  // Firestore 실시간 구독을 위한 StreamSubscription 변수
  late StreamSubscription _subscription;

  // 생성자에서 Firestore 데이터를 구독하는 메서드 호출
  WishlistItemNotifier(this.wishlistItemRepository, this.userEmail) : super(const AsyncValue.loading()) {
    // Firestore의 실시간 데이터를 구독하는 메서드 호출
    _listenToWishlistItems();
  }

  // Firestore의 실시간 데이터를 구독하는 메서드
  void _listenToWishlistItems() {
    _subscription = wishlistItemRepository.firestore
        .collection('couture_wishlist_item')
        .doc(userEmail)
        .collection('items')
        .snapshots()
        .listen((snapshot) {
      final itemIds = snapshot.docs.map((doc) => doc['product_id'] as String).toSet();
      state = AsyncValue.data(itemIds);
    }, onError: (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    });
  }

  // 클래스가 dispose될 때 구독을 취소하는 메서드
  @override
  void dispose() {
    // 구독 취소
    _subscription.cancel();
    super.dispose();
  }

  // 상품 ID를 기준으로 찜 목록에 추가 또는 제거하는 함수
  void toggleItem(String productId) {
    // 현재 상태가 데이터인 경우
    if (state is AsyncData) {
      // 현재 찜 목록 상태를 가져옴
      final items = (state as AsyncData<Set<String>>).value;
      // 상품이 찜 목록에 있는 경우 제거
      if (items.contains(productId)) {
        state = AsyncValue.data(Set.from(items)..remove(productId));
      } else {
        // 상품이 찜 목록에 없는 경우 추가
        state = AsyncValue.data(Set.from(items)..add(productId));
      }
    }
  }

  // 상품 ID를 기준으로 찜 목록에서 제거하는 함수인 removeItem
  void removeItem(String productId) async {
    try {
      await wishlistItemRepository.removeFromWishlistItem(userEmail, productId);
      state = state.whenData((items) => Set.from(items)..remove(productId));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // 상품 ID를 기준으로 찜 목록에 추가하는 함수인 addItem
  void addItem(String productId) {
    // 현재 상태가 데이터인 경우
    if (state is AsyncData) {
      // 현재 찜 목록 상태를 가져옴
      final items = (state as AsyncData<Set<String>>).value;
      // 상품을 찜 목록에 추가
      state = AsyncValue.data(Set.from(items)..add(productId));
    }
  }

  // 주어진 상품 ID가 찜 목록에 있는지 확인하는 함수
  bool isWished(String productId) {
    // 현재 상태가 데이터인 경우
    if (state is AsyncData) {
      // 현재 찜 목록 상태를 가져옴
      final items = (state as AsyncData<Set<String>>).value;
      // 상품이 찜 목록에 있는지 여부 반환
      return items.contains(productId);
    }
    // 현재 상태가 데이터가 아닌 경우 false 반환
    return false;
  }
}
// ------ Firestore와의 상호작용을 위해 WishlistItemRepository를 사용하여 상태를 관리하는 WishlistItemNotifier 클래스 내용 끝

// WishlistItemNotifier 클래스를 사용할 수 있도록 하는 StateNotifierProvider
final wishlistItemProvider = StateNotifierProvider.family<WishlistItemNotifier, AsyncValue<Set<String>>, String>((ref, String userEmail) {
  // wishlistItemRepositoryProvider를 사용하여 WishlistItemRepository 인스턴스를 가져옴.
  final wishlistRepository = ref.watch(wishlistItemRepositoryProvider);
  // WishlistItemNotifier를 생성하고 반환함.
  return WishlistItemNotifier(wishlistRepository, userEmail);
});