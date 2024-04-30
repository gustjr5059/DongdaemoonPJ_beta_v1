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

// // 티셔츠 카테고리 버튼 클릭 인덱스를 관리하기 위한 StateProvider
// final shirtSelectedCategoryProvider = StateProvider<int?>((ref) => 0);
// // 블라우스 카테고리 버튼 클릭 인덱스를 관리하기 위한 StateProvider
// final blouseSelectedCategoryProvider = StateProvider<int?>((ref) => 0);
// // 맨투맨 카테고리 버튼 클릭 인덱스를 관리하기 위한 StateProvider
// final mtmSelectedCategoryProvider = StateProvider<int?>((ref) => 0);
// // 니트 카테고리 버튼 클릭 인덱스를 관리하기 위한 StateProvider
// final neatSelectedCategoryProvider = StateProvider<int?>((ref) => 0);
// // 폴라티 카테고리 버튼 클릭 인덱스를 관리하기 위한 StateProvider
// final polaSelectedCategoryProvider = StateProvider<int?>((ref) => 0);
// // 원피스 카테고리 버튼 클릭 인덱스를 관리하기 위한 StateProvider
// final onepieceSelectedCategoryProvider = StateProvider<int?>((ref) => 0);
// // 팬츠 카테고리 버튼 클릭 인덱스를 관리하기 위한 StateProvider
// final pantsSelectedCategoryProvider = StateProvider<int?>((ref) => 0);
// // 청바지 카테고리 버튼 클릭 인덱스를 관리하기 위한 StateProvider
// final jeanSelectedCategoryProvider = StateProvider<int?>((ref) => 0);
// // 스커트 카테고리 버튼 클릭 인덱스를 관리하기 위한 StateProvider
// final skirtSelectedCategoryProvider = StateProvider<int?>((ref) => 0);
// // 패딩 카테고리 버튼 클릭 인덱스를 관리하기 위한 StateProvider
// final paedingSelectedCategoryProvider = StateProvider<int?>((ref) => 0);
// // 코트 카테고리 버튼 클릭 인덱스를 관리하기 위한 StateProvider
// final coatSelectedCategoryProvider = StateProvider<int?>((ref) => 0);
// // 가디건 카테고리 버튼 클릭 인덱스를 관리하기 위한 StateProvider
// final cardiganSelectedCategoryProvider = StateProvider<int?>((ref) => 0);
