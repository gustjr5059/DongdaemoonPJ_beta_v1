
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 현재 페이지 인덱스를 관리하는 StateProvider(common_parts_layout.dart 내 공통 위젯 내에 구현되는 부분)
final currentPageProvider = StateProvider<int>((ref) => 0);
// onTopBarTap 함수를 상태 관리하기 위한 사용한 StateProvider
final selectedTabIndexProvider = StateProvider<int>((ref) => 0);
// buildCommonBottomNavigationBar 상태 관리를 위한 StateProvider
final tabIndexProvider = StateProvider<int>((ref) => 0);