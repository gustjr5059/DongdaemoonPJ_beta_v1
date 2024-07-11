// Riverpod 라이브러리를 임포트합니다.
// 이 라이브러리는 상태 관리를 위한 강력하고 유연한 프레임워크로, 애플리케이션의 다양한 상태를 관리하는데 도움을 줍니다.
// Riverpod는 기존 Provider 라이브러리를 기반으로 하여 더욱 발전된 기능을 제공하며,
// 각종 상태 관리 요구 사항을 보다 세밀하고 효과적으로 다룰 수 있도록 설계되었습니다.
// 이를 통해 앱의 상태를 전역적으로 또는 로컬적으로 제어하고, 상태 변화에 따라 UI를 자동으로 업데이트하는 구조를 구현할 수 있습니다.
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../product/model/product_model.dart';

// 찜 목록 화면에서 화면 자체 스크롤로 이동환 위치를 저장하는 StateProvider
final wishlistScrollPositionProvider = StateProvider<double>((ref) => 0);

// -------- wishlist_screen.dart 관련 ScrollControllerProvider 시작
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 wishlistScrollControllerProvider라는 이름의 Provider를 정의함.
final wishlistScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});
// -------- wishlist_screen.dart 관련 ScrollControllerProvider 끝


// WishlistItemNotifier 클래스를 사용할 수 있도록 하는 StateNotifierProvider
final wishlistItemProvider = StateNotifierProvider<WishlistItemNotifier, Set<String>>((ref) {
  return WishlistItemNotifier(); // WishlistItemNotifier 인스턴스를 반환
});

// Firestore와의 상호작용을 위해 WishlistItemRepository를 사용하여 상태를 관리하는 provider인 StateNotifier
class WishlistItemNotifier extends StateNotifier<Set<String>> {
  WishlistItemNotifier() : super({}); // 초기 상태를 빈 Set으로 설정

  // 상품 ID를 기준으로 찜 목록에 추가 또는 제거하는 함수
  void toggleItem(String productId) {
    if (state.contains(productId)) { // 현재 상태에 상품 ID가 포함되어 있는 경우
      state = Set.from(state)..remove(productId); // 상태를 업데이트하여 상품 ID 제거
    } else { // 현재 상태에 상품 ID가 포함되어 있지 않은 경우
      state = Set.from(state)..add(productId); // 상태를 업데이트하여 상품 ID 추가
    }
  }

  // 주어진 상품 ID가 찜 목록에 있는지 확인하는 함수
  bool isWished(String productId) {
    return state.contains(productId); // 상품 ID가 상태에 포함되어 있는지 여부 반환
  }
}

