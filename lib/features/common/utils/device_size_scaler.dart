
import 'package:flutter/widgets.dart';

/// 디바이스의 화면 정보를 제공하고, 레이아웃에 사용되는 공통 상수를 정의합니다.
/// [중요] 사용 전, main.dart 등 앱 시작점에서 'DeviceSizeScaler.init(context)'를 1회 호출해야 합니다.

// --- 변경된 내용 시작 부분 - 25.11.16 lhs
class DeviceSizeScaler {
  // --- 기준 디바이스 사이즈 (참고용) ---
  static const double referenceWidth = 375.0;
  static const double referenceHeight = 812.0;

  // --- 현재 기기의 화면 사이즈 ---
  static late Size _screenSize;
  static late double _widthRatio;
  static late double _heightRatio;

  /// 앱 시작 시 1회 호출되어야 하는 초기화 함수
  static void init(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _widthRatio = _screenSize.width / referenceWidth;
    _heightRatio = _screenSize.height / referenceHeight;
  }

  // --- 화면 정보 프로퍼티 ---
  /// 기준 너비 대비 현재 화면 비율 (고급 반응형 로직용)
  static double get widthRatio => _widthRatio;

  /// 기준 높이 대비 현재 화면 비율 (고급 반응형 로직용)
  static double get heightRatio => _heightRatio;

  /// 현재 화면 사이즈 (고급 반응형 로직용)
  static Size get screenSize => _screenSize;

  // ---- OnBoardingView 관련 공통 상수 (절대값) ----
  // Swift 코드와 동일하게, 비율 스케일링이 아닌 절대값(논리적 픽셀)을 사용합니다.
  static const double onBoardingView1Y = 32.0;
  static const double onBoardingView2Y = 43.0;
  static const double onBoardingView3Y = 24.0;
  static const double onBoardingView4Y = 16.0;
  static const double onBoardingView5Y = 52.0;
  static const double onBoardingView6Y = 8.0;

  static const double onBoardingView1X = 16.0;
// ---- OnBoardingView 관련 수치 끝 부분 ----
}
// --- 변경된 내용 띀 부분