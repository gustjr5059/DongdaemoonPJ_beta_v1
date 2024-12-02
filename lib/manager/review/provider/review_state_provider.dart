
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongdaemoon_beta_v1/manager/review/provider/review_all_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/review_repository.dart';


// 리뷰 관리 화면에서 화면 자체 스크롤로 이동한 위치를 저장하는 StateProvider
final adminReviewScrollPositionProvider = StateProvider<double>((ref) => 0);

// -------- review_screen.dart 관련 ScrollControllerProvider 시작
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 adminReviewScrollControllerProvider라는 이름의 Provider를 정의함.
final adminReviewScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 함.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});
// -------- review_screen.dart 관련 ScrollControllerProvider 끝

// 특정 사용자의 이메일을 선택하는 상태 프로바이더
final adminSelectedUserEmailProvider = StateProvider<String?>((ref) => null);

// ------ 사용자 리뷰 목록 데이터를 관리하는 StateNotifier인 AdminReviewItemsListNotifier 시작 부분
class AdminReviewItemsListNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final AdminReviewRepository reviewRepository; // 리뷰 데이터 처리 로직을 담당하는 리포지토리
  final Ref ref; // Riverpod Ref 객체
  final String userEmail; // 선택된 사용자 이메일
  DocumentSnapshot? lastDocument; // Firestore에서 가져온 마지막 문서
  bool isLoadingMore = false; // 데이터 로드 상태를 나타내는 플래그

  AdminReviewItemsListNotifier(this.reviewRepository, this.ref, this.userEmail) : super([]) {
    if (userEmail.isNotEmpty) {
      loadMoreReviews(); // Notifier 생성 시 데이터 로드
    }
  }

  // ——— Firestore에서 추가 리뷰 데이터를 페이징 처리로 가져오는 함수
  Future<void> loadMoreReviews() async {
    if (isLoadingMore) {
      print("데이터 로드 중 중복 요청 방지됨."); // 데이터 로드 중 중복 요청 방지 메시지
      return;
    }

    isLoadingMore = true; // 로드 상태를 true로 설정

    // // 현재 로그인된 사용자 이메일 가져오기
    // final user = FirebaseAuth.instance.currentUser; // FirebaseAuth에서 현재 사용자 정보 가져옴
    // final userEmail = user?.email; // 사용자 이메일 추출
    if (userEmail.isEmpty) {
      print("사용자 이메일이 없습니다."); // 사용자 이메일 없음 메시지
      state = []; // 상태 초기화
      isLoadingMore = false; // 로드 상태를 false로 설정
      return;
    }

    print("Firestore에서 새로운 리뷰 아이템 4개를 요청합니다."); // 리뷰 데이터 요청 메시지
    // Firestore에서 데이터를 4개씩 페이징 처리로 가져옴
    final newReviews = await reviewRepository.getPagedReviewItemsList(
      userEmail: userEmail,
      lastDocument: lastDocument,
      limit: 4,
    );

    if (newReviews.isNotEmpty) {
      lastDocument = newReviews.last['snapshot']; // 마지막 문서를 기록함
      state = [...state, ...newReviews]; // 기존 데이터에 추가된 데이터를 병합함
      print("새로 불러온 데이터: ${newReviews.length}개"); // 불러온 데이터 개수 출력
      print("현재 전체 데이터: ${state.length}개"); // 전체 데이터 개수 출력
    } else {
      print("더 이상 불러올 데이터가 없습니다."); // 더 이상 불러올 데이터 없음 메시지
    }

    isLoadingMore = false; // 로드 상태를 false로 설정
    print("데이터 로드 완료."); // 데이터 로드 완료 메시지
  }

  // 데이터 상태 초기화 및 리셋 함수
  // ('삭제' 버튼 로직에서 해당 함수를 불러와서 삭제하면 화면에 있는 상태에서도 데이터를 다시 로드해서 기존의 불러온 페이징 데이터 안에서만 삭제되서 칸이 비어지는 이슈 해결 방법)
  void resetAndReloadReviews() async {
    isLoadingMore = false; // 로드 상태 초기화
    state = []; // 상태 초기화
    lastDocument = null; // 마지막 문서 초기화
    print("리뷰 목록 초기화."); // 상태 초기화 메시지
    await loadMoreReviews(); // 데이터 로드
  }

  // ——— 특정 리뷰 데이터를 삭제 처리하는 함수
  Future<void> deleteReview(String separatorKey) async {
    // final user = FirebaseAuth.instance.currentUser; // FirebaseAuth에서 현재 사용자 정보 가져옴
    // final userEmail = user?.email; // 사용자 이메일 추출
    if (userEmail.isEmpty) {
      print("사용자 이메일이 없습니다."); // 사용자 이메일 없음 메시지
      throw Exception('사용자 이메일이 없습니다.'); // 예외 발생
    }

    // 리뷰 데이터 삭제 처리 요청
    await reviewRepository.deleteReview(
      userEmail: userEmail,
      separatorKey: separatorKey,
    );

    // 삭제한 리뷰를 상태에서 제거
    state = state.where((review) => review['separator_key'] != separatorKey).toList();
    print("separatorKey: $separatorKey 상태에서 제거됨."); // 삭제된 데이터 메시지
    resetAndReloadReviews(); // 상태를 초기화하고 데이터를 다시 로드
  }
}
// ------ 사용자 리뷰 목록 데이터를 관리하는 StateNotifier인 PrivateReviewItemsListNotifier 끝 부분

// ——— AdminReviewItemsListNotifier를 제공하는 Riverpod Provider
// 기존의 StateNotifierProvider.family를 StateNotifierProvider로 변경함.
// (이메일을 선택할 때마다 선택된 이메일 관련 데이터를 새롭게 불러오기 위해 이렇게 변경)
final adminReviewItemsListNotifierProvider =
StateNotifierProvider<AdminReviewItemsListNotifier, List<Map<String, dynamic>>>(
      (ref) {
    final reviewRepository = ref.read(adminReviewRepositoryProvider); // 리뷰 리포지토리 읽기
    final userEmail = ref.watch(adminSelectedUserEmailProvider) ?? ''; // 선택된 이메일을 가져옴.
    return AdminReviewItemsListNotifier(reviewRepository, ref, userEmail); // Notifier 생성 및 반환
  },
);
