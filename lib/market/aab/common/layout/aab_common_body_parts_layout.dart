
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

import '../../home/provider/aab_home_state_provider.dart';
import '../../product/provider/aab_product_all_providers.dart';
import '../../product/provider/aab_product_state_provider.dart';
import '../../product/view/sub_main_screen/aab_autumn_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aab_best_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aab_new_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aab_sale_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aab_spring_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aab_summer_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aab_winter_sub_main_screen.dart'; // Riverpod 상태 관리 라이브러리


// ------ 대배너 클릭 시 URL 이동 로직 관련 함수 내용 시작
void aabOnLargeBannerTap(BuildContext context, int index,
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
        destinationScreen = AabNewSubMainScreen();
        break;
      case '스테디 셀러':
        destinationScreen = AabBestSubMainScreen();
        break;
      case '특가 상품':
        destinationScreen = AabSaleSubMainScreen();
        break;
      case '봄':
        destinationScreen = AabSpringSubMainScreen();
        break;
      case '여름':
        destinationScreen = AabSummerSubMainScreen();
        break;
      case '가을':
        destinationScreen = AabAutumnSubMainScreen();
        break;
      case '겨울':
        destinationScreen = AabWinterSubMainScreen();
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
void aabOnSmallBannerTap(BuildContext context, int index,
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
class AabStoreInitializer {
  final WidgetRef ref;

  AabStoreInitializer(this.ref);

  void reset() {
    // ------ Aab 상점 초기화 부분 시작
    // 홈 화면 관련 초기화 부분 시작
    // 스크롤 위치 및 현재 탭 인덱스 초기화
    ref.read(aabHomeScrollPositionProvider.notifier).state =
    0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aabHomeCurrentTabProvider.notifier).state =
    0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aabHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
    ref.read(aabHomeSmall1BannerPageProvider.notifier).state =
    0; // 홈 소배너1 페이지뷰 초기화
    ref.read(aabHomeSmall2BannerPageProvider.notifier).state =
    0; // 홈 소배너2 페이지뷰 초기화
    ref.read(aabHomeSmall3BannerPageProvider.notifier).state =
    0; // 홈 소배너3 페이지뷰 초기화
    ref.read(aabHomeSectionScrollPositionsProvider.notifier).state =
    {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
    // 홈 화면 관련 초기화 부분 끝

    // 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
    ref.invalidate(aabMainProductRepositoryProvider);
    ref.invalidate(aabSectionProductRepositoryProvider);
    // 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

    // ------ 2차 메인 화면 관련 부분 시작
    // 블라우스 메인 화면 관련 초기화 부분 시작
    ref.read(aabBlouseMainScrollPositionProvider.notifier).state =
    0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aabBlouseCurrentTabProvider.notifier).state =
    0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aabBlouseMainLargeBannerPageProvider.notifier).state =
    0; // 블라우스 대배너 페이지뷰 초기화
    ref.read(aabBlouseMainSmall1BannerPageProvider.notifier).state =
    0; // 블라우스 소배너 페이지뷰 초기화
    ref
        .read(aabBlouseMainProductListProvider.notifier)
        .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aabBlouseMainSortButtonProvider.notifier).state =
    ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 블라우스 메인 화면 관련 초기화 부분 끝

    // 가디건 메인 화면 관련 초기화 부분 시작
    ref.read(aabCardiganMainScrollPositionProvider.notifier).state =
    0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aabCardiganCurrentTabProvider.notifier).state =
    0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aabCardiganMainLargeBannerPageProvider.notifier).state =
    0; // 가디건 대배너 페이지뷰 초기화
    ref.read(aabCardiganMainSmall1BannerPageProvider.notifier).state =
    0; // 가디건 소배너 페이지뷰 초기화
    ref
        .read(aabCardiganMainProductListProvider.notifier)
        .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aabCardiganMainSortButtonProvider.notifier).state =
    ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 가디건 메인 화면 관련 초기화 부분 끝

    // 코트 메인 화면 관련 초기화 부분 시작
    ref.read(aabCoatMainScrollPositionProvider.notifier).state =
    0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aabCoatCurrentTabProvider.notifier).state =
    0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aabCoatMainLargeBannerPageProvider.notifier).state =
    0; // 코트 대배너 페이지뷰 초기화
    ref.read(aabCoatMainSmall1BannerPageProvider.notifier).state =
    0; // 코트 소배너 페이지뷰 초기화
    ref
        .read(aabCoatMainProductListProvider.notifier)
        .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aabCoatMainSortButtonProvider.notifier).state =
    ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 코트 메인 화면 관련 초기화 부분 끝

    // 청바지 메인 화면 관련 초기화 부분 시작
    ref.read(aabJeanMainScrollPositionProvider.notifier).state =
    0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aabJeanCurrentTabProvider.notifier).state =
    0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aabJeanMainLargeBannerPageProvider.notifier).state =
    0; // 청바지 대배너 페이지뷰 초기화
    ref.read(aabJeanMainSmall1BannerPageProvider.notifier).state =
    0; // 청바지 소배너 페이지뷰 초기화
    ref
        .read(aabJeanMainProductListProvider.notifier)
        .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aabJeanMainSortButtonProvider.notifier).state =
    ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 청바지 메인 화면 관련 초기화 부분 끝

    // 맨투맨 메인 화면 관련 초기화 부분 시작
    ref.read(aabMtmMainScrollPositionProvider.notifier).state =
    0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aabMtmCurrentTabProvider.notifier).state =
    0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aabMtmMainLargeBannerPageProvider.notifier).state =
    0; // 맨투맨 대배너 페이지뷰 초기화
    ref.read(aabMtmMainSmall1BannerPageProvider.notifier).state =
    0; // 맨투맨 소배너 페이지뷰 초기화
    ref
        .read(aabMtmMainProductListProvider.notifier)
        .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aabMtmMainSortButtonProvider.notifier).state =
    ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 맨투맨 메인 화면 관련 초기화 부분 끝

    // 니트 메인 화면 관련 초기화 부분 시작
    ref.read(aabNeatMainScrollPositionProvider.notifier).state =
    0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aabNeatCurrentTabProvider.notifier).state =
    0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aabNeatMainLargeBannerPageProvider.notifier).state =
    0; // 니트 대배너 페이지뷰 초기화
    ref.read(aabNeatMainSmall1BannerPageProvider.notifier).state =
    0; // 니트 소배너 페이지뷰 초기화
    ref
        .read(aabNeatMainProductListProvider.notifier)
        .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aabNeatMainSortButtonProvider.notifier).state =
    ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 니트 메인 화면 관련 초기화 부분 끝

    // 원피스 메인 화면 관련 초기화 부분 시작
    ref.read(aabOnepieceMainScrollPositionProvider.notifier).state =
    0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aabOnepieceCurrentTabProvider.notifier).state =
    0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aabOnepieceMainLargeBannerPageProvider.notifier).state =
    0; // 원피스 대배너 페이지뷰 초기화
    ref.read(aabOnepieceMainSmall1BannerPageProvider.notifier).state =
    0; // 원피스 소배너 페이지뷰 초기화
    ref
        .read(aabOnepieceMainProductListProvider.notifier)
        .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aabOnepieceMainSortButtonProvider.notifier).state =
    ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 원피스 메인 화면 관련 초기화 부분 끝

    // 패딩 메인 화면 관련 초기화 부분 시작
    ref.read(aabPaedingMainScrollPositionProvider.notifier).state =
    0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aabPaedingCurrentTabProvider.notifier).state =
    0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aabPaedingMainLargeBannerPageProvider.notifier).state =
    0; // 패딩 대배너 페이지뷰 초기화
    ref.read(aabPaedingMainSmall1BannerPageProvider.notifier).state =
    0; // 패딩 소배너 페이지뷰 초기화
    ref
        .read(aabPaedingMainProductListProvider.notifier)
        .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aabPaedingMainSortButtonProvider.notifier).state =
    ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 패딩 메인 화면 관련 초기화 부분 끝

    // 팬츠 메인 화면 관련 초기화 부분 시작
    ref.read(aabPantsMainScrollPositionProvider.notifier).state =
    0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aabPantsCurrentTabProvider.notifier).state =
    0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aabPantsMainLargeBannerPageProvider.notifier).state =
    0; // 팬츠 대배너 페이지뷰 초기화
    ref.read(aabPantsMainSmall1BannerPageProvider.notifier).state =
    0; // 팬츠 소배너 페이지뷰 초기화
    ref
        .read(aabPantsMainProductListProvider.notifier)
        .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aabPantsMainSortButtonProvider.notifier).state =
    ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 팬츠 메인 화면 관련 초기화 부분 끝

    // 폴라티 메인 화면 관련 초기화 부분 시작
    ref.read(aabPolaMainScrollPositionProvider.notifier).state =
    0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aabPolaCurrentTabProvider.notifier).state =
    0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aabPolaMainLargeBannerPageProvider.notifier).state =
    0; // 폴라티 대배너 페이지뷰 초기화
    ref.read(aabPolaMainSmall1BannerPageProvider.notifier).state =
    0; // 폴라티 소배너 페이지뷰 초기화
    ref
        .read(aabPolaMainProductListProvider.notifier)
        .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aabPolaMainSortButtonProvider.notifier).state =
    ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 폴라티 메인 화면 관련 초기화 부분 끝

    // 티셔츠 메인 화면 관련 초기화 부분 시작
    ref.read(aabShirtMainScrollPositionProvider.notifier).state =
    0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aabShirtCurrentTabProvider.notifier).state =
    0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aabShirtMainLargeBannerPageProvider.notifier).state =
    0; // 티셔츠 대배너 페이지뷰 초기화
    ref.read(aabShirtMainSmall1BannerPageProvider.notifier).state =
    0; // 티셔츠 소배너 페이지뷰 초기화
    ref
        .read(aabShirtMainProductListProvider.notifier)
        .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aabShirtMainSortButtonProvider.notifier).state =
    ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 티셔츠 메인 화면 관련 초기화 부분 끝

    // 스커트 메인 화면 관련 초기화 부분 시작
    ref.read(aabSkirtMainScrollPositionProvider.notifier).state =
    0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aabSkirtCurrentTabProvider.notifier).state =
    0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aabSkirtMainLargeBannerPageProvider.notifier).state =
    0; // 스커트 대배너 페이지뷰 초기화
    ref.read(aabSkirtMainSmall1BannerPageProvider.notifier).state =
    0; // 스커트 소배너 페이지뷰 초기화
    ref
        .read(aabSkirtMainProductListProvider.notifier)
        .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aabSkirtMainSortButtonProvider.notifier).state =
    ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 스커트 메인 화면 관련 초기화 부분 끝
    // ------ 2차 메인 화면 관련 부분 끝

    // ------ 섹션 더보기 화면 관련 부분 시작
    // 신상 더보기 화면 관련 초기화 부분 시작
    ref.read(aabNewSubMainScrollPositionProvider.notifier).state =
    0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aabNewSubMainProductListProvider.notifier)
        .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
    ref.read(aabNewSubMainSortButtonProvider.notifier).state =
    ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aabNewSubMainLargeBannerPageProvider.notifier).state =
    0; // 신상 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aabNewSubMainSmall1BannerPageProvider.notifier).state =
    0; // 신상 더보기 화면 소배너 페이지뷰 초기화
    // 신상 더보기 화면 관련 초기화 부분 끝

    // 최고 더보기 화면 관련 초기화 부분 시작
    ref.read(aabBestSubMainScrollPositionProvider.notifier).state =
    0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aabBestSubMainProductListProvider.notifier)
        .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
    ref.read(aabBestSubMainSortButtonProvider.notifier).state =
    ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aabBestSubMainLargeBannerPageProvider.notifier).state =
    0; // 최고 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aabBestSubMainSmall1BannerPageProvider.notifier).state =
    0; // 최고 더보기 화면 소배너 페이지뷰 초기화
    // 최고 더보기 화면 관련 초기화 부분 끝

    // 할인 더보기 화면 관련 초기화 부분 시작
    ref.read(aabSaleSubMainScrollPositionProvider.notifier).state =
    0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aabSaleSubMainProductListProvider.notifier)
        .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
    ref.read(aabSaleSubMainSortButtonProvider.notifier).state =
    ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aabSaleSubMainLargeBannerPageProvider.notifier).state =
    0; // 할인 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aabSaleSubMainSmall1BannerPageProvider.notifier).state =
    0; // 할인 더보기 화면 소배너 페이지뷰 초기화
    // 할인 더보기 화면 관련 초기화 부분 끝

    // 봄 더보기 화면 관련 초기화 부분 시작
    ref.read(aabSpringSubMainScrollPositionProvider.notifier).state =
    0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aabSpringSubMainProductListProvider.notifier)
        .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
    ref.read(aabSpringSubMainSortButtonProvider.notifier).state =
    ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aabSpringSubMainLargeBannerPageProvider.notifier).state =
    0; // 봄 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aabSpringSubMainSmall1BannerPageProvider.notifier).state =
    0; // 봄 더보기 화면 소배너 페이지뷰 초기화
    // 봄 더보기 화면 관련 초기화 부분 끝

    // 여름 더보기 화면 관련 초기화 부분 시작
    ref.read(aabSummerSubMainScrollPositionProvider.notifier).state =
    0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aabSummerSubMainProductListProvider.notifier)
        .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
    ref.read(aabSummerSubMainSortButtonProvider.notifier).state =
    ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aabSummerSubMainLargeBannerPageProvider.notifier).state =
    0; // 여름 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aabSummerSubMainSmall1BannerPageProvider.notifier).state =
    0; // 여름 더보기 화면 소배너 페이지뷰 초기화
    // 여름 더보기 화면 관련 초기화 부분 끝

    // 가을 더보기 화면 관련 초기화 부분 시작
    ref.read(aabAutumnSubMainScrollPositionProvider.notifier).state =
    0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aabAutumnSubMainProductListProvider.notifier)
        .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
    ref.read(aabAutumnSubMainSortButtonProvider.notifier).state =
    ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aabAutumnSubMainLargeBannerPageProvider.notifier).state =
    0; // 가을 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aabAutumnSubMainSmall1BannerPageProvider.notifier).state =
    0; // 가을 더보기 화면 소배너 페이지뷰 초기화
    // 가을 더보기 화면 관련 초기화 부분 끝

    // 겨울 더보기 화면 관련 초기화 부분 시작
    ref.read(aabWinterSubMainScrollPositionProvider.notifier).state =
    0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aabWinterSubMainProductListProvider.notifier)
        .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
    ref.read(aabWinterSubMainSortButtonProvider.notifier).state =
    ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aabWinterSubMainLargeBannerPageProvider.notifier).state =
    0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aabWinterSubMainSmall1BannerPageProvider.notifier).state =
    0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
    // 겨울 더보기 화면 관련 초기화 부분 끝
    // ------ 섹션 더보기 화면 관련 부분 끝

    // ------ Aab 상점 초기화 부분 끝
  }
}
// ------ 상점 내 각 화면별 초기화 로직 내용 끝
