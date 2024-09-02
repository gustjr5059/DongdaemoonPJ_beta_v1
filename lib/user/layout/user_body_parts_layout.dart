import 'package:flutter/material.dart'; // 플러터 Material 디자인 패키지를 가져옴
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 플러터 Riverpod 패키지를 가져옴
import 'package:url_launcher/url_launcher.dart'; // URL을 열기 위한 패키지를 가져옴
import '../../announcement/view/announce_screen.dart'; // 공지사항 화면을 가져옴
import '../../common/const/colors.dart'; // 공통 색상 상수를 가져옴
import '../../common/layout/common_body_parts_layout.dart'; // 공통 레이아웃을 가져옴
import '../../common/layout/common_exception_parts_of_body_layout.dart'; // 공통 예외 처리 레이아웃을 가져옴
import '../../inquiry/view/inquiry_screen.dart'; // 문의 화면을 가져옴
import '../../message/view/message_screen.dart'; // 메시지 화면을 가져옴
import '../../order/provider/order_all_providers.dart'; // 주문 관련 프로바이더를 가져옴
import '../../order/view/order_list_screen.dart'; // 주문 목록 화면을 가져옴
import '../../product/layout/product_body_parts_layout.dart'; // 제품 관련 레이아웃을 가져옴
import '../../wishlist/view/wishlist_screen.dart'; // 찜 목록 화면을 가져옴
import '../view/login_screen.dart'; // 로그인 화면을 가져옴


// ------- 마이페이지 화면 내 회원정보 관련 데이터를 파이어베이스에서 불러와서 UI로 구현하는 UserProfileInfo 클래스 내용 시작 부분
class UserProfileInfo extends ConsumerWidget { // ConsumerWidget을 상속받아 UserProfileInfo 클래스를 정의
  final String email; // 이메일 필드를 선언

  UserProfileInfo({required this.email}); // 생성자를 통해 이메일 필드를 초기화

  @override
  Widget build(BuildContext context, WidgetRef ref) { // build 메서드 정의
    final userInfoAsyncValue = ref.watch(userInfoProvider(email)); // userInfoProvider를 통해 유저 정보를 가져옴

    return userInfoAsyncValue.when( // 유저 정보의 상태에 따라 다른 위젯을 반환
      data: (userInfo) { // 데이터가 있을 경우
        final name = userInfo?['name'] ?? '-'; // 이름을 가져오고 없으면 '-'로 설정
        final email = userInfo?['email'] ?? '-'; // 이메일을 가져오고 없으면 '-'로 설정
        final phoneNumber = userInfo?['phone_number'] ?? '-'; // 전화번호를 가져오고 없으면 '-'로 설정

        return CommonCardView( // CommonCardView 위젯 반환
          backgroundColor: BEIGE_COLOR, // 배경색 설정
          content: Padding( // 패딩 설정
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10), // 수직, 수평 패딩 설정
            child: Column( // 컬럼 위젯으로 구성
              crossAxisAlignment: CrossAxisAlignment.start, // 시작 지점 정렬
              children: [
                Text( // 텍스트 위젯
                  '회원정보', // 텍스트 내용
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // 텍스트 스타일 설정
                ),
                SizedBox(height: 12), // 간격 설정
                _buildUserInfoRow('고객명', name), // 이름 정보 행 추가
                _buildUserInfoRow('이메일', email), // 이메일 정보 행 추가
                _buildUserInfoRow('연락처', phoneNumber), // 연락처 정보 행 추가
                SizedBox(height: 6), // 간격 설정
                Row( // 행 위젯으로 구성
                  children: [
                    ElevatedButton( // ElevatedButton 위젯
                      onPressed: () async { // 버튼 클릭 시 비동기 함수 실행
                        const url = 'https://pf.kakao.com/_xjVrbG'; // URL 설정
                        if (await canLaunchUrl(Uri.parse(url))) { // URL이 열릴 수 있는지 확인
                          await launchUrl(Uri.parse(url)); // URL 열기
                        } else {
                          throw 'Could not launch $url'; // 오류 발생 시 메시지 출력
                        }
                      },
                      style: ElevatedButton.styleFrom( // 버튼 스타일 설정
                        foregroundColor: BUTTON_COLOR, // 전경색 설정
                        backgroundColor: BACKGROUND_COLOR, // 배경색 설정
                        side: BorderSide(color: BUTTON_COLOR), // 버튼 테두리 설정
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10), // 패딩 설정
                      ),
                      child: Text('회원정보 수정', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), // 버튼 텍스트 설정
                    ),
                    SizedBox(width: 10), // 간격 설정
                    ElevatedButton( // ElevatedButton 위젯
                      onPressed: () async { // 버튼 클릭 시 비동기 함수 실행
                        // 로그아웃 처리
                        await logoutAndLoginAfterProviderReset(ref); // 로그아웃 처리 및 프로바이더 리셋
                        // 로그인 화면으로 이동
                        Navigator.of(context).pushReplacement( // 화면 이동
                          MaterialPageRoute(builder: (_) => LoginScreen()), // 로그인 화면으로 이동
                        );
                      },
                      style: ElevatedButton.styleFrom( // 버튼 스타일 설정
                        foregroundColor: BUTTON_COLOR, // 전경색 설정
                        backgroundColor: BACKGROUND_COLOR, // 배경색 설정
                        side: BorderSide(color: BUTTON_COLOR), // 버튼 테두리 설정
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10), // 패딩 설정
                      ),
                      child: Text('로그아웃', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), // 버튼 텍스트 설정
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()), // 로딩 중일 때 로딩 위젯 표시
      error: (error, stack) => Center(child: Text('Error: $error')), // 오류 발생 시 오류 메시지 표시
    );
  }

  Widget _buildUserInfoRow(String label, String value) { // 사용자 정보 행을 구성하는 위젯
    return Padding( // 패딩 설정
      padding: const EdgeInsets.symmetric(vertical: 4.0), // 수직 패딩 설정
      child: Row( // 행 위젯으로 구성
        children: [
          Text( // 텍스트 위젯
            '$label: ', // 레이블 텍스트
            style: TextStyle(fontWeight: FontWeight.bold), // 텍스트 스타일 설정
          ),
          Expanded( // 남은 공간을 차지하는 위젯
            child: Text(value), // 값 텍스트
          ),
        ],
      ),
    );
  }
}
// ------- 마이페이지 화면 내 회원정보 관련 데이터를 파이어베이스에서 불러와서 UI로 구현하는 UserProfileInfo 클래스 내용 끝 부분

// ------- 마이페이지 화면 내 발주내역 관리 ~ 문의하기 관련 옵션 선택 UI 구현하는 UserProfileOptions 클래스 내용 시작 부분
class UserProfileOptions extends ConsumerWidget { // ConsumerWidget을 상속받아 UserProfileOptions 클래스를 정의
  final String email;

  UserProfileOptions({required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // build 메서드 정의
    return CommonCardView( // CommonCardView 위젯 반환
      backgroundColor: BEIGE_COLOR, // 배경색 설정
      content: Column( // 컬럼 위젯으로 구성
        children: [
          _buildOptionTile( // 옵션 타일 생성
            context,
            icon: Icons.receipt_long_outlined, // 아이콘 설정
            title: '발주내역', // 제목 설정
            onTap: () { // 클릭 시 실행될 함수
              onOrderListClick(context, ref); // 주문 목록 클릭 함수 실행
            },
          ),
          _buildOptionTile( // 옵션 타일 생성
            context,
            icon: Icons.favorite, // 아이콘 설정
            title: '찜 목록', // 제목 설정
            onTap: () { // 클릭 시 실행될 함수
              onWishListClick(context, ref); // 찜 목록 클릭 함수 실행
            },
          ),
          _buildOptionTile( // 옵션 타일 생성
            context,
            icon: Icons.announcement, // 아이콘 설정
            title: '공지사항', // 제목 설정
            onTap: () { // 클릭 시 실행될 함수
              onAnnounceListClick(context, ref); // 공지사항 클릭 함수 실행
            },
          ),
          _buildOptionTile( // 옵션 타일 생성
            context,
            icon: Icons.help, // 아이콘 설정
            title: '문의하기', // 제목 설정
            onTap: () { // 클릭 시 실행될 함수
              onInquiryListClick(context, ref); // 문의 클릭 함수 실행
            },
          ),
        ],
      ),
    );
  }

  // 각 선택 옵션마다의 회색 구분선 및 제목 UI 관련 _buildOptionTile 위젯 내용
  Widget _buildOptionTile(BuildContext context,
      {required IconData icon, required String title, required Function() onTap}) { // 옵션 타일 생성 함수
    return Column( // 컬럼 위젯으로 구성
      children: [
        ListTile( // 리스트 타일 위젯
          leading: Icon(icon), // 아이콘 설정
          title: Text(title), // 제목 설정
          trailing: Icon(Icons.chevron_right), // 오른쪽 화살표 아이콘 설정
          onTap: onTap, // 클릭 시 실행될 함수 설정
        ),
        Divider(height: 1, color: Colors.grey[300]), // 구분선 추가
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

  void onAnnounceListClick(BuildContext context, WidgetRef ref) { // 공지사항 클릭 함수
    navigateToScreenAndRemoveUntil(context, ref, AnnounceMainScreen(), 4); // 화면 이동 함수 호출
  }

  void onInquiryListClick(BuildContext context, WidgetRef ref) { // 문의 클릭 함수
    navigateToScreenAndRemoveUntil(context, ref, InquiryMainScreen(), 4); // 화면 이동 함수 호출
  }
}
// ------ 각 옵션마다 클릭 시, 각 해당 화면으로 이동하는 로직 끝 부분
// ------- 마이페이지 화면 내 발주내역 관리 ~ 문의하기 관련 옵션 선택 UI 구현하는 UserProfileOptions 위젯 내용 끝 부분
