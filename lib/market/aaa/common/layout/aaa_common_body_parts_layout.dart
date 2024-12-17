
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
