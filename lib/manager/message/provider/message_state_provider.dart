
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/message_repository.dart';
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

// 관리자용 쪽지 관리 화면 내 '쪽지 목록'탭 화면에서 선택된 수신자 이메일을 관리하는 상태 프로바이더
final selectedReceiverProvider = StateProvider<String?>((ref) => null);

// ------ 수신자 쪽지 목록 데이터를 관리하는 StateNotifier인 AdminMessageItemsListNotifier 시작 부분
class AdminMessageItemsListNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final AdminMessageRepository messageRepository; // 쪽지 데이터 처리 로직을 담당하는 리포지토리
  final Ref ref; // Riverpod Ref 객체
  final String userEmail; // 선택된 사용자 이메일
  DocumentSnapshot? lastDocument; // Firestore에서 가져온 마지막 문서
  bool isLoadingMore = false; // 데이터 로드 상태를 나타내는 플래그

  AdminMessageItemsListNotifier(this.messageRepository, this.ref, this.userEmail) : super([]) {
    if (userEmail.isNotEmpty) {
      loadMoreMessages(timeFrame: 30); // Notifier 생성 시 데이터 로드 (30일 시간 프레임으로 호출)
    }
  }

  // ——— Firestore에서 추가 쪽지 데이터를 페이징 처리로 가져오는 함수
  Future<void> loadMoreMessages({required int timeFrame}) async {
    if (isLoadingMore) {
      print("데이터 로드 중 중복 요청 방지됨."); // 데이터 로드 중 중복 요청 방지 메시지
      return;
    }

    isLoadingMore = true; // 로드 상태를 true로 설정

    // 현재 로그인된 사용자 이메일 가져오기
    if (userEmail.isEmpty) {
      print("선택한 수신자 이메일이 없습니다."); // 수신자 이메일 없음 메시지
      state = []; // 상태 초기화
      isLoadingMore = false; // 로드 상태를 false로 설정
      return;
    }

    print("Firestore에서 새로운 쪽지 아이템 6개를 요청합니다."); // 쪽지 데이터 요청 메시지
    // Firestore에서 데이터를 6개씩 페이징 처리로 가져옴
    final newMessages = await messageRepository.getPagedMessageItemsList(
      userEmail: userEmail,
      lastDocument: lastDocument,
      limit: 6,
      timeFrame: timeFrame, // 시간 프레임
    );

    // 가져온 데이터가 있는 경우 상태 업데이트
    if (newMessages.isNotEmpty) {
      lastDocument = newMessages.last['snapshot']; // 마지막 문서를 기록함
      state = [...state, ...newMessages]; // 기존 데이터에 추가된 데이터를 병합함
      print("새로 불러온 데이터: ${newMessages.length}개"); // 불러온 데이터 개수 출력
      print("현재 전체 데이터: ${state.length}개"); // 전체 데이터 개수 출력
    } else {
      print("더 이상 불러올 데이터가 없습니다."); // 더 이상 불러올 데이터 없음 메시지
    }

    isLoadingMore = false; // 로드 상태를 false로 설정
    print("데이터 로드 완료."); // 데이터 로드 완료 메시지
  }

  // 데이터 상태 초기화 및 리셋 함수
  // ('삭제' 버튼 로직에서 해당 함수를 불러와서 삭제하면 화면에 있는 상태에서도 데이터를 다시 로드해서 기존의 불러온 페이징 데이터 안에서만 삭제되서 칸이 비어지는 이슈 해결 방법)
  void resetAndReloadMessages({required int timeFrame}) async {
    isLoadingMore = false; // 로드 상태 초기화
    state = []; // 상태 초기화
    lastDocument = null; // 마지막 문서 초기화
    print("쪽지 목록 초기화."); // 상태 초기화 메시지
    await loadMoreMessages(timeFrame: timeFrame); // 데이터 로드
  }

  // ——— 특정 쪽지 데이터를 삭제 처리하는 함수
  Future<void> deleteMessage(String messageId, int timeFrame) async {
    if (userEmail.isEmpty) {
      print("수신자 이메일이 없습니다."); // 사용자 이메일 없음 메시지
      throw Exception('수신자 이메일이 없습니다.'); // 예외 발생
    }

    // Firestore에서 해당 메시지 삭제 처리
    await messageRepository.deleteMessage(
      userEmail: userEmail, // 사용자 이메일
      messageId: messageId, // 삭제할 쪽지 ID
    );

    // 삭제한 쪽지를 상태에서 제거
    state = state.where((message) => message['id'] != messageId).toList();
    print("messageId: $messageId 상태에서 제거됨."); // 삭제된 데이터 메시지
    // 상태를 초기화하고 데이터를 다시 로드
    resetAndReloadMessages(timeFrame: timeFrame);
  }
}
// ------ 수신자 쪽지 목록 데이터를 관리하는 StateNotifier인 AdminMessageItemsListNotifier 끝 부분

// ——— AdminMessageItemsListNotifier를 제공하는 Riverpod Provider
// 기존의 StateNotifierProvider.family를 StateNotifierProvider로 변경함.
// (이메일을 선택할 때마다 선택된 이메일 관련 데이터를 새롭게 불러오기 위해 이렇게 변경)
final adminMessageItemsListNotifierProvider =
StateNotifierProvider<AdminMessageItemsListNotifier, List<Map<String, dynamic>>>(
      (ref) {
    final messageRepository = ref.read(adminMessageRepositoryProvider); // 쪽지 리포지토리 읽기
    final userEmail = ref.watch(selectedReceiverProvider) ?? ''; // 선택된 이메일을 가져옴.
    return AdminMessageItemsListNotifier(messageRepository, ref, userEmail); // Notifier 생성 및 반환
  },
);