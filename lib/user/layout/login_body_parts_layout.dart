import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../announcement/provider/announce_state_provider.dart';
import '../../cart/provider/cart_state_provider.dart';
import '../../common/provider/common_state_provider.dart';
import '../../home/provider/home_state_provider.dart';
import '../../inquiry/provider/inquiry_state_provider.dart';
import '../../manager/message/provider/message_all_provider.dart';
import '../../manager/message/provider/message_state_provider.dart';
import '../../manager/orderlist/provider/orderlist_all_provider.dart';
import '../../manager/orderlist/provider/orderlist_state_provider.dart';
import '../../manager/review/provider/review_all_provider.dart';
import '../../manager/review/provider/review_state_provider.dart';
import '../../market/aaa/home/provider/aaa_home_state_provider.dart';
import '../../market/aaa/product/provider/aaa_product_all_providers.dart';
import '../../market/aaa/product/provider/aaa_product_state_provider.dart';
import '../../market/aab/home/provider/aab_home_state_provider.dart';
import '../../market/aab/product/provider/aab_product_all_providers.dart';
import '../../market/aab/product/provider/aab_product_state_provider.dart';
import '../../market/aac/home/provider/aac_home_state_provider.dart';
import '../../market/aac/product/provider/aac_product_all_providers.dart';
import '../../market/aac/product/provider/aac_product_state_provider.dart';
import '../../market/aad/home/provider/aad_home_state_provider.dart';
import '../../market/aad/product/provider/aad_product_all_providers.dart';
import '../../market/aad/product/provider/aad_product_state_provider.dart';
import '../../market/aae/home/provider/aae_home_state_provider.dart';
import '../../market/aae/product/provider/aae_product_all_providers.dart';
import '../../market/aae/product/provider/aae_product_state_provider.dart';
import '../../market/aaf/home/provider/aaf_home_state_provider.dart';
import '../../market/aaf/product/provider/aaf_product_all_providers.dart';
import '../../market/aaf/product/provider/aaf_product_state_provider.dart';
import '../../market/aag/home/provider/aag_home_state_provider.dart';
import '../../market/aag/product/provider/aag_product_all_providers.dart';
import '../../market/aag/product/provider/aag_product_state_provider.dart';
import '../../market/aah/home/provider/aah_home_state_provider.dart';
import '../../market/aah/product/provider/aah_product_all_providers.dart';
import '../../market/aah/product/provider/aah_product_state_provider.dart';
import '../../market/aai/home/provider/aai_home_state_provider.dart';
import '../../market/aai/product/provider/aai_product_all_providers.dart';
import '../../market/aai/product/provider/aai_product_state_provider.dart';
import '../../market/aaj/home/provider/aaj_home_state_provider.dart';
import '../../market/aaj/product/provider/aaj_product_all_providers.dart';
import '../../market/aaj/product/provider/aaj_product_state_provider.dart';
import '../../market/aak/home/provider/aak_home_state_provider.dart';
import '../../market/aak/product/provider/aak_product_all_providers.dart';
import '../../market/aak/product/provider/aak_product_state_provider.dart';
import '../../market/aal/home/provider/aal_home_state_provider.dart';
import '../../market/aal/product/provider/aal_product_all_providers.dart';
import '../../market/aal/product/provider/aal_product_state_provider.dart';
import '../../market/aam/home/provider/aam_home_state_provider.dart';
import '../../market/aam/product/provider/aam_product_all_providers.dart';
import '../../market/aam/product/provider/aam_product_state_provider.dart';
import '../../market/aan/home/provider/aan_home_state_provider.dart';
import '../../market/aan/product/provider/aan_product_all_providers.dart';
import '../../market/aan/product/provider/aan_product_state_provider.dart';
import '../../market/aao/home/provider/aao_home_state_provider.dart';
import '../../market/aao/product/provider/aao_product_all_providers.dart';
import '../../market/aao/product/provider/aao_product_state_provider.dart';
import '../../market/aap/home/provider/aap_home_state_provider.dart';
import '../../market/aap/product/provider/aap_product_all_providers.dart';
import '../../market/aap/product/provider/aap_product_state_provider.dart';
import '../../market/aaq/home/provider/aaq_home_state_provider.dart';
import '../../market/aaq/product/provider/aaq_product_all_providers.dart';
import '../../market/aaq/product/provider/aaq_product_state_provider.dart';
import '../../market/aar/home/provider/aar_home_state_provider.dart';
import '../../market/aar/product/provider/aar_product_all_providers.dart';
import '../../market/aar/product/provider/aar_product_state_provider.dart';
import '../../market/aas/home/provider/aas_home_state_provider.dart';
import '../../market/aas/product/provider/aas_product_all_providers.dart';
import '../../market/aas/product/provider/aas_product_state_provider.dart';
import '../../market/aat/home/provider/aat_home_state_provider.dart';
import '../../market/aat/product/provider/aat_product_all_providers.dart';
import '../../market/aat/product/provider/aat_product_state_provider.dart';
import '../../market/aau/home/provider/aau_home_state_provider.dart';
import '../../market/aau/product/provider/aau_product_all_providers.dart';
import '../../market/aau/product/provider/aau_product_state_provider.dart';
import '../../market/aav/home/provider/aav_home_state_provider.dart';
import '../../market/aav/product/provider/aav_product_all_providers.dart';
import '../../market/aav/product/provider/aav_product_state_provider.dart';
import '../../market/aaw/home/provider/aaw_home_state_provider.dart';
import '../../market/aaw/product/provider/aaw_product_all_providers.dart';
import '../../market/aaw/product/provider/aaw_product_state_provider.dart';
import '../../market/aax/home/provider/aax_home_state_provider.dart';
import '../../market/aax/product/provider/aax_product_all_providers.dart';
import '../../market/aax/product/provider/aax_product_state_provider.dart';
import '../../market/aay/home/provider/aay_home_state_provider.dart';
import '../../market/aay/product/provider/aay_product_all_providers.dart';
import '../../market/aay/product/provider/aay_product_state_provider.dart';
import '../../market/aaz/home/provider/aaz_home_state_provider.dart';
import '../../market/aaz/product/provider/aaz_product_all_providers.dart';
import '../../market/aaz/product/provider/aaz_product_state_provider.dart';
import '../../market/aba/home/provider/aba_home_state_provider.dart';
import '../../market/aba/product/provider/aba_product_all_providers.dart';
import '../../market/aba/product/provider/aba_product_state_provider.dart';
import '../../market/abb/home/provider/abb_home_state_provider.dart';
import '../../market/abb/product/provider/abb_product_all_providers.dart';
import '../../market/abb/product/provider/abb_product_state_provider.dart';
import '../../market/abc/home/provider/abc_home_state_provider.dart';
import '../../market/abc/product/provider/abc_product_all_providers.dart';
import '../../market/abc/product/provider/abc_product_state_provider.dart';
import '../../market/abd/home/provider/abd_home_state_provider.dart';
import '../../market/abd/product/provider/abd_product_all_providers.dart';
import '../../market/abd/product/provider/abd_product_state_provider.dart';
import '../../message/provider/message_all_provider.dart';
import '../../message/provider/message_state_provider.dart';
import '../../order/provider/complete_payment_provider.dart';
import '../../order/provider/order_all_providers.dart';
import '../../order/provider/order_state_provider.dart';
import '../../product/provider/product_state_provider.dart';
import '../../review/provider/review_state_provider.dart';
import '../../wishlist/provider/wishlist_all_providers.dart';
import '../../wishlist/provider/wishlist_state_provider.dart';
import '../provider/profile_state_provider.dart';

// 로그아웃 및 자동로그인 체크 상태에서 앱 종료 후 재실행 시,
// 홈 내 섹션의 데이터 초기화 / 홈 화면 내 섹션의 스크롤 위치 초기화
// ------ 홈,장바구니,발주내역,마이페이지,2차 메인 화면 등 모든 화면화면 자체의 스크롤 위치 초기화 관련 함수 시작 부분
Future<void> logoutAndLoginAfterProviderReset(WidgetRef ref) async {
  // 로그아웃 기능 수행
  await FirebaseAuth.instance.signOut(); // Firebase 인증 로그아웃
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // 자동 로그인 정보 삭제 및 비활성화
  prefs.setBool('autoLogin', false); // 자동 로그인 체크박스 비활성화
  // prefs.remove('autoLogin'); // 자동 로그인 정보 삭제
  prefs.remove('username'); // 저장된 사용자명 삭제
  prefs.remove('password'); // 저장된 비밀번호 삭제

  // 로그아웃했다가 재로그인 시, 초가화하려면 여기에 적용시켜야 반영이 됨
  // 모든 화면에서 로그아웃 버튼을 클릭했을 때 모든 화면의 상태를 초기화하는 로직-앱 종료 후 재실행할 때인 경우에도 여기 포함됨
  // 각 화면마다의 FirebaseAuth.instance.authStateChanges().listen((user) 여기에도 provider 구현하고, 여기에도 구현하는 두 곳 다 구현해야함.
  // 홈 화면 관련 초기화 부분 시작
  // 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(homeScrollPositionProvider.notifier).state =
      0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(homeCurrentTabProvider.notifier).state =
      0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(midCategoryViewBoolExpandedProvider.notifier).state =
      false; // 홈 화면 내 카테고리 버튼 뷰 확장 상태 관련 provider를 초기화
  ref.read(homeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(homeSmall1BannerPageProvider.notifier).state = 0; // 홈 소배너1 페이지뷰 초기화
  ref.invalidate(marketBtnProvider); // 홈 마켓 버튼 페이지뷰 초기화
  // 홈 화면 관련 초기화 부분 끝

  // 장바구니 화면 관련 초기화 부분 시작
  // 장바구니 화면에서 단순 화면 스크롤 초기화
  ref.read(cartScrollPositionProvider.notifier).state = 0.0;
  ref.invalidate(cartItemsProvider); // 장바구니 데이터 초기화
  // resetAndReloadCartItems를 호출하기 위해 cartItemsProvider.notifier를 읽어서 호출
  ref.read(cartItemsProvider.notifier).resetAndReloadCartItems();
  ref.invalidate(cartItemCountProvider); // 장바구니 아이템 갯수 데이터 초기화
  // 장바구니 화면 관련 초기화 부분 끝

  // 발주 내역 화면 관련 초기화 부분 시작
  // 발주 내역 화면에서 단순 화면 스크롤 초기화
  ref.read(orderListScrollPositionProvider.notifier).state = 0.0;
  // 발주 목록 내 데이터를 불러오는 orderlistItemsProvider 초기화
  ref.invalidate(orderlistItemsProvider);
  // 발주 내역 화면 관련 초기화 부분 끝

  // 발주 내역 상세 화면 관련 초기화 부분 시작
  // 발주 화면에서 로그아웃 이벤트를 실시간으로 감지하고 처리하는 로직 (여기에도 발주 화면 내 프로바이더 중 초기화해야하는 것을 로직 구현)
  ref.read(orderListDetailScrollPositionProvider.notifier).state =
      0.0; // 발주 화면 자체의 스크롤 위치 인덱스를 초기화
  // 발주 목록 상세 화면 내 발주내역 데이터를 불러오는 로직 초기화
  ref.invalidate(orderlistDetailItemProvider);
  // 발주 목록 상세 화면 내 '환불' 버튼과 '리뷰 작성' 버튼 활성도 관련 데이터를 불러오는 로직 초기화
  ref.invalidate(buttonInfoProvider);
  // 발주 내역 상세 화면 관련 초기화 부분 끝

  // ----- 발주 화면 관련 초기화 부분 시작
  // 발주 화면에서 단순 화면 스크롤 초기화
  ref.read(orderMainScrollPositionProvider.notifier).state = 0.0;
  // ref.invalidate(orderItemsProvider); // 발주 상품 정보를 불러오는 프로바이더 초기화
  ref.invalidate(deliveryMethodSelectProvider); // 수령방식 선택 정보를 불러오는 프로바이더 초기화
  // 발주 화면 내 수령자 정보 관련 초기화 부분 시작
  ref.invalidate(recipientInfoItemsProvider); // 수령자 정보 목록 초기화
  ref.invalidate(saveRecipientInfoProvider); // 수령자 정보 저장 관련 상태 초기화
  ref.invalidate(recipientInfoItemRepositoryProvider); // 수령자 정보 Repository 초기화
  // 수령자 정보 즐겨찾기 선택 화면 스크롤 위치 초기화
  ref.read(recipientInfoFavoritesSelectScrollPositionProvider.notifier).state =
      0.0; // 스크롤 위치 초기화
  // 발주 화면 내 수령자 정보 관련 초기화 부분 끝
  // ----- 발주 화면 관련 초기화 부분 끝

  // 발주 완료 화면 관련 초기화 부분 시작
  // 발주 완료 화면에서 단순 화면 스크롤 초기화
  ref.read(completePaymentScrollPositionProvider.notifier).state = 0.0;
  // 발주 완료 화면 관련 초기화 부분 끝

  // 찜 목록 화면 관련 초기화 부분 시작
  // 찜 목록 화면에서 단순 화면 스크롤 초기화
  ref.read(wishlistScrollPositionProvider.notifier).state = 0.0;
  ref.invalidate(wishlistItemProvider); // 찜 목록 데이터 초기화
  ref.invalidate(wishlistItemsLoadFutureProvider); // 찜 목록  데이터 로드 초기화
  ref.invalidate(wishlistItemLoadStreamProvider); // 찜 목록 실시간 삭제된 데이터 로드 초기화
  ref.invalidate(wishlistItemCountProvider); // 찜 목록 아이템 갯수 데이터 초기화
  // 찜 목록 화면 관련 초기화 부분 끝

  // 마이페이지 화면 관련 초기화 부분 시작
  ref.read(profileMainScrollPositionProvider.notifier).state =
      0.0; // 마이페이지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(profileMainSmall1BannerPageProvider.notifier).state =
      0; // 마이페이지 소배너 페이지뷰 초기화
  // 머아패아자 화면 관련 초기화 부분 끝

  // 공지사항 화면 관련 초기화 부분 시작
  ref.read(announceScrollPositionProvider.notifier).state =
      0.0; // 공지사항 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(announceDetailScrollPositionProvider.notifier).state =
      0.0; // 공지사항 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  // 공지사항 화면 내 데이터를 불러오는 announceItemsProvider 초기화
  ref.invalidate(announceItemsProvider);
  // 공지사항 상세 화면 내 데이터를 불러오는 announceDetailItemProvider 초기화
  ref.invalidate(announceDetailItemProvider);
  // 공지사항 화면 관련 초기화 부분 끝

  // 문의하기 화면 관련 초기화 부분 시작
  ref.read(inquiryScrollPositionProvider.notifier).state =
      0.0; // 문의하기 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  // 문의하기 화면 관련 초기화 부분 끝

  // 쪽지 관리 화면 관련 초기화 부분 시작
  ref.read(privateMessageScrollPositionProvider.notifier).state =
      0.0; // 쪽지 관리 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.invalidate(currentUserEmailProvider); // 현재 사용자 이메일 데이터 초기화
  // 계정별로 불러오는 마이페이지용 쪽지함 내 메시지 데이터 불러오는 로직 초기화
  ref.invalidate(privateMessageItemsListNotifierProvider);
  ref.invalidate(paymentCompleteDateProvider); // 결제완료일 데이터 초기화
  ref.invalidate(deliveryStartDateProvider); // 배송시작일 데이터 초기화
  // 쪽지 관리 화면 관련 초기화 부분 끝

  // 리뷰 관리 화면 관련 초기화 부분 시작
  ref.read(privateReviewScrollPositionProvider.notifier).state =
      0.0; // 리뷰 관리 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  // ref.invalidate(reviewUserOrdersProvider); // 리뷰 작성 데이터를 초기화
  // ref.read(privateReviewScreenTabProvider.notifier).state =
  //     ReviewScreenTab.create; // 리뷰 작성/목록 탭 초기화
  // // 리뷰 관리 화면 중 리뷰 작성 탭 화면 내 '환불' 버튼과 '리뷰 작성' 버튼 활성도 관련 데이터를 불러오는 로직 초기화
  // ref.invalidate(buttonInfoProvider);
  // ref.invalidate(reviewListProvider); // 리뷰 목록 초기화
  // ref.invalidate(deleteReviewProvider); // 리뷰 삭제 관련 데이터 초기화
  // ref.invalidate(productReviewProvider); // 특정 상품에 대한 리뷰 데이터를 초기화
  ref.invalidate(privateReviewItmesListNotifierProvider); // 리뷰 데이터를 초기화
  // 리뷰 관리 화면 관련 초기화 부분 끝

  // ------ 관리자용 화면인 리뷰관리, 쪽지관리, 발주내역 관리, 찜 목록 괸리, 공지사항 관리 관련 초기화 부분 시작
  // 리뷰 관리 화면 초기화 시작
  ref.read(adminReviewScrollPositionProvider.notifier).state = 0.0;
  // 선택된 사용자 이메일 초기화
  ref.read(adminSelectedUserEmailProvider.notifier).state = null;
  // 사용자 이메일 목록 초기화
  ref.invalidate(adminUsersEmailProvider);
  // 리뷰 목록 초기화 (프로바이더를 무효화)
  ref.invalidate(adminReviewItemsListNotifierProvider);
  // 리뷰 관리 화면 초기화 끝

  // 쪽지 관리 화면 초기화 시작
  ref.read(adminMessageScrollPositionProvider.notifier).state = 0.0;
  // 쪽지 관리 화면 내 발신자 관련 로그인한 이메일 계정 데이터 불러오는 로직 초기화
  ref.invalidate(currentUserProvider);
  // 쪽지 관리 화면 내 users에 있는 이메일 계정 데이터 불러오는 로직 초기화
  ref.invalidate(receiversProvider);
  // 쪽지 관리 화면 내 선택된 이메일 계정 관련 발주번호 데이터 불러오는 로직 초기화
  ref.invalidate(orderNumbersProvider);
  // 쪽지 관리 화면 초기화 시, 내용 선택 관려 드롭다운 메뉴 선택 상태 초기화
  ref.read(adminMessageContentProvider.notifier).state = null;
  // 쪽지 관리 화면 초기화 시, 선택한 메뉴 관려 텍스트 노출 입력칸 노출 상태 초기화
  ref.read(adminCustomMessageProvider.notifier).state = null;
  // 쪽지 관리 화면 초기화 시, 탭 선택 상태 초기화
  ref.read(adminMessageScreenTabProvider.notifier).state =
      MessageScreenTab.create;
  // 관리자용 쪽지 관리 화면 내 '쪽지 목록' 탭 화면에서 선택된 수신자 이메일 상태 초기화
  // 선택된 수신자 이메일 상태 초기화
  ref.read(selectedReceiverProvider.notifier).state = null;
  // 수신자 이메일 목록 초기화
  ref.invalidate(receiversProvider);
  // 쪽지 목록 초기화 (프로바이더를 무효화)
  ref
      .read(adminMessageItemsListNotifierProvider.notifier)
      .resetAndReloadMessages(timeFrame: 30);

  // 쪽지 관리 화면 초기화 끝

  // 발주내역 관리 화면 초기화 시작
  // 발주내역 관리 화면 자체의 스크롤 초기화
  ref.read(adminOrderlistScrollPositionProvider.notifier).state = 0.0;
  // 발주내역 상세 관리 화면 자체의 스크롤 초기화
  ref.read(adminOrderListDetailScrollPositionProvider.notifier).state = 0.0;
  // 선택된 발주자 이메일 초기화
  ref.read(adminSelectedOrdererEmailProvider.notifier).state = null;
  // 발주자 이메일 목록 초기화
  ref.invalidate(adminOrdererEmailProvider);
  // 발주 내역 초기화 (프로바이더를 무효화)
  ref.invalidate(adminOrderlistItemsListNotifierProvider);
  // 발주내역 관리 화면 초기화 끝
  // ------ 관리자용 화면인 리뷰관리, 쪽지관리, 발주내역 관리, 찜 목록 괸리, 공지사항 관리 관련 초기화 부분 끝

  // ------ 상품 상세 화면 관련 초기화 부분 시작
  // 화면을 돌아왔을 때 선택된 색상과 사이즈의 상태를 초기화함
  ref.read(colorSelectionIndexProvider.notifier).state = 0;
  ref.read(colorSelectionTextProvider.notifier).state = null;
  ref.read(colorSelectionUrlProvider.notifier).state = null;
  ref.read(sizeSelectionIndexProvider.notifier).state = null;
  // 화면을 돌아왔을 때 수량과 총 가격의 상태를 초기화함
  ref.read(detailQuantityIndexProvider.notifier).state = 1;
  // 페이지가 처음 생성될 때 '상품 정보 펼쳐보기' 버튼이 클릭되지 않은 상태로 초기화
  ref.read(showFullImageProvider.notifier).state = false;
  ref.invalidate(imagesProvider); // 상품정보 탭 이미지 데이터 초기화
  ref.invalidate(productReviewListNotifierProvider); // 리뷰 탭 리뷰 데이터 초기화
  // ------ 상품 상세 화면 관련 초기화 부분 끝

  // ------ 상점별 홈 화면, 2차 메인 화면, 상품 상세 화면, 섹션더보기 화면 관련 초기화 부분 시작
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

// ------ Aac 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aacHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aacHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aacHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aacHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aacHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aacHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aacHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aacMainProductRepositoryProvider);
  ref.invalidate(aacSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aacBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aacBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aacBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aacBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aacBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aacBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aacCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aacCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aacCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aacCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aacCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aacCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aacCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aacCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aacCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aacCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aacCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aacCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aacJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aacJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aacJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aacJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aacJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aacJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aacMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aacMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aacMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aacMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aacMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aacMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aacNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aacNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aacNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aacNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aacNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aacNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aacOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aacOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aacOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aacOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aacOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aacOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aacPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aacPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aacPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aacPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aacPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aacPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aacPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aacPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aacPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aacPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aacPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aacPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aacPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aacPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aacPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aacPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aacPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aacPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aacShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aacShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aacShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aacShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aacShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aacShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aacSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aacSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aacSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aacSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aacSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aacSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aacNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aacNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aacNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aacNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aacNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aacBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aacBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aacBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aacBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aacBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aacSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aacSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aacSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aacSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aacSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aacSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aacSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aacSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aacSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aacSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aacSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aacSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aacSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aacSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aacSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aacAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aacAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aacAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aacAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aacAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aacWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aacWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aacWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aacWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aacWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aac 상점 초기화 부분 끝

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

// ------ Aae 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aaeHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaeHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaeHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aaeHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aaeHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aaeHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aaeHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aaeMainProductRepositoryProvider);
  ref.invalidate(aaeSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aaeBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaeBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaeBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aaeBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aaeBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaeBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aaeCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaeCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaeCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aaeCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aaeCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaeCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aaeCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaeCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaeCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aaeCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aaeCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaeCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aaeJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaeJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaeJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aaeJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aaeJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaeJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aaeMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaeMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaeMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aaeMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aaeMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaeMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aaeNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaeNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaeNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aaeNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aaeNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaeNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aaeOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaeOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaeOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aaeOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aaeOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaeOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aaePaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaePaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaePaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aaePaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aaePaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaePaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aaePantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaePantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaePantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aaePantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aaePantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaePantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aaePolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaePolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaePolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aaePolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aaePolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaePolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aaeShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaeShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaeShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aaeShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aaeShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaeShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aaeSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaeSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaeSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aaeSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aaeSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaeSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aaeNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaeNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaeNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaeNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaeNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aaeBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaeBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaeBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaeBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaeBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aaeSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaeSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaeSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaeSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaeSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aaeSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaeSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaeSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaeSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaeSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aaeSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaeSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaeSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaeSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaeSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aaeAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaeAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaeAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaeAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaeAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aaeWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaeWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaeWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaeWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaeWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aae 상점 초기화 부분 끝

// ------ Aaf 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aafHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aafHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aafHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aafHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aafHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aafHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aafHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aafMainProductRepositoryProvider);
  ref.invalidate(aafSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aafBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aafBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aafBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aafBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aafBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aafBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aafCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aafCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aafCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aafCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aafCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aafCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aafCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aafCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aafCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aafCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aafCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aafCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aafJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aafJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aafJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aafJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aafJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aafJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aafMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aafMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aafMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aafMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aafMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aafMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aafNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aafNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aafNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aafNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aafNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aafNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aafOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aafOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aafOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aafOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aafOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aafOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aafPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aafPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aafPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aafPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aafPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aafPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aafPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aafPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aafPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aafPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aafPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aafPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aafPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aafPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aafPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aafPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aafPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aafPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aafShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aafShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aafShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aafShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aafShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aafShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aafSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aafSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aafSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aafSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aafSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aafSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aafNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aafNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aafNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aafNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aafNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aafBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aafBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aafBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aafBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aafBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aafSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aafSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aafSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aafSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aafSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aafSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aafSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aafSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aafSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aafSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aafSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aafSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aafSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aafSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aafSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aafAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aafAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aafAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aafAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aafAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aafWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aafWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aafWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aafWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aafWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aaf 상점 초기화 부분 끝

// ------ Aag 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aagHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aagHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aagHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aagHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aagHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aagHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aagHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aagMainProductRepositoryProvider);
  ref.invalidate(aagSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aagBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aagBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aagBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aagBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aagBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aagBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aagCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aagCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aagCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aagCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aagCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aagCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aagCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aagCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aagCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aagCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aagCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aagCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aagJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aagJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aagJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aagJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aagJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aagJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aagMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aagMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aagMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aagMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aagMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aagMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aagNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aagNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aagNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aagNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aagNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aagNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aagOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aagOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aagOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aagOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aagOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aagOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aagPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aagPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aagPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aagPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aagPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aagPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aagPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aagPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aagPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aagPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aagPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aagPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aagPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aagPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aagPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aagPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aagPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aagPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aagShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aagShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aagShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aagShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aagShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aagShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aagSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aagSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aagSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aagSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aagSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aagSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aagNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aagNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aagNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aagNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aagNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aagBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aagBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aagBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aagBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aagBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aagSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aagSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aagSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aagSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aagSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aagSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aagSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aagSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aagSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aagSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aagSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aagSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aagSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aagSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aagSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aagAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aagAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aagAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aagAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aagAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aagWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aagWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aagWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aagWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aagWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aag 상점 초기화 부분 끝

// ------ Aah 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aahHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aahHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aahHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aahHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aahHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aahHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aahHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aahMainProductRepositoryProvider);
  ref.invalidate(aahSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aahBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aahBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aahBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aahBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aahBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aahBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aahCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aahCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aahCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aahCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aahCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aahCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aahCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aahCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aahCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aahCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aahCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aahCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aahJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aahJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aahJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aahJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aahJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aahJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aahMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aahMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aahMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aahMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aahMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aahMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aahNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aahNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aahNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aahNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aahNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aahNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aahOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aahOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aahOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aahOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aahOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aahOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aahPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aahPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aahPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aahPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aahPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aahPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aahPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aahPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aahPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aahPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aahPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aahPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aahPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aahPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aahPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aahPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aahPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aahPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aahShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aahShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aahShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aahShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aahShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aahShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aahSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aahSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aahSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aahSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aahSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aahSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aahNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aahNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aahNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aahNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aahNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aahBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aahBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aahBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aahBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aahBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aahSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aahSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aahSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aahSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aahSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aahSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aahSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aahSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aahSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aahSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aahSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aahSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aahSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aahSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aahSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aahAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aahAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aahAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aahAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aahAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aahWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aahWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aahWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aahWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aahWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aah 상점 초기화 부분 끝

// ------ Aai 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aaiHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaiHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaiHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aaiHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aaiHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aaiHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aaiHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aaiMainProductRepositoryProvider);
  ref.invalidate(aaiSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aaiBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaiBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaiBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aaiBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aaiBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaiBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aaiCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaiCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaiCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aaiCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aaiCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaiCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aaiCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaiCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaiCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aaiCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aaiCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaiCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aaiJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaiJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaiJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aaiJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aaiJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaiJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aaiMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaiMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaiMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aaiMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aaiMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaiMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aaiNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaiNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaiNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aaiNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aaiNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaiNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aaiOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaiOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaiOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aaiOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aaiOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaiOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aaiPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaiPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaiPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aaiPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aaiPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaiPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aaiPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaiPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaiPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aaiPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aaiPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaiPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aaiPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaiPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaiPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aaiPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aaiPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaiPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aaiShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaiShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaiShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aaiShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aaiShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaiShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aaiSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaiSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaiSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aaiSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aaiSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaiSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aaiNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaiNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaiNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaiNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaiNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aaiBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaiBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaiBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaiBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaiBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aaiSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaiSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaiSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaiSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaiSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aaiSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaiSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaiSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaiSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaiSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aaiSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaiSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaiSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaiSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaiSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aaiAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaiAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaiAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaiAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaiAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aaiWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaiWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaiWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaiWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaiWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aai 상점 초기화 부분 끝

// ------ Aaj 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aajHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aajHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aajHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aajHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aajHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aajHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aajHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aajMainProductRepositoryProvider);
  ref.invalidate(aajSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aajBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aajBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aajBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aajBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aajBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aajBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aajCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aajCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aajCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aajCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aajCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aajCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aajCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aajCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aajCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aajCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aajCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aajCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aajJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aajJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aajJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aajJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aajJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aajJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aajMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aajMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aajMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aajMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aajMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aajMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aajNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aajNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aajNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aajNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aajNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aajNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aajOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aajOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aajOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aajOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aajOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aajOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aajPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aajPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aajPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aajPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aajPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aajPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aajPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aajPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aajPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aajPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aajPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aajPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aajPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aajPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aajPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aajPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aajPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aajPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aajShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aajShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aajShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aajShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aajShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aajShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aajSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aajSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aajSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aajSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aajSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aajSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aajNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aajNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aajNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aajNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aajNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aajBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aajBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aajBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aajBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aajBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aajSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aajSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aajSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aajSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aajSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aajSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aajSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aajSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aajSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aajSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aajSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aajSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aajSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aajSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aajSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aajAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aajAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aajAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aajAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aajAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aajWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aajWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aajWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aajWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aajWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aaj 상점 초기화 부분 끝

// ------ Aak 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aakHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aakHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aakHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aakHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aakHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aakHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aakHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aakMainProductRepositoryProvider);
  ref.invalidate(aakSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aakBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aakBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aakBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aakBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aakBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aakBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aakCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aakCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aakCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aakCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aakCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aakCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aakCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aakCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aakCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aakCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aakCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aakCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aakJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aakJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aakJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aakJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aakJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aakJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aakMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aakMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aakMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aakMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aakMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aakMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aakNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aakNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aakNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aakNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aakNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aakNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aakOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aakOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aakOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aakOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aakOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aakOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aakPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aakPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aakPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aakPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aakPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aakPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aakPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aakPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aakPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aakPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aakPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aakPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aakPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aakPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aakPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aakPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aakPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aakPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aakShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aakShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aakShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aakShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aakShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aakShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aakSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aakSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aakSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aakSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aakSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aakSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aakNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aakNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aakNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aakNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aakNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aakBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aakBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aakBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aakBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aakBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aakSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aakSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aakSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aakSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aakSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aakSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aakSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aakSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aakSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aakSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aakSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aakSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aakSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aakSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aakSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aakAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aakAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aakAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aakAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aakAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aakWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aakWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aakWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aakWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aakWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aak 상점 초기화 부분 끝

// ------ Aal 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aalHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aalHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aalHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aalHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aalHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aalHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aalHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aalMainProductRepositoryProvider);
  ref.invalidate(aalSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aalBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aalBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aalBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aalBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aalBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aalBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aalCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aalCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aalCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aalCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aalCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aalCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aalCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aalCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aalCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aalCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aalCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aalCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aalJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aalJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aalJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aalJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aalJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aalJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aalMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aalMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aalMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aalMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aalMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aalMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aalNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aalNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aalNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aalNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aalNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aalNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aalOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aalOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aalOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aalOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aalOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aalOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aalPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aalPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aalPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aalPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aalPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aalPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aalPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aalPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aalPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aalPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aalPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aalPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aalPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aalPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aalPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aalPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aalPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aalPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aalShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aalShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aalShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aalShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aalShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aalShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aalSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aalSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aalSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aalSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aalSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aalSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aalNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aalNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aalNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aalNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aalNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aalBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aalBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aalBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aalBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aalBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aalSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aalSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aalSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aalSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aalSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aalSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aalSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aalSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aalSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aalSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aalSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aalSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aalSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aalSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aalSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aalAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aalAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aalAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aalAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aalAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aalWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aalWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aalWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aalWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aalWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aal 상점 초기화 부분 끝

// ------ Aam 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aamHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aamHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aamHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aamHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aamHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aamHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aamHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aamMainProductRepositoryProvider);
  ref.invalidate(aamSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aamBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aamBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aamBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aamBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aamBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aamBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aamCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aamCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aamCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aamCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aamCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aamCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aamCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aamCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aamCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aamCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aamCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aamCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aamJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aamJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aamJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aamJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aamJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aamJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aamMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aamMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aamMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aamMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aamMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aamMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aamNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aamNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aamNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aamNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aamNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aamNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aamOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aamOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aamOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aamOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aamOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aamOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aamPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aamPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aamPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aamPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aamPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aamPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aamPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aamPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aamPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aamPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aamPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aamPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aamPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aamPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aamPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aamPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aamPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aamPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aamShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aamShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aamShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aamShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aamShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aamShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aamSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aamSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aamSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aamSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aamSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aamSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aamNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aamNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aamNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aamNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aamNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aamBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aamBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aamBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aamBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aamBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aamSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aamSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aamSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aamSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aamSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aamSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aamSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aamSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aamSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aamSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aamSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aamSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aamSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aamSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aamSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aamAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aamAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aamAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aamAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aamAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aamWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aamWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aamWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aamWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aamWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aam 상점 초기화 부분 끝

// ------ Aan 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aanHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aanHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aanHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aanHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aanHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aanHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aanHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aanMainProductRepositoryProvider);
  ref.invalidate(aanSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aanBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aanBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aanBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aanBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aanBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aanBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aanCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aanCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aanCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aanCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aanCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aanCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aanCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aanCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aanCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aanCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aanCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aanCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aanJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aanJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aanJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aanJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aanJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aanJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aanMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aanMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aanMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aanMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aanMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aanMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aanNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aanNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aanNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aanNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aanNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aanNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aanOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aanOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aanOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aanOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aanOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aanOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aanPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aanPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aanPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aanPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aanPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aanPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aanPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aanPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aanPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aanPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aanPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aanPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aanPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aanPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aanPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aanPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aanPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aanPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aanShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aanShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aanShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aanShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aanShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aanShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aanSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aanSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aanSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aanSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aanSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aanSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aanNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aanNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aanNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aanNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aanNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aanBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aanBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aanBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aanBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aanBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aanSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aanSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aanSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aanSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aanSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aanSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aanSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aanSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aanSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aanSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aanSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aanSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aanSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aanSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aanSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aanAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aanAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aanAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aanAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aanAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aanWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aanWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aanWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aanWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aanWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aan 상점 초기화 부분 끝

// ------ Aao 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aaoHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaoHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaoHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aaoHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aaoHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aaoHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aaoHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aaoMainProductRepositoryProvider);
  ref.invalidate(aaoSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aaoBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaoBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaoBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aaoBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aaoBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaoBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aaoCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaoCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaoCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aaoCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aaoCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaoCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aaoCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaoCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaoCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aaoCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aaoCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaoCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aaoJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaoJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaoJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aaoJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aaoJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaoJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aaoMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaoMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaoMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aaoMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aaoMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaoMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aaoNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaoNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaoNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aaoNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aaoNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaoNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aaoOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaoOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaoOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aaoOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aaoOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaoOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aaoPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaoPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaoPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aaoPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aaoPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaoPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aaoPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaoPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaoPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aaoPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aaoPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaoPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aaoPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaoPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaoPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aaoPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aaoPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaoPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aaoShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaoShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaoShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aaoShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aaoShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaoShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aaoSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaoSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaoSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aaoSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aaoSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaoSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aaoNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaoNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaoNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaoNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaoNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aaoBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaoBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaoBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaoBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaoBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aaoSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaoSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaoSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaoSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaoSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aaoSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaoSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaoSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaoSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaoSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aaoSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaoSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaoSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaoSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaoSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aaoAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaoAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaoAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaoAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaoAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aaoWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaoWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaoWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaoWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaoWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aao 상점 초기화 부분 끝

// ------ Aap 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aapHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aapHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aapHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aapHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aapHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aapHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aapHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aapMainProductRepositoryProvider);
  ref.invalidate(aapSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aapBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aapBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aapBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aapBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aapBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aapBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aapCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aapCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aapCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aapCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aapCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aapCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aapCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aapCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aapCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aapCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aapCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aapCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aapJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aapJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aapJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aapJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aapJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aapJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aapMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aapMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aapMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aapMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aapMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aapMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aapNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aapNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aapNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aapNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aapNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aapNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aapOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aapOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aapOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aapOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aapOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aapOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aapPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aapPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aapPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aapPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aapPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aapPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aapPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aapPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aapPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aapPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aapPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aapPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aapPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aapPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aapPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aapPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aapPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aapPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aapShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aapShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aapShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aapShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aapShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aapShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aapSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aapSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aapSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aapSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aapSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aapSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aapNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aapNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aapNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aapNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aapNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aapBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aapBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aapBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aapBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aapBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aapSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aapSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aapSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aapSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aapSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aapSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aapSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aapSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aapSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aapSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aapSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aapSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aapSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aapSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aapSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aapAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aapAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aapAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aapAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aapAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aapWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aapWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aapWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aapWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aapWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aap 상점 초기화 부분 끝

// ------ Aaq 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aaqHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaqHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaqHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aaqHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aaqHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aaqHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aaqHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aaqMainProductRepositoryProvider);
  ref.invalidate(aaqSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aaqBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaqBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaqBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aaqBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aaqBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaqBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aaqCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaqCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaqCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aaqCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aaqCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaqCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aaqCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaqCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaqCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aaqCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aaqCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaqCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aaqJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaqJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaqJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aaqJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aaqJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaqJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aaqMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaqMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaqMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aaqMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aaqMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaqMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aaqNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaqNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaqNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aaqNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aaqNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaqNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aaqOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaqOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaqOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aaqOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aaqOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaqOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aaqPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaqPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaqPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aaqPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aaqPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaqPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aaqPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaqPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaqPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aaqPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aaqPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaqPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aaqPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaqPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaqPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aaqPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aaqPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaqPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aaqShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaqShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaqShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aaqShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aaqShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaqShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aaqSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaqSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaqSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aaqSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aaqSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaqSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aaqNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaqNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaqNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaqNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaqNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aaqBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaqBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaqBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaqBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaqBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aaqSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaqSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaqSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaqSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaqSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aaqSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaqSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaqSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaqSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaqSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aaqSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaqSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaqSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaqSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaqSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aaqAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaqAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaqAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaqAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaqAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aaqWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaqWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaqWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaqWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaqWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aaq 상점 초기화 부분 끝

// ------ Aar 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aarHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aarHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aarHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aarHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aarHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aarHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aarHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aarMainProductRepositoryProvider);
  ref.invalidate(aarSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aarBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aarBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aarBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aarBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aarBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aarBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aarCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aarCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aarCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aarCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aarCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aarCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aarCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aarCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aarCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aarCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aarCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aarCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aarJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aarJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aarJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aarJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aarJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aarJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aarMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aarMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aarMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aarMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aarMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aarMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aarNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aarNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aarNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aarNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aarNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aarNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aarOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aarOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aarOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aarOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aarOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aarOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aarPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aarPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aarPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aarPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aarPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aarPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aarPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aarPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aarPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aarPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aarPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aarPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aarPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aarPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aarPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aarPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aarPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aarPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aarShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aarShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aarShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aarShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aarShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aarShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aarSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aarSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aarSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aarSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aarSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aarSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aarNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aarNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aarNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aarNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aarNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aarBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aarBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aarBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aarBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aarBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aarSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aarSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aarSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aarSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aarSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aarSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aarSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aarSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aarSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aarSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aarSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aarSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aarSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aarSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aarSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aarAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aarAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aarAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aarAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aarAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aarWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aarWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aarWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aarWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aarWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aar 상점 초기화 부분 끝

// ------ Aas 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aasHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aasHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aasHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aasHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aasHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aasHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aasHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aasMainProductRepositoryProvider);
  ref.invalidate(aasSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aasBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aasBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aasBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aasBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aasBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aasBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aasCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aasCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aasCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aasCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aasCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aasCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aasCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aasCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aasCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aasCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aasCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aasCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aasJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aasJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aasJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aasJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aasJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aasJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aasMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aasMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aasMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aasMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aasMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aasMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aasNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aasNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aasNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aasNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aasNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aasNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aasOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aasOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aasOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aasOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aasOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aasOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aasPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aasPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aasPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aasPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aasPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aasPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aasPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aasPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aasPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aasPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aasPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aasPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aasPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aasPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aasPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aasPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aasPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aasPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aasShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aasShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aasShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aasShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aasShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aasShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aasSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aasSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aasSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aasSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aasSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aasSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aasNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aasNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aasNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aasNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aasNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aasBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aasBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aasBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aasBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aasBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aasSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aasSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aasSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aasSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aasSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aasSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aasSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aasSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aasSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aasSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aasSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aasSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aasSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aasSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aasSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aasAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aasAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aasAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aasAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aasAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aasWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aasWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aasWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aasWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aasWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aas 상점 초기화 부분 끝

// ------ Aat 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aatHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aatHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aatHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aatHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aatHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aatHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aatHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aatMainProductRepositoryProvider);
  ref.invalidate(aatSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aatBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aatBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aatBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aatBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aatBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aatBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aatCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aatCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aatCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aatCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aatCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aatCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aatCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aatCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aatCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aatCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aatCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aatCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aatJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aatJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aatJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aatJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aatJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aatJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aatMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aatMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aatMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aatMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aatMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aatMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aatNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aatNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aatNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aatNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aatNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aatNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aatOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aatOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aatOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aatOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aatOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aatOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aatPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aatPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aatPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aatPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aatPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aatPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aatPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aatPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aatPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aatPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aatPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aatPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aatPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aatPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aatPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aatPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aatPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aatPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aatShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aatShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aatShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aatShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aatShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aatShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aatSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aatSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aatSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aatSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aatSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aatSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aatNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aatNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aatNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aatNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aatNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aatBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aatBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aatBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aatBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aatBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aatSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aatSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aatSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aatSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aatSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aatSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aatSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aatSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aatSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aatSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aatSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aatSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aatSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aatSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aatSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aatAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aatAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aatAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aatAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aatAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aatWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aatWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aatWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aatWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aatWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aat 상점 초기화 부분 끝

// ------ Aau 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aauHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aauHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aauHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aauHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aauHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aauHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aauHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aauMainProductRepositoryProvider);
  ref.invalidate(aauSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aauBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aauBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aauBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aauBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aauBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aauBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aauCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aauCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aauCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aauCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aauCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aauCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aauCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aauCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aauCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aauCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aauCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aauCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aauJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aauJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aauJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aauJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aauJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aauJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aauMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aauMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aauMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aauMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aauMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aauMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aauNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aauNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aauNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aauNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aauNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aauNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aauOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aauOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aauOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aauOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aauOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aauOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aauPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aauPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aauPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aauPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aauPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aauPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aauPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aauPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aauPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aauPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aauPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aauPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aauPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aauPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aauPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aauPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aauPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aauPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aauShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aauShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aauShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aauShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aauShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aauShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aauSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aauSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aauSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aauSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aauSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aauSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aauNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aauNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aauNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aauNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aauNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aauBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aauBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aauBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aauBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aauBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aauSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aauSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aauSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aauSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aauSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aauSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aauSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aauSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aauSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aauSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aauSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aauSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aauSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aauSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aauSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aauAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aauAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aauAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aauAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aauAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aauWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aauWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aauWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aauWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aauWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aau 상점 초기화 부분 끝

// ------ Aav 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aavHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aavHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aavHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aavHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aavHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aavHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aavHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aavMainProductRepositoryProvider);
  ref.invalidate(aavSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aavBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aavBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aavBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aavBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aavBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aavBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aavCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aavCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aavCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aavCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aavCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aavCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aavCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aavCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aavCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aavCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aavCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aavCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aavJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aavJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aavJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aavJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aavJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aavJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aavMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aavMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aavMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aavMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aavMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aavMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aavNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aavNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aavNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aavNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aavNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aavNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aavOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aavOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aavOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aavOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aavOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aavOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aavPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aavPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aavPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aavPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aavPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aavPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aavPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aavPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aavPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aavPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aavPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aavPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aavPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aavPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aavPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aavPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aavPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aavPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aavShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aavShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aavShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aavShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aavShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aavShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aavSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aavSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aavSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aavSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aavSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aavSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aavNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aavNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aavNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aavNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aavNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aavBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aavBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aavBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aavBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aavBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aavSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aavSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aavSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aavSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aavSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aavSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aavSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aavSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aavSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aavSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aavSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aavSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aavSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aavSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aavSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aavAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aavAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aavAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aavAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aavAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aavWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aavWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aavWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aavWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aavWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aav 상점 초기화 부분 끝

// ------ Aaw 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aawHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aawHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aawHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aawHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aawHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aawHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aawHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aawMainProductRepositoryProvider);
  ref.invalidate(aawSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aawBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aawBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aawBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aawBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aawBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aawBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aawCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aawCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aawCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aawCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aawCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aawCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aawCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aawCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aawCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aawCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aawCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aawCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aawJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aawJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aawJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aawJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aawJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aawJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aawMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aawMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aawMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aawMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aawMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aawMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aawNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aawNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aawNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aawNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aawNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aawNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aawOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aawOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aawOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aawOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aawOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aawOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aawPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aawPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aawPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aawPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aawPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aawPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aawPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aawPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aawPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aawPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aawPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aawPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aawPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aawPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aawPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aawPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aawPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aawPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aawShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aawShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aawShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aawShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aawShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aawShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aawSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aawSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aawSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aawSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aawSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aawSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aawNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aawNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aawNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aawNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aawNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aawBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aawBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aawBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aawBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aawBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aawSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aawSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aawSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aawSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aawSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aawSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aawSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aawSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aawSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aawSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aawSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aawSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aawSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aawSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aawSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aawAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aawAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aawAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aawAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aawAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aawWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aawWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aawWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aawWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aawWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aaw 상점 초기화 부분 끝

// ------ Aax 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aaxHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaxHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaxHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aaxHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aaxHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aaxHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aaxHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aaxMainProductRepositoryProvider);
  ref.invalidate(aaxSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aaxBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaxBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaxBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aaxBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aaxBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaxBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aaxCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaxCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaxCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aaxCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aaxCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaxCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aaxCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaxCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaxCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aaxCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aaxCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaxCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aaxJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaxJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaxJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aaxJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aaxJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaxJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aaxMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaxMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaxMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aaxMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aaxMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaxMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aaxNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaxNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaxNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aaxNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aaxNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaxNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aaxOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaxOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaxOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aaxOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aaxOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaxOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aaxPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaxPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaxPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aaxPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aaxPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaxPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aaxPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaxPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaxPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aaxPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aaxPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaxPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aaxPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaxPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaxPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aaxPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aaxPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaxPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aaxShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaxShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaxShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aaxShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aaxShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaxShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aaxSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaxSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaxSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aaxSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aaxSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaxSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aaxNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaxNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaxNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaxNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaxNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aaxBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaxBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaxBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaxBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaxBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aaxSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaxSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaxSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaxSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaxSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aaxSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaxSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaxSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaxSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaxSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aaxSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaxSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaxSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaxSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaxSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aaxAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaxAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaxAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaxAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaxAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aaxWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaxWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaxWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaxWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaxWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aax 상점 초기화 부분 끝

// ------ Aay 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aayHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aayHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aayHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aayHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aayHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aayHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aayHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aayMainProductRepositoryProvider);
  ref.invalidate(aaySectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aayBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aayBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aayBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aayBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aayBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aayBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aayCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aayCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aayCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aayCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aayCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aayCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aayCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aayCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aayCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aayCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aayCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aayCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aayJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aayJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aayJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aayJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aayJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aayJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aayMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aayMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aayMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aayMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aayMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aayMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aayNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aayNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aayNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aayNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aayNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aayNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aayOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aayOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aayOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aayOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aayOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aayOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aayPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aayPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aayPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aayPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aayPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aayPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aayPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aayPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aayPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aayPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aayPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aayPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aayPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aayPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aayPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aayPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aayPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aayPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aayShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aayShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aayShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aayShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aayShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aayShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aaySkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaySkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaySkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aaySkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aaySkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaySkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aayNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aayNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aayNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aayNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aayNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aayBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aayBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aayBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aayBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aayBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aaySaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaySaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaySaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaySaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaySaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aaySpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaySpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaySpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaySpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaySpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aaySummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaySummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaySummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaySummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaySummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aayAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aayAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aayAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aayAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aayAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aayWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aayWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aayWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aayWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aayWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aay 상점 초기화 부분 끝

// ------ Aaz 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aazHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aazHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aazHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aazHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aazHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aazHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(aazHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aazMainProductRepositoryProvider);
  ref.invalidate(aazSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aazBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aazBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aazBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aazBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aazBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aazBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aazCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aazCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aazCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aazCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aazCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aazCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aazCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aazCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aazCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(aazCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aazCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aazCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aazJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aazJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aazJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aazJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aazJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aazJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aazMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aazMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aazMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aazMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aazMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aazMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aazNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aazNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aazNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(aazNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aazNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aazNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aazOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aazOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aazOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aazOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aazOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aazOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aazPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aazPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aazPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aazPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aazPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aazPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aazPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aazPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aazPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aazPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aazPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aazPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aazPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aazPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aazPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aazPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aazPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aazPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aazShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aazShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aazShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aazShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aazShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aazShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aazSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aazSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aazSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aazSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aazSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aazSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aazNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aazNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aazNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aazNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aazNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aazBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aazBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aazBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aazBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aazBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aazSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aazSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aazSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aazSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aazSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aazSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aazSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aazSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aazSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aazSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aazSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aazSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aazSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aazSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aazSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aazAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aazAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aazAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aazAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aazAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aazWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aazWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aazWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aazWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aazWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aaz 상점 초기화 부분 끝

// ------ Aba 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(abaHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abaHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abaHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(abaHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(abaHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(abaHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(abaHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(abaMainProductRepositoryProvider);
  ref.invalidate(abaSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(abaBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abaBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abaBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(abaBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(abaBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abaBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(abaCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abaCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abaCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(abaCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(abaCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abaCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(abaCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abaCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abaCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(abaCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(abaCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abaCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(abaJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abaJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abaJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(abaJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(abaJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abaJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(abaMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abaMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abaMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(abaMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(abaMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abaMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(abaNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abaNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abaNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(abaNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(abaNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abaNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(abaOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abaOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abaOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(abaOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(abaOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abaOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(abaPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abaPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abaPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(abaPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(abaPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abaPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(abaPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abaPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abaPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(abaPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(abaPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abaPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(abaPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abaPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abaPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(abaPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(abaPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abaPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(abaShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abaShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abaShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(abaShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(abaShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abaShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(abaSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abaSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abaSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(abaSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(abaSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abaSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(abaNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abaNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(abaNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abaNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abaNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(abaBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abaBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(abaBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abaBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abaBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(abaSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abaSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(abaSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abaSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abaSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(abaSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abaSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(abaSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abaSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abaSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(abaSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abaSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(abaSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abaSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abaSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(abaAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abaAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(abaAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abaAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abaAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(abaWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abaWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(abaWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abaWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abaWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Aba 상점 초기화 부분 끝

// ------ Abb 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(abbHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abbHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abbHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(abbHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(abbHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(abbHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(abbHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(abbMainProductRepositoryProvider);
  ref.invalidate(abbSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(abbBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abbBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abbBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(abbBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(abbBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abbBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(abbCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abbCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abbCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(abbCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(abbCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abbCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(abbCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abbCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abbCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(abbCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(abbCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abbCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(abbJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abbJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abbJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(abbJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(abbJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abbJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(abbMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abbMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abbMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(abbMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(abbMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abbMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(abbNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abbNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abbNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(abbNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(abbNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abbNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(abbOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abbOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abbOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(abbOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(abbOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abbOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(abbPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abbPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abbPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(abbPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(abbPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abbPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(abbPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abbPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abbPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(abbPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(abbPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abbPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(abbPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abbPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abbPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(abbPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(abbPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abbPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(abbShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abbShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abbShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(abbShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(abbShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abbShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(abbSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abbSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abbSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(abbSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(abbSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abbSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(abbNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abbNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(abbNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abbNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abbNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(abbBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abbBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(abbBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abbBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abbBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(abbSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abbSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(abbSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abbSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abbSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(abbSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abbSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(abbSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abbSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abbSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(abbSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abbSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(abbSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abbSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abbSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(abbAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abbAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(abbAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abbAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abbAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(abbWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abbWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(abbWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abbWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abbWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Abb 상점 초기화 부분 끝

// ------ Abc 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(abcHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abcHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abcHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(abcHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(abcHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(abcHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(abcHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(abcMainProductRepositoryProvider);
  ref.invalidate(abcSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(abcBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abcBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abcBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(abcBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(abcBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abcBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(abcCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abcCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abcCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(abcCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(abcCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abcCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(abcCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abcCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abcCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(abcCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(abcCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abcCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(abcJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abcJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abcJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(abcJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(abcJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abcJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(abcMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abcMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abcMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(abcMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(abcMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abcMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(abcNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abcNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abcNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(abcNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(abcNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abcNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(abcOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abcOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abcOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(abcOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(abcOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abcOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(abcPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abcPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abcPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(abcPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(abcPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abcPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(abcPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abcPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abcPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(abcPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(abcPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abcPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(abcPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abcPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abcPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(abcPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(abcPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abcPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(abcShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abcShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abcShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(abcShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(abcShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abcShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(abcSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abcSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abcSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(abcSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(abcSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abcSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(abcNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abcNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(abcNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abcNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abcNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(abcBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abcBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(abcBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abcBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abcBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(abcSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abcSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(abcSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abcSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abcSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(abcSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abcSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(abcSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abcSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abcSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(abcSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abcSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(abcSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abcSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abcSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(abcAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abcAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(abcAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abcAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abcAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(abcWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abcWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(abcWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abcWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abcWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Abc 상점 초기화 부분 끝

// ------ Abd 상점 초기화 부분 시작
// 홈 화면 관련 초기화 부분 시작
// 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(abdHomeScrollPositionProvider.notifier).state =
  0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abdHomeCurrentTabProvider.notifier).state =
  0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abdHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(abdHomeSmall1BannerPageProvider.notifier).state =
  0; // 홈 소배너1 페이지뷰 초기화
  ref.read(abdHomeSmall2BannerPageProvider.notifier).state =
  0; // 홈 소배너2 페이지뷰 초기화
  ref.read(abdHomeSmall3BannerPageProvider.notifier).state =
  0; // 홈 소배너3 페이지뷰 초기화
  ref.read(abdHomeSectionScrollPositionsProvider.notifier).state =
  {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
// 홈 화면 관련 초기화 부분 끝

// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(abdMainProductRepositoryProvider);
  ref.invalidate(abdSectionProductRepositoryProvider);
// 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

// ------ 2차 메인 화면 관련 부분 시작
// 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(abdBlouseMainScrollPositionProvider.notifier).state =
  0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abdBlouseCurrentTabProvider.notifier).state =
  0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abdBlouseMainLargeBannerPageProvider.notifier).state =
  0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(abdBlouseMainSmall1BannerPageProvider.notifier).state =
  0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(abdBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abdBlouseMainSortButtonProvider.notifier).state =
  ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 블라우스 메인 화면 관련 초기화 부분 끝

// 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(abdCardiganMainScrollPositionProvider.notifier).state =
  0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abdCardiganCurrentTabProvider.notifier).state =
  0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abdCardiganMainLargeBannerPageProvider.notifier).state =
  0; // 가디건 대배너 페이지뷰 초기화
  ref.read(abdCardiganMainSmall1BannerPageProvider.notifier).state =
  0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(abdCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abdCardiganMainSortButtonProvider.notifier).state =
  ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 가디건 메인 화면 관련 초기화 부분 끝

// 코트 메인 화면 관련 초기화 부분 시작
  ref.read(abdCoatMainScrollPositionProvider.notifier).state =
  0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abdCoatCurrentTabProvider.notifier).state =
  0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abdCoatMainLargeBannerPageProvider.notifier).state =
  0; // 코트 대배너 페이지뷰 초기화
  ref.read(abdCoatMainSmall1BannerPageProvider.notifier).state =
  0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(abdCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abdCoatMainSortButtonProvider.notifier).state =
  ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 코트 메인 화면 관련 초기화 부분 끝

// 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(abdJeanMainScrollPositionProvider.notifier).state =
  0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abdJeanCurrentTabProvider.notifier).state =
  0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abdJeanMainLargeBannerPageProvider.notifier).state =
  0; // 청바지 대배너 페이지뷰 초기화
  ref.read(abdJeanMainSmall1BannerPageProvider.notifier).state =
  0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(abdJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abdJeanMainSortButtonProvider.notifier).state =
  ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 청바지 메인 화면 관련 초기화 부분 끝

// 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(abdMtmMainScrollPositionProvider.notifier).state =
  0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abdMtmCurrentTabProvider.notifier).state =
  0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abdMtmMainLargeBannerPageProvider.notifier).state =
  0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(abdMtmMainSmall1BannerPageProvider.notifier).state =
  0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(abdMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abdMtmMainSortButtonProvider.notifier).state =
  ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 맨투맨 메인 화면 관련 초기화 부분 끝

// 니트 메인 화면 관련 초기화 부분 시작
  ref.read(abdNeatMainScrollPositionProvider.notifier).state =
  0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abdNeatCurrentTabProvider.notifier).state =
  0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abdNeatMainLargeBannerPageProvider.notifier).state =
  0; // 니트 대배너 페이지뷰 초기화
  ref.read(abdNeatMainSmall1BannerPageProvider.notifier).state =
  0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(abdNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abdNeatMainSortButtonProvider.notifier).state =
  ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 니트 메인 화면 관련 초기화 부분 끝

// 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(abdOnepieceMainScrollPositionProvider.notifier).state =
  0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abdOnepieceCurrentTabProvider.notifier).state =
  0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abdOnepieceMainLargeBannerPageProvider.notifier).state =
  0; // 원피스 대배너 페이지뷰 초기화
  ref.read(abdOnepieceMainSmall1BannerPageProvider.notifier).state =
  0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(abdOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abdOnepieceMainSortButtonProvider.notifier).state =
  ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 원피스 메인 화면 관련 초기화 부분 끝

// 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(abdPaedingMainScrollPositionProvider.notifier).state =
  0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abdPaedingCurrentTabProvider.notifier).state =
  0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abdPaedingMainLargeBannerPageProvider.notifier).state =
  0; // 패딩 대배너 페이지뷰 초기화
  ref.read(abdPaedingMainSmall1BannerPageProvider.notifier).state =
  0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(abdPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abdPaedingMainSortButtonProvider.notifier).state =
  ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 패딩 메인 화면 관련 초기화 부분 끝

// 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(abdPantsMainScrollPositionProvider.notifier).state =
  0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abdPantsCurrentTabProvider.notifier).state =
  0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abdPantsMainLargeBannerPageProvider.notifier).state =
  0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(abdPantsMainSmall1BannerPageProvider.notifier).state =
  0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(abdPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abdPantsMainSortButtonProvider.notifier).state =
  ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 팬츠 메인 화면 관련 초기화 부분 끝

// 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(abdPolaMainScrollPositionProvider.notifier).state =
  0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abdPolaCurrentTabProvider.notifier).state =
  0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abdPolaMainLargeBannerPageProvider.notifier).state =
  0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(abdPolaMainSmall1BannerPageProvider.notifier).state =
  0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(abdPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abdPolaMainSortButtonProvider.notifier).state =
  ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 폴라티 메인 화면 관련 초기화 부분 끝

// 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(abdShirtMainScrollPositionProvider.notifier).state =
  0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abdShirtCurrentTabProvider.notifier).state =
  0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abdShirtMainLargeBannerPageProvider.notifier).state =
  0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(abdShirtMainSmall1BannerPageProvider.notifier).state =
  0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(abdShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abdShirtMainSortButtonProvider.notifier).state =
  ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 티셔츠 메인 화면 관련 초기화 부분 끝

// 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(abdSkirtMainScrollPositionProvider.notifier).state =
  0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(abdSkirtCurrentTabProvider.notifier).state =
  0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(abdSkirtMainLargeBannerPageProvider.notifier).state =
  0; // 스커트 대배너 페이지뷰 초기화
  ref.read(abdSkirtMainSmall1BannerPageProvider.notifier).state =
  0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(abdSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(abdSkirtMainSortButtonProvider.notifier).state =
  ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
// 스커트 메인 화면 관련 초기화 부분 끝
// ------ 2차 메인 화면 관련 부분 끝

// ------ 섹션 더보기 화면 관련 부분 시작
// 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(abdNewSubMainScrollPositionProvider.notifier).state =
  0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abdNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(abdNewSubMainSortButtonProvider.notifier).state =
  ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abdNewSubMainLargeBannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abdNewSubMainSmall1BannerPageProvider.notifier).state =
  0; // 신상 더보기 화면 소배너 페이지뷰 초기화
// 신상 더보기 화면 관련 초기화 부분 끝

// 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(abdBestSubMainScrollPositionProvider.notifier).state =
  0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abdBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(abdBestSubMainSortButtonProvider.notifier).state =
  ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abdBestSubMainLargeBannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abdBestSubMainSmall1BannerPageProvider.notifier).state =
  0; // 최고 더보기 화면 소배너 페이지뷰 초기화
// 최고 더보기 화면 관련 초기화 부분 끝

// 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(abdSaleSubMainScrollPositionProvider.notifier).state =
  0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abdSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(abdSaleSubMainSortButtonProvider.notifier).state =
  ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abdSaleSubMainLargeBannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abdSaleSubMainSmall1BannerPageProvider.notifier).state =
  0; // 할인 더보기 화면 소배너 페이지뷰 초기화
// 할인 더보기 화면 관련 초기화 부분 끝

// 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(abdSpringSubMainScrollPositionProvider.notifier).state =
  0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abdSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(abdSpringSubMainSortButtonProvider.notifier).state =
  ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abdSpringSubMainLargeBannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abdSpringSubMainSmall1BannerPageProvider.notifier).state =
  0; // 봄 더보기 화면 소배너 페이지뷰 초기화
// 봄 더보기 화면 관련 초기화 부분 끝

// 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(abdSummerSubMainScrollPositionProvider.notifier).state =
  0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abdSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(abdSummerSubMainSortButtonProvider.notifier).state =
  ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abdSummerSubMainLargeBannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abdSummerSubMainSmall1BannerPageProvider.notifier).state =
  0; // 여름 더보기 화면 소배너 페이지뷰 초기화
// 여름 더보기 화면 관련 초기화 부분 끝

// 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(abdAutumnSubMainScrollPositionProvider.notifier).state =
  0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abdAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(abdAutumnSubMainSortButtonProvider.notifier).state =
  ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abdAutumnSubMainLargeBannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abdAutumnSubMainSmall1BannerPageProvider.notifier).state =
  0; // 가을 더보기 화면 소배너 페이지뷰 초기화
// 가을 더보기 화면 관련 초기화 부분 끝

// 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(abdWinterSubMainScrollPositionProvider.notifier).state =
  0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(abdWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(abdWinterSubMainSortButtonProvider.notifier).state =
  ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(abdWinterSubMainLargeBannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(abdWinterSubMainSmall1BannerPageProvider.notifier).state =
  0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
// 겨울 더보기 화면 관련 초기화 부분 끝
// ------ 섹션 더보기 화면 관련 부분 끝

// ------ Abd 상점 초기화 부분 끝

  // ------ 상점별 홈 화면, 2차 메인 화면, 상품 상세 화면, 섹션더보기 화면 관련 초기화 부분 끝
}
// ------ 홈,장바구니,발주내역,마이페이지,2차 메인 화면 등 모든 화면화면 자체의 스크롤 위치 초기화 관련 함수 끝 부분
