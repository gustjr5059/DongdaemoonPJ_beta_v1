
// Riverpod 라이브러리를 임포트합니다.
// 이 라이브러리는 상태 관리를 위한 강력하고 유연한 프레임워크로, 애플리케이션의 다양한 상태를 관리하는데 도움을 줍니다.
// Riverpod는 기존 Provider 라이브러리를 기반으로 하여 더욱 발전된 기능을 제공하며,
// 각종 상태 관리 요구 사항을 보다 세밀하고 효과적으로 다룰 수 있도록 설계되었습니다.
// 이를 통해 앱의 상태를 전역적으로 또는 로컬적으로 제어하고, 상태 변화에 따라 UI를 자동으로 업데이트하는 구조를 구현할 수 있습니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongdaemoon_beta_v1/product/provider/product_future_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/provider/home_state_provider.dart';
import '../layout/product_body_parts_layout.dart';
import '../model/product_model.dart';


// 티셔츠 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final shirtMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 블라우스 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final blouseMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 맨투맨 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final mtmMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 니트 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final neatMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 폴라티 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final polaMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 원피스 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final onepieceMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 팬츠 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final pantsMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 청바지 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final jeanMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 스커트 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final skirtMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 패딩 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final paedingMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 코트 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final coatMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 가디건 카테고리 메인화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final cardiganMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);

// 티셔츠 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final shirtMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 블라우스 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final blouseMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 맨투맨 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final mtmMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 니트 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final neatMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 폴라티 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final polaMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 원피스 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final onepieceMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 팬츠 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final pantsMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 청바지 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final jeanMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 스커트 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final skirtMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 패딩 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final paedingMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 코트 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final coatMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 가디건 카테고리 메인화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final cardiganMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);

// 티셔츠 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final shirtDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 블라우스 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final blouseDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 맨투맨 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final mtmDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 니트 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final neatDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 폴라티 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final polaDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 원피스 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final onepieceDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 팬츠 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final pantsDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 청바지 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final jeanDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 스커트 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final skirtDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 패딩 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final paedingDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 코트 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final coatDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 가디건 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final cardiganDetailBannerPageProvider = StateProvider<int>((ref) => 0);

// 색상 선택을 위한 상태 관리용 StateProvider
final colorSelectionIndexProvider = StateProvider<String?>((ref) => null);
// 사이즈 선택을 위한 상태 관리용 StateProvider
final sizeSelectionProvider = StateProvider<String?>((ref) => null);

// 현재 선택된 상단 탭 바 관련 탭의 인덱스 상태 관리를 위한 StateProvider
final blouseCurrentTabProvider = StateProvider<int>((ref) => 0);
final cardiganCurrentTabProvider = StateProvider<int>((ref) => 0);
final coatCurrentTabProvider = StateProvider<int>((ref) => 0);
final jeanCurrentTabProvider = StateProvider<int>((ref) => 0);
final mtmCurrentTabProvider = StateProvider<int>((ref) => 0);
final neatCurrentTabProvider = StateProvider<int>((ref) => 0);
final onepieceCurrentTabProvider = StateProvider<int>((ref) => 0);
final paedingCurrentTabProvider = StateProvider<int>((ref) => 0);
final pantsCurrentTabProvider = StateProvider<int>((ref) => 0);
final polaCurrentTabProvider = StateProvider<int>((ref) => 0);
final shirtCurrentTabProvider = StateProvider<int>((ref) => 0);
final skirtCurrentTabProvider = StateProvider<int>((ref) => 0);

// 각 카테고리별 메인화면에서 각 상단 탭 바 관련 섹션의 스크롤 위치와 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final blouseMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final cardiganMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final coatMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final jeanMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final mtmMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final neatMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final onepieceMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final paedingMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final pantsMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final polaMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final shirtMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final skirtMainScrollPositionProvider = StateProvider<double>((ref) => 0);

// 각 카테고리별 상세화면에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final blouseDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final cardiganDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final coatDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final jeanDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final mtmDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final neatDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final onepieceDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final paedingDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final pantsDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final polaDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final shirtDetailScrollPositionProvider = StateProvider<double>((ref) => 0);
final skirtDetailScrollPositionProvider = StateProvider<double>((ref) => 0);

// -------- product_main_screen.dart 관련 ScrollControllerProvider 시작
// 2차 메인 화면-블라우스 메인 화면
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 blouseMainScrollControllerProvider라는 이름의 Provider를 정의함.
final blouseMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 2차 메인 화면-가디건 메인 화면
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 cardiganMainScrollControllerProvider라는 이름의 Provider를 정의함.
final cardiganMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 2차 메인 화면-코트 메인 화면
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 coatMainScrollControllerProvider라는 이름의 Provider를 정의함.
final coatMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 2차 메인 화면-청바지 메인 화면
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 jeanMainScrollControllerProvider라는 이름의 Provider를 정의함.
final jeanMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 2차 메인 화면-맨투맨 메인 화면
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 mtmMainScrollControllerProvider라는 이름의 Provider를 정의함.
final mtmMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 2차 메인 화면-니트 메인 화면
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 neatMainScrollControllerProvider라는 이름의 Provider를 정의함.
final neatMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 2차 메인 화면-원피스 메인 화면
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 onepieceMainScrollControllerProvider라는 이름의 Provider를 정의함.
final onepieceMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 2차 메인 화면-패딩 메인 화면
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 paedingMainScrollControllerProvider라는 이름의 Provider를 정의함.
final paedingMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 2차 메인 화면-팬츠 메인 화면
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 pantsMainScrollControllerProvider라는 이름의 Provider를 정의함.
final pantsMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 2차 메인 화면-폴라티 메인 화면
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 polaMainScrollControllerProvider라는 이름의 Provider를 정의함.
final polaMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 2차 메인 화면-티셔츠 메인 화면
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 shirtMainScrollControllerProvider라는 이름의 Provider를 정의함.
final shirtMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 2차 메인 화면-스커트 메인 화면
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 skirtMainScrollControllerProvider라는 이름의 Provider를 정의함.
final skirtMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});
// -------- product_main_screen.dart 관련 ScrollControllerProvider 끝

// -------- product_sub_main_screen.dart 관련 ScrollControllerProvider 시작
// 신상 서브 메인
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 skirtMainScrollControllerProvider라는 이름의 Provider를 정의함.
final newSubMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});


// 최고 서브 메인
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 bestSubMainScrollControllerProvider라는 이름의 Provider를 정의함.
final bestSubMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 할인 서브 메인
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 saleSubMainScrollControllerProvider라는 이름의 Provider를 정의함.
final saleSubMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 봄 서브 메인
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 springSubMainScrollControllerProvider라는 이름의 Provider를 정의함.
final springSubMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 여름 서브 메인
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 summerSubMainScrollControllerProvider라는 이름의 Provider를 정의함.
final summerSubMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 가을 서브 메인
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 autumnSubMainScrollControllerProvider라는 이름의 Provider를 정의함.
final autumnSubMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});

// 겨울 서브 메인
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 winterSubMainScrollControllerProvider라는 이름의 Provider를 정의함.
final winterSubMainScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});
// -------- product_sub_main_screen.dart 관련 ScrollControllerProvider 끝

// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트) 상품 데이터 불러오고 상태를 관리하는 클래스 시작
// ------- ProductMainListNotifier 클래스 내용 구현 시작
class ProductMainListNotifier extends StateNotifier<List<ProductContent>> {
  // 생성자: Provider 참조와 기본 컬렉션 이름을 받아 초기 상태를 빈 리스트로 설정
  ProductMainListNotifier(this.ref, this.baseCollection) : super([]);

  final Ref ref; // Provider 참조
  final String baseCollection; // 기본 컬렉션 이름
  bool _isFetching = false; // 데이터 가져오는 중인지 여부를 나타내는 변수
  DocumentSnapshot? _lastDocument; // 마지막 문서 스냅샷 저장 변수
  bool get isFetching => _isFetching; // 데이터 가져오는 중인지 여부 반환

  // 제품을 가져오는 함수 (초기 로드 여부에 따라 다름)
  Future<void> _fetchProducts({
    bool isInitial = false, // 초기 로드인지 여부
    required List<String> collectionNames, // 가져올 컬렉션 이름 리스트
  }) async {
    if (_isFetching) return; // 이미 가져오는 중이면 리턴
    _isFetching = true; // 가져오는 중으로 설정
    try {
      // 제품 내용을 가져오는 함수 호출
      final products = await ref.read(productRepositoryProvider(collectionNames)).fetchProductContents(
        limit: 3, // 한 번에 가져올 상품 수 제한
        startAfter: isInitial ? null : _lastDocument, // 초기 로드면 처음부터, 아니면 마지막 문서 이후부터
      );

      // // 디버깅 출력 추가
      // debugPrint('Fetched products count: ${products.length}');
      // if (_lastDocument != null) {
      //   debugPrint('Last document before fetch: ${_lastDocument!.id}');
      // }

      if (products.isNotEmpty) {
        _lastDocument = products.last.documentSnapshot; // 마지막 문서 업데이트
        // debugPrint('Last document after fetch: ${_lastDocument!.id}');
        state = isInitial ? products : [...state, ...products]; // 초기 로드면 상태를 덮어쓰고, 아니면 기존 상태에 추가
      } else {
        if (isInitial) state = []; // 초기 로드에서 가져온 제품이 없으면 상태를 빈 리스트로 설정
      }
    } catch (e) {
      // 에러 발생 시 디버깅용 출력
      debugPrint('Error fetching products: $e');
    } finally {
      _isFetching = false; // 가져오는 중 상태 해제
    }
  }

  // 초기 제품을 가져오는 함수
  Future<void> fetchInitialProducts(String category) async {
    _lastDocument = null; // 초기 로드시 마지막 문서 초기화
    state = []; // 상태 초기화
    List<String> collectionNames = _getCollectionNames(category); // 카테고리에 따른 컬렉션 이름 가져오기
    await _fetchProducts(isInitial: true, collectionNames: collectionNames); // 초기 로드로 제품 가져오기
  }

  // 더 많은 제품을 가져오는 함수
  Future<void> fetchMoreProducts(String category) async {
    // fetching 중이거나 첫 페이지가 로드되지 않았다면 리턴
    if (_isFetching || _lastDocument == null) return;
    List<String> collectionNames = _getCollectionNames(category); // 카테고리에 따른 컬렉션 이름 가져오기
    await _fetchProducts(collectionNames: collectionNames); // 더 많은 제품 가져오기
  }

  // 데이터 초기화 함수
  void reset() {
    state = []; // 상태 초기화
    _lastDocument = null; // 마지막 문서 초기화
  }

  // 카테고리에 따른 컬렉션 이름 반환 함수
  List<String> _getCollectionNames(String category) {
    switch (category) {
      case '신상':
        return ['${baseCollection}1'];
      case '최고':
        return ['${baseCollection}2'];
      case '할인':
        return ['${baseCollection}3'];
      case '봄':
        return ['${baseCollection}4'];
      case '여름':
        return ['${baseCollection}5'];
      case '가을':
        return ['${baseCollection}6'];
      case '겨울':
        return ['${baseCollection}7'];
      default: // 전체
        return [
          '${baseCollection}1',
          '${baseCollection}2',
          '${baseCollection}3',
          '${baseCollection}4',
          '${baseCollection}5',
          '${baseCollection}6',
          '${baseCollection}7'
        ];
    }
  }
}
// ------- ProductMainListNotifier 클래스 내용 구현 끝

// 카테고리별로 ProductMainListNotifier 인스턴스를 생성하는 프로바이더 정의
// UI 코드에서 category 값을 인자로 전달하여 fetchInitialProducts와 fetchMoreProducts를 호출할 수 있음
final blouseMainProductListProvider = StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  return ProductMainListNotifier(ref, 'a2b');
});

final cardiganMainProductListProvider = StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  return ProductMainListNotifier(ref, 'a12b');
});

final coatMainProductListProvider = StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  return ProductMainListNotifier(ref, 'a11b');
});

final jeanMainProductListProvider = StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  return ProductMainListNotifier(ref, 'a8b');
});

final mtmMainProductListProvider = StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  return ProductMainListNotifier(ref, 'a3b');
});

final neatMainProductListProvider = StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  return ProductMainListNotifier(ref, 'a4b');
});

final onepieceMainProductListProvider = StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  return ProductMainListNotifier(ref, 'a6b');
});

final paedingMainProductListProvider = StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  return ProductMainListNotifier(ref, 'a10b');
});

final pantsMainProductListProvider = StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  return ProductMainListNotifier(ref, 'a7b');
});

final polaMainProductListProvider = StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  return ProductMainListNotifier(ref, 'a5b');
});

final shirtMainProductListProvider = StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  return ProductMainListNotifier(ref, 'a1b');
});

final skirtMainProductListProvider = StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  return ProductMainListNotifier(ref, 'a9b');
});
// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트) 상품 데이터 불러오고 상태를 관리하는 클래스 끝


