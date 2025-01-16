
import 'package:dongdaemoon_beta_v1/user/provider/sns_login_and_sign_up_all_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/sns_login_and_sign_up_repository.dart';


// ------ AppleSignInState: Apple 로그인 상태를 표현하기 위한 State 클래스 시작 부분
// Apple 로그인 상태를 표현하는 클래스
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
// ------ AppleSignInState: Apple 로그인 상태를 표현하기 위한 State 클래스 끝 부분

// ------ GoogleSignInState: 구글 로그인 상태를 표현하기 위한 State 클래스 시작 부분
// 구글 로그인 시 상태를 표현하는 클래스
class GoogleSignInState {
  final bool isLoading;          // 로딩 중 여부
  final bool isLoginSuccess;     // 로그인 성공 여부 (기존 회원)
  final bool isSignUpNeeded;     // 신규 회원 가입 필요 여부
  final String? signUpEmail;     // 신규 회원의 이메일
  final String? errorMessage;    // 에러 메시지

  GoogleSignInState({
    this.isLoading = false,
    this.isLoginSuccess = false,
    this.isSignUpNeeded = false,
    this.signUpEmail,
    this.errorMessage,
  });

  GoogleSignInState copyWith({
    bool? isLoading,
    bool? isLoginSuccess,
    bool? isSignUpNeeded,
    String? signUpEmail,
    String? errorMessage,
  }) {
    return GoogleSignInState(
      isLoading: isLoading ?? this.isLoading,
      isLoginSuccess: isLoginSuccess ?? this.isLoginSuccess,
      isSignUpNeeded: isSignUpNeeded ?? this.isSignUpNeeded,
      signUpEmail: signUpEmail ?? this.signUpEmail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
// ------ GoogleSignInState: 구글 로그인 상태를 표현하기 위한 State 클래스 끝 부분

// ------ NaverSignInState: 네이버 로그인 상태를 표현하기 위한 State 클래스 시작 부분
class NaverSignInState {
  final bool isLoading;         // 로딩중 여부
  final bool isLoginSuccess;    // 기존 회원 로그인 성공 여부
  final bool isSignUpNeeded;    // 신규 회원 가입 필요 여부
  final String? signUpEmail;    // 신규 회원의 이메일
  final String? errorMessage;   // 에러 메시지

  NaverSignInState({
    this.isLoading = false,
    this.isLoginSuccess = false,
    this.isSignUpNeeded = false,
    this.signUpEmail,
    this.errorMessage,
  });

  NaverSignInState copyWith({
    bool? isLoading,
    bool? isLoginSuccess,
    bool? isSignUpNeeded,
    String? signUpEmail,
    String? errorMessage,
  }) {
    return NaverSignInState(
      isLoading: isLoading ?? this.isLoading,
      isLoginSuccess: isLoginSuccess ?? this.isLoginSuccess,
      isSignUpNeeded: isSignUpNeeded ?? this.isSignUpNeeded,
      signUpEmail: signUpEmail ?? this.signUpEmail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ------ NaverSignInState: 네이버 로그인 상태를 표현하기 위한 State 클래스 끝 부분

// ------ AppleSignInNotifier: 실제 Apple 로그인을 수행하고 상태를 업데이트하는 로직 시작 부분
// --- Apple 로그인 Notifier 클래스 시작 부분
// Apple 로그인 프로세스를 실행하고 상태를 관리하는 클래스
class AppleSignInNotifier extends StateNotifier<AppleSignInState> {
  final SNSLoginRepository repository;

  AppleSignInNotifier(this.repository) : super(AppleSignInState());

  // --- Apple 로그인 메서드 시작 부분
  // Apple 로그인을 처리하고 결과에 따라 상태를 업데이트함
  Future<void> signInWithApple() async {
    if (state.isLoading) return; // 로딩 중인 경우 중복 호출 방지
    try {
      // 로딩 상태로 업데이트
      print('Apple 로그인 시작. 로딩 상태 활성화.');
      state = state.copyWith(isLoading: true, errorMessage: '');

      // Apple 로그인 처리 시작
      final signInResult = await repository.signInWithApple();
      print('Apple 로그인 결과: $signInResult');

      // if (signInResult == null) {
      //   // 로그인 실패 처리
      //   print('Apple 로그인 실패.');
      //   state = state.copyWith(
      //     isLoading: false,
      //     errorMessage: '로그인 중 문제가 발생했습니다. 다시 시도해주세요.',
      //   );
      //   return;
      // }

      if (signInResult == null) {
        // Apple 로그인 취소 시 처리 없음
        print('Apple 로그인이 취소되었습니다.');
        state = state.copyWith(isLoading: false);
        return;
      }

      // 로그인 성공 여부 확인
      final userCredential = signInResult.userCredential;
      final isExistingUser = signInResult.isExistingUser;
      final User? user = userCredential.user;

      if (user == null) {
        throw Exception('사용자 인증 정보가 없습니다.'); // 디버깅용 메시지
      }

      if (isExistingUser) {
        // 기존 회원 로그인 성공 처리
        print('기존 회원 로그인 성공. 메인 화면으로 이동 준비.');
        state = state.copyWith(
          isLoading: false,
          isLoginSuccess: true,
        );
      } else {
        // 신규 회원 처리
        print('신규 회원 로그인. 추가 회원가입 필요.');
        state = state.copyWith(
          isLoading: false,
          isSignUpNeeded: true,
          signUpEmail: user.email ?? '',
        );
      }
    } catch (e) {
      // 에러 처리
      print('Apple 로그인 중 오류 발생: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그인 실패: $e',
      );
    }
  }

  // 초기화 로직
  void resetState() {
    print('애플 로그인 상태 초기화.');
    state = AppleSignInState();
  }
}
// ------ AppleSignInNotifier: 실제 Apple 로그인을 수행하고 상태를 업데이트하는 로직 끝 부분

// --- AppleSignInNotifier 관련 Provider 시작 부분
// AppleSignInNotifier의 Provider 설정
final appleSignInNotifierProvider =
StateNotifierProvider<AppleSignInNotifier, AppleSignInState>((ref) {
  final repository = ref.watch(snsLoginRepositoryProvider);
  return AppleSignInNotifier(repository);
});
// --- AppleSignInNotifier 관련 Provider 끝 부분

// ------ GoogleSignInNotifier: 실제 구글 로그인을 수행하고 상태를 업데이트하는 로직 시작 부분
// --- Google 로그인 Notifier 클래스 시작 부분
// Google 로그인 프로세스를 실행하고 상태를 관리하는 클래스
class GoogleSignInNotifier extends StateNotifier<GoogleSignInState> {
  final SNSLoginRepository repository;

  GoogleSignInNotifier(this.repository) : super(GoogleSignInState());

  // --- Google 로그인 메서드 시작 부분
  // Google 로그인을 처리하고 결과에 따라 상태를 업데이트함
  Future<void> signInWithGoogle() async {
    if (state.isLoading) return; // 로딩 중인 경우 중복 호출 방지
    try {
      // 로딩 상태로 업데이트
      print('Google 로그인 시작. 로딩 상태 활성화.');
      state = state.copyWith(isLoading: true, errorMessage: '');

      // Google 로그인 처리 시작
      final signInResult = await repository.signInWithGoogle();
      print('Google 로그인 결과: $signInResult');

      // if (signInResult == null) {
      //   // 로그인 실패 처리
      //   print('Google 로그인 실패.');
      //   state = state.copyWith(
      //     isLoading: false,
      //     errorMessage: '로그인에 실패하였습니다. 다시 시도해주세요.',
      //   );
      //   return;
      // }

      if (signInResult == null) {
        // Google 로그인 취소 처리
        print('Google 로그인이 취소되었습니다.');
        state = state.copyWith(isLoading: false);
        return;
      }

      // 로그인 성공 여부 확인
      final userCredential = signInResult.userCredential;
      final isExistingUser = signInResult.isExistingUser;
      final User? user = userCredential.user;

      if (user == null) {
        throw Exception('사용자 인증 정보가 없습니다.'); // 디버깅용 메시지
      }

      if (isExistingUser) {
        // 기존 회원 로그인 성공 처리
        print('기존 회원 로그인 성공. 메인 화면으로 이동 준비.');
        state = state.copyWith(
          isLoading: false,
          isLoginSuccess: true,
        );
      } else {
        // 신규 회원 처리
        print('신규 회원 로그인. 추가 회원가입 필요.');
        state = state.copyWith(
          isLoading: false,
          isSignUpNeeded: true,
          signUpEmail: user.email ?? '',
        );
      }
    } catch (e) {
      // 에러 처리
      print('Google 로그인 중 오류 발생: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그인 실패: $e',
      );
    }
  }

  // 초기화 로직
  void resetState() {
    print('Google 로그인 상태 초기화.');
    state = GoogleSignInState();
  }
}
// ------ GoogleSignInNotifier: 실제 구글 로그인을 수행하고 상태를 업데이트하는 로직 끝 부분

// --- GoogleSignInNotifier 관련 Provider 시작 부분
// GoogleSignInNotifier의 Provider 설정
final googleSignInNotifierProvider =
StateNotifierProvider<GoogleSignInNotifier, GoogleSignInState>((ref) {
  final repository = ref.watch(snsLoginRepositoryProvider);
  return GoogleSignInNotifier(repository);
});
// --- GoogleSignInNotifier 관련 Provider 끝 부분

// ------ NaverSignInNotifier: 실제 네이버 로그인을 수행하고 상태를 업데이트하는 로직 시작 부분
class NaverSignInNotifier extends StateNotifier<NaverSignInState> {
  final SNSLoginRepository repository;

  NaverSignInNotifier(this.repository) : super(NaverSignInState());

  Future<void> signInWithNaver() async {
    if (state.isLoading) return;

    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final result = await repository.signInWithNaver();

      // logIn()에서 null을 리턴한 경우(로그인 실패/취소 등)
      if (result == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '네이버 로그인 실패 또는 취소되었습니다.',
        );
        return;
      }

      // 기존 회원
      if (result.isExistingUser) {
        state = state.copyWith(isLoading: false, isLoginSuccess: true);
      }
      // 신규 회원
      else {
        state = state.copyWith(isLoading: false, isSignUpNeeded: true);
      }

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '네이버 로그인 중 오류 발생: $e',
      );
    }
  }

  // 상태 초기화 로직
  void resetState() {
    print('네이버 로그인 상태 초기화.');
    state = NaverSignInState();
  }
}
// ------ NaverSignInNotifier: 실제 네이버 로그인을 수행하고 상태를 업데이트하는 로직 끝 부분

// --- NaverSignInNotifier 관련 Provider 시작 부분
// NaverSignInNotifier의 Provider 설정
final naverSignInNotifierProvider =
StateNotifierProvider<NaverSignInNotifier, NaverSignInState>((ref) {
  final repository = ref.read(snsLoginRepositoryProvider);
  return NaverSignInNotifier(repository);
});
// --- NaverSignInNotifier 관련 Provider 끝 부분
