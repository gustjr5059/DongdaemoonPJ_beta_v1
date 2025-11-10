// --- spinning_wheel.dart 시작 부분
// 회전 애니메이션 + 그리기(CustomPainter) + 터치 스핀 로직
// 2025-11-03 lhs

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model.dart';

class SpinningWheel extends StatefulWidget {
  final WheelConfig config;                        // 돌림판 구성
  final Duration duration;                         // 회전 시간
  final void Function(WheelSection result)? onEnd; // 회전 종료 콜백

  const SpinningWheel({
    super.key,
    required this.config,
    this.duration = const Duration(milliseconds: 5200),
    this.onEnd,
  });

  @override
  State<SpinningWheel> createState() => _SpinningWheelState();
}

class _SpinningWheelState extends State<SpinningWheel>
    with SingleTickerProviderStateMixin {
  // —— 내부 상태
  late AnimationController _ctrl;   // [0..1] 컨트롤러
  late Animation<double> _spin;     // 0→end(곡선) 진행각
  double _base = 0;                 // 누적 기준각(라디안) — 마지막 멈춘 각도(회전값 φ)
  double _startBase = 0;            // 이번 스핀 시작 시점의 기준각
  double _end = 0;                  // 이번 스핀 총 진행각
  bool _spinning = false;

  // —— 포인터(다트)가 가리키는 절대 방향: 윗쪽(12시) = -π/2
  static const double _pointerDir = -pi / 2;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _spin = _ctrl.drive(Tween<double>(begin: 0.0, end: 0.0));

    // 완료 시: 기준각 갱신 + 결과 계산
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        // 최종 회전값(φ) = 시작각 + 진행각
        _base = (_startBase + _end) % (2 * pi);

        // 포인터가 가리키는 섹션의 "섹터 좌표(θ)" = ψ(포인터) - φ(회전값)
        final thetaAtPointer = _normalize(_pointerDir - _base);
        final idx = _indexAtAngle(widget.config, thetaAtPointer);

        _spinning = false;
        HapticFeedback.selectionClick();
        widget.onEnd?.call(widget.config.sections[idx]);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // —— 유틸
  double _normalize(double a) {
    a %= 2 * pi;
    if (a < 0) a += 2 * pi;
    return a;
  }

  // 터치 시 회전 시작
  void spin() {
    if (_spinning) return;
    _spinning = true;

    _startBase = _base; // 이번 스핀 시작 기준각 고정

    // 1) 가중치 기반 섹션 랜덤
    final idx = _randomIndexByWeight(widget.config.sections);

    // 2) 섹션 중앙 각도(섹터 좌표 θ)
    final center = _centerAngle(widget.config, idx);

    // 3) “섹션 중앙이 포인터 위쪽(ψ)”에 오도록 해야 하므로
    //    목표 회전값(φ_target) = ψ - θ
    final targetRotation = _normalize(_pointerDir - center);

    // 4) 여유 회전(6바퀴) + 현재 회전값(φ = _startBase)에서 목표(φ_target)까지 최소 전진
    _end = (6 * pi) + _deltaToTarget(targetRotation, _startBase);

    // 5) 애니메이션 세팅/시작
    _ctrl.reset();
    final animatable = Tween<double>(begin: 0.0, end: _end)
        .chain(CurveTween(curve: Curves.decelerate));
    setState(() {
      _spin = _ctrl.drive(animatable);
    });
    _ctrl.forward();
  }

  // 가중치 랜덤 인덱스 선택
  int _randomIndexByWeight(List<WheelSection> list) {
    final total = list.fold<double>(0, (s, e) => s + e.weight);
    final r = Random().nextDouble() * total;
    double acc = 0;
    for (int i = 0; i < list.length; i++) {
      acc += list[i].weight;
      if (r <= acc) return i;
    }
    return list.length - 1;
  }

  // 섹션 중앙 각도(라디안, 섹터 좌표 θ)
  double _centerAngle(WheelConfig cfg, int idx) {
    final (st, en) = _angles(cfg)[idx];
    return (st + en) / 2;
  }

  // 섹션별 시작/끝 각도 리스트(섹터 좌표)
  List<(double, double)> _angles(WheelConfig cfg) {
    final total = cfg.sections.fold<double>(0, (s, e) => s + e.weight);
    double acc = 0;
    final res = <(double, double)>[];
    for (final s in cfg.sections) {
      final st = acc / total * 2 * pi;
      final en = (acc + s.weight) / total * 2 * pi;
      res.add((st, en));
      acc += s.weight;
    }
    return res;
  }

  // 현재 회전값(base=φ)에서 목표 회전값(target=φ_target)까지의 최소 전진량(0~2π)
  double _deltaToTarget(double target, double base) {
    double d = (target - (base % (2 * pi))) % (2 * pi);
    if (d < 0) d += 2 * pi;
    return d;
  }

  // 각도(섹터 좌표 θ) → 섹션 인덱스
  int _indexAtAngle(WheelConfig cfg, double angle) {
    final list = _angles(cfg);
    for (int i = 0; i < list.length; i++) {
      final (st, en) = list[i];
      var inRange = st <= angle && angle < en;
      // 랩 구간 보정
      if (st > en) inRange = !(en <= angle && angle < st);
      if (inRange) return i;
    }
    return list.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: spin,
      child: AnimatedBuilder(
        animation: _spin,
        builder: (_, __) {
          // 화면에 그릴 각도 = 이번 스핀 시작각 + 진행각  (회전값 φ)
          final angle = _startBase + _spin.value;

          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size.square(320),
                painter: _WheelPainter(cfg: widget.config, angle: angle),
              ),
              const Positioned(top: 8, child: _Pointer()),
            ],
          );
        },
      ),
    );
  }
}

// 섹션/텍스트/테두리/중심점 그리기
class _WheelPainter extends CustomPainter {
  final WheelConfig cfg;
  final double angle;

  const _WheelPainter({required this.cfg, required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    canvas.translate(r, r);
    canvas.rotate(angle); // 회전값 φ 반영

    final total = cfg.sections.fold<double>(0, (s, e) => s + e.weight);
    final rect = Rect.fromCircle(center: Offset.zero, radius: r);
    final fill = Paint()..style = PaintingStyle.fill;

    double acc = 0;
    for (final s in cfg.sections) {
      final start = acc / total * 2 * pi;           // 섹터 좌표 시작각(θ)
      final sweep = s.weight / total * 2 * pi;

      // 섹션 면
      fill.color = s.color;
      canvas.drawArc(rect, start, sweep, true, fill);

      // 라벨
      final tp = TextPainter(
        text: TextSpan(
          text: s.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: r * .8);

      final theta = start + sweep / 2;
      final off = Offset(
        cos(theta) * (r * .58) - tp.width / 2,
        sin(theta) * (r * .58) - tp.height / 2,
      );
      canvas.save();
      canvas.translate(off.dx, off.dy);
      tp.paint(canvas, Offset.zero);
      canvas.restore();

      acc += s.weight;
    }

    // 외곽선/중심점
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = Colors.black12,
    );
    canvas.drawCircle(Offset.zero, 16, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _WheelPainter old) =>
      old.angle != angle || old.cfg != cfg;
}

// 삼각형 포인터(다트)
class _Pointer extends StatelessWidget {
  const _Pointer();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(24, 34), painter: _PointerPainter());
  }
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(p, Paint()..color = Colors.black87);
    canvas.drawCircle(
      Offset(size.width / 2, size.height - 2),
      2,
      Paint()..color = Colors.redAccent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
// --- spinning_wheel.dart 끝 부분
