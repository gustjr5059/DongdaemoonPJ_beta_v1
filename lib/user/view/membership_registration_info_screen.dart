import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import 'login_screen.dart';

// -------- 회원가입 안내 화면 관련 MembershipRegistrationInfoScreen 클래스 정의 내용 시작
class MembershipRegistrationInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 버튼 스타일폼 옵션 정의
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: LIGHT_PURPLE_COLOR, // 버튼 배경색 설정
      foregroundColor: Colors.white, // 버튼 텍스트(전경) 색상 설정
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 최상단 이미지
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Image.asset(
                'asset/img/misc/poster_img/membership_guide_image.png',
                // 이미지를 불러오는 경로
                height: MediaQuery.of(context).size.height /
                    2, // 화면 높이의 절반을 차지하도록 설정
                fit: BoxFit.cover, // 이미지를 잘라서 박스에 맞춤
              ),
            ),
            SizedBox(height: 20), // 이미지와 카드뷰 사이의 간격
            // 회원가입 안내 카드뷰
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CommonCardView(
                backgroundColor: LIGHT_YELLOW_COLOR, // 카드 배경색 설정
                content: Column(
                  children: [
                    Text(
                      '<회원가입 안내>', // 안내 텍스트
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold), // 텍스트 스타일
                      textAlign: TextAlign.center, // 텍스트를 중앙 정렬
                    ),
                    SizedBox(height: 20), // 텍스트 사이의 간격
                    Text(
                      '하단에 [회원가입 하러가기]버튼 클릭해주세요.', // 안내 텍스트
                      style: TextStyle(fontSize: 16), // 텍스트 스타일
                      textAlign: TextAlign.center, // 텍스트를 중앙 정렬
                    ),
                    SizedBox(height: 10), // 텍스트 사이의 간격
                    Text(
                      '버튼 클릭 후, 구글시트에 내용 기입해주세요.', // 안내 텍스트
                      style: TextStyle(fontSize: 16), // 텍스트 스타일
                      textAlign: TextAlign.center, // 텍스트를 중앙 정렬
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40), // 카드뷰와 버튼 사이의 간격
            // 버튼들 배치
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // 회원가입 하러가기 버튼 클릭 시
                    _launchURL('https://pf.kakao.com/_xjVrbG'); // 해당 URL을 엶
                  },
                  child: Text('회원가입 하러가기'), // 버튼 텍스트
                  style: buttonStyle, // 버튼 스타일 적용
                ),
                SizedBox(width: 20), // 버튼 사이의 간격
                ElevatedButton(
                  onPressed: () {
                    // 돌아가기 버튼 클릭 시 LoginScreen으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen()), // LoginScreen으로 네비게이션
                    );
                  },
                  child: Text('돌아가기'), // 버튼 텍스트
                  style: buttonStyle, // 버튼 스타일 적용
                ),
              ],
            ),
          ],
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
// -------- 회원가입 안내 화면 관련 MembershipRegistrationInfoScreen 클래스 정의 내용 끝
