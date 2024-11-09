// Riverpod는 Flutter에서 사용할 수 있는 현대적이고 강력한 상태 관리 라이브러리입니다.
// 이 라이브러리는 앱의 상태를 전역적으로 관리할 수 있게 해주며, 앱 내에서 필요한 데이터의 흐름과 상태 변화를
// 효율적으로 관리할 수 있도록 설계되어 있습니다.
// Riverpod는 Provider 패키지의 기능을 확장하며, 더 유연하고 테스트하기 쉬운 코드를 작성할 수 있게 해 줍니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/event_data_repository.dart';
import 'common_all_providers.dart';

// 현재 페이지 인덱스를 관리하는 StateProvider(common_body_parts_layout.dart 내 공통 위젯 내에 구현되는 부분)
final currentPageProvider = StateProvider<int>((ref) => 0);
// onTopBarTap 함수를 상태 관리하기 위한 사용한 StateProvider
final selectedTabIndexProvider = StateProvider<int>((ref) => 0);
// buildCommonBottomNavigationBar 상태 관리를 위한 StateProvider
final tabIndexProvider = StateProvider<int>((ref) => 0);
// 선택된 중간 카테고리 버튼의 인덱스 상태 관리를 위한 StateProvider
final selectedMidCategoryProvider = StateProvider<int>((ref) => 0);
// 중간 카테고리 버튼의 열 수를 확장/축소하여 보이는 상태 관리를 위한 StateProvider
final midCategoryViewBoolExpandedProvider =
    StateProvider<bool>((ref) => false); // 기본값은 축소된 상태
// 현재 선택된 상단 탭 바 관련 탭의 인덱스 상태 관리를 위한 StateProvider
final currentTabProvider = StateProvider<int>((ref) => 0);

// 데이터를 로딩할 때 사용되는 로딩 상태를 관리하는 공통 StateProvider
final isLoadingProvider = StateProvider<bool>((ref) => false);


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

    // 이벤트 포스터 이미지 데이터를 초기화하고 상태를 재설정하는 함수임
    void resetEventPosterImgItems() {
        isLoadingMore = false; // 로딩 플래그를 초기화함
        hasMoreData = true; // 데이터가 더 이상 없음 플래그 초기화
        state = []; // 상태를 빈 리스트로 초기화함
        lastDocument = null; // 마지막 문서 스냅샷을 초기화함
    }

    // 구독을 취소하고 리소스를 해제하는 함수임
    @override
    void dispose() {
        super.dispose(); // 상위 클래스의 dispose 메서드를 호출함
    }
}
// ------ EventPosterImgNotifier 클래스: Firestore와의 상호작용을 통해 이벤트 포스터 이미지 데이터 상태를 관리하는 StateNotifier 클래스 내용 끝

// EventPosterImgItemsNotifier를 사용하는 StateNotifierProvider임
final eventPosterImgItemsProvider =
StateNotifierProvider<EventPosterImgItemsNotifier, List<Map<String, dynamic>>>((ref) {
    final eventPosterImgItemRepository = ref.read(eventPosterImgItemRepositoryProvider); // announceItemRepository 인스턴스를 가져옴
    return EventPosterImgItemsNotifier(eventPosterImgItemRepository, ref); // AnnounceItemsNotifier 인스턴스를 반환함
});