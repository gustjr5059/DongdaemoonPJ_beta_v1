import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../product/model/product_model.dart';


// ------- order_list_detail_screen.dart - 발주내역 상세 관련 내용 시작 부분
// 발주 내역 상세 화면에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final orderListDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
// ------- order_list_detail_screen.dart - 발주내역 상세 관련 내용 끝 부분

// ------- order_list_screen.dart - 발주내역 관련 내용 시작 부분
// 발주 내역 화면에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final orderListScrollPositionProvider = StateProvider<double>((ref) => 0);

// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 orderListScrollControllerProvider라는 이름의 Provider를 정의함.
final orderListScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});
// ------- order_list_screen.dart - 발주내역 관련 내용 끝 부분

// ------- order_screen.dart - 발주 관련 내용 시작 부분
// 발주 화면에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final orderMainScrollPositionProvider = StateProvider<double>((ref) => 0);

// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 orderMainScrollControllerProvider라는 이름의 Provider를 정의함.
final orderMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 발주 화면으로 전달할 상품 리스트를 관리하는 상태 프로바이더
final orderItemsProvider = StateNotifierProvider<OrderItemsNotifier, List<ProductContent>>((ref) {
  return OrderItemsNotifier();
});

class OrderItemsNotifier extends StateNotifier<List<ProductContent>> {
  OrderItemsNotifier() : super([]);

  void setOrderItems(List<ProductContent> items) {
    state = items;
  }
}
// ------- order_screen.dart - 발주 관련 내용 끝 부분