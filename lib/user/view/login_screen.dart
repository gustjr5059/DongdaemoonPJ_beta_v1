// Flutter의 UI 구성 요소를 제공하는 Material 디자인 패키지를 임포트합니다.
import 'package:flutter/material.dart';
// 상태 관리를 위한 현대적인 라이브러리인 Riverpod를 임포트합니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Firebase의 사용자 인증 기능을 제공하는 FirebaseAuth 패키지를 임포트합니다.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/component/custom_text_form_field.dart';
import '../../common/const/colors.dart';
import '../../common/provider/common_state_provider.dart';
import '../../home/view/home_screen.dart';
import 'membership_registration_info_screen.dart';

// 로그인 화면을 위한 StatefulWidget 정의
class LoginScreen extends ConsumerStatefulWidget {
  // 라우트 이름 정의
  static String get routeName => 'login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // FirebaseAuth 인스턴스 초기화
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // 이메일 입력을 위한 컨트롤러
  final TextEditingController emailController = TextEditingController();
  // 비밀번호 입력을 위한 컨트롤러
  final TextEditingController passwordController = TextEditingController();
  // 이메일 입력 필드의 포커스 노드
  FocusNode emailFocusNode = FocusNode();
  // 비밀번호 입력 필드의 포커스 노드
  FocusNode passwordFocusNode = FocusNode();
  // 사용자 이메일 저장 변수
  String username = '';
  // 사용자 비밀번호 저장 변수
  String password = '';
  // 자동 로그인 여부 저장 변수
  bool autoLogin = false;

  @override
  void initState() {
    super.initState();
    // 자동 로그인 정보 불러오기
    _loadAutoLogin();
    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {
        // 이메일 필드에 포커스가 생겼을 때 수행할 동작
      }
    });
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        // 비밀번호 필드에 포커스가 생겼을 때 수행할 동작
      }
    });
  }

  @override
  void dispose() {
    // 포커스 노드 해제
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  // SharedPreferences에서 자동 로그인 정보 불러오는 함수
  void _loadAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      autoLogin = prefs.getBool('autoLogin') ?? false;
      if (autoLogin) {
        username = prefs.getString('username') ?? '';
        password = prefs.getString('password') ?? '';
        // 자동 로그인 정보가 있으면 _login 메서드를 호출하여 로그인 시도
        _login();
      }
    });
  }

  // SharedPreferences에 자동 로그인 정보 저장하는 함수
  void _saveAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('autoLogin', autoLogin);
    if (autoLogin) {
      prefs.setString('username', username);
      prefs.setString('password', password);
    } else {
      prefs.remove('username');
      prefs.remove('password');
    }
  }

  // 로그인 함수
  void _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      // 로그인 성공 시 스낵바 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("로그인이 되었습니다."),
        ),
      );
      // 탭 인덱스를 0으로 초기화
      ref.read(tabIndexProvider.notifier).state = 0;
      // 홈 화면으로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeMainScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // 로그인 실패 시 스낵바 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("아이디 혹은 비밀번호가 일치하지 않습니다."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SingleChildScrollView를 사용하여 화면을 스크롤 가능하게 만듭니다.
      body: SingleChildScrollView(
        // SafeArea를 사용하여 장치의 안전 영역을 침범하지 않도록 합니다.
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            // 좌우 여백을 16.0으로 설정합니다.
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              // 자식 위젯들을 stretch(늘리기) 방향으로 정렬합니다.
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 타이틀 위젯
                _Title(),
                const SizedBox(height: 16.0),
                // 서브 타이틀 위젯
                _SubTitle(),
                // 이미지 위젯
                Image.asset(
                  'asset/img/misc/main_image.jpg',
                  // 화면 너비의 1.5배로 이미지 너비를 설정합니다.
                  width: MediaQuery.of(context).size.width / 2 * 3,
                ),
                const SizedBox(height: 12.0),
                // 이메일 입력 필드
                CustomTextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  hintText: '이메일을 입력해주세요.',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (String value) {
                    // 입력된 이메일 값을 username 변수에 저장
                    username = value;
                  },
                ),
                const SizedBox(height: 12.0),
                // 비밀번호 입력 필드
                CustomTextFormField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  hintText: '비밀번호를 입력해주세요.',
                  obscureText: true,
                  onChanged: (String value) {
                    // 입력된 비밀번호 값을 password 변수에 저장
                    password = value;
                  },
                ),
                const SizedBox(height: 12.0),
                // 자동 로그인 체크박스와 텍스트
                Row(
                  children: [
                    Checkbox(
                      value: autoLogin,
                      onChanged: (bool? value) {
                        setState(() {
                          // 체크박스 값 변경
                          autoLogin = value ?? false;
                        });
                      },
                    ),
                    const Text('자동 로그인'),
                  ],
                ),
                // 로그인 버튼
                ElevatedButton(
                  child: Text('로그인'),
                  onPressed: () async {
                    // 로그인 함수 호출
                    _login();
                    // 자동 로그인 정보 저장
                    _saveAutoLogin();
                  },
                  // 버튼 스타일 설정
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BUTTON_COLOR,
                    foregroundColor: Colors.white,
                  ),
                ),
                // 회원가입 및 아이디/비밀번호 찾기 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // 회원가입 화면으로 이동
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    MembershipRegistrationInfoScreen()),
                          );
                        },
                        child: Text('회원가입'),
                        // 버튼 텍스트 색상 설정
                        style: TextButton.styleFrom(
                          foregroundColor: BUTTON_COLOR,
                        ),
                      ),
                    ),
                    Container(
                      // 세로 구분선
                      height: 24.0,
                      child: VerticalDivider(
                        color: Colors.grey,
                        thickness: 1.0,
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // 아이디/비밀번호 찾기 URL 열기
                          const url = 'https://pf.kakao.com/_xjVrbG';
                          _launchURL(url);
                        },
                        child: Text('아이디/비밀번호 찾기'),
                        // 버튼 텍스트 색상 설정
                        style: TextButton.styleFrom(
                          foregroundColor: BUTTON_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // URL을 여는 함수 정의
  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}

// 로그인 화면 타이틀 위젯
class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 타이틀 텍스트
    return Text(
      'Dongdaemoon Shop 🛍️',
      textAlign: TextAlign.center,
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
    // 서브 타이틀 텍스트
    return Text(
      '오늘도 나만의 옷을 PICK!!\n 이메일과 비밀번호를 입력해서 로그인 해주세요! :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
