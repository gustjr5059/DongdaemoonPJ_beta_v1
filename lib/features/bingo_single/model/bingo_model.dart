// // ——— bingo_model.dart 시작 부분
// // 빙고 게임 도메인 모델 및 유틸 정의
// // 2025-11-03 lhs
//
// import 'dart:math';
//
// // ——— BingoConfig 시작 부분
// // 보드 크기 등 기본 설정 값 정의
// // 2025-11-03 lhs
// class BingoConfig {
//   final int size;                 // 보드 한 변 길이(기본 5)
//   final int winLines;             // 승리로 간주할 빙고 줄 수(기본 5)
//   final Duration drawInterval;    // 자동 뽑기 간격
//   const BingoConfig({
//     this.size = 5,
//     this.winLines = 5,
//     this.drawInterval = const Duration(milliseconds: 600),
//   });
// }
// // ——— BingoConfig 끝 부분
//
// // ——— BingoBoard 시작 부분
// // 1..(size*size) 값을 셔플하여 보드 구성 및 체크 상태를 관리
// // 2025-11-03 lhs
// class BingoBoard {
//   final int size;
//   late final List<int> numbers;     // 셔플된 번호 25개
//   final Set<int> marked = {};       // 체크된 숫자 집합
//   final Set<int> drawn = {};        // 이미 뽑힌 숫자(중복 방지)
//
//   BingoBoard(this.size) {
//     final total = size * size;
//     numbers = List<int>.generate(total, (i) => i + 1)..shuffle(Random());
//   }
//
//   // 번호를 체크(있으면 mark)하고 true/false 반환
//   bool markIfExists(int n) {
//     if (numbers.contains(n)) {
//       marked.add(n);
//       return true;
//     }
//     return false;
//   }
//
//   // 남은 뽑기 후보(아직 안 뽑은 숫자)
//   List<int> get remainingDraws {
//     final total = size * size;
//     final all = List<int>.generate(total, (i) => i + 1);
//     return all.where((e) => !drawn.contains(e)).toList();
//   }
//
//   // 빙고 줄 계산(가로/세로/대각)
// //  완전 단순한 규칙: 한 줄이 모두 marked면 1줄
//   int bingoLines() {
//     int lines = 0;
//     // 가로
//     for (int r = 0; r < size; r++) {
//       bool ok = true;
//       for (int c = 0; c < size; c++) {
//         final n = numbers[r * size + c];
//         if (!marked.contains(n)) { ok = false; break; }
//       }
//       if (ok) lines++;
//     }
//     // 세로
//     for (int c = 0; c < size; c++) {
//       bool ok = true;
//       for (int r = 0; r < size; r++) {
//         final n = numbers[r * size + c];
//         if (!marked.contains(n)) { ok = false; break; }
//       }
//       if (ok) lines++;
//     }
//     // 대각(좌상-우하)
//     bool diag1 = true;
//     for (int i = 0; i < size; i++) {
//       final n = numbers[i * size + i];
//       if (!marked.contains(n)) { diag1 = false; break; }
//     }
//     if (diag1) lines++;
//
//     // 대각(우상-좌하)
//     bool diag2 = true;
//     for (int i = 0; i < size; i++) {
//       final n = numbers[i * size + (size - 1 - i)];
//       if (!marked.contains(n)) { diag2 = false; break; }
//     }
//     if (diag2) lines++;
//
//     return lines;
//   }
// }
// // ——— BingoBoard 끝 부분
//
// // ——— drawNextNumber 시작 부분
// // 남은 숫자 중 하나를 랜덤으로 뽑아 반환, 없으면 null
// // 2025-11-03 lhs
// int? drawNextNumber(BingoBoard board, Random rnd) {
//   final remains = board.remainingDraws;
//   if (remains.isEmpty) return null;
//   final pick = remains[rnd.nextInt(remains.length)];
//   board.drawn.add(pick);
//   return pick;
// }
// // ——— drawNextNumber 끝 부분
//
// // ——— bingo_model.dart 끝 부분



// ——— bingo_model.dart 시작 부분
// 빙고 게임 도메인 모델 및 유틸 정의 (입력 단계 + 게임 단계)
// 2025-11-03 lhs

import 'dart:math';

// ——— BingoConfig 시작 부분
// 보드 크기 등 기본 설정 값 정의
// 2025-11-03 lhs
class BingoConfig {
  final int size;                 // 보드 한 변 길이(기본 5)
  final int winLines;             // 승리로 간주할 빙고 줄 수(기본 5)
  final Duration drawInterval;    // 자동 뽑기 간격
  const BingoConfig({
    this.size = 5,
    this.winLines = 5,
    this.drawInterval = const Duration(milliseconds: 600),
  });
}
// ——— BingoConfig 끝 부분

// ——— BingoInputResult 시작 부분
// 셀 입력 결과 구분용 enum
// 2025-11-03 lhs
enum BingoInputResult {
  ok,            // 정상 입력
  locked,        // 이미 게임 시작됨(입력 불가)
  outOfRange,    // 범위(1..N) 위반
  duplicated,    // 중복 숫자
}
// ——— BingoInputResult 끝 부분

// ——— BingoBoard 시작 부분
// 입력 단계: entries(List<int?>)에 유저 입력 저장 (중복/범위 검증)
// 게임 시작: lock() 호출로 numbers(List<int>) 확정 → 이후부터 마킹/빙고 계산
// 2025-11-03 lhs
class BingoBoard {
  final int size;

  // 입력 단계 저장소(칸별 값) – 게임 시작 전까지 null 허용
  final List<int?> entries;

  // 입력된 숫자 집합(중복 방지)
  final Set<int> usedNumbers = {};

  // 게임 진행용 확정 배열(입력 완료 후 lock 시 생성)
  List<int> numbers = const [];

  // 체크/추첨 상태
  final Set<int> marked = {};    // 체크된 숫자
  final Set<int> drawn = {};     // 이미 뽑은 숫자

  // 상태
  bool locked = false;           // 게임 시작(잠금) 여부

  BingoBoard(this.size) : entries = List<int?>.filled(size * size, null, growable: false);

  // —— 입력: index 위치에 값 설정 (검증 포함)
  BingoInputResult setCellValue(int index, int value) {
    if (locked) return BingoInputResult.locked;
    final max = size * size;
    if (value < 1 || value > max) return BingoInputResult.outOfRange;
    // 이미 다른 칸에 존재하면 중복
    if (usedNumbers.contains(value) && entries[index] != value) {
      return BingoInputResult.duplicated;
    }

    // 기존 값 있으면 집합에서 제거
    final prev = entries[index];
    if (prev != null) {
      usedNumbers.remove(prev);
    }

    // 새 값 반영
    entries[index] = value;
    usedNumbers.add(value);
    return BingoInputResult.ok;
  }

  // —— 입력 완료 여부(모든 칸 채움)
  bool get isFilled => entries.every((e) => e != null);

  // —— 게임 잠금: 입력 배열 → 확정 배열(numbers)로 전환
  void lock() {
    if (locked) return;
    if (!isFilled) return;
    numbers = entries.cast<int>().toList(growable: false);
    locked = true;
  }

  // —— 남은 뽑기 후보(아직 안 뽑은 숫자)
  List<int> get remainingDraws {
    final total = size * size;
    final all = List<int>.generate(total, (i) => i + 1);
    return all.where((e) => !drawn.contains(e)).toList();
  }

  // —— 번호 존재 시 체크
  bool markIfExists(int n) {
    if (!locked) return false;
    if (numbers.contains(n)) {
      marked.add(n);
      return true;
    }
    return false;
  }

  // —— 빙고 줄 계산(가로/세로/대각)
  int bingoLines() {
    if (!locked) return 0;
    int lines = 0;

    // 가로
    for (int r = 0; r < size; r++) {
      bool ok = true;
      for (int c = 0; c < size; c++) {
        final n = numbers[r * size + c];
        if (!marked.contains(n)) { ok = false; break; }
      }
      if (ok) lines++;
    }

    // 세로
    for (int c = 0; c < size; c++) {
      bool ok = true;
      for (int r = 0; r < size; r++) {
        final n = numbers[r * size + c];
        if (!marked.contains(n)) { ok = false; break; }
      }
      if (ok) lines++;
    }

    // 대각(좌상-우하)
    bool diag1 = true;
    for (int i = 0; i < size; i++) {
      final n = numbers[i * size + i];
      if (!marked.contains(n)) { diag1 = false; break; }
    }
    if (diag1) lines++;

    // 대각(우상-좌하)
    bool diag2 = true;
    for (int i = 0; i < size; i++) {
      final n = numbers[i * size + (size - 1 - i)];
      if (!marked.contains(n)) { diag2 = false; break; }
    }
    if (diag2) lines++;

    return lines;
  }
}
// ——— BingoBoard 끝 부분

// ——— drawNextNumber 시작 부분
// 남은 숫자 중 하나를 랜덤으로 뽑아 반환, 없으면 null
// 2025-11-03 lhs
int? drawNextNumber(BingoBoard board, Random rnd) {
  final remains = board.remainingDraws;
  if (remains.isEmpty) return null;
  final pick = remains[rnd.nextInt(remains.length)];
  board.drawn.add(pick);
  return pick;
}
// ——— drawNextNumber 끝 부분

// ——— bingo_model.dart 끝 부분
