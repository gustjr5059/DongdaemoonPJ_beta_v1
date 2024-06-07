
// Dart의 비동기 프로그래밍 기능을 사용하기 위한 'dart:async' 라이브러리를 임포트합니다.
import 'dart:async';
// 네트워크 이미지를 캐싱하는 기능을 제공하는 'cached_network_image' 패키지를 임포트합니다.
// 이 패키지는 이미지 로딩 속도를 개선하고 데이터 사용을 최적화합니다.
import 'package:cached_network_image/cached_network_image.dart';
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
import '../model/banner_model.dart';
import '../provider/common_future_provider.dart'; // 비동기 데이터 로드를 위한 FutureProvider
// Riverpod는 상태 관리를 위한 외부 라이브러리입니다. 이를 통해 애플리케이션의 상태를 효율적으로 관리할 수 있습니다.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리 라이브러리


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
    this.scrollDuration = 300,  // 기본 스크롤 지속 시간을 300ms로 설정
    this.waitDuration = 5000,   // 기본 대기 시간을 5000ms(5초)로 설정
  });

  // 자동 스크롤 기능을 시작하는 함수
  void startAutoScroll() {
    _timer?.cancel(); // 기존에 실행중인 타이머가 있다면 취소
    // 5초마다 반복되는 타이머를 설정
    _timer = Timer.periodic(Duration(milliseconds: waitDuration), (Timer timer) {
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
      fit: BoxFit.contain, // 이미지가 부모 위젯의 경계 내에 들어가도록 조정함.
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
}) {
  // PageView.builder를 반환하여 동적으로 아이템을 생성하는 페이지 뷰를 구현
  return PageView.builder(
    controller: pageController,  // PageController 인스턴스 사용. 페이지 이동 제어
    itemCount: itemCount,        // 총 페이지(아이템)의 수를 지정
    onPageChanged: (index) {
      // 페이지가 변경될 때 호출될 함수. 새 페이지 인덱스를 상태 관리 도구를 통해 업데이트
      ref.read(currentPageProvider.notifier).state = index;
    },
    itemBuilder: itemBuilder,    // 각 페이지를 구성할 위젯을 빌드하는 함수
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
}) {
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
              child: BannerImageClass(imageUrl: commonBannerImages[index].imageUrl),
            ),
            currentPageProvider: currentPageProvider,
            context: context,
          ),
          Positioned(
            right: 40,
            bottom: 10,
            child: Consumer(
              builder: (context, ref, child) {
                final currentPage = ref.watch(currentPageProvider);
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
    required this.content,
    this.backgroundColor = Colors.white,
    this.elevation = 4.0,
    this.margin = const EdgeInsets.all(2),
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    // Card 위젯을 사용하여 시각적 표현을 구현함.
    return Container(
      width: double.infinity, // 해당 위젯이 가능한 한 최대 너비를 가지도록 설정
      child: Card(
        color: backgroundColor,
        elevation: elevation,
        margin: margin,
        child: Padding(
          padding: padding,
          child: content,
        ),
      ),
    );
  }
}
// ------ 범용성으로 재사용가능한 카드뷰인 CommonCardView 클래스 끝

// ------ 공통적으로 사용될 'top' 버튼 위젯 내용 시작
// 'Top' 버튼을 구현하는 위젯
Widget buildTopButton(BuildContext context, ScrollController scrollController) {
  return Positioned(
    top: MediaQuery.of(context).size.height - 200, // 화면 하단에서 200px 위로 위치
    right: 20, // 화면 오른쪽 끝에서 20px 왼쪽으로 위치
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
      child: Text(
        'Top', // 버튼에 표시할 텍스트
        style: TextStyle(color: Colors.black), // 텍스트 색상을 검은색으로 설정
      ),
    ),
  );
}
// ------ 공통적으로 사용될 'top' 버튼 위젯 내용 끝







