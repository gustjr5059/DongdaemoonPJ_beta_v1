import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common/const/colors.dart';
import '../../../common/layout/common_body_parts_layout.dart';
import '../../../product/layout/product_body_parts_layout.dart';
import '../../../product/model/product_model.dart';
import '../../../product/view/detail_screen/product_detail_original_image_screen.dart';
import '../provider/review_all_provider.dart';
import '../provider/review_state_provider.dart';

// ------- 관리자용 리뷰 관리 화면 UI를 구현하는 AdminReviewListScreen 클래스 내용 시작 부분
class AdminReviewListScreen extends ConsumerStatefulWidget {
  @override
  _AdminReviewListScreenState createState() => _AdminReviewListScreenState();
}

class _AdminReviewListScreenState extends ConsumerState<AdminReviewListScreen> {
  Map<int, bool> _expandedReviews = {}; // 리뷰 항목의 펼침 상태를 관리하는 변수

  @override
  void initState() {
    super.initState();
  }

  // review_delete_time 필드의 데이터 타입이 Timestamp로 되어 있어, 이를 DateTime으로 변환한 후, 문자열로 포맷팅하는 함수
  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate(); // Timestamp를 DateTime으로 변환하는 코드
      return DateFormat('[yyyy년 MM월 dd일 HH시 mm분] ')
          .format(dateTime); // 변환된 DateTime을 포맷팅하여 문자열로 반환하는 코드
    } else {
      return ''; // timestamp가 Timestamp 타입이 아닌 경우 빈 문자열 반환
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedUserEmail =
        ref.watch(adminSelectedUserEmailProvider); // 선택된 사용자 이메일을 구독하는 코드
    final usersEmail =
        ref.watch(adminUsersEmailProvider); // 모든 사용자 이메일 목록을 구독하는 코드
    final reviews = ref
        .watch(adminReviewItemsListNotifierProvider); // 선택된 사용자의 리뷰 목록을 구독하는 코드

    // 숫자 형식을 '###,###'로 지정함
    final numberFormat = NumberFormat('###,###');

    // 날짜 형식을 'yyyy년 MM월 dd일 HH시 MM분'로 지정함
    final dateFormat = DateFormat('yyyy년 MM월 dd일 HH시 MM분');

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 리뷰 관리 화면 내 리뷰 목록 탭 내 카드뷰 섹션의 가로와 세로 비율 계산
    final double reviewInfoCardViewWidth =
        screenSize.width * (393 / referenceWidth); // 가로 비율 계산
    final double reviewInfoCardViewHeight =
        screenSize.height * (480 / referenceHeight); // 세로 비율 계산

    // body 부분 전체 패딩 수치 계산
    final double reviewInfoCardViewPaddingX =
        screenSize.width * (15 / referenceWidth); // 좌우 패딩 계산
    final double reviewInfoCardViewPadding1Y =
        screenSize.height * (10 / referenceHeight); // 상하 패딩 계산

    // 비율을 기반으로 동적으로 크기와 위치 설정
    final double reviewBtnWidth = screenSize.width * (130 / referenceWidth);
    final double reviewBtnHeight = screenSize.height * (50 / referenceHeight);
    final double reviewBtnX = screenSize.width * (12 / referenceWidth);
    final double reviewBtnY = screenSize.height * (10 / referenceHeight);
    final double reviewBtnFontSize = screenSize.height * (16 / referenceHeight);
    final double paddingX = screenSize.width * (2 / referenceWidth);
    final double reviewRecipientDropdownBtnWidth =
        screenSize.width * (230 / referenceWidth);
    final double reviewRecipientDropdownBtnHeight =
        screenSize.height * (50 / referenceHeight);

    final double reviewTitleFontSize =
        screenSize.height * (18 / referenceHeight); //  크기 설정함
    final double reviewWriterSelectDataTextSize =
        screenSize.height * (16 / referenceHeight);
    final double reviewDataTextSize1 =
        screenSize.height * (14 / referenceHeight);
    final double reviewDataTextSize2 =
        screenSize.height * (16 / referenceHeight);
    final double reviewDeleteTimeDataTextSize =
        screenSize.height * (13 / referenceHeight);
    final double reviewStatusIconTextSize =
        screenSize.height * (13 / referenceHeight);
    final double reviewOriginalPriceFontSize =
        screenSize.height * (12 / referenceHeight); // 원래 가격 글꼴 크기 설정함
    final double reviewDiscountPercentFontSize =
        screenSize.height * (14 / referenceHeight); // 할인 퍼센트 글꼴 크기 설정함
    final double reviewDiscountPriceFontSize =
        screenSize.height * (14 / referenceHeight); // 할인 가격 글꼴 크기 설정함
    final double reviewSelectedColorTextFontSize =
        screenSize.height * (14 / referenceHeight); // 선택된 색상 텍스트 글꼴 크기 설정함
    final double reviewSelectedSizeTextFontSize =
        screenSize.height * (14 / referenceHeight); // 선택된 사이즈 텍스트 글꼴 크기 설정함
    final double reviewSelectedCountTextFontSize =
        screenSize.height * (14 / referenceHeight); // 선택된 수량 텍스트 글꼴 크기 설정함
    final double reviewOrderNumberDataFontSize =
        screenSize.height * (14 / referenceHeight); //  크기 설정함
    final double reviewProdNumberDataFontSize =
        screenSize.height * (14 / referenceHeight); //  크기 설정함
    final double reviewBriefIntroductionDataFontSize =
        screenSize.height * (14 / referenceHeight); //  크기 설정함

    // 상품 색상 이미지 크기 설정
    final double reviewSelctedColorImageDataWidth =
        screenSize.width * (16 / referenceWidth); // 색상 이미지 가로 크기 설정함
    final double reviewSelctedColorImageDataHeight =
        screenSize.width * (16 / referenceWidth); // 색상 이미지 세로 크기 설정함

    final double reviewTitleTextFontSize =
        screenSize.height * (14 / referenceHeight); // 리뷰 제목 텍스트 글꼴 크기 설정함
    final double reviewContentsTextFontSize =
        screenSize.height * (14 / referenceHeight); // 리뷰 내용 텍스트 글꼴 크기 설정함
    final double reviewWriteDateTextFontSize =
        screenSize.height * (14 / referenceHeight); // 리뷰 작성일자 텍스트 글꼴 크기 설정함
    final double reviewExpandedBtnFontSize =
        screenSize.height * (14 / referenceHeight); // 펼치기 및 닫기 버튼 크기
    final double reviewExpandedBtnHeight =
        screenSize.height * (30 / referenceHeight);

    // 삭제 버튼 수치
    final double deleteBtnHeight = screenSize.height * (30 / referenceHeight);
    final double deleteBtnWidth = screenSize.width * (60 / referenceWidth);
    final double intervalX = screenSize.width * (8 / referenceWidth);
    final double deleteBtnPaddingY = screenSize.height * (2 / referenceHeight);
    final double deleteBtnPaddingX = screenSize.width * (4 / referenceWidth);
    final double deleteBtnFontSize = screenSize.height * (12 / referenceHeight);

    // 컨텐츠 사이의 간격 수치
    final double interval1Y = screenSize.height * (20 / referenceHeight);
    final double interval2Y = screenSize.height * (2 / referenceHeight);
    final double interval3Y = screenSize.height * (4 / referenceHeight);
    final double interval4Y = screenSize.height * (6 / referenceHeight);
    final double interval5Y = screenSize.height * (8 / referenceHeight);
    final double interval1X = screenSize.width * (8 / referenceWidth);
    final double interval2X = screenSize.width * (19 / referenceWidth);
    final double interval3X = screenSize.width * (20 / referenceWidth);
    final double interval4X = screenSize.width * (70 / referenceWidth);

    // 리뷰 목록 부분이 비어있는 경우의 알림 부분 수치
    final double reviewEmptyTextWidth =
        screenSize.width * (250 / referenceWidth); // 가로 비율
    final double reviewEmptyTextHeight =
        screenSize.height * (22 / referenceHeight); // 세로 비율
    final double reviewEmptyTextX =
        screenSize.width * (70 / referenceWidth); // 가로 비율
    final double reviewEmptyTextY =
        screenSize.height * (200 / referenceHeight); // 세로 비율
    final double reviewEmptyTextFontSize =
        screenSize.height * (16 / referenceHeight);

    return Column(
      children: [
        SizedBox(height: interval3Y),
        // 드롭다운 버튼을 중앙에 위치시키기 위해 Center 위젯을 추가
        Center(
          child: Container(
            width: reviewRecipientDropdownBtnWidth,
            height: reviewRecipientDropdownBtnHeight,
            decoration: BoxDecoration(
              // color: GRAY96_COLOR,
              color: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
              border: Border.all(color: GRAY83_COLOR, width: 1), // 윤곽선
              borderRadius: BorderRadius.circular(6),
            ),
            padding: EdgeInsets.symmetric(horizontal: intervalX),
            alignment: Alignment.center,
            // 텍스트 정렬
            child: DropdownButtonHideUnderline(
              child: usersEmail.when(
                data: (usersEmailList) {
                  final uniqueUsersEmailList =
                      usersEmailList.toSet().toList(); // 드롭다운 메뉴 이메일값들
                  final validSelectedUserEmail = (selectedUserEmail != null &&
                          uniqueUsersEmailList.contains(selectedUserEmail))
                      ? selectedUserEmail
                      : null; // 드롭다운 메뉴에서 선택된 이메일 값이 유효하지 않을 경우 null 처리

                  return DropdownButton<String>(
                    hint: Center(
                      child: Text(
                        '리뷰 작성자 선택',
                        style: TextStyle(
                          fontFamily: 'NanumGothic',
                          fontSize: reviewWriterSelectDataTextSize,
                        ),
                      ),
                    ),
                    // 드롭다운 버튼의 힌트 텍스트 설정
                    // // value: selectedUserEmail ?? '', // 선택된 이메일 값을 드롭다운 버튼에 반영하는 코드
                    // value: (selectedUserEmail?.isNotEmpty ?? false)
                    //     ? selectedUserEmail
                    //     : '', // selectedUserEmail 값이 없으면 빈 문자열 반환 (위의 코드와 동작은 동일한데 null 케이스와 빈 문자열 케이스를 명시적으로 표현한 것)
                    value: validSelectedUserEmail,
                    // 선택된 이메일 값
                    onChanged: (value) {
                      ref.read(adminSelectedUserEmailProvider.notifier).state =
                          value; // 선택된 이메일 값을 변경하는 코드
                    },
                    items: uniqueUsersEmailList.map((email) {
                      return DropdownMenuItem<String>(
                        value: email, // 각 이메일을 드롭다운의 항목으로 설정하는 코드
                        child: Text(
                          email,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'NanumGothic',
                            fontSize: reviewWriterSelectDataTextSize,
                            color: BLACK_COLOR,
                          ),
                        ), // 드롭다운 항목에 표시할 텍스트 설정
                      );
                    }).toList(),
                  );
                },
                // 데이터가 로딩 중인 경우
                loading: () => buildCommonLoadingIndicator(),
                // 에러가 발생한 경우
                error: (e, stack) =>
                    const Center(child: Text('에러가 발생했으니, 앱을 재실행해주세요.')),
              ),
            ),
          ),
        ),
        SizedBox(height: interval1Y), // 드롭다운 버튼과 리뷰 목록 사이의 간격을 설정하는 코드
        if (reviews.isEmpty)
          // 리뷰 목록이 비어있을 경우 "현재 리뷰 목록 내 리뷰가 없습니다." 메시지 표시
          Container(
            width: reviewEmptyTextWidth,
            height: reviewEmptyTextHeight,
            margin: EdgeInsets.only(top: reviewEmptyTextY),
            // 텍스트를 중앙에 위치하도록 설정함.
            alignment: Alignment.center,
            child: Text(
              '현재 리뷰 목록 내 리뷰가 없습니다.',
              style: TextStyle(
                fontSize: reviewEmptyTextFontSize,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
                color: BLACK_COLOR,
              ),
            ),
          )
        else
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: reviews.asMap().entries.map((entry) {
                final index = entry.key; // 현재 리뷰 항목의 인덱스
                final review = entry.value; // 현재 리뷰 항목의 데이터
                final reviewImages = [
                  review['review_image1'],
                  review['review_image2'],
                  review['review_image3']
                ]
                    .where((image) => image != null) // 이미지가 null이 아닌 경우 필터링
                    .map((image) => image.toString() ?? '') // 이미지 URL을 문자열로 변환
                    .toList(); // 리뷰에 포함된 이미지들을 리스트로 저장하는 코드

                // private_review_closed_button 필드값에 따라 '[O]' 또는 '[X]' 표시
                String statusIcon = review['private_review_closed_button'] ==
                        true
                    ? '[삭제 O]'
                    : '[삭제 X]'; // private_review_closed_button 값에 따라 상태 아이콘 설정
                String deleteTime = '';

                // 'review_delete_time' 필드값이 존재 유무에 따라 해당 필드값을 노출
                if (review.containsKey('review_delete_time')) {
                  deleteTime = formatTimestamp(
                      review['review_delete_time']); // 리뷰 삭제 시간을 포맷팅하여 저장하는 코드
                }

                // // 클립 위젯을 사용하여 모서리를 둥글게 설정함
                // return ClipRRect(
                //   borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
                //   child: Container(
                return Container(
                  padding: EdgeInsets.zero, // 패딩을 없앰
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 지정함
                    ),
                  ),
                  child: CommonCardView(
                    // 공통 카드뷰 위젯 사용
                    backgroundColor:
                        Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                    elevation: 0, // 그림자 깊이 설정
                    content: Padding(
                      // 패딩 설정
                      padding: EdgeInsets.zero, // 패딩을 없앰
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // 내용물을 왼쪽 정렬
                        children: [
                          Row(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
                                children: [
                                  Text(
                                    statusIcon, // 리뷰 상태 아이콘 표시
                                    style: TextStyle(
                                      fontSize: reviewStatusIconTextSize,
                                      // 텍스트 크기 설정
                                      fontWeight: FontWeight.bold,
                                      // 텍스트 굵기 설정
                                      fontFamily: 'NanumGothic',
                                      color:
                                      review['private_review_closed_button'] ==
                                          true
                                          ? RED46_COLOR
                                          : BLACK_COLOR, // 상태에 따라 텍스트 색상 변경
                                    ),
                                  ),
                                  if (deleteTime.isNotEmpty) // deleteTime이 존재하는 경우
                                    Padding(
                                      padding: EdgeInsets.only(left: interval1X),
                                      // 상태 아이콘과 간격 추가
                                      child: Text(
                                        deleteTime, // 삭제 시간을 표시
                                        style: TextStyle(
                                          fontSize: reviewDeleteTimeDataTextSize,
                                          // 텍스트 크기 설정
                                          fontWeight: FontWeight.bold,
                                          // 텍스트 굵기 설정
                                          fontFamily: 'NanumGothic',
                                          color: BLACK_COLOR, // 텍스트 색상 설정
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              // 삭제 유무 및 삭제시간 데이터 부분과 삭제 버튼 사이의 공간을 차지하여 삭제 버튼이 오른쪽 끝에 위치하도록 함
                              Expanded(
                                child: Container(),
                              ),
                              Container(
                                width: deleteBtnWidth,
                                height: deleteBtnHeight,
                                margin: EdgeInsets.only(right: intervalX),
                                // 오른쪽 여백 설정
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: GRAY44_COLOR,
                                    // 텍스트 색상 설정
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    // 버튼 배경색을 앱 배경색으로 설정
                                    side: BorderSide(color: GRAY44_COLOR),
                                    // 버튼 테두리 색상 설정
                                    padding: EdgeInsets.symmetric(
                                        vertical: deleteBtnPaddingY,
                                        horizontal: deleteBtnPaddingX), // 버튼 패딩
                                  ),
                                  onPressed: () async {
                                    // 리뷰 삭제 버튼 클릭 시 확인 다이얼로그를 표시함
                                    await showSubmitAlertDialog(
                                      context,
                                      title: '[리뷰 삭제]',
                                      // 다이얼로그 제목 설정
                                      content:
                                          '삭제 시, 해당 리뷰는 영구적으로 삭제됩니다.\n해당 리뷰를 삭제하시겠습니까?',
                                      // 다이얼로그 내용 설정
                                      actions: buildAlertActions(
                                        context,
                                        noText: '아니요',
                                        // 아니요 버튼 텍스트 설정
                                        yesText: '예',
                                        // 예 버튼 텍스트 설정
                                        noTextStyle: TextStyle(
                                          color: BLACK_COLOR,
                                          // 아니요 버튼 텍스트 색상 설정
                                          fontWeight: FontWeight
                                              .bold, // 아니요 버튼 텍스트 굵기 설정
                                        ),
                                        yesTextStyle: TextStyle(
                                          color: RED46_COLOR, // 예 버튼 텍스트 색상 설정
                                          fontWeight:
                                              FontWeight.bold, // 예 버튼 텍스트 굵기 설정
                                        ),
                                        onYesPressed: () async {
                                          try {
                                            // 리뷰 삭제 처리
                                            await ref
                                                .read(
                                                    adminReviewItemsListNotifierProvider
                                                        .notifier)
                                                .deleteReview(
                                                    review['separator_key']);
                                            Navigator.of(context)
                                                .pop(); // 다이얼로그 닫기
                                            // 리뷰 삭제 완료 메시지 표시
                                            showCustomSnackBar(
                                                context, '리뷰가 삭제되었습니다.');
                                          } catch (e) {
                                            showCustomSnackBar(context,
                                                '리뷰 삭제 중 오류가 발생했습니다: $e');
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    '삭제', // 버튼 텍스트 설정
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'NanumGothic',
                                      fontSize: deleteBtnFontSize,
                                      color: BLACK_COLOR,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: interval2Y),

                          Text(
                            '상품 내용',
                            style: TextStyle(
                              fontSize: reviewTitleFontSize,
                              // 텍스트 크기 설정
                              fontWeight: FontWeight.bold,
                              // 텍스트 굵기 설정
                              fontFamily: 'NanumGothic',
                              // 글꼴 설정
                              color: BLACK_COLOR, // 텍스트 색상 설정
                            ),
                          ),

                          SizedBox(height: interval2Y),

                          _buildReviewInfoRow(
                              '발주번호: ',
                              review['order_number']?.toString().isNotEmpty ==
                                      true
                                  ? review['order_number']
                                  : '',
                              bold: true,
                              fontSize: reviewOrderNumberDataFontSize),
                          // 발주 번호가 존재할 경우, 이를 표시하는 행(Row)을 생성하여
                          // 화면에 출력함. '발주번호:'라는 라벨과 함께 bold로 표시함.

                          _buildReviewInfoRow(
                              '상품번호: ',
                              review['product_number']?.toString().isNotEmpty == true
                                  ? review['product_number']
                                  : '',
                              bold: true,
                              fontSize: reviewProdNumberDataFontSize),
                          // 상품 번호가 존재할 경우, 이를 표시하는 행(Row)을 생성하여
                          // 화면에 출력함. '상품번호:'라는 라벨과 함께 bold로 표시함.

                          SizedBox(height: interval2Y),

                          _buildReviewInfoRow(
                              review['brief_introduction']?.toString().isNotEmpty ==
                                  true
                                  ? review['brief_introduction']
                                  : '',
                              '',
                              bold: true,
                              fontSize: reviewBriefIntroductionDataFontSize),
                          // 리뷰에 간단한 소개가 있을 경우, 이를 표시하는 행(Row)을 생성하여
                          // 화면에 출력함. 텍스트는 굵게(bold) 표시함.

                          SizedBox(height: interval2Y),
                          // 간단한 소개와 다음 항목 사이의 간격 설정
                          GestureDetector(
                            onTap: () {
                              final product = ProductContent(
                                docId: review['product_id'] ?? '',
                                // 제품 ID 설정
                                category:
                                    review['category']?.toString() ?? '',
                                // 제품 카테고리 설정
                                productNumber:
                                    review['product_number']?.toString() ??
                                        '',
                                // 제품 번호 설정
                                thumbnail:
                                    review['thumbnails']?.toString() ?? '',
                                // 썸네일 이미지 설정
                                briefIntroduction:
                                    review['brief_introduction']?.toString() ??
                                        '',
                                // 간단한 소개 설정
                                originalPrice: review['original_price'] ?? 0,
                                // 원가 설정
                                discountPrice: review['discount_price'] ?? 0,
                                // 할인된 가격 설정
                                discountPercent:
                                    review['discount_percent'] ?? 0, // 할인율 설정
                              );
                              final navigatorProductDetailScreen =
                                  ProductInfoDetailScreenNavigation(
                                      ref); // 제품 상세 화면으로의 네비게이터 설정
                              navigatorProductDetailScreen
                                  .navigateToDetailScreen(
                                      context, product); // 제품 상세 화면으로 이동하는 코드
                              // 사용자가 리뷰 항목을 클릭했을 때 제품 상세 화면으로 이동함.
                              // 리뷰에 포함된 제품 정보를 기반으로 ProductContent 객체를 생성하여,
                              // 상세 화면으로 해당 데이터를 전달함.
                            },
                            child: CommonCardView(
                              backgroundColor: Theme.of(context)
                                  .scaffoldBackgroundColor, // 앱 기본 배경색
                              elevation: 0, // 그림자 깊이 설정
                              content: Padding(
                                padding: EdgeInsets.zero, // 패딩을 없앰
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start, // 내용물을 왼쪽 정렬
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: review['thumbnails']
                                                      ?.toString()
                                                      .isNotEmpty ==
                                                  true
                                              ? Image.network(
                                                  review['thumbnails'],
                                            fit: BoxFit.cover,
                                            // 이미지 로드 실패 시 아이콘 표시
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                Icon(
                                                  Icons.image_not_supported,
                                                  color: GRAY88_COLOR,
                                                  size: interval4X,
                                                ),
                                          )
                                              : Icon(
                                            Icons.image_not_supported,
                                            color: GRAY88_COLOR,
                                            size: interval4X,
                                          ),
                                        ),
                                        // 리뷰에 썸네일 이미지가 존재하면 이를 네트워크에서 불러와 표시함.
                                        // 썸네일 이미지가 없을 경우 대체 아이콘(이미지 미지원)을 표시함.
                                        SizedBox(width: interval3X),
                                        // 이미지와 텍스트 사이의 간격 설정
                                        Expanded(
                                          flex: 6,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${numberFormat.format(review['original_price']?.toString().isNotEmpty == true ? review['original_price'] as num : '')} 원',
                                                style: TextStyle(
                                                  fontSize:
                                                  reviewOriginalPriceFontSize,
                                                  fontFamily: 'NanumGothic',
                                                  color: GRAY60_COLOR,
                                                  // 텍스트 색상 설정
                                                  decoration: TextDecoration
                                                      .lineThrough, // 텍스트에 취소선 추가
                                                ),
                                              ),
                                              // 원래 가격이 존재할 경우 이를 취소선과 함께 표시함.
                                              // 가격은 세 자리마다 쉼표로 구분하여 표시하며,
                                              // 회색 텍스트로 렌더링함.

                                              Row(
                                                children: [
                                                  Text(
                                                    '${numberFormat.format(review['discount_price']?.toString().isNotEmpty == true ? review['discount_price'] as num : '')} 원',
                                                    style: TextStyle(
                                                        fontSize:
                                                        reviewDiscountPriceFontSize,
                                                        fontFamily: 'NanumGothic',
                                                        color: BLACK_COLOR,
                                                        // 텍스트 색상 설정
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(width: interval2X),
                                                  Text(
                                                    '${numberFormat.format(review['discount_percent']?.toString().isNotEmpty == true ? review['discount_percent'] as num : '')}%',
                                                    style: TextStyle(
                                                      fontSize:
                                                      reviewDiscountPercentFontSize,
                                                      fontFamily: 'NanumGothic',
                                                      color: RED46_COLOR,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // 할인 가격과 할인율이 존재할 경우 이를 표시함.
                                              // 할인 가격은 굵은 글씨로, 할인율은 빨간색 굵은 글씨로 표시함.
                                              Row(
                                                children: [
                                                  // 선택된 색상 이미지를 표시하고, 없을 경우 대체 아이콘 표시
                                                  review['selected_color_image']
                                                      ?.toString()
                                                      .isNotEmpty ==
                                                      true
                                                      ? Image.network(
                                                    review[
                                                    'selected_color_image'],
                                                    height:
                                                    reviewSelctedColorImageDataHeight,
                                                    width:
                                                    reviewSelctedColorImageDataWidth,
                                                    fit: BoxFit.cover,
                                                    // 이미지 로드 실패 시 아이콘 표시
                                                    errorBuilder: (context,
                                                        error,
                                                        stackTrace) =>
                                                        Icon(
                                                          Icons.image_not_supported,
                                                          color: GRAY88_COLOR,
                                                          size:
                                                          reviewSelctedColorImageDataHeight,
                                                        ),
                                                  )
                                                      : Icon(
                                                    Icons.image_not_supported,
                                                    color: GRAY88_COLOR,
                                                    size:
                                                    reviewSelctedColorImageDataHeight,
                                                  ),
                                                  SizedBox(width: interval1X),
                                                  // 선택된 색상 텍스트를 표시
                                                  Text(
                                                    review['selected_color_text']
                                                        ?.toString()
                                                        .isNotEmpty ==
                                                        true
                                                        ? review[
                                                    'selected_color_text']
                                                        : '',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize:
                                                      reviewSelectedColorTextFontSize,
                                                      fontFamily: 'NanumGothic',
                                                      fontWeight: FontWeight.bold,
                                                      color: BLACK_COLOR,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // 선택된 색상 텍스트와 색상 이미지를 표시함.
                                              // 색상 이미지는 네트워크에서 불러오며, 이미지가 없을 경우 대체 아이콘을 표시함.
                                              // 색상 텍스트는 줄임말로 표시하여 공간을 절약함.
                                              SizedBox(height: interval4Y),
                                              // 선택된 사이즈와 수량을 표시
                                              // 선택된 사이즈 정보를 표시함.
                                              Text(
                                                '${review['selected_size']?.toString().isNotEmpty == true ? review['selected_size'] : ''}',
                                                style: TextStyle(
                                                  fontSize:
                                                  reviewSelectedSizeTextFontSize,
                                                  fontFamily: 'NanumGothic',
                                                  fontWeight: FontWeight.bold,
                                                  color: BLACK_COLOR,
                                                ),
                                              ),
                                              SizedBox(height: interval4Y),
                                              // 선택된 수량 정보를 표시함.
                                              Text(
                                                '${review['selected_count']?.toString().isNotEmpty == true ? review['selected_count'] : ''}개',
                                                style: TextStyle(
                                                  fontSize:
                                                  reviewSelectedCountTextFontSize,
                                                  fontFamily: 'NanumGothic',
                                                  fontWeight: FontWeight.bold,
                                                  color: BLACK_COLOR,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: interval5Y),
                          Text(
                            '리뷰 내용',
                            style: TextStyle(
                              fontSize: reviewTitleFontSize,
                              // 텍스트 크기 설정
                              fontWeight: FontWeight.bold,
                              // 텍스트 굵기 설정
                              fontFamily: 'NanumGothic',
                              // 글꼴 설정
                              color: BLACK_COLOR, // 텍스트 색상 설정
                            ),
                          ),
                          SizedBox(height: interval2Y),
                          if (_expandedReviews[index] == true) ...[
                            _buildReviewInfoRow(
                              '작성일시: ',
                              review['review_write_time'] != null &&
                                  review['review_write_time'] is Timestamp
                                  ? dateFormat.format(
                                  (review['review_write_time'] as Timestamp)
                                      .toDate())
                                  : '',
                              bold: true,
                              fontSize:
                              reviewWriteDateTextFontSize, // 리뷰 내용 텍스트 글꼴 크기 설정함
                            ),
                            // 리뷰 작성일자가 존재할 경우 이를 표시함.
                            // 작성일자는 'yyyy.MM.dd' 형식으로 변환하여 표시되며, 굵은 텍스트로 렌더링됨.

                            SizedBox(height: interval2Y),

                            _buildReviewInfoRow(
                                '제목: ',
                                review['review_title']?.toString().isNotEmpty == true
                                    ? review['review_title']
                                    : '',
                                bold: true,
                                fontSize: reviewTitleTextFontSize),
                            // 리뷰 제목이 있을 경우 이를 표시함.
                            // '제목:' 라벨과 함께 굵은 텍스트로 제목을 표시함.

                            SizedBox(height: interval2Y),
                            _buildReviewInfoRow(
                                '내용: ',
                                review['review_contents']?.toString().isNotEmpty ==
                                    true
                                    ? review['review_contents']
                                    : '',
                                bold: true,
                                fontSize: reviewContentsTextFontSize),
                            // 리뷰 내용이 있을 경우 이를 표시함.
                            // '내용:' 라벨과 함께 굵은 텍스트로 내용을 표시함.

                            SizedBox(height: interval2Y),
                            if (reviewImages.isNotEmpty)
                              _buildReviewImagesRow(reviewImages, context),
                            // 리뷰에 첨부된 이미지가 있을 경우, 이미지를 표시하는 행(Row)을 추가함.
                            // 이미지가 존재하지 않을 경우 해당 부분은 렌더링되지 않음.

                            SizedBox(height: interval2Y),
                          ],
                          Container(
                            height: reviewExpandedBtnHeight,
                            // 버튼 높이 설정
                            width: double.infinity,
                            // 버튼 너비를 화면 전체 너비로 설정
                            margin: EdgeInsets.symmetric(vertical: interval3Y),
                            // 위아래 여백 설정
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _expandedReviews[index] =
                                  !(_expandedReviews[index] ??
                                      false); // 펼치기/닫기 상태 변경
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: GRAY44_COLOR, // 아이콘 및 텍스트 색상 설정
                                backgroundColor: Theme.of(context)
                                    .scaffoldBackgroundColor, // 앱 기본 배경색
                                side: BorderSide(color: GRAY44_COLOR), // 버튼 테두리 색상 설정
                                padding: EdgeInsets.zero, // 버튼 내부 여백 제거
                              ),
                              icon: Icon(
                                _expandedReviews[index] == true
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward, // 화살표 아이콘 설정
                                size: reviewExpandedBtnFontSize, // 아이콘 크기
                                color: BLACK_COLOR,
                              ),
                              label: Text(
                                _expandedReviews[index] == true ? '접기' : '펼쳐보기',
                                // 확장 여부에 따라 텍스트 변경
                                style: TextStyle(
                                  fontFamily: 'NanumGothic',
                                  fontSize: reviewExpandedBtnFontSize, // 텍스트 크기 설정
                                  fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                  color: BLACK_COLOR, // 텍스트 색상 설정
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // 리뷰 정보 항목을 표시하는 위젯
  Widget _buildReviewInfoRow(String label, String value,
      {bool bold = false, double fontSize = 16}) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 컨텐츠 사이의 간격 수치
    final double interval1X = screenSize.width * (4 / referenceWidth);
    final double interval1Y = screenSize.height * (4 / referenceHeight);

    if (label.length + value.length <= 30) {
      return Padding(
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'NanumGothic',
                color: BLACK_COLOR,
              ),
            ),
            // 정보의 라벨을 텍스트로 표시함. 글꼴 크기와 굵기는 파라미터에 따라 설정됨.
            SizedBox(width: interval1X), // 라벨과 값 사이의 간격 설정
            Expanded(
              child: Text(
                value ?? '',
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: 'NanumGothic',
                  color: BLACK_COLOR,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.start,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // 정보의 값을 텍스트로 표시함. 값이 길 경우 줄임말로 표시되고,
            // 텍스트가 여러 줄에 걸쳐 표시될 수 있도록 설정됨.
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: BLACK_COLOR,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'NanumGothic',
              ),
            ),
            // 정보의 라벨을 텍스트로 표시함. 글꼴 크기와 굵기는 파라미터에 따라 설정됨.

            SizedBox(height: interval1Y),
            Text(
              value ?? '',
              style: TextStyle(
                fontSize: fontSize,
                color: BLACK_COLOR,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'NanumGothic',
              ),
              textAlign: TextAlign.start,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            // 정보의 값을 텍스트로 표시함. 텍스트가 여러 줄에 걸쳐 표시될 수 있도록 설정되며,
            // 줄임말이 아닌 전체 텍스트가 표시됨.
          ],
        ),
      );
    }
    // 정보의 길이에 따라 Row 또는 Column으로 구성된 정보를 표시함.
    // 정보의 라벨과 값이 짧을 경우 Row로 표시되며, 길 경우 Column으로 표시됨.
  }

  // 리뷰 이미지 목록을 표시하는 위젯
  Widget _buildReviewImagesRow(List<String> images, BuildContext context) {
    final width = MediaQuery.of(context).size.width; // 화면 너비 가져오기
    final imageWidth = width / 4; // 이미지 너비 설정

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 컨텐츠 사이의 간격 수치
    final double interval1X = screenSize.width * (8 / referenceWidth);

    return Row(
      children: images.map((image) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailOriginalImageScreen(
                  images: images, // 이미지 목록 전달
                  initialPage: images.indexOf(image), // 클릭한 이미지의 인덱스 설정
                ),
              ),
            );
            // 사용자가 이미지를 클릭하면,
            // 해당 이미지를 포함한 원본 이미지 상세 화면으로 이동함.
          },
          child: Container(
            width: imageWidth,
            height: imageWidth,
            margin: EdgeInsets.only(right: interval1X),
            child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  // 이미지 로드 실패 시 아이콘 표시
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    color: GRAY88_COLOR,
                    size: imageWidth,
                  ),
                )),
            // 네트워크에서 이미지를 불러와 표시함.
            // 이미지는 컨테이너에 맞춰서 표시되며,
            // 이미지를 완전히 채우도록 설정됨.
          ),
        );
      }).toList(),
    );
    // 리뷰 이미지들을 가로로 나열하여 표시함.
    // 각 이미지는 동일한 크기로 설정되며,
    // 이미지를 클릭할 경우 원본 이미지를 볼 수 있도록 설정됨.
  }
}
// ------- 관리자용 리뷰 관리 화면 UI를 구현하는 AdminReviewListScreen 클래스 내용 끝 부분
