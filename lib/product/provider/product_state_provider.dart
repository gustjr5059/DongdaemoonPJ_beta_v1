
// Riverpod 라이브러리를 임포트합니다.
// 이 라이브러리는 상태 관리를 위한 강력하고 유연한 프레임워크로, 애플리케이션의 다양한 상태를 관리하는데 도움을 줍니다.
// Riverpod는 기존 Provider 라이브러리를 기반으로 하여 더욱 발전된 기능을 제공하며,
// 각종 상태 관리 요구 사항을 보다 세밀하고 효과적으로 다룰 수 있도록 설계되었습니다.
// 이를 통해 앱의 상태를 전역적으로 또는 로컬적으로 제어하고, 상태 변화에 따라 UI를 자동으로 업데이트하는 구조를 구현할 수 있습니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';


// 티셔츠 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final shirtMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 블라우스 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final blouseMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 맨투맨 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final mtmMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 니트 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final neatMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 폴라티 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final polaMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 원피스 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final onepieceMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 팬츠 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final pantsMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 청바지 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final jeanMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 스커트 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final skirtMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 패딩 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final paedingMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 코트 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final coatMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 가디건 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final cardiganMainBannerPageProvider = StateProvider<int>((ref) => 0);

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
