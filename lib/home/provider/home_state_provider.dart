
// Riverpod는 Flutter에서 사용할 수 있는 현대적이고 강력한 상태 관리 라이브러리입니다.
// 이 라이브러리를 통해 개발자는 애플리케이션의 상태를 보다 효율적으로 관리할 수 있습니다.
// Riverpod는 기존의 Provider 패키지를 개선하여 더 유연하고, 테스트가 용이하며,
// 강력한 타입 안정성을 제공하는 기능을 갖추고 있습니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';


// 홈 화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final homeLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 홈 화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final homeSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 홈 화면의 작은 배너2 페이지 인덱스를 관리하기 위한 StateProvider
final homeSmall2BannerPageProvider = StateProvider<int>((ref) => 0);
// 홈 화면의 작은 배너3 페이지 인덱스를 관리하기 위한 StateProvider
final homeSmall3BannerPageProvider = StateProvider<int>((ref) => 0);
// 홈 화면에서 각 상단 탭 바 관련 섹션의 스크롤 위치를 저장하는 StateProvider
final scrollPositionProvider = StateProvider<double>((ref) => 0);