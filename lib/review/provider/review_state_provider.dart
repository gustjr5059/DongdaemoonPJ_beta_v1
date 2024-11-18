
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

// ------  리뷰 발주 내역 관리 Notifier 클래스 시작 부분
// 리뷰 발주 내역 관리를 담당하는 StateNotifier 클래스임.
// 발주 데이터를 페이지 단위로 로드하고 상태를 관리함.
class ReviewOrdersNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  // 리뷰 데이터를 가져오는 리포지토리를 참조함.
  final ReviewRepository reviewRepository;
  // Riverpod의 Ref 객체를 참조함.
  final Ref ref;
  // Firestore의 마지막 문서를 저장하는 변수임.
  DocumentSnapshot? lastDocument;
  // 추가 데이터 로딩 상태를 나타내는 변수임.
  bool isLoadingMore = false;
  // 추가 데이터가 더 있는지 여부를 나타내는 변수임.
  bool hasMore = true;

  // 생성자에서 초기화 작업과 첫 데이터 로딩을 수행함.
  ReviewOrdersNotifier(this.reviewRepository, this.ref) : super([]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 앱의 프레임 렌더링 이후 첫 데이터 로딩을 시작함.
      loadMoreOrders();
    });
  }

  // ——— 발주 데이터를 페이지 단위로 로드하는 함수 시작 부분 ———
  // Firestore에서 사용자 이메일 기반으로 발주 데이터를 가져옴.
  Future<void> loadMoreOrders() async {
    // 추가 로딩 중이거나 더 이상 데이터가 없을 경우 함수를 종료함.
    if (isLoadingMore || !hasMore) return;

    // 추가 데이터 로딩 상태를 true로 설정함.
    isLoadingMore = true;

    // 현재 로그인한 사용자 정보를 가져옴.
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // 로그인하지 않은 상태이면 상태를 빈 리스트로 설정함.
      state = [];
      isLoadingMore = false;
      print('디버그: 사용자 인증 정보 없음. 빈 상태로 초기화함.');
      return;
    }

    print('디버그: ${user.email} 계정의 발주 데이터 로딩 시작함.');

    // Firestore에서 이메일 기반 발주 데이터를 페이지 단위로 가져옴.
    final newOrders = await reviewRepository.getPagedOrdersByEmail(
      user.email!, // 사용자 이메일
      lastDocument: lastDocument, // 이전의 마지막 문서
      limit: 2, // 페이지당 데이터 제한
    );

    if (newOrders.isNotEmpty) {
      // 새 데이터를 상태에 추가하고 마지막 문서를 갱신함.
      lastDocument = newOrders.last['snapshot'];
      state = [...state, ...newOrders];
      print('디버그: 새로운 발주 데이터 ${newOrders.length}개 로드 완료.');
    } else {
      // 추가 데이터가 없으면 hasMore 상태를 false로 설정함.
      hasMore = false;
      print('디버그: 더 이상 로드할 데이터 없음.');
    }

    // 추가 데이터 로딩 상태를 false로 설정함.
    isLoadingMore = false;
  }

  // ——— 발주 데이터 상태를 초기화하는 함수 시작 부분 ———
  // 현재 상태를 초기화하고 첫 페이지 데이터부터 다시 로드함.
  void resetOrders() {
    // 추가 로딩 상태와 데이터 상태를 초기화함.
    isLoadingMore = false;
    hasMore = true;
    state = [];
    lastDocument = null;
    print('디버그: 발주 데이터 상태 초기화 완료.');
    // 초기화 후 첫 페이지 데이터를 다시 로드함.
    loadMoreOrders();
  }
}
// ------  리뷰 발주 내역 관리 Notifier 클래스 끝 부분

// ------  리뷰 발주 내역 StateNotifierProvider 정의 시작 부분
// 리뷰 발주 내역 관리 StateNotifierProvider를 정의함.
// ReviewRepository와 ReviewOrdersNotifier를 연결함.
final reviewOrdersProvider =
StateNotifierProvider<ReviewOrdersNotifier, List<Map<String, dynamic>>>((ref) {
  // ReviewRepository를 Provider에서 읽어옴.
  final reviewRepository = ref.read(reviewRepositoryProvider);
  // ReviewOrdersNotifier 인스턴스를 생성하여 반환함.
  return ReviewOrdersNotifier(reviewRepository, ref);
});
// ------  리뷰 발주 내역 StateNotifierProvider 정의 끝 부분

