// Dart의 비동기 프로그래밍 기능을 사용하기 위한 'dart:async' 라이브러리를 임포트합니다.
import 'dart:async';

// 네트워크 이미지를 캐싱하는 기능을 제공하는 'cached_network_image' 패키지를 임포트합니다.
// 이 패키지는 이미지 로딩 속도를 개선하고 데이터 사용을 최적화합니다.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

// Flutter의 기본 디자인과 인터페이스 요소들을 사용하기 위한 Material 디자인 패키지를 임포트합니다.
import 'package:flutter/material.dart'; // Flutter의 기본 디자인 위젯
import 'package:flutter/services.dart';
// 외부 웹사이트나 애플리케이션 링크를 열기 위한 URL Launcher 패키지를 임포트합니다.
import 'package:url_launcher/url_launcher.dart';

// 여러 의류 카테고리 화면을 정의한 파일들을 임포트합니다.
import '../../product/layout/product_body_parts_layout.dart';
import '../../product/model/product_model.dart';
import '../../product/view/detail_screen/product_detail_original_image_screen.dart';
// 비동기 데이터 로딩을 위해 상태 관리에 사용되는 FutureProvider 파일을 임포트합니다.
// 이 파일은 네트워크 요청과 같은 비동기 작업 결과를 처리하고 상태 관리에 사용됩니다.
import '../../product/view/sub_main_screen/autumn_sub_main_screen.dart';
import '../../product/view/sub_main_screen/best_sub_main_screen.dart';
import '../../product/view/sub_main_screen/new_sub_main_screen.dart';
import '../../product/view/sub_main_screen/sale_sub_main_screen.dart';
import '../../product/view/sub_main_screen/spring_sub_main_screen.dart';
import '../../product/view/sub_main_screen/summer_sub_main_screen.dart';
import '../../product/view/sub_main_screen/winter_sub_main_screen.dart';
import '../../user/view/easy_login_aos_screen.dart';
import '../../user/view/easy_login_ios_screen.dart';
import '../const/colors.dart';
import '../model/banner_model.dart';
import '../provider/common_all_providers.dart'; // 비동기 데이터 로드를 위한 FutureProvider
// Riverpod는 상태 관리를 위한 외부 라이브러리입니다. 이를 통해 애플리케이션의 상태를 효율적으로 관리할 수 있습니다.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리 라이브러리

import 'dart:io';

import '../provider/common_state_provider.dart';

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
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 에러 관련 텍스트 수치
    final double errorTextFontSize1 =
        screenSize.height * (14 / referenceHeight);
    final double errorTextFontSize2 =
        screenSize.height * (12 / referenceHeight);
    final double errorTextHeight = screenSize.height * (600 / referenceHeight);

    return imageUrl.isNotEmpty // 이미지 URL이 비어 있지 않은 경우
        ? CachedNetworkImage(
            imageUrl: imageUrl, // imageUrl 프로퍼티를 통해 이미지 URL을 지정함.
            fit: BoxFit.cover, // 이미지가 부모 위젯의 경계 내에 들어가도록 조정함.
            // 이미지 로드 실패 시 에러 인디케이터 표시
            errorWidget: (context, url, error) => Container(
              height: errorTextHeight, // 전체 화면 높이 설정
              alignment: Alignment.center, // 중앙 정렬
              child: buildCommonErrorIndicator(
                message: '오픈 예정입니다.',
                fontSize1: errorTextFontSize1,
                // 폰트1 크기 설정
                fontSize2: errorTextFontSize2,
                // 폰트2 크기 설정
                showSecondMessage: false,
                // 두 번째 메시지 표시 여부
                color: BLACK_COLOR, // 색상 설정 // 에러 메시지 색상
              ),
            ),
          )
        : Container(
            height: errorTextHeight, // 전체 화면 높이 설정
            alignment: Alignment.center, // 중앙 정렬
            child: buildCommonErrorIndicator(
              message: '오픈 예정입니다.',
              fontSize1: errorTextFontSize1,
              // 폰트1 크기 설정
              fontSize2: errorTextFontSize2,
              // 폰트2 크기 설정
              showSecondMessage: false,
              // 두 번째 메시지 표시 여부
              color: BLACK_COLOR, // 색상 설정 // 에러 메시지 색상
            ),
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
  required double width, // 이미지의 너비
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
        width: width,
        // 외부에서 받은 너비 적용
        height: height,
        // 외부에서 받은 높이 적용
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius), // 모서리 반경 적용
        ),
        clipBehavior: Clip.antiAlias,
        // borderRadius 적용을 위해 클리핑
        child: itemBuilder(context, index), // 배너 이미지 로드
      );
    },
  );
}
// ------ buildBannerPageView 위젯 내용 구현 끝

// ------ 공통 배너 페이지 뷰 위젯인 buildCommonBannerPageViewSection 시작 - 모든 배너를 해당 위젯을 재사용하여 데이터만 다르게 교체하여 사용(모델, 레퍼지토리, 프로바이더만 다르게 변경하여..)
Widget buildCommonBannerPageViewSection<T extends CommonBannerImage>({
  required BuildContext context, // 빌드 컨텍스트
  required WidgetRef ref, // 위젯 참조
  required StateProvider<int> currentPageProvider, // 현재 페이지 상태 제공자
  required PageController pageController, // 페이지 컨트롤러
  required BannerAutoScrollClass bannerAutoScroll, // 배너 자동 스크롤 클래스
  // required List<String> bannerLinks,
  required FutureProvider<List<T>> bannerImagesProvider, // 배너 이미지 제공자
  required void Function(BuildContext, int)
      onPageTap, // 페이지 클릭 시 콜백 함수, 반환 타입은 void
  required double width, // 배너 너비
  required double height, // 배너 높이
  required double borderRadius, // 배너 모서리 반경
}) {
  // MediaQuery로 화면 크기를 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 비율을 기준으로 배너 페이지 뷰 인디케이터 크기와 위치 설정
  final double commonBannerViewPageIndicatorWidth =
      screenSize.width * (50 / referenceWidth); // 페이지 번호 너비
  final double commonBannerViewPageIndicatorHeight =
      screenSize.height * (25 / referenceHeight); // 페이지 번호 높이
  final double commonBannerViewPageIndicatorX =
      screenSize.width * (20 / referenceWidth); // 페이지 번호 X 위치
  final double commonBannerViewPageIndicatorY =
      screenSize.height * (7 / referenceHeight); // 페이지 번호 Y 위치

  // 에러 메시지 텍스트 크기 설정
  final double errorTextFontSize1 =
      screenSize.height * (14 / referenceHeight); // 첫 번째 에러 텍스트 크기
  final double errorTextFontSize2 =
      screenSize.height * (12 / referenceHeight); // 두 번째 에러 텍스트 크기

  // 배너 이미지를 비동기로 가져옴
  final asyncBannerImages = ref.watch(bannerImagesProvider);

  return asyncBannerImages.when(
    // 데이터가 로드되었을 때 UI 렌더링
    data: (List<T> commonBannerImages) {
      bannerAutoScroll.itemCount = commonBannerImages.length; // 자동 스크롤 항목 개수 설정
      bannerAutoScroll.startAutoScroll(); // 자동 스크롤 시작

      return Stack(
        children: [
          // 배너 페이지 뷰 생성
          buildBannerPageView(
            ref: ref,
            // 위젯 참조 전달
            pageController: pageController,
            // 페이지 컨트롤러 전달
            itemCount: commonBannerImages.length,
            // 항목 개수 설정
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                onPageTap(context, index); // 클릭 시 콜백 함수 호출
              },
              child: BannerImageClass(
                imageUrl: commonBannerImages[index].imageUrl, // 배너 이미지 URL 설정
              ),
            ),
            currentPageProvider: currentPageProvider,
            // 현재 페이지 상태 제공자 설정
            context: context,
            // 빌드 컨텍스트 설정
            width: width,
            // 배너 너비 설정
            height: height,
            // 배너 높이 설정
            borderRadius: borderRadius, // 배너 모서리 반경 설정
          ),
          // 페이지 인디케이터 위치 설정
          Positioned(
            right: commonBannerViewPageIndicatorX, // X 위치 설정
            bottom: commonBannerViewPageIndicatorY, // Y 위치 설정
            child: Consumer(
              builder: (context, ref, child) {
                final currentPage =
                    ref.watch(currentPageProvider); // 현재 페이지 번호 감시
                return Container(
                  width: commonBannerViewPageIndicatorWidth,
                  // 인디케이터 너비 설정
                  height: commonBannerViewPageIndicatorHeight,
                  // 인디케이터 높이 설정
                  alignment: Alignment.center,
                  // 중앙 정렬 설정
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5), // 배경색 및 투명도 설정
                    borderRadius: BorderRadius.circular(12), // 모서리 반경 설정
                  ),
                  child: Text(
                    '${currentPage + 1} / ${commonBannerImages.length}',
                    // 페이지 번호 표시
                    style: TextStyle(color: WHITE_COLOR), // 텍스트 색상 설정
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
    // 로딩 중일 때 로딩 인디케이터 표시
    loading: () => buildCommonLoadingIndicator(),
    // 에러 발생 시 에러 인디케이터 표시
    error: (error, stack) => buildCommonErrorIndicator(
      message: '에러가 발생했으니, 앱을 재실행해주세요.',
      // 첫 번째 메시지 설정
      secondMessage: '에러가 반복될 시, \'문의하기\'에서 문의해주세요.',
      // 두 번째 메시지 설정
      fontSize1: errorTextFontSize1,
      // 첫 번째 폰트 크기 설정
      fontSize2: errorTextFontSize2,
      // 두 번째 폰트 크기 설정
      color: BLACK_COLOR,
      // 텍스트 색상 설정
      showSecondMessage: true, // 두 번째 메시지 표시 여부 설정
    ),
  );
}
// ------ 공통 배너 페이지 뷰 위젯인 buildCommonBannerPageViewSection 끝 - 모든 배너를 해당 위젯을 재사용하여 데이터만 다르게 교체하여 사용(모델, 레퍼지토리, 프로바이더만 다르게 변경하여..)

// ------ 대배너 클릭 시 URL 이동 로직 관련 함수 내용 시작
void onLargeBannerTap(BuildContext context, int index,
    List<AllLargeBannerImage> images, WidgetRef ref) async {
  // 선택된 인덱스의 배너 이미지 정보를 가져옴
  final bannerImage = images[index];

  // 인덱스가 4이고, subCategory가 있을 경우
  if (index == 4 && bannerImage.subCategory != null) {
    // subCategory에 따른 화면 전환을 위한 변수 선언
    Widget destinationScreen;
    // subCategory 값에 따라 각기 다른 화면으로 이동함
    switch (bannerImage.subCategory) {
      case '신상':
        destinationScreen = NewSubMainScreen();
        break;
      case '스테디 셀러':
        destinationScreen = BestSubMainScreen();
        break;
      case '특가 상품':
        destinationScreen = SaleSubMainScreen();
        break;
      case '봄':
        destinationScreen = SpringSubMainScreen();
        break;
      case '여름':
        destinationScreen = SummerSubMainScreen();
        break;
      case '가을':
        destinationScreen = AutumnSubMainScreen();
        break;
      case '겨울':
        destinationScreen = WinterSubMainScreen();
        break;
      default:
        // 유효하지 않은 카테고리일 경우 경고 메시지 출력 후 함수 종료
        print('유효하지 않은 카테고리입니다.');
        return;
    }
    // 선택한 화면으로 이동함
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => destinationScreen));
  }
  // productId가 있을 경우 해당 제품 상세 화면으로 이동함
  else if (bannerImage.productId != null) {
    final product = ProductContent(
      docId: bannerImage.productId!, // 제품 문서 ID 설정
      category: bannerImage.category, // 제품 카테고리 설정
    );
    // 제품 상세 화면으로 이동하는 함수 호출
    ProductInfoDetailScreenNavigation(ref)
        .navigateToDetailScreen(context, product);
  }
  // url이 있을 경우 외부 URL로 이동함
  else if (bannerImage.url != null) {
    Uri uri = Uri.parse(bannerImage.url!); // URL 파싱
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri); // URL 실행
    } else {
      // URL이 없을 경우 경고 메시지 출력
      print('링크가 없는 배너입니다.');
    }
  }
  // 위 조건에 모두 해당되지 않을 경우 경고 메시지 출력
  else {
    print('링크가 없는 배너입니다.');
  }
}
// ------ 대배너 클릭 시 URL 이동 로직 관련 함수 내용 끝

// ------ 소배너 클릭 시 URL 이동 로직 관련 함수 내용 시작
void onSmallBannerTap(BuildContext context, int index,
    List<AllSmallBannerImage> images, WidgetRef ref) async {
  // 선택된 인덱스의 배너 이미지 정보를 가져옴
  final bannerImage = images[index];

  // productId가 있을 경우 해당 제품 상세 화면으로 이동함
  if (bannerImage.productId != null) {
    final product = ProductContent(
      docId: bannerImage.productId!, // 제품 문서 ID 설정
      category: bannerImage.category, // 제품 카테고리 설정
    );
    // 제품 상세 화면으로 이동하는 함수 호출
    ProductInfoDetailScreenNavigation(ref)
        .navigateToDetailScreen(context, product);
  }
  // url이 있을 경우 외부 URL로 이동함
  else if (bannerImage.url != null) {
    Uri uri = Uri.parse(bannerImage.url!); // URL 파싱
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri); // URL 실행
    } else {
      // URL이 없을 경우 경고 메시지 출력
      print('링크가 없는 배너입니다.');
    }
  }
  // 위 조건에 모두 해당되지 않을 경우 경고 메시지 출력
  else {
    print('링크가 없는 배너입니다.');
  }
}
// ------ 소배너 클릭 시 URL 이동 로직 관련 함수 내용 끝

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
    this.backgroundColor = WHITE_COLOR, // 배경색은 선택적이며 기본값은 하얀색으로 설정
    this.elevation = 4.0, // elevation은 선택적이며 기본값은 4.0으로 설정
    this.margin =
        const EdgeInsets.all(2), // margin은 선택적이며 기본값은 EdgeInsets.all(2)로 설정
    this.padding =
        const EdgeInsets.all(8), // padding은 선택적이며 기본값은 EdgeInsets.all(8)로 설정
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
  final double topBarY = screenSize.height * (200 / referenceHeight); // Y

  return Positioned(
    top: screenSize.height - topBarY, // 화면 하단에서 topBarY 위로 위치
    right: topBarX, // 화면 오른쪽 끝에서 topBarX 왼쪽으로 위치
    child: FloatingActionButton(
      mini: true, // 버튼을 작게 설정
      backgroundColor: WHITE_COLOR, // 버튼 배경색을 하얀색으로 설정
      onPressed: () {
        if (scrollController.hasClients) {
          // ScrollController가 연결된 경우
          scrollController.animateTo(
            0.0, // 스크롤 위치를 최상단으로 이동
            duration: Duration(milliseconds: 500), // 애니메이션 지속 시간
            curve: Curves.easeInOut, // 애니메이션 곡선 설정
          );
        } else {
          // ScrollController가 클라이언트에 연결되지 않은 경우 처리
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              // 클라이언트가 연결된 후 다시 최상단으로 이동
              scrollController.animateTo(
                0.0, // 스크롤 위치를 최상단으로 이동
                duration: Duration(milliseconds: 500), // 애니메이션 지속 시간
                curve: Curves.easeInOut, // 애니메이션 곡선 설정
              );
            }
          });
        }
      },
      child: Icon(
        Icons.arrow_upward, // 위로 가리키는 화살표 아이콘
        color: ORANGE56_COLOR, // 아이콘 색상은 주황색으로 설정
      ),
    ),
  );
}
// ------ 공통적으로 사용될 'top' 버튼 위젯 내용 끝

// ------ 공통적으로 사용될 알림창 관련 함수 내용 시작

// 공통적으로 사용할 수 있는 알림창 생성 함수
// showSubmitAlertDialog: 다양한 플랫폼(iOS, Android)에서 사용할 수 있는 알림창을 생성하는 함수
Future<bool> showSubmitAlertDialog(
  BuildContext context, {
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
          final double AlertDialogBtnFontSize1 =
              screenSize.height * (14 / referenceHeight);
          final double AlertDialogBtnFontSize2 =
              screenSize.height * (11 / referenceHeight);

          // 플랫폼이 iOS인 경우 CupertinoAlertDialog 사용
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: Text(
                title,
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: AlertDialogBtnFontSize1, // 텍스트 크기 설정
                ),
              ), // 제목 표시
              content: contentWidget ??
                  Text(
                    content ?? '',
                    style: TextStyle(
                      fontFamily: 'NanumGothic',
                      fontSize: AlertDialogBtnFontSize2, // 텍스트 크기 설정
                    ),
                  ), // 내용 위젯이 제공되면 그것을 사용하고, 없으면 content 문자열을 표시함
              actions: actions, // 알림창에서 사용될 버튼 리스트(actions)
            );
            // 플랫폼이 Android인 경우 AlertDialog 사용
          } else if (Platform.isAndroid) {
            return AlertDialog(
              title: Text(
                title,
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: AlertDialogBtnFontSize1, // 텍스트 크기 설정
                ),
              ), // 제목 표시
              content: contentWidget ??
                  Text(
                    content ?? '',
                    style: TextStyle(
                      fontFamily: 'NanumGothic',
                      fontSize: AlertDialogBtnFontSize2, // 텍스트 크기 설정
                    ),
                  ), // 내용 위젯이 제공되면 그것을 사용하고, 없으면 content 문자열을 표시함
              actions: actions, // 알림창에서 사용될 버튼 리스트(actions)
            );
          } else {
            // 지원되지 않는 플랫폼일 경우 기본적으로 false 반환함
            return AlertDialog(
              title: Text(
                'Unsupported Platform',
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                ),
              ), // '지원되지 않는 플랫폼'이라는 제목 표시
              content: Text(
                '이 플랫폼은 지원되지 않습니다.',
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                ),
              ), // '이 플랫폼은 지원되지 않습니다.'라는 내용 표시
              actions: <Widget>[
                // '확인' 버튼 클릭 시 false 반환하고 알림창 닫음
                TextButton(
                  child: Text(
                    '확인',
                    style: TextStyle(
                      fontFamily: 'NanumGothic',
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          }
        },
      ) ??
      false; // 기본적으로 false 반환함 (예외 상황 대비)
}

// 공통적으로 사용할 수 있는 알림창 버튼 생성 함수
// buildAlertActions: 알림창에 표시될 버튼을 생성하는 함수
List<Widget> buildAlertActions(
  BuildContext context, {
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

  // 스낵바 부분 수치 설정
  final double commonSnackBarWidth =
      screenSize.width * (393 / referenceWidth); // 스낵바 너비 설정
  final double commonSnackBarX =
      screenSize.width * (20 / referenceWidth); // X축 패딩
  final double commonSnackBarY =
      screenSize.height * (16 / referenceHeight); // Y축 패딩
  final double commonSnackBarTextFontSize =
      screenSize.height * (14 / referenceHeight); // 텍스트 폰트 크기 설정

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message, // 스낵바에 표시할 메시지
        style: TextStyle(
          fontFamily: 'NanumGothic', // 폰트 설정
          fontWeight: FontWeight.bold, // 폰트 굵기 설정
          fontSize: commonSnackBarTextFontSize, // 폰트 크기 설정
          color: WHITE_COLOR, // 텍스트 색상 설정
        ),
      ),
      backgroundColor: ORANGEGRAY56_COLOR,
      // 색상을 80% 투명도로 설정
      width: commonSnackBarWidth,
      // 스낵바 너비 설정
      behavior: SnackBarBehavior.floating,
      // 스낵바를 떠 있는 형태로 표시
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 설정
      ),
      padding: EdgeInsets.symmetric(
        horizontal: commonSnackBarX, // X축 패딩 설정
        vertical: commonSnackBarY, // Y축 패딩 설정
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
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
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
              color: ORANGE56_COLOR, // 버튼 텍스트 색상 지정
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

// ------- EventPosterImgSectionList 클래스 내용 구현 시작
// 홈 화면 내 이벤트 포스터 이미지 섹션에서 데이터를 4개 단위로 표시하며 스크롤 가능한 UI 구현 관련 클래스
class EventPosterImgSectionList extends ConsumerStatefulWidget {
  // 생성자 선언
  EventPosterImgSectionList();

  @override
  _EventPosterImgSectionListState createState() =>
      _EventPosterImgSectionListState(); // 상태 객체 생성 함수 호출
}

class _EventPosterImgSectionListState
    extends ConsumerState<EventPosterImgSectionList> {
  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러 초기화

  @override
  void initState() {
    super.initState(); // 부모 클래스의 초기화 함수 호출
    _scrollController.addListener(_scrollListener); // 스크롤 리스너 추가
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener); // 스크롤 리스너 제거
    _scrollController.dispose(); // 스크롤 컨트롤러 메모리 해제
    super.dispose(); // 부모 클래스의 dispose 함수 호출
  }

  // 스크롤 리스너 함수 선언
  void _scrollListener() {
    // 스크롤 위치가 스크롤 끝에 가까워지고, 추가 데이터를 로드 중이 아니며 더 로드할 데이터가 남아 있을 때
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !ref.read(eventPosterImgItemsProvider.notifier).isLoadingMore &&
        ref.read(eventPosterImgItemsProvider.notifier).hasMoreData) {
      ref
          .read(eventPosterImgItemsProvider.notifier)
          .loadMoreEventPosterImgItems(); // 추가 데이터 로드 함수 호출
    }
  }

  @override
  Widget build(BuildContext context) {
    // 이벤트 포스터 이미지 항목 데이터 가져오기
    final eventPosterImgItems = ref.watch(eventPosterImgItemsProvider);

    // 화면 크기를 동적으로 가져오기 위한 MediaQuery
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852 (비율 계산에 사용)
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 화면 비율에 따른 가로 크기 설정
    final double DetailDocWidth = screenSize.width * (160 / referenceWidth);
    // 화면 비율에 따른 세로 크기 설정
    final double DetailDocHeight = screenSize.height * (250 / referenceHeight);
    // 아이템 간 여백 비율 설정
    final double DetailDoc1X = screenSize.width * (4 / referenceWidth);

    // 에러 관련 텍스트 수치
    final double errorTextFontSize1 =
        screenSize.height * (12 / referenceHeight);
    final double errorTextFontSize2 =
        screenSize.height * (10 / referenceHeight);

    return SingleChildScrollView(
        controller: _scrollController, // 수평 스크롤 컨트롤러 설정
        scrollDirection: Axis.horizontal, // 수평 스크롤 방향 설정
        child: Row(
          children: eventPosterImgItems.map((eventPosterImgItem) {
            // 각 항목의 이미지 URL 가져오기, 이미지가 없을 경우 '' 빈 칸 사용
            final posterImg = eventPosterImgItem['poster_1'] as String? ?? '';

            return Container(
              width: DetailDocWidth,
              // 설정된 가로 크기 사용
              padding: EdgeInsets.all(DetailDoc1X),
              // 아이템 간 여백 설정
              margin: EdgeInsets.all(DetailDoc1X),
              // 아이템 외부 여백 설정
              decoration: BoxDecoration(
                color: WHITE_COLOR, // 배경색 설정
                borderRadius: BorderRadius.circular(10.0), // 둥근 모서리 설정
                boxShadow: [
                  BoxShadow(
                    color: GRAY62_COLOR.withOpacity(0.5), // 그림자 색상 및 불투명도 설정
                    spreadRadius: 0, // 그림자 퍼짐 정도 설정
                    blurRadius: 1, // 그림자 흐림 정도 설정
                    offset: Offset(0, 4), // 그림자 위치 설정
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () async {
                  // ------ 이벤트 포스터 이미지 클릭 시, 원본 이미지를 로드하는 로직 시작 부분
                  // eventPosterImgItemsProvider의 notifier를 통해 원본 이미지를 비동기적으로 로드
                  final images = await ref
                      .read(eventPosterImgItemsProvider.notifier)
                      .loadEventPosterOriginalImages(eventPosterImgItem['id']);

                  // ------ 이미지 클릭 시 상세 이미지 화면으로 이동 시작 부분
                  // 로드된 이미지가 있을 경우, 상세 이미지 화면으로 네비게이션
                  if (images.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // 클릭된 이미지의 상세 화면으로 이동 라우트 정의
                        builder: (_) => ProductDetailOriginalImageScreen(
                          images: images, // 클릭한 이미지 리스트를 전달
                          initialPage: 0, // 첫 번째 페이지로 시작
                        ),
                      ),
                    );
                  }
                },
                // 포스터 이미지가 있으면 이미지를 표시하고, 없으면 아이콘을 표시
                child: posterImg != null && posterImg!.isNotEmpty
                    ? Image.network(
                        posterImg, // 네트워크 이미지 URL 설정
                        width: DetailDocWidth, // 이미지 가로 크기 설정
                        height: DetailDocHeight, // 이미지 세로 크기 설정
                        fit: BoxFit.cover, // 이미지 맞춤 방식 설정
                        // 이미지 로드 실패 시 아이콘 표시
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: DetailDocHeight, // 전체 화면 높이 설정
                          alignment: Alignment.center, // 중앙 정렬
                          child: buildCommonErrorIndicator(
                            message: '에러가 발생했습니다.',
                            // 첫 번째 메시지 설정
                            secondMessage: '재실행해주세요.',
                            // 두 번째 메시지 설정
                            fontSize1: errorTextFontSize1,
                            // 폰트1 크기 설정
                            fontSize2: errorTextFontSize2,
                            // 폰트2 크기 설정
                            color: BLACK_COLOR,
                            // 색상 설정
                            showSecondMessage: true, // 두 번째 메시지를 표시하도록 설정
                          ),
                        ),
                      )
                    : Container(
                        height: DetailDocHeight, // 전체 화면 높이 설정
                        alignment: Alignment.center, // 중앙 정렬
                        child: buildCommonErrorIndicator(
                          message: '에러가 발생했습니다.',
                          // 첫 번째 메시지 설정
                          secondMessage: '재실행해주세요.',
                          // 두 번째 메시지 설정
                          fontSize1: errorTextFontSize1,
                          // 폰트1 크기 설정
                          fontSize2: errorTextFontSize2,
                          // 폰트2 크기 설정
                          color: BLACK_COLOR,
                          // 색상 설정
                          showSecondMessage: true, // 두 번째 메시지를 표시하도록 설정
                        ),
                      ),
              ),
            );
          }).toList(),
        ));
  }
}
// ------- EventPosterImgSectionList 클래스 내용 구현 끝

// ------- 공통 로딩 인디케이터 위젯 함수 내용 시작
Widget buildCommonLoadingIndicator() {
  return Center(
    child: CircularProgressIndicator(
      color: ORANGE56_COLOR, // 원하는 색상 지정
    ),
  );
}
// ------- 공통 로딩 인디케이터 위젯 함수 내용 끝

// ------- 공통 에러 인디케이터 위젯 함수 내용 시작
Widget buildCommonErrorIndicator({
  required String message, // 첫 번째 메시지, 필수 매개변수
  String? secondMessage, // 두 번째 메시지, 선택 매개변수
  bool showSecondMessage = false, // 두 번째 메시지 표시 여부를 설정할 플래그
  double fontSize1 = 14, // 기본 폰트 크기, 재사용하는 곳에서 변경 가능
  double fontSize2 = 12, // 기본 폰트 크기, 재사용하는 곳에서 변경 가능
  Color color = BLACK_COLOR, // 기본 폰트 색상, 재사용하는 곳에서 변경 가능
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
      children: [
        Text(
          message,
          style: TextStyle(
            color: color, // 재사용하는 곳에서 설정 가능
            fontSize: fontSize1, // 재사용하는 곳에서 설정 가능
            fontWeight: FontWeight.bold, // 고정된 굵기
            fontFamily: 'NanumGothic', // 고정된 폰트 패밀리
          ),
          textAlign: TextAlign.center,
        ),
        if (showSecondMessage && secondMessage != null) ...[
          // 두 번째 메시지를 표시할 조건
          SizedBox(height: 8.0), // 두 텍스트 사이에 간격 추가
          Text(
            secondMessage,
            style: TextStyle(
              color: color, // 재사용하는 곳에서 설정 가능
              fontSize: fontSize2, // 재사용하는 곳에서 설정 가능
              fontWeight: FontWeight.normal, // 고정된 굵기
              fontFamily: 'NanumGothic', // 고정된 폰트 패밀리
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    ),
  );
}
// ------- 공통 에러 인디케이터 위젯 함수 내용 끝

// ------- 공통 로그인이 되어있지 않은 상태에서의 UI 구현 관련 함수 내용 시작
class LoginRequiredWidget extends StatelessWidget {
  final double textWidth;
  final double textHeight;
  final double textFontSize;
  final double buttonWidth;
  final double buttonPaddingX;
  final double buttonPaddingY;
  final double buttonFontSize;
  final double marginTop;
  final double interval;

  const LoginRequiredWidget({
    Key? key,
    required this.textWidth,
    required this.textHeight,
    required this.textFontSize,
    required this.buttonWidth,
    required this.buttonPaddingX,
    required this.buttonPaddingY,
    required this.buttonFontSize,
    required this.marginTop,
    required this.interval,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 안내 문구
        Container(
          width: textWidth, // 텍스트 너비
          height: textHeight, // 텍스트 높이
          margin: EdgeInsets.only(top: marginTop), // 상단 여백
          alignment: Alignment.center, // 중앙 정렬
          child: Text(
            '로그인 후 이용해주세요.', // 안내 문구
            style: TextStyle(
              fontSize: textFontSize, // 텍스트 크기
              fontFamily: 'NanumGothic', // 폰트
              fontWeight: FontWeight.bold, // 굵기
              color: BLACK_COLOR, // 색상
            ),
            textAlign: TextAlign.center, // 중앙 정렬
          ),
        ),
        SizedBox(height: interval), // 텍스트와 버튼 사이 간격
        // 로그인 버튼
        Container(
          width: buttonWidth, // 버튼 너비
          alignment: Alignment.center, // 중앙 정렬
          child: ElevatedButton(
            onPressed: () {
              // 플랫폼에 따라 로그인 화면 이동
              if (Platform.isIOS) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => EasyLoginIosScreen()),
                );
              } else if (Platform.isAndroid) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => EasyLoginAosScreen()),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => EasyLoginAosScreen()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: ORANGE56_COLOR, // 텍스트 색상
              backgroundColor: ORANGE56_COLOR, // 버튼 배경 색상
              padding: EdgeInsets.symmetric(
                vertical: buttonPaddingY,
                horizontal: buttonPaddingX,
              ), // 패딩
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45), // 둥근 모서리
              ),
            ),
            child: Text(
              '로그인 하기', // 버튼 텍스트
              style: TextStyle(
                fontSize: buttonFontSize, // 텍스트 크기
                fontFamily: 'NanumGothic', // 폰트
                fontWeight: FontWeight.bold, // 굵기
                color: WHITE_COLOR, // 텍스트 색상
              ),
            ),
          ),
        ),
      ],
    );
  }
}
// ------- 공통 로그인이 되어있지 않은 상태에서의 UI 구현 관련 함수 내용 끝
