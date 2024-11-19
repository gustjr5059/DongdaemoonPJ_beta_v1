
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

// 마이페이지용 리뷰 관리 화면에서 '리뷰 작성', '리뷰 목록' 탭의 선택 상태를 관리하는 privateReviewScreenTabProvider 정의
final privateReviewScreenTabProvider = StateProvider<ReviewScreenTab>((ref) {
  return ReviewScreenTab.create;
});

// 리뷰 작성 상세 화면에서 화면 자체 스크롤로 이동한 위치를 저장하는 StateProvider
final reviewCreateDetailScrollPositionProvider = StateProvider<double>((ref) => 0);


class PrivateReviewItemsListNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final PrivateReviewRepository reviewRepository;
  final Ref ref;
  DocumentSnapshot? lastDocument;
  bool isLoadingMore = false;

  PrivateReviewItemsListNotifier(this.reviewRepository, this.ref) : super([]);

  Future<void> loadMoreReviews() async {
    if (isLoadingMore) {
      print("데이터 로드 중 중복 요청 방지됨.");
      return;
    }

    isLoadingMore = true;

    // 현재 로그인된 사용자 이메일 가져오기
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email;
    if (userEmail == null) {
      print("사용자 인증 실패: 로그인 필요.");
      state = [];
      isLoadingMore = false;
      return;
    }

    print("Firestore에서 새로운 리뷰 아이템 3개를 요청합니다.");
    // Firestore에서 데이터를 3개씩 페이징 처리로 가져옴
    final newReviews = await reviewRepository.getPagedReviewItemsList(
      userEmail: userEmail,
      lastDocument: lastDocument,
      limit: 3,
    );

    if (newReviews.isNotEmpty) {
      lastDocument = newReviews.last['snapshot']; // 마지막 문서를 기록함
      state = [...state, ...newReviews]; // 기존 데이터에 추가된 데이터를 병합함
      print("새로 불러온 데이터: ${newReviews.length}개");
      print("현재 전체 데이터: ${state.length}개");
    } else {
      print("더 이상 불러올 데이터가 없습니다.");
    }

    isLoadingMore = false;
    print("데이터 로드 완료.");
  }

  Future<void> deleteReview(String separatorKey) async {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email;
    if (userEmail == null) {
      print("사용자 인증 실패: 로그인 필요.");
      throw Exception('사용자가 로그인되어 있지 않습니다.');
    }

    await reviewRepository.deleteReview(
      userEmail: userEmail,
      separatorKey: separatorKey,
    );

    // 삭제한 리뷰를 상태에서 제거
    state = state.where((review) => review['separator_key'] != separatorKey).toList();
    print("separatorKey: $separatorKey 상태에서 제거됨.");
  }

  void resetReviews() {
    isLoadingMore = false;
    state = [];
    lastDocument = null;
    print("리뷰 목록 초기화.");
  }
}

final privateReviewItmesListNotifierProvider = StateNotifierProvider<PrivateReviewItemsListNotifier, List<Map<String, dynamic>>>((ref) {
  final reviewRepository = ref.read(privateReviewRepositoryProvider);
  return PrivateReviewItemsListNotifier(reviewRepository, ref);
});
