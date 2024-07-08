import 'package:dongdaemoon_beta_v1/common/const/colors.dart';
import 'package:flutter/material.dart'; // Flutter의 Material Design 위젯을 사용하기 위해 import
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리 패키지를 사용하기 위해 import
import 'package:intl/intl.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../product/layout/product_body_parts_layout.dart';
import '../../product/model/product_model.dart'; // 제품 모델을 사용하기 위해 import
import '../../product/provider/product_state_provider.dart'; // 제품 상태 제공자를 사용하기 위해 import
import '../../wishlist/layout/wishlist_body_parts_layout.dart';
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
    // cartItemsProvider를 통해 장바구니 아이템 목록을 가져옴
    final cartItems = ref.watch(cartItemsProvider);

    // 장바구니가 비어있을 경우 보여줄 텍스트
    if (cartItems.isEmpty) {
      return Text('장바구니가 비어 있습니다.');
    }

    // 숫자 형식을 지정하기 위한 NumberFormat 객체 생성
    final numberFormat = NumberFormat('###,###');

    // ProductInfoDetailScreenNavigation 인스턴스 생성
    final navigatorProductDetailScreen = ProductInfoDetailScreenNavigation(ref);

    // 장바구니 아이템들을 UI로 표시
    return Column(
      children: cartItems.map((cartItem) {
        // 원래 가격을 정수로 변환
        final int originalPrice = cartItem['original_price']?.round() ?? 0;
        // 할인된 가격을 정수로 변환
        final int discountPrice = cartItem['discount_price']?.round() ?? 0;
        // 선택된 수량을 정수로 변환
        final int selectedCount = cartItem['selected_count'] ?? 1;
        // 원래 가격에 선택된 수량을 곱한 값
        final int totalOriginalPrice = originalPrice * selectedCount;
        // 할인된 가격에 선택된 수량을 곱한 값
        final int totalDiscountPrice = discountPrice * selectedCount;

        // CommonCardView 위젯으로 각 아이템 표시
        return CommonCardView(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 체크박스 표시
                  Transform.scale(
                    scale: 1.5,  // 체크박스 크기 조절
                    child: Checkbox(
                      value: cartItem['checked'] ?? false,  // 체크박스의 초기값 설정
                      activeColor: BUTTON_COLOR,  // 체크박스 색상 변경
                      onChanged: (bool? value) {  // 체크박스 상태가 변경될 때 호출되는 콜백 함수
                        ref.read(cartItemsProvider.notifier)
                            .toggleItemChecked(cartItem['id'], value!);  // 체크박스 상태 변경 로직 호출
                      },
                    ),
                  ),
                  // 아이템 이름 중앙 정렬
                  Expanded(
                    child: Center(
                      child: Text(
                        '${cartItem['brief_introduction'] ?? ''}',  // 아이템의 간단한 설명
                        style: TextStyle(
                          fontSize: 18,  // 글자 크기 설정
                          fontWeight: FontWeight.bold,  // 글자 두께 설정
                        ),
                      ),
                    ),
                  ),
                  // 찜 마크 표시 버튼 생성
                  Transform.scale(
                    scale: 1.5,  // 찜 마크 크기 조절
                    child: WishlistIconButton(docId: cartItem['product_id'], ref: ref), // WishlistIconButton 재사용하여 구현
                  ),
                ],
              ),
              Row(
                children: [
                  // 썸네일 이미지 표시
                  if (cartItem['thumbnails'] != null)  // 썸네일 이미지가 있는 경우에만 표시
                    GestureDetector(
                      onTap: () {  // 썸네일 클릭 시 호출되는 함수
                        // 썸네일 클릭 시 해당 상품 상세 화면으로 이동
                        navigatorProductDetailScreen.navigateToDetailScreen(
                          context,
                          ProductContent(
                            docId: cartItem['product_id'],  // 상품 ID
                            thumbnail: cartItem['thumbnails'],  // 썸네일 이미지 URL
                            briefIntroduction: cartItem['brief_introduction'],  // 상품 간단 설명
                            originalPrice: cartItem['original_price'],  // 원래 가격
                            discountPrice: cartItem['discount_price'],  // 할인된 가격
                            discountPercent: cartItem['discount_percent'],  // 할인율
                          ),
                        );
                      },
                      child: Image.network(
                        cartItem['thumbnails'] ?? '',  // 썸네일 이미지 URL
                        height: 130,  // 이미지 높이
                        width: 130,  // 이미지 너비
                        fit: BoxFit.cover,  // 이미지 맞추기 설정
                      ),
                    ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 원래 가격 표시
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
                          // 할인된 가격 표시
                          Text(
                            '${numberFormat.format(totalDiscountPrice)}원',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          // 할인율 표시
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
                          // 선택된 색상 이미지 표시
                          if (cartItem['selected_color_image'] != null)
                            Image.network(
                              cartItem['selected_color_image'] ?? '',
                              height: 20,
                              width: 20,
                              fit: BoxFit.cover,
                            ),
                          SizedBox(width: 8),
                          // 선택된 색상 텍스트 표시
                          Text(
                            '${cartItem['selected_color_text'] ?? ''}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      // 선택된 사이즈 텍스트 표시
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0), // 10 정도 우측으로 이동
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
                // 수량 조절 버튼과 직접 입력 버튼
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 수량 감소 버튼
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        // 수량이 1보다 클 때만 감소
                        if (cartItem['selected_count'] > 1) {
                          ref.read(cartItemsProvider.notifier)
                              .updateItemQuantity(cartItem['id'], cartItem['selected_count'] - 1);
                        }
                      },
                    ),
                    // 현재 수량 표시
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
                        // 수량 입력을 위한 다이얼로그 표시
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            final TextEditingController controller = TextEditingController();
                            String input = '';
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
                                  // 포커스된 상태의 밑줄 색상을 검정으로 변경.
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black), // 밑줄 색상 변경
                                  ),
                                ),
                              ),
                              actions: <TextButton>[
                                TextButton(
                                  child: Text('확인', style: TextStyle(color: Colors.black)),
                                  onPressed: () {
                                    // 입력된 수량이 비어있지 않을 경우 수량 업데이트
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
                    // '삭제' 버튼 생성
                    ElevatedButton(
                      onPressed: () {
                        ref.read(cartItemsProvider.notifier)
                            .removeItem(cartItem['id']); // 해당 프로바이더와 연결된 파이어스토어 내 상품 데이터 삭제
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('상품이 장바구니에서 삭제되었습니다.')),
                        ); // 메세지 노출
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
          backgroundColor: BEIGE_COLOR,
          elevation: 2,
          padding: const EdgeInsets.all(8),
        );
      }).toList(),
    );
  }
}
// ------ 장바구니 화면 내 파이어스토어에 있는 장바구니에 담긴 상품 아이템 데이터를 UI로 구현하는 CartItemsList 클래스 끝

