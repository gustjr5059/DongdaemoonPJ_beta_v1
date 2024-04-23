
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 홈 화면의 큰 배너 페이지 인덱스를 관리하기 위한 StateProvider
final homeLargeBannerPageProvider = StateProvider<int>((ref) => 0);
// 홈 화면의 작은 배너1 페이지 인덱스를 관리하기 위한 StateProvider
final homeSmall1BannerPageProvider = StateProvider<int>((ref) => 0);
// 홈 화면의 작은 배너2 페이지 인덱스를 관리하기 위한 StateProvider
final homeSmall2BannerPageProvider = StateProvider<int>((ref) => 0);
// 홈 화면의 작은 배너3 페이지 인덱스를 관리하기 위한 StateProvider
final homeSmall3BannerPageProvider = StateProvider<int>((ref) => 0);