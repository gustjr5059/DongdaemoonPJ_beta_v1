
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cart/provider/cart_state_provider.dart';
import '../../common/provider/common_state_provider.dart';
import '../repository/announce_repository.dart';
import 'announce_all_provider.dart';

// -------- announce_screen.dart 관련 ScrollControllerProvider 시작
// 공지사항 화면에서 화면 자체 스크롤로 이동한 위치를 저장하는 StateProvider
final announceScrollPositionProvider = StateProvider<double>((ref) => 0);

// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 announceScrollControllerProvider라는 이름의 Provider를 정의함.
final announceScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 함.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});
// -------- announce_screen.dart 관련 ScrollControllerProvider 끝

// -------- announce_detail_screen.dart 관련 ScrollControllerProvider 시작
// 공지사항 화면에서 화면 자체 스크롤로 이동한 위치를 저장하는 StateProvider
final announceDetailScrollPositionProvider = StateProvider<double>((ref) => 0);

// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 announceDetailScrollControllerProvider라는 이름의 Provider를 정의함.
final announceDetailScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 함.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});
// -------- announce_detail_screen.dart 관련 ScrollControllerProvider 끝


// ------ AnnounceItemsNotifier 클래스: Firestore와의 상호작용을 통해 공지사항 상태를 관리하는 StateNotifier 클래스 내용 시작
class AnnounceItemsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  // AnnouncementRepository 인스턴스를 저장하는 변수임
  final AnnouncementRepository announceItemRepository;

  // Riverpod의 Ref 객체를 저장하는 변수임
  final Ref ref;

  // 마지막으로 불러온 데이터의 스냅샷을 저장하는 변수임
  DocumentSnapshot? lastDocument;

  // 페이징 처리 중인지 여부를 나타내는 플래그임
  bool isLoadingMore = false;

  // 생성자에서 AnnouncementRepository와 Ref를 받아 초기 상태를 빈 리스트로 설정함
  // 초기 데이터 로딩을 위해 loadMoreAnnounceItems 메서드를 호출함
  AnnounceItemsNotifier(this.announceItemRepository, this.ref) : super([]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMoreAnnounceItems();
    });
  }

  // Firestore에서 공지사항 아이템을 페이징 처리하여 불러오는 함수임
  Future<void> loadMoreAnnounceItems() async {
    if (isLoadingMore) {
      print("이미 로딩 중입니다.");
      return; // 중복 로딩을 방지함
    }

    print("데이터 로드를 시작합니다.");
    isLoadingMore = true; // 로딩 상태를 true로 설정함
    ref.read(isLoadingProvider.notifier).state = true; // 로딩 상태를 관리하는 프로바이더의 상태를 true로 설정함

    // 사용자 인증 상태를 확인함
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("사용자가 로그인되어 있지 않습니다.");
      state = []; // 로그인하지 않은 경우 상태를 빈 리스트로 설정함
      isLoadingMore = false; // 로딩 상태를 해제함
      return;
    }

    // Firestore에서 데이터를 9개씩 페이징 처리로 불러옴
    final newItems = await announceItemRepository.getPagedAnnounceItems(
      lastDocument: lastDocument,
      limit: 9,
    );

    if (newItems.isNotEmpty) {
      lastDocument = newItems.last['snapshot']; // 마지막 문서를 저장함
      state = [...state, ...newItems]; // 기존 데이터에 새로 불러온 데이터를 추가함
      print("새로 불러온 데이터: ${newItems.length}개");
      print("현재 전체 데이터: ${state.length}개");
    } else {
      print("더 이상 불러올 데이터가 없습니다.");
    }

    ref.read(isLoadingProvider.notifier).state = false; // 로딩 상태를 false로 설정함
    isLoadingMore = false; // 로딩 플래그를 해제함
    print("데이터 로드를 완료했습니다.");
  }

  // 공지사항 데이터를 초기화하고 상태를 재설정하는 함수임
  void resetAnnounceItems() {
    isLoadingMore = false; // 로딩 플래그를 초기화함
    state = []; // 상태를 빈 리스트로 초기화함
    lastDocument = null; // 마지막 문서 스냅샷을 초기화함
  }

  // 구독을 취소하고 리소스를 해제하는 함수임
  @override
  void dispose() {
    super.dispose(); // 상위 클래스의 dispose 메서드를 호출함
  }
}
// ------ AnnounceItemsNotifier 클래스: Firestore와의 상호작용을 통해 공지사항 상태를 관리하는 StateNotifier 클래스 내용 끝

// AnnounceItemsNotifier를 사용하는 StateNotifierProvider임
final announceItemsProvider =
StateNotifierProvider<AnnounceItemsNotifier, List<Map<String, dynamic>>>((ref) {
  final announceItemRepository = ref.read(announceItemRepositoryProvider); // announceItemRepository 인스턴스를 가져옴
  return AnnounceItemsNotifier(announceItemRepository, ref); // AnnounceItemsNotifier 인스턴스를 반환함
});

// ------ AnnounceDetailItemNotifier 클래스: Firestore와의 상호작용을 통해 공지사항 상세 내용 상태를 관리하는 StateNotifier 클래스 내용 시작
class AnnounceDetailItemNotifier extends StateNotifier<Map<String, dynamic>> {
  // AnnouncementRepository 인스턴스를 저장하는 변수임
  final AnnouncementRepository announceItemRepository;

  // Riverpod의 Ref 객체를 저장하는 변수임
  final Ref ref;

  // 데이터 처리 중 로딩 여부를 나타내는 플래그임
  bool isLoadingMore = false;

  // 생성자에서 AnnouncementRepository와 Ref를 받아 초기 상태를 빈 Map으로 설정함
  // 초기 데이터 로딩을 위해 loadMoreAnnounceDetailItem 메서드를 호출함
  AnnounceDetailItemNotifier(this.announceItemRepository, this.ref, String documentId) : super({}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMoreAnnounceDetailItem(documentId);
    });
  }

  // Firestore에서 공지사항 아이템을 불러오는 함수임
  Future<void> loadMoreAnnounceDetailItem(String documentId) async {
    if (isLoadingMore) {
      print("이미 로딩 중입니다.");
      return; // 중복 로딩 방지함
    }

    print("데이터 로드를 시작합니다.");
    isLoadingMore = true; // 로딩 상태를 true로 설정함
    ref.read(isLoadingProvider.notifier).state = true; // 로딩 상태를 관리하는 프로바이더의 상태를 true로 설정함

    // 사용자 인증 상태 확인함
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("사용자가 로그인되어 있지 않습니다.");
      state = {}; // 로그인하지 않은 경우 상태를 빈 Map으로 설정함
      isLoadingMore = false; // 로딩 상태를 해제함
      return;
    }

    // Firestore에서 공지사항 문서 데이터를 가져옴
    final announceDetailItem = await announceItemRepository.getAnnounceDetailItem(documentId);

    state = announceDetailItem.isNotEmpty ? announceDetailItem : {}; // 가져온 데이터를 상태로 설정함
    print("공지사항 데이터 로드 완료: ${announceDetailItem['title']}");

    ref.read(isLoadingProvider.notifier).state = false; // 로딩 상태를 false로 설정함
    isLoadingMore = false; // 로딩 플래그를 해제함
    print("데이터 로드를 완료했습니다.");
  }

  // 공지사항 데이터를 초기화하고 상태를 재설정하는 함수임
  void resetAnnounceDetailItem() {
    isLoadingMore = false; // 로딩 플래그를 초기화함
    state = {}; // 상태를 빈 Map으로 초기화함
  }

  // 구독을 취소하고 리소스를 해제하는 함수임
  @override
  void dispose() {
    super.dispose(); // 상위 클래스의 dispose 메서드를 호출함
  }
}
// ------ AnnounceDetailItemNotifier 클래스: Firestore와의 상호작용을 통해 공지사항 상세 내용 상태를 관리하는 StateNotifier 클래스 내용 끝

// 공지사항 상세 데이터를 제공하는 StateNotifierProvider 설정임
final announceDetailItemProvider = StateNotifierProvider.family<
    AnnounceDetailItemNotifier, Map<String, dynamic>, String>((ref, documentId) {
  final announceItemRepository = ref.read(announceItemRepositoryProvider); // announceItemRepository 인스턴스를 가져옴
  return AnnounceDetailItemNotifier(announceItemRepository, ref, documentId); // AnnounceDetailItemNotifier 인스턴스를 반환함
});
