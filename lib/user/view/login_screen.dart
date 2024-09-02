// Flutter의 UI 구성 요소를 제공하는 Material 디자인 패키지를 임포트합니다.
import 'package:flutter/material.dart';

// 상태 관리를 위한 현대적인 라이브러리인 Riverpod를 임포트합니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Firebase의 사용자 인증 기능을 제공하는 FirebaseAuth 패키지를 임포트합니다.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../cart/provider/cart_state_provider.dart';
import '../../common/component/custom_text_form_field.dart';
import '../../common/const/colors.dart';
import '../../common/provider/common_state_provider.dart';
import '../../home/view/home_screen.dart';
import '../provider/user_me_provider.dart';
import 'membership_registration_info_screen.dart';

// ------- 로그인 화면 관련 클래스인 LoginScreen 내용 부분 시작
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
    // 자동 로그인 정보 불러옴
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
    // SharedPreferences 인스턴스 가져옴
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState로 상태 업데이트
    setState(() {
      // autoLogin 값을 SharedPreferences에서 불러오고, 값이 없으면 false 설정
      autoLogin = prefs.getBool('autoLogin') ?? false;
      if (autoLogin) {
        // autoLogin이 true인 경우, username과 password를 SharedPreferences에서 불러옴
        username = prefs.getString('username') ?? '';
        password = prefs.getString('password') ?? '';
        // 자동 로그인 정보가 있으면 _login 메서드를 호출하여 로그인 시도
        _login();
      }
    });
  }

// SharedPreferences에 자동 로그인 정보 저장하는 함수
  void _saveAutoLogin() async {
    // SharedPreferences 인스턴스 가져옴
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // autoLogin 값을 SharedPreferences에 저장
    prefs.setBool('autoLogin', autoLogin);
    if (autoLogin) {
      // autoLogin이 true인 경우, username과 password를 SharedPreferences에 저장
      prefs.setString('username', username);
      prefs.setString('password', password);
    } else {
      // autoLogin이 false인 경우, username과 password를 SharedPreferences에서 삭제
      prefs.remove('username');
      prefs.remove('password');
    }
  }

// 로그인 함수
  void _login() async {
    try {
      // FirebaseAuth를 사용하여 이메일과 비밀번호로 로그인 시도
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      // 로그인한 사용자 정보 가져옴
      User? user = userCredential.user;
      if (user != null) {
        // userMeProvider를 통해 사용자 정보 저장
        await ref.read(userMeProvider.notifier).login(
          email: username,
          password: password,
        );
        // cartItemsProvider를 통해 장바구니 데이터 로드
        await ref.read(cartItemsProvider.notifier).loadCartItems(); // 장바구니 데이터 로드

        // 로그인 성공 메시지 출력
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("로그인이 되었습니다."),
          ),
        );
        // 탭 인덱스를 0으로 설정
        ref.read(tabIndexProvider.notifier).state = 0;
        // 홈 화면으로 이동 및 현재 화면을 대체
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeMainScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // 로그인 실패 시 오류 메시지 출력
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
      body: Stack(
        children: [
          // 배경 이미지 추가
          Positioned.fill(
            child: Image.asset(
              'asset/img/misc/login_image/couture_login_bg_img.png',
              fit: BoxFit.cover, // 이미지가 화면을 꽉 채우도록 설정
              alignment: Alignment.center, // 화면 중앙에 맞춰서 배경을 배치
            ),
          ),
          // 텍스트 및 입력 필드 추가
          // SingleChildScrollView(
            // child: SafeArea(
            //   Stack(
            //     children: [
            //       // 화면 이름 텍스트
            //       Positioned(
            //         left: 0,
            //         right: 0,
            //         child: _ScreenName(),
            //       ),
                  _ScreenName(),
                  // 타이틀 텍스트 위치 및 스타일 설정
                  _Title(),
                  _SubTitle(),
                  // 이메일 입력 필드
                  Container(
                    width: 313, // Figma에서 지정한 너비 반영
                    height: 42, // Figma에서 지정한 높이 반영
                    margin: const EdgeInsets.only(left: 40.0, top: 330.0), // Figma에서 지정한 위치 반영
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85), // Figma에서 지정한 투명도 반영
                      borderRadius: BorderRadius.circular(5.0), // 둥근 모서리 반영
                      // Figma에서 설정된 효과 추가 (Background blur는 Flutter에서 직접 지원하지 않으므로 Color와 Opacity로 대체)
                    ),
                    child: CustomTextFormField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      hintText: '이메일을 입력해주세요.',
                      hintStyle: TextStyle(
                        fontFamily: 'NanumGothic', // Figma에서 사용된 폰트
                        fontSize: 12, // Figma에서 설정된 폰트 크기
                        fontWeight: FontWeight.normal, // Figma에서 설정된 굵기
                        color: Color(0xFF818181), // Figma에서 설정된 색상 (818181)
                      ),
                      hintTextPadding: EdgeInsets.only(left: 10.0, top: 5.0), // Figma에서 제공된 위치 반영
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (String value) {
                        username = value;
                      },
                    ),
                  ),
                  // 비밀번호 입력 필드
                  Container(
                    width: 313, // Figma에서 지정한 너비 반영
                    height: 42, // Figma에서 지정한 높이 반영
                    margin: const EdgeInsets.only(left: 40.0, top: 380.0), // Figma에서 지정한 위치 반영
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85), // Figma에서 지정한 투명도 반영
                      borderRadius: BorderRadius.circular(5.0), // 둥근 모서리 반영
                      // Figma에서 설정된 효과 추가 (Background blur는 Flutter에서 직접 지원하지 않으므로 Color와 Opacity로 대체)
                    ),
                    child: CustomTextFormField(
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      hintText: '비밀번호를 입력해주세요.',
                      hintStyle: TextStyle(
                        fontFamily: 'NanumGothic', // Figma에서 사용된 폰트
                        fontSize: 12, // Figma에서 설정된 폰트 크기
                        fontWeight: FontWeight.normal, // Figma에서 설정된 굵기
                        color: Color(0xFF818181), // Figma에서 설정된 색상 (818181)
                      ),
                      hintTextPadding: EdgeInsets.only(left: 10.0, top: 5.0), // Figma에서 제공된 위치 반영
                      obscureText: true,
                      onChanged: (String value) {
                        password = value;
                      },
                    ),
                  ),
                  Positioned(
                    left: 56.0, // Figma에서 지정한 X 위치
                    top: 434.0, // Figma에서 지정한 Y 위치
                    child: Container(
                      width: 16, // Figma에서 지정한 너비
                      height: 16, // Figma에서 지정한 높이
                      decoration: BoxDecoration(
                        color: Colors.white, // Figma에서 지정한 색상
                        borderRadius: BorderRadius.circular(2.0), // Figma에서 지정한 둥근 모서리
                      ),
                      child: Checkbox(
                        value: autoLogin,
                        onChanged: (bool? value) {
                          setState(() {
                            autoLogin = value ?? false;
                          });
                        },
                        activeColor: Colors.transparent, // 피그마에서 체크박스 색상을 투명하게 설정
                        checkColor: Colors.black, // 체크 표시 색상
                      ),
                    ),
                  ),
                  Positioned(
                    left: 80.0, // Figma에서 지정한 X 위치
                    top: 436.0, // Figma에서 지정한 Y 위치
                    child: Text(
                      '자동로그인',
                      style: TextStyle(
                        fontFamily: 'NanumGothic', // 피그마에서 사용된 폰트
                        fontSize: 12, // 피그마에서 지정된 폰트 크기
                        fontWeight: FontWeight.bold, // 피그마에서 지정된 굵기
                        color: Colors.white.withOpacity(0.9), // 피그마에서 지정된 색상 및 투명도
                      ),
                    ),
                  ),
                  // 로그인 버튼
                  Container(
                    width: 313, // Figma에서 지정한 너비 반영
                    height: 42, // Figma에서 지정한 높이 반영
                    margin: const EdgeInsets.only(left: 40.0, top: 487.0), // Figma에서 지정한 위치 반영
                    decoration: BoxDecoration(
                      color: Color(0xFF303030), // Figma에서 지정한 버튼 배경 색상
                      borderRadius: BorderRadius.circular(5.0), // Figma에서 지정한 둥근 모서리 반영
                      // Figma에서 설정된 효과 추가 (Background blur는 Flutter에서 직접 지원하지 않으므로 Color와 Opacity로 대체)
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        _login();
                        _saveAutoLogin();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // 배경색 투명 설정
                        elevation: 0, // 그림자 효과 제거
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0), // 모서리 둥글게 설정
                        ),
                      ),
                      child: Text(
                        '로그인',
                        style: TextStyle(
                          fontFamily: 'NanumGothic', // Figma에서 사용된 폰트
                          fontSize: 16, // Figma에서 지정한 폰트 크기
                          fontWeight: FontWeight.bold, // Figma에서 지정한 굵기
                          color: Colors.white.withOpacity(0.9), // Figma에서 지정한 텍스트 색상 및 투명도
                        ),
                      ),
                    ),
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    // 회원가입 및 아이디/비밀번호 찾기 버튼
                      Container(
                        width: 218, // Figma에서 지정한 전체 너비
                        height: 14, // Figma에서 지정한 전체 높이
                        margin: const EdgeInsets.only(left: 88.0, top: 543.0), // Figma에서 지정한 위치 반영
                        child: Row(
                          children: [
                            // 회원가입 텍스트 버튼
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MembershipRegistrationInfoScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  '회원가입',
                                  style: TextStyle(
                                    fontFamily: 'NanumGothic', // 피그마에서 사용된 폰트
                                    fontSize: 12, // 피그마에서 지정된 폰트 크기
                                    fontWeight: FontWeight.normal, // 피그마에서 지정된 굵기
                                    color: Colors.white, // 피그마에서 지정된 텍스트 색상
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero, // 여백 제거
                                  alignment: Alignment.centerLeft, // 텍스트 정렬
                                ),
                              ),
                            ),
                            // 아이디/비밀번호 찾기 텍스트 버튼
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  const url = 'https://pf.kakao.com/_xjVrbG';
                                  _launchURL(url);
                                },
                                child: Text(
                                  '아이디/비밀번호 찾기',
                                  style: TextStyle(
                                    fontFamily: 'NanumGothic', // 피그마에서 사용된 폰트
                                    fontSize: 12, // 피그마에서 지정된 폰트 크기
                                    fontWeight: FontWeight.normal, // 피그마에서 지정된 굵기
                                    color: Colors.white, // 피그마에서 지정된 텍스트 색상
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero, // 여백 제거
                                  alignment: Alignment.centerRight, // 텍스트 정렬
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 845), // 빈 공간 추가
        ],
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

// 로그인 화면 화면 이름 위젯
class _ScreenName extends StatelessWidget {
  const _ScreenName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      top: 54.0,
      child: Text(
      'Login',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24, // Figma에서 사용된 글꼴 크기에 맞춤
        fontWeight: FontWeight.w600, // Figma에서 사용된 굵기에 맞춤
        color: Colors.black, // Figma에서 사용된 텍스트 색상
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
    return Positioned(
      left: 51.0, // Figma에서 지정한 X 위치 반영
      top: 227.0, // Figma에서 지정한 Y 위치 반영
      child: Text(
        '오늘도 나만의 옷을 PICK!',
        style: TextStyle(
          fontFamily: 'NanumGothic', // Figma에서 사용된 폰트
          fontWeight: FontWeight.bold, // Figma에서 설정된 Bold
          fontSize: 26, // Figma에서 설정된 폰트 크기
          color: Colors.white, // Figma에서 설정된 색상
        ),
      ),
    );
  }
}

// 로그인 화면 서브 타이틀 위젯
class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 49.0, // Figma에서 지정한 X 위치 반영
      top: 268.0, // Figma에서 지정한 Y 위치 반영
      child: Text(
        '이메일과 비밀번호를 입력해서 로그인해주세요! :)',
        style: TextStyle(
          fontFamily: 'NanumGothic', // Figma에서 사용된 폰트
          fontWeight: FontWeight.normal, // Figma에서 설정된 Bold
          fontSize: 14, // Figma에서 설정된 폰트 크기
          color: Colors.white, // Figma에서 설정된 색상
        ),
      ),
    );
  }
}
