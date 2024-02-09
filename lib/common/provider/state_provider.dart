import 'package:flutter_riverpod/flutter_riverpod.dart';

// 상태 관리를 위한 StateProvider 정의
final currentPageProvider = StateProvider<int>((ref) => 0);
