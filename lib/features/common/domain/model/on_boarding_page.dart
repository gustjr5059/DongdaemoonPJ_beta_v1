/// 온보딩 페이지 종류를 정의하는 열거형 (domain/model 레이어)
///
/// SwiftUI의 OnBoardingPage.swift enum과 동일한 역할을 합니다.
/// UI와 데이터를 분리하여 재사용성을 높입니다.

// --- 변경된 내용 시작 부분 - 25.11.16 lhs
enum OnBoardingPage {
  // --- 페이지 케이스 정의 ---
  page1,
  page2,
  page3;

  /// SwiftUI의 CaseIterable과 동일한 기능을 제공합니다.
  static const List<OnBoardingPage> allCases = [
    OnBoardingPage.page1,
    OnBoardingPage.page2,
    OnBoardingPage.page3,
  ];

  /// 이미지 에셋 이름
  /// 참고: 실제 프로젝트의 이미지 경로에 맞게 수정해야 합니다.
  /// (예: "asset/img/onboarding/onboarding_main_img_1.png")
  String get image {
    switch (this) {
      case OnBoardingPage.page1:
        return "asset/img/misc/splash_image/wearcano_splash1_bg_img.png";
      case OnBoardingPage.page2:
        return "asset/img/misc/splash_image/wearcano_splash1_bg_img.png";
      case OnBoardingPage.page3:
        return "asset/img/misc/splash_image/wearcano_splash1_bg_img.png";
    }
  }

  /// 타이틀 1줄째
  String get title1 {
    switch (this) {
      case OnBoardingPage.page1:
        return "필요한 정보를";
      case OnBoardingPage.page2:
        return "1분 만에 끝나는";
      case OnBoardingPage.page3:
        return "결제하는 순간";
    }
  }

  /// 타이틀 2줄째
  String get title2 {
    switch (this) {
      case OnBoardingPage.page1:
        return "한 눈에!";
      case OnBoardingPage.page2:
        return "쉽고 빠른 결제";
      case OnBoardingPage.page3:
        return "쌓이는 혜택!";
    }
  }
}
// --- 변경된 내용 끝 부분