import 'package:dongdaemoon_beta_v1/product/model/product_model.dart'; // Product 모델 클래스 임포트
import 'package:flutter/cupertino.dart'; // Cupertino 디자인을 사용하기 위한 패키지 임포트
import 'package:flutter/material.dart'; // Material 디자인을 사용하기 위한 패키지 임포트
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위한 Riverpod 패키지 임포트
import '../provider/wishlist_future_provider.dart'; // 찜 목록의 비동기 동작을 위한 Provider 임포트
import '../provider/wishlist_state_provider.dart'; // 찜 목록의 상태 관리를 위한 Provider 임포트

// ------- 찜 목록 아이콘 동작 로직 관련 클래스인 WishlistIconButton 내용 구현 시작
// 찜 목록 아이콘 버튼 위젯을 구현하는 클래스
class WishlistIconButton extends ConsumerWidget {
  final ProductContent product; // 현재 상품 정보를 담고 있는 필드

  WishlistIconButton({required this.product}); // 생성자에서 상품 정보를 받아 필드에 저장

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 찜 목록에 현재 상품이 포함되어 있는지 여부를 확인
    final isWished = ref.watch(wishlistItemProvider).contains(product.docId);

    return IconButton(
      icon: Icon(
        // 찜 목록에 포함된 경우와 아닌 경우에 따라 아이콘 모양 및 색상 설정
        isWished ? Icons.favorite : Icons.favorite_border,
        color: isWished ? Colors.red : Colors.grey,
      ),
      // 아이콘 버튼이 눌렸을 때의 동작을 정의
      onPressed: () async {
        final wishlistNotifier = ref.read(wishlistItemProvider.notifier); // 찜 목록 상태를 업데이트할 Notifier
        final wishlistRepository = ref.read(wishlistItemRepositoryProvider); // 찜 목록 비동기 작업을 위한 Repository

        if (isWished) { // 이미 찜 목록에 있는 경우
          wishlistNotifier.toggleItem(product.docId);  // 상태를 업데이트하여 찜 목록에서 제거
          try {
            await wishlistRepository.removeFromWishlistItem(product.docId); // 서버에서 찜 목록에서 제거
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('상품이 찜 목록에서 비워졌습니다.')), // 성공 메시지 표시
            );
          } catch (e) {
            wishlistNotifier.toggleItem(product.docId);  // 실패하면 상태를 롤백
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('찜 목록에서 비우는 중 오류가 발생했습니다.')), // 오류 메시지 표시
            );
          }
        } else { // 찜 목록에 없는 경우
          wishlistNotifier.toggleItem(product.docId);  // 상태를 업데이트하여 찜 목록에 추가
          try {
            await wishlistRepository.addToWishlistItem(product); // 서버에서 찜 목록에 추가
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('상품이 찜 목록에 담겼습니다.')), // 성공 메시지 표시
            );
          } catch (e) {
            wishlistNotifier.toggleItem(product.docId);  // 실패하면 상태를 롤백
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('찜 목록에 담는 중 오류가 발생했습니다.')), // 오류 메시지 표시
            );
          }
        }
      },
    );
  }
}
// ------- 찜 목록 아이콘 동작 로직 관련 클래스인 WishlistIconButton 내용 구현 끝
