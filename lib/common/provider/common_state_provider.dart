
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 현재 페이지 인덱스를 관리하는 StateProvider(common_body_parts_layout.dart 내 공통 위젯 내에 구현되는 부분)
final currentPageProvider = StateProvider<int>((ref) => 0);
// onTopBarTap 함수를 상태 관리하기 위한 사용한 StateProvider
final selectedTabIndexProvider = StateProvider<int>((ref) => 0);
// buildCommonBottomNavigationBar 상태 관리를 위한 StateProvider
final tabIndexProvider = StateProvider<int>((ref) => 0);
// 선택된 중간 카테고리 버튼의 인덱스 상태 관리를 위한 StateProvider
final selectedMidCategoryProvider = StateProvider<int>((ref) => 0);
// 중간 카테고리 버튼의 열 수를 확장/축소하여 보이는 상태 관리를 위한 StateProvider
final midCategoryViewBoolExpandedProvider = StateProvider<bool>((ref) => false); // 기본값은 축소된 상태