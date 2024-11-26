
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/message_repository.dart';
import 'message_all_provider.dart';


// 쪽지 관리 화면에서 화면 자체 스크롤로 이동한 위치를 저장하는 StateProvider
final privateMessageScrollPositionProvider = StateProvider<double>((ref) => 0);

// -------- message_screen.dart 관련 ScrollControllerProvider 시작
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 privateMessageScrollControllerProvider라는 이름의 Provider를 정의함.
final privateMessageScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 함.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});
// -------- message_screen.dart 관련 ScrollControllerProvider 끝

// ------ 사용자 쪽지 목록 데이터를 관리하는 StateNotifier인 PrivateMessageItemsListNotifier 시작 부분
class PrivateMessageItemsListNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final PrivateMessageRepository messageRepository; // 쪽지 데이터 처리 로직을 담당하는 리포지토리
  final Ref ref; // Riverpod Ref 객체
  DocumentSnapshot? lastDocument; // Firestore에서 가져온 마지막 문서
  bool isLoadingMore = false; // 데이터 로드 상태를 나타내는 플래그

  PrivateMessageItemsListNotifier(this.messageRepository, this.ref) : super([]);

  // ——— Firestore에서 추가 쪽지 데이터를 페이징 처리로 가져오는 함수
  Future<void> loadMoreMessages({required int timeFrame}) async {
    // 데이터 로드 중복 요청 방지
    if (isLoadingMore) {
      print("현재 데이터 로드 중이므로 중복 요청이 차단되었습니다."); // 중복 요청 방지 메시지
      return;
    }

    isLoadingMore = true; // 로드 상태를 true로 설정

    // 현재 로그인된 사용자 이메일 가져오기
    final user = FirebaseAuth.instance.currentUser; // FirebaseAuth에서 현재 사용자 정보 가져옴
    final userEmail = user?.email; // 사용자 이메일 추출
    if (userEmail == null) {
      print("사용자 인증에 실패했습니다. 로그인 후 다시 시도해주세요."); // 인증 실패 메시지
      state = []; // 상태 초기화
      isLoadingMore = false; // 로드 상태를 false로 설정
      return;
    }

    // Firestore에서 쪽지 데이터를 요청
    print("Firestore에서 새로운 쪽지 데이터 7개를 요청 중입니다."); // 데이터 요청 메시지
    final newMessages = await messageRepository.getPagedMessageItemsList(
      userEmail: userEmail, // 사용자 이메일
      lastDocument: lastDocument, // 이전 마지막 문서
      limit: 7, // 가져올 데이터 개수
      timeFrame: timeFrame, // 시간 프레임
    );

    // 가져온 데이터가 있는 경우 상태 업데이트
    if (newMessages.isNotEmpty) {
      lastDocument = newMessages.last['snapshot']; // 마지막 문서를 기록
      state = [...state, ...newMessages]; // 기존 데이터와 병합하여 상태를 갱신
      print("새로 가져온 쪽지 데이터: ${newMessages.length}개"); // 가져온 데이터 개수 출력
      print("현재 전체 쪽지 데이터: ${state.length}개"); // 전체 데이터 개수 출력
    } else {
      print("더 이상 가져올 데이터가 없습니다."); // 데이터 없음 메시지
    }

    isLoadingMore = false; // 로드 상태를 false로 설정
    print("Firestore에서 데이터 로드가 완료되었습니다."); // 로드 완료 메시지
  }

  // ——— 데이터 상태 초기화 및 다시 로드하는 함수
  void resetAndReloadMessages({required int timeFrame}) async {
    isLoadingMore = false; // 로드 상태 초기화
    state = []; // 상태 초기화
    lastDocument = null; // 마지막 문서 초기화
    print("쪽지 목록을 초기화하고 다시 로드합니다."); // 초기화 및 로드 메시지
    await loadMoreMessages(timeFrame: timeFrame); // 데이터 로드
  }

  // ——— 특정 쪽지 데이터를 삭제 처리하는 함수
  Future<void> deleteMessage(String messageId, int timeFrame) async {
    // 현재 로그인된 사용자 이메일 가져오기
    final user = FirebaseAuth.instance.currentUser; // FirebaseAuth에서 현재 사용자 정보 가져옴
    final userEmail = user?.email; // 사용자 이메일 추출
    if (userEmail == null) {
      print("사용자 인증에 실패했습니다. 로그인 후 다시 시도해주세요."); // 인증 실패 메시지
      throw Exception('사용자가 로그인되어 있지 않습니다.'); // 인증 실패 예외 발생
    }

    // Firestore에서 해당 메시지 삭제 처리
    await messageRepository.deleteMessage(
      userEmail: userEmail, // 사용자 이메일
      messageId: messageId, // 삭제할 쪽지 ID
    );

    print("쪽지 ID: $messageId가 정상적으로 삭제 처리되었습니다."); // 삭제 완료 메시지
    // 상태를 초기화하고 데이터를 다시 로드
    resetAndReloadMessages(timeFrame: timeFrame);
  }
}
// ------ 사용자 쪽지 목록 데이터를 관리하는 StateNotifier인 PrivateMessageItemsListNotifier 끝 부분

// ——— PrivateMessageItemsListNotifier를 제공하는 Riverpod Provider
final privateMessageItemsListNotifierProvider =
StateNotifierProvider<PrivateMessageItemsListNotifier, List<Map<String, dynamic>>>((ref) {
  final messageRepository = ref.read(privateMessageRepositoryProvider); // 리포지토리 객체 읽기
  return PrivateMessageItemsListNotifier(messageRepository, ref); // StateNotifier 생성 및 반환
});
