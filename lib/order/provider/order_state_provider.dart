
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 현재 선택된 상단 탭 바 관련 탭의 인덱스 상태 관리를 위한 StateProvider
final orderCurrentTabProvider = StateProvider<int>((ref) => 0);