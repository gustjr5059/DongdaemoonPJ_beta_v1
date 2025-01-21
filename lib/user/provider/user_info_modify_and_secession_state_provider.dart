
import 'package:dongdaemoon_beta_v1/user/provider/user_info_modify_and_secession_all_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/user_info_modify_and_secession_repository.dart';


// 회원정보 수정 및 탈퇴 화면에서 화면 자체 스크롤로 이동한 위치를 저장하는 StateProvider
final userInfoModifyAndSecessionScrollPositionProvider = StateProvider<double>((ref) => 0);

// -------- user_info_modify_and_secession_screen.dart 관련 ScrollControllerProvider 시작
// ScrollController를 프로바이더로 추가하는 코드
// 이 코드는 userInfoModifyAndSecessionScrollControllerProvider라는 이름의 Provider를 정의함.
final userInfoModifyAndSecessionScrollControllerProvider = Provider<ScrollController>((ref) {
  // ScrollController 객체를 생성함.
  final scrollController = ScrollController();
  // ref.onDispose 메서드를 사용하여 프로바이더가 해제될 때 ScrollController의 dispose 메서드가 호출되도록 함.
  // 이것은 메모리 누수를 방지하고 자원을 적절하게 해제하기 위함.
  ref.onDispose(scrollController.dispose);
  // 생성된 ScrollController 객체를 반환함.
  return scrollController;
});
// -------- user_info_modify_and_secession_screen.dart 관련 ScrollControllerProvider 끝

// ------ 회원정보 수정 부분 데이터를 불러오고 상태관리 하는 로직 관련 UserInfoModifyNotifier 시작 부분( 1) StateNotifier 정의)
class UserInfoModifyNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final UserInfoModifyRepository repository;
  UserInfoModifyNotifier(this.repository) : super(const AsyncValue.loading());

  // --- Firestore에서 특정 유저의 정보를 불러오는 메서드
  Future<void> fetchUserInfo(String email) async {
    // 로딩 상태로 갱신
    state = const AsyncValue.loading();
    try {
      final userInfo = await repository.modifyGetUserInfoByEmail(email);
      // 데이터를 성공적으로 가져왔다면 data로 상태 업데이트
      state = AsyncValue.data(userInfo);
    } catch (e, st) {
      // 에러가 나면 error 상태로
      state = AsyncValue.error(e, st);
    }
  }

  // --- Firestore에 유저 정보를 업데이트하는 메서드
  Future<void> updateUserInfo({
    required String email,
    required Map<String, dynamic> updatedData,
  }) async {
    // 우선 업데이트 시도
    await repository.updateUserInfo(email, updatedData);

    // 업데이트 후 다시 fetchUserInfo 호출하여 최신 상태로 갱신
    await fetchUserInfo(email);
  }
}
// ------ 회원정보 수정 부분 데이터를 불러오고 상태관리 하는 로직 관련 UserInfoModifyNotifier 끝 부분

// 2) 위 Notifier를 제공하는 Provider
//   - 보통 family를 써서 email을 받기도 하지만,
//     여기서는 '현재 로그인한 유저' 등 맥락에 따라 자유롭게 작성하시면 됩니다.
final userInfoModifyNotifierProvider =
StateNotifierProvider<UserInfoModifyNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  final repository = ref.watch(userInfoModifyRepositoryProvider);
  return UserInfoModifyNotifier(repository);
});

