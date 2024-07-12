import 'package:dongdaemoon_beta_v1/common/const/colors.dart';
import 'package:flutter/material.dart'; // Flutter의 Material Design 위젯을 사용하기 위해 import
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리 패키지를 사용하기 위해 import
import 'package:intl/intl.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../product/layout/product_body_parts_layout.dart';
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
    // cartItemsProvider를 통해 장바구니 아이템 목록 상태를 가져옴
    final cartItems = ref.watch(cartItemsProvider);

    // 숫자 형식을 지정하기 위한 NumberFormat 객체 생성
    final numberFormat = NumberFormat('###,###');

    // ProductInfoDetailScreenNavigation 인스턴스 생성
    final navigatorProductDetailScreen = ProductInfoDetailScreenNavigation(ref);

    // 장바구니가 비어 있을 경우 화면에 '장바구니가 비어 있습니다.' 텍스트를 중앙에 표시
    return cartItems.isEmpty
        ? Center(child: Text('장바구니가 비어 있습니다.'))
        : Column(
      // 장바구니 아이템을 반복하여 UI를 생성
      children: cartItems.map((cartItem) {
        // 상품의 원래 가격을 정수형으로 변환, 값이 없을 경우 0으로 설정
        final int originalPrice = cartItem['original_price']?.round() ?? 0;
        // 상품의 할인 가격을 정수형으로 변환, 값이 없을 경우 0으로 설정
        final int discountPrice = cartItem['discount_price']?.round() ?? 0;
        // 선택된 상품의 수량을 가져옴, 값이 없을 경우 1로 설정
        final int selectedCount = cartItem['selected_count'] ?? 1;
        // 원래 가격에 선택된 수량을 곱한 값을 계산
        final int totalOriginalPrice = originalPrice * selectedCount;
        // 할인 가격에 선택된 수량을 곱한 값을 계산
        final int totalDiscountPrice = discountPrice * selectedCount;

        // ProductContent 인스턴스를 생성하여 상품의 상세 정보를 저장
        final product = ProductContent(
          docId: cartItem['product_id'],
          thumbnail: cartItem['thumbnails'],
          briefIntroduction: cartItem['brief_introduction'],
          originalPrice: cartItem['original_price'],
          discountPrice: cartItem['discount_price'],
          discountPercent: cartItem['discount_percent'],
        );

        // CommonCardView 위젯을 사용하여 상품 정보를 카드 형태로 표시
        return CommonCardView(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 체크박스 크기를 1.5배로 조정하여 표시
                  Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      // 체크박스의 체크 여부를 cartItem의 bool_checked 값으로 설정, 값이 없을 경우 false로 설정
                      value: cartItem['bool_checked'] ?? false,
                      activeColor: BUTTON_COLOR,
                      // 체크박스 상태 변경 시 cartItemsProvider의 상태를 업데이트
                      onChanged: (bool? value) {
                        ref.read(cartItemsProvider.notifier)
                            .toggleItemChecked(cartItem['id'], value!);
                      },
                    ),
                  ),
                  // 상품의 간단한 설명을 중앙에 Bold체로 표시
                  Expanded(
                    child: Center(
                      child: Text(
                        '${cartItem['brief_introduction'] ?? ''}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // 썸네일 이미지가 있을 경우 이미지 표시, 클릭 시 상세 페이지로 이동
                  if (cartItem['thumbnails'] != null)
                    GestureDetector(
                      onTap: () {
                        navigatorProductDetailScreen.navigateToDetailScreen(
                          context,
                          product,
                        );
                      },
                      child: Image.network(
                        cartItem['thumbnails'] ?? '',
                        height: 130,
                        width: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 원래 가격을 취소선과 함께 표시
                      Text(
                        '${numberFormat.format(totalOriginalPrice)}원',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Row(
                        children: [
                          // 할인 가격을 Bold체로 표시
                          Text(
                            '${numberFormat.format(totalDiscountPrice)}원',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          // 할인 퍼센트를 빨간색으로 Bold체로 표시
                          Text(
                            '${cartItem['discount_percent']?.round() ?? 0}%',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          // 선택된 색상 이미지가 있을 경우 이미지 표시
                          if (cartItem['selected_color_image'] != null)
                            Image.network(
                              cartItem['selected_color_image'] ?? '',
                              height: 20,
                              width: 20,
                              fit: BoxFit.cover,
                            ),
                          SizedBox(width: 8),
                          // 선택된 색상 텍스트를 표시
                          Text(
                            '${cartItem['selected_color_text'] ?? ''}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      // 선택된 사이즈를 왼쪽 여백을 주어 표시
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Text(
                          '${cartItem['selected_size'] ?? ''}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Center(
                // 수량 조절 버튼과 삭제 버튼을 중앙에 정렬하여 표시
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 수량 감소 버튼, 1보다 큰 경우에만 수량 감소
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (cartItem['selected_count'] > 1) {
                          ref.read(cartItemsProvider.notifier)
                              .updateItemQuantity(cartItem['id'], cartItem['selected_count'] - 1);
                        }
                      },
                    ),
                    // 현재 선택된 수량을 중앙에 표시
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
                        ref.read(cartItemsProvider.notifier)
                            .updateItemQuantity(cartItem['id'], cartItem['selected_count'] + 1);
                      },
                    ),
                    // 수량 직접 입력 버튼
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            final TextEditingController controller = TextEditingController();
                            String input = '';
                            // 수량 입력을 위한 AlertDialog 생성
                            return AlertDialog(
                              title: Text('수량 입력', style: TextStyle(color: Colors.black)),
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
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                              actions: <TextButton>[
                                TextButton(
                                  child: Text('확인', style: TextStyle(color: Colors.black)),
                                  onPressed: () {
                                    // 입력값이 비어 있지 않을 경우 수량 업데이트
                                    if (input.isNotEmpty) {
                                      ref.read(cartItemsProvider.notifier)
                                          .updateItemQuantity(cartItem['id'], int.parse(input));
                                    }
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('직접 입력', style: TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                    SizedBox(width: 50),
                    // 삭제 버튼, 클릭 시 장바구니에서 해당 상품을 삭제하고 스낵바 표시
                    ElevatedButton(
                      onPressed: () {
                        ref.read(cartItemsProvider.notifier)
                            .removeItem(cartItem['id']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('상품이 장바구니에서 삭제되었습니다.')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: BUTTON_COLOR,
                        backgroundColor: BACKGROUND_COLOR,
                        side: BorderSide(color: BUTTON_COLOR),
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text('삭제', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 카드의 배경색과 그림자, 패딩 설정
          backgroundColor: BEIGE_COLOR,
          elevation: 2,
          padding: const EdgeInsets.all(8),
        );
      }).toList(),
    );
  }
}
// ------ 장바구니 화면 내 파이어스토어에 있는 장바구니에 담긴 상품 아이템 데이터를 UI로 구현하는 CartItemsList 클래스 끝

