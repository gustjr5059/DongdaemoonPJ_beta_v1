// Flutter에서 제공하는 Material 디자인 요소를 사용하기 위한 패키지입니다.
// 이 패키지는 버튼, 카드, 타이포그래피 등의 디자인 요소를 포함하고 있으며,
// 앱의 기본적인 UI 구성에 필수적입니다.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Dart의 비동기 프로그래밍을 지원하는 'dart:async' 라이브러리를 가져옵니다.
// 이 라이브러리는 Future와 Stream을 통해 비동기 작업을 쉽게 다룰 수 있게 해주며,
// 네트워크 요청, 파일 I/O, 시간 지연 작업 등에 사용됩니다.
import 'dart:async'; // 비동기 작업을 위한 dart:async 라이브러리를 가져옴.
// 애플리케이션의 스플래시 스크린 중 두 번째 화면을 구현한 'SplashScreen2' 파일을 가져옵니다.
// 이 화면은 앱이 시작할 때 초기 로딩 화면으로 사용되어, 사용자에게 앱 로딩 중임을 알립니다.
import 'package:shared_preferences/shared_preferences.dart';
// 애플리케이션 전반에 걸쳐 사용될 색상의 상수를 정의한 파일을 가져옵니다.
// 이 파일에서 정의된 색상은 버튼, 배경, 텍스트 등 다양한 UI 요소에 일관되게 사용되어,
// 앱의 디자인 통일성을 유지하는데 도움을 줍니다.
import '../../home/view/main_home_screen.dart';
import '../const/colors.dart';


// ------ 스플레시1화면의 UI를 구현하는 SplashScreen1 클래스 시작 부분
class SplashScreen1 extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

// _SplashScreenState 클래스에서 SingleTickerProviderStateMixin을 사용하여 애니메이션 컨트롤러를 생성함.
class _SplashScreenState extends State<SplashScreen1>
    with TickerProviderStateMixin {
  late AnimationController _controller; // 애니메이션 컨트롤러를 선언함.
  late Animation<double> _animation; // 애니메이션 값을 저장할 변수를 선언함.
  late AnimationController _loadingController; // 로딩 인디케이터의 회전을 제어하기 위한 컨트롤러
  late Animation<double> _rotationAnimation; // 회전 속도를 조절하기 위한 애니메이션

  @override
  void initState() {
    super.initState();
    // initState에서 애니메이션 컨트롤러와 애니메이션 값을 초기화함.
    _controller = AnimationController(
      vsync: this, // 현재 클래스가 애니메이션의 vsync를 담당함.
      duration: Duration(milliseconds: 2000), // 애니메이션 지속 시간을 2초로 설정함.
    );
    // 위젯이 생성될 때 _checkAutoLogin 메서드를 호출하여 자동 로그인 여부를 확인.
    _checkAutoLogin();

    // Tween을 사용하여 애니메이션의 시작과 끝 값을 설정함.
    _animation = Tween(begin: 1.0, end: 0.5).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse(); // 애니메이션이 완료되면 반대 방향으로 실행함.
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward(); // 애니메이션이 종료되면 다시 시작함.
        }
      });

    _controller.forward(); // 애니메이션을 시작함.

    // 로딩 인디케이터의 회전 속도를 제어하는 컨트롤러를 초기화.
    _loadingController = AnimationController(
      duration: const Duration(seconds: 100), // 회전 속도를 조절함.
      vsync: this,
    );

    // CurvedAnimation을 사용하여 회전 속도의 곡선을 조절함
    _rotationAnimation = CurvedAnimation(
      parent: _loadingController,
      curve: Curves.decelerate, // 시작은 빠르고 점점 느려지는 효과
    );

    _loadingController.repeat();
  }

  @override
  void dispose() {
    // 위젯이 제거될 때 애니메이션 컨트롤러를 정리함.
    _controller.dispose();
    _loadingController.dispose(); // 새로 추가한 컨트롤러도 정리함.

    super.dispose();
  }

  // // 자동 로그인을 확인하는 비동기 메서드.
  // void _checkAutoLogin() async {
  //   // SharedPreferences 인스턴스를 가져옴.
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // 'autoLogin' 키에 저장된 값을 불러오며, 값이 없을 경우 기본값으로 false를 사용.
  //   bool autoLogin = prefs.getBool('autoLogin') ?? false;
  //
  //   // 현재 Firebase 인증 상태에서 사용자 정보를 가져옴
  //   User? user = FirebaseAuth.instance.currentUser;
  //
  //   // (1) 이미 로그인된 사용자 정보가 있는지 판별
  //   if (user == null) {
  //     // user가 null → 로그인된 사용자가 없는 상태
  //     // 이메일/비밀번호 로그인 유저가 자동 로그인 옵션을 꺼두었다면 → 필요 시 로그아웃 처리
  //     if (!autoLogin) {
  //       await FirebaseAuth.instance.signOut();
  //       // 사실 이미 user == null이지만, 혹시 모를 세션 이슈나
  //       // 중간에 SNS 로그인 시도 흔적 등이 남아있다면 아예 정리하는 의미로 작성한 코드
  //     }
  //   }

  // 자동 로그인을 확인하는 비동기 메서드
  // 앱 실행 시, 사용자가 이전에 '자동 로그인'을 체크했는지 확인하고
  // Firebase Authentication 상태와 함께 검증하여 로그인 유지 여부를 결정.
  void _checkAutoLogin() async {
    // ───────────────────────────────────────────────────────────────
    // (1) SharedPreferences에서 autoLogin 값 가져오기
    //     - 사용자 기기에 'autoLogin' 여부(체크박스 상태) 저장되어 있는지 확인
    //     - 없으면 false(미체크)로 간주
    // ───────────────────────────────────────────────────────────────
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool autoLogin = prefs.getBool('autoLogin') ?? false;

    // ───────────────────────────────────────────────────────────────
    // (2) 현재 Firebase 인증 상태에서 사용자 정보를 가져옴
    //     - FirebaseAuth.instance.currentUser로 현재 로그인한 사용자 정보 확인
    //     - 로그아웃 상태이면 user == null
    // ───────────────────────────────────────────────────────────────
    User? user = FirebaseAuth.instance.currentUser;

    // ───────────────────────────────────────────────────────────────
    // (3) 사용자 정보가 있는 경우 (user != null)
    //     - 이미 Firebase 로그인 상태임
    // ───────────────────────────────────────────────────────────────
    if (user != null) {
      // 3-1) 'password' Provider인 경우 → 이메일/비밀번호 로그인 방식을 사용했는지 체크
      //      autoLogin이 false라면 => 자동 로그인 해제
      bool isEmailUser = user.providerData.any((info) => info.providerId == 'password');

      // ▸ 이메일/비밀번호 사용자이고(autoLogin == false)이면 로그아웃 처리
      if (isEmailUser && !autoLogin) {
        // 자동 로그인이 체크되어 있지 않으므로 로그인 해제
        await FirebaseAuth.instance.signOut();
        // 로그아웃 직후 user 상태를 null로 업데이트 (화면에 즉시 반영할 수 있도록)
        user = null;
      }

      // SNS 계정 로그인 사용자의 경우는 3-1인 이메일/비밀번호 사용자이고(autoLogin == false)이면 로그아웃 처리에 해당하지 않는 경우이므로
      // else 경우에 해당하고 해당 경우는 따로 구현하지않아도 일반적으로 반대 케이스로 인식하므로 로그인 해제가 안되어서 자연스레 앱을 재실행해도 로그인 상태가 유지됨.
    }
    // ───────────────────────────────────────────────────────────────
    // (4) 사용자 정보가 없는 경우 (user == null)
    //     - 이미 로그인 정보가 없거나, 이전 단계에서 로그아웃 처리된 상황
    //     - autoLogin == false이면 혹시 모를 세션(토큰) 흔적을 지우기 위해 다시 signOut()
    // ───────────────────────────────────────────────────────────────
    else {
      // 자동 로그인이 해제되어 있으면 로그인 세션 정리
      if (!autoLogin) {
        await FirebaseAuth.instance.signOut();
      }
    }

    // 2초 후에 다음 동작을 수행.
    Timer(Duration(milliseconds: 2000), () {
      Navigator.of(context).pushReplacement(
        // MaterialPageRoute(builder: (_) => HomeMainScreen()),
        MaterialPageRoute(builder: (_) => MainHomeScreen()),
      ); // 홈 화면으로 이동

      // if (autoLogin) {
      //   // autoLogin이 true인 경우 HomeMainScreen으로 이동.
      //   Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(builder: (_) => HomeMainScreen()),
      //   );
      // } else {
      //   // autoLogin이 false인 경우 플랫폼에 따라 분기
      //   // IOS 플랫폼은 IOS 화면으로 이동
      //   if (Platform.isIOS) {
      //     Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(builder: (_) => EasyLoginIosScreen()),
      //     );
      //     // AOS 플랫폼은 AOS 화면으로 이동
      //   } else if (Platform.isAndroid) {
      //     Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(builder: (_) => EasyLoginAosScreen()),
      //     );
      //   } else {
      //     // 기타 플랫폼은 기본적으로 AOS 화면으로 이동
      //     Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(builder: (_) => EasyLoginAosScreen()),
      //     );
      //   }
      // }
    });
  }

  @override
  Widget build(BuildContext context) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 세로 852
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 화면 부분 수치
    final double screenX =
        screenSize.height * (180 / referenceHeight); // 위쪽 여백 비율

    // 화면의 UI를 구성함.
    return Scaffold(
      body: Stack(
        // Stack 위젯을 사용하여 요소들을 겹쳐서 배치함.
        children: <Widget>[
          // 피그마에서 추출한 배경 이미지를 SVG로 추가
          Positioned.fill(
            child: Image.asset(
              'asset/img/misc/splash_image/wearcano_splash1_bg_img.png', // 배경 이미지를 SVG로 설정
              fit: BoxFit.cover, // 화면 전체에 맞게 조정
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter, // 하단 중앙에 배치함.
            child: Padding(
              padding: EdgeInsets.only(bottom: screenX), // 하단에서부터 100의 여백을 줌.
              child: AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14,
                    child: child,
                  );
                },
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(ORANGE56_COLOR),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// ------ 스플레시1화면의 UI를 구현하는 SplashScreen1 클래스 끝 부분