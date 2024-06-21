
// Riverpod는 Flutter에서 사용할 수 있는 현대적이고 강력한 상태 관리 라이브러리입니다.
// 이 라이브러리를 통해 개발자는 애플리케이션의 상태를 보다 효율적으로 관리할 수 있습니다.
// Riverpod는 기존의 Provider 패키지를 개선하여 더 유연하고, 테스트가 용이하며,
// 강력한 타입 안정성을 제공하는 기능을 갖추고 있습니다.
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../product/model/product_model.dart';


// 홈 화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final homeLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 홈 화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final homeSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 홈 화면의 작은 배너2 페이지 인덱스를 관리하기 위한 StateProvider
final homeSmall2BannerPageProvider = StateProvider<int>((ref) => 0);
// 홈 화면의 작은 배너3 페이지 인덱스를 관리하기 위한 StateProvider
final homeSmall3BannerPageProvider = StateProvider<int>((ref) => 0);
// 다른 화면으로 이동했다가 다시 돌아오는 경우의
// 홈 화면에서 각 상단 탭 바 관련 섹션의 스크롤 위치와 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final homeScrollPositionProvider = StateProvider<double>((ref) => 0);
// 로그아웃했다가 다시 재로그인하는 경우의
// 홈 화면에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final homeLoginAndLogoutScrollPositionProvider = StateProvider<double>((ref) => 0);
// 현재 선택된 상단 탭 바 관련 탭의 인덱스 상태 관리를 위한 StateProvider
final homeCurrentTabProvider = StateProvider<int>((ref) => 0);
// 홈 화면 내 카테고리 버튼 뷰 확장 유무 상태 관리를 위한 StateProvider
final homeMidCategoryViewBoolExpandedProvider = StateProvider<bool>((ref) => false);

// ------ SectionStateNotifier 클래스 내용 구현 시작
// SectionDataStateNotifier 클래스는 홈 화면 내 섹션의 불러온 데이터 상태를 관리하는 기능을 함
class SectionDataStateNotifier extends StateNotifier<Map<String, List<ProductContent>>> {
  SectionDataStateNotifier() : super({});

  // 카테고리에 해당하는 섹션을 업데이트하는 함수
  void updateSection(String category, List<ProductContent> products) {
    state = {...state, category: products}; // 현재 상태를 복사한 후 새로운 데이터를 추가하여 상태를 업데이트
  }

  // 카테고리에 해당하는 섹션을 초기화하는 함수
  void resetSection(String category) {
    state = {...state, category: []}; // 현재 상태를 복사한 후 해당 카테고리의 리스트를 빈 리스트로 초기화
  }

  // 카테고리에 해당하는 제품 리스트를 반환하는 함수
  List<ProductContent> getSectionProducts(String category) {
    return state[category] ?? []; // 해당 카테고리에 데이터가 없으면 빈 리스트를 반환
  }
}
// ------ SectionStateNotifier 클래스 내용 구현 끝

// 홈 화면 내 섹션의 불러온 데이터 저장을 위한 StateNotifierProvider
final homeSectionDataStateProvider = StateNotifierProvider<SectionDataStateNotifier, Map<String, List<ProductContent>>>((ref) {
  return SectionDataStateNotifier();
});

// 홈 화면 내 섹션의 가로 스크롤 위치 저장을 위한 StateProvider
final homeSectionScrollPositionsProvider = StateProvider<Map<String, double>>((ref) => {});

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
