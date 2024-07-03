import 'package:flutter/cupertino.dart'; // Flutter의 Cupertino 디자인 패키지를 사용하기 위해 import
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 패키지를 사용하기 위해 import

import '../repository/cart_repository.dart'; // 장바구니 데이터 처리를 위한 CartRepository를 import
import 'cart_future_provier.dart'; // CartFutureProvider를 import

// 장바구니 화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final cartLargeBannerPageProvider = StateProvider<int>((ref) => 0);

// 현재 선택된 상단 탭 바 관련 탭의 인덱스 상태 관리를 위한 StateProvider
final cartCurrentTabProvider = StateProvider<int>((ref) => 0);

// 장바구니 화면에서 각 상단 탭 바 관련 섹션의 스크롤 위치와 단순 화면 스크롤로 이동할 위치를 저장하는 StateProvider
final cartScrollPositionProvider = StateProvider<double>((ref) => 0);

// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 cartScrollControllerProvider라는 이름의 Provider를 정의함
final cartScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 함
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함
  return scrollController;
});

// Firestore와의 상호작용을 위해 CartItemRepository를 사용하여 상태를 관리하는 provider인 StateNotifier
// 즉, CartItemRepository를 통해서 파이어베이스와 UI부분을 보면서 수량의 변화, 장바구니 아이템이 제거되고, 새로 추가되는 상태가 변경되는 것을 관리(상태 업데이트)하는 담당
class CartItemsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  // CartItemRepository 인스턴스를 저장하기 위한 변수 선언
  final CartItemRepository cartItemRepository;

  // 생성자에서 CartItemRepository를 받아 초기 상태를 빈 리스트로 설정하고, loadCartItems 함수 호출
  CartItemsNotifier(this.cartItemRepository) : super([]) {
    loadCartItems();
  }

  // Firestore에서 장바구니 아이템 목록을 불러와 상태를 업데이트하는 함수
  Future<void> loadCartItems() async {
    state = await cartItemRepository.getCartItems();
  }

  // 장바구니 아이템의 수량을 업데이트하고 상태를 갱신하는 함수
  Future<void> updateItemQuantity(String id, int newQuantity) async {
    // Firestore에서 수량 업데이트
    await cartItemRepository.updateCartItemQuantity(id, newQuantity);
    // 상태를 새로운 수량으로 업데이트
    state = [
      for (final item in state)
        if (item['id'] == id)
          {...item, 'selected_count': newQuantity} // 수량이 변경된 아이템 업데이트
        else
          item // 수량이 변경되지 않은 아이템은 그대로 유지
    ];
  }

  // 장바구니에서 아이템을 제거하고 상태를 갱신하는 함수
  Future<void> removeItem(String id) async {
    await cartItemRepository.removeCartItem(id); // Firestore에서 아이템 제거
    state = state.where((item) => item['id'] != id).toList(); // 상태에서 제거된 아이템 삭제
  }

  // 장바구니 아이템 목록을 새로고침하는 함수
  Future<void> refreshCartItems() async {
    state = await cartItemRepository.getCartItems(); // Firestore에서 최신 장바구니 아이템 목록을 불러옴
  }
}

// CartItemsNotifier 클래스를 사용할 수 있도록 하는 StateNotifierProvider
final cartItemsProvider = StateNotifierProvider<CartItemsNotifier, List<Map<String, dynamic>>>((ref) {
  // cartItemRepositoryProvider를 통해 CartItemRepository 인스턴스를 가져옴
  final cartItemRepository = ref.read(cartItemRepositoryProvider);
  // CartItemsNotifier 인스턴스를 생성하여 반환
  return CartItemsNotifier(cartItemRepository);
});
