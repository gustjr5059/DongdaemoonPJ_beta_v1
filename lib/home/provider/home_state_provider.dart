
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 티셔츠 카테고리 화면의 배너 페이지 인덱스를 관리하기 위한 StateProvider
final homeMainBannerPageProvider = StateProvider<int>((ref) => 0);