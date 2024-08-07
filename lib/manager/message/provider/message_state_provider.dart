
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'message_all_provider.dart';


// 관리자용 쪽지 관리 화면에서 화면 자체 스크롤로 이동한 위치를 저장하는 StateProvider
final adminMessageScrollPositionProvider = StateProvider<double>((ref) => 0);

// -------- managerMessage_screen.dart 관련 ScrollControllerProvider 시작
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 adminManagerMessageScrollControllerProvider라는 이름의 Provider를 정의함.
final adminManagerMessageScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 함.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});
// -------- managerMessage_screen.dart 관련 ScrollControllerProvider 끝


// 관리자용 쪽지 관리 화면에서 '쪽지 작성', '쪽지 목록' 탭의 선택 상태를 관리하는 adminMessageScreenTabProvider 정의
final adminMessageScreenTabProvider = StateProvider<MessageScreenTab>((ref) {
  return MessageScreenTab.create;
});
// 관리자용 쪽지 관리 화면에서 내용 선택 관련 드롭다운 메뉴 선택 상태를 관리하는 adminMessageContentProvider 정의
final adminMessageContentProvider = StateProvider<String?>((ref) {
  return null;
});
// 관리자용 쪽지 관리 화면에서 선택한 메뉴 관련 텍스트 노출 입력칸 노출 상태를 관리하는 adminCustomMessageProvider 정의
final adminCustomMessageProvider = StateProvider<String?>((ref) {
  return null;
});