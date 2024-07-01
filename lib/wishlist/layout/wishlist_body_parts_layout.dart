import 'package:flutter/cupertino.dart'; // Cupertino 디자인을 사용하기 위한 패키지
import 'package:flutter/material.dart'; // Material 디자인을 사용하기 위한 패키지
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위한 Riverpod 패키지

import '../provider/wishlist_state_provider.dart'; // wishlist 상태 관리를 위한 provider 파일을 임포트

// ------- 찜 목록 아이콘 동작 로직 관련 클래스인 WishlistIconButton 내용 구현 시작
class WishlistIconButton extends StatelessWidget {
  final String docId; // 상품의 고유 ID를 저장할 변수
  final WidgetRef ref; // Riverpod 상태 관리를 위한 참조 변수

  WishlistIconButton(
      {required this.docId, required this.ref}); // 생성자, docId와 ref를 받아옴

  @override
  Widget build(BuildContext context) {
    return IconButton(
      // 아이콘 버튼을 생성
      icon: Icon(
        // 아이콘 위젯을 생성
        ref.watch(wishlistProvider).contains(docId)
            ? Icons.favorite // docId가 wishlist에 포함되어 있으면 꽉 찬 하트 아이콘을 사용
            : Icons.favorite_border, // 포함되어 있지 않으면 빈 하트 아이콘을 사용
        color: ref.watch(wishlistProvider).contains(docId)
            ? Colors.red // docId가 wishlist에 포함되어 있으면 빨간색으로 아이콘 색상 지정
            : Colors.grey, // 포함되어 있지 않으면 회색으로 아이콘 색상 지정
      ),
      onPressed: () {
        // 아이콘 버튼이 눌렸을 때 실행되는 함수
        ref
            .read(wishlistProvider.notifier)
            .toggleItem(docId); // wishlist에 docId 추가/삭제 토글

        if (ref.read(wishlistProvider).contains(docId)) {
          // docId가 wishlist에 포함되었는지 확인
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('상품이 찜 목록에 담겼습니다.')), // 포함되었으면 스낵바로 알림
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('상품이 찜 목록에서 비워졌습니다.')), // 포함되지 않았으면 스낵바로 알림
          );
        }
      },
    );
  }
}
// ------- 찜 목록 아이콘 동작 로직 관련 클래스인 WishlistIconButton 내용 구현 끝
