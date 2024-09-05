// Flutter에서 제공하는 Material 디자인 요소를 사용하기 위한 패키지입니다.
// 이 패키지는 버튼, 카드, 타이포그래피 등의 디자인 요소를 포함하고 있으며,
// 앱의 기본적인 UI 구성에 필수적입니다.
import 'package:flutter/material.dart';

// Dart의 비동기 프로그래밍을 지원하는 'dart:async' 라이브러리를 가져옵니다.
// 이 라이브러리는 Future와 Stream을 통해 비동기 작업을 쉽게 다룰 수 있게 해주며,
// 네트워크 요청, 파일 I/O, 시간 지연 작업 등에 사용됩니다.
import 'dart:async'; // 비동기 작업을 위한 dart:async 라이브러리를 가져옴.
// 애플리케이션의 스플래시 스크린 중 두 번째 화면을 구현한 'SplashScreen2' 파일을 가져옵니다.
// 이 화면은 앱이 시작할 때 초기 로딩 화면으로 사용되어, 사용자에게 앱 로딩 중임을 알립니다.
import 'package:dongdaemoon_beta_v1/common/view/splash2_screen.dart'; // 다음 화면으로 전환하기 위해 SplashScreen2를 가져옴.
import 'package:flutter_svg/svg.dart';
// 애플리케이션 전반에 걸쳐 사용될 색상의 상수를 정의한 파일을 가져옵니다.
// 이 파일에서 정의된 색상은 버튼, 배경, 텍스트 등 다양한 UI 요소에 일관되게 사용되어,
// 앱의 디자인 통일성을 유지하는데 도움을 줍니다.
import '../const/colors.dart'; // 앱에서 사용할 색상 상수를 정의한 파일을 가져옴.

// 스플래시 스크린의 StatefulWidget을 정의함.
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

    // 1초 후에 SplashScreen2로 화면을 전환함.
    Timer(Duration(seconds: 1), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => SplashScreen2()));
    });
  }

  @override
  Widget build(BuildContext context) {
    // 화면의 UI를 구성함.
    return Scaffold(
      body: Stack(
        // Stack 위젯을 사용하여 요소들을 겹쳐서 배치함.
        children: <Widget>[
          // 피그마에서 추출한 배경 이미지를 SVG로 추가
          Positioned.fill(
            child: Image.asset(
              'asset/img/misc/splash_image/couture_splash1_bg_img.png', // 배경 이미지를 SVG로 설정
              fit: BoxFit.cover, // 화면 전체에 맞게 조정
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter, // 하단 중앙에 배치함.
            child: Padding(
              padding: EdgeInsets.only(bottom: 180), // 하단에서부터 100의 여백을 줌.
              child: AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14,
                    child: child,
                  );
                },
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 위젯이 제거될 때 애니메이션 컨트롤러를 정리함.
    _controller.dispose();
    _loadingController.dispose(); // 새로 추가한 컨트롤러도 정리함.
    super.dispose();
  }
}
