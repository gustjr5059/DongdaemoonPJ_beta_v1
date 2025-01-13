
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/email_login_and_sign_up_repository.dart';


// 회원가입 Repository Provider인 emailSignUpInfoRepositoryProvider
final emailSignUpInfoRepositoryProvider = Provider<EmailSignUpInfoRepository>((ref) {
  return EmailSignUpInfoRepository();
});