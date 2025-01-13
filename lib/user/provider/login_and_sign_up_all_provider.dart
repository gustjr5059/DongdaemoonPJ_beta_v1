
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/login_and_sign_up_repository.dart';


// 회원가입 Repository Provider인 signUpInfoRepositoryProvider
final signUpInfoRepositoryProvider = Provider<SignUpInfoRepository>((ref) {
  return SignUpInfoRepository();
});