// ---- 25.11.15 lhs 작업 내용 시작 부분
// ——— AppLocalizations 익스텐션 및 헬퍼 정의 파일 시작 부분
// Flutter 전역에서 context.l10n 으로 다국어 문자열에 접근하기 위함
// 2025-11-15 lhs

import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';


// --- 다국어 기능 구현 관련 각 파일별 로직 설명 내용 시작 부분 - 25.11.15 lhs
// app_en.arb, app_ko.arb인 json 파일을 만들고 나서 Terminal에서 "flutter gen-l10n" 명령어를 입력하면
// app_localizations.dart, app_localizations_en.dart, app_localizations_ko.dart 파일이 자동 생성이 됨
// 해당 3개 파일은 app_en.arb, app_ko.arb인 json 파일 기준으로 자동 생성시키는 파일이므로 새로 프로젝트 받을 때마다 최초 한 번 flutter gen-l10n 을 실행해 줘야 함
// 즉, 해당 3개 파일은 깃허브에 .gitignore로 해서 안올려놓기 때문에 깃허브에서 받는 폴더에는 해당 파일이 없는거임

// features/localization/l10n/app_en.arb : 영어 문구 데이터 (개발자가 직접 작성/수정) (필수 파일)
// features/localization/l10n/app_ko.arb : 한국어 문구 데이터 (개발자가 직접 작성/수정) (필수 파일)
// features/localization/l10n/app_localizations.dart : gen-l10n 이 만드는 메인 로컬라이제이션 클래스 & delegate (필수 파일)
// features/localization/l10n/app_localizations_en.dart : 영어 구현체 (gen-l10n 자동 생성) (필수 파일)
// features/localization/l10n/app_localizations_ko.dart : 한국어 구현체 (gen-l10n 자동 생성) (필수 파일)
// l10n.yaml : 다국어용 Dart 코드(app_localizations.dart)를 어떻게, 어디에 생성할지 알려주는 설정 (필수 파일)
// features/localization/Presentation/app_localizations_extension.dart : context.l10n.xxx 식으로 쓰게 해주는 편의 레이어 (선택 파일이지만 있도록 하기)
// features/localization/Presentation/localization_test_screen.dart : 다국어가 잘 먹는지 확인하는 샘플 UI 화면 (선택 파일)

// 다국어 기능 각 파일별을 사용해서 구현되는 흐름:
// 1. ARB 두 개 (app_en.arb, app_ko.arb)에 “키 이름 – 언어별 문장 데이터”를 작성
// 2. flutter gen-l10n 실행 → app_localizations.dart, app_localizations_en.dart, app_localizations_ko.dart 자동 생성
// 3. main.dart 의 MaterialApp에
// -> localizationsDelegates에 AppLocalizations.delegate와 기본 delegate 들 추가
// -> supportedLocales 에 AppLocalizations.supportedLocales 사용
// 4. View 코드에서 context.l10n.home_title 처럼 사용
// (이때 l10n 은 app_localizations_extension.dart 가 제공)
// 5. iOS / Android 의 시스템 언어가 바뀌면
// → Flutter 가 자동으로 Locale 을 바꿔서
// → AppLocalizationsEn / AppLocalizationsKo 중 하나를 쓰게 됨
// → 같은 코드(context.l10n.home_title) 로도 언어만 깔끔하게 전환
// --- 다국어 기능 구현 관련 각 파일별 로직 설명 내용 끝 부분


/// BuildContext 에 l10n 프로퍼티를 추가해서
/// Swift 의 "key".localized 와 유사하게 사용하도록 하는 익스텐션
extension AppLocalizationContextExtension on BuildContext {
  /// 현재 Locale 에 맞는 AppLocalizations 인스턴스를 반환함
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    return localizations;
  }
}

// ——— AppLocalizations 익스텐션 및 헬퍼 정의 파일 끝 부분
// ---- 25.11.15 lhs 작업 내용 끝 부분
