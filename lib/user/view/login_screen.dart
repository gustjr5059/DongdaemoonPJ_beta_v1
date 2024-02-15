
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common/component/custom_text_form_field.dart';
import '../../common/const/colors.dart';
import '../../home/view/home_screen.dart';




class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth 객체 초기화
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  String username = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {
        // 텍스트 필드에 포커스가 있을 때 키보드가 활성화되도록 함
      }
    });
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        // 텍스트 필드에 포커스가 있을 때 키보드가 활성화되도록 함
      }
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                const SizedBox(height: 16.0),
                _SubTitle(),
                Image.asset(
                  'asset/img/misc/main_image.jpg',
                  width: MediaQuery.of(context).size.width / 2 * 3,
                ),
                const SizedBox(height: 12.0),
                CustomTextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode, // FocusNode 할당
                  hintText: '이메일을 입력해주세요.',
                  keyboardType: TextInputType.emailAddress, // Keyboard type for email input
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                const SizedBox(height: 12.0),
                CustomTextFormField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  hintText: '비밀번호를 입력해주세요.',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  child: Text('로그인'),
                  onPressed: () async {
                    try {
                      // 이메일과 비밀번호를 사용하여 Firebase에서 로그인 시도
                      await _auth.signInWithEmailAndPassword(
                        email: username, // username을 이용해 이메일 전달
                        password: password, // password를 이용해 비밀번호 전달
                      );
                      // 로그인 성공 후 처리, 예를 들어 다음 페이지로 이동
                      Navigator.of(context).pushReplacement(
                        // MainScreen : 여기에 메인 화면 뷰를 넣어줘야 함
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } on FirebaseAuthException catch (e) {
                      // 로그인 실패 시 처리, 예를 들어 사용자에게 오류 메시지 표시
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("로그인 실패: ${e.message}"),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: BUTTON_COLOR, // 버튼 색상 설정
                    onPrimary: Colors.white, // 텍스트 색상 설정
                  ),
                ),
                  // 회원가입 버튼
                  // 기존 TextButton 대신 ElevatedButton 사용
                ElevatedButton(
                  child: Text('회원가입'),
                  onPressed: () async {
                    try {
                      // Firebase에서 이메일과 비밀번호로 사용자 생성 시도
                      await _auth.createUserWithEmailAndPassword(
                        email: username, // username을 이용해 이메일 전달
                        password: password, // password를 이용해 비밀번호 전달
                      );
                      // 회원가입 성공 후 처리, 예를 들어 로그인 페이지로 이동
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    } on FirebaseAuthException catch (e) {
                      // 회원가입 실패 시 알림 메시지 표시
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("회원가입 실패: ${e.message}"),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: BUTTON_COLOR, // 버튼 색상 설정
                    onPrimary: Colors.white, // 텍스트 색상 설정
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
   );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Dongdaemoon Shop 🛍️',
      textAlign: TextAlign.center, // 텍스트를 중앙 정렬
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '오늘도 나만의 옷을 PICK!!\n 이메일과 비밀번호를 입력해서 로그인 해주세요! :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
