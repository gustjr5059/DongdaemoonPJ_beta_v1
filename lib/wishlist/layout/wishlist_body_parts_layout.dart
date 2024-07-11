import 'package:dongdaemoon_beta_v1/product/model/product_model.dart'; // Product 모델 클래스 임포트
import 'package:flutter/cupertino.dart'; // Cupertino 디자인을 사용하기 위한 패키지 임포트
import 'package:flutter/material.dart'; // Material 디자인을 사용하기 위한 패키지 임포트
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위한 Riverpod 패키지 임포트
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
