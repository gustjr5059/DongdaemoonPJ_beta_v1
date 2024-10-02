import 'package:dongdaemoon_beta_v1/product/model/product_model.dart'; // Product 모델 클래스 임포트
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart'; // Cupertino 디자인을 사용하기 위한 패키지 임포트
import 'package:flutter/material.dart'; // Material 디자인을 사용하기 위한 패키지 임포트
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리를 위한 Riverpod 패키지 임포트
import 'package:intl/intl.dart';
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../product/layout/product_body_parts_layout.dart';
import '../provider/wishlist_all_providers.dart'; // 찜 목록의 비동기 동작을 위한 Provider 임포트
import '../provider/wishlist_state_provider.dart'; // 찜 목록의 상태 관리를 위한 Provider 임포트

// ------- 찜 목록 아이콘 동작 로직 관련 클래스인 WishlistIconButton 내용 구현 시작
// 찜 목록 아이콘 버튼 위젯을 구현하는 클래스
class WishlistIconButton extends ConsumerWidget {
  // ProductContent 타입의 product를 필드로 가짐
  final ProductContent product;

  // 생성자를 통해 필드 초기화
  WishlistIconButton({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
// 현재 로그인된 사용자 정보를 가져옴
    final user = FirebaseAuth.instance.currentUser;
// user가 null인 경우 (로그인되지 않은 경우)
    if (user == null) {
      // 빈 위젯 반환
      return SizedBox.shrink();
    }
    // 현재 로그인한 사용자 이메일 가져옴
    final userEmail = user.email; // 이메일 주소를 가져옴
    if (userEmail == null) {
      throw Exception('User email not available');
    }
// wishlistItemProvider의 상태를 구독하여 asyncWishlist 변수에 저장
    final asyncWishlist = ref.watch(wishlistItemProvider(userEmail));

    // asyncWishlist 상태에 따라 위젯을 빌드
    return asyncWishlist.when(
      // 데이터가 로드된 경우
      data: (wishlist) {
        // 찜 목록에 현재 상품이 있는지 확인
        final isWished = wishlist.contains(product.docId);
        // 찜 목록이 한도를 초과했는지 확인
        final isWishlistFull = wishlist.length >= 20;

        // 아이콘 버튼 반환
        return IconButton(
          // 찜 목록에 있는 경우 꽉 찬 하트 아이콘, 그렇지 않은 경우 빈 하트 아이콘
          icon: Icon(
            isWished ? Icons.favorite : Icons.favorite_border,
            // 찜 목록에 있는 경우 빨간색, 그렇지 않은 경우 회색
            color: isWished ? Colors.red : Colors.grey,
          ),
          // 버튼 클릭 시 동작 정의
          onPressed: () async {
            // wishlistItemProvider의 notifier를 가져옴
            final wishlistNotifier =
            ref.read(wishlistItemProvider(userEmail).notifier);
            // wishlistItemRepositoryProvider를 가져옴
            final wishlistRepository =
            ref.read(wishlistItemRepositoryProvider);

            // 상품이 찜 목록에 있는 경우
            if (isWished) {
              try {
                // 찜 목록에서 상품 제거
                await wishlistRepository.removeFromWishlistItem(
                    userEmail, product.docId);
                // 로컬 상태 업데이트
                wishlistNotifier.removeItem(product.docId);
                // 사용자에게 알림 표시
                showCustomSnackBar(context, '상품이 찜 목록에서 비워졌습니다.');
              } catch (e) {
                // 오류 발생 시 로컬 상태 복원
                wishlistNotifier.toggleItem(product.docId);
                // 사용자에게 오류 알림 표시
                showCustomSnackBar(context, '찜 목록에서 비우는 중 오류가 발생했습니다.');
              }
            } else {
              // 상품이 찜 목록에 없는 경우
              try {
                // 찜 목록이 20개를 초과했는지 확인
                if (isWishlistFull) {
                  // 한도 초과 메시지 표시
                  showCustomSnackBar(
                    context,
                    '현재 찜 목록에 상품 수량이 한도를 초과했습니다.\n찜 목록에서 상품을 삭제한 후 재시도해주시길 바랍니다.',
                  );
                } else {
                  // 찜 목록에 상품 추가
                  await wishlistRepository.addToWishlistItem(userEmail, product);
                  // 로컬 상태 업데이트
                  wishlistNotifier.addItem(product.docId);
                  // 사용자에게 알림 표시
                  showCustomSnackBar(context, '상품이 찜 목록에 담겼습니다.');
                }
              } catch (e) {
                wishlistNotifier.toggleItem(product.docId);
                // 오류 발생 시 메시지 표시
                showCustomSnackBar(context, '찜 목록에 담는 중 오류가 발생했습니다.');
              }
            }
          },
        );
      },
      // 데이터가 로딩 중인 경우
      loading: () => CircularProgressIndicator(),
      // 에러가 발생한 경우
      error: (e, stack) => Icon(Icons.error),
    );
  }
}
// ------- 찜 목록 아이콘 동작 로직 관련 클래스인 WishlistIconButton 내용 구현 끝

// ------- 찜 목록 화면 내 파이어베이스의 찜 목록 상품 데이터를 불러와서 UI로 구현하는 클래스 내용 시작
class WishlistItemsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 로그인된 사용자 정보를 가져옴
    final user = FirebaseAuth.instance.currentUser;

    // user가 null인 경우 (로그인되지 않은 경우)
    if (user == null) {
      // 빈 위젯 반환
      return Center(child: Text('로그인이 필요합니다.'));
    }

    // 현재 로그인한 사용자 이메일 가져옴
    final userEmail = user.email;
    if (userEmail == null) {
      throw Exception('User email not available');
    }

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 찜 목록 아이템별 카드뷰 섹션 부분 수치
    final double wishlistCardViewWidth =
        screenSize.width * (353 / referenceWidth); // 가로 비율
    final double wishlistCardViewHeight =
        screenSize.height * (143 / referenceHeight); // 세로 비율
    // 썸네일 이미지 부분 수치
    final double wishlistThumnailPartWidth =
        screenSize.width * (126 / referenceWidth); // 가로 비율
    final double wishlistThumnailPartHeight =
        screenSize.height * (126 / referenceHeight); // 세로 비율
    // 텍스트 데이터 부분 수치
    final double wishlistTextDataPartHeight =
        screenSize.height * (126 / referenceHeight); // 세로 비율
    final double wishlistBriefIntroductionFontSize =
        screenSize.height * (15 / referenceHeight);
    final double wishlistOriginalPriceFontSize =
        screenSize.height * (15 / referenceHeight);
    final double wishlistDiscountPercentFontSize =
        screenSize.height * (17 / referenceHeight);
    final double wishlistDiscountPriceFontSize =
        screenSize.height * (19 / referenceHeight);
    // 삭제 버튼 부분 수치
    final double wishlistDeleteBtn1X =
        screenSize.width * (20 / referenceWidth); // 가로 비율
    final double wishlistDeleteBtn1Y =
        screenSize.height * (6 / referenceHeight); // 세로 비율
    final double wishlistDeleteBtnFontSize =
        screenSize.height * (16 / referenceHeight);
    // 텍스트 데이터 간 너비, 높이
    final double wishlist1X =
        screenSize.width * (12 / referenceWidth); // 가로 비율
    final double wishlist2X =
        screenSize.width * (19 / referenceWidth); // 가로 비율
    final double wishlist1Y =
        screenSize.width * (4 / referenceWidth); // 가로 비율

    // 찜 목록 비어있는 경우의 알림 부분 수치
    final double wishlistEmptyTextWidth =
        screenSize.width * (200 / referenceWidth); // 가로 비율
    final double wishlistEmptyTextHeight =
        screenSize.height * (22 / referenceHeight); // 세로 비율
    final double wishlistEmptyTextX =
        screenSize.width * (45 / referenceWidth); // 가로 비율
    final double wishlistEmptyTextY =
        screenSize.height * (300 / referenceHeight); // 세로 비율
    final double wishlistEmptyTextFontSize =
        screenSize.height * (16 / referenceHeight);

    // wishlistItemsStreamProvider를 통해 찜 목록 항목의 스트림을 감시하여, wishlistItemsAsyncValue에 할당.
    final wishlistItemsAsyncValue = ref.watch(wishlistItemsStreamProvider(userEmail));

    // wishItemsAsyncValue의 상태에 따라 위젯을 빌드.
    return wishlistItemsAsyncValue.when(
      // 데이터가 성공적으로 로드되었을 때 실행되는 콜백 함수.
      data: (wishlistItems) {
        // 찜 목록 항목이 비어있을 경우의 조건문.
        if (wishlistItems.isEmpty) {
          // 찜 목록이 비어있을 때 화면에 보여줄 텍스트 위젯을 반환.
          return Container(
              width: wishlistEmptyTextWidth,
              height: wishlistEmptyTextHeight,
              margin: EdgeInsets.only(left: wishlistEmptyTextX, top: wishlistEmptyTextY),
              child: Text('찜 목록이 비어 있습니다.',
                style: TextStyle(
                  fontSize: wishlistEmptyTextFontSize,
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
          );
        }

        // 숫자 형식을 지정하기 위한 NumberFormat 객체 생성
        final numberFormat = NumberFormat('###,###');

        // ProductInfoDetailScreenNavigation 인스턴스 생성
        final navigatorProductDetailScreen = ProductInfoDetailScreenNavigation(ref);

        // 장바구니 아이템들을 UI로 표시
        return Column(
          children: wishlistItems.map((wishlistItem) {

            // 원래 가격을 정수로 변환
            final int originalPrice = wishlistItem['original_price']?.round() ?? 0;
            // 할인된 가격을 정수로 변환
            final int discountPrice = wishlistItem['discount_price']?.round() ?? 0;

            // ProductContent 객체 생성
            final product = ProductContent(
              docId: wishlistItem['product_id'],
              thumbnail: wishlistItem['thumbnails'],
              briefIntroduction: wishlistItem['brief_introduction'],
              originalPrice: wishlistItem['original_price'],
              discountPrice: wishlistItem['discount_price'],
              discountPercent: wishlistItem['discount_percent'],
            );

            return GestureDetector(
              // 탭(클릭) 시 상세 화면으로 이동하게 하는 기능을 정의함
              onTap: () {
                navigatorProductDetailScreen.navigateToDetailScreen(context, product);
              },
              child: Container(
                width: wishlistCardViewWidth,  // CommonCardView의 너비를 지정함
                height: wishlistCardViewHeight, // CommonCardView의 높이를 지정함
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFCECECE), width: 1.0), // 하단 테두리 색상을 지정함
                  ),
                ),
                child: CommonCardView(
                  content: Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 상단에 정렬함
                    children: [
                      Container(
                        // 이미지 컨테이너의 너비를 설정함
                        width: wishlistThumnailPartWidth,
                        // 이미지 컨테이너의 높이를 설정함
                        height: wishlistThumnailPartHeight,
                        // 썸네일이 있을 경우 이미지를 표시하고, 없을 경우 빈 컨테이너를 표시함
                        child: wishlistItem['thumbnails'] != null
                            ? FittedBox(
                          fit: BoxFit.cover,
                          child: Image.network(
                            wishlistItem['thumbnails'] ?? '',
                          ),
                        )
                            : Container(), // 썸네일이 없을 경우 빈 컨테이너를 표시함
                      ),
                      SizedBox(width: wishlist1X),
                      // 텍스트 데이터와 삭제 버튼을 포함하는 컬럼(세로 정렬)을 정의함
                      Expanded(
                        child: Container(
                          height: wishlistTextDataPartHeight, // 텍스트와 삭제 버튼을 포함하는 컬럼의 높이를 설정함
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽으로 정렬함
                            children: [
                              // 텍스트 데이터 부분을 정의함
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬함
                                  children: [
                                    // 상품의 짧은 소개 텍스트를 표시함
                                    Text(
                                      '${wishlistItem['brief_introduction'] ?? ''}',
                                      style: TextStyle(
                                        fontSize: wishlistBriefIntroductionFontSize,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'NanumGothic',
                                        color: Colors.black,
                                      ),
                                      maxLines: 1, // 한 줄로 표시되도록 설정함
                                      overflow: TextOverflow.ellipsis, // 넘칠 경우 말줄임표로 처리함
                                    ),
                                    SizedBox(height: wishlist1Y),
                                    // 상품 원가 텍스트와 할인율을 함께 표시하는 행을 정의함
                                    Row(
                                      children: [
                                        // 상품의 원래 가격 텍스트를 표시함
                                        Text(
                                          '${numberFormat.format(originalPrice)}원',
                                          style: TextStyle(
                                            fontSize: wishlistOriginalPriceFontSize,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'NanumGothic',
                                            color: Color(0xFF6C6C6C),
                                            decoration: TextDecoration.lineThrough, // 가격에 줄을 긋는 스타일을 적용함
                                          ),
                                        ),
                                        SizedBox(width: wishlist2X),
                                        // 상품 할인율 텍스트를 표시함
                                        Text(
                                          '${wishlistItem['discount_percent']?.round() ?? 0}%',
                                          style: TextStyle(
                                            fontSize: wishlistDiscountPercentFontSize,
                                            fontWeight: FontWeight.w800, // ExtraBold 스타일을 적용함
                                            fontFamily: 'NanumGothic',
                                            color: Colors.red, // 빨간색으로 할인율을 강조함
                                          ),
                                        ),
                                      ],
                                    ),
                                    // 상품 할인가 텍스트를 표시함
                                    Text(
                                      '${numberFormat.format(discountPrice)}원',
                                      style: TextStyle(
                                        fontSize: wishlistDiscountPriceFontSize,
                                        fontWeight: FontWeight.w800, // ExtraBold 스타일을 적용함
                                        fontFamily: 'NanumGothic',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // 삭제 버튼을 우측에 배치함
                              Container(
                                alignment: Alignment.centerRight, // 버튼을 오른쪽 정렬함
                                child: ElevatedButton(
                                  // 삭제 버튼을 누를 때 실행되는 비동기 함수를 정의함
                                  onPressed: () async {
                                    await showSubmitAlertDialog(
                                      context, // 현재 화면의 컨텍스트를 전달함
                                      title: '[찜 목록 삭제]', // 대화상자의 제목을 설정함
                                      content: '상품을 삭제하시겠습니까?', // 대화상자의 내용을 경고 메시지로 설정함
                                      actions: buildAlertActions(
                                        context, // 현재 화면의 컨텍스트를 전달함
                                        noText: '아니요', // '아니요' 버튼 텍스트를 설정함
                                        yesText: '예', // '예' 버튼 텍스트를 설정함
                                        noTextStyle: TextStyle(
                                          fontFamily: 'NanumGothic',
                                          color: Colors.black, // '아니요' 텍스트 색상을 검정색으로 설정함
                                          fontWeight: FontWeight.bold, // 텍스트를 굵게 설정함
                                        ),
                                        yesTextStyle: TextStyle(
                                          fontFamily: 'NanumGothic',
                                          color: Colors.red, // '예' 텍스트 색상을 빨간색으로 설정함
                                          fontWeight: FontWeight.bold, // 텍스트를 굵게 설정함
                                        ),
                                        // '예' 버튼이 눌렸을 때 실행될 비동기 함수를 정의함
                                        onYesPressed: () async {
                                          try {
                                            final String? itemId = wishlistItem['product_id'];
                                            if (itemId != null) {
                                              // 찜 목록에서 상품을 제거함
                                              ref.read(wishlistItemProvider(userEmail).notifier).removeItem(itemId);
                                              Navigator.of(context).pop(); // 삭제 후 대화상자를 닫음
                                              // 스낵바로 삭제 성공 메시지를 표시함
                                              showCustomSnackBar(context, '상품이 찜 목록에서 삭제되었습니다.');
                                            } else {
                                              // 유효하지 않은 상품 ID 메시지를 표시함
                                              showCustomSnackBar(context, '삭제하는 중 오류가 발생했습니다.');
                                            }
                                          } catch (e) { // 예외가 발생할 경우 에러 메시지를 처리함
                                            showCustomSnackBar(context, '삭제 중 오류 발생: $e'); // 오류 메시지를 텍스트로 표시함
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  // 삭제 버튼의 스타일을 정의함
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: wishlistDeleteBtn1X, vertical: wishlistDeleteBtn1Y), // 버튼의 크기를 패딩으로 설정
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(37), // 버튼을 둥글게 설정함
                                      side: BorderSide(color: Color(0xFF6F6F6F)), // 테두리 색상을 설정함
                                    ),
                                    backgroundColor: Colors.white, // 버튼 배경색을 앱 배경색과 동일하게 설정함
                                  ),
                                  child: Text(
                                    '삭제',
                                    style: TextStyle(
                                      fontSize: wishlistDeleteBtnFontSize,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'NanumGothic',
                                      color: Colors.black, // 버튼 텍스트 색상을 검정색으로 설정함
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 카드의 배경색을 앱의 기본 배경색으로 설정함
                  elevation: 0, // 그림자를 없앰
                  padding: const EdgeInsets.all(4), // 카드 내부에 패딩을 추가함
                ),
              ),
            );
              }).toList(),
            );
          },
          // 로딩 중일 때 표시할 위젯
          loading: () => Center(child: CircularProgressIndicator()),
          // 에러 발생 시 표시할 위젯
          error: (error, stack) => Center(child: Text('오류가 발생했습니다.')),
        );
      }
    }
// ------- 찜 목록 화면 내 파이어베이스의 찜 목록 상품 데이터를 불러와서 UI로 구현하는 클래스 내용 끝