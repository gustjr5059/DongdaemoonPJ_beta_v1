import 'package:flutter/material.dart';

import '../domain/model/on_boarding_page.dart';
import '../theme/app_text_style.dart';
import '../utils/device_size_scaler.dart';


/// 온보딩 개별 페이지 UI (Presentation/View 레이어)
///
/// SwiftUI의 OnBoardingContentsView.swift와 동일한 역할을 합니다.
/// OnBoardingPage 모델을 받아 화면에 표시하는 역할만 수행합니다.

// --- 변경된 내용 시작 부분 - 25.11.16 lhs
class OnBoardingContentsScreen extends StatelessWidget {
  // 임포트된 OnBoardingPage enum 타입을 참조합니다.
  final OnBoardingPage onBoardingPage;

  const OnBoardingContentsScreen({
    Key? key,
    required this.onBoardingPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold: Material Design의 기본 구조를 제공하며, 흰색 배경을 보장합니다.
    return Scaffold(
      // 목표 이미지(image_9ec48d.jpg)와 같이 배경을 흰색으로 명시
      backgroundColor: Colors.white,

      // SafeArea: 상태표시줄, 노치 등을 피해 콘텐츠를 안전한 영역에 배치합니다.
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Text(
                onBoardingPage.title1, // 모델 데이터 사용
                style: AppTextStyle.body4_m,
                textAlign: TextAlign.center,
              ),
              Text(
                onBoardingPage.title2, // 모델 데이터 사용
                style: AppTextStyle.h1,
                textAlign: TextAlign.center,
              ),

              // DeviceSizeScaler.onBoardingView1Y는 이제 32.0을 의미
              const SizedBox(height: DeviceSizeScaler.onBoardingView1Y),
              // const SizedBox(height: DeviceSizeScaler.onBoardingView6Y),

              // Expanded를 사용하여 남은 공간을 모두 차지하도록 함
              Expanded(
                child: Image.asset(
                  onBoardingPage.image, // 모델 데이터 사용
                  // .scaledToFit()과 동일한 효과
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// --- 변경된 내용 끝 부분