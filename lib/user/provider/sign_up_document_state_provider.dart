
import 'package:dongdaemoon_beta_v1/user/provider/sign_up_document_all_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/provider/common_state_provider.dart';
import '../repository/sign_up_document_repository.dart';


// -------- sign_up_document_screen.dart 관련 ScrollControllerProvider 시작
// 동의서 화면에서 화면 자체 스크롤로 이동한 위치를 저장하는 StateProvider
final signUpDocumentScrollPositionProvider = StateProvider<double>((ref) => 0);

// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 signUpDocumentScrollControllerProvider라는 이름의 Provider를 정의함.
final signUpDocumentScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 함.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});
// -------- sign_up_document_screen.dart 관련 ScrollControllerProvider 끝

// ------ SignUpDocumentDetailItemNotifier 클래스: Firestore와의 상호작용을 통해 동의서 상세 내용 상태를 관리하는 StateNotifier 클래스 내용 시작
class SignUpDocumentDetailItemNotifier extends StateNotifier<Map<String, dynamic>> {
  // SignUpDocumentRepository 인스턴스를 저장하는 변수임
  final SignUpDocumentRepository signUpDocumentRepository;

  // Riverpod의 Ref 객체를 저장하는 변수임
  final Ref ref;

  // 데이터 처리 중 로딩 여부를 나타내는 플래그임
  bool isLoadingMore = false;

  // 생성자에서 SignUpDocumentRepository와 Ref를 받아 초기 상태를 빈 Map으로 설정함
  // 초기 데이터 로딩을 위해 loadMoreDocumentDetailItem 메서드를 호출함
  SignUpDocumentDetailItemNotifier(this.signUpDocumentRepository, this.ref, String documentId) : super({}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMoreDocumentDetailItem(documentId);
    });
  }

  // Firestore에서 동의서 아이템을 불러오는 함수임
  Future<void> loadMoreDocumentDetailItem(String documentId) async {
    if (isLoadingMore) {
      print("이미 로딩 중입니다.");
      return; // 중복 로딩 방지함
    }

    print("데이터 로드를 시작합니다.");
    isLoadingMore = true; // 로딩 상태를 true로 설정함
    ref.read(isLoadingProvider.notifier).state = true; // 로딩 상태를 관리하는 프로바이더의 상태를 true로 설정함

    // Firestore에서 동의서 문서 데이터를 가져옴
    final documentDetailItem = await signUpDocumentRepository.getDocumentDetailItem(documentId);

    state = documentDetailItem.isNotEmpty ? documentDetailItem : {}; // 가져온 데이터를 상태로 설정함
    print("동의서 데이터 로드 완료: ${documentDetailItem['title']}");

    ref.read(isLoadingProvider.notifier).state = false; // 로딩 상태를 false로 설정함
    isLoadingMore = false; // 로딩 플래그를 해제함
    print("데이터 로드를 완료했습니다.");
  }

  // 동의서 데이터를 초기화하고 상태를 재설정하는 함수임
  void resetDocumentDetailItem() {
    isLoadingMore = false; // 로딩 플래그를 초기화함
    state = {}; // 상태를 빈 Map으로 초기화함
    print("동의서 상세 데이터를 초기화했습니다."); // 데이터 초기화 메시지
  }

  // 구독을 취소하고 리소스를 해제하는 함수임
  @override
  void dispose() {
    super.dispose(); // 상위 클래스의 dispose 메서드를 호출함
    print("SignUpDocumentDetailItemNotifier의 리소스를 해제했습니다."); // 리소스 해제 메시지
  }
}
// ------ SignUpDocumentDetailItemNotifier 클래스: Firestore와의 상호작용을 통해 동의서 상세 내용 상태를 관리하는 StateNotifier 클래스 내용 끝

// 동의서 상세 데이터를 제공하는 StateNotifierProvider 설정임
final signUpDocumentDetailItemProvider = StateNotifierProvider.family<
    SignUpDocumentDetailItemNotifier, Map<String, dynamic>, String>((ref, documentId) {
  final documentItemRepository = ref.read(signUpDocumentItemRepositoryProvider); // SignUpDocumentRepository 인스턴스를 가져옴
  return SignUpDocumentDetailItemNotifier(documentItemRepository, ref, documentId); // SignUpDocumentDetailItemNotifier 인스턴스를 반환함
});