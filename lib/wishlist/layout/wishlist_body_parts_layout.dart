import 'package:dongdaemoon_beta_v1/product/model/product_model.dart'; // Product 모델 클래스 임포트
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart'; // Cupertino 디자인을 사용하기 위한 패키지 임포트
import 'package:flutter/material.dart'; // Material 디자인을 사용하기 위한 패키지 임포트
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위한 Riverpod 패키지 임포트
import 'package:intl/intl.dart';
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../product/layout/product_body_parts_layout.dart';
import '../provider/wishlist_all_providers.dart'; // 찜 목록의 비동기 동작을 위한 Provider 임포트
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
// 현재 로그인된 사용자 정보를 가져옴
    final user = FirebaseAuth.instance.currentUser;
// user가 null인 경우 (로그인되지 않은 경우)
    if (user == null) {
      // 빈 위젯 반환
      return SizedBox.shrink();
    }
    // 현재 로그인한 사용자 이메일 가져옴
    final userEmail = user.email; // 이메일 주소를 가져옴
    if (userEmail == null) {
      throw Exception('User email not available');
    }
// wishlistItemProvider의 상태를 구독하여 asyncWishlist 변수에 저장
    final asyncWishlist = ref.watch(wishlistItemProvider(userEmail));

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
            final wishlistNotifier = ref.read(wishlistItemProvider(userEmail).notifier);
            // wishlistItemRepositoryProvider를 가져옴
            final wishlistRepository = ref.read(wishlistItemRepositoryProvider);

            // 상품이 찜 목록에 있는 경우
            if (isWished) {
              try {
                // 찜 목록에서 상품 제거
                await wishlistRepository.removeFromWishlistItem(userEmail, product.docId);
                // 로컬 상태 업데이트
                wishlistNotifier.removeItem(product.docId);
                // 사용자에게 알림 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('상품이 찜 목록에서 비워졌습니다.')),
                );
              } catch (e) {
                // 오류 발생 시 로컬 상태 복원
                wishlistNotifier.toggleItem(product.docId);
                // 사용자에게 오류 알림 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('찜 목록에서 비우는 중 오류가 발생했습니다.')),
                );
              }
            } else {
              // 상품이 찜 목록에 없는 경우
              try {
                // 찜 목록에 상품 추가
                await wishlistRepository.addToWishlistItem(userEmail, product);
                // 로컬 상태 업데이트
                wishlistNotifier.addItem(product.docId);
                // 사용자에게 알림 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('상품이 찜 목록에 담겼습니다.')),
                );
              } catch (e) {
                // 오류 발생 시 로컬 상태 복원
                wishlistNotifier.toggleItem(product.docId);
                // 사용자에게 오류 알림 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('찜 목록에 담는 중 오류가 발생했습니다.')),
                );
              }
            }
          },
        );
      },
      // 데이터가 로딩 중인 경우
      loading: () => CircularProgressIndicator(),
      // 에러가 발생한 경우
      error: (e, stack) => Icon(Icons.error),
    );
  }
}
// ------- 찜 목록 아이콘 동작 로직 관련 클래스인 WishlistIconButton 내용 구현 끝

// ------- 찜 목록 화면 내 파이어베이스의 찜 목록 상품 데이터를 불러와서 UI로 구현하는 클래스 내용 시작
class WishlistItemsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 로그인된 사용자 정보를 가져옴
    final user = FirebaseAuth.instance.currentUser;

    // user가 null인 경우 (로그인되지 않은 경우)
    if (user == null) {
      // 빈 위젯 반환
      return Center(child: Text('로그인이 필요합니다.'));
    }

    // 현재 로그인한 사용자 이메일 가져옴
    final userEmail = user.email;
    if (userEmail == null) {
      throw Exception('User email not available');
    }

    // wishlistItemsStreamProvider를 통해 찜 목록 항목의 스트림을 감시하여, wishlistItemsAsyncValue에 할당.
    final wishlistItemsAsyncValue = ref.watch(wishlistItemsStreamProvider(userEmail));

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

            return GestureDetector(
              // 탭할 때 상세 화면으로 이동
              onTap: () {
                navigatorProductDetailScreen.navigateToDetailScreen(context, product);
              },
              child: CommonCardView(
                content: Row(
                  children: [
                    Container(
                      // 이미지 컨테이너 너비 설정
                      width: MediaQuery.of(context).size.width * 0.35,
                      // 이미지 컨테이너 높이 설정
                      height: MediaQuery.of(context).size.height * 0.15,
                      // 썸네일이 있을 경우 이미지 표시
                      child: wishlistItem['thumbnails'] != null
                          ? AspectRatio(
                        aspectRatio: 1,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Image.network(
                            wishlistItem['thumbnails'] ?? '',
                          ),
                        ),
                      )
                          : Container(), // 썸네일이 없을 경우 빈 컨테이너 표시
                    ),
                    SizedBox(width: 12),
                    // 남은 공간을 차지하는 위젯
                    Expanded(
                      child: Column(
                        // 자식 위젯들을 왼쪽 정렬
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 짧은 소개 텍스트
                          Text(
                            '${wishlistItem['brief_introduction'] ?? ''}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          // 원래 가격 텍스트
                          Text(
                            '${numberFormat.format(originalPrice)}원',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          // 할인 가격과 할인율을 표시하는 행
                          Row(
                            children: [
                              Text(
                                '${numberFormat.format(discountPrice)}원',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${wishlistItem['discount_percent']?.round() ?? 0}%',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // 삭제 버튼
                          ElevatedButton(
                            onPressed: () {
                              final String? itemId = wishlistItem['product_id'];
                              if (itemId != null) {
                                // 찜 목록에서 상품 제거
                                ref.read(wishlistItemProvider(userEmail).notifier).removeItem(itemId);
                                // 스낵바로 삭제 메시지 표시
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('상품이 찜 목록에서 삭제되었습니다.')),
                                );
                              } else {
                                // 유효하지 않은 상품 ID 메시지 표시
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('상품 ID가 유효하지 않습니다.')),
                                );
                              }
                            },
                            // 버튼 스타일 설정
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
                // 카드 배경색 설정
                backgroundColor: BEIGE_COLOR,
                elevation: 2,
                padding: const EdgeInsets.all(4),
              ),
            );
          }).toList(),
        );
      },
      // 로딩 중일 때 표시할 위젯
      loading: () => Center(child: CircularProgressIndicator()),
      // 에러 발생 시 표시할 위젯
      error: (error, stack) => Center(child: Text('오류가 발생했습니다.')),
    );
  }
}
// ------- 찜 목록 화면 내 파이어베이스의 찜 목록 상품 데이터를 불러와서 UI로 구현하는 클래스 내용 끝