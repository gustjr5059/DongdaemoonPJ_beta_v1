
import 'package:dongdaemoon_beta_v1/user/provider/user_info_modify_and_secession_all_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/user_info_modify_and_secession_repository.dart';


// ——— 회원정보 수정 및 탈퇴 화면에서 화면 자체 스크롤로 이동한 위치를 저장하는 StateProvider 시작 부분
// 화면에서 사용자가 스크롤한 위치를 저장함
final userInfoModifyAndSecessionScrollPositionProvider = StateProvider<double>((ref) => 0);
// ——— 회원정보 수정 및 탈퇴 화면에서 화면 자체 스크롤로 이동한 위치를 저장하는 StateProvider 끝 부분

// -------- user_info_modify_and_secession_screen.dart 관련 ScrollControllerProvider 시작
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 userInfoModifyAndSecessionScrollControllerProvider라는 이름의 Provider를 정의함.
final userInfoModifyAndSecessionScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 함.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  print('ScrollController가 생성되었습니다.'); // 디버깅 메시지
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});
// -------- user_info_modify_and_secession_screen.dart 관련 ScrollControllerProvider 끝

// ------ 회원정보 수정 부분 데이터를 불러오고 상태관리 하는 로직 관련 UserInfoModifyNotifier 시작 부분( 1) StateNotifier 정의)
// Firestore에서 특정 유저의 정보를 불러오고 업데이트를 관리하는 StateNotifier
class UserInfoModifyNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final UserInfoModifyRepository repository;
  UserInfoModifyNotifier(this.repository) : super(const AsyncValue.loading());

  // --- Firestore에서 특정 유저의 정보를 불러오는 메서드 시작
  // Firestore에서 email로 유저 정보를 가져오는 함수
  Future<void> fetchUserInfo(String email) async {
    // 로딩 상태로 갱신함
    state = const AsyncValue.loading();
    try {
      // Firestore에서 유저 데이터를 가져옴
      final userInfo = await repository.modifyGetUserInfoByEmail(email);
      print('유저 정보를 성공적으로 불러왔습니다: $userInfo'); // 디버깅 메시지
      // 데이터를 성공적으로 가져왔다면 data로 상태 업데이트
      state = AsyncValue.data(userInfo);
    } catch (e, st) {
      // 에러가 발생하면 error 상태로 업데이트
      print('유저 정보 불러오기에 실패했습니다: $e'); // 디버깅 메시지
      state = AsyncValue.error(e, st);
    }
  }

  // --- Firestore에 유저 정보를 업데이트하는 메서드 시작
  // Firestore에 유저 정보를 업데이트하는 함수
  Future<void> updateUserInfo({
    required String email,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      // Firestore에서 유저 정보를 업데이트함
      await repository.updateUserInfo(email, updatedData);
      print('유저 정보를 성공적으로 업데이트했습니다.'); // 디버깅 메시지

      // 업데이트 후 최신 상태로 갱신하기 위해 fetchUserInfo 호출
      await fetchUserInfo(email);
    } catch (e) {
      print('유저 정보 업데이트에 실패했습니다: $e'); // 디버깅 메시지
      rethrow;
    }
  }
}
// ------ 회원정보 수정 부분 데이터를 불러오고 상태관리 하는 로직 관련 UserInfoModifyNotifier 끝 부분

// UserInfoModifyNotifier 인스턴스를 제공하는 프로바이더
final userInfoModifyNotifierProvider =
StateNotifierProvider<UserInfoModifyNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  final repository = ref.watch(userInfoModifyRepositoryProvider);
  return UserInfoModifyNotifier(repository);
});

// ------- 회원 탈퇴 부분 데이터 처리 로직을 불러오고 상태관리 하는 로직 관련 UserSecessionNotifier 시작 부분
// Firestore를 통해 회원 탈퇴 데이터를 처리하는 StateNotifier
class UserSecessionNotifier extends StateNotifier<AsyncValue<void>> {
  final UserSecessionRepository repository;

  UserSecessionNotifier(this.repository) : super(const AsyncValue.data(null));

  // --- 회원 탈퇴를 처리하는 메서드 시작
  Future<void> secessionUser(String userEmail) async {
    // 1) 로딩 상태로 변경
    state = const AsyncValue.loading();

    try {
      // 2) 레포지토리의 회원 탈퇴 로직 실행
      await repository.secessionUser(userEmail);
      print('회원 탈퇴가 성공적으로 처리되었습니다: $userEmail'); // 디버깅 메시지

      // 3) 문제 없이 완료되면 상태를 성공으로 업데이트
      state = const AsyncValue.data(null);
    } catch (e, st) {
      // 4) 오류 발생 시 상태를 에러로 변경
      print('회원 탈퇴 중 오류가 발생했습니다: $e'); // 디버깅 메시지
      state = AsyncValue.error(e, st);
    }
  }
// --- 회원 탈퇴를 처리하는 메서드 끝
}
// ------- 회원 탈퇴 부분 데이터 처리 로직을 불러오고 상태관리 하는 로직 관련 UserSecessionNotifier 끝 부분

// UserSecessionNotifier 인스턴스를 제공하는 프로바이더
final userSecessionNotifierProvider =
StateNotifierProvider<UserSecessionNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(userSecessionRepositoryProvider);
  return UserSecessionNotifier(repo);
});
