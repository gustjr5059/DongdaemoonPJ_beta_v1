// // ——— bingo_game_screen.dart 시작 부분
// // 단일 로컬 빙고 게임 화면(UI + 로직)
// // 2025-11-03 lhs
//
// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../model/bingo_model.dart';
//
// // ——— BingoGameScreen 시작 부분
// // 5x5 보드 / “숫자 뽑기” / 자동 표시 / 빙고 줄 카운트 / 5줄 승리
// // 2025-11-03 lhs
// class BingoGameScreen extends StatefulWidget {
//   const BingoGameScreen({super.key});
//
//   @override
//   State<BingoGameScreen> createState() => _BingoGameScreenState();
// }
// // ——— BingoGameScreen 끝 부분
//
// // ——— _BingoGameScreenState 시작 부분
// // 상태 값 및 타이머/랜덤, 라인 카운트/스낵바 출력 관리
// // 2025-11-03 lhs
// class _BingoGameScreenState extends State<BingoGameScreen> {
//   final cfg = const BingoConfig();               // 기본 5x5, 승리 5줄
//   late BingoBoard board;                         // 보드 상태
//   final rnd = Random();                          // 랜덤 인스턴스
//   int? lastDraw;                                 // 마지막에 뽑힌 숫자
//   int lineCount = 0;                             // 현재 빙고 줄 수
//   bool autoMode = false;                         // 자동 뽑기 on/off
//   Timer? autoTimer;                              // 자동 뽑기 타이머
//
//   @override
//   void initState() {
//     super.initState();
//     board = BingoBoard(cfg.size);                // 초기 보드 생성
//   }
//
//   @override
//   void dispose() {
//     autoTimer?.cancel();                         // 타이머 해제
//     super.dispose();
//   }
//
//   // ——— resetGame 시작 부분
//   // 새 보드로 초기화
//   // 2025-11-03 lhs
//   void resetGame() {
//     setState(() {
//       board = BingoBoard(cfg.size);
//       lastDraw = null;
//       lineCount = 0;
//       autoMode = false;
//       autoTimer?.cancel();
//       autoTimer = null;
//     });
//   }
//   // ——— resetGame 끝 부분
//
//   // ——— drawOne 시작 부분
//   // 숫자 1개 뽑고, 보드에 있으면 체크 → 라인 재계산 → 승리 체크
//   // 2025-11-03 lhs
//   void drawOne() {
//     if (lineCount >= cfg.winLines) return; // 이미 승리
//     final n = drawNextNumber(board, rnd);
//     if (n == null) return; // 남은 숫자 없음
//     setState(() {
//       lastDraw = n;
//       board.markIfExists(n);
//       lineCount = board.bingoLines();
//     });
//     // 승리 시 알림
//     if (lineCount >= cfg.winLines && mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('빙고 5줄 달성! 축하해요 🎉')),
//       );
//       setState(() {
//         autoMode = false;
//         autoTimer?.cancel();
//         autoTimer = null;
//       });
//     }
//   }
//   // ——— drawOne 끝 부분
//
//   // ——— toggleAuto 시작 부분
//   // 자동 뽑기 on/off 토글
//   // 2025-11-03 lhs
//   void toggleAuto() {
//     if (autoMode) {
//       setState(() { autoMode = false; });
//       autoTimer?.cancel();
//       autoTimer = null;
//       return;
//     }
//     setState(() { autoMode = true; });
//     autoTimer = Timer.periodic(cfg.drawInterval, (_) {
//       if (!mounted) return;
//       if (lineCount >= cfg.winLines) {
//         toggleAuto(); // 종료
//         return;
//       }
//       drawOne();
//       if (board.remainingDraws.isEmpty) toggleAuto();
//     });
//   }
//   // ——— toggleAuto 끝 부분
//
//   // ——— build 시작 부분
//   // UI 레이아웃: AppBar / 5x5 Grid / 컨트롤 버튼들
//   // 2025-11-03 lhs
//   @override
//   Widget build(BuildContext context) {
//     final size = cfg.size;
//     final cellCount = size * size;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('빙고 게임'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 12),
//           // 상태 표시
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('마지막 숫자: ${lastDraw ?? '-'}',
//                     style: Theme.of(context).textTheme.titleMedium),
//                 Text('빙고 줄: $lineCount/${cfg.winLines}',
//                     style: Theme.of(context).textTheme.titleMedium),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           // 5x5 보드
//           Expanded(
//             child: Center(
//               child: AspectRatio(
//                 aspectRatio: 1,
//                 child: GridView.builder(
//                   padding: const EdgeInsets.all(12),
//                   itemCount: cellCount,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: size,
//                     crossAxisSpacing: 8,
//                     mainAxisSpacing: 8,
//                   ),
//                   itemBuilder: (_, i) {
//                     final n = board.numbers[i];
//                     final checked = board.marked.contains(n);
//                     return _BingoCell(
//                       number: n,
//                       checked: checked,
//                       onTap: () {
//                         // 수동 체크 허용(아케이드 룰 변형) : 셀 탭 시 표시/해제 X
//                         // 여기서는 “룰 고정: 뽑힌 숫자만 자동 체크”
//                         // 필요하다면 토글 허용으로 바꿔도 됨.
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           // 컨트롤 버튼
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: drawOne,
//                     child: const Text('숫자 뽑기'),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: toggleAuto,
//                     child: Text(autoMode ? '자동 멈춤' : '자동 뽑기'),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: resetGame,
//                     child: const Text('초기화'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// // ——— build 끝 부분
// }
// // ——— _BingoGameScreenState 끝 부분
//
// // ——— _BingoCell 시작 부분
// // 단일 셀 위젯: 체크 상태에 따라 색/스타일 변경
// // 2025-11-03 lhs
// class _BingoCell extends StatelessWidget {
//   final int number;          // 표시 숫자
//   final bool checked;        // 체크 여부
//   final VoidCallback? onTap; // 탭 콜백(현재 미사용)
//
//   const _BingoCell({
//     required this.number,
//     required this.checked,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final bg = checked ? const Color(0xFF27AE60) : const Color(0xFFEFEFEF);
//     final tc = checked ? Colors.white : Colors.black87;
//     return Material(
//       color: bg,
//       borderRadius: BorderRadius.circular(12),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: onTap,
//         child: Center(
//           child: Text(
//             '$number',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w800,
//               color: tc,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// // ——— _BingoCell 끝 부분
//
// // ——— bingo_game_screen.dart 끝 부분


// ——— bingo_game_screen.dart 시작 부분
// 단일 로컬 빙고 게임 화면(UI + 로직) — 입력 단계(숫자 세팅) + 게임 진행 단계
// 2025-11-03 lhs

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../model/bingo_model.dart';

// ——— BingoGameScreen 시작 부분
// 5x5 보드 / 각 칸 직접 입력(중복·범위 검증) / 25칸 채우면 ‘게임시작’ 활성화
// 게임 시작 시 3-2-1-START 오버레이 후 1번째 숫자 자동 추첨 → 이후 ‘숫자 뽑기’ 버튼 진행
// 2025-11-03 lhs
class BingoGameScreen extends StatefulWidget {
  const BingoGameScreen({super.key});

  @override
  State<BingoGameScreen> createState() => _BingoGameScreenState();
}
// ——— BingoGameScreen 끝 부분

// ——— _BingoGameScreenState 시작 부분
// 상태 값 및 타이머/랜덤, 카운트다운/스낵바 출력, 입력 다이얼로그 등 관리
// 2025-11-03 lhs
class _BingoGameScreenState extends State<BingoGameScreen> {
  final cfg = const BingoConfig();               // 기본 5x5, 승리 5줄
  late BingoBoard board;                         // 보드 상태
  final rnd = Random();                          // 랜덤 인스턴스

  int? lastDraw;                                 // 마지막에 뽑힌 숫자
  int lineCount = 0;                             // 현재 빙고 줄 수
  int drawCount = 0;                             // 몇 번째 숫자인지(1번째, 2번째, ...)
  bool autoMode = false;                         // 자동 뽑기 on/off
  Timer? autoTimer;                              // 자동 뽑기 타이머
  bool starting = false;                         // 카운트다운 중 여부
  String? countdownText;                         // 3 / 2 / 1 / START 표시 텍스트

  @override
  void initState() {
    super.initState();
    board = BingoBoard(cfg.size);                // 입력 단계 시작(빈 칸)
  }

  @override
  void dispose() {
    autoTimer?.cancel();
    super.dispose();
  }

  // ——— resetGame 시작 부분
  // 새 보드로 초기화 (입력 단계로 돌아감)
  // 2025-11-03 lhs
  void resetGame() {
    setState(() {
      board = BingoBoard(cfg.size);
      lastDraw = null;
      lineCount = 0;
      drawCount = 0;
      autoMode = false;
      autoTimer?.cancel();
      autoTimer = null;
      starting = false;
      countdownText = null;
    });
  }
  // ——— resetGame 끝 부분

  // ——— drawOne 시작 부분
  // 숫자 1개 뽑고, 보드에 있으면 체크 → 라인 재계산 → 승리 체크
  // 2025-11-03 lhs
  void drawOne() {
    if (!board.locked) return;                   // 게임 시작 전에는 불가
    if (lineCount >= cfg.winLines) return;       // 이미 승리
    final n = drawNextNumber(board, rnd);
    if (n == null) return;                       // 남은 숫자 없음

    setState(() {
      lastDraw = n;
      drawCount += 1;                            // “몇 번째 숫자” 증가
      board.markIfExists(n);
      lineCount = board.bingoLines();
    });

    // 승리 시 알림
    if (lineCount >= cfg.winLines && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('빙고 5줄 달성! 축하해요 🎉')),
      );
      setState(() {
        autoMode = false;
        autoTimer?.cancel();
        autoTimer = null;
      });
    }
  }
  // ——— drawOne 끝 부분

  // ——— toggleAuto 시작 부분
  // 자동 뽑기 on/off 토글 (요청 규칙과 충돌하지 않도록 기본은 수동, 원하면 사용)
//  1번째 숫자는 자동으로 뽑히고 이후부터 버튼으로 진행하지만
//  사용자가 원하면 자동 버튼으로 이어서 진행할 수 있게 유지
  // 2025-11-03 lhs
  void toggleAuto() {
    if (!board.locked) return; // 입력 단계에서는 비활성
    if (autoMode) {
      setState(() { autoMode = false; });
      autoTimer?.cancel();
      autoTimer = null;
      return;
    }
    setState(() { autoMode = true; });
    autoTimer = Timer.periodic(cfg.drawInterval, (_) {
      if (!mounted) return;
      if (lineCount >= cfg.winLines) { toggleAuto(); return; }
      drawOne();
      if (board.remainingDraws.isEmpty) toggleAuto();
    });
  }
  // ——— toggleAuto 끝 부분

  // ——— startWithCountdown 시작 부분
  // “게임시작” 클릭 시 3-2-1-START 오버레이 → 1번째 숫자 자동 추첨
  // 2025-11-03 lhs
  Future<void> startWithCountdown() async {
    if (!board.isFilled || board.locked) return;
    setState(() { starting = true; countdownText = '3'; });

    // 카운트다운 표시
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() { countdownText = '2'; });

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() { countdownText = '1'; });

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() { countdownText = 'START'; });

    // 잠깐 보여주기
    await Future.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    // 게임 잠금(입력 배열 → 확정 배열)
    board.lock();

    // 오버레이 제거 + 1번째 숫자 자동 추첨
    setState(() {
      starting = false;
      countdownText = null;
    });

    drawOne(); // 1번째 숫자 자동
  }
  // ——— startWithCountdown 끝 부분

  // ——— onCellTap 시작 부분
  // 셀 탭 시 숫자 입력 다이얼로그(숫자 키보드) → 검증 → 반영
  // 2025-11-03 lhs
  Future<void> onCellTap(int index) async {
    if (board.locked || starting) return; // 게임 시작 이후/카운트다운 중에는 수정 금지

    final value = await _showNumberInputDialog(context,
        title: '숫자 입력 (1~${cfg.size * cfg.size})',
        initial: board.entries[index]?.toString() ?? '');

    if (value == null) return; // 취소

    // 문자열 → 정수 변환
    final parsed = int.tryParse(value.trim());
    if (parsed == null) {
      _toast('숫자를 입력해주세요.');
      return;
    }

    final result = board.setCellValue(index, parsed);
    switch (result) {
      case BingoInputResult.ok:
        setState(() {}); // 화면 갱신
        break;
      case BingoInputResult.outOfRange:
        _toast('1 ~ ${cfg.size * cfg.size} 범위만 입력할 수 있어요.');
        break;
      case BingoInputResult.duplicated:
        _toast('이미 다른 칸에 같은 숫자가 있어요.');
        break;
      case BingoInputResult.locked:
        _toast('이미 게임이 시작되어 수정할 수 없어요.');
        break;
    }
  }
  // ——— onCellTap 끝 부분

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ——— build 시작 부분
  // UI 레이아웃: AppBar / 상태영역 / 5x5 Grid / 컨트롤 + 게임시작 버튼 / 카운트다운 오버레이
  // 2025-11-03 lhs
  @override
  Widget build(BuildContext context) {
    final size = cfg.size;
    final cellCount = size * size;
    final started = board.locked;

    return Scaffold(
      appBar: AppBar(
        title: const Text('빙고 게임'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 12),
              // 상태 표시
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('마지막 숫자: ${lastDraw ?? '-'}',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text('빙고 줄: $lineCount/${cfg.winLines}',
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
              // “n번째 숫자: X” 강조 표시
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Text(
                  (drawCount > 0)
                      ? '${drawCount}번째 숫자: ${lastDraw ?? ''}'
                      : '보드를 채운 뒤 게임을 시작하세요.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              // 5x5 보드
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: cellCount,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: size,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (_, i) {
                        final val = board.locked
                            ? board.numbers[i]                 // 게임 중에는 확정 숫자
                            : board.entries[i];               // 입력 단계: null 가능
                        final checked = started && board.marked.contains(val);
                        return _BingoCell(
                          number: val,
                          checked: checked,
                          dimmed: !started && val == null,   // 입력 전 빈 칸
                          onTap: () => onCellTap(i),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // 컨트롤 버튼
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (started && !starting) ? drawOne : null,
                        child: const Text('숫자 뽑기'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (started && !starting) ? toggleAuto : null,
                        child: Text(autoMode ? '자동 멈춤' : '자동 뽑기'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: (!starting) ? resetGame : null,
                        child: const Text('초기화'),
                      ),
                    ),
                  ],
                ),
              ),
              // 게임시작 버튼 (입력 단계에서만 / 25칸 모두 채워야 활성)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (!started && board.isFilled && !starting)
                        ? startWithCountdown
                        : null,
                    child: const Text('게임시작'),
                  ),
                ),
              ),
            ],
          ),

          // 카운트다운 오버레이
          if (starting || countdownText != null)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.35),
                child: Center(
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 180),
                    scale: 1.0,
                    child: Text(
                      countdownText ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
// ——— build 끝 부분
}
// ——— _BingoGameScreenState 끝 부분

// ——— _BingoCell 시작 부분
// 단일 셀 위젯: 입력 단계(null)면 빈 박스, 게임 단계에서 체크 여부에 따라 색/스타일 변경
// 2025-11-03 lhs
class _BingoCell extends StatelessWidget {
  final int? number;          // 표시 숫자(null=빈 칸)
  final bool checked;         // 체크 여부(게임 단계에서만 의미)
  final bool dimmed;          // 입력 전 빈 칸 스타일
  final VoidCallback? onTap;  // 탭 콜백(입력 단계에서 사용)

  const _BingoCell({
    required this.number,
    required this.checked,
    required this.dimmed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasNumber = number != null;
    final isChecked = checked && hasNumber;

    final bg = isChecked
        ? const Color(0xFF27AE60)               // 체크(초록)
        : (hasNumber ? const Color(0xFFEFEFEF)  // 숫자 존재(회색)
        : const Color(0xFFF4F4F4)); // 비어있음(연회색)

    final tc = isChecked ? Colors.white : Colors.black87;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Center(
          child: hasNumber
              ? Text(
            '$number',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: tc,
            ),
          )
              : Icon(
            Icons.edit,
            color: Colors.black26,
          ),
        ),
      ),
    );
  }
}
// ——— _BingoCell 끝 부분

// ——— _showNumberInputDialog 시작 부분
// 숫자 전용 키보드가 열리는 간단한 입력 다이얼로그
// 2025-11-03 lhs
Future<String?> _showNumberInputDialog(
    BuildContext context, {
      required String title,
      String initial = '',
    }) async {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: '숫자를 입력하세요',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: const Text('입력'),
          ),
        ],
      );
    },
  );
}
// ——— _showNumberInputDialog 끝 부분

// ——— bingo_game_screen.dart 끝 부분
