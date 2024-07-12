import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart'; // Flutter의 Cupertino 디자인 패키지를 사용하기 위해 import
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 패키지를 사용하기 위해 import
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/cart_repository.dart'; // 장바구니 데이터 처리를 위한 CartRepository를 import
import 'cart_future_provier.dart'; // CartFutureProvider를 import

// 장바구니 화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final cartLargeBannerPageProvider = StateProvider<int>((ref) => 0);

// 장바구니 화면에서 단순 화면 스크롤로 이동할 위치를 저장하는 StateProvider
final cartScrollPositionProvider = StateProvider<double>((ref) => 0);

// 장바구니 화면에서 하단 탭 바 내 전체 체크박스 관련 상태관리 StateProvider
final allCheckedProvider = StateProvider<bool>((ref) => false);

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

// ------ Firestore와의 상호작용을 위해 CartItemRepository를 사용하여 상태를 관리하는 provider인 CartItemsNotifier 클래스 내용 시작
// 즉, CartItemRepository를 통해서 파이어베이스와 UI부분을 보면서 수량의 변화, 장바구니 아이템이 제거되고, 새로 추가되는 상태가 변경되는 것을 관리(상태 업데이트)하는 담당
class CartItemsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  // CartItemRepository 인스턴스를 저장하기 위한 변수 선언
  final CartItemRepository cartItemRepository;
  final Ref ref; // Ref 인스턴스를 저장하기 위한 변수 선언
  // 장바구니 아이템 스트림 구독을 위한 변수 선언
  StreamSubscription<List<Map<String, dynamic>>>? _cartItemsSubscription;

  // 생성자에서 CartItemRepository를 받아 초기 상태를 빈 리스트로 설정하고, _subscribeToCartItems 함수 호출
  CartItemsNotifier(this.cartItemRepository, this.ref) : super([]) {
    _subscribeToCartItems();
  }

  // 전체 체크박스 상태를 업데이트하는 함수
  void _updateAllCheckedState(List<Map<String, dynamic>> cartItems) {
    // 마이크로태스크 큐에 함수를 추가하여 다른 작업이 끝난 후 실행되도록 함
    Future.microtask(() {
      // cartItems 리스트가 비어있지 않고 모든 항목의 'bool_checked' 값이 true인지 확인하여 allChecked 변수에 할당
      final allChecked = cartItems.isNotEmpty && cartItems.every((item) => item['bool_checked'] == true);
      // allCheckedProvider 상태를 allChecked 값으로 업데이트
      ref.read(allCheckedProvider.notifier).state = allChecked;
    });
  }

  // Firestore의 장바구니 아이템 스트림에 구독하여 상태를 업데이트하는 함수
  void _subscribeToCartItems() {
    // 장바구니 아이템 스트림을 구독하고, 데이터가 변경되면 상태를 업데이트
    _cartItemsSubscription = cartItemRepository.cartItemsStream().listen((cartItems) {
      state = cartItems;
      // 전체 체크박스 상태 업데이트
      _updateAllCheckedState(cartItems);
    });
  }

  // Firestore에서 장바구니 아이템 목록을 불러와 상태를 업데이트하는 함수
  Future<void> loadCartItems() async {
    // Firestore에서 장바구니 아이템 목록을 가져와 상태를 업데이트
    state = await cartItemRepository.getCartItems();
    // 전체 체크박스 상태 업데이트
    _updateAllCheckedState(state);
  }

  // 장바구니 아이템의 수량을 업데이트하고 상태를 갱신하는 함수
  Future<void> updateItemQuantity(String id, int newQuantity) async {
    // Firestore에서 수량 업데이트
    await cartItemRepository.updateCartItemQuantity(id, newQuantity);
    // 상태를 새로운 수량으로 업데이트
    state = [
      for (final item in state)
        if (item['id'] == id)
        // 수량이 변경된 아이템 업데이트
          {...item, 'selected_count': newQuantity}
        else
        // 수량이 변경되지 않은 아이템은 그대로 유지
          item
    ];
    // 전체 체크박스 상태 업데이트
    _updateAllCheckedState(state);
  }

  // 장바구니에서 아이템을 제거하고 상태를 갱신하는 함수
  Future<void> removeItem(String id) async {
    // Firestore에서 아이템 제거
    await cartItemRepository.removeCartItem(id);
    // 상태에서 제거된 아이템 삭제
    state = state.where((item) => item['id'] != id).toList();
    // 전체 체크박스 상태 업데이트
    _updateAllCheckedState(state);
  }

  // 장바구니 아이템의 체크 상태를 변경하는 함수
  Future<void> toggleItemChecked(String id, bool checked) async {
    // 특정 아이템의 체크 상태를 Firestore에 업데이트
    await cartItemRepository.updateCartItemChecked(id, checked);
    // 상태를 업데이트
    state = [
      for (final item in state)
        if (item['id'] == id)
        // 체크 상태가 변경된 아이템 업데이트
          {...item, 'bool_checked': checked}
        else
        // 체크 상태가 변경되지 않은 아이템은 그대로 유지
          item
    ];
    // 전체 체크박스 상태 업데이트
    _updateAllCheckedState(state);
  }

  // 장바구니 내 모든 아이템의 체크 상태를 변경하는 함수
  void toggleAll(bool checked) {
    // 모든 아이템의 체크 상태를 변경
    for (final item in state) {
      toggleItemChecked(item['id'], checked);
    }
  }

  // 구독을 취소하고 리소스를 해제하는 함수
  @override
  void dispose() {
    _cartItemsSubscription?.cancel();
    super.dispose();
  }
}
// ------ Firestore와의 상호작용을 위해 CartItemRepository를 사용하여 상태를 관리하는 provider인 CartItemsNotifier 클래스 내용 끝

// CartItemsNotifier 클래스를 사용할 수 있도록 하는 StateNotifierProvider
final cartItemsProvider = StateNotifierProvider<CartItemsNotifier, List<Map<String, dynamic>>>((ref) {
  // cartItemRepositoryProvider를 통해 CartItemRepository 인스턴스를 가져옴
  final cartItemRepository = ref.read(cartItemRepositoryProvider);
  // CartItemsNotifier 인스턴스를 생성하여 반환
  return CartItemsNotifier(cartItemRepository, ref);
});

