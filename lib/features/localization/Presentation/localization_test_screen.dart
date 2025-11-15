import 'package:dongdaemoon_beta_v1/features/localization/Presentation/app_localizations_extension.dart';
import 'package:flutter/material.dart';
// 같은 presentation 폴더 안에 있는 확장 파일이므로 패키지 경로 또는 상대 경로 모두 가능함

// ---- 25.11.15 lhs 작업 내용 시작 부분
// ——— LocalizationTestScreen 시작 부분
// 다국어 처리 테스트를 위해 사용하는 샘플 화면
// 2025-11-15 lhs
class LocalizationTestScreen extends StatelessWidget {
  const LocalizationTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // iOS 의 "home_title".localized 와 동일 개념으로,
        // 현재 Locale 에 맞는 홈 타이틀 문자열을 표시함
        title: Text(context.l10n.home_title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 클릭 시 별도 동작은 없고,
            // 다국어 문자열이 잘 바인딩되는지만 확인하는 용도
          },
          // 현재 Locale 에 맞는 버튼 문구를 표시함
          child: Text(context.l10n.navigate_to_home_btn),
        ),
      ),
    );
  }
}
// ——— LocalizationTestScreen 끝 부분
// ---- 25.11.15 lhs 작업 내용 끝 부분
