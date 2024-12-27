
import 'package:dongdaemoon_beta_v1/user/provider/sns_login_all_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/sns_login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';


// AppleSignInState: Apple 로그인 상태를 표현하기 위한 State 클래스
class AppleSignInState {
  final bool isLoading;         // 로딩중 여부
  final bool isLoginSuccess;    // 기존회원 로그인 성공 여부
  final bool isSignUpNeeded;    // 신규회원 가입 필요 여부
  final String? signUpEmail;    // 신규회원의 이메일
  final String? signUpFullName; // 신규회원의 이름
  final String? errorMessage;   // 에러 메시지

  AppleSignInState({
    this.isLoading = false,
    this.isLoginSuccess = false,
    this.isSignUpNeeded = false,
    this.signUpEmail,
    this.signUpFullName,
    this.errorMessage,
  });

  AppleSignInState copyWith({
    bool? isLoading,
    bool? isLoginSuccess,
    bool? isSignUpNeeded,
    String? signUpEmail,
    String? signUpFullName,
    String? errorMessage,
  }) {
    return AppleSignInState(
      isLoading: isLoading ?? this.isLoading,
      isLoginSuccess: isLoginSuccess ?? this.isLoginSuccess,
      isSignUpNeeded: isSignUpNeeded ?? this.isSignUpNeeded,
      signUpEmail: signUpEmail ?? this.signUpEmail,
      signUpFullName: signUpFullName ?? this.signUpFullName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// AppleSignInNotifier: 실제 Apple 로그인을 수행하고 상태를 업데이트
class AppleSignInNotifier extends StateNotifier<AppleSignInState> {
  final SNSLoginRepository repository;

  AppleSignInNotifier(this.repository) : super(AppleSignInState());

  // Apple 로그인 메서드
  Future<void> signInWithApple() async {
    if (state.isLoading) return; // 로딩 중이면 중복 호출 방지
    try {
      // 로딩 시작
      state = state.copyWith(isLoading: true, errorMessage: '');

      // repository를 통해 실제 Apple 로그인 처리
      final signInResult = await repository.signInWithApple();

      if (signInResult == null) {
        // 로그인 결과가 없으면 실패
        state = state.copyWith(
          isLoading: false,
          errorMessage: '로그인 중 문제가 발생했습니다. 다시 시도해주세요.',
        );
        return;
      }

      // userCredential, isExistingUser, fullName을 반환받았다고 가정
      final userCredential = signInResult.userCredential;
      final isExistingUser = signInResult.isExistingUser;
      final fullName = signInResult.fullName;

      final User? user = userCredential.user;
      if (user == null) {
        throw Exception('사용자 인증 정보가 없습니다.');
      }

      // 기존 회원
      if (isExistingUser) {
        // 로그인 성공, 메인화면으로 이동
        state = state.copyWith(
          isLoading: false,
          isLoginSuccess: true,
        );
      } else {
        // 신규 회원
        state = state.copyWith(
          isLoading: false,
          isSignUpNeeded: true,
          signUpEmail: user.email ?? '',
          signUpFullName: fullName,
        );
      }
    } catch (e) {
      // 에러 처리
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그인 실패: $e',
      );
    }
  }
}

// Apple 로그인 Provider
final appleSignInNotifierProvider =
StateNotifierProvider<AppleSignInNotifier, AppleSignInState>((ref) {
  // SNSLoginRepository를 주입받아 Notifier 생성
  final repository = ref.watch(snsLoginRepositoryProvider);
  return AppleSignInNotifier(repository);
});