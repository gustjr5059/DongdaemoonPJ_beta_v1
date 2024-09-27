import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore와 상호작용을 위해 cloud_firestore 패키지를 import함
import 'package:firebase_auth/firebase_auth.dart'; // Firebase 인증을 사용하기 위해 firebase_auth 패키지를 import함
import 'package:flutter/cupertino.dart'; // Flutter의 Cupertino 디자인 패키지를 사용하기 위해 import함
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위해 Riverpod 패키지를 import함
import '../repository/cart_repository.dart'; // 장바구니 데이터 처리를 위한 CartRepository를 import함
import 'cart_all_proviers.dart'; // CartFutureProvider와 관련된 provider 파일을 import함

// 장바구니 화면에서 스크롤 위치를 저장하는 StateProvider
final cartScrollPositionProvider = StateProvider<double>((ref) => 0);

// 장바구니 화면에서 하단의 전체 선택 체크박스 상태를 관리하는 StateProvider
final allCheckedProvider = StateProvider<bool>((ref) => false);

// 장바구니 데이터를 로딩할 때 사용되는 로딩 상태를 관리하는 StateProvider
final isLoadingProvider = StateProvider<bool>((ref) => false);

// ScrollController를 관리하는 Provider
// ScrollController를 제공하는 cartScrollControllerProvider를 정의함
final cartScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함
  final scrollController = ScrollController();
  // Provider가 해제될 때 ScrollController의 dispose 메서드를 호출하여 자원을 해제함
  ref.onDispose(scrollController.dispose);
  // ScrollController 객체를 반환함
  return scrollController;
});

// CartItemsNotifier 클래스: Firestore와의 상호작용을 통해 장바구니 상태를 관리하는 StateNotifier 클래스
class CartItemsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  // 아이템별 실시간 구독을 관리하는 Map (아이템 ID -> 구독 객체)
  final Map<String, StreamSubscription<Map<String, dynamic>>> _itemSubscriptions = {};
  // CartItemRepository 인스턴스를 저장하는 변수
  final CartItemRepository cartItemRepository;
  // Riverpod의 Ref 객체를 저장하는 변수
  final Ref ref;
  // 마지막으로 불러온 데이터의 스냅샷을 저장하는 변수
  DocumentSnapshot? lastDocument;
  // 페이징 처리 중 여부를 나타내는 플래그
  bool isLoadingMore = false;

  // 스트림에 대한 실시간 구독 여부를 관리하는 플래그
  bool isListeningToStream = false;

  // 초기 데이터 로딩 완료 여부를 나타내는 플래그
  bool _isInitialLoadComplete = false;

  // 생성자에서 CartItemRepository와 Ref를 받아서 초기 상태를 빈 리스트로 설정함
  // 초기 데이터 로딩을 위해 loadMoreCartItems 메서드를 호출함
  CartItemsNotifier(this.cartItemRepository, this.ref) : super([]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMoreCartItems();
    });
  }

  // 전체 체크박스 상태를 업데이트하는 함수
  void _updateAllCheckedState(List<Map<String, dynamic>> cartItems) {
    // 장바구니 아이템이 비어 있지 않고 모든 아이템이 선택된 경우 전체 선택 체크박스 상태를 true로 설정함
    final allChecked = cartItems.isNotEmpty && cartItems.every((item) => item['bool_checked'] == true);
    // UI가 그려진 후 상태를 업데이트함
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(allCheckedProvider.notifier).state = allChecked;
    });
  }

  // Firestore에서 장바구니 아이템을 페이징 처리해서 불러오는 함수
  Future<void> loadMoreCartItems() async {
    if (isLoadingMore) {
      print("이미 로딩 중입니다.");
      return; // 이미 로딩 중이면 중복 로딩 방지함
    }

    print("데이터 로드를 시작합니다.");
    isLoadingMore = true;
    // 로딩 상태를 true로 설정함
    ref.read(isLoadingProvider.notifier).state = true;

    // 사용자 인증 상태 확인
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("사용자가 로그인되어 있지 않습니다.");
      state = [];
      isLoadingMore = false;
      return;
    }

    // Firestore에서 데이터를 3개씩 페이징 처리로 가져옴
    final newItems = await cartItemRepository.getPagedCartItems(
      lastDocument: lastDocument,
      limit: 3,
    );

    if (newItems.isNotEmpty) {
      lastDocument = newItems.last['snapshot']; // 마지막 문서를 기록함
      state = [...state, ...newItems]; // 기존 데이터에 추가된 데이터를 병합함
      print("새로 불러온 데이터: ${newItems.length}개");
      print("현재 전체 데이터: ${state.length}개");
    } else {
      print("더 이상 불러올 데이터가 없습니다.");
    }
    // 로딩 상태를 false로 설정함
    ref.read(isLoadingProvider.notifier).state = false;
    isLoadingMore = false;
    print("데이터 로드를 완료했습니다.");

    // 초기 로딩이 완료되면 각 아이템에 대해 실시간 구독을 시작함
    if (!_isInitialLoadComplete) {
      _isInitialLoadComplete = true;
    }
    _subscribeToIndividualItemUpdates();
  }

  // 각 아이템에 대해 실시간 체크박스 상태와 삭제 이벤트를 처리하는 함수
  void _subscribeToIndividualItemUpdates() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || isListeningToStream) return;
    isListeningToStream = true;

    // 각 아이템의 실시간 업데이트를 구독함
    for (final item in state) {
      final itemId = item['id'] ?? ''; // item['id']가 null일 경우 빈 문자열로 설정함

      // itemId가 비어있지 않은 경우에만 구독을 시작함
      if (itemId.isNotEmpty && !_itemSubscriptions.containsKey(itemId)) {
        final subscription = cartItemRepository.cartItemStream(itemId).listen((updatedItem) {
          if (updatedItem == null) {
            // 문서가 삭제된 경우 구독을 해제함
            _itemSubscriptions[itemId]?.cancel();
            _itemSubscriptions.remove(itemId);
            print('Cancelled subscription for itemId: $itemId as document does not exist.');
          } else {
            // 상태를 업데이트함
            state = [
              for (final cartItem in state)
                if (cartItem['id'] == updatedItem['id'])
                  updatedItem // 업데이트된 아이템을 상태에 반영함
                else
                  cartItem
            ];

            // 전체 체크박스 상태를 업데이트함
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateAllCheckedState(state);
            });
          }
        });
        _itemSubscriptions[itemId] = subscription; // 구독을 관리하는 Map에 추가함
      } else {
        print("Error: 아이템의 ID가 null이거나 빈 문자열입니다. 구독을 건너뜁니다.");
      }
    }
  }

  // 장바구니에서 아이템을 제거하고 상태를 갱신하는 함수
  Future<void> removeItem(String id) async {
    await cartItemRepository.removeCartItem(id); // Firestore에서 아이템을 제거함
    state = state.where((item) => item['id'] != id).toList(); // 상태에서 해당 아이템을 제거함

    // 해당 아이템에 대한 구독을 해제하고 Map에서 제거함
    _itemSubscriptions[id]?.cancel();
    _itemSubscriptions.remove(id);

    // 전체 체크박스 상태를 업데이트함
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAllCheckedState(state);
    });
  }

  // 장바구니 데이터를 초기화하고 상태를 재설정하는 함수
  void resetCartItems() {
    isLoadingMore = false; // 로딩 플래그 초기화
    state = []; // 불러온 데이터를 초기화함
    lastDocument = null; // 마지막 문서 스냅샷 초기화

    // 모든 아이템에 대한 실시간 구독을 해제함
    _unsubscribeFromAllItems();
  }

  // 모든 실시간 구독을 해제하는 함수
  void _unsubscribeFromAllItems() {
    for (final subscription in _itemSubscriptions.values) {
      subscription.cancel(); // 모든 구독을 해제함
    }
    _itemSubscriptions.clear(); // 구독 관리 Map을 초기화함
  }

  // 장바구니 아이템의 체크 상태를 변경하는 함수
  Future<void> toggleItemChecked(String id, bool checked) async {
    await cartItemRepository.updateCartItemChecked(id, checked); // Firestore에서 체크 상태를 업데이트함
    state = [
      for (final item in state)
        if (item['id'] == id)
          {...item, 'bool_checked': checked} // 상태를 업데이트함
        else
          item
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAllCheckedState(state); // 전체 체크박스 상태를 업데이트함
    });
  }

  // 장바구니 내 모든 아이템의 체크 상태를 변경하는 함수
  void toggleAll(bool checked) {
    for (final item in state) {
      toggleItemChecked(item['id'], checked); // 모든 아이템의 체크 상태를 변경함
    }
  }

  // 구독을 취소하고 리소스를 해제하는 함수
  @override
  void dispose() {
    for (final subscription in _itemSubscriptions.values) {
      subscription.cancel(); // 모든 구독을 해제함
    }
    _itemSubscriptions.clear(); // 구독 관리 Map을 초기화함
    super.dispose(); // 상위 클래스의 dispose 메서드를 호출함
  }
}

// CartItemsNotifier를 사용하는 StateNotifierProvider
final cartItemsProvider =
StateNotifierProvider<CartItemsNotifier, List<Map<String, dynamic>>>((ref) {
  final cartItemRepository = ref.read(cartItemRepositoryProvider); // CartItemRepository 인스턴스를 가져옴
  return CartItemsNotifier(cartItemRepository, ref); // CartItemsNotifier 인스턴스를 생성하여 반환함
});