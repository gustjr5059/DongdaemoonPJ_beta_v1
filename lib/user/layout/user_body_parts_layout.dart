import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // 플러터 Material 디자인 패키지를 가져옴
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 플러터 Riverpod 패키지를 가져옴
import 'package:url_launcher/url_launcher.dart'; // URL을 열기 위한 패키지를 가져옴
import '../../announcement/view/announce_screen.dart'; // 공지사항 화면을 가져옴
import '../../common/const/colors.dart'; // 공통 색상 상수를 가져옴
import '../../common/layout/common_body_parts_layout.dart'; // 공통 레이아웃을 가져옴
import '../../common/layout/common_exception_parts_of_body_layout.dart'; // 공통 예외 처리 레이아웃을 가져옴
import '../../home/view/home_screen.dart';
import '../../inquiry/view/inquiry_screen.dart'; // 문의 화면을 가져옴
import '../../message/view/message_screen.dart'; // 메시지 화면을 가져옴
import '../../order/provider/order_all_providers.dart'; // 주문 관련 프로바이더를 가져옴
import '../../order/view/order_list_screen.dart'; // 주문 목록 화면을 가져옴
import '../../product/layout/product_body_parts_layout.dart'; // 제품 관련 레이아웃을 가져옴
import '../../review/view/review_screen.dart'; // 리뷰 화면을 가져옴
import '../../wishlist/view/wishlist_screen.dart'; // 찜 목록 화면을 가져옴
import '../provider/profile_all_providers.dart';
import '../view/easy_login_aos_screen.dart';
import '../view/easy_login_ios_screen.dart';
import '../view/login_screen.dart';
import '../view/profile_screen.dart';
import '../view/user_info_modify_screen.dart'; // 로그인 화면을 가져옴
import 'dart:io'; // 플랫폼을 확인하기 위한 dart:io 라이브러리 추가


// // ------- 마이페이지 화면 내 회원정보 관련 데이터를 파이어베이스에서 불러와서 UI로 구현하는 UserProfileInfo 클래스 내용 시작 부분
// class UserProfileInfo extends ConsumerWidget { // ConsumerWidget을 상속받아 UserProfileInfo 클래스를 정의
//   final String email; // 이메일 필드를 선언
//
//   UserProfileInfo({required this.email}); // 생성자를 통해 이메일 필드를 초기화
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) { // build 메서드 정의
//     // build 메서드를 정의하여 위젯 트리를 구성함
//     // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
//     final Size screenSize = MediaQuery.of(context).size;
//
//     // 기준 화면 크기 설정 (가로 393, 세로 852)
//     final double referenceWidth = 393.0;
//     final double referenceHeight = 852.0;
//
//     // 마이페이지 회원정보 카드뷰 섹션의 가로와 세로 비율 계산
//     final double uesrInfoCardViewWidth =
//         screenSize.width * (393 / referenceWidth); // 가로 비율 계산
//     final double uesrInfoCardViewHeight =
//         screenSize.height * (220 / referenceHeight); // 세로 비율 계산
//
//     // body 부분 전체 패딩 수치 계산
//     final double uesrInfoCardViewPaddingX = screenSize.width * (15 / referenceWidth); // 좌우 패딩 계산
//     final double uesrInfoCardViewPadding1Y = screenSize.height * (8 / referenceHeight); // 상하 패딩 계산
//
//     // 텍스트 크기 계산
//     final double userInfoCardViewTitleFontSize =
//         screenSize.height * (18 / referenceHeight); // 텍스트 크기 비율 계산
//
//     // 회원정보 수정 버튼과 로그아웃 버튼의 가로, 세로 비율 계산
//     final double uesrInfoModifyBtn1X =
//         screenSize.width * (115 / referenceWidth); // 수정 버튼 가로 비율 계산
//     final double uesrInfoModifyBtn1Y =
//         screenSize.height * (45 / referenceHeight); // 수정 버튼 세로 비율 계산
//     final double uesrInfoModifyBtnFontSize =
//         screenSize.height * (14 / referenceHeight); // 수정 버튼 텍스트 크기 비율 계산
//     final double uesrInfoModifyBtnPaddingX = screenSize.width * (12 / referenceWidth); // 수정 버튼 좌우 패딩 계산
//     final double uesrInfoModifyBtnPaddingY = screenSize.height * (5 / referenceHeight); // 수정 버튼 상하 패딩 계산
//     final double logoutBtn1X =
//         screenSize.width * (95 / referenceWidth); // 로그아웃 버튼 가로 비율 계산
//     final double logoutBtn1Y =
//         screenSize.height * (45 / referenceHeight); // 로그아웃 버튼 세로 비율 계산
//     final double logoutBtnFontSize =
//         screenSize.height * (14 / referenceHeight); // 로그아웃 버튼 텍스트 크기 비율 계산
//     final double logoutBtnPaddingX = screenSize.width * (12 / referenceWidth); // 로그아웃 버튼 좌우 패딩 계산
//     final double logoutBtnPaddingY = screenSize.height * (5 / referenceHeight); // 로그아웃 버튼 상하 패딩 계산
//
//     // 회원정보 카드뷰 섹션 내 컨텐츠 사이의 간격 계산
//     final double interval1Y = screenSize.height * (8 / referenceHeight); // 세로 간격 1 계산
//     final double interval2Y = screenSize.height * (6 / referenceHeight); // 세로 간격 2 계산
//     final double interval3Y = screenSize.height * (12 / referenceHeight); // 세로 간격 3 계산
//     final double interval1X = screenSize.width * (80 / referenceWidth); // 가로 간격 1 계산
//     final double interval2X = screenSize.width * (10 / referenceWidth); // 가로 간격 2 계산
//     final double interval3X = screenSize.width * (120 / referenceWidth); // 가로 간격 3 계산
//
//     // 에러 관련 텍스트 수치
//     final double errorTextFontSize1 = screenSize.height * (14 / referenceHeight);
//     final double errorTextFontSize2 = screenSize.height * (12 / referenceHeight);
//     final double errorTextHeight = screenSize.height * (600 / referenceHeight);
//
//     final userInfoAsyncValue = ref.watch(userInfoProvider(email)); // userInfoProvider를 통해 유저 정보를 가져옴
//
//     return userInfoAsyncValue.when( // 유저 정보의 상태에 따라 반환할 위젯을 설정함
//       data: (userInfo) { // 데이터가 로드되었을 경우 실행됨
//         final name = userInfo?['name'] ?? ''; // 이름 정보를 가져오고, 없으면 ''로 설정함
//         final email = userInfo?['email'] ?? ''; // 이메일 정보를 가져오고, 없으면 ''로 설정함
//         final phoneNumber = userInfo?['phone_number'] ?? ''; // 전화번호 정보를 가져오고, 없으면 ''로 설정함
//
//           return Container(
//             width: uesrInfoCardViewWidth, // 카드뷰 가로 크기 설정
//             height: uesrInfoCardViewHeight, // 카드뷰 세로 크기 설정
//             // color: Theme.of(context).scaffoldBackgroundColor, // 배경색 설정
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
//               ),
//             ),
//             child: CommonCardView( // 공통 카드뷰 위젯 사용
//               backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 배경색 설정
//               elevation: 0, // 그림자 깊이 설정
//               content: Padding( // 패딩 설정
//                 padding: EdgeInsets.symmetric(vertical: uesrInfoCardViewPadding1Y, horizontal: uesrInfoCardViewPaddingX), // 상하 좌우 패딩 설정
//                 child: Column( // 컬럼 위젯으로 구성함
//                   crossAxisAlignment: CrossAxisAlignment.start, // 시작 위치에서 정렬함
//                   children: [
//                     Text( // 텍스트 위젯으로 회원정보 타이틀을 표시함
//                       '회원정보', // 회원정보 텍스트 설정
//                       style: TextStyle(
//                         fontSize: userInfoCardViewTitleFontSize, // 텍스트 크기 설정
//                         fontWeight: FontWeight.bold, // 텍스트 굵기 설정
//                         fontFamily: 'NanumGothic', // 글꼴 설정
//                         color: BLACK_COLOR, // 텍스트 색상 설정
//                       ),
//                     ),
//                     SizedBox(height: interval1Y), // 간격 설정
//                     _buildUserInfoRow(context, '고객명', name), // 이름 정보 행 생성
//                     SizedBox(height: interval2Y), // 간격 설정
//                     _buildUserInfoRow(context, '이메일', email), // 이메일 정보 행 생성
//                     SizedBox(height: interval2Y), // 간격 설정
//                     _buildUserInfoRow(context, '연락처', phoneNumber), // 전화번호 정보 행 생성
//                     SizedBox(height: interval3Y), // 간격 설정
//                     // 회원정보 수정 및 로그아웃 버튼을 행(Row)으로 배치함
//                     Row(
//                       children: [
//                         Container(
//                           width: uesrInfoModifyBtn1X, // 회원정보 수정 버튼 가로 설정
//                           height: uesrInfoModifyBtn1Y, // 회원정보 수정 버튼 세로 설정
//                           // margin: EdgeInsets.only(left: interval3X), // 왼쪽 여백 설정
//                           child: ElevatedButton( // ElevatedButton 위젯을 사용하여 수정 버튼을 만듦
//                             onPressed: () async { // 클릭 시 실행되는 비동기 함수 설정
//                               const url = 'https://pf.kakao.com/_xjVrbG'; // 수정 링크 설정
//                               if (await canLaunchUrl(Uri.parse(url))) { // URL을 열 수 있는지 확인함
//                                 await launchUrl(Uri.parse(url)); // URL을 열음
//                               } else {
//                                 throw 'Could not launch $url'; // URL을 열 수 없을 경우 오류 발생
//                               }
//                             },
//                             style: ElevatedButton.styleFrom( // 버튼 스타일 설정
//                               foregroundColor: ORANGE56_COLOR, // 텍스트 색상 설정
//                               backgroundColor: ORANGE56_COLOR, // 버튼 배경색 설정
//                               padding: EdgeInsets.symmetric(vertical: uesrInfoModifyBtnPaddingY, horizontal: uesrInfoModifyBtnPaddingX), // 패딩 설정
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(45), // 모서리 둥글게 설정
//                               ),
//                             ),
//                             child: Text('회원정보 수정', // 버튼 텍스트 설정
//                               style: TextStyle(
//                                 fontSize: uesrInfoModifyBtnFontSize, // 텍스트 크기 설정
//                                 fontWeight: FontWeight.bold, // 텍스트 굵기 설정
//                                 fontFamily: 'NanumGothic', // 글꼴 설정
//                                 color: WHITE_COLOR, // 텍스트 색상 설정
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           width: logoutBtn1X, // 로그아웃 버튼 가로 설정
//                           height: logoutBtn1Y, // 로그아웃 버튼 세로 설정
//                           margin: EdgeInsets.only(left: interval2X), // 왼쪽 여백 설정
//                           child: ElevatedButton( // ElevatedButton 위젯을 사용하여 로그아웃 버튼을 만듦
//                             onPressed: () async { // 클릭 시 비동기 로그아웃 처리 함수 실행
//                               await logoutAndLoginAfterProviderReset(ref); // 로그아웃 처리 및 프로바이더 리셋
//                               Navigator.of(context).pushReplacement( // 화면 전환
//                                 MaterialPageRoute(builder: (_) => LoginScreen()), // 로그인 화면으로 전환
//                               );
//                             },
//                             style: ElevatedButton.styleFrom( // 버튼 스타일 설정
//                               foregroundColor: ORANGE56_COLOR, // 텍스트 색상 설정
//                               backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 버튼 배경색을 앱 배경색으로 설정
//                               side: BorderSide(color: ORANGE56_COLOR,
//                               ), // 버튼 테두리 색상 설정
//                               padding: EdgeInsets.symmetric(vertical: logoutBtnPaddingY, horizontal: logoutBtnPaddingX), // 패딩 설정
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(45), // 모서리 둥글게 설정
//                               ),
//                             ),
//                             child: Text('로그아웃', // 버튼 텍스트 설정
//                               style: TextStyle(
//                                 fontSize: logoutBtnFontSize, // 텍스트 크기 설정
//                                 fontWeight: FontWeight.bold, // 텍스트 굵기 설정
//                                 fontFamily: 'NanumGothic', // 글꼴 설정
//                                 color: ORANGE56_COLOR, // 텍스트 색상 설정
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         );
//       },
//       loading: () => buildCommonLoadingIndicator(), // 공통 로딩 인디케이터 호출
//       error: (error, stack) => Container( // 에러 상태에서 중앙 배치
//         height: errorTextHeight, // 전체 화면 높이 설정
//         alignment: Alignment.center, // 중앙 정렬
//         child: buildCommonErrorIndicator(
//           message: '에러가 발생했으니, 앱을 재실행해주세요.', // 첫 번째 메시지 설정
//           secondMessage: '에러가 반복될 시, \'문의하기\'에서 문의해주세요.', // 두 번째 메시지 설정
//           fontSize1: errorTextFontSize1, // 폰트1 크기 설정
//           fontSize2: errorTextFontSize2, // 폰트2 크기 설정
//           color: BLACK_COLOR, // 색상 설정
//           showSecondMessage: true, // 두 번째 메시지를 표시하도록 설정
//         ),
//       ),
//     );
//   }
//
//   // 사용자 정보 행을 구성하는 메서드
//   Widget _buildUserInfoRow(BuildContext context, String label, String value) {
//     final Size screenSize = MediaQuery.of(context).size; // 기기 화면 크기 가져옴
//     final double referenceHeight = 852.0; // 기준 화면 높이 설정
//     final double uesrInfoTextFontSize =
//         screenSize.height * (15 / referenceHeight); // 텍스트 크기 비율 계산
//
//     return Row( // 행을 구성하는 위젯 생성
//       children: [
//         Text( // 레이블 텍스트 위젯
//           '$label: ', // 레이블 텍스트 설정
//           style: TextStyle(
//             fontSize: uesrInfoTextFontSize, // 레이블 텍스트 크기 설정
//             fontWeight: FontWeight.bold, // 텍스트 굵기 설정
//             fontFamily: 'NanumGothic', // 글꼴 설정
//             color: GRAY41_COLOR, // 색상 설정
//           ),
//         ),
//         Expanded( // 남은 공간을 차지하는 위젯
//           child: Text(value ?? ''), // 유저 정보 텍스트 표시
//         ),
//       ],
//     );
//   }
// }
// // ------- 마이페이지 화면 내 회원정보 관련 데이터를 파이어베이스에서 불러와서 UI로 구현하는 UserProfileInfo 클래스 내용 끝 부분


// ------- 마이페이지 화면 내 회원정보 관련 데이터를 파이어베이스에서 불러와서 UI로 구현하는 UserProfileInfo 클래스 내용 시작 부분
class UserProfileInfo extends ConsumerWidget { // ConsumerWidget을 상속받아 UserProfileInfo 클래스를 정의

  UserProfileInfo(); // 생성자를 초기화

  @override
  Widget build(BuildContext context, WidgetRef ref) { // build 메서드 정의
    // build 메서드를 정의하여 위젯 트리를 구성함
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기 설정 (가로 393, 세로 852)
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 마이페이지 회원정보 카드뷰 섹션의 가로와 세로 비율 계산
    final double uesrInfoCardViewWidth =
        screenSize.width * (393 / referenceWidth); // 가로 비율 계산
    final double uesrInfoCardViewHeight =
        screenSize.height * (220 / referenceHeight); // 세로 비율 계산

    // body 부분 전체 패딩 수치 계산
    final double uesrInfoCardViewPaddingX = screenSize.width * (15 / referenceWidth); // 좌우 패딩 계산
    final double uesrInfoCardViewPadding1Y = screenSize.height * (8 / referenceHeight); // 상하 패딩 계산

    // 텍스트 크기 계산
    final double userInfoCardViewTitleFontSize =
        screenSize.height * (18 / referenceHeight); // 텍스트 크기 비율 계산
    final double userInfoCardViewGuideTextFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산

    // 로그인 및 회원가입 버튼과 로그아웃 버튼의 가로, 세로 비율 계산
    final double logoutBtnX =
        screenSize.width * (110 / referenceWidth); // 로그아웃 버튼 가로 비율 계산
    final double logoutBtnY =
        screenSize.height * (45 / referenceHeight); // 로그아웃 버튼 세로 비율 계산
    final double loginAndJoinBtnX =
        screenSize.width * (160 / referenceWidth); // 로그인 및 회원가입 버튼 가로 비율 계산
    final double loginAndJoinBtnY =
        screenSize.height * (45 / referenceHeight); // 로그인 및 회원가입 버튼 세로 비율 계산

    // 회원정보 카드뷰 섹션 내 컨텐츠 사이의 간격 계산
    final double interval1Y = screenSize.height * (8 / referenceHeight); // 세로 간격 1 계산
    final double interval2Y = screenSize.height * (6 / referenceHeight); // 세로 간격 2 계산
    final double interval3Y = screenSize.height * (12 / referenceHeight); // 세로 간격 3 계산
    final double interval4Y = screenSize.height * (20 / referenceHeight); // 세로 간격 4 계산
    final double interval1X = screenSize.width * (80 / referenceWidth); // 가로 간격 1 계산
    final double interval2X = screenSize.width * (10 / referenceWidth); // 가로 간격 2 계산
    final double interval3X = screenSize.width * (120 / referenceWidth); // 가로 간격 3 계산

    // 에러 관련 텍스트 수치
    final double errorTextFontSize1 = screenSize.height * (14 / referenceHeight);
    final double errorTextFontSize2 = screenSize.height * (12 / referenceHeight);
    final double errorTextHeight = screenSize.height * (600 / referenceHeight);

    // FirebaseAuth를 사용하여 현재 로그인 상태를 확인
    final user = FirebaseAuth.instance.currentUser;

    // 이메일 정보를 FirebaseAuth에서 가져와 Firestore 데이터를 가져오는 데 사용.
    final userInfoAsyncValue = ref.watch(profileUserInfoProvider(user?.email ?? ''));

    return userInfoAsyncValue.when( // 유저 정보의 상태에 따라 반환할 위젯을 설정함
      data: (userInfo) { // 데이터가 로드되었을 경우 실행됨
        final name = userInfo?['name'] ?? ''; // 이름 정보를 가져오고, 없으면 ''로 설정함
        final email = userInfo?['email'] ?? ''; // 이메일 정보를 가져오고, 없으면 ''로 설정함
        final phoneNumber = userInfo?['phone_number'] ?? ''; // 전화번호 정보를 가져오고, 없으면 ''로 설정함

        return Container(
          width: uesrInfoCardViewWidth, // 카드뷰 가로 크기 설정
          // height: uesrInfoCardViewHeight, // 카드뷰 세로 크기 설정
          // color: Theme.of(context).scaffoldBackgroundColor, // 배경색 설정
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
            ),
          ),
          child: CommonCardView( // 공통 카드뷰 위젯 사용
            backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 배경색 설정
            elevation: 0, // 그림자 깊이 설정
            content: Padding( // 패딩 설정
              padding: EdgeInsets.symmetric(vertical: uesrInfoCardViewPadding1Y, horizontal: uesrInfoCardViewPaddingX), // 상하 좌우 패딩 설정
              child: Column( // 컬럼 위젯으로 구성함
                crossAxisAlignment: CrossAxisAlignment.start, // 시작 위치에서 정렬함
                children: [
                  Text( // 텍스트 위젯으로 회원정보 타이틀을 표시함
                    '회원정보', // 회원정보 텍스트 설정
                    style: TextStyle(
                      fontSize: userInfoCardViewTitleFontSize, // 텍스트 크기 설정
                      fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                      fontFamily: 'NanumGothic', // 글꼴 설정
                      color: BLACK_COLOR, // 텍스트 색상 설정
                    ),
                  ),
                  SizedBox(height: interval1Y), // 간격 설정
                  if (user != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUserInfoRow(context, '고객명', name),
                        SizedBox(height: interval2Y),
                        _buildUserInfoRow(context, '이메일', email),
                        SizedBox(height: interval2Y),
                        _buildUserInfoRow(context, '연락처', phoneNumber),
                        SizedBox(height: interval3Y),
                        // 로그아웃 버튼만 표시
                        _buildActionButton(
                          context,
                          '로그아웃',
                          Theme.of(context).scaffoldBackgroundColor,
                          ORANGE56_COLOR,
                          logoutBtnX,
                          logoutBtnY,
                              () async {
                            await logoutAndLoginAfterProviderReset(ref);
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => ProfileMainScreen()),
                                  (Route<dynamic> route) => false,
                            );
                            showCustomSnackBar(context, '로그아웃이 되었습니다.');
                          },
                          borderColor: ORANGE56_COLOR,
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: interval2Y),
                        Container(
                          child: Text(
                            "로그인 후 이용해주세요.",
                            style: TextStyle(
                              fontSize: userInfoCardViewGuideTextFontSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NanumGothic',
                              color: GRAY41_COLOR,
                            ),
                          ),
                        ),
                        SizedBox(height: interval3Y),
                        // 로그인 및 회원가입 버튼 표시
                        _buildActionButton(
                          context,
                          '로그인 및 회원가입',
                          ORANGE56_COLOR,
                          WHITE_COLOR,
                          loginAndJoinBtnX,
                          loginAndJoinBtnY,
                              // () {
                              () async {
                            await logoutAndLoginAfterProviderReset(ref);
                                // 해당 간편 로그인 화면으로 이동하는 로직은 간편 로그인 화면 내 '닫기' 버튼을 클릭 시,
                                // 마이페이지 화면으로 복귀해야하므로 Navigator.pushReplacement 대신 Navigator.of(context).push를 사용
                                // Navigator.pushReplacement를 사용하면 이전 화면 스택을 제거하는 것이고, Navigator.of(context).push를 사용하면 이전 스택이 남는 것
                                // IOS 플랫폼은 IOS 화면으로 이동
                                if (Platform.isIOS) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => EasyLoginIosScreen()),
                                  );
                                  // AOS 플랫폼은 AOS 화면으로 이동
                                } else if (Platform.isAndroid) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => EasyLoginAosScreen()),
                                  );
                                } else {
                                  // 기타 플랫폼은 기본적으로 AOS 화면으로 이동
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => EasyLoginAosScreen()),
                                  );
                                }
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => buildCommonLoadingIndicator(), // 공통 로딩 인디케이터 호출
      error: (error, stack) => Container( // 에러 상태에서 중앙 배치
        height: errorTextHeight, // 전체 화면 높이 설정
        alignment: Alignment.center, // 중앙 정렬
        child: buildCommonErrorIndicator(
          message: '에러가 발생했으니, 앱을 재실행해주세요.', // 첫 번째 메시지 설정
          secondMessage: '에러가 반복될 시, \'문의하기\'에서 문의해주세요.', // 두 번째 메시지 설정
          fontSize1: errorTextFontSize1, // 폰트1 크기 설정
          fontSize2: errorTextFontSize2, // 폰트2 크기 설정
          color: BLACK_COLOR, // 색상 설정
          showSecondMessage: true, // 두 번째 메시지를 표시하도록 설정
        ),
      ),
    );
  }

  // 회원정보 내 '로그인 및 회원가입'과 '로그아웃' 버튼의 UI 관련 메서드
  Widget _buildActionButton(
      BuildContext context,
      String text,
      Color bgColor,
      Color textColor,
      double width,
      double height,
      VoidCallback onPressed, {
        Color? borderColor,
      }) {

    final Size screenSize = MediaQuery.of(context).size; // 기기 화면 크기 가져옴
    final double referenceHeight = 852.0; // 기준 화면 높이 설정
    final double actionBtnTextFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산

    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: actionBtnTextFontSize,
            fontWeight: FontWeight.bold,
            fontFamily: 'NanumGothic',
          ),
        ),
      ),
    );
  }

  // 사용자 정보 행을 구성하는 메서드
  Widget _buildUserInfoRow(BuildContext context, String label, String value) {
    final Size screenSize = MediaQuery.of(context).size; // 기기 화면 크기 가져옴
    final double referenceHeight = 852.0; // 기준 화면 높이 설정
    final double uesrInfoTextFontSize =
        screenSize.height * (15 / referenceHeight); // 텍스트 크기 비율 계산

    return Row( // 행을 구성하는 위젯 생성
      children: [
        Text( // 레이블 텍스트 위젯
          '$label: ', // 레이블 텍스트 설정
          style: TextStyle(
            fontSize: uesrInfoTextFontSize, // 레이블 텍스트 크기 설정
            fontWeight: FontWeight.bold, // 텍스트 굵기 설정
            fontFamily: 'NanumGothic', // 글꼴 설정
            color: GRAY41_COLOR, // 색상 설정
          ),
        ),
        Expanded( // 남은 공간을 차지하는 위젯
          child: Text(value ?? ''), // 유저 정보 텍스트 표시
        ),
      ],
    );
  }
}
// ------- 마이페이지 화면 내 회원정보 관련 데이터를 파이어베이스에서 불러와서 UI로 구현하는 UserProfileInfo 클래스 내용 끝 부분

// ------- 마이페이지 화면 내 리뷰 관리 ~ 문의하기 관련 옵션 선택 UI 구현하는 UserProfileOptions 클래스 내용 시작 부분
class UserProfileOptions extends ConsumerWidget { // ConsumerWidget을 상속받아 UserProfileOptions 클래스를 정의

  UserProfileOptions();

  @override
  Widget build(BuildContext context, WidgetRef ref) { // build 메서드 정의

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기 설정 (가로 393, 세로 852)
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 마이페이지 회원정보 카드뷰 섹션의 가로와 세로 비율 계산
    final double uesrProfileOptionsCardViewWidth =
        screenSize.width * (393 / referenceWidth); // 가로 비율 계산
    final double uesrProfileOptionsCardViewHeight =
        screenSize.height * (450 / referenceHeight); // 세로 비율 계산

    return Container(
      width: uesrProfileOptionsCardViewWidth, // 카드뷰의 가로 크기 설정
      height: uesrProfileOptionsCardViewHeight, // 카드뷰의 세로 크기 설정
      child: CommonCardView( // CommonCardView 위젯 반환
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색으로 설정함
        elevation: 0, // 그림자 깊이를 설정하지 않음
        content: Padding(
          padding: EdgeInsets.zero, // 패딩을 0으로 설정함
          child: Column( // 컬럼 위젯을 사용하여 UI 요소를 세로로 나열함
            children: [
              _buildOptionTile( // 옵션 타일 생성
                context,
                assetPath: 'asset/img/misc/icon_img/reviewlist_icon.png', // 리뷰관리 아이콘 설정
                title: '리뷰관리', // 제목 설정
                onTap: () { // 클릭 시 실행될 함수
                  onReviewListClick(context, ref); // 리뷰 목록 클릭 함수 실행
                },
              ),
              _buildOptionTile( // 옵션 타일 생성
                  context,
                  assetPath: 'asset/img/misc/icon_img/messagelist_icon.png', // 쪽지함 아이콘 설정
                  title: '쪽지함', // 제목 설정
                  onTap: () { // 클릭 시 실행될 함수
                    onMessageListClick(context, ref); // 메시지 목록 클릭 함수 실행
                  },
                ),
                _buildOptionTile( // 옵션 타일 생성
                  context,
                  assetPath: 'asset/img/misc/icon_img/orderlist_icon.png', // 발주내역 아이콘 설정
                  title: '발주내역', // 발주내역 타이틀 설정
                  onTap: () { // 클릭 시 실행될 함수 설정
                    onOrderListClick(context, ref); // 발주내역 클릭 시 호출되는 함수 실행
                  },
                ),
                _buildOptionTile( // 옵션 타일 생성
                  context,
                  assetPath: 'asset/img/misc/icon_img/wishlist_icon.png', // 찜 목록 아이콘 설정
                  title: '찜 목록', // 찜 목록 타이틀 설정
                  onTap: () { // 클릭 시 실행될 함수 설정
                    onWishListClick(context, ref); // 찜 목록 클릭 시 호출되는 함수 실행
                  },
                ),
                _buildOptionTile( // 옵션 타일 생성
                  context,
                  assetPath: 'asset/img/misc/icon_img/announcelist_icon.png', // 공지사항 아이콘 설정
                  title: '공지사항', // 공지사항 타이틀 설정
                  onTap: () { // 클릭 시 실행될 함수 설정
                    onAnnounceListClick(context, ref); // 공지사항 클릭 시 호출되는 함수 실행
                  },
                ),
                _buildOptionTile( // 옵션 타일 생성
                  context,
                  assetPath: 'asset/img/misc/icon_img/inquiry_icon.png', // 문의하기 아이콘 설정
                  title: '문의하기', // 문의하기 타이틀 설정
                  onTap: () { // 클릭 시 실행될 함수 설정
                    onInquiryListClick(context, ref); // 문의하기 클릭 시 호출되는 함수 실행
                  },
                ),
                _buildOptionTile( // 옵션 타일 생성
                  context,
                  assetPath: 'asset/img/misc/icon_img/inquiry_icon.png', // 회원정보 수정 아이콘 설정
                  title: '회원정보 수정 및 탈퇴', // 회원정보 수정 타이틀 설정
                  onTap: () { // 클릭 시 실행될 함수 설정
                    onUserInfoModifyListClick(context, ref); // 회원정보 수정 클릭 시 호출되는 함수 실행
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // 각 선택 옵션마다의 회색 구분선 및 제목 UI 관련 _buildOptionTile 위젯 내용
  Widget _buildOptionTile(BuildContext context,
      {required String assetPath, required String title, required Function() onTap}) { // 옵션 타일을 생성하는 함수

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 마이페이지 옵션 버튼 크기 비율 계산
    final double userProfileOptionsHeight = screenSize.height * (60 / referenceHeight); // 버튼 높이 계산
    final double interval1X = screenSize.width * (12 / referenceWidth); // 아이콘과 텍스트 사이의 간격 계산
    final double interval2X = screenSize.width * (8 / referenceWidth); // 텍스트와 화살표 사이의 간격 계산
    final double interval3X = screenSize.width * (20 / referenceWidth); // 아이콘과 좌측 사이의 간격 계산
    final double interval4X = screenSize.width * (30 / referenceWidth); // 아이콘과 좌측 사이의 간격 계산


    // 마이페이지 옵션 버튼 내 구분선 부분 수치 계산
    final double uesrProfileOptionsDividerWidth =
        screenSize.width * (393 / referenceWidth); // 구분선 가로 길이 계산
    final double uesrProfileOptionsDividerHeight =
        screenSize.height * (1 / referenceHeight); // 구분선 세로 길이 계산

    // 아이콘 크기 관련 수치 계산
    final double iconImageWidth = screenSize.width * (24 / referenceWidth); // 아이콘 가로 크기 계산
    final double iconImageHeight = screenSize.width * (24 / referenceWidth); // 아이콘 세로 크기 계산
    final double iconTextFontSize =
        screenSize.height * (15 / referenceHeight); // 아이콘 텍스트 크기 계산
    final double chevronBtnImageWidth = screenSize.width * (10 / referenceWidth); // 화살표 이미지 가로 크기 계산
    final double chevronBtnImageHeight = screenSize.width * (24 / referenceWidth); // 화살표 이미지 세로 크기 계산
    final double optionTitleY = screenSize.height * (10 / referenceHeight); // 타이틀 상하 패딩 계산

    return Column( // 컬럼 위젯으로 UI를 구성함
      children: [
        GestureDetector( // GestureDetector 위젯을 사용하여 클릭 이벤트를 처리함
          onTap: onTap, // 클릭 시 실행될 함수 설정
          child: Container( // 옵션 타일을 감싸는 컨테이너 생성
            height: userProfileOptionsHeight, // 옵션 타일의 높이 설정
            // color: Colors.transparent, // 배경색을 투명하게 설정하여 클릭 가능하게 만듦
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: optionTitleY), // 상하 패딩 설정
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
              ),
            ),
            child: Row( // 아이콘, 타이틀, 화살표 이미지를 한 줄로 배치함
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 요소들을 양 끝으로 배치함
              children: [
                Row( // 아이콘과 타이틀을 한 줄로 배치함
                  children: [
                    SizedBox(width: interval4X), // 아이콘 왼쪽 여백 설정
                    Image.asset( // 아이콘 이미지를 불러옴
                      assetPath, // 아이콘 경로 설정
                      width: iconImageWidth, // 아이콘 가로 크기 설정
                      height: iconImageHeight, // 아이콘 세로 크기 설정
                    ),
                    SizedBox(width: interval1X), // 아이콘과 텍스트 사이의 간격 설정
                    Text(title, // 타이틀 텍스트 설정
                      style: TextStyle(
                        fontSize: iconTextFontSize, // 텍스트 크기 설정
                        fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                        fontFamily: 'NanumGothic', // 글꼴 설정
                        color: BLACK_COLOR, // 텍스트 색상 설정
                      ),
                    ),
                  ],
                ),
                Padding( // 텍스트 오른쪽에 화살표 이미지를 배치함
                  padding: EdgeInsets.only(right: interval3X), // 오른쪽 여백 설정
                  child: Image.asset( // 화살표 이미지 설정
                    'asset/img/misc/icon_img/chevron_right.png', // 화살표 이미지 경로 설정
                    width: chevronBtnImageWidth, // 화살표 가로 크기 설정
                    height: chevronBtnImageHeight, // 화살표 세로 크기 설정
                  ),
                ),
              ],
            ),
          ),
        ),
        // Container( // 옵션 타일 아래에 구분선 컨테이너를 생성함
        //   width: uesrProfileOptionsDividerWidth, // 구분선 가로 길이 설정
        //   height: uesrProfileOptionsDividerHeight, // 구분선 세로 높이 설정
        //   color: Colors.black, // 구분선 색상 설정
        // ),
      ],
    );
  }

  // ------ 각 옵션마다 클릭 시, 각 해당 화면으로 이동하는 로직 시작 부분
  // (navigateToScreenAndRemoveUntil 재사용하여 해당 화면의 스택을 삭제하고 이동하니 이전화면으로 이동 버튼이 자동 생성되는 것을 방지!!)
  void onOrderListClick(BuildContext context, WidgetRef ref) { // 주문 목록 클릭 함수
    navigateToScreenAndRemoveUntil(context, ref, OrderListMainScreen(), 2); // 화면 이동 함수 호출
  }

  void onWishListClick(BuildContext context, WidgetRef ref) { // 찜 목록 클릭 함수
    navigateToScreenAndRemoveUntil(context, ref, WishlistMainScreen(), 4); // 화면 이동 함수 호출
  }

  void onReviewListClick(BuildContext context, WidgetRef ref) { // 리뷰 목록 클릭 함수
    navigateToScreenAndRemoveUntil(context, ref, PrivateReviewMainScreen(), 4); // 화면 이동 함수 호출
  }

  void onMessageListClick(BuildContext context, WidgetRef ref) { // 메시지 목록 클릭 함수
    navigateToScreenAndRemoveUntil(context, ref, PrivateMessageMainScreen(), 4); // 화면 이동 함수 호출
  }

  void onAnnounceListClick(BuildContext context, WidgetRef ref) { // 공지사항 클릭 함수
    navigateToScreenAndRemoveUntil(context, ref, AnnounceMainScreen(), 4); // 화면 이동 함수 호출
  }

  void onInquiryListClick(BuildContext context, WidgetRef ref) { // 문의 클릭 함수
    navigateToScreenAndRemoveUntil(context, ref, InquiryMainScreen(), 4); // 화면 이동 함수 호출
  }

  void onUserInfoModifyListClick(BuildContext context, WidgetRef ref) { // 회원정보 수정 클릭 함수
    navigateToScreenAndRemoveUntil(context, ref, UserInfoModifyScreen(), 4); // 화면 이동 함수 호출
  }
}
// ------ 각 옵션마다 클릭 시, 각 해당 화면으로 이동하는 로직 끝 부분
// ------- 마이페이지 화면 내 리뷰 관리 ~ 문의하기 관련 옵션 선택 UI 구현하는 UserProfileOptions 위젯 내용 끝 부분
