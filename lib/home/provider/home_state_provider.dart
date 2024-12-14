// Riverpod는 Flutter에서 사용할 수 있는 현대적이고 강력한 상태 관리 라이브러리입니다.
// 이 라이브러리를 통해 개발자는 애플리케이션의 상태를 보다 효율적으로 관리할 수 있습니다.
// Riverpod는 기존의 Provider 패키지를 개선하여 더 유연하고, 테스트가 용이하며,
// 강력한 타입 안정성을 제공하는 기능을 갖추고 있습니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/provider/common_all_providers.dart';
import '../../common/provider/common_state_provider.dart';
import '../../common/repository/event_data_repository.dart';
import '../../product/model/product_model.dart';
import '../repository/home_repository.dart';
import 'home_all_providers.dart';

// 홈 화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final homeLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 홈 화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final homeSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 다른 화면으로 이동했다가 다시 돌아오는 경우의
// 홈 화면에서 각 상단 탭 바 관련 섹션의 스크롤 위치와 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final homeScrollPositionProvider = StateProvider<double>((ref) => 0);
// 로그아웃했다가 다시 재로그인하는 경우의
// 홈 화면에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final homeLoginAndLogoutScrollPositionProvider =
    StateProvider<double>((ref) => 0);
// 현재 선택된 상단 탭 바 관련 탭의 인덱스 상태 관리를 위한 StateProvider
final homeCurrentTabProvider = StateProvider<int>((ref) => 0);
// 이벤트 섹션 내 가로 스크롤 상태 관리를 위한 StateProvider
final eventPosterScrollPositionProvider = StateProvider<double>((ref) => 0.0);

// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 homeScrollControllerProvider라는 이름의 Provider를 정의함.
// 하단 탭 바의 홈 버튼 관련 상태 관리 provider
final homeScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// ------ 메인 홈 화면 내 마켓 버튼 부분의 데이터 및 상태관리 관련 로직인 MarketBtnNotifier 클래스 내용 시작
class MarketBtnNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final MarketBtnRepository repository;

  MarketBtnNotifier(this.repository) : super([]);

  // Firestore에서 모든 데이터를 불러옴
  Future<void> loadAllMarketButtons() async {
    try {
      final allItems = await repository.fetchAllMarketButtons();
      state = allItems;
      print("불러온 버튼 상태: ${state.length}개");
    } catch (e) {
      print("데이터 로드 중 오류 발생: $e");
    }
  }

  // 데이터 초기화
  void resetMarketButtons() {
    state = [];
    print("중간 카테고리 버튼 데이터를 초기화했습니다.");
  }
}
// ------ 메인 홈 화면 내 마켓 버튼 부분의 데이터 및 상태관리 관련 로직인 MarketBtnNotifier 클래스 내용 끝

// MarketBtnNotifier 클래스 인스턴스 생성하는 StateNotifierProvider
final marketBtnProvider = StateNotifierProvider<MarketBtnNotifier, List<Map<String, dynamic>>>((ref) {
  final repository = ref.watch(marketBtnRepositoryProvider);
  return MarketBtnNotifier(repository);
});

// ------ EventPosterImgItemsNotifier 클래스: Firestore와의 상호작용을 통해 이벤트 포스터 이미지 데이터 상태를 관리하는 StateNotifier 클래스 내용 시작
class EventPosterImgItemsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  // EventPosterImgRepository 인스턴스를 저장하는 변수임
  final EventRepository eventPosterImgItemRepository;

  // Riverpod의 Ref 객체를 저장하는 변수임
  final Ref ref;

  // 마지막으로 불러온 데이터의 스냅샷을 저장하는 변수임
  DocumentSnapshot? lastDocument;

  // 페이징 처리 중인지 여부를 나타내는 플래그임
  bool isLoadingMore = false;

  // 더 이상 데이터가 없을 때를 위한 플래그
  bool hasMoreData = true;

  // 생성자에서 EventPosterImgRepository와 Ref를 받아 초기 상태를 빈 리스트로 설정함
  // 초기 데이터 로딩을 위해 loadMoreEventPosterImgItems 메서드를 호출함
  EventPosterImgItemsNotifier(this.eventPosterImgItemRepository, this.ref) : super([]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMoreEventPosterImgItems();
    });
  }

  // Firestore에서 이벤트 포스터 이미지 아이템을 페이징 처리하여 불러오는 함수임
  Future<void> loadMoreEventPosterImgItems() async {
    // 로딩 중이거나 더 이상 데이터가 없으면 반환
    if (isLoadingMore || !hasMoreData) {
      print("이미 로딩 중이거나 더 이상 불러올 데이터가 없습니다.");
      return;
    }

    print("데이터 로드를 시작합니다.");
    isLoadingMore = true; // 로딩 상태를 true로 설정함
    ref.read(isLoadingProvider.notifier).state = true; // 로딩 상태를 관리하는 프로바이더의 상태를 true로 설정함

    // Firestore에서 데이터를 4개씩 페이징 처리로 불러옴
    final newItems = await eventPosterImgItemRepository.getPagedEventPosterImgItems(
      lastDocument: lastDocument,
      limit: 4,
    );

    // 불러온 데이터가 있을 경우
    if (newItems.isNotEmpty) {
      lastDocument = newItems.last['snapshot']; // 마지막 문서를 저장함
      state = [...state, ...newItems]; // 기존 데이터에 새로 불러온 데이터를 추가함
      print("새로 불러온 데이터: ${newItems.length}개");
      print("현재 전체 데이터: ${state.length}개");
    } else {
      // 불러온 데이터가 없을 경우 더 이상 불러올 데이터가 없음을 표시
      hasMoreData = false;
      print("더 이상 불러올 데이터가 없습니다.");
    }

    // 로딩 상태를 false로 설정하여 로딩 종료를 알림
    ref.read(isLoadingProvider.notifier).state = false; // 로딩 상태를 false로 설정함
    isLoadingMore = false; // 로딩 플래그를 해제함
    print("데이터 로드를 완료했습니다.");
  }

  // 이벤트 섹션 내 특정 문서의 모든 이벤트 이미지를 가져오는 함수
  Future<List<String>> loadEventPosterOriginalImages(String documentId) async {
    print("문서 ID ${documentId}의 이벤트 원본 이미지를 로드합니다."); // 이벤트 원본 이미지 로드 시작 로그 메시지
    // eventPosterImgItemRepository를 통해 documentId에 해당하는 이벤트 원본 이미지를 가져옴
    return await eventPosterImgItemRepository.getEventPosterOriginalImages(documentId);
  }

  // 이벤트 포스터 이미지 데이터를 초기화하고 상태를 재설정하는 함수임
  void resetEventPosterImgItems() {
    print("이벤트 포스터 이미지 데이터를 초기화합니다."); // 데이터 초기화 시작 로그 메시지
    isLoadingMore = false; // 로딩 플래그를 초기화함
    hasMoreData = true; // 데이터가 더 이상 없음 플래그 초기화
    state = []; // 상태를 빈 리스트로 초기화함
    lastDocument = null; // 마지막 문서 스냅샷을 초기화함
    print("이벤트 포스터 이미지 데이터 초기화 완료."); // 데이터 초기화 완료 로그 메시지
  }

  // 구독을 취소하고 리소스를 해제하는 함수임
  @override
  void dispose() {
    print("EventPosterImgItemsNotifier 구독을 취소하고 리소스를 해제합니다."); // dispose 시작 로그 메시지
    super.dispose(); // 상위 클래스의 dispose 메서드를 호출함
  }
}
// ------ EventPosterImgNotifier 클래스: Firestore와의 상호작용을 통해 이벤트 포스터 이미지 데이터 상태를 관리하는 StateNotifier 클래스 내용 끝

// EventPosterImgItemsNotifier를 사용하는 StateNotifierProvider임
final eventPosterImgItemsProvider =
StateNotifierProvider<EventPosterImgItemsNotifier, List<Map<String, dynamic>>>((ref) {
  final eventPosterImgItemRepository = ref.read(eventPosterImgItemRepositoryProvider); // announceItemRepository 인스턴스를 가져옴
  print("EventPosterImgItemsProvider 초기화 중..."); // StateNotifierProvider 초기화 로그 메시지
  return EventPosterImgItemsNotifier(eventPosterImgItemRepository, ref); // AnnounceItemsNotifier 인스턴스를 반환함
});