
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 색상 선택을 위한 상태 관리용 StateProvider
final colorProvider = StateProvider<String?>((ref) => null);
// 사이즈 선택을 위한 상태 관리용 StateProvider
final sizeProvider = StateProvider<String?>((ref) => null);