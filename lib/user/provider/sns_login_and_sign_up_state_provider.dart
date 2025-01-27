
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
  final String? signUpName;      // 신규 회원의 이름
  final String? errorMessage;    // 에러 메시지

  GoogleSignInState({
    this.isLoading = false,
    this.isLoginSuccess = false,
    this.isSignUpNeeded = false,
    this.signUpEmail,
    this.signUpName,
    this.errorMessage,
  });

  GoogleSignInState copyWith({
    bool? isLoading,
    bool? isLoginSuccess,
    bool? isSignUpNeeded,
    String? signUpEmail,
    String? signUpName,
    String? errorMessage,
  }) {
    return GoogleSignInState(
      isLoading: isLoading ?? this.isLoading,
      isLoginSuccess: isLoginSuccess ?? this.isLoginSuccess,
      isSignUpNeeded: isSignUpNeeded ?? this.isSignUpNeeded,
      signUpEmail: signUpEmail ?? this.signUpEmail,
      signUpName: signUpName ?? this.signUpName,
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
  final String? signUpId;       // 신규 회원의 아이디
  final String? signUpEmail;   // 네이버 계정 email
  final String? signUpName;    // 네이버 계정 name
  final String? errorMessage;   // 에러 메시지

  NaverSignInState({
    this.isLoading = false,
    this.isLoginSuccess = false,
    this.isSignUpNeeded = false,
    this.signUpId,
    this.signUpEmail,
    this.signUpName,
    this.errorMessage,
  });

  NaverSignInState copyWith({
    bool? isLoading,
    bool? isLoginSuccess,
    bool? isSignUpNeeded,
    String? signUpId,
    String? signUpEmail,
    String? signUpName,
    String? errorMessage,
  }) {
    return NaverSignInState(
      isLoading: isLoading ?? this.isLoading,
      isLoginSuccess: isLoginSuccess ?? this.isLoginSuccess,
      isSignUpNeeded: isSignUpNeeded ?? this.isSignUpNeeded,
      signUpId: signUpId ?? this.signUpId,
      signUpEmail: signUpEmail ?? this.signUpEmail,
      signUpName: signUpName ?? this.signUpName,
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
          // signUpEmail: user.email ?? '',
          // AppleSignInResultModel에서 가져온 이메일, fullName 저장
          signUpEmail: signInResult.signUpEmail ?? '',
          signUpFullName: signInResult.signUpFullName ?? '',
        );
      }
    } catch (e) {
      final errorMsg = e.toString();
      print('AppleSignInNotifier 에러: $errorMsg');

      // 'secessionUser'인지 분기
      if (errorMsg.contains('secessionUser')) {
        // → EasyLoginIosScreen에서 AlertDialog
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'secessionUser',
        );
      } else {
        // 일반 오류
        state = state.copyWith(
          isLoading: false,
          errorMessage: '로그인 실패: $errorMsg',
        );
      }
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
          signUpName: signInResult.name ?? '',
        );
      }
    } catch (e) {
      final errorMsg = e.toString();
      print('GoogleSignInNotifier 에러: $errorMsg');

      // 'secessionUser'인지 분기
      if (errorMsg.contains('secessionUser')) {
        // → EasyLoginAosScreen에서 AlertDialog
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'secessionUser',
        );
      } else {
        // 일반 오류
        state = state.copyWith(
          isLoading: false,
          errorMessage: '로그인 실패: $errorMsg',
        );
      }
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
      // ↑ 여기서 만약 '탈퇴 5분 내 계정'이라면
      //   repository.signInWithNaver() 내부에서 `throw Exception('secessionUser');`
      //   로 넘어올 것이고, 아래 catch에서 잡힙니다.

      // logIn()에서 null을 리턴한 경우(로그인 실패/취소 등)
      if (result == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '네이버 로그인 실패 또는 취소되었습니다.',
        );
        return;
      }

      // 해당 로직은 파이어베이스 권한 내 사용자 UID 정보와 'users' 컬렉션 하위에 문서명 일치 여부로
      // UI 구현 로직 내 회원정보 조회하는 곳에 사용하기 위한 로직
      // 기존 회원
      if (result.isExistingUser) {
        state = state.copyWith(isLoading: false, isLoginSuccess: true);
      }
      // 신규 회원
      else {
        state = state.copyWith(
          isLoading: false,
          isSignUpNeeded: true,
          signUpId: result.userCredential.user?.uid, // UID 전달 (signUpEmail 변수명은 그대로 사용해서 기존 UI로직을 활용)
          signUpEmail: result.email ?? '',
          signUpName: result.name ?? '',
        );
      }

    } catch (e) {
      // 여기서 'secessionUser' 인지, 일반 오류인지 분기
      final errorMsg = e.toString();
      print('NaverSignInNotifier 에러: $errorMsg');

      // 만약 'secessionUser'라면 state.errorMessage 값을 특정 문자열로 저장
      if (errorMsg.contains('secessionUser')) {
        // UI에서 AlertDialog로 안내
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'secessionUser',
        );
      } else {
        // 일반 오류
        state = state.copyWith(
          isLoading: false,
          errorMessage: '네이버 로그인 중 오류 발생: $errorMsg',
        );
      }
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
