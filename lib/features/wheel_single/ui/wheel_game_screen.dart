// --- wheel_game_screen.dart 시작 부분
// 돌림판 싱글 게임 메인 화면
// 2025-11-03 lhs

import 'package:flutter/material.dart';
import '../model.dart';
import '../widgets/spinning_wheel.dart';

class WheelGameScreen extends StatefulWidget {
  const WheelGameScreen({super.key});

  @override
  State<WheelGameScreen> createState() => _WheelGameScreenState();
}

class _WheelGameScreenState extends State<WheelGameScreen> {
  // 기본 섹션 구성(원하시면 colors/라벨/가중치만 바꾸면 됨)
  final _config = const WheelConfig(
    title: '돌림판 게임',
    sections: [
      WheelSection(label: '꽝',       weight: 1.0, color: Color(0xFFE74C3C)),
      WheelSection(label: '음료 1잔',   weight: 2.0, color: Color(0xFF27AE60)),
      WheelSection(label: '사탕',     weight: 1.5, color: Color(0xFF2980B9)),
      WheelSection(label: '기프티콘',   weight: 1.0, color: Color(0xFF8E44AD)),
      WheelSection(label: '쿠폰',     weight: 1.5, color: Color(0xFFF39C12)),
      WheelSection(label: '럭키!',     weight: 0.8, color: Color(0xFF16A085)),
    ],
  );

  String? _resultText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_config.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 화면 중앙에 ‘정확히’ 배치
          Expanded(
            child: Center(
            // 돌림판 위젯 – 터치하면 회전
              child: SpinningWheel(
                config: _config,
                onEnd: (section) {
                  setState(() => _resultText = '결과: ${section.label}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(_resultText!)),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _resultText ?? '돌림판을 터치하면 돌기 시작합니다.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          // (선택) 다시하기 버튼
          TextButton(
            onPressed: () => setState(() => _resultText = null),
            child: const Text('결과 초기화'),
          ),
        ],
      ),
    );
  }
}
// --- wheel_game_screen.dart 끝 부분
