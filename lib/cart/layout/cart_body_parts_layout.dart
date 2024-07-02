import 'package:flutter/material.dart'; // Flutter의 Material Design 위젯을 사용하기 위해 import
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리 패키지를 사용하기 위해 import
import '../../product/model/product_model.dart'; // 제품 모델을 사용하기 위해 import
import '../../product/provider/product_state_provider.dart'; // 제품 상태 제공자를 사용하기 위해 import
import '../provider/cart_future_provier.dart'; // 장바구니 관련 Future Provider를 사용하기 위해 import

// 장바구니 버튼 클릭 시 호출되는 함수 - 장바구니 버튼이 클릭되었을 때 addToCartItem 함수를 호출하여 상품을 장바구니에 추가하고, 성공 또는 실패 메시지를 표시
void onCartButtonPressed(
    BuildContext context, WidgetRef ref, ProductContent product) {
  final cartRepository = ref.read(
      cartItemRepositoryProvider); // cartItemRepositoryProvider를 사용하여 장바구니 레포지토리를 읽음
  final selectedColorIndex = ref.read(
      colorSelectionIndexProvider); // colorSelectionIndexProvider를 사용하여 선택된 색상 인덱스를 읽음
  final selectedColorUrl = ref.read(
      colorSelectionUrlProvider); // colorSelectionUrlProvider를 사용하여 선택된 색상 URL을 읽음
  final selectedColorOption = (product.colorOptions != null &&
          selectedColorIndex != null &&
          selectedColorIndex >= 0 &&
          selectedColorIndex <
              product.colorOptions!.length) // 조건문으로 색상 옵션이 존재하고 유효한 인덱스인지 확인
      ? product.colorOptions![selectedColorIndex] // 유효한 인덱스라면 선택된 색상 옵션을 가져옴
      : null; // 유효하지 않다면 null을 반환
  final selectedColorText = selectedColorOption?['text'] ??
      ''; // 선택된 색상 옵션에서 'text' 값을 가져오고, 없다면 빈 문자열을 반환
  final selectedSize = ref.read(
      sizeSelectionIndexProvider); // sizeSelectionIndexProvider를 사용하여 선택된 사이즈 인덱스를 읽음
  final quantity = ref.read(
      detailQuantityIndexProvider); // detailQuantityIndexProvider를 사용하여 선택된 수량을 읽음

  cartRepository
      .addToCartItem(
          product, selectedColorText, selectedColorUrl, selectedSize, quantity)
      .then((_) {
    // addToCartItem 함수를 호출하여 상품을 장바구니에 추가하고 성공 시
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('해당 상품이 장바구니 목록에 담겼습니다.'))); // 성공 메시지를 화면에 표시
  }).catchError((error) {
    // 에러가 발생할 경우
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('장바구니에 상품을 담는 중 오류가 발생했습니다.'))); // 오류 메시지를 화면에 표시
  });
}
