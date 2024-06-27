// Riverpod 라이브러리를 임포트합니다.
// 이 라이브러리는 상태 관리를 위한 강력하고 유연한 프레임워크로, 애플리케이션의 다양한 상태를 관리하는데 도움을 줍니다.
// Riverpod는 기존 Provider 라이브러리를 기반으로 하여 더욱 발전된 기능을 제공하며,
// 각종 상태 관리 요구 사항을 보다 세밀하고 효과적으로 다룰 수 있도록 설계되었습니다.
// 이를 통해 앱의 상태를 전역적으로 또는 로컬적으로 제어하고, 상태 변화에 따라 UI를 자동으로 업데이트하는 구조를 구현할 수 있습니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongdaemoon_beta_v1/product/provider/product_future_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// 신상 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final newSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 최고 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final bestSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 할인 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final saleSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 봄 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final springSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 여름 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final summerSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 가을 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final autumnSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 겨울 서브 메인화면(섹션 더보기 화면)의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final winterSubMainLargeBannerPageProvider = StateProvider<int>((ref) => 0);

// 신상 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final newSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 최고 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final bestSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 할인 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final saleSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 봄 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final springSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 여름 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final summerSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 가을 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final autumnSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 겨울 서브 메인화면(섹션 더보기 화면)의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final winterSubMainSmall1BannerPageProvider = StateProvider<int>((ref) => 0);

// ------- 상품 상세 화면 관련 StateProvider 시작
// // 티셔츠 디테일 상품 화면의 이미지 페이지 인덱스를 관리하기 위한 StateProvider
// final shirtDetailImagePageProvider = StateProvider<int>((ref) => 0);
// // 블라우스 디테일 상품 화면의 이미지 페이지 인덱스를 관리하기 위한 StateProvider
// final blouseDetailImagePageProvider = StateProvider<int>((ref) => 0);
// // 맨투맨 디테일 상품 화면의 이미지 페이지 인덱스를 관리하기 위한 StateProvider
// final mtmDetailImagePageProvider = StateProvider<int>((ref) => 0);
// // 니트 디테일 상품 화면의 이미지 페이지 인덱스를 관리하기 위한 StateProvider
// final neatDetailImagePageProvider = StateProvider<int>((ref) => 0);
// // 폴라티 디테일 상품 화면의 이미지 페이지 인덱스를 관리하기 위한 StateProvider
// final polaDetailImagePageProvider = StateProvider<int>((ref) => 0);
// // 원피스 디테일 상품 화면의 이미지 페이지 인덱스를 관리하기 위한 StateProvider
// final onepieceDetailImagePageProvider = StateProvider<int>((ref) => 0);
// // 팬츠 디테일 상품 화면의 이미지 페이지 인덱스를 관리하기 위한 StateProvider
// final pantsDetailImagePageProvider = StateProvider<int>((ref) => 0);
// // 청바지 디테일 상품 화면의 이미지 페이지 인덱스를 관리하기 위한 StateProvider
// final jeanDetailImagePageProvider = StateProvider<int>((ref) => 0);
// // 스커트 디테일 상품 화면의 이미지 페이지 인덱스를 관리하기 위한 StateProvider
// final skirtDetailImagePageProvider = StateProvider<int>((ref) => 0);
// // 패딩 디테일 상품 화면의 이미지 페이지 인덱스를 관리하기 위한 StateProvider
// final paedingDetailImagePageProvider = StateProvider<int>((ref) => 0);
// // 코트 디테일 상품 화면의 이미지 페이지 인덱스를 관리하기 위한 StateProvider
// final coatDetailImagePageProvider = StateProvider<int>((ref) => 0);
// // 가디건 디테일 상품 화면의 이미지 페이지 인덱스를 관리하기 위한 StateProvider
// final cardiganDetailImagePageProvider = StateProvider<int>((ref) => 0);

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

// ------ 상세 화면마다의 각 id를 통해서 이미지 상태관리하는 provider를 케이스로 나눠서 개별적으로 사용하도록 한 로직 부분 시작
// _imagePageProviders라는 Map을 선언함. 키는 문자열이고 값은 StateProvider<int>임.
final Map<String, StateProvider<int>> _imagePageProviders = {};

// productId를 받아서 해당하는 StateProvider<int>를 반환하는 함수.
StateProvider<int> getImagePageProvider(String productId) {
  // _imagePageProviders에 productId가 존재하지 않으면 새 StateProvider<int>를 생성하여 추가하고, 존재하면 기존 값을 반환함.
  return _imagePageProviders.putIfAbsent(
      productId, () => StateProvider<int>((ref) => 0));
}
// ------ 상세 화면마다의 각 id를 통해서 이미지 상태관리하는 provider를 케이스로 나눠서 개별적으로 사용하도록 한 로직 부분 끝

// 상품 상세 화면에서 이미지 클릭 시, 상세 이미지 화면으로 이동하는 데 해당 화면 내 이미지 페이지 인덱스 상태관리 관련 StateProvider
final detailImagePageProvider = StateProvider<int>((ref) => 0);

// ------- 상품 상세 화면 관련 StateProvider 끝

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

// 각 섹션별 서브 메인 화면(섹션 더보기 화면)에서 단순 화면 스크롤로 이동환 위치를 저장하는 StateProvider
final newSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final bestSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final saleSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final springSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final summerSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final autumnSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);
final winterSubMainScrollPositionProvider = StateProvider<double>((ref) => 0);

// 2차 메인 화면 내 가격순, 할인순 버튼 관련 상태 관리 함수인 StateProvider
final blouseMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final cardiganMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final coatMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final jeanMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final mtmMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final neatMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final onepieceMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final paedingMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final pantsMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final polaMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final shirtMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final skirtMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정

// 섹션 더보기 화면 내 가격순, 할인순 버튼 관련 상태 관리 함수인 StateProvider
final newSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final bestSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final saleSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final springSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final summerSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final autumnSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정
final winterSubMainSortButtonProvider =
    StateProvider<String>((ref) => ''); // 기본값을 빈 문자열로 설정

// 주석처리한 해당 프로바이더는 현재 사용하지 않는 부분
// // -------- product_main_screen.dart 관련 ScrollControllerProvider 시작
// // 2차 메인 화면-블라우스 메인 화면
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 blouseMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final blouseMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 2차 메인 화면-가디건 메인 화면
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 cardiganMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final cardiganMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 2차 메인 화면-코트 메인 화면
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 coatMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final coatMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 2차 메인 화면-청바지 메인 화면
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 jeanMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final jeanMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 2차 메인 화면-맨투맨 메인 화면
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 mtmMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final mtmMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 2차 메인 화면-니트 메인 화면
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 neatMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final neatMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 2차 메인 화면-원피스 메인 화면
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 onepieceMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final onepieceMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 2차 메인 화면-패딩 메인 화면
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 paedingMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final paedingMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 2차 메인 화면-팬츠 메인 화면
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 pantsMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final pantsMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 2차 메인 화면-폴라티 메인 화면
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 polaMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final polaMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 2차 메인 화면-티셔츠 메인 화면
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 shirtMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final shirtMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 2차 메인 화면-스커트 메인 화면
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 skirtMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final skirtMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
// // -------- product_main_screen.dart 관련 ScrollControllerProvider 끝
//
// // -------- product_sub_main_screen.dart 관련 ScrollControllerProvider 시작
// // 신상 서브 메인
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 skirtMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final newSubMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 최고 서브 메인
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 bestSubMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final bestSubMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 할인 서브 메인
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 saleSubMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final saleSubMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 봄 서브 메인
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 springSubMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final springSubMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 여름 서브 메인
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 summerSubMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final summerSubMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 가을 서브 메인
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 autumnSubMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final autumnSubMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
//
// // 겨울 서브 메인
// // ScrollController를 프로바이더로 추가하는 코드
// // 이 코드는 winterSubMainScrollControllerProvider라는 이름의 Provider를 정의함.
// final winterSubMainScrollControllerProvider = Provider<ScrollController>((ref) {
//   // ScrollController 객체를 생성함.
//   final scrollController = ScrollController();
//   // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 힘.
//   // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
//   ref.onDispose(scrollController.dispose);
//   // 생성된 ScrollController 객체를 반환함.
//   return scrollController;
// });
// // -------- product_sub_main_screen.dart 관련 ScrollControllerProvider 끝

// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트)과 섹션 더보기 화면 (신상, ~ 겨울)) 상품 데이터 불러오고 상태를 관리하는 기본 추상 클래스 시작
// ------- BaseProductListNotifier 클래스 내용 구현 시작
// 해당 내용은 추상 클래스이며, 해당 클래스를 다른 클래스에 오버라이드(extends 사용)를 하면 해당 클래스 기능은 그대로 사용하면서 추가되는 내용을 각기 적용 가능하므로, 이렇게 구성

// 상태 관리 추상 클래스 BaseProductListNotifier를 정의 (상품 데이터 관리)
abstract class BaseProductListNotifier
    extends StateNotifier<List<ProductContent>> {
  // 생성자를 정의, ref와 baseCollection을 초기화
  BaseProductListNotifier(this.ref, this.baseCollection) : super([]);

  // Ref 객체 선언
  final Ref ref;

  // 기본 컬렉션 이름 선언
  final String baseCollection;

  // 데이터 페칭 상태를 관리하는 변수 선언
  bool _isFetching = false;

  // 마지막 문서 스냅샷을 저장하는 변수 선언
  DocumentSnapshot? _lastDocument;

  // 데이터 페칭 상태를 반환하는 getter 정의
  bool get isFetching => _isFetching;

  // 정렬 타입을 저장하는 변수 선언
  String _sortType = '';

  // 정렬 타입을 설정하는 setter 정의
  set sortType(String value) {
    _sortType = value;
    _sortProducts();
  }

  // 상품 데이터를 정렬하는 메서드 정의
  void _sortProducts() {
    // 상태를 복사하여 새로운 리스트에 저장
    List<ProductContent> sortedProducts = [...state];
    // 가격 높은 순 정렬
    if (_sortType == '가격 높은 순') {
      sortedProducts
          .sort((a, b) => b.discountPrice!.compareTo(a.discountPrice!));
      // 가격 낮은 순 정렬
    } else if (_sortType == '가격 낮은 순') {
      sortedProducts
          .sort((a, b) => a.discountPrice!.compareTo(b.discountPrice!));
      // 할인율 높은 순 정렬
    } else if (_sortType == '할인율 높은 순') {
      sortedProducts
          .sort((a, b) => b.discountPercent!.compareTo(a.discountPercent!));
      // 할인율 낮은 순 정렬
    } else if (_sortType == '할인율 낮은 순') {
      sortedProducts
          .sort((a, b) => a.discountPercent!.compareTo(b.discountPercent!));
    }
    // 상태를 정렬된 리스트로 업데이트
    state = sortedProducts;
  }

  // 상품 데이터를 페칭하는 비동기 메서드 정의
  Future<void> _fetchProducts({
    // 초기 페칭 여부를 나타내는 매개변수
    bool isInitial = false,
    // 컬렉션 이름 리스트를 매개변수로 받음
    required List<String> collectionNames,
  }) async {
    // 이미 페칭 중이면 리턴
    if (_isFetching) return;
    // 페칭 상태를 true로 설정
    _isFetching = true;
    try {
      // 상품 데이터를 페칭 (제한: 3개, 시작 문서: _lastDocument)
      final products = await ref
          .read(productRepositoryProvider(collectionNames))
          .fetchProductContents(
            limit: 3,
            startAfter: isInitial ? null : _lastDocument,
          );

      // 디버깅 출력 추가
      // debugPrint('Fetched products count: ${products.length}');
      // if (_lastDocument != null) {
      //   debugPrint('Last document before fetch: ${_lastDocument!.id}');
      // }

      // 페칭된 상품 데이터가 비어있지 않으면
      if (products.isNotEmpty) {
        // 마지막 문서를 업데이트
        _lastDocument = products.last.documentSnapshot;
        // debugPrint('Last document after fetch: ${_lastDocument!.id}');
        // 상태를 초기화 또는 기존 상태에 추가
        state = isInitial ? products : [...state, ...products];
      } else {
        // 초기화 시 비어있는 상태로 설정
        if (isInitial) state = [];
      }
      // 상품 데이터를 정렬
      _sortProducts();
    } catch (e) {
      // 에러 발생 시 디버깅 출력
      debugPrint('Error fetching products: $e');
    } finally {
      // 페칭 상태를 false로 설정
      _isFetching = false;
    }
  }

  // 초기 상품 데이터를 페칭하는 메서드 정의
  Future<void> fetchInitialProducts(String category) async {
    // 마지막 문서와 상태를 초기화
    _lastDocument = null;
    state = [];
    // 카테고리에 따른 컬렉션 이름 리스트를 얻음
    List<String> collectionNames = _getCollectionNames(category);
    // 초기 상품 데이터를 페칭
    await _fetchProducts(isInitial: true, collectionNames: collectionNames);
  }

  // 더 많은 상품 데이터를 페칭하는 메서드 정의
  Future<void> fetchMoreProducts(String category) async {
    // 이미 페칭 중이거나 마지막 문서가 없으면 리턴
    if (_isFetching || _lastDocument == null) return;
    // 카테고리에 따른 컬렉션 이름 리스트를 얻음
    List<String> collectionNames = _getCollectionNames(category);
    // 추가 상품 데이터를 페칭
    await _fetchProducts(collectionNames: collectionNames);
  }

  // 상태와 변수들을 초기화하는 메서드 정의
  void reset() {
    state = [];
    _lastDocument = null;
    _sortType = '';
  }

  // 카테고리에 따른 컬렉션 이름 리스트를 반환하는 추상 메서드
  List<String> _getCollectionNames(String category);
}
// ------- BaseProductListNotifier 클래스 내용 구현 끝
// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트)과 섹션 더보기 화면 (신상, ~ 겨울)) 상품 데이터 불러오고 상태를 관리하는 기본 추상 클래스 끝

// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트) 상품 데이터 불러오고 상태를 관리하는 클래스 (BaseProductListNotifier 추상 클래스를 오버라이드함-기능 상속받는 구조) 시작
// ------- ProductMainListNotifier 클래스 내용 구현 시작
// BaseProductListNotifier 클래스를 상속받는 ProductMainListNotifier 클래스 정의
class ProductMainListNotifier extends BaseProductListNotifier {
  // 생성자를 정의, ref와 baseCollection을 부모 클래스에 전달
  ProductMainListNotifier(Ref ref, String baseCollection)
      : super(ref, baseCollection);

  // 카테고리에 따른 컬렉션 이름 리스트를 반환하는 메서드 구현
  @override
  List<String> _getCollectionNames(String category) {
    // 카테고리별로 다른 컬렉션 이름 반환
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
      // 기본적으로 모든 컬렉션 반환
      default:
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

// 2차 메인 화면 관련 ProductMainListNotifier 인스턴스를 생성하는 프로바이더 정의
// UI 코드에서 category 값을 인자로 전달하여 fetchInitialProducts와 fetchMoreProducts를 호출할 수 있음
final blouseMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 블라우스 컬렉션
  return ProductMainListNotifier(ref, 'a2b');
});

final cardiganMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 가디건 컬렉션
  return ProductMainListNotifier(ref, 'a12b');
});

final coatMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 코트 컬렉션
  return ProductMainListNotifier(ref, 'a11b');
});

final jeanMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 청바지 컬렉션
  return ProductMainListNotifier(ref, 'a8b');
});

final mtmMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 맨투맨 컬렉션
  return ProductMainListNotifier(ref, 'a3b');
});

final neatMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 니트 컬렉션
  return ProductMainListNotifier(ref, 'a4b');
});

final onepieceMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 원피스 컬렉션
  return ProductMainListNotifier(ref, 'a6b');
});

final paedingMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 패딩 컬렉션
  return ProductMainListNotifier(ref, 'a10b');
});

final pantsMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 바지 컬렉션
  return ProductMainListNotifier(ref, 'a7b');
});

final polaMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 폴라티 컬렉션
  return ProductMainListNotifier(ref, 'a5b');
});

final shirtMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 셔츠 컬렉션
  return ProductMainListNotifier(ref, 'a1b');
});

final skirtMainProductListProvider =
    StateNotifierProvider<ProductMainListNotifier, List<ProductContent>>((ref) {
  // 스커트 컬렉션
  return ProductMainListNotifier(ref, 'a9b');
});
// ------- ProductMainListNotifier 클래스 내용 구현 끝
// ------- 2차 메인 화면 (블라우스, 가디건, ~ 스커트) 상품 데이터 불러오고 상태를 관리하는 클래스 (BaseProductListNotifier 추상 클래스를 오버라이드함-기능 상속받는 구조) 끝

// ------- 섹션 더보기 화면 (신상, ~ 겨울)) 상품 데이터 불러오고 상태를 관리하는 클래스 (BaseProductListNotifier 추상 클래스를 오버라이드함-기능 상속받는 구조) 시작
// ------- SectionMoreProductListNotifier 클래스 내용 구현 시작
// BaseProductListNotifier 클래스를 상속받는 SectionMoreProductListNotifier 클래스 정의
class SectionMoreProductListNotifier extends BaseProductListNotifier {
  // 생성자를 정의, ref와 baseCollection을 부모 클래스에 전달
  SectionMoreProductListNotifier(Ref ref, String baseCollection)
      : super(ref, baseCollection);

  // 카테고리에 따른 컬렉션 이름 리스트를 반환하는 메서드 구현
  @override
  List<String> _getCollectionNames(String category) {
    // 카테고리별로 다른 컬렉션 이름 반환 (12개의 서브 컬렉션)
    switch (category) {
      case '신상':
        return List.generate(12, (index) => '${baseCollection}${index + 1}b1');
      case '최고':
        return List.generate(12, (index) => '${baseCollection}${index + 1}b2');
      case '할인':
        return List.generate(12, (index) => '${baseCollection}${index + 1}b3');
      case '봄':
        return List.generate(12, (index) => '${baseCollection}${index + 1}b4');
      case '여름':
        return List.generate(12, (index) => '${baseCollection}${index + 1}b5');
      case '가을':
        return List.generate(12, (index) => '${baseCollection}${index + 1}b6');
      case '겨울':
        return List.generate(12, (index) => '${baseCollection}${index + 1}b7');
      // 기본적으로 신상 컬렉션 반환
      default:
        return List.generate(12, (index) => '${baseCollection}${index + 1}b1');
    }
  }
}

// 섹션 더보기 화면 관련 SectionMoreProductListNotifier 인스턴스를 생성하는 프로바이더 정의
// UI 코드에서 category 값을 인자로 전달하여 fetchInitialProducts와 fetchMoreProducts를 호출할 수 있음
final newSubMainProductListProvider =
    StateNotifierProvider<SectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 신상 섹션
  return SectionMoreProductListNotifier(ref, 'a');
});

final bestSubMainProductListProvider =
    StateNotifierProvider<SectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 최고 섹션
  return SectionMoreProductListNotifier(ref, 'a');
});

final saleSubMainProductListProvider =
    StateNotifierProvider<SectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 할인 섹션
  return SectionMoreProductListNotifier(ref, 'a');
});

final springSubMainProductListProvider =
    StateNotifierProvider<SectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 봄 섹션
  return SectionMoreProductListNotifier(ref, 'a');
});

final summerSubMainProductListProvider =
    StateNotifierProvider<SectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 여름 섹션
  return SectionMoreProductListNotifier(ref, 'a');
});

final autumnSubMainProductListProvider =
    StateNotifierProvider<SectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 가을 섹션
  return SectionMoreProductListNotifier(ref, 'a');
});

final winterSubMainProductListProvider =
    StateNotifierProvider<SectionMoreProductListNotifier, List<ProductContent>>(
        (ref) {
  // 겨울 섹션
  return SectionMoreProductListNotifier(ref, 'a');
});
// ------- SectionMoreProductListNotifier 클래스 내용 구현 끝
// ------- 섹션 더보기 화면 (신상, ~ 겨울)) 상품 데이터 불러오고 상태를 관리하는 클래스 (BaseProductListNotifier 추상 클래스를 오버라이드함-기능 상속받는 구조) 끝
