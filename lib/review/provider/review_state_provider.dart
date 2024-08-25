
import 'package:dongdaemoon_beta_v1/review/provider/review_all_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// 리뷰 관리 화면에서 화면 자체 스크롤로 이동한 위치를 저장하는 StateProvider
final privateReviewScrollPositionProvider = StateProvider<double>((ref) => 0);

// -------- review_screen.dart 관련 ScrollControllerProvider 시작
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 privateReviewScrollControllerProvider라는 이름의 Provider를 정의함.
final privateReviewScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 함.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});
// -------- review_screen.dart 관련 ScrollControllerProvider 끝

// 마이페이지용 리뷰 관리 화면에서 '리뷰 작성', '리뷰 목록' 탭의 선택 상태를 관리하는 privateReviewScreenTabProvider 정의
final privateReviewScreenTabProvider = StateProvider<ReviewScreenTab>((ref) {
  return ReviewScreenTab.create;
});

// 리뷰 작성 상세 화면에서 화면 자체 스크롤로 이동한 위치를 저장하는 StateProvider
final reviewCreateDetailScrollPositionProvider = StateProvider<double>((ref) => 0);