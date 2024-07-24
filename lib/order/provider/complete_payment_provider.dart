
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// ------- complete_payment_screen.dart - 결제 완료 관련 내용 시작 부분
// 결제 완료 화면에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final completePaymentScrollPositionProvider = StateProvider<double>((ref) => 0);

// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 completePaymentScrollControllerProvider라는 이름의 Provider를 정의함.
final completePaymentScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});
// ------- complete_payment_screen.dart - 결제 완료 관련 내용 끝 부분