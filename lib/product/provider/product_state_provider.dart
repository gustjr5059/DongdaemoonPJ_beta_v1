import 'package:flutter_riverpod/flutter_riverpod.dart';

// 색상 선택을 위한 상태 관리용 StateProvider
final colorSelectionIndexProvider = StateProvider<int?>((ref) => null);
// 사이즈 선택을 위한 상태 관리용 StateProvider
final sizeSelectionProvider = StateProvider<String?>((ref) => null);

// 전체 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final allBannerPageProvider = StateProvider<int>((ref) => 0);
// 디테일 상품 화면의 페이지 인덱스를 관리하기 위한 StateProvider
final detailBannerPageProvider = StateProvider<int>((ref) => 0);

