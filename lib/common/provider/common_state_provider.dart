// Riverpod는 Flutter에서 사용할 수 있는 현대적이고 강력한 상태 관리 라이브러리입니다.
// 이 라이브러리는 앱의 상태를 전역적으로 관리할 수 있게 해주며, 앱 내에서 필요한 데이터의 흐름과 상태 변화를
// 효율적으로 관리할 수 있도록 설계되어 있습니다.
// Riverpod는 Provider 패키지의 기능을 확장하며, 더 유연하고 테스트하기 쉬운 코드를 작성할 수 있게 해 줍니다.
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
final midCategoryViewBoolExpandedProvider =
    StateProvider<bool>((ref) => false); // 기본값은 축소된 상태
// 현재 선택된 상단 탭 바 관련 탭의 인덱스 상태 관리를 위한 StateProvider
final currentTabProvider = StateProvider<int>((ref) => 0);

// 데이터를 로딩할 때 사용되는 로딩 상태를 관리하는 공통 StateProvider
final isLoadingProvider = StateProvider<bool>((ref) => false);
