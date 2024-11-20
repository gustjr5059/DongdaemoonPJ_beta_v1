
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongdaemoon_beta_v1/review/provider/review_all_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/review_repository.dart';


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

// 리뷰 작성 상세 화면에서 화면 자체 스크롤로 이동한 위치를 저장하는 StateProvider
final reviewCreateDetailScrollPositionProvider = StateProvider<double>((ref) => 0);


// ------ 사용자 리뷰 목록 데이터를 관리하는 StateNotifier인 PrivateReviewItemsListNotifier 시작 부분
class PrivateReviewItemsListNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final PrivateReviewRepository reviewRepository; // 리뷰 데이터 처리 로직을 담당하는 리포지토리
  final Ref ref; // Riverpod Ref 객체
  DocumentSnapshot? lastDocument; // Firestore에서 가져온 마지막 문서
  bool isLoadingMore = false; // 데이터 로드 상태를 나타내는 플래그

  PrivateReviewItemsListNotifier(this.reviewRepository, this.ref) : super([]);

  // ——— Firestore에서 추가 리뷰 데이터를 페이징 처리로 가져오는 함수
  Future<void> loadMoreReviews() async {
    if (isLoadingMore) {
      print("데이터 로드 중 중복 요청 방지됨."); // 데이터 로드 중 중복 요청 방지 메시지
      return;
    }

    isLoadingMore = true; // 로드 상태를 true로 설정

    // 현재 로그인된 사용자 이메일 가져오기
    final user = FirebaseAuth.instance.currentUser; // FirebaseAuth에서 현재 사용자 정보 가져옴
    final userEmail = user?.email; // 사용자 이메일 추출
    if (userEmail == null) {
      print("사용자 인증 실패: 로그인 필요."); // 사용자 인증 실패 메시지
      state = []; // 상태 초기화
      isLoadingMore = false; // 로드 상태를 false로 설정
      return;
    }

    print("Firestore에서 새로운 리뷰 아이템 3개를 요청합니다."); // 리뷰 데이터 요청 메시지
    // Firestore에서 데이터를 3개씩 페이징 처리로 가져옴
    final newReviews = await reviewRepository.getPagedReviewItemsList(
      userEmail: userEmail,
      lastDocument: lastDocument,
      limit: 3,
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

  // ——— 특정 리뷰 데이터를 삭제 처리하는 함수
  Future<void> deleteReview(String separatorKey) async {
    final user = FirebaseAuth.instance.currentUser; // FirebaseAuth에서 현재 사용자 정보 가져옴
    final userEmail = user?.email; // 사용자 이메일 추출
    if (userEmail == null) {
      print("사용자 인증 실패: 로그인 필요."); // 사용자 인증 실패 메시지
      throw Exception('사용자가 로그인되어 있지 않습니다.'); // 인증 실패 예외 발생
    }

    // 리뷰 데이터 삭제 처리 요청
    await reviewRepository.deleteReview(
      userEmail: userEmail,
      separatorKey: separatorKey,
    );

    // 삭제한 리뷰를 상태에서 제거
    state = state.where((review) => review['separator_key'] != separatorKey).toList();
    print("separatorKey: $separatorKey 상태에서 제거됨."); // 삭제된 데이터 메시지
  }

  // ——— 리뷰 데이터 상태를 초기화하는 함수
  void resetReviews() {
    isLoadingMore = false; // 로드 상태 초기화
    state = []; // 상태 초기화
    lastDocument = null; // 마지막 문서 초기화
    print("리뷰 목록 초기화."); // 상태 초기화 메시지
  }
}
// ------ 사용자 리뷰 목록 데이터를 관리하는 StateNotifier인 PrivateReviewItemsListNotifier 끝 부분

// ——— PrivateReviewItemsListNotifier를 제공하는 Riverpod Provider
final privateReviewItmesListNotifierProvider =
StateNotifierProvider<PrivateReviewItemsListNotifier, List<Map<String, dynamic>>>((ref) {
  final reviewRepository = ref.read(privateReviewRepositoryProvider); // 리뷰 리포지토리 읽기
  return PrivateReviewItemsListNotifier(reviewRepository, ref); // Notifier 생성 및 반환
});

