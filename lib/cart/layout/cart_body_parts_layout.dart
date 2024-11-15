import 'package:dongdaemoon_beta_v1/common/const/colors.dart';
import 'package:flutter/material.dart'; // Flutter의 Material Design 위젯을 사용하기 위해 import
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리 패키지를 사용하기 위해 import
import 'package:intl/intl.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../product/layout/product_body_parts_layout.dart';
import '../../product/model/product_model.dart'; // 제품 모델을 사용하기 위해 import
import '../../product/provider/product_state_provider.dart'; // 제품 상태 제공자를 사용하기 위해 import
import '../provider/cart_all_proviers.dart';
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
  final selectedCount = ref.read(
      detailQuantityIndexProvider); // detailQuantityIndexProvider를 사용하여 선택된 수량을 읽음

  cartRepository
      .addToCartItem(context,
      product, selectedColorText, selectedColorUrl, selectedSize, selectedCount)
      .then((isAdded) { // addToCartItem에서 성공 여부를 받아 처리
    if (isAdded) { // 만약 데이터가 실제로 추가되었다면 성공 메시지를 표시
      showCustomSnackBar(context, '해당 상품이 장바구니 목록에 담겼습니다.'); // 성공 메시지를 화면에 표시
    }
  }).catchError((error) {
    // 에러가 발생할 경우
    showCustomSnackBar(context, '장바구니에 상품을 담는 중 오류가 발생했습니다.'); // 오류 메시지를 화면에 표시
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

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치를 설정함

    // 장바구니 카드뷰 섹션 크기 설정
    final double cartlistCardViewWidth =
        screenSize.width * (393 / referenceWidth); // 화면 가로 비율에 맞게 설정함
    final double cartlistCardViewHeight =
        screenSize.height * (320 / referenceHeight); // 화면 세로 비율에 맞게 설정함
    final double cartlistCardViewPaddingX =
        screenSize.width * (15 / referenceWidth); // 가로 패딩을 화면 비율에 맞게 설정함
    // 썸네일 이미지 크기 설정
    final double cartlistThumnailPartWidth =
        screenSize.width * (120 / referenceWidth); // 썸네일 가로 비율 설정함
    final double cartlistThumnailPartHeight =
        screenSize.width * (120 / referenceWidth); // 썸네일 세로 비율 설정함
    // 상품 색상 이미지 크기 설정
    final double cartlistSelctedColorImageDataWidth =
        screenSize.width * (16 / referenceWidth); // 색상 이미지 가로 크기 설정함
    final double cartlistSelctedColorImageDataHeight =
        screenSize.width * (16 / referenceWidth); // 색상 이미지 세로 크기 설정함
    // 텍스트 데이터 패딩 및 글꼴 크기 설정
    final double cartlistDataPaddingX =
        screenSize.width * (13 / referenceWidth); // 텍스트 데이터의 가로 패딩 설정함
    final double cartlistDataPaddingY =
        screenSize.height * (10 / referenceHeight); // 텍스트 데이터의 세로 패딩 설정함
    final double cartlistProductNumberFontSize =
        screenSize.height * (13 / referenceHeight); // 상품 번호 글꼴 크기 설정함
    final double cartlistTextDataPartHeight =
        screenSize.height * (140 / referenceHeight); // 텍스트 데이터 부분의 높이 설정함
    final double cartlistBriefIntroductionFontSize =
        screenSize.height * (16 / referenceHeight); // 간략한 설명 글꼴 크기 설정함
    final double cartlistOriginalPriceFontSize =
        screenSize.height * (13 / referenceHeight); // 원래 가격 글꼴 크기 설정함
    final double cartlistDiscountPercentFontSize =
        screenSize.height * (16 / referenceHeight); // 할인 퍼센트 글꼴 크기 설정함
    final double cartlistDiscountPriceFontSize =
        screenSize.height * (16 / referenceHeight); // 할인 가격 글꼴 크기 설정함
    final double cartlistSelectedColorTextFontSize =
        screenSize.height * (15 / referenceHeight); // 선택된 색상 텍스트 글꼴 크기 설정함
    final double cartlistSelectedSizeTextFontSize =
        screenSize.height * (15 / referenceHeight); // 선택된 사이즈 텍스트 글꼴 크기 설정함
    // 삭제 버튼 글꼴 및 위치 설정
    final double cartlistDeleteBtnFontSize =
        screenSize.height * (13 / referenceHeight); // 삭제 버튼 글꼴 크기 설정함
    final double cartlistDeleteBtn1X =
        screenSize.width * (10 / referenceWidth); // 삭제 버튼 가로 위치 설정함
    final double cartlistDeleteBtn1Y =
        screenSize.width * (1 / referenceHeight); // 삭제 버튼 세로 위치 설정함
    // 수량 업데이트 부분 설정
    final double cartlistUpdateItemQuantityBtnSize =
        screenSize.height * (20 / referenceHeight); // 수량 업데이트 버튼 크기 설정함
    final double cartlistUpdateItemQuantityBtnFontSize =
        screenSize.height * (16 / referenceHeight); // 수량 업데이트 버튼 글꼴 크기 설정함
    final double cartlistUpdateItemQuantityWidth =
        screenSize.width * (80 / referenceWidth); // 수량 업데이트 버튼 너비 설정함

    // 텍스트 데이터 간 너비 및 높이 설정
    final double cartlist1X =
        screenSize.width * (12 / referenceWidth); // 텍스트 간 가로 여백 설정함
    final double cartlist2X =
        screenSize.width * (19 / referenceWidth); // 텍스트 간 가로 여백 설정함
    final double cartlist3X =
        screenSize.width * (30 / referenceWidth); // 텍스트 간 가로 여백 설정함
    final double cartlist4X = screenSize.width * (8 / referenceWidth);
    final double cartlist1Y =
        screenSize.width * (6 / referenceWidth); // 텍스트 간 세로 여백 설정함
    final double cartlist2Y =
        screenSize.width * (8 / referenceWidth); // 텍스트 간 세로 여백 설정함

    final double interval1X =
        screenSize.width * (70 / referenceWidth);

    // 직접입력 버튼 수치
    final double directInsertBtnWidth = screenSize.width * (100 / referenceWidth);
    final double directInsertBtnHeight = screenSize.height * (40 / referenceHeight);
    final double directInsertBtnFontSize = screenSize.height * (14 / referenceHeight);


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
        // 상품의 원래 가격을 정수형으로 변환, 값이 없을 경우 빈 값으로 설정
        final int originalPrice = cartItem['original_price']?.round() ?? 0;
        // 상품의 할인 가격을 정수형으로 변환, 값이 없을 경우 빈 값으로 설정
        final int discountPrice = cartItem['discount_price']?.round() ?? 0;
        // 선택된 상품의 수량을 가져옴, 값이 없을 경우 빈 값으로 설정
        final int selectedCount = cartItem['selected_count'] ?? 1;
        // 원래 가격에 선택된 수량을 곱한 값을 계산, 값이 없을 경우 빈 값으로 설정
        final dynamic totalOriginalPrice =
        (originalPrice is int && selectedCount is int)
            ? originalPrice * selectedCount
            : 0;
        // 할인 가격에 선택된 수량을 곱한 값을 계산, 값이 없을 경우 빈 값으로 설정
        final dynamic totalDiscountPrice =
        (discountPrice is int && selectedCount is int)
            ? discountPrice * selectedCount
            : 0;

        // ProductContent 인스턴스를 생성하여 상품의 상세 정보를 저장
        final product = ProductContent(
          docId: cartItem['product_id'],
          category: cartItem['category'],
          productNumber: cartItem['product_number'],
          thumbnail: cartItem['thumbnails'],
          briefIntroduction: cartItem['brief_introduction'],
          originalPrice: cartItem['original_price'],
          discountPrice: cartItem['discount_price'],
          discountPercent: cartItem['discount_percent'],
          maxStockQuantity: cartItem['max_stock_quantity'] ?? 10001, // max_stock_quantity가 없을 경우 기본값 10001 사용
        );

        // GestureDetector로 CommonCardView를 감싸서 카드뷰 전체를 클릭할 수 있도록 함
        return GestureDetector(
          onTap: () {
            navigatorProductDetailScreen.navigateToDetailScreen(context, product);
          },
          child: Container(
            width: cartlistCardViewWidth,  // CommonCardView의 너비를 설정함
            height: cartlistCardViewHeight, // CommonCardView의 높이를 설정함
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
              ),
            ),
            child: CommonCardView(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          // 체크박스의 체크 여부를 cartItem의 bool_checked 값으로 설정함
                          value: cartItem['bool_checked'] ?? false,
                          activeColor: ORANGE56_COLOR,
                          // 체크박스 상태 변경 시 cartItemsProvider의 상태를 업데이트함
                          onChanged: (bool? value) {
                            ref.read(cartItemsProvider.notifier)
                                .toggleItemChecked(cartItem['id'], value!);
                          },
                        ),
                      ),
                      // 체크박스와 삭제 버튼 사이의 공간을 차지하여 삭제 버튼이 오른쪽 끝에 위치하도록 함
                      Expanded(
                        child: Container(),
                      ),
                      // 삭제 버튼을 오른쪽 끝에 배치함
                      Container(
                        child: ElevatedButton(
                          // 삭제 버튼을 누를 때 실행되는 비동기 함수를 정의함
                          onPressed: () async {
                            await showSubmitAlertDialog(
                              context, // 현재 화면의 컨텍스트를 전달함
                              title: '[장바구니 목록 삭제]', // 대화상자의 제목을 설정함
                              content: '상품을 삭제하시겠습니까?', // 대화상자의 내용을 경고 메시지로 설정함
                              actions: buildAlertActions(
                                context, // 현재 화면의 컨텍스트를 전달함
                                noText: '아니요', // '아니요' 버튼 텍스트를 설정함
                                yesText: '예', // '예' 버튼 텍스트를 설정함
                                noTextStyle: TextStyle(
                                  fontFamily: 'NanumGothic',
                                  color: BLACK_COLOR, // '아니요' 텍스트 색상을 검정색으로 설정함
                                  fontWeight: FontWeight.bold, // 텍스트를 굵게 설정함
                                ),
                                yesTextStyle: TextStyle(
                                  fontFamily: 'NanumGothic',
                                  color: RED46_COLOR, // '예' 텍스트 색상을 빨간색으로 설정함
                                  fontWeight: FontWeight.bold, // 텍스트를 굵게 설정함
                                ),
                                // '예' 버튼이 눌렸을 때 실행될 비동기 함수를 정의함
                                onYesPressed: () async {
                                  try {
                                    final String? itemId = cartItem['id'];
                                    if (itemId != null) {
                                      ref.read(cartItemsProvider.notifier)
                                          .removeItem(itemId);
                                      Navigator.of(context).pop(); // 삭제 후 대화상자를 닫음
                                      showCustomSnackBar(context, '상품이 장바구니 목록에서 삭제되었습니다.');
                                    } else {
                                      // 유효하지 않은 상품 ID 메시지를 표시함
                                      showCustomSnackBar(context, '삭제하는 중 오류가 발생했습니다.');
                                    }
                                  } catch (e) { // 예외가 발생할 경우 에러 메시지를 처리함
                                    showCustomSnackBar(context, '삭제 중 오류 발생: $e'); // 오류 메시지를 텍스트로 표시함
                                  }
                                },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: cartlistDeleteBtn1X, vertical: cartlistDeleteBtn1Y), // 버튼의 크기를 패딩으로 설정함
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35), // 버튼을 둥글게 설정함
                              side: BorderSide(color: GRAY65_COLOR),
                            ),
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                          ),
                          child: Text(
                              '삭제',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NanumGothic',
                                fontSize: cartlistDeleteBtnFontSize,
                                color: GRAY40_COLOR,
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                  // 상품의 간단한 설명을 중앙에 Bold체로 표시함
                  Padding(
                    padding: EdgeInsets.only(left: cartlistDataPaddingX, bottom: cartlistDataPaddingY),
                    child: Text(
                      '${cartItem['brief_introduction'] ?? ''}',
                      style: TextStyle(
                        fontSize: cartlistBriefIntroductionFontSize,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NanumGothic',
                        color: BLACK_COLOR,
                      ),
                      maxLines: 1, // 한 줄로 표시되도록 설정함
                      overflow: TextOverflow.ellipsis, // 넘칠 경우 말줄임표로 처리함
                    ),
                  ),
                  Row(
                    children: [
                      // 썸네일 이미지를 표시함
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 상품 번호를 표시함
                            if (cartItem['product_number'] != null && cartItem['product_number'] != '')
                              Padding(
                                padding: EdgeInsets.only(left: cartlistDataPaddingX, bottom: cartlistDataPaddingY),
                                child: Text(
                                  '상품번호: ${cartItem['product_number'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: cartlistProductNumberFontSize,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NanumGothic',
                                    color: BLACK_COLOR,
                                  ),
                                ),
                              ),
                            Container(
                              height: cartlistThumnailPartHeight,
                              width: cartlistThumnailPartWidth,
                              padding: EdgeInsets.only(left: cartlistDataPaddingX, bottom: cartlistDataPaddingY),
                              child: cartItem['thumbnails'] != null && cartItem['thumbnails'] != ''
                                  ? FittedBox(
                                fit: BoxFit.cover,
                                child: Image.network(
                                  cartItem['thumbnails']!,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.image_not_supported, // 이미지 로드 실패 시 아이콘 표시
                                    color: GRAY88_COLOR,
                                    size: cartlistThumnailPartWidth,
                                  ),
                                ),
                              )
                                  : Icon(
                                Icons.image_not_supported, // 썸네일 데이터가 없을 경우 아이콘 표시
                                color: GRAY88_COLOR,
                                size: cartlistThumnailPartWidth,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(width: cartlist4X),
                      Container(
                        height: cartlistTextDataPartHeight,
                        padding: EdgeInsets.only(top: cartlistDataPaddingY * 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 원래 가격을 취소선과 함께 표시함
                            Text(
                              '${totalOriginalPrice != null ? numberFormat.format(totalOriginalPrice) : ''}원',
                              style: TextStyle(
                                fontSize: cartlistOriginalPriceFontSize,
                                fontFamily: 'NanumGothic',
                                color: GRAY60_COLOR,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Row(
                              children: [
                                // 할인 가격을 Bold체로 표시함
                                Text(
                                  '${totalDiscountPrice != null ? numberFormat.format(totalDiscountPrice) : ''}원',
                                  style: TextStyle(
                                    fontSize: cartlistDiscountPriceFontSize,
                                    fontFamily: 'NanumGothic',
                                    fontWeight: FontWeight.bold,
                                    color: BLACK_COLOR,
                                  ),
                                ),
                                SizedBox(width: cartlist2X),
                                // 할인 퍼센트를 빨간색으로 Bold체로 표시함
                                Text(
                                  '${cartItem['discount_percent']?.round() ?? ''}%',
                                  style: TextStyle(
                                    fontSize: cartlistDiscountPercentFontSize,
                                    fontFamily: 'NanumGothic',
                                    color: RED46_COLOR,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: cartlist1Y),
                            Row(
                              children: [
                                // 선택된 색상 이미지가 있을 경우 이미지를 표시함
                                cartItem['selected_color_image'] != null && cartItem['selected_color_image'] != ''
                                  ? Image.network(
                                    cartItem['selected_color_image'] ?? '',
                                    height: cartlistSelctedColorImageDataHeight,
                                    width: cartlistSelctedColorImageDataWidth,
                                    fit: BoxFit.cover,
                                  // 이미지 로드 실패 시 아이콘 표시
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.image_not_supported,
                                    color: GRAY88_COLOR,
                                    size: cartlistSelctedColorImageDataWidth,
                                  ),
                                )
                                    : Icon(
                                  Icons.image_not_supported,
                                  color: GRAY88_COLOR,
                                  size: cartlistSelctedColorImageDataWidth,
                                ), // 썸네일이 없을 때 아이콘을 표시
                                SizedBox(width: cartlist1X),
                                // 선택된 색상 텍스트를 표시함
                                Text(
                                  '${cartItem['selected_color_text'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: cartlistSelectedColorTextFontSize,
                                    fontFamily: 'NanumGothic',
                                    fontWeight: FontWeight.bold,
                                    color: BLACK_COLOR,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: cartlist1Y),
                            // 선택된 사이즈를 왼쪽 여백을 주어 표시함
                            Padding(
                              padding: EdgeInsets.only(left: cartlist3X),
                              child: Text(
                                '${cartItem['selected_size'] ?? ''}',
                                style: TextStyle(
                                  fontSize: cartlistSelectedSizeTextFontSize,
                                  fontFamily: 'NanumGothic',
                                  fontWeight: FontWeight.bold,
                                  color: BLACK_COLOR,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // ——— 중앙에 수량 조절 및 삭제 버튼이 있는 위젯을 표시하는 Center 위젯
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Row를 중앙에 정렬함
                      children: [
                        // ——— 수량 감소 버튼, 선택된 수량이 1 이상일 때만 활성화됨
                        IconButton(
                          icon: Icon(Icons.remove, size: cartlistUpdateItemQuantityBtnSize), // '-' 아이콘 설정
                          onPressed: () {
                            if (cartItem['selected_count'] > 1) { // 선택된 수량이 1보다 클 경우
                              ref.read(cartItemsProvider.notifier)
                                  .updateItemQuantity(cartItem['id'], cartItem['selected_count'] - 1); // 수량 감소
                            }
                          },
                        ),
                        // ——— 현재 선택된 수량을 중앙에 표시하는 컨테이너
                        Container(
                          width: cartlistUpdateItemQuantityWidth, // 수량 표시 넓이
                          alignment: Alignment.center, // 텍스트를 중앙에 정렬함
                          child: Text(
                            numberFormat.format(cartItem['selected_count'] ?? ''), // 선택된 수량을 형식에 맞게 표시함
                            style: TextStyle(
                              fontSize: cartlistUpdateItemQuantityBtnFontSize, // 텍스트 크기 설정
                              fontFamily: 'NanumGothic', // 폰트 설정
                              fontWeight: FontWeight.normal, // 글꼴 굵기 설정
                              color: BLACK_COLOR, // 텍스트 색상 설정
                            ),
                          ),
                        ),
                        // ——— 수량 증가 버튼, maxStockQuantity를 초과하지 않도록 제한함
                        IconButton(
                          icon: Icon(Icons.add, size: cartlistUpdateItemQuantityBtnSize), // '+' 아이콘 설정
                          onPressed: () {
                            if (cartItem['selected_count'] < product.maxStockQuantity - 1) { // maxStockQuantity 확인
                              ref.read(cartItemsProvider.notifier)
                                  .updateItemQuantity(cartItem['id'], cartItem['selected_count'] + 1); // 수량 증가
                            } else {
                              showCustomSnackBar(context, '최대 수량을 초과했습니다. 최대 수량: ${numberFormat.format(product.maxStockQuantity - 1)}개'); // 알림 메시지 표시
                            }
                          },
                        ),
                        SizedBox(width: cartlist3X), // 버튼 간격 조정
                        // ——— 수량을 직접 입력할 수 있는 버튼
                        Container(
                          width: directInsertBtnWidth, // 버튼 넓이 설정
                          height: directInsertBtnHeight, // 버튼 높이 설정
                          child: ElevatedButton(
                            onPressed: () async {
                              final TextEditingController controller = TextEditingController(); // 텍스트 입력 컨트롤러 초기화
                              String input = ''; // 입력된 값 초기화

                              // ——— 수량 입력 알림창을 표시하는 함수
                              await showSubmitAlertDialog(
                                context,
                                title: '[수량 입력]', // 알림창 제목
                                contentWidget: Material( // 알림창 내부를 Material로 감쌈
                                  color: Colors.transparent, // 투명 배경색 설정
                                  child: TextField(
                                    controller: controller, // 컨트롤러 설정
                                    keyboardType: TextInputType.number, // 숫자 입력 전용 키보드 표시
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly // 숫자만 입력 가능하도록 필터링
                                    ],
                                    autofocus: true, // 자동 포커스 활성화
                                    onChanged: (value) {
                                      input = value; // 입력된 값을 input 변수에 저장
                                    },
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: BLACK_COLOR), // 포커스 시 테두리 색상 설정
                                      ),
                                    ),
                                  ),
                                ),
                                actions: buildAlertActions(
                                  context,
                                  noText: '취소', // '취소' 버튼 텍스트
                                  yesText: '확인', // '확인' 버튼 텍스트
                                  noTextStyle: TextStyle(
                                    fontFamily: 'NanumGothic', // '취소' 텍스트 폰트 설정
                                    color: BLACK_COLOR, // '취소' 텍스트 색상
                                  ),
                                  yesTextStyle: TextStyle(
                                    fontFamily: 'NanumGothic', // '확인' 텍스트 폰트 설정
                                    color: RED46_COLOR, // '확인' 텍스트 색상 설정
                                    fontWeight: FontWeight.bold, // 텍스트 굵게 설정
                                  ),
                                  onYesPressed: () {
                                    if (input.isNotEmpty) { // 입력이 비어있지 않을 경우
                                      int enteredQuantity = int.parse(input); // 입력된 값을 정수로 변환
                                      if (enteredQuantity > 0 && enteredQuantity < product.maxStockQuantity) {
                                        ref.read(cartItemsProvider.notifier)
                                            .updateItemQuantity(cartItem['id'], enteredQuantity); // 수량 업데이트
                                      } else if (enteredQuantity < 1) {
                                        showCustomSnackBar(context, '1개 이상의 수량을 입력해주세요.'); // 최소 수량 알림
                                      } else {
                                        showCustomSnackBar(context, '최대 수량을 초과했습니다. 최대 수량: ${numberFormat.format(product.maxStockQuantity - 1)}개'); // 최대 수량 초과 알림
                                      }
                                      Navigator.of(context).pop(); // 대화창 닫기
                                    }
                                  },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Theme.of(context).scaffoldBackgroundColor, // 버튼 텍스트 색상 설정
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 버튼 배경색 설정
                              side: BorderSide(color: GRAY65_COLOR), // 버튼 테두리 색상 설정
                            ),
                            child: Text('직접입력', // 버튼 텍스트
                              style: TextStyle(
                                fontSize: directInsertBtnFontSize, // 텍스트 크기 설정
                                fontFamily: 'NanumGothic', // 폰트 설정
                                fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                color: GRAY40_COLOR, // 텍스트 색상 설정
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // 카드의 배경색과 그림자, 패딩을 설정함
              backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 카드의 배경색을 앱의 기본 배경색으로 설정함
              elevation: 0,
              margin: EdgeInsets.only(left: cartlistCardViewPaddingX, right: cartlistCardViewPaddingX
              ),
            ),
          ),
         );
        }).toList(),
     );
   }
}
// ------ 장바구니 화면 내 파이어스토어에 있는 장바구니에 담긴 상품 아이템 데이터를 UI로 구현하는 CartItemsList 클래스 끝

