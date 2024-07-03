import 'package:flutter/material.dart'; // Flutter의 Material Design 위젯을 사용하기 위해 import
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리 패키지를 사용하기 위해 import
import '../../common/layout/common_body_parts_layout.dart';
import '../../product/model/product_model.dart'; // 제품 모델을 사용하기 위해 import
import '../../product/provider/product_state_provider.dart'; // 제품 상태 제공자를 사용하기 위해 import
import '../provider/cart_future_provier.dart';
import '../provider/cart_state_provider.dart'; // 장바구니 관련 Future Provider를 사용하기 위해 import

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

// ------ 장바구니 화면 내 파이어스토어에 있는 장바구니에 담긴 상품 아이템 데이터를 UI로 구현하는 CartItemsList 클래스 시작
// 데이터 처리 로직과 UI 구현 로직을 분리
// 데이터 처리 로직은 CartItemRepository를 통해서 파이어베이스와의 통신을 하여 데이터를 저장하고 불러오는 역할 수행 /
// cartItemRepositoryProvider를 통해서 CartItemRepository 인스턴스를 생성하여 해당 기능을 가져와 사용할 수 있도록 하는 역할 수행 /
// CartItemsNotifier와 cartItemsProvider를 통해서 파이어베이스와 UI부분을 보면서 수량의 변화에 따른 상태가 변경되는 것을 관리(상태 업데이트)하는 역할 수행 /
// CartItemsList 클래스는 단순 UI 구현 로직!!
class CartItemsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // cartItemsProvider의 상태를 관찰하여 cartItems 변수에 저장
    final cartItems = ref.watch(cartItemsProvider);

    // 장바구니가 비어 있을 경우 '장바구니가 비어 있습니다.' 메시지 표시
    if (cartItems.isEmpty) {
      return Text('장바구니가 비어 있습니다.');
    }

    // 장바구니에 아이템이 있을 경우, 각 아이템을 UI로 표시
    return Column(
      // cartItems 리스트를 순회하면서 각 아이템을 위젯으로 생성
      children: cartItems.map((cartItem) {
        return CommonCardView(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 썸네일 이미지가 있을 경우 이미지 표시
              if (cartItem['thumbnails'] != null)
                Image.network(
                  cartItem['thumbnails'] ?? '',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              // 상품 간단 소개 텍스트 표시
              Text('${cartItem['brief_introduction'] ?? ''}'),
              // 원래 가격 텍스트 표시
              Text('${cartItem['original_price']?.round() ?? 0}원'),
              // 할인된 가격 텍스트 표시
              Text('${cartItem['discount_price']?.round() ?? 0}원'),
              // 할인율 텍스트 표시
              Text('${cartItem['discount_percent']?.round() ?? 0}%'),
              Row(
                children: [
                  Text(''),
                  SizedBox(width: 8),
                  // 선택된 색상 이미지가 있을 경우 이미지 표시
                  if (cartItem['selected_color_image'] != null)
                    Image.network(
                      cartItem['selected_color_image'] ?? '',
                      height: 30,
                      width: 30,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(width: 8),
                  // 선택된 색상 텍스트 표시
                  Text('${cartItem['selected_color_text'] ?? ''}'),
                ],
              ),
              // 선택된 사이즈 텍스트 표시
              Text('${cartItem['selected_size'] ?? ''}'),
              Row(
                children: [
                  Text(''),
                  // 수량 감소 버튼
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      // 수량이 1보다 클 경우 수량 감소
                      if (cartItem['selected_count'] > 1) {
                        ref.read(cartItemsProvider.notifier).updateItemQuantity(cartItem['id'], cartItem['selected_count'] - 1);
                      }
                    },
                  ),
                  // 현재 선택된 수량 표시
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(
                      '${cartItem['selected_count'] ?? 0}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  // 수량 증가 버튼
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // 수량 증가
                      ref.read(cartItemsProvider.notifier).updateItemQuantity(cartItem['id'], cartItem['selected_count'] + 1);
                    },
                  ),
                  // 수량 직접 입력 버튼
                  TextButton(
                    onPressed: () {
                      // 수량 입력 다이얼로그 표시
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          final TextEditingController controller = TextEditingController();
                          String input = '';
                          return AlertDialog(
                            title: Text('수량 입력'),
                            content: TextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              autofocus: true,
                              onChanged: (value) {
                                input = value;
                              },
                            ),
                            actions: <TextButton>[
                              // 확인 버튼
                              TextButton(
                                child: Text('확인'),
                                onPressed: () {
                                  // 입력한 수량이 비어 있지 않을 경우 수량 업데이트
                                  if (input.isNotEmpty) {
                                    ref.read(cartItemsProvider.notifier).updateItemQuantity(cartItem['id'], int.parse(input));
                                  }
                                  // 다이얼로그 닫기
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('직접 입력'),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.all(8),
        );
      }).toList(),
    );
  }
}
// ------ 장바구니 화면 내 파이어스토어에 있는 장바구니에 담긴 상품 아이템 데이터를 UI로 구현하는 CartItemsList 클래스 끝
