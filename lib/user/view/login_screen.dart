// Flutter의 UI 구성 요소를 제공하는 Material 디자인 패키지를 임포트합니다.
// 이 패키지는 다양한 머티리얼 디자인 위젯을 포함하여, 사용자 인터페이스를 효과적으로 구성할 수 있게 도와줍니다.
import 'package:flutter/material.dart';
// 상태 관리를 위한 현대적인 라이브러리인 Riverpod를 임포트합니다.
// Riverpod는 애플리케이션의 상태를 효율적으로 관리하고, 상태 변화에 따라 UI를 자동으로 업데이트합니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Firebase의 사용자 인증 기능을 제공하는 FirebaseAuth 패키지를 임포트합니다.
// FirebaseAuth는 Firebase 플랫폼의 일부로, 사용자 로그인 및 계정 관리 기능을 쉽게 구현할 수 있게 해줍니다.
// 이를 통해 이메일 및 비밀번호 인증, 소셜 미디어 로그인, 전화번호 인증 등 다양한 인증 방법을 애플리케이션에 통합할 수 있습니다.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
// 애플리케이션 내에서 재사용 가능한 커스텀 텍스트 입력 필드 위젯을 정의한 파일을 임포트합니다.
// 이 커스텀 위젯은 입력 폼을 보다 효과적으로 관리하고, 일관된 스타일을 유지할 수 있도록 돕습니다.
import '../../common/component/custom_text_form_field.dart';
// 애플리케이션에서 사용할 색상의 상수를 정의한 파일을 임포트합니다.
// 이 파일은 앱 전반에 걸쳐 일관된 색상 팔레트를 제공하며, UI의 시각적 일관성을 유지하는 데 중요합니다.
import '../../common/const/colors.dart';
// 애플리케이션의 공통 상태 관리 로직을 포함하는 Provider 파일을 임포트합니다.
// 이 파일은 앱 전체에서 사용될 상태 관리 로직을 정의하고, 데이터의 상태를 효과적으로 관리합니다.
import '../../common/provider/common_state_provider.dart';
// 애플리케이션의 홈 화면 뷰를 정의하는 파일을 임포트합니다.
// 홈 화면은 사용자가 앱을 열었을 때 처음 보게 되는 화면으로, 앱의 주요 기능을 사용자에게 소개하고 접근성을 제공합니다.
import '../../home/view/home_screen.dart';
import 'membership_registration_info_screen.dart';

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
                      // 로그인 성공 시 처리, 로그인 성공 메시지 표시
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("로그인이 되었습니다."),
                        ),
                      );
                      // 로그인 성공 후 처리
                      ref.read(tabIndexProvider.notifier).state = 0; // tabIndex를 0으로 설정
                      Navigator.of(context).pushReplacement(
                        // (context) -> (_) 로 변경 : 매개변수를 정의해야 하지만 실제로 내부 로직에서 사용하지 않을 때 표기방법
                        MaterialPageRoute(builder: (_) => HomeMainScreen()),
                      );
                    } on FirebaseAuthException catch (e) {
                      // 로그인 실패 시 처리, 예를 들어 사용자에게 오류 메시지 표시
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("아이디 혹은 비밀번호가 일치하지 않습니다."),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BUTTON_COLOR, // 버튼 배경색 설정
                    foregroundColor: Colors.white, // 버튼 텍스트(전경) 색상 설정
                  ),
                ),
                // '회원가입' 버튼과 '아이디/비밀번호 찾기' 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    MembershipRegistrationInfoScreen()),
                          );
                        },
                        child: Text('회원가입'),
                        style: TextButton.styleFrom(
                          foregroundColor: BUTTON_COLOR, // 텍스트 색상 설정
                        ),
                      ),
                    ),
                    // 세로로된 회색 구분선
                    Container(
                      height: 24.0,
                      child: VerticalDivider(
                        color: Colors.grey,
                        thickness: 1.0,
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // 링크로 이동
                          const url = 'https://pf.kakao.com/_xjVrbG';
                          _launchURL(url);
                        },
                        child: Text('아이디/비밀번호 찾기'),
                        style: TextButton.styleFrom(
                          foregroundColor: BUTTON_COLOR, // 텍스트 색상 설정
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30), // 버튼 밑에 30 높이의 빈 공간 추가
              ],
            ),
          ),
        ),
      ),
    );
  }

  // URL을 여는 함수 정의
  void _launchURL(String url) async {
    Uri uri = Uri.parse(url); // 주어진 URL을 파싱하여 Uri 객체 생성
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri); // URL을 열 수 있으면 엶
    } else {
      throw 'Could not launch $url'; // URL을 열 수 없으면 예외 발생
    }
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
