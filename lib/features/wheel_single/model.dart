// --- models.dart 시작 부분
// 돌림판 게임의 도메인 모델 정의 파일
// 2025-11-03 lhs

import 'package:flutter/material.dart';

// 섹션(라벨/가중치/색상) 정의 – 확률 제어는 weight 비율로 처리
class WheelSection {
  final String label;   // 표시 문구
  final double weight;  // 가중치(확률 비율)
  final Color color;    // 배경 색상

  const WheelSection({
    required this.label,
    required this.weight,
    required this.color,
  });
}

// 돌림판 구성(제목/섹션들)
class WheelConfig {
  final String title;                 // 화면 타이틀
  final List<WheelSection> sections;  // 섹션 리스트

  const WheelConfig({
    required this.title,
    required this.sections,
  });
}
// --- models.dart 끝 부분
