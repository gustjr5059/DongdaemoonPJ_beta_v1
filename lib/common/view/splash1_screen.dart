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
import '../const/colors.dart';
import '../layout/common_body_parts_layout.dart'; // 앱에서 사용할 색상 상수를 정의한 파일을 가져옴.

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
      duration: Duration(milliseconds: 1500), // 애니메이션 지속 시간을 1.5초로 설정함.
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
    Timer(Duration(milliseconds: 1500), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => SplashScreen2()));
    });
  }

  @override
  void dispose() {
    // 위젯이 제거될 때 애니메이션 컨트롤러를 정리함.
    _controller.dispose();
    _loadingController.dispose(); // 새로 추가한 컨트롤러도 정리함.

    super.dispose();
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

// // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려하지 않은 사이즈 시작 부분
//     // 화면의 UI를 구성함.
//     return Scaffold(
//       body: Stack(
//         // Stack 위젯을 사용하여 요소들을 겹쳐서 배치함.
//         children: <Widget>[
//           // 피그마에서 추출한 배경 이미지를 SVG로 추가
//           Positioned.fill(
//             child: Image.asset(
//               'asset/img/misc/splash_image/couture_splash1_bg_img.png', // 배경 이미지를 SVG로 설정
//               fit: BoxFit.cover, // 화면 전체에 맞게 조정
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter, // 하단 중앙에 배치함.
//             child: Padding(
//               padding: EdgeInsets.only(bottom: screenX), // 하단에서부터 100의 여백을 줌.
//               child: AnimatedBuilder(
//                 animation: _rotationAnimation,
//                 builder: (context, child) {
//                   return Transform.rotate(
//                     angle: _rotationAnimation.value * 2 * 3.14,
//                     child: child,
//                   );
//                 },
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(WHITE_COLOR),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
// // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려하지 않은 사이즈 끝 부분

    // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려한 사이즈 시작 부분
    // 화면의 UI를 구성함.
    return Scaffold(
      // body에 바로 CustomScrollView 배치
      body: CustomScrollView(
        slivers: [
          // SliverFillRemaining:
          // 남은 화면 전체를 차지하기 때문에
          // 배경 이미지를 상하단까지 완전히 채울 수 있음.
          SliverFillRemaining(
            // 만약 스크롤이 필요 없고, 화면을 '정적으로' 채우기만 한다면
            // hasScrollBody: false 를 사용해서 내용이 화면보다 작을 때 스크롤이 비활성화되도록 할 수 있음
            hasScrollBody: false,
            child: Stack(
              children: [
                // 배경 이미지
                Positioned.fill(
                  child: Image.asset(
                    'asset/img/misc/splash_image/couture_splash1_bg_img.png',
                    fit: BoxFit.cover, // 전체 화면 꽉 채우기
                    width: screenSize.width, // 화면 너비
                    height: screenSize.height, // 화면 높이
                  ),
                ),
                // 실제 표시할 콘텐츠(예: 로고, 로딩 인디케이터 등)는
                // SafeArea 내부에 배치하여 상태바, 하단 제스처 영역 침범을 방지
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: screenX),
                      // 하단에서부터 100의 여백을 줌.
                      child: AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationAnimation.value * 2 * 3.14,
                            child: child,
                          );
                        },
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            WHITE_COLOR,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려한 사이즈 끝 부분
  }
}
