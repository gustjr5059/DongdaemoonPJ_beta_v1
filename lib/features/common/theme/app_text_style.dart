
import 'package:flutter/material.dart';

/// Figma 텍스트 스타일을 코드로 매핑한 공통 텍스트 스타일 클래스

// --- 변경된 내용 시작 부분 - 25.11.16 lhs
class AppTextStyle {
  /// 앱 전역에서 사용할 폰트 패밀리 이름 (pubspec.yaml과 일치해야 함)
  static const String _fontFamily = "Pretendard";

  /// 텍스트 스타일을 생성하는 내부 헬퍼 함수
  /// (size, weight, lineRatio, kerning)
  static TextStyle _spec({
    required double size, // size(Flutter의 논리적 픽셀)
    required FontWeight weight,
    required double lineRatio,
    required double kerning,
    Color color = const Color(0xFF212529), // .grey900 (SwiftUI)
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: size,         // size
      fontWeight: weight,     // weight
      height: lineRatio,      // lineRatio (line-height = fontSize * height)
      letterSpacing: kerning,  // kerning (자간)
      color: color,           // 기본 색상
    );
  }

  // --- 제목 스타일 정의 ---
  static final TextStyle h1 = _spec(size: 24, weight: FontWeight.w700, lineRatio: 1.5, kerning: -0.83); // .bold
  static final TextStyle h2 = _spec(size: 22, weight: FontWeight.w700, lineRatio: 1.5, kerning: -0.83); // .bold
  static final TextStyle h3 = _spec(size: 20, weight: FontWeight.w700, lineRatio: 1.5, kerning: -0.83); // .bold
  static final TextStyle h4 = _spec(size: 18, weight: FontWeight.w700, lineRatio: 1.5, kerning: -0.83); // .bold
  static final TextStyle h5 = _spec(size: 18, weight: FontWeight.w600, lineRatio: 1.5, kerning: -0.83); // .semibold
  static final TextStyle h1_m = _spec(size: 24, weight: FontWeight.w500, lineRatio: 1.5, kerning: -0.83); // .medium
  static final TextStyle h6 = _spec(size: 32, weight: FontWeight.w700, lineRatio: 1.4, kerning: -0.83); // .bold

  // --- 본문 스타일 정의 ---
  static final TextStyle body1_b = _spec(size: 16, weight: FontWeight.w700, lineRatio: 1.4, kerning: -0.83); // .bold
  static final TextStyle body1_m = _spec(size: 16, weight: FontWeight.w500, lineRatio: 1.4, kerning: -0.83); // .medium
  static final TextStyle body1_r = _spec(size: 16, weight: FontWeight.w400, lineRatio: 1.4, kerning: -0.83); // .regular

  static final TextStyle body2_m = _spec(size: 15, weight: FontWeight.w500, lineRatio: 1.4, kerning: -0.83); // .medium
  static final TextStyle body2_r = _spec(size: 15, weight: FontWeight.w400, lineRatio: 1.4, kerning: -0.83); // .regular

  static final TextStyle body3_m = _spec(size: 14, weight: FontWeight.w500, lineRatio: 1.4, kerning: -0.83); // .medium
  static final TextStyle body3_r = _spec(size: 14, weight: FontWeight.w400, lineRatio: 1.4, kerning: -0.83); // .regular

  static final TextStyle body4_m = _spec(size: 13, weight: FontWeight.w500, lineRatio: 1.4, kerning: -0.83); // .medium
  static final TextStyle body4_r = _spec(size: 13, weight: FontWeight.w400, lineRatio: 1.4, kerning: -0.83); // .regular

  // --- 캡션 및 내비게이션 스타일 정의 ---
  static final TextStyle caption = _spec(size: 12, weight: FontWeight.w400, lineRatio: 1.4, kerning: -0.83); // .regular
  static final TextStyle nav = _spec(size: 13, weight: FontWeight.w600, lineRatio: 1.4, kerning: -0.83); // .semibold

  // --- 숫자 전용 스타일 정의 ---
  static final TextStyle number = _spec(size: 30, weight: FontWeight.w700, lineRatio: 1.5, kerning: -0.83); // .bold
  static final TextStyle number_pad = _spec(size: 26, weight: FontWeight.w400, lineRatio: 1.4, kerning: 0); // .regular
}
// --- 변경된 내용 끝 부분