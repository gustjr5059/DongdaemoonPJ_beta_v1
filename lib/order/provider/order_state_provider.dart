import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../../common/provider/common_state_provider.dart';
import '../../product/model/product_model.dart';
import '../repository/order_repository.dart';
import 'order_all_providers.dart';


// ------- order_list_detail_screen.dart - 발주내역 상세 관련 내용 시작 부분
// 발주 내역 상세 화면에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final orderListDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
// ------- order_list_detail_screen.dart - 발주내역 상세 관련 내용 끝 부분

// ------- order_list_screen.dart - 발주내역 관련 내용 시작 부분
// 발주 내역 화면에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final orderListScrollPositionProvider = StateProvider<double>((ref) => 0);

// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 orderListScrollControllerProvider라는 이름의 Provider를 정의함.
final orderListScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});
// ------- order_list_screen.dart - 발주내역 관련 내용 끝 부분

// ------- order_screen.dart - 발주 화면 내용 데이터 처리 로직 시작 부분
// 발주 화면에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final orderMainScrollPositionProvider = StateProvider<double>((ref) => 0);

// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 orderMainScrollControllerProvider라는 이름의 Provider를 정의함.
final orderMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 발주 화면으로 전달할 상품 리스트를 관리하는 상태 프로바이더
final orderItemsProvider = StateNotifierProvider<OrderItemsNotifier, List<ProductContent>>((ref) {
  return OrderItemsNotifier();
});

class OrderItemsNotifier extends StateNotifier<List<ProductContent>> {
  OrderItemsNotifier() : super([]);

  void setOrderItems(List<ProductContent> items) {
    state = items;
  }
}
// ------- order_screen.dart - 발주 화면 내용 데이터 처리 로직 끝 부분

// ------- order_list_screen.dart - 발주 내역 화면 내용 데이터 처리 로직 시작 부분
// ------- Firestore에서 발주 데이터를 페이징 처리하여 상태로 관리하는 역할하는 OrderlistItemsNotifier 클래스 내용 시작 부분
class OrderlistItemsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  // OrderlistRepository와 Ref를 저장하는 필드 선언.
  final OrderlistRepository orderlistRepository;
  final Ref ref;

  // 마지막 문서 스냅샷과 로딩 상태를 저장하는 필드 선언.
  DocumentSnapshot? lastDocument;
  bool isLoadingMore = false;

  // 생성자에서 OrderlistRepository와 Ref를 받아 초기 상태를 빈 리스트로 설정함.
  OrderlistItemsNotifier(this.orderlistRepository, this.ref) : super([]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("초기 데이터 로드를 시작합니다."); // 초기 로드 시작 메시지
      loadMoreOrderItems();  // 첫 데이터 로드를 수행함.
    });
  }

  // ------ Firestore에서 발주 아이템을 페이징 처리해서 불러오는 함수 시작 부분
  Future<void> loadMoreOrderItems() async {
    // 이미 로딩 중이면 중복 로딩을 방지함.
    if (isLoadingMore) {
      print("이미 로딩 중입니다. 추가 로드를 방지합니다."); // 중복 로드 방지 메시지
      return;
    }

    print("데이터 로드를 시작합니다."); // 데이터 로드 시작 메시지
    isLoadingMore = true;  // 로딩 중 상태로 변경.
    // 로딩 상태를 true로 설정함.
    ref.read(isLoadingProvider.notifier).state = true;

    // 현재 로그인한 사용자를 확인함.
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("사용자가 로그인되어 있지 않습니다. 빈 상태로 설정합니다."); // 사용자 미로그인 시 메시지
      state = [];  // 사용자가 없으면 상태를 빈 리스트로 설정.
      isLoadingMore = false;  // 로딩 상태 해제.
      return;
    }

    // Firestore에서 발주 데이터를 5개씩 페이징 처리로 가져옴.
    final newItems = await orderlistRepository.fetchOrdersByEmail(
      userEmail: user.email!,  // 현재 사용자 이메일을 매개변수로 넘김.
      lastDocument: lastDocument,  // 마지막 문서 이후의 데이터를 불러옴.
      limit: 5,  // 한번에 5개의 아이템을 불러옴.
    );

    // 새로 불러온 데이터가 있을 경우 상태를 업데이트함.
    if (newItems.isNotEmpty) {
      lastDocument = newItems.last['snapshot'];  // 마지막 문서를 기록함.
      state = [...state, ...newItems];  // 기존 데이터에 새 데이터를 추가함.
      print("새로 불러온 데이터: ${newItems.length}개"); // 불러온 데이터 개수 로그
      print("현재 전체 데이터: ${state.length}개"); // 현재 상태 내 전체 데이터 수 로그
    } else {
      print("더 이상 불러올 데이터가 없습니다."); // 추가 데이터 없음 메시지
    }
    // 로딩 상태를 false로 설정함.
    ref.read(isLoadingProvider.notifier).state = false;
    // 로딩 상태를 해제함.
    isLoadingMore = false;
    print("데이터 로드를 완료했습니다."); // 데이터 로드 완료 메시지
  }
  // ------ Firestore에서 발주 아이템을 페이징 처리해서 불러오는 함수 끝 부분

  // ------ 발주 아이템을 Firestore에서 삭제하는 함수 시작 부분
  Future<void> deleteOrderItems(String orderNumber) async {
    print("발주 아이템 삭제 요청 - 주문 번호: $orderNumber"); // 발주 아이템 삭제 요청 메시지

    // 현재 로그인한 사용자를 확인함.
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // 발주 아이템을 Firestore에서 삭제함.
      await orderlistRepository.fetchDeleteOrders(user.email!, orderNumber);

      // 삭제된 발주 아이템을 상태에서 제거함.
      state = state.where((item) => item['numberInfo']['order_number'] != orderNumber).toList();
      print("발주 아이템 삭제 완료 - 주문 번호: $orderNumber"); // 발주 아이템 삭제 완료 메시지
    } else {
      print("삭제 실패 - 사용자 정보 없음"); // 사용자 미로그인 시 삭제 실패 메시지
    }
  }
  // ------ 발주 아이템을 Firestore에서 삭제하는 함수 끝 부분

  // ------ 발주 아이템 데이터를 초기화하고 상태를 재설정하는 함수 시작 부분
  void resetOrderItems() {
    print("발주 아이템 데이터를 초기화합니다."); // 데이터 초기화 시작 메시지
    isLoadingMore = false;  // 로딩 상태 플래그 초기화
    state = [];  // 불러온 데이터를 초기화함
    lastDocument = null;  // 마지막 문서 스냅샷 초기화
    print("발주 아이템 데이터 초기화 완료."); // 데이터 초기화 완료 메시지
  }
  // ------ 발주 아이템 데이터를 초기화하고 상태를 재설정하는 함수 끝 부분

  // ------ Notifier가 dispose될 때 호출되는 함수 시작 부분
  @override
  void dispose() {
    print("OrderlistItemsNotifier dispose 호출됨"); // dispose 호출 메시지
    resetOrderItems();  // dispose 시 데이터 초기화 수행
    super.dispose();  // 부모 클래스의 dispose 함수 호출함.
  }
// ------ Notifier가 dispose될 때 호출되는 함수 끝 부분
}
// ------- Firestore에서 발주 데이터를 페이징 처리하여 상태로 관리하는 역할하는 OrderlistItemsNotifier 클래스 내용 끝 부분

// OrderItemsNotifier를 사용하는 StateNotifierProvider.
// 외부에서 접근할 수 있도록 StateNotifierProvider로 제공함.
final orderlistItemsProvider = StateNotifierProvider<OrderlistItemsNotifier, List<Map<String, dynamic>>>((ref) {
  // OrderlistRepository를 Provider에서 읽어옴.
  final orderlistRepository = ref.read(orderlistRepositoryProvider);

  print("OrderlistItemsProvider 초기화 중..."); // Provider 초기화 메시지
  // OrderlistItemsNotifier를 생성하고 Provider로 반환함.
  return OrderlistItemsNotifier(orderlistRepository, ref);
});
// ------- order_list_screen.dart - 발주 내역 화면 내용 데이터 처리 로직 끝 부분

// ------- order_detail_list_screen.dart - 발주 내역 상세화면 내용 데이터 처리 로직 시작 부분
// ------ OrderlistDetailItemNotifier 클래스: Firestore와의 상호작용을 통해 발주 내역 상세 내용 상태를 관리하는 StateNotifier 클래스 내용 시작
class OrderlistDetailItemNotifier extends StateNotifier<Map<String, dynamic>> {
  // orderlistRepository 인스턴스를 저장하는 변수임
  final OrderlistRepository orderlistRepository;

  // Riverpod의 Ref 객체를 저장하는 변수임
  final Ref ref;

  // 사용자 이메일과 발주 번호를 저장하는 변수임
  final String userEmail;
  final String orderNumber;

  // 데이터 처리 중 로딩 여부를 나타내는 플래그임
  bool isLoadingMore = false;

  // 생성자에서 OrderlistRepository와 Ref를 받아 초기 상태를 빈 Map으로 설정함
  // 초기 데이터 로딩을 위해 loadMoreOrderlistDetailItem 메서드를 호출함
  OrderlistDetailItemNotifier(this.orderlistRepository, this.ref, this.userEmail, this.orderNumber) : super({}) {
    // 위젯이 완전히 빌드된 후 실행되도록 콜백을 추가함
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("초기 발주 내역 데이터를 로드합니다."); // 초기 데이터 로드 메시지
      // 발주 내역 데이터를 불러오는 함수를 호출함
      loadMoreOrderlistDetailItem(userEmail, orderNumber);
    });
  }

  // Firestore에서 발주 내역 아이템을 불러오는 함수임
  Future<void> loadMoreOrderlistDetailItem(String userEmail, String orderNumber) async {
    // 만약 이미 로딩 중이라면, 중복 로딩을 방지하기 위해 반환함
    if (isLoadingMore) {
      print("이미 로딩 중입니다. 추가 로드를 방지합니다."); // 중복 로드 방지 메시지
      return;
    }

    // 데이터 로딩을 시작한다고 출력함
    print("발주 내역 데이터 로드를 시작합니다."); // 데이터 로드 시작 메시지

    // 로딩 상태를 true로 설정함
    isLoadingMore = true;

    // 로딩 상태를 관리하는 프로바이더의 상태를 true로 설정함
    ref.read(isLoadingProvider.notifier).state = true;

    // 만약 dispose 상태라면 이후 상태 업데이트가 발생하지 않도록 반환함
    if (!mounted) return;

    // 사용자 인증 상태를 확인함
    final user = FirebaseAuth.instance.currentUser;

    // 만약 사용자가 로그인하지 않았다면, 상태를 빈 Map으로 설정하고 로딩 상태를 해제함
    if (user == null) {
      print("사용자가 로그인되어 있지 않습니다. 빈 데이터로 설정합니다."); // 사용자 미로그인 시 메시지
      state = {};
      isLoadingMore = false;
      ref.read(isLoadingProvider.notifier).state = false; // 로딩 상태 해제
      return;
    }

    // Firestore에서 발주 내역 아이템을 가져옴
    final orderlistDetailItem = await orderlistRepository.fetchOrderlistItemByOrderNumber(userEmail, orderNumber);

    // 'title' 필드가 없을 경우 'numberInfo'의 'order_number' 필드를 대신 출력하도록 설정함
    final title = orderlistDetailItem['title'] ?? orderlistDetailItem['numberInfo']?['order_number'] ?? '';

    // 가져온 데이터를 상태로 설정하고, 데이터가 없을 경우 빈 Map으로 설정함
    state = orderlistDetailItem.isNotEmpty ? orderlistDetailItem : {};
    print("발주 내역 데이터 로드 완료 - 제목: $title"); // 데이터 로드 완료 후 제목 로그 출력

    // 로딩 상태를 false로 설정함
    ref.read(isLoadingProvider.notifier).state = false;

    // 로딩 플래그를 해제함
    isLoadingMore = false;
    print("발주 내역 데이터 로드를 완료했습니다."); // 데이터 로드 완료 메시지
  }

  // 발주 내역 데이터를 초기화하고 상태를 재설정하는 함수임
  void resetOrderlistDetailItem() {
    print("발주 내역 데이터를 초기화합니다."); // 데이터 초기화 시작 메시지
    // 로딩 플래그를 초기화함
    isLoadingMore = false;
    // 상태를 빈 Map으로 초기화함
    state = {};
    print("발주 내역 데이터 초기화 완료."); // 데이터 초기화 완료 메시지
  }

  // 구독을 취소하고 리소스를 해제하는 함수임
  @override
  void dispose() {
    // dispose 메서드 호출을 출력함
    print("OrderlistDetailItemNotifier dispose 호출됨"); // dispose 호출 메시지
    // 상위 클래스의 dispose 메서드를 호출함
    super.dispose();
  }
}
// ------ OrderlistDetailItemNotifier 클래스 내용 끝

// 발주 내역 상세 데이터를 제공하는 StateNotifierProvider 설정임
// Tuple2 사용 이유: family를 사용하면 기존에서 매개변수 1개를 추가 가능한데,
// 여기에서는 매개변수를 2개를 추가해야하므로 autoDispose.family, Tuple2를 사용함!!
final orderlistDetailItemProvider = StateNotifierProvider.autoDispose.family<
    OrderlistDetailItemNotifier, Map<String, dynamic>, Tuple2<String, String>>((ref, tuple) {
  // orderlistItemRepository 인스턴스를 가져옴
  final orderlistDetailItemRepository = ref.read(orderlistRepositoryProvider);

  print("OrderlistDetailItemProvider 초기화 중..."); // Provider 초기화 메시지
  // OrderlistDetailItemNotifier 인스턴스를 반환함
  return OrderlistDetailItemNotifier(orderlistDetailItemRepository, ref, tuple.item1, tuple.item2);
});
// ------- order_detail_list_screen.dart - 발주 내역 상세화면 내용 데이터 처리 로직 끝 부분

// ------- 수령자 정보 즐겨찾기 선택 화면 로직 내용 시작
// 수령자 정보 즐겨찾기 선택 화면에서 스크롤 위치를 저장하는 StateProvider
// 수령자 정보 선택 화면에서 스크롤 위치를 저장하고 관리하는 StateProvider
final recipientInfoFavoritesSelectScrollPositionProvider = StateProvider<double>((ref) => 0);

// ------ RecipientInfoItemsNotifier 클래스: Firestore와의 상호작용을 통해 수령자 정보 즐겨찾기 목록 상태를 관리하는 StateNotifier 클래스 내용 시작
// RecipientInfoItemsNotifier 클래스는 Firestore와 상호작용하여 수령자 정보 즐겨찾기 목록 상태를 관리하는 역할을 수행함
class RecipientInfoItemsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  // 아이템별 실시간 구독을 관리하는 Map (아이템 ID -> 구독 객체)
  // 각 아이템에 대한 실시간 구독을 관리하는 Map
  final Map<String, StreamSubscription<Map<String, dynamic>>> _itemSubscriptions = {};
  // RecipientInfoItemRepository 인스턴스를 저장하는 변수
  // Firestore와의 상호작용을 담당하는 RecipientInfoItemRepository 인스턴스를 저장함
  final RecipientInfoItemRepository recipientInfoItemRepository;
  // Riverpod의 Ref 객체를 저장하는 변수
  // Riverpod의 Ref 객체를 저장하여 상태 관리를 지원함
  final Ref ref;
  // 마지막으로 불러온 데이터의 스냅샷을 저장하는 변수
  // 마지막으로 불러온 Firestore 데이터 스냅샷을 저장하는 변수
  DocumentSnapshot? lastDocument;
  // 페이징 처리 중 여부를 나타내는 플래그
  // 데이터를 페이징 처리 중인지 여부를 나타내는 상태 플래그
  bool isLoadingMore = false;

  // 스트림에 대한 실시간 구독 여부를 관리하는 플래그
  // 실시간 스트림 구독 여부를 관리하는 플래그
  bool isListeningToStream = false;

  // 초기 데이터 로딩 완료 여부를 나타내는 플래그
  // 초기 데이터 로딩 완료 상태를 관리하는 플래그
  bool _isInitialLoadComplete = false;

  // 생성자에서 RecipientInfoItemRepository와 Ref를 받아서 초기 상태를 빈 리스트로 설정함
  // 생성자에서 Firestore 데이터 로딩을 위한 초기 상태를 빈 리스트로 설정함
  // 초기 데이터 로딩을 위해 loadMoreRecipientInfoItems 메서드를 호출함
  RecipientInfoItemsNotifier(this.recipientInfoItemRepository, this.ref) : super([]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("초기 수령자 정보 데이터를 로드합니다."); // 초기 데이터 로드 시작 메시지
      loadMoreRecipientInfoItems(); // 초기 데이터 로딩을 비동기적으로 호출함
    });
  }

  // Firestore에서 수령자 정보 즐겨찾기 목록 내 아이템을 페이징 처리해서 불러오는 함수
  Future<void> loadMoreRecipientInfoItems() async {
    if (isLoadingMore) {
      print("이미 로딩 중입니다. 중복 로드를 방지합니다."); // 중복 로드 방지 메시지
      return; // 이미 로딩 중이면 중복 로딩을 방지함
    }

    print("수령자 정보 데이터 로드를 시작합니다."); // 데이터 로드 시작 메시지
    isLoadingMore = true;
    // 로딩 상태를 true로 설정함
    ref.read(isLoadingProvider.notifier).state = true;

    // 사용자 인증 상태 확인
    // 현재 사용자가 로그인되어 있는지 확인함
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("사용자가 로그인되어 있지 않습니다. 빈 데이터로 설정합니다."); // 사용자 미로그인 시 메시지
      state = [];
      isLoadingMore = false;
      ref.read(isLoadingProvider.notifier).state = false; // 로딩 상태 해제
      return; // 로그인되지 않은 경우 데이터 로딩을 중단함
    }

    // Firestore에서 데이터를 페이징하여 4개씩 가져옴
    final newItems = await recipientInfoItemRepository.getPagedRecipientInfoItems(
      lastDocument: lastDocument, // 마지막으로 불러온 문서 이후의 데이터를 가져옴
      limit: 4, // 한번에 가져올 데이터 개수를 설정함
    );

    if (newItems.isNotEmpty) {
      lastDocument = newItems.last['snapshot']; // 마지막 문서를 기록함
      state = [...state, ...newItems]; // 기존 데이터에 새로 불러온 데이터를 병합함
      print("새로 불러온 데이터: ${newItems.length}개"); // 새로 불러온 데이터 개수 로그
      print("현재 전체 데이터: ${state.length}개"); // 현재 전체 데이터 수 로그
    } else {
      print("더 이상 불러올 데이터가 없습니다."); // 추가 데이터 없음 메시지
    }

    // 로딩 상태를 false로 설정함
    ref.read(isLoadingProvider.notifier).state = false;
    isLoadingMore = false;
    print("수령자 정보 데이터 로드를 완료했습니다."); // 데이터 로드 완료 메시지

    // 초기 로딩이 완료되면 각 아이템에 대해 실시간 구독을 시작함
    // 첫 로딩 완료 후 각 아이템의 실시간 상태를 구독함
    if (!_isInitialLoadComplete) {
      _isInitialLoadComplete = true;
    }
    _subscribeToIndividualItemUpdates(); // 아이템별 구독을 설정함
  }

  // 각 아이템에 대해 실시간 체크박스 상태와 삭제 이벤트를 처리하는 함수
  // 각 아이템의 실시간 상태 변화를 구독하고 처리하는 함수
  void _subscribeToIndividualItemUpdates() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || isListeningToStream) return; // 로그인되지 않았거나 이미 구독 중이면 종료함
    isListeningToStream = true;

    // 각 아이템의 실시간 업데이트를 구독함
    // 아이템별로 Firestore의 실시간 업데이트를 구독함
    for (final item in state) {
      final itemId = item['id'] ?? ''; // 아이템 ID를 가져옴

      // itemId가 비어있지 않은 경우에만 구독을 시작함
      // 유효한 ID가 있는 경우에만 구독을 설정함
      if (itemId.isNotEmpty && !_itemSubscriptions.containsKey(itemId)) {
        final subscription = recipientInfoItemRepository.recipientInfoItemStream(itemId).listen((updatedItem) {
          if (updatedItem == null) {
            // 문서가 삭제된 경우 구독을 해제함
            _itemSubscriptions[itemId]?.cancel(); // 구독을 해제함
            _itemSubscriptions.remove(itemId); // 구독 관리에서 제거함
            print('문서가 존재하지 않아 itemId: $itemId에 대한 구독이 취소되었습니다.');
          } else {
            // 상태를 업데이트함
            // 상태를 새로 구독된 데이터로 업데이트함
            state = [
              for (final recipientInfoItem in state)
                if (recipientInfoItem['id'] == updatedItem['id'])
                  updatedItem // 업데이트된 아이템을 상태에 반영함
                else
                  recipientInfoItem
            ];
            print("itemId: $itemId에 대한 상태가 업데이트되었습니다."); // 상태 업데이트 메시지
          }
        });
        _itemSubscriptions[itemId] = subscription; // 구독을 관리하는 Map에 추가함
        print("itemId: $itemId에 대한 실시간 구독이 시작되었습니다."); // 구독 시작 메시지
      } else {
        print("Error: 아이템의 ID가 null이거나 빈 문자열입니다. 구독을 건너뜁니다.");
      }
    }
  }

  // 수령자 정보 즐겨찾기 목록에서 아이템을 제거하고 상태를 갱신하는 함수
  // Firestore에서 아이템을 삭제하고 상태를 갱신하는 함수
  Future<void> removeItem(String id) async {
    await recipientInfoItemRepository.removeRecipientInfoItem(id); // Firestore에서 아이템을 제거함
    state = state.where((item) => item['id'] != id).toList(); // 상태에서 해당 아이템을 제거함
    print("itemId: $id가 삭제되었습니다."); // 삭제 완료 메시지

    // 해당 아이템에 대한 구독을 해제하고 Map에서 제거함
    // 삭제된 아이템의 실시간 구독을 해제하고 구독 관리에서 제거함
    _itemSubscriptions[id]?.cancel();
    _itemSubscriptions.remove(id);
  }

  // 수령자 정보 즐겨찾기 목록 내 데이터를 초기화하고 상태를 재설정하는 함수
  // 수령자 정보 즐겨찾기 데이터를 초기화하는 함수
  void resetRecipientInfoItems() {
    print("수령자 정보 데이터를 초기화합니다."); // 데이터 초기화 시작 메시지
    isLoadingMore = false; // 로딩 플래그 초기화
    state = []; // 불러온 데이터를 초기화함
    lastDocument = null; // 마지막 문서 스냅샷 초기화
    // 모든 아이템에 대한 실시간 구독을 해제함
    _unsubscribeFromAllItems(); // 모든 실시간 구독을 해제함
    print("수령자 정보 데이터 초기화 완료."); // 데이터 초기화 완료 메시지
  }

  // 모든 실시간 구독을 해제하는 함수
  // 모든 실시간 구독을 취소하고 리소스를 해제하는 함수
  void _unsubscribeFromAllItems() {
    for (final subscription in _itemSubscriptions.values) {
      subscription.cancel(); // 모든 구독을 해제함
    }
    _itemSubscriptions.clear(); // 구독 관리 Map을 초기화함
    print("모든 실시간 구독이 취소되었습니다."); // 모든 구독 취소 메시지
  }

  // 구독을 취소하고 리소스를 해제하는 함수
  // 상태관리 객체가 dispose될 때 구독을 취소하고 리소스를 해제하는 함수
  @override
  void dispose() {
    for (final subscription in _itemSubscriptions.values) {
      subscription.cancel(); // 모든 구독을 해제함
    }
    _itemSubscriptions.clear(); // 구독 관리 Map을 초기화함
    print("RecipientInfoItemsNotifier dispose 호출됨"); // dispose 호출 메시지
    super.dispose(); // 상위 클래스의 dispose 메서드를 호출함
  }
}
// ------ Firestore와의 상호작용을 위해 RecipientInfoItemRepository를 사용하여 상태를 관리하는 provider인 RecipientInfoItemsNotifier 클래스 내용 끝

// RecipientInfoItemsNotifier를 사용하는 StateNotifierProvider 설정
final recipientInfoItemsProvider =
StateNotifierProvider<RecipientInfoItemsNotifier, List<Map<String, dynamic>>>((ref) {
  final recipientInfoItemRepository = ref.read(recipientInfoItemRepositoryProvider); // RecipientInfoItemRepository 인스턴스를 가져옴
  return RecipientInfoItemsNotifier(recipientInfoItemRepository, ref); // RecipientInfoItemsNotifier 인스턴스를 생성하여 반환함
});

// ------- 수령자 정보 즐겨찾기 선택 화면 로직 내용 끝