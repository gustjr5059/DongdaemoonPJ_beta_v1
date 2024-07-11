import 'package:dongdaemoon_beta_v1/product/model/product_model.dart'; // Product 모델 클래스 임포트
import 'package:flutter/cupertino.dart'; // Cupertino 디자인을 사용하기 위한 패키지 임포트
import 'package:flutter/material.dart'; // Material 디자인을 사용하기 위한 패키지 임포트
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위한 Riverpod 패키지 임포트
import 'package:intl/intl.dart';
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../product/layout/product_body_parts_layout.dart';
import '../provider/wishlist_future_provider.dart'; // 찜 목록의 비동기 동작을 위한 Provider 임포트
import '../provider/wishlist_state_provider.dart'; // 찜 목록의 상태 관리를 위한 Provider 임포트

// ------- 찜 목록 아이콘 동작 로직 관련 클래스인 WishlistIconButton 내용 구현 시작
// 찜 목록 아이콘 버튼 위젯을 구현하는 클래스
class WishlistIconButton extends ConsumerWidget {
  // ProductContent 타입의 product를 필드로 가짐
  final ProductContent product;

  // 생성자를 통해 필드 초기화
  WishlistIconButton({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // wishlistItemProvider의 상태를 구독하여 asyncWishlist 변수에 저장
    final asyncWishlist = ref.watch(wishlistItemProvider);

    // asyncWishlist 상태에 따라 위젯을 빌드
    return asyncWishlist.when(
      // 데이터가 로드된 경우
      data: (wishlist) {
        // 찜 목록에 현재 상품이 있는지 확인
        final isWished = wishlist.contains(product.docId);
        // 아이콘 버튼 반환
        return IconButton(
          // 찜 목록에 있는 경우 꽉 찬 하트 아이콘, 그렇지 않은 경우 빈 하트 아이콘
          icon: Icon(
            isWished ? Icons.favorite : Icons.favorite_border,
            // 찜 목록에 있는 경우 빨간색, 그렇지 않은 경우 회색
            color: isWished ? Colors.red : Colors.grey,
          ),
          // 버튼 클릭 시 동작 정의
          onPressed: () async {
            // wishlistItemProvider의 notifier를 가져옴
            final wishlistNotifier = ref.read(wishlistItemProvider.notifier);
            // wishlistItemRepositoryProvider를 가져옴
            final wishlistRepository = ref.read(wishlistItemRepositoryProvider);

            if (isWished) {
              // 찜 목록에 있는 경우 제거
              wishlistNotifier.toggleItem(product.docId);
              try {
                // Firestore에서 찜 목록에서 제거
                await wishlistRepository.removeFromWishlistItem(product.docId);
                // 성공 메시지 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('상품이 찜 목록에서 비워졌습니다.')),
                );
              } catch (e) {
                // 오류 발생 시 다시 추가
                wishlistNotifier.toggleItem(product.docId);
                // 오류 메시지 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('찜 목록에서 비우는 중 오류가 발생했습니다.')),
                );
              }
            } else {
              // 찜 목록에 없는 경우 추가
              wishlistNotifier.toggleItem(product.docId);
              try {
                // Firestore에서 찜 목록에 추가
                await wishlistRepository.addToWishlistItem(product);
                // 성공 메시지 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('상품이 찜 목록에 담겼습니다.')),
                );
              } catch (e) {
                // 오류 발생 시 다시 제거
                wishlistNotifier.toggleItem(product.docId);
                // 오류 메시지 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('찜 목록에 담는 중 오류가 발생했습니다.')),
                );
              }
            }
          },
        );
      },
      // 로딩 중인 경우 로딩 인디케이터 표시
      loading: () => CircularProgressIndicator(),
      // 오류 발생 시 오류 아이콘 표시
      error: (e, stack) => Icon(Icons.error),
    );
  }
}
// ------- 찜 목록 아이콘 동작 로직 관련 클래스인 WishlistIconButton 내용 구현 끝

// ------- 찜 목록 화면 내 파이어베이스의 찜 목록 상품 데이터를 불러와서 UI로 구현하는 클래스 내용 시작
class WishlistItemsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // wishlistItemsStreamProvider를 통해 찜 목록 항목의 스트림을 감시하여, wishlistItemsAsyncValue에 할당.
    final wishlistItemsAsyncValue = ref.watch(wishlistItemsStreamProvider);

    // cartItemsAsyncValue의 상태에 따라 위젯을 빌드.
    return wishlistItemsAsyncValue.when(
      // 데이터가 성공적으로 로드되었을 때 실행되는 콜백 함수.
      data: (wishlistItems) {
        // 장바구니 항목이 비어있을 경우의 조건문.
        if (wishlistItems.isEmpty) {
          // 장바구니가 비어있을 때 화면에 보여줄 텍스트 위젯을 반환.
          return Center(child: Text('장바구니가 비어 있습니다.'));
        }

        // 숫자 형식을 지정하기 위한 NumberFormat 객체 생성
        final numberFormat = NumberFormat('###,###');

        // ProductInfoDetailScreenNavigation 인스턴스 생성
        final navigatorProductDetailScreen = ProductInfoDetailScreenNavigation(ref);

        // 장바구니 아이템들을 UI로 표시
        return Column(
          children: wishlistItems.map((wishlistItem) {

            // 원래 가격을 정수로 변환
            final int originalPrice = wishlistItem['original_price']?.round() ?? 0;
            // 할인된 가격을 정수로 변환
            final int discountPrice = wishlistItem['discount_price']?.round() ?? 0;

            // ProductContent 객체 생성
            final product = ProductContent(
              docId: wishlistItem['product_id'],
              thumbnail: wishlistItem['thumbnails'],
              briefIntroduction: wishlistItem['brief_introduction'],
              originalPrice: wishlistItem['original_price'],
              discountPrice: wishlistItem['discount_price'],
              discountPercent: wishlistItem['discount_percent'],
            );

            // CommonCardView 위젯으로 각 아이템 표시
            return CommonCardView(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // 아이템 이름 중앙 정렬
                      Expanded(
                        child: Center(
                          child: Text(
                            '${wishlistItem['brief_introduction'] ?? ''}',  // 아이템의 간단한 설명
                            style: TextStyle(
                              fontSize: 18,  // 글자 크기 설정
                              fontWeight: FontWeight.bold,  // 글자 두께 설정
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // 썸네일 이미지 표시
                      if (wishlistItem['thumbnails'] != null)  // 썸네일 이미지가 있는 경우에만 표시
                        GestureDetector(
                          onTap: () {  // 썸네일 클릭 시 호출되는 함수
                            // 썸네일 클릭 시 해당 상품 상세 화면으로 이동
                            navigatorProductDetailScreen.navigateToDetailScreen(
                              context,
                              product,
                            );
                          },
                          child: Image.network(
                            wishlistItem['thumbnails'] ?? '',  // 썸네일 이미지 URL
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
                            '${numberFormat.format(originalPrice)}원',
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
                                '${numberFormat.format(discountPrice)}원',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              // 할인율 표시
                              Text(
                                '${wishlistItem['discount_percent']?.round() ?? 0}%',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ],
                  ),
                  Center(
                    // 수량 조절 버튼과 직접 입력 버튼
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 50),
                        // '삭제' 버튼 생성
                        ElevatedButton(
                          onPressed: () {
                            final String? itemId = wishlistItem['product_id'];
                            if (itemId != null) {
                              ref.read(wishlistItemProvider.notifier).removeItem(itemId); // 해당 프로바이더와 연결된 파이어스토어 내 상품 데이터 삭제
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('상품이 찜 목록에서 삭제되었습니다.')),
                              ); // 메세지 노출
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('상품 ID가 유효하지 않습니다.')),
                              );
                            }
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
      },
      // 데이터가 로딩 중일 때 실행되는 콜백 함수.
      loading: () => Center(child: CircularProgressIndicator()),
      // 데이터 로딩 중 오류가 발생했을 때 실행되는 콜백 함수.
      error: (error, stack) => Center(child: Text('오류가 발생했습니다.')),
    );
  }
}
// ------- 찜 목록 화면 내 파이어베이스의 찜 목록 상품 데이터를 불러와서 UI로 구현하는 클래스 내용 끝