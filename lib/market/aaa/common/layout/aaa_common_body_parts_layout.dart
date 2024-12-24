
// 네트워크 이미지를 캐싱하는 기능을 제공하는 'cached_network_image' 패키지를 임포트합니다.
// 이 패키지는 이미지 로딩 속도를 개선하고 데이터 사용을 최적화합니다.
import 'package:flutter/cupertino.dart';

// Flutter의 기본 디자인과 인터페이스 요소들을 사용하기 위한 Material 디자인 패키지를 임포트합니다.
import 'package:flutter/material.dart'; // Flutter의 기본 디자인 위젯
// 외부 웹사이트나 애플리케이션 링크를 열기 위한 URL Launcher 패키지를 임포트합니다.
import 'package:url_launcher/url_launcher.dart';

// 여러 의류 카테고리 화면을 정의한 파일들을 임포트합니다.
import '../../../../common/model/banner_model.dart';
import '../../../../product/layout/product_body_parts_layout.dart';
import '../../../../product/model/product_model.dart';
// Riverpod는 상태 관리를 위한 외부 라이브러리입니다. 이를 통해 애플리케이션의 상태를 효율적으로 관리할 수 있습니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/provider/aaa_home_state_provider.dart';
import '../../product/provider/aaa_product_all_providers.dart';
import '../../product/provider/aaa_product_state_provider.dart';
import '../../product/view/sub_main_screen/aaa_autumn_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aaa_best_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aaa_new_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aaa_sale_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aaa_spring_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aaa_summer_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aaa_winter_sub_main_screen.dart'; // Riverpod 상태 관리 라이브러리


// ------ 대배너 클릭 시 URL 이동 로직 관련 함수 내용 시작
void aaaOnLargeBannerTap(BuildContext context, int index,
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
        destinationScreen = AaaNewSubMainScreen();
        break;
      case '스테디 셀러':
        destinationScreen = AaaBestSubMainScreen();
        break;
      case '특가 상품':
        destinationScreen = AaaSaleSubMainScreen();
        break;
      case '봄':
        destinationScreen = AaaSpringSubMainScreen();
        break;
      case '여름':
        destinationScreen = AaaSummerSubMainScreen();
        break;
      case '가을':
        destinationScreen = AaaAutumnSubMainScreen();
        break;
      case '겨울':
        destinationScreen = AaaWinterSubMainScreen();
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
void aaaOnSmallBannerTap(BuildContext context, int index,
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

// ------ 상점 내 각 화면별 초기화 로직 내용 시작
class AaaStoreInitializer {
  final WidgetRef ref;

  AaaStoreInitializer(this.ref);

  void reset() {
    // ------ Aaa 상점 초기화 부분 시작
    // 홈 화면 관련 초기화 부분 시작
    // 스크롤 위치 및 현재 탭 인덱스 초기화
    ref.read(aaaHomeScrollPositionProvider.notifier).state =
    0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaaHomeCurrentTabProvider.notifier).state =
    0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaaHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
    ref.read(aaaHomeSmall1BannerPageProvider.notifier).state =
    0; // 홈 소배너1 페이지뷰 초기화
    ref.read(aaaHomeSmall2BannerPageProvider.notifier).state =
    0; // 홈 소배너2 페이지뷰 초기화
    ref.read(aaaHomeSmall3BannerPageProvider.notifier).state =
    0; // 홈 소배너3 페이지뷰 초기화
    ref.read(aaaHomeSectionScrollPositionsProvider.notifier).state =
    {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
    // 홈 화면 관련 초기화 부분 끝

    // 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
    ref.invalidate(aaaMainProductRepositoryProvider);
    ref.invalidate(aaaSectionProductRepositoryProvider);
    // 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

    // ------ 2차 메인 화면 관련 부분 시작
    // 블라우스 메인 화면 관련 초기화 부분 시작
    ref.read(aaaBlouseMainScrollPositionProvider.notifier).state =
    0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaaBlouseCurrentTabProvider.notifier).state =
    0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaaBlouseMainLargeBannerPageProvider.notifier).state =
    0; // 블라우스 대배너 페이지뷰 초기화
    ref.read(aaaBlouseMainSmall1BannerPageProvider.notifier).state =
    0; // 블라우스 소배너 페이지뷰 초기화
    ref
        .read(aaaBlouseMainProductListProvider.notifier)
        .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaaBlouseMainSortButtonProvider.notifier).state =
    ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 블라우스 메인 화면 관련 초기화 부분 끝

    // 가디건 메인 화면 관련 초기화 부분 시작
    ref.read(aaaCardiganMainScrollPositionProvider.notifier).state =
    0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaaCardiganCurrentTabProvider.notifier).state =
    0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaaCardiganMainLargeBannerPageProvider.notifier).state =
    0; // 가디건 대배너 페이지뷰 초기화
    ref.read(aaaCardiganMainSmall1BannerPageProvider.notifier).state =
    0; // 가디건 소배너 페이지뷰 초기화
    ref
        .read(aaaCardiganMainProductListProvider.notifier)
        .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaaCardiganMainSortButtonProvider.notifier).state =
    ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 가디건 메인 화면 관련 초기화 부분 끝

    // 코트 메인 화면 관련 초기화 부분 시작
    ref.read(aaaCoatMainScrollPositionProvider.notifier).state =
    0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaaCoatCurrentTabProvider.notifier).state =
    0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaaCoatMainLargeBannerPageProvider.notifier).state =
    0; // 코트 대배너 페이지뷰 초기화
    ref.read(aaaCoatMainSmall1BannerPageProvider.notifier).state =
    0; // 코트 소배너 페이지뷰 초기화
    ref
        .read(aaaCoatMainProductListProvider.notifier)
        .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaaCoatMainSortButtonProvider.notifier).state =
    ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 코트 메인 화면 관련 초기화 부분 끝

    // 청바지 메인 화면 관련 초기화 부분 시작
    ref.read(aaaJeanMainScrollPositionProvider.notifier).state =
    0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaaJeanCurrentTabProvider.notifier).state =
    0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaaJeanMainLargeBannerPageProvider.notifier).state =
    0; // 청바지 대배너 페이지뷰 초기화
    ref.read(aaaJeanMainSmall1BannerPageProvider.notifier).state =
    0; // 청바지 소배너 페이지뷰 초기화
    ref
        .read(aaaJeanMainProductListProvider.notifier)
        .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaaJeanMainSortButtonProvider.notifier).state =
    ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 청바지 메인 화면 관련 초기화 부분 끝

    // 맨투맨 메인 화면 관련 초기화 부분 시작
    ref.read(aaaMtmMainScrollPositionProvider.notifier).state =
    0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaaMtmCurrentTabProvider.notifier).state =
    0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaaMtmMainLargeBannerPageProvider.notifier).state =
    0; // 맨투맨 대배너 페이지뷰 초기화
    ref.read(aaaMtmMainSmall1BannerPageProvider.notifier).state =
    0; // 맨투맨 소배너 페이지뷰 초기화
    ref
        .read(aaaMtmMainProductListProvider.notifier)
        .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaaMtmMainSortButtonProvider.notifier).state =
    ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 맨투맨 메인 화면 관련 초기화 부분 끝

    // 니트 메인 화면 관련 초기화 부분 시작
    ref.read(aaaNeatMainScrollPositionProvider.notifier).state =
    0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaaNeatCurrentTabProvider.notifier).state =
    0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaaNeatMainLargeBannerPageProvider.notifier).state =
    0; // 니트 대배너 페이지뷰 초기화
    ref.read(aaaNeatMainSmall1BannerPageProvider.notifier).state =
    0; // 니트 소배너 페이지뷰 초기화
    ref
        .read(aaaNeatMainProductListProvider.notifier)
        .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaaNeatMainSortButtonProvider.notifier).state =
    ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 니트 메인 화면 관련 초기화 부분 끝

    // 원피스 메인 화면 관련 초기화 부분 시작
    ref.read(aaaOnepieceMainScrollPositionProvider.notifier).state =
    0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaaOnepieceCurrentTabProvider.notifier).state =
    0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaaOnepieceMainLargeBannerPageProvider.notifier).state =
    0; // 원피스 대배너 페이지뷰 초기화
    ref.read(aaaOnepieceMainSmall1BannerPageProvider.notifier).state =
    0; // 원피스 소배너 페이지뷰 초기화
    ref
        .read(aaaOnepieceMainProductListProvider.notifier)
        .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaaOnepieceMainSortButtonProvider.notifier).state =
    ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 원피스 메인 화면 관련 초기화 부분 끝

    // 패딩 메인 화면 관련 초기화 부분 시작
    ref.read(aaaPaedingMainScrollPositionProvider.notifier).state =
    0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaaPaedingCurrentTabProvider.notifier).state =
    0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaaPaedingMainLargeBannerPageProvider.notifier).state =
    0; // 패딩 대배너 페이지뷰 초기화
    ref.read(aaaPaedingMainSmall1BannerPageProvider.notifier).state =
    0; // 패딩 소배너 페이지뷰 초기화
    ref
        .read(aaaPaedingMainProductListProvider.notifier)
        .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaaPaedingMainSortButtonProvider.notifier).state =
    ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 패딩 메인 화면 관련 초기화 부분 끝

    // 팬츠 메인 화면 관련 초기화 부분 시작
    ref.read(aaaPantsMainScrollPositionProvider.notifier).state =
    0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaaPantsCurrentTabProvider.notifier).state =
    0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaaPantsMainLargeBannerPageProvider.notifier).state =
    0; // 팬츠 대배너 페이지뷰 초기화
    ref.read(aaaPantsMainSmall1BannerPageProvider.notifier).state =
    0; // 팬츠 소배너 페이지뷰 초기화
    ref
        .read(aaaPantsMainProductListProvider.notifier)
        .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaaPantsMainSortButtonProvider.notifier).state =
    ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 팬츠 메인 화면 관련 초기화 부분 끝

    // 폴라티 메인 화면 관련 초기화 부분 시작
    ref.read(aaaPolaMainScrollPositionProvider.notifier).state =
    0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaaPolaCurrentTabProvider.notifier).state =
    0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaaPolaMainLargeBannerPageProvider.notifier).state =
    0; // 폴라티 대배너 페이지뷰 초기화
    ref.read(aaaPolaMainSmall1BannerPageProvider.notifier).state =
    0; // 폴라티 소배너 페이지뷰 초기화
    ref
        .read(aaaPolaMainProductListProvider.notifier)
        .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaaPolaMainSortButtonProvider.notifier).state =
    ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 폴라티 메인 화면 관련 초기화 부분 끝

    // 티셔츠 메인 화면 관련 초기화 부분 시작
    ref.read(aaaShirtMainScrollPositionProvider.notifier).state =
    0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaaShirtCurrentTabProvider.notifier).state =
    0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaaShirtMainLargeBannerPageProvider.notifier).state =
    0; // 티셔츠 대배너 페이지뷰 초기화
    ref.read(aaaShirtMainSmall1BannerPageProvider.notifier).state =
    0; // 티셔츠 소배너 페이지뷰 초기화
    ref
        .read(aaaShirtMainProductListProvider.notifier)
        .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaaShirtMainSortButtonProvider.notifier).state =
    ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 티셔츠 메인 화면 관련 초기화 부분 끝

    // 스커트 메인 화면 관련 초기화 부분 시작
    ref.read(aaaSkirtMainScrollPositionProvider.notifier).state =
    0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaaSkirtCurrentTabProvider.notifier).state =
    0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaaSkirtMainLargeBannerPageProvider.notifier).state =
    0; // 스커트 대배너 페이지뷰 초기화
    ref.read(aaaSkirtMainSmall1BannerPageProvider.notifier).state =
    0; // 스커트 소배너 페이지뷰 초기화
    ref
        .read(aaaSkirtMainProductListProvider.notifier)
        .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaaSkirtMainSortButtonProvider.notifier).state =
    ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 스커트 메인 화면 관련 초기화 부분 끝
    // ------ 2차 메인 화면 관련 부분 끝

    // ------ 섹션 더보기 화면 관련 부분 시작
    // 신상 더보기 화면 관련 초기화 부분 시작
    ref.read(aaaNewSubMainScrollPositionProvider.notifier).state =
    0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aaaNewSubMainProductListProvider.notifier)
        .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
    ref.read(aaaNewSubMainSortButtonProvider.notifier).state =
    ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aaaNewSubMainLargeBannerPageProvider.notifier).state =
    0; // 신상 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aaaNewSubMainSmall1BannerPageProvider.notifier).state =
    0; // 신상 더보기 화면 소배너 페이지뷰 초기화
    // 신상 더보기 화면 관련 초기화 부분 끝

    // 최고 더보기 화면 관련 초기화 부분 시작
    ref.read(aaaBestSubMainScrollPositionProvider.notifier).state =
    0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aaaBestSubMainProductListProvider.notifier)
        .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
    ref.read(aaaBestSubMainSortButtonProvider.notifier).state =
    ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aaaBestSubMainLargeBannerPageProvider.notifier).state =
    0; // 최고 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aaaBestSubMainSmall1BannerPageProvider.notifier).state =
    0; // 최고 더보기 화면 소배너 페이지뷰 초기화
    // 최고 더보기 화면 관련 초기화 부분 끝

    // 할인 더보기 화면 관련 초기화 부분 시작
    ref.read(aaaSaleSubMainScrollPositionProvider.notifier).state =
    0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aaaSaleSubMainProductListProvider.notifier)
        .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
    ref.read(aaaSaleSubMainSortButtonProvider.notifier).state =
    ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aaaSaleSubMainLargeBannerPageProvider.notifier).state =
    0; // 할인 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aaaSaleSubMainSmall1BannerPageProvider.notifier).state =
    0; // 할인 더보기 화면 소배너 페이지뷰 초기화
    // 할인 더보기 화면 관련 초기화 부분 끝

    // 봄 더보기 화면 관련 초기화 부분 시작
    ref.read(aaaSpringSubMainScrollPositionProvider.notifier).state =
    0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aaaSpringSubMainProductListProvider.notifier)
        .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
    ref.read(aaaSpringSubMainSortButtonProvider.notifier).state =
    ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aaaSpringSubMainLargeBannerPageProvider.notifier).state =
    0; // 봄 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aaaSpringSubMainSmall1BannerPageProvider.notifier).state =
    0; // 봄 더보기 화면 소배너 페이지뷰 초기화
    // 봄 더보기 화면 관련 초기화 부분 끝

    // 여름 더보기 화면 관련 초기화 부분 시작
    ref.read(aaaSummerSubMainScrollPositionProvider.notifier).state =
    0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aaaSummerSubMainProductListProvider.notifier)
        .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
    ref.read(aaaSummerSubMainSortButtonProvider.notifier).state =
    ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aaaSummerSubMainLargeBannerPageProvider.notifier).state =
    0; // 여름 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aaaSummerSubMainSmall1BannerPageProvider.notifier).state =
    0; // 여름 더보기 화면 소배너 페이지뷰 초기화
    // 여름 더보기 화면 관련 초기화 부분 끝

    // 가을 더보기 화면 관련 초기화 부분 시작
    ref.read(aaaAutumnSubMainScrollPositionProvider.notifier).state =
    0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aaaAutumnSubMainProductListProvider.notifier)
        .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
    ref.read(aaaAutumnSubMainSortButtonProvider.notifier).state =
    ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aaaAutumnSubMainLargeBannerPageProvider.notifier).state =
    0; // 가을 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aaaAutumnSubMainSmall1BannerPageProvider.notifier).state =
    0; // 가을 더보기 화면 소배너 페이지뷰 초기화
    // 가을 더보기 화면 관련 초기화 부분 끝

    // 겨울 더보기 화면 관련 초기화 부분 시작
    ref.read(aaaWinterSubMainScrollPositionProvider.notifier).state =
    0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aaaWinterSubMainProductListProvider.notifier)
        .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
    ref.read(aaaWinterSubMainSortButtonProvider.notifier).state =
    ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aaaWinterSubMainLargeBannerPageProvider.notifier).state =
    0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aaaWinterSubMainSmall1BannerPageProvider.notifier).state =
    0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
    // 겨울 더보기 화면 관련 초기화 부분 끝
    // ------ 섹션 더보기 화면 관련 부분 끝

    // ------ Aaa 상점 초기화 부분 끝
  }
}
// ------ 상점 내 각 화면별 초기화 로직 내용 끝
