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

// ------- order_screen.dart - 발주 관련 내용 시작 부분
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
// ------- order_screen.dart - 발주 관련 내용 끝 부분

// ------- Firestore에서 요청내역 화면 내 요청내역 데이터를 페이징 처리하여 상태로 관리하는 역할하는 OrderlistItemsNotifier 클래스 내용 시작 부분
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
      loadMoreOrderItems();  // 첫 데이터 로드를 수행함.
    });
  }

  // ------ Firestore에서 발주 아이템을 페이징 처리해서 불러오는 함수 시작 부분
  Future<void> loadMoreOrderItems() async {
    // 이미 로딩 중일 때 중복 로딩을 방지함.
    if (isLoadingMore) {
      print("이미 로딩 중입니다.");
      return;
    }

    print("데이터 로드를 시작합니다.");
    isLoadingMore = true;  // 로딩 상태를 활성화함.
    // 로딩 상태를 true로 설정함.
    ref.read(isLoadingProvider.notifier).state = true;

    // 현재 로그인한 사용자를 확인함.
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("사용자가 로그인되어 있지 않습니다.");
      state = [];  // 로그인한 사용자가 없을 경우 상태를 빈 리스트로 설정함.
      isLoadingMore = false;  // 로딩 상태를 해제함.
      ref.read(isLoadingProvider.notifier).state = false;
      return;
    }

    // Firestore에서 5개의 발주 데이터를 페이징 처리하여 가져옴.
    final newItems = await orderlistRepository.fetchOrdersByEmail(
      // 네이버 로그인 및 회원가입 시, 'users' 문서명이 사용자 UID이므로 해당 경우도 포함시킨 형태
      userEmail: user.email ?? user.uid, // 현재 사용자 이메일을 넘김.
      lastDocument: lastDocument,  // 마지막 문서 이후 데이터를 불러옴.
      limit: 5,  // 한 번에 5개의 아이템을 불러옴.
    );

    // 새로 불러온 데이터가 있을 경우 상태를 업데이트함.
    if (newItems.isNotEmpty) {
      lastDocument = newItems.last['snapshot'];  // 마지막 문서를 기록함.
      state = [...state, ...newItems];  // 기존 데이터에 새 데이터를 추가함.
      print("새로 불러온 데이터: ${newItems.length}개");
      print("현재 전체 데이터: ${state.length}개");
    } else {
      print("더 이상 불러올 데이터가 없습니다.");
    }
    // 로딩 상태를 false로 설정함.
    ref.read(isLoadingProvider.notifier).state = false;
    // 로딩 상태를 해제함.
    isLoadingMore = false;
    print("데이터 로드를 완료했습니다.");
  }
  // ------ Firestore에서 발주 아이템을 페이징 처리해서 불러오는 함수 끝 부분

  // ------ 발주 아이템 데이터를 초기화하고 상태를 재설정하는 함수 시작 부분
  void resetAndReloadOrderItems() async {
    print("발주 아이템 데이터를 초기화합니다."); // 데이터 초기화 시작 메시지
    isLoadingMore = false;  // 로딩 상태 플래그 초기화
    state = [];  // 불러온 데이터를 초기화함
    lastDocument = null;  // 마지막 문서 스냅샷 초기화
    print("발주 아이템 데이터 초기화 완료."); // 데이터 초기화 완료 메시지
    await loadMoreOrderItems(); // 데이터 로드
  }
  // ------ 발주 아이템 데이터를 초기화하고 상태를 재설정하는 함수 끝 부분

  // ------ 발주 아이템을 Firestore에서 삭제하는 함수 시작 부분
  Future<void> deleteOrderItems(String orderNumber) async {
    print("발주 아이템 삭제 요청 - 주문 번호: $orderNumber"); // 발주 아이템 삭제 요청 메시지

    // 현재 로그인한 사용자를 확인함.
    // 네이버 로그인 및 회원가입 시, 'users' 문서명이 사용자 UID이므로 해당 경우도 포함시킨 형태
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email ?? user?.uid; // 현재 로그인한 사용자 Email 가져옴
    if (userEmail == null) {
      print("사용자 인증 실패: 로그인 필요."); // 사용자 인증 실패 메시지
      throw Exception('사용자가 로그인되어 있지 않습니다.'); // 인증 실패 예외 발생
    }
    // 발주 아이템을 Firestore에서 삭제함.
    await orderlistRepository.fetchDeleteOrders(
      userEmail: userEmail,
      orderNumber: orderNumber,
    );

    // 삭제된 발주 아이템을 상태에서 제거함.
    state = state.where((item) => item['numberInfo']['order_number'] != orderNumber).toList();
    print("발주 아이템 삭제 완료 - 주문 번호: $orderNumber"); // 발주 아이템 삭제 완료 메시지
    resetAndReloadOrderItems();
  }
// ------ 발주 아이템을 Firestore에서 삭제하는 함수 끝 부분

//   // ------ Notifier가 dispose될 때 호출되는 함수 시작 부분
//   @override
//   void dispose() {
//     print("OrderlistItemsNotifier dispose 호출됨"); // dispose 호출 메시지
//     resetAndReloadOrderItems();  // dispose 시 데이터 초기화 수행
//     super.dispose();  // 부모 클래스의 dispose 함수 호출함.
//   }
// // ------ Notifier가 dispose될 때 호출되는 함수 끝 부분
}
// ------- Firestore에서 요청내역 화면 내 요청내역 데이터를 페이징 처리하여 상태로 관리하는 역할하는 OrderlistItemsNotifier 클래스 내용 끝 부분

// 요청내역을 가져오는 OrderItemsNotifier를 사용하는 StateNotifierProvider.
// 외부에서 접근할 수 있도록 StateNotifierProvider로 제공함.
final orderlistItemsProvider = StateNotifierProvider<OrderlistItemsNotifier, List<Map<String, dynamic>>>((ref) {
  // OrderlistRepository를 Provider에서 읽어옴.
  final orderlistRepository = ref.read(orderlistRepositoryProvider);

  print("OrderlistItemsProvider 초기화 중..."); // Provider 초기화 메시지
  // OrderlistItemsNotifier를 생성하고 Provider로 반환함.
  return OrderlistItemsNotifier(orderlistRepository, ref);
});

// ------- order_detail_list_screen.dart - 발주 내역 상세화면 내용 데이터 처리 로직 시작 부분
// ------ OrderlistDetailItemNotifier 클래스: Firestore와의 상호작용을 통해 요청내역 상세 화면 내 요청내역 상세 내용 상태를 관리하는 StateNotifier 클래스 내용 시작
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
    print("데이터 로드를 시작합니다.");

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
    print("발주 내역 데이터 로드 완료: ${title}");

    // 로딩 상태를 false로 설정함
    ref.read(isLoadingProvider.notifier).state = false;

    // 로딩 플래그를 해제함
    isLoadingMore = false;
    print("데이터 로드를 완료했습니다.");
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
    print('orderlistDetailItemProvider dispose 호출됨');
    // 상위 클래스의 dispose 메서드를 호출함
    super.dispose();
  }
}
// ------ OrderlistDetailItemNotifier 클래스: Firestore와의 상호작용을 통해 요청내역 상세 화면 내 요청내역 상세 내용 상태를 관리하는 StateNotifier 클래스 내용 끝

// 요청 내역 상세 데이터를 제공하는 StateNotifierProvider 설정임
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

// 요청내역 문서 갯수 상태를 구독하는 StreamProvider
final orderlistItemCountProvider = StreamProvider<int>((ref) {
  // orderlistRepository를 가져와 watchOrderlistItemCount 호출
  final orderlistRepository = ref.read(orderlistIconRepositoryProvider);
  return orderlistRepository.watchOrderlistItemCount();
});