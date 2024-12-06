import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../../../common/provider/common_state_provider.dart';
import '../repository/orderlist_repository.dart';
import 'orderlist_all_provider.dart';


// 발주내역 관리 화면에서 화면 자체 스크롤로 이동한 위치를 저장하는 StateProvider
final adminOrderlistScrollPositionProvider = StateProvider<double>((ref) => 0);
// 발주내역 상세 화면에서 화면 자체 스크롤로 이동한 위치를 저장하는 StateProvider
final adminOrderListDetailScrollPositionProvider = StateProvider<double>((ref) => 0);

// 특정 사용자의 이메일을 선택하는 상태 프로바이더
final adminSelectedOrdererEmailProvider = StateProvider<String?>((ref) => null);

// ------- orderlist_screen.dart - 발주 내역 화면 내용 데이터 처리 로직 시작 부분
// ------ AdminOrderlistItemsNotifier 클래스: Firestore와의 상호작용을 통해 발주 내역 내용 상태를 관리하는 StateNotifier 클래스 내용 시작
// ——— AdminOrderlistItemsNotifier 클래스 시작 부분
class AdminOrderlistItemsNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {
  final AdminOrderlistRepository adminOrderlistRepository; // 발주 내역 리포지토리를 나타내는 변수임
  final Ref ref; // Riverpod의 Ref 객체를 나타내는 변수임
  final String userEmail; // 현재 선택된 발주자의 이메일 주소를 나타내는 변수임

  DocumentSnapshot? lastDocument; // Firestore 페이징 처리를 위해 마지막으로 로드한 문서를 저장하는 변수임
  bool isLoadingMore = false; // 추가 데이터 로드 중인지 여부를 나타내는 플래그 변수임

  // ——— AdminOrderlistItemsNotifier 생성자 시작 부분
  AdminOrderlistItemsNotifier(
      this.adminOrderlistRepository, this.ref, this.userEmail)
      : super([]) // 초기 상태를 빈 리스트로 설정함
  {
    // userEmail이 비어있지 않을 경우 초기 데이터 로드를 진행함
    // userEmail이 존재하는 경우에만 loadMoreOrderItems를 호출함
    if (userEmail.isNotEmpty) { // 조건 검사함
      loadMoreOrderItems(); // 초기 데이터 로드 함수 호출함
    }
  } // ——— AdminOrderlistItemsNotifier 생성자 끝 부분

  // ——— loadMoreOrderItems 함수 시작 부분
  Future<void> loadMoreOrderItems() async { // Firestore에서 더 많은 발주 내역 아이템을 불러오는 함수임
    if (isLoadingMore) { // 이미 로딩 중인지 확인함
      print("이미 로딩 중입니다. 추가 로드를 방지합니다."); // 중복 로드 방지 메시지 출력함
      return; // 함수 종료함
    }

    print("데이터 로드를 시작합니다."); // 데이터 로드를 시작했음을 알리는 메시지 출력함
    isLoadingMore = true; // 로딩 상태를 true로 설정함

    if (userEmail.isEmpty) { // userEmail이 비어있는 경우 처리함
      print("발주자 이메일이 없습니다."); // 발주자 이메일이 없음을 알리는 메시지 출력함
      state = []; // 상태를 빈 리스트로 초기화함
      isLoadingMore = false; // 로딩 상태 해제함
      return; // 함수 종료함
    }

    print("Firestore에서 새로운 발주내역 아이템 6개를 요청합니다."); // Firestore에서 데이터를 요청함을 알리는 메시지 출력함
    try {
      // adminOrderlistRepository를 통해 Firestore에서 데이터 가져옴
      final newItems = await adminOrderlistRepository.fetchOrdersByEmail(
        userEmail: userEmail, // 현재 선택된 발주자 이메일을 인자로 넘김
        lastDocument: lastDocument, // 페이징 처리를 위한 마지막 문서 정보를 넘김
        limit: 6, // 한 번에 불러올 아이템 수를 6개로 제한함
      ); // 비동기 호출로 Firestore에서 발주 내역을 가져옴

      if (newItems.isNotEmpty) { // 불러온 새 아이템이 비어있지 않다면 처리함
        lastDocument = newItems.last['snapshot']; // 마지막 아이템의 snapshot을 lastDocument에 저장함
        state = [...state, ...newItems]; // 기존 상태에 새로운 아이템들을 추가하여 상태 업데이트함
        print("새로 불러온 데이터: ${newItems.length}개"); // 새로 불러온 데이터 개수 출력함
        print("현재 전체 데이터: ${state.length}개"); // 전체 데이터 개수 출력함
      } else {
        print("더 이상 불러올 데이터가 없습니다."); // 추가로 불러올 데이터가 없음을 알리는 메시지 출력함
      }
    } catch (e) {
      print("발주 데이터를 로드하는 중 오류 발생: $e"); // 데이터 로딩 중 오류 발생 시 해당 내용 출력함
    } finally {
      isLoadingMore = false; // 로딩 상태를 해제함
      print("데이터 로드를 완료했습니다."); // 데이터 로드 완료 메시지 출력함
    }
  } // ——— loadMoreOrderItems 함수 끝 부분

  // ——— resetAndReloadOrderItems 함수 시작 부분
  void resetAndReloadOrderItems() async { // 상태를 초기화하고 데이터를 다시 로드하는 함수임
    print("발주 아이템 데이터를 초기화합니다."); // 데이터 초기화 시작 메시지 출력함
    isLoadingMore = false; // 로딩 상태 초기화함
    state = []; // 상태를 빈 리스트로 초기화함
    lastDocument = null; // 마지막 문서 정보 초기화함
    print("발주 아이템 데이터 초기화 완료."); // 데이터 초기화 완료 메시지 출력함
    await loadMoreOrderItems(); // 초기화 후 다시 데이터 로딩 함수 호출함
  } // ——— resetAndReloadOrderItems 함수 끝 부분
}
// ------ AdminOrderlistItemsNotifier 클래스 내용 끝

// ——— adminOrderlistItemsListNotifierProvider Provider 시작 부분
// adminOrderlistItemsListNotifierProvider: AdminOrderlistItemsNotifier를 제공하는 Riverpod Provider임
final adminOrderlistItemsListNotifierProvider = StateNotifierProvider<
    AdminOrderlistItemsNotifier, List<Map<String, dynamic>>>(
      (ref) {
    final orderlistRepository =
    ref.read(adminOrderlistRepositoryProvider); // 발주내역 리포지토리 인스턴스 읽음
    final userEmail =
        ref.watch(adminSelectedOrdererEmailProvider) ?? ''; // 현재 선택된 발주자의 이메일을 가져옴
    return AdminOrderlistItemsNotifier(
        orderlistRepository, ref, userEmail); // Notifier 인스턴스 생성 및 반환함
  },
);
// ——— adminOrderlistItemsListNotifierProvider Provider 끝 부분

// ------- orderlist_screen.dart - 발주 내역 화면 내용 데이터 처리 로직 끝 부분

// ------- orderlist_detail_screen.dart - 발주 내역 상세화면 내용 데이터 처리 로직 시작 부분
// ------ AdminOrderlistDetailItemNotifier 클래스: Firestore와의 상호작용을 통해 발주 내역 상세 내용 상태를 관리하는 StateNotifier 클래스 내용 시작

// ——— AdminOrderlistDetailItemNotifier 클래스 시작 부분
class AdminOrderlistDetailItemNotifier extends StateNotifier<Map<String, dynamic>> {
  final AdminOrderlistRepository orderlistRepository; // 발주 내역 리포지토리 인스턴스를 저장하는 변수임
  final Ref ref; // Riverpod의 Ref 객체를 저장하는 변수임
  final String userEmail; // 발주자 이메일을 저장하는 변수임
  final String orderNumber; // 발주 번호를 저장하는 변수임

  bool isLoadingMore = false; // 데이터 처리 중 로딩 여부를 나타내는 플래그 변수임

  // ——— AdminOrderlistDetailItemNotifier 생성자 시작 부분
  AdminOrderlistDetailItemNotifier(this.orderlistRepository, this.ref, this.userEmail, this.orderNumber) : super({}) {
    // 위젯이 완전히 빌드된 후 실행되도록 addPostFrameCallback을 통해 콜백 등록함
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("초기 발주 내역 데이터를 로드합니다."); // 초기 데이터 로드 시작 메시지 출력함
      loadMoreOrderlistDetailItem(userEmail, orderNumber); // 상세 발주 데이터 로드 함수 호출함
    });
  } // ——— AdminOrderlistDetailItemNotifier 생성자 끝 부분

  // ——— loadMoreOrderlistDetailItem 함수 시작 부분
  Future<void> loadMoreOrderlistDetailItem(String userEmail, String orderNumber) async {
    if (isLoadingMore) { // 이미 로딩 중인지 확인함
      print("이미 로딩 중입니다. 추가 로드를 방지합니다."); // 중복 로드 방지 메시지 출력함
      return; // 함수 종료함
    }

    print("발주 내역 데이터 로드를 시작합니다."); // 데이터 로드 시작 메시지 출력함
    isLoadingMore = true; // 로딩 상태를 true로 설정함

    ref.read(isLoadingProvider.notifier).state = true; // 글로벌 로딩 상태를 true로 설정함

    if (!mounted) return; // dispose 상태일 경우 상태 업데이트를 중단함

    if (userEmail.isEmpty) { // 발주자 이메일이 없는 경우 처리함
      print("발주자 이메일이 없습니다."); // 발주자 이메일 없음 메시지 출력함
      state = {}; // 상태를 빈 Map으로 초기화함
      isLoadingMore = false; // 로딩 상태 해제함
      return; // 함수 종료함
    }

    // Firestore에서 해당 발주 번호의 상세 내역을 가져옴
    final orderlistDetailItem = await orderlistRepository.fetchOrderlistItemByOrderNumber(userEmail, orderNumber); // 발주 번호 기반으로 상세 데이터 가져옴

    // 'title' 필드가 없을 경우 'numberInfo'의 'order_number' 필드를 제목으로 사용함
    final title = orderlistDetailItem['title'] ?? orderlistDetailItem['numberInfo']?['order_number'] ?? ''; // 제목 정보 확인함

    state = orderlistDetailItem.isNotEmpty ? orderlistDetailItem : {}; // 상태를 가져온 데이터로 설정, 없을 경우 빈 Map 설정함
    print("발주 내역 데이터 로드 완료 - 제목: $title"); // 발주 내역 데이터 로드 완료 후 제목 출력함

    ref.read(isLoadingProvider.notifier).state = false; // 글로벌 로딩 상태를 false로 설정함

    isLoadingMore = false; // 로딩 플래그 해제함
    print("발주 내역 데이터 로드를 완료했습니다."); // 데이터 로드 완료 메시지 출력함
  } // ——— loadMoreOrderlistDetailItem 함수 끝 부분

  // ——— resetOrderlistDetailItem 함수 시작 부분
  void resetOrderlistDetailItem() {
    print("발주 내역 데이터를 초기화합니다."); // 데이터 초기화 시작 메시지 출력함
    isLoadingMore = false; // 로딩 플래그 초기화함
    state = {}; // 상태를 빈 Map으로 초기화함
    print("발주 내역 데이터 초기화 완료."); // 데이터 초기화 완료 메시지 출력함
  } // ——— resetOrderlistDetailItem 함수 끝 부분

  // ——— dispose 함수 시작 부분
  @override
  void dispose() {
    print("OrderlistDetailItemNotifier dispose 호출됨"); // dispose 호출 시 메시지 출력함
    super.dispose(); // 상위 클래스의 dispose 메서드 호출함
  } // ——— dispose 함수 끝 부분
}
// ------ AdminOrderlistDetailItemNotifier 클래스 내용 끝

// ——— adminOrderlistDetailItemProvider Provider 시작 부분
// adminOrderlistDetailItemProvider: 발주 내역 상세 데이터를 제공하는 StateNotifierProvider 설정임
final adminOrderlistDetailItemProvider = StateNotifierProvider.autoDispose.family<
    AdminOrderlistDetailItemNotifier, Map<String, dynamic>, Tuple2<String, String>>((ref, tuple) {
  final orderlistDetailItemRepository = ref.read(adminOrderlistRepositoryProvider); // orderlistItemRepository 인스턴스를 가져옴
  print("AdminOrderlistDetailItemProvider 초기화 중..."); // Provider 초기화 메시지 출력함
  return AdminOrderlistDetailItemNotifier(orderlistDetailItemRepository, ref, tuple.item1, tuple.item2); // Notifier 인스턴스 반환함
});
// ——— adminOrderlistDetailItemProvider Provider 끝 부분

// ------- orderlist_detail_screen.dart - 발주 내역 상세화면 내용 데이터 처리 로직 끝 부분



