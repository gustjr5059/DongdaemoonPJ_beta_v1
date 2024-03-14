
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common/component/custom_text_form_field.dart';
import '../../common/const/colors.dart';
import '../../common/provider/state_provider.dart';
import '../../home/view/home_screen.dart';



// 로그인 화면을 위한 StatefulWidget 정의
class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login'; // 라우트 이름 정의

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth 인스턴스(객체) 초기화
  final TextEditingController emailController = TextEditingController(); // 이메일 입력을 위한 컨트롤러
  final TextEditingController passwordController = TextEditingController(); // 비밀번호 입력을 위한 컨트롤러
  FocusNode emailFocusNode = FocusNode(); // 이메일 입력 필드의 포커스 노드
  FocusNode passwordFocusNode = FocusNode(); // 비밀번호 입력 필드의 포커스 노드
  String username = ''; // 사용자 이메일 저장 변수
  String password = ''; // 사용자 비밀번호 저장 변수

  @override
  void initState() {
    super.initState();// 이메일 및 비밀번호 입력 필드의 포커스 상태 변경을 감지하는 리스너 추가
    emailFocusNode.addListener(() {
      // 이메일 필드에 포커스가 있을 때 수행할 작업
      if (emailFocusNode.hasFocus) {
        // 텍스트 필드에 포커스가 있을 때 키보드가 활성화되도록 함
      }
    });
    passwordFocusNode.addListener(() {
      // 비밀번호 필드에 포커스가 있을 때 수행할 작업
      if (passwordFocusNode.hasFocus) {
        // 텍스트 필드에 포커스가 있을 때 키보드가 활성화되도록 함
      }
    });
  }

  @override
  void dispose() {
    // 위젯 해제 시 리소스 해제
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
                _Title(), // 로그인 화면 타이틀 위젯
                const SizedBox(height: 16.0),
                _SubTitle(), // 로그인 화면 서브 타이틀 위젯
                Image.asset(
                  'asset/img/misc/main_image.jpg', // 로그인 화면 메인 이미지
                  width: MediaQuery.of(context).size.width / 2 * 3,
                ),
                const SizedBox(height: 12.0),
                CustomTextFormField(
                  controller: emailController, // 이메일 입력을 위한 컨트롤러 연결
                  focusNode: emailFocusNode, // FocusNode 할당, 이메일 입력 필드 포커스 노드
                  hintText: '이메일을 입력해주세요.',
                  keyboardType: TextInputType.emailAddress, // 키보드 유형을 이메일 주소로 설정
                  onChanged: (String value) {
                    username = value; // 입력된 이메일 주소 저장
                  },
                ),
                const SizedBox(height: 12.0),
                CustomTextFormField(
                  controller: passwordController, // 비밀번호 입력을 위한 컨트롤러 연결
                  focusNode: passwordFocusNode, // 비밀번호 입력 필드 포커스 노드
                  hintText: '비밀번호를 입력해주세요.',
                  obscureText: true, // 비밀번호 가리기
                  onChanged: (String value) {
                    password = value; // 입력된 비밀번호 저장
                  },
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  child: Text('로그인'),
                  onPressed: () async {
                    // 로그인 버튼 클릭 시 동작
                    try {
                      // 이메일과 비밀번호를 사용하여 Firebase에서 로그인 시도
                      await _auth.signInWithEmailAndPassword(
                        email: username, // username을 이용해 이메일 전달
                        password: password, // password를 이용해 비밀번호 전달
                      );
                      // 로그인 성공 후 처리
                      ref.read(tabIndexProvider.notifier).state = 0; // tabIndex를 0으로 설정
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
                    backgroundColor: BUTTON_COLOR, // 버튼 배경색 설정
                    foregroundColor: Colors.white, // 버튼 텍스트(전경) 색상 설정
                  ),
                ),
                  // 회원가입 버튼
                  // 기존 TextButton 대신 ElevatedButton 사용
                ElevatedButton(
                  child: Text('회원가입'),
                  onPressed: () async {
                    // 회원가입 버튼 클릭 시 동작
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
                    backgroundColor: BUTTON_COLOR, // 버튼 배경색 설정
                    foregroundColor: Colors.white, // 버튼 텍스트(전경) 색상 설정
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

// 로그인 화면 타이틀 위젯
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

// 로그인 화면 서브 타이틀 위젯
class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '오늘도 나만의 옷을 PICK!!\n 이메일과 비밀번호를 입력해서 로그인 해주세요! :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR, // 본문 텍스트 색상
      ),
    );
  }
}
