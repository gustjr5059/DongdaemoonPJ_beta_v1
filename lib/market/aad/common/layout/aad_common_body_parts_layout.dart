
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

import '../../home/provider/aad_home_state_provider.dart';
import '../../product/provider/aad_product_all_providers.dart';
import '../../product/provider/aad_product_state_provider.dart';
import '../../product/view/sub_main_screen/aad_autumn_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aad_best_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aad_new_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aad_sale_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aad_spring_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aad_summer_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aad_winter_sub_main_screen.dart';


// ------ 대배너 클릭 시 URL 이동 로직 관련 함수 내용 시작
void aadOnLargeBannerTap(BuildContext context, int index,
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
        destinationScreen = AadNewSubMainScreen();
        break;
      case '스테디 셀러':
        destinationScreen = AadBestSubMainScreen();
        break;
      case '특가 상품':
        destinationScreen = AadSaleSubMainScreen();
        break;
      case '봄':
        destinationScreen = AadSpringSubMainScreen();
        break;
      case '여름':
        destinationScreen = AadSummerSubMainScreen();
        break;
      case '가을':
        destinationScreen = AadAutumnSubMainScreen();
        break;
      case '겨울':
        destinationScreen = AadWinterSubMainScreen();
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
void aadOnSmallBannerTap(BuildContext context, int index,
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
class AadStoreInitializer {
  final WidgetRef ref;

  AadStoreInitializer(this.ref);

  void reset() {
    // ------ Aad 상점 초기화 부분 시작
    // 홈 화면 관련 초기화 부분 시작
    // 스크롤 위치 및 현재 탭 인덱스 초기화
    ref.read(aadHomeScrollPositionProvider.notifier).state =
    0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aadHomeCurrentTabProvider.notifier).state =
    0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aadHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
    ref.read(aadHomeSmall1BannerPageProvider.notifier).state =
    0; // 홈 소배너1 페이지뷰 초기화
    ref.read(aadHomeSmall2BannerPageProvider.notifier).state =
    0; // 홈 소배너2 페이지뷰 초기화
    ref.read(aadHomeSmall3BannerPageProvider.notifier).state =
    0; // 홈 소배너3 페이지뷰 초기화
    ref.read(aadHomeSectionScrollPositionsProvider.notifier).state =
    {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
    // 홈 화면 관련 초기화 부분 끝

    // 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
    ref.invalidate(aadMainProductRepositoryProvider);
    ref.invalidate(aadSectionProductRepositoryProvider);
    // 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

    // ------ 2차 메인 화면 관련 부분 시작
    // 블라우스 메인 화면 관련 초기화 부분 시작
    ref.read(aadBlouseMainScrollPositionProvider.notifier).state =
    0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aadBlouseCurrentTabProvider.notifier).state =
    0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aadBlouseMainLargeBannerPageProvider.notifier).state =
    0; // 블라우스 대배너 페이지뷰 초기화
    ref.read(aadBlouseMainSmall1BannerPageProvider.notifier).state =
    0; // 블라우스 소배너 페이지뷰 초기화
    ref
        .read(aadBlouseMainProductListProvider.notifier)
        .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aadBlouseMainSortButtonProvider.notifier).state =
    ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 블라우스 메인 화면 관련 초기화 부분 끝

    // 가디건 메인 화면 관련 초기화 부분 시작
    ref.read(aadCardiganMainScrollPositionProvider.notifier).state =
    0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aadCardiganCurrentTabProvider.notifier).state =
    0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aadCardiganMainLargeBannerPageProvider.notifier).state =
    0; // 가디건 대배너 페이지뷰 초기화
    ref.read(aadCardiganMainSmall1BannerPageProvider.notifier).state =
    0; // 가디건 소배너 페이지뷰 초기화
    ref
        .read(aadCardiganMainProductListProvider.notifier)
        .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aadCardiganMainSortButtonProvider.notifier).state =
    ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 가디건 메인 화면 관련 초기화 부분 끝

    // 코트 메인 화면 관련 초기화 부분 시작
    ref.read(aadCoatMainScrollPositionProvider.notifier).state =
    0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aadCoatCurrentTabProvider.notifier).state =
    0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aadCoatMainLargeBannerPageProvider.notifier).state =
    0; // 코트 대배너 페이지뷰 초기화
    ref.read(aadCoatMainSmall1BannerPageProvider.notifier).state =
    0; // 코트 소배너 페이지뷰 초기화
    ref
        .read(aadCoatMainProductListProvider.notifier)
        .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aadCoatMainSortButtonProvider.notifier).state =
    ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 코트 메인 화면 관련 초기화 부분 끝

    // 청바지 메인 화면 관련 초기화 부분 시작
    ref.read(aadJeanMainScrollPositionProvider.notifier).state =
    0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aadJeanCurrentTabProvider.notifier).state =
    0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aadJeanMainLargeBannerPageProvider.notifier).state =
    0; // 청바지 대배너 페이지뷰 초기화
    ref.read(aadJeanMainSmall1BannerPageProvider.notifier).state =
    0; // 청바지 소배너 페이지뷰 초기화
    ref
        .read(aadJeanMainProductListProvider.notifier)
        .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aadJeanMainSortButtonProvider.notifier).state =
    ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 청바지 메인 화면 관련 초기화 부분 끝

    // 맨투맨 메인 화면 관련 초기화 부분 시작
    ref.read(aadMtmMainScrollPositionProvider.notifier).state =
    0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aadMtmCurrentTabProvider.notifier).state =
    0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aadMtmMainLargeBannerPageProvider.notifier).state =
    0; // 맨투맨 대배너 페이지뷰 초기화
    ref.read(aadMtmMainSmall1BannerPageProvider.notifier).state =
    0; // 맨투맨 소배너 페이지뷰 초기화
    ref
        .read(aadMtmMainProductListProvider.notifier)
        .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aadMtmMainSortButtonProvider.notifier).state =
    ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 맨투맨 메인 화면 관련 초기화 부분 끝

    // 니트 메인 화면 관련 초기화 부분 시작
    ref.read(aadNeatMainScrollPositionProvider.notifier).state =
    0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aadNeatCurrentTabProvider.notifier).state =
    0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aadNeatMainLargeBannerPageProvider.notifier).state =
    0; // 니트 대배너 페이지뷰 초기화
    ref.read(aadNeatMainSmall1BannerPageProvider.notifier).state =
    0; // 니트 소배너 페이지뷰 초기화
    ref
        .read(aadNeatMainProductListProvider.notifier)
        .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aadNeatMainSortButtonProvider.notifier).state =
    ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 니트 메인 화면 관련 초기화 부분 끝

    // 원피스 메인 화면 관련 초기화 부분 시작
    ref.read(aadOnepieceMainScrollPositionProvider.notifier).state =
    0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aadOnepieceCurrentTabProvider.notifier).state =
    0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aadOnepieceMainLargeBannerPageProvider.notifier).state =
    0; // 원피스 대배너 페이지뷰 초기화
    ref.read(aadOnepieceMainSmall1BannerPageProvider.notifier).state =
    0; // 원피스 소배너 페이지뷰 초기화
    ref
        .read(aadOnepieceMainProductListProvider.notifier)
        .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aadOnepieceMainSortButtonProvider.notifier).state =
    ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 원피스 메인 화면 관련 초기화 부분 끝

    // 패딩 메인 화면 관련 초기화 부분 시작
    ref.read(aadPaedingMainScrollPositionProvider.notifier).state =
    0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aadPaedingCurrentTabProvider.notifier).state =
    0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aadPaedingMainLargeBannerPageProvider.notifier).state =
    0; // 패딩 대배너 페이지뷰 초기화
    ref.read(aadPaedingMainSmall1BannerPageProvider.notifier).state =
    0; // 패딩 소배너 페이지뷰 초기화
    ref
        .read(aadPaedingMainProductListProvider.notifier)
        .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aadPaedingMainSortButtonProvider.notifier).state =
    ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 패딩 메인 화면 관련 초기화 부분 끝

    // 팬츠 메인 화면 관련 초기화 부분 시작
    ref.read(aadPantsMainScrollPositionProvider.notifier).state =
    0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aadPantsCurrentTabProvider.notifier).state =
    0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aadPantsMainLargeBannerPageProvider.notifier).state =
    0; // 팬츠 대배너 페이지뷰 초기화
    ref.read(aadPantsMainSmall1BannerPageProvider.notifier).state =
    0; // 팬츠 소배너 페이지뷰 초기화
    ref
        .read(aadPantsMainProductListProvider.notifier)
        .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aadPantsMainSortButtonProvider.notifier).state =
    ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 팬츠 메인 화면 관련 초기화 부분 끝

    // 폴라티 메인 화면 관련 초기화 부분 시작
    ref.read(aadPolaMainScrollPositionProvider.notifier).state =
    0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aadPolaCurrentTabProvider.notifier).state =
    0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aadPolaMainLargeBannerPageProvider.notifier).state =
    0; // 폴라티 대배너 페이지뷰 초기화
    ref.read(aadPolaMainSmall1BannerPageProvider.notifier).state =
    0; // 폴라티 소배너 페이지뷰 초기화
    ref
        .read(aadPolaMainProductListProvider.notifier)
        .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aadPolaMainSortButtonProvider.notifier).state =
    ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 폴라티 메인 화면 관련 초기화 부분 끝

    // 티셔츠 메인 화면 관련 초기화 부분 시작
    ref.read(aadShirtMainScrollPositionProvider.notifier).state =
    0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aadShirtCurrentTabProvider.notifier).state =
    0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aadShirtMainLargeBannerPageProvider.notifier).state =
    0; // 티셔츠 대배너 페이지뷰 초기화
    ref.read(aadShirtMainSmall1BannerPageProvider.notifier).state =
    0; // 티셔츠 소배너 페이지뷰 초기화
    ref
        .read(aadShirtMainProductListProvider.notifier)
        .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aadShirtMainSortButtonProvider.notifier).state =
    ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 티셔츠 메인 화면 관련 초기화 부분 끝

    // 스커트 메인 화면 관련 초기화 부분 시작
    ref.read(aadSkirtMainScrollPositionProvider.notifier).state =
    0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aadSkirtCurrentTabProvider.notifier).state =
    0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aadSkirtMainLargeBannerPageProvider.notifier).state =
    0; // 스커트 대배너 페이지뷰 초기화
    ref.read(aadSkirtMainSmall1BannerPageProvider.notifier).state =
    0; // 스커트 소배너 페이지뷰 초기화
    ref
        .read(aadSkirtMainProductListProvider.notifier)
        .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aadSkirtMainSortButtonProvider.notifier).state =
    ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 스커트 메인 화면 관련 초기화 부분 끝
    // ------ 2차 메인 화면 관련 부분 끝

    // ------ 섹션 더보기 화면 관련 부분 시작
    // 신상 더보기 화면 관련 초기화 부분 시작
    ref.read(aadNewSubMainScrollPositionProvider.notifier).state =
    0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aadNewSubMainProductListProvider.notifier)
        .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
    ref.read(aadNewSubMainSortButtonProvider.notifier).state =
    ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aadNewSubMainLargeBannerPageProvider.notifier).state =
    0; // 신상 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aadNewSubMainSmall1BannerPageProvider.notifier).state =
    0; // 신상 더보기 화면 소배너 페이지뷰 초기화
    // 신상 더보기 화면 관련 초기화 부분 끝

    // 최고 더보기 화면 관련 초기화 부분 시작
    ref.read(aadBestSubMainScrollPositionProvider.notifier).state =
    0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aadBestSubMainProductListProvider.notifier)
        .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
    ref.read(aadBestSubMainSortButtonProvider.notifier).state =
    ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aadBestSubMainLargeBannerPageProvider.notifier).state =
    0; // 최고 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aadBestSubMainSmall1BannerPageProvider.notifier).state =
    0; // 최고 더보기 화면 소배너 페이지뷰 초기화
    // 최고 더보기 화면 관련 초기화 부분 끝

    // 할인 더보기 화면 관련 초기화 부분 시작
    ref.read(aadSaleSubMainScrollPositionProvider.notifier).state =
    0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aadSaleSubMainProductListProvider.notifier)
        .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
    ref.read(aadSaleSubMainSortButtonProvider.notifier).state =
    ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aadSaleSubMainLargeBannerPageProvider.notifier).state =
    0; // 할인 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aadSaleSubMainSmall1BannerPageProvider.notifier).state =
    0; // 할인 더보기 화면 소배너 페이지뷰 초기화
    // 할인 더보기 화면 관련 초기화 부분 끝

    // 봄 더보기 화면 관련 초기화 부분 시작
    ref.read(aadSpringSubMainScrollPositionProvider.notifier).state =
    0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aadSpringSubMainProductListProvider.notifier)
        .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
    ref.read(aadSpringSubMainSortButtonProvider.notifier).state =
    ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aadSpringSubMainLargeBannerPageProvider.notifier).state =
    0; // 봄 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aadSpringSubMainSmall1BannerPageProvider.notifier).state =
    0; // 봄 더보기 화면 소배너 페이지뷰 초기화
    // 봄 더보기 화면 관련 초기화 부분 끝

    // 여름 더보기 화면 관련 초기화 부분 시작
    ref.read(aadSummerSubMainScrollPositionProvider.notifier).state =
    0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aadSummerSubMainProductListProvider.notifier)
        .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
    ref.read(aadSummerSubMainSortButtonProvider.notifier).state =
    ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aadSummerSubMainLargeBannerPageProvider.notifier).state =
    0; // 여름 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aadSummerSubMainSmall1BannerPageProvider.notifier).state =
    0; // 여름 더보기 화면 소배너 페이지뷰 초기화
    // 여름 더보기 화면 관련 초기화 부분 끝

    // 가을 더보기 화면 관련 초기화 부분 시작
    ref.read(aadAutumnSubMainScrollPositionProvider.notifier).state =
    0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aadAutumnSubMainProductListProvider.notifier)
        .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
    ref.read(aadAutumnSubMainSortButtonProvider.notifier).state =
    ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aadAutumnSubMainLargeBannerPageProvider.notifier).state =
    0; // 가을 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aadAutumnSubMainSmall1BannerPageProvider.notifier).state =
    0; // 가을 더보기 화면 소배너 페이지뷰 초기화
    // 가을 더보기 화면 관련 초기화 부분 끝

    // 겨울 더보기 화면 관련 초기화 부분 시작
    ref.read(aadWinterSubMainScrollPositionProvider.notifier).state =
    0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aadWinterSubMainProductListProvider.notifier)
        .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
    ref.read(aadWinterSubMainSortButtonProvider.notifier).state =
    ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aadWinterSubMainLargeBannerPageProvider.notifier).state =
    0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aadWinterSubMainSmall1BannerPageProvider.notifier).state =
    0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
    // 겨울 더보기 화면 관련 초기화 부분 끝
    // ------ 섹션 더보기 화면 관련 부분 끝

    // ------ Aad 상점 초기화 부분 끝
  }
}
// ------ 상점 내 각 화면별 초기화 로직 내용 끝
