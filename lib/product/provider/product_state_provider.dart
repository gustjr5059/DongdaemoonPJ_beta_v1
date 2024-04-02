import 'package:flutter_riverpod/flutter_riverpod.dart';

// 색상 선택을 위한 상태 관리용 StateProvider
final colorSelectionIndexProvider = StateProvider<int?>((ref) => null);
// 사이즈 선택을 위한 상태 관리용 StateProvider
final sizeSelectionProvider = StateProvider<String?>((ref) => null);

// 전체 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final allMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 상의 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final topMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 하의 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final bottomMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 아우터 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final outerMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 니트 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final neatMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 원피스 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final onepieceMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 티셔츠 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final shirtMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 블라우스 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final blouseMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 스커트 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final skirtMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 팬츠 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final pantsMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 언더웨어 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final underwearMainBannerPageProvider = StateProvider<int>((ref) => 0);
// 악세서리 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final accessoryMainBannerPageProvider = StateProvider<int>((ref) => 0);

// 전체 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final allDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 상의 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final topDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 하의 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final bottomDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 아우터 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final outerDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 니트 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final neatDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 원피스 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final onepieceDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 티셔츠 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final shirtDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 블라우스 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final blouseDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 스커트 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final skirtDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 팬츠 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final pantsDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 언더웨어 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final underwearDetailBannerPageProvider = StateProvider<int>((ref) => 0);
// 악세서리 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final accessoryDetailBannerPageProvider = StateProvider<int>((ref) => 0);

