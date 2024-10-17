// Dart의 비동기 프로그래밍 기능을 사용하기 위한 'dart:async' 라이브러리를 임포트합니다.
import 'dart:async';

// 네트워크 이미지를 캐싱하는 기능을 제공하는 'cached_network_image' 패키지를 임포트합니다.
// 이 패키지는 이미지 로딩 속도를 개선하고 데이터 사용을 최적화합니다.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

// Flutter의 기본 디자인과 인터페이스 요소들을 사용하기 위한 Material 디자인 패키지를 임포트합니다.
import 'package:flutter/material.dart'; // Flutter의 기본 디자인 위젯
// 외부 웹사이트나 애플리케이션 링크를 열기 위한 URL Launcher 패키지를 임포트합니다.
import 'package:url_launcher/url_launcher.dart';

// 여러 의류 카테고리 화면을 정의한 파일들을 임포트합니다.
import '../../product/view/main_screen/blouse_main_screen.dart'; // 블라우스 화면
import '../../product/view/main_screen/cardigan_main_screen.dart'; // 가디건 화면
import '../../product/view/main_screen/coat_main_screen.dart'; // 코트 화면
import '../../product/view/main_screen/shirt_main_screen.dart'; // 셔츠 화면
// 비동기 데이터 로딩을 위해 상태 관리에 사용되는 FutureProvider 파일을 임포트합니다.
// 이 파일은 네트워크 요청과 같은 비동기 작업 결과를 처리하고 상태 관리에 사용됩니다.
import '../const/colors.dart';
import '../model/banner_model.dart';
import '../provider/common_all_providers.dart'; // 비동기 데이터 로드를 위한 FutureProvider
// Riverpod는 상태 관리를 위한 외부 라이브러리입니다. 이를 통해 애플리케이션의 상태를 효율적으로 관리할 수 있습니다.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리 라이브러리

import 'dart:io';

// ------ 배너 페이지 뷰 자동 스크롤 기능 구현 위한 클래스 시작
class BannerAutoScrollClass {
  // 페이지 뷰를 제어할 PageController 객체
  final PageController pageController;

  // 현재 페이지 인덱스를 추적하고 관리할 상태 변수
  final StateProvider<int> currentPageProvider;

  // 자동 스크롤을 위한 타이머 객체. 선택적으로 사용되므로 nullable 타입
  Timer? _timer;

  // 배너 아이템의 총 개수를 저장하는 변수
  int itemCount;

  // 페이지를 넘기는 데 걸리는 시간(ms 단위)
  final int scrollDuration;

  // 자동 스크롤 전 대기 시간(ms 단위)
  final int waitDuration;

  // 클래스 생성자: 필수적인 변수들을 초기화하고, 선택적으로 스크롤 및 대기 시간을 지정
  BannerAutoScrollClass({
    required this.pageController,
    required this.currentPageProvider,
    required this.itemCount,
    this.scrollDuration = 300, // 기본 스크롤 지속 시간을 300ms로 설정
    this.waitDuration = 5000, // 기본 대기 시간을 5000ms(5초)로 설정
  });

  // 자동 스크롤 기능을 시작하는 함수
  void startAutoScroll() {
    _timer?.cancel(); // 기존에 실행중인 타이머가 있다면 취소
    // 5초마다 반복되는 타이머를 설정
    _timer =
        Timer.periodic(Duration(milliseconds: waitDuration), (Timer timer) {
      // 페이지 컨트롤러와 아이템 수를 확인
      if (pageController.hasClients && itemCount > 0) {
        // 다음 페이지 번호 계산, 현재 페이지에서 1을 더함
        int nextPage = (pageController.page?.round() ?? 0) + 1;
        // 계산된 다음 페이지가 아이템 수보다 많거나 같으면 첫 페이지로 설정
        if (nextPage >= itemCount) {
          nextPage = 0; // 첫 페이지로 이동
        }
        // 페이지 컨트롤러를 사용하여 부드럽게 다음 페이지로 이동
        pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300), // 이동하는 데 300밀리초 소요
          curve: Curves.easeInOut, // 이동 애니메이션은 easeInOut 곡선을 사용
        );
      }
    });
  }

  // 자동 스크롤 기능을 정지하는 함수
  void stopAutoScroll() {
    _timer?.cancel(); // 타이머를 취소
    _timer = null; // 타이머 변수를 null로 설정
  }
}
// ------ 배너 페이지 뷰 자동 스크롤 기능 구현 위한 클래스 끝

// ------ 배너 페이지 뷰에 사용되는 파이어베이스의 이미지 데이터를 캐시에 임시 저장하기 위한 클래스 시작
// StatelessWidget를 상속받아 상태가 없는 위젯 BannerImage를 정의함.
class BannerImageClass extends StatelessWidget {
  // imageUrl은 네트워크 이미지의 URL을 저장하는 문자열 변수
  final String imageUrl;

  // 생성자에서는 imageUrl을 필수적으로 받으며, key는 선택적으로 받음.
  // super(key: key)를 통해 부모 클래스의 생성자에 key를 전달함.
  const BannerImageClass({Key? key, required this.imageUrl}) : super(key: key);

  // build 메소드는 위젯의 UI를 구성함.
  @override
  Widget build(BuildContext context) {
    // CachedNetworkImage 위젯을 사용하여 네트워크 이미지를 로딩하고 캐싱함.
    return CachedNetworkImage(
      imageUrl: imageUrl, // imageUrl 프로퍼티를 통해 이미지 URL을 지정함.
      fit: BoxFit.cover, // 이미지가 부모 위젯의 경계 내에 들어가도록 조정함.
      // (기존의 fit: BoxFit.contain을 사용하면 이미지 크기에 맞게하는거라 안 맞음 => 그래서, fit: BoxFit.cover로 변경)
      // 이미지 로딩 중 에러가 발생한 경우 errorWidget을 통해 에러 아이콘을 표시함.
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
// ------ 배너 페이지 뷰에 사용되는 파이어베이스의 이미지 데이터를 캐시에 임시 저장하기 위한 클래스 끝

// ------ buildBannerPageView 위젯 내용 구현 시작
Widget buildBannerPageView({
  required WidgetRef ref, // BuildContext 대신 WidgetRef를 사용, ref를 매개변수(인자)로 받음.
  required PageController pageController, // 페이지 컨트롤러
  required int itemCount, // 배너 아이템(이미지)의 총 개수
  required IndexedWidgetBuilder itemBuilder, // 각 배너 아이템을 구성하는 위젯 빌더
  required StateProvider<int> currentPageProvider, // 현재 페이지 인덱스를 관리하는 상태 프로바이더
  required BuildContext context, // 현재 컨텍스트
  required double width,  // 이미지의 너비
  required double height, // 이미지의 높이
  required double borderRadius, // 모서리 반경
}) {
  // PageView.builder를 반환하여 동적으로 아이템을 생성하는 페이지 뷰를 구현
  return PageView.builder(
    controller: pageController, // PageController 인스턴스 사용. 페이지 이동 제어
    itemCount: itemCount, // 총 페이지(아이템)의 수를 지정
    onPageChanged: (index) {
      // 페이지가 변경될 때 호출될 함수. 새 페이지 인덱스를 상태 관리 도구를 통해 업데이트
      ref.read(currentPageProvider.notifier).state = index;
    },
    itemBuilder: (context, index) {
      return Container(
        width: width, // 외부에서 받은 너비 적용
        height: height, // 외부에서 받은 높이 적용
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius), // 모서리 반경 적용
        ),
        clipBehavior: Clip.antiAlias, // borderRadius 적용을 위해 클리핑
        child: itemBuilder(context, index), // 배너 이미지 로드
      );
    },
  );
}
// ------ buildBannerPageView 위젯 내용 구현 끝

// ------ 공통 배너 페이지 뷰 위젯인 buildCommonBannerPageViewSection 시작 - 모든 배너를 해당 위젯을 재사용하여 데이터만 다르게 교체하여 사용(모델, 레퍼지토리, 프로바이더만 다르게 변경하여..)
Widget buildCommonBannerPageViewSection<T extends CommonBannerImage>({
  required BuildContext context,
  required WidgetRef ref,
  required StateProvider<int> currentPageProvider,
  required PageController pageController,
  required BannerAutoScrollClass bannerAutoScroll,
  required List<String> bannerLinks,
  required FutureProvider<List<T>> bannerImagesProvider,
  required void Function(BuildContext, int) onPageTap, // 콜백 함수의 반환 타입을 void로 변경
  required double width,  // 배너의 너비
  required double height, // 배너의 높이
  required double borderRadius, // 모서리 반경
}) {

  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정
  final double commonBannerViewPageIndicatorWidth = screenSize.width * (50 / referenceWidth); // 페이지 번호 너비
  final double commonBannerViewPageIndicatorHeight = screenSize.height * (25 / referenceHeight); // 페이지 번호 높이
  final double commonBannerViewPageIndicatorX = screenSize.width * (20 / referenceWidth); // 페이지 번호 X
  final double commonBannerViewPageIndicatorY = screenSize.height * (7 / referenceHeight); // 페이지 번호 Y

  final asyncBannerImages = ref.watch(bannerImagesProvider);

  return asyncBannerImages.when(
    data: (List<T> commonBannerImages) {
      bannerAutoScroll.itemCount = commonBannerImages.length;
      bannerAutoScroll.startAutoScroll();

      return Stack(
        children: [
          buildBannerPageView(
            ref: ref,
            pageController: pageController,
            itemCount: commonBannerImages.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                onPageTap(context, index); // 콜백 함수 호출
              },
              child: BannerImageClass(
                  imageUrl: commonBannerImages[index].imageUrl),
            ),
            currentPageProvider: currentPageProvider,
            context: context,
            width: width, // 배너의 너비 전달
            height: height, // 배너의 높이 전달
            borderRadius: borderRadius, // 모서리 반경 전달
          ),
          Positioned(
            right: commonBannerViewPageIndicatorX,
            bottom: commonBannerViewPageIndicatorY,
            child: Consumer(
              builder: (context, ref, child) {
                final currentPage = ref.watch(currentPageProvider);
                return Container(
                  width: commonBannerViewPageIndicatorWidth, // 페이지 번호 너비 설정
                  height: commonBannerViewPageIndicatorHeight, // 페이지 번호 높이 설정
                  alignment: Alignment.center, // 중앙 정렬
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${currentPage + 1} / ${commonBannerImages.length}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
    loading: () => Center(child: CircularProgressIndicator()),
    error: (error, stack) => Center(child: Text('이미지를 불러오는 중 오류가 발생했습니다.')),
  );
}
// ------ 공통 배너 페이지 뷰 위젯인 buildCommonBannerPageViewSection 끝 - 모든 배너를 해당 위젯을 재사용하여 데이터만 다르게 교체하여 사용(모델, 레퍼지토리, 프로바이더만 다르게 변경하여..)

// ------ 범용성으로 재사용가능한 카드뷰인 CommonCardView 클래스 시작
class CommonCardView extends StatelessWidget {
  // 'content'는 카드 내부에 표시될 위젯을 정의함.
  final Widget content;

  // 'backgroundColor'는 카드의 배경색을 정의함. 기본값은 흰색임.
  final Color backgroundColor;

  // 'elevation'는 카드의 그림자 깊이를 정의함. 기본값은 4.0임.
  final double elevation;

  // 'margin'은 카드의 외부 여백을 정의함. 기본값은 모든 방향으로 2의 여백임.
  final EdgeInsets margin;

  // 'padding'은 카드 내부의 여백을 정의함. 기본값은 모든 방향으로 8의 여백임.
  final EdgeInsets padding;

// 생성자에서는 위에서 정의한 필드들을 초기화함.
// 필요한 'content'는 반드시 제공되어야 하며, 나머지는 선택적으로 제공될 수 있음.
  CommonCardView({
    required this.content, // content는 필수로 제공되어야 함
    this.backgroundColor = Colors.white, // 배경색은 선택적이며 기본값은 하얀색으로 설정
    this.elevation = 4.0, // elevation은 선택적이며 기본값은 4.0으로 설정
    this.margin = const EdgeInsets.all(
        2), // margin은 선택적이며 기본값은 EdgeInsets.all(2)로 설정
    this.padding = const EdgeInsets.all(
        8), // padding은 선택적이며 기본값은 EdgeInsets.all(8)로 설정
  });

  @override
  Widget build(BuildContext context) {
    // Container 위젯을 사용하여 시각적 표현을 구현함.
    return Container(
      width: double.infinity, // 해당 위젯이 가능한 한 최대 너비를 가지도록 설정
      margin: margin, // 생성자에서 받은 margin 값 적용
      child: Material(
        color: backgroundColor, // 생성자에서 받은 배경색 값 적용
        elevation: elevation, // 생성자에서 받은 elevation 값 적용
        child: Padding(
          padding: padding, // 생성자에서 받은 padding 값 적용
          child: content, // 생성자에서 받은 content 값 적용
        ),
      ),
    );
  }
}
// ------ 범용성으로 재사용가능한 카드뷰인 CommonCardView 클래스 끝

// ------ 공통적으로 사용될 'top' 버튼 위젯 내용 시작
// 'Top' 버튼을 구현하는 위젯
Widget buildTopButton(BuildContext context, ScrollController scrollController) {

  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 비율을 기반으로 동적으로 크기와 위치 설정
  final double topBarX = screenSize.width * (22 / referenceWidth); // X
  final double topBarY = screenSize.height * (170 / referenceHeight); // Y

  return Positioned(
    top: screenSize.height - topBarY, // 화면 하단에서 topBarY 위로 위치
    right: topBarX, // 화면 오른쪽 끝에서 topBarX 왼쪽으로 위치
      child: FloatingActionButton(
        mini: true, // 버튼을 작게 설정
        backgroundColor: Colors.white, // 버튼 배경색을 하얀색으로 설정
        onPressed: () {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              0.0,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } else {
            // ScrollController가 클라이언트에 연결되지 않은 경우 처리
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (scrollController.hasClients) {
                scrollController.animateTo(
                  0.0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            });
          }
        },
        child: Icon(
          Icons.arrow_upward, // 위로 가리키는 화살표 아이콘
          color: Color(0xFFE17735), // 아이콘 색상은 주황색으로 설정
        ),
      ),
  );
}
// ------ 공통적으로 사용될 'top' 버튼 위젯 내용 끝

// ------ 공통적으로 사용될 알림창 관련 함수 내용 시작

// 공통적으로 사용할 수 있는 알림창 생성 함수
// showSubmitAlertDialog: 다양한 플랫폼(iOS, Android)에서 사용할 수 있는 알림창을 생성하는 함수
Future<bool> showSubmitAlertDialog(BuildContext context, {
  required String title, // 알림창의 제목을 나타내는 문자열
  String? content, // 알림창의 내용을 나타내는 선택적 문자열
  required List<Widget> actions, // 알림창에서 사용할 버튼 리스트 (actions)
  Widget? contentWidget, // 알림창 내용 대신 사용할 위젯 (contentWidget)
}) async {
  // showDialog: 비동기로 알림창을 띄우며 사용자의 입력(확인, 취소 등)을 대기함
  return await showDialog<bool>(
    context: context, // 알림창이 표시될 BuildContext
    barrierDismissible: false, // 사용자가 알림창 외부를 클릭해도 닫히지 않도록 설정함
    builder: (BuildContext context) {

      // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
      final Size screenSize = MediaQuery.of(context).size;

      // 기준 화면 크기: 가로 393, 세로 852
      final double referenceHeight = 852.0;

      // 비율을 기반으로 동적으로 크기와 위치를 설정함
      final double AlertDialogBtnFontSize1 = screenSize.height * (16 / referenceHeight);
      final double AlertDialogBtnFontSize2 = screenSize.height * (14 / referenceHeight);

      // 플랫폼이 iOS인 경우 CupertinoAlertDialog 사용
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text(title,
            style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: AlertDialogBtnFontSize1, // 텍스트 크기 설정
            ),
          ), // 제목 표시
          content: contentWidget ?? Text(content ?? '',
            style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: AlertDialogBtnFontSize2, // 텍스트 크기 설정
            ),), // 내용 위젯이 제공되면 그것을 사용하고, 없으면 content 문자열을 표시함
          actions: actions, // 알림창에서 사용될 버튼 리스트(actions)
        );
        // 플랫폼이 Android인 경우 AlertDialog 사용
      } else if (Platform.isAndroid) {
        return AlertDialog(
          title: Text(title,
            style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: AlertDialogBtnFontSize1, // 텍스트 크기 설정
            ),), // 제목 표시
          content: contentWidget ?? Text(content ?? '',
            style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: AlertDialogBtnFontSize2, // 텍스트 크기 설정
            ),), // 내용 위젯이 제공되면 그것을 사용하고, 없으면 content 문자열을 표시함
          actions: actions, // 알림창에서 사용될 버튼 리스트(actions)
        );
      } else {
        // 지원되지 않는 플랫폼일 경우 기본적으로 false 반환함
        return AlertDialog(
          title: Text('Unsupported Platform',
            style: TextStyle(
              fontFamily: 'NanumGothic',
            ),), // '지원되지 않는 플랫폼'이라는 제목 표시
          content: Text('이 플랫폼은 지원되지 않습니다.',
            style: TextStyle(
              fontFamily: 'NanumGothic',
            ),), // '이 플랫폼은 지원되지 않습니다.'라는 내용 표시
          actions: <Widget>[
            // '확인' 버튼 클릭 시 false 반환하고 알림창 닫음
            TextButton(
              child: Text('확인',
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                ),),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      }
    },
  ) ?? false; // 기본적으로 false 반환함 (예외 상황 대비)
}

// 공통적으로 사용할 수 있는 알림창 버튼 생성 함수
// buildAlertActions: 알림창에 표시될 버튼을 생성하는 함수
List<Widget> buildAlertActions(BuildContext context, {
  required String noText, // '취소' 또는 '닫기' 버튼에 표시될 텍스트
  TextStyle? noTextStyle, // '취소' 또는 '닫기' 버튼 텍스트의 스타일
  String? yesText, // '확인' 버튼에 표시될 선택적 텍스트
  TextStyle? yesTextStyle, // '확인' 버튼 텍스트의 스타일
  VoidCallback? onYesPressed, // '확인' 버튼 클릭 시 호출될 함수
}) {
  if (yesText != null && onYesPressed != null) {
    // '확인' 텍스트와 onYesPressed 함수가 제공된 경우, 두 개의 버튼(취소, 확인)을 생성함
    return <Widget>[
      TextButton(
        child: Text(noText, style: noTextStyle), // '취소' 버튼 텍스트에 스타일 적용
        onPressed: () {
          Navigator.of(context).pop(false); // '취소' 클릭 시 false 반환하고 알림창 닫음
        },
      ),
      TextButton(
        child: Text(yesText, style: yesTextStyle), // '확인' 버튼 텍스트에 스타일 적용
        onPressed: onYesPressed, // '확인' 버튼 클릭 시 전달된 함수 호출
      ),
    ];
  } else {
    // '확인' 버튼이 없을 경우, '취소' 버튼만 생성함
    return <Widget>[
      TextButton(
        child: Text(noText, style: noTextStyle), // '닫기' 버튼 텍스트에 스타일 적용
        onPressed: () {
          Navigator.of(context).pop(false); // '닫기' 클릭 시 false 반환하고 알림창 닫음
        },
      ),
    ];
  }
}
// ------ 공통적으로 사용될 알림창 관련 함수 내용 끝

// ------ 공통 SnackBar 함수 내용 시작
// 공통 SnackBar 함수
void showCustomSnackBar(BuildContext context, String message) {

  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 스낵바 부분 수치
  final double commonSnackBarWidth = screenSize.width * (393 / referenceWidth);
  final double commonSnackBarX = screenSize.width * (20 / referenceWidth);
  final double commonSnackBarY = screenSize.height * (16 / referenceHeight);
  final double commonSnackBarTextFontSize = screenSize.height * (14 / referenceHeight);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,
        style: TextStyle(
          fontFamily: 'NanumGothic',
          fontWeight: FontWeight.bold,
          fontSize: commonSnackBarTextFontSize,
          color: Colors.white,
        ),
      ),
      backgroundColor: Color(0xCCE17735),  // 색상을 80% 투명도로 설정
      width: commonSnackBarWidth,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: commonSnackBarX,
        vertical: commonSnackBarY,
      ),
    ),
  );
}
// ------ 공통 SnackBar 함수 내용 끝

// ------ 네트워크 상태 체크 함수 내용 시작
// 네트워크 상태를 체크하는 클래스 정의
class NetworkChecker {
  final BuildContext context; // 현재 앱의 화면 정보를 담고 있는 context 값
  StreamSubscription? _subscription; // 스트림을 구독하는 역할을 하는 _subscription 변수 추가

  // 생성자에서 context 값을 전달받아 사용
  NetworkChecker(this.context);

  // 네트워크 상태 변화를 실시간으로 감지하는 메서드
  void checkNetworkStatus() {
    _subscription = Connectivity().onConnectivityChanged.listen((
        List<ConnectivityResult> results) {
      // 결과 리스트를 순회하면서 네트워크 연결 상태를 확인
      for (var result in results) {
        if (result == ConnectivityResult.none) {
          // 네트워크 연결이 없을 경우 네트워크 오류 알림창을 띄움
          showNetworkErrorDialog();
          break; // 오류가 발생하면 반복문 종료
        }
      }
    });
  }

  // 네트워크 연결 상태를 동기적으로 확인하는 메서드
  Future<bool> isConnected() async {
    // 현재 네트워크 연결 상태를 가져옴
    var connectivityResult = await Connectivity().checkConnectivity();
    // 네트워크가 연결되어 있지 않다면 false 반환
    return connectivityResult != ConnectivityResult.none;
  }

  // 네트워크 오류 시 알림창을 띄우는 메서드
  void showNetworkErrorDialog() {
    // 알림창을 보여주는 함수 호출
    showSubmitAlertDialog(
      context,
      title: '[네트워크 에러]', // 알림창의 제목
      content: '인터넷 연결 확인 후, 앱을 재실행 해주세요.', // 알림창의 내용
      actions: [
        TextButton(
          // '확인' 버튼 정의
          child: Text(
            '확인',
            style: TextStyle(
              color: Color(0xFFE17735), // 버튼 텍스트 색상 지정
              fontWeight: FontWeight.bold, // 텍스트의 굵기를 두껍게 설정
              fontFamily: 'NanumGothic', // 글꼴 설정
            ),
          ),
          onPressed: () {
            // Android 기기에서는 앱을 종료
            if (Platform.isAndroid) {
              exit(0); // 앱 종료 명령
              // iOS 기기에서는 알림창만 닫음
            } else if (Platform.isIOS) {
              Navigator.of(context).pop(); // 알림창 닫기
            }
          },
        ),
      ],
    );
  }

  // 네트워크 상태 감지 리스너 해제하는 메서드
  void dispose() {
    // 스트림 구독 해제
    _subscription?.cancel();
  }
}
// ------ 네트워크 상태 체크 함수 내용 끝