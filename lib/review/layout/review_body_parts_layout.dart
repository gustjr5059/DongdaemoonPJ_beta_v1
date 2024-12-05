import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../common/layout/common_exception_parts_of_body_layout.dart';
import '../../message/provider/message_all_provider.dart';
import '../../order/provider/order_all_providers.dart';
import '../../product/layout/product_body_parts_layout.dart';
import '../../product/model/product_model.dart';
import '../../product/view/detail_screen/product_detail_original_image_screen.dart';
import '../provider/review_all_provider.dart';
import '../provider/review_state_provider.dart';
import '../view/review_create_detail_screen.dart';
import 'package:image_picker/image_picker.dart'; // image_picker 패키지를 가져옴.
import 'dart:io';
import '../view/review_screen.dart'; // 파일 처리를 위해 dart:io 패키지를 가져옴.

// ------- 리뷰 작성 상세 화면 관련 UI 내용인 PrivateReviewCreateDetailFormScreen 클래스 시작
class PrivateReviewCreateDetailFormScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> productInfo; // 특정 상품 정보를 담는 변수
  final Map<String, dynamic> numberInfo; // 발주 정보를 담는 변수
  final String userEmail; // 사용자의 이메일을 저장하기 위한 변수
  final TextEditingController titleController =
      TextEditingController(); // 리뷰 제목을 입력받기 위한 컨트롤러
  final TextEditingController contentController =
      TextEditingController(); // 리뷰 내용을 입력받기 위한 컨트롤러

  // 생성자에서 productInfo, numberInfo, userEmail을 필수로 받아옴
  PrivateReviewCreateDetailFormScreen({
    required this.productInfo,
    required this.numberInfo,
    required this.userEmail,
  });

  // 상태를 생성하는 메서드
  @override
  _PrivateReviewCreateDetailFormScreenState createState() =>
      _PrivateReviewCreateDetailFormScreenState();
}

// ------ PrivateReviewCreateDetailFormScreen의 상태를 정의하는 클래스
class _PrivateReviewCreateDetailFormScreenState
    extends ConsumerState<PrivateReviewCreateDetailFormScreen> {
  final List<File> _images = []; // 최대 3개의 이미지를 저장하기 위한 리스트
  final ImagePicker _picker =
      ImagePicker(); // 갤러리에서 이미지를 선택하기 위한 ImagePicker 객체

  // ----- 리뷰 사진 업로드 관련 함수 시작 부분
  // 권한 요청 함수
  // _requestPermission: 갤러리 접근을 위한 권한을 요청하는 함수
  Future<bool> _requestPermission(BuildContext context) async {
    // 안드로이드 및 IOS 권한 요청
    if (Platform.isAndroid || Platform.isIOS) {
      // Permission.photos.status: 사진 접근 권한의 현재 상태를 가져옴
      PermissionStatus status = await Permission.photos.status;
      if (status.isGranted) {
        // 권한이 이미 허용된 경우
        return true; // true 반환
      } else if (status.isDenied || status.isPermanentlyDenied) {
        // 권한이 거부되었거나 영구적으로 거부된 경우
        await showSubmitAlertDialog(
          context,
          title: '[갤러리 접근 권한]', // 팝업 제목 설정
          content: '갤러리 접근 권한이 필요합니다.\n설정에서 권한을 허용해주세요.', // 팝업 내용 설정
          actions: buildAlertActions(
            context,
            noText: '취소',
            // '취소' 버튼 텍스트 설정
            yesText: '승인',
            // '승인' 버튼 텍스트 설정
            noTextStyle: TextStyle(
              // '취소' 버튼 스타일을 검은색 Bold로 설정함
              color: BLACK_COLOR,
              fontWeight: FontWeight.bold,
            ),
            yesTextStyle: TextStyle(
              // '승인' 버튼 스타일을 빨간색 Bold로 설정함
              color: RED46_COLOR,
              fontWeight: FontWeight.bold,
            ),
            onYesPressed: () {
              // '승인' 버튼이 클릭되었을 때 실행되는 동작
              openAppSettings(); // 설정 화면으로 이동함
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
          ),
        );
        return false; // 권한 요청 실패 시 false 반환
      }
    }
    return false; // 권한 요청이 실패하거나 지원되지 않는 플랫폼인 경우 false 반환
  }

  // 이미지 선택 함수
  Future<void> _pickImage(BuildContext context) async {
    if (_images.length >= 3) {
      // 이미지가 3개 이상이면 업로드 제한 메시지를 표시
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('사진은 최대 3개까지 업로드할 수 있습니다.')),
      // );
      showCustomSnackBar(context, '사진은 최대 3개까지 업로드할 수 있습니다.');
      return;
    }

    // await _requestPermission(context); // 권한 요청 수행 (주석 처리됨)

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // 이미지가 선택된 경우 리스트에 추가하고 성공 메시지를 표시
      setState(() {
        _images.add(File(image.path));
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('사진이 성공적으로 업로드되었습니다.')),
      // );
      showCustomSnackBar(context, '사진이 성공적으로 업로드되었습니다.');
    }
  }

  // 사진 삭제 함수
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index); // 선택된 이미지를 리스트에서 삭제함
    });
  }

  // ----- 리뷰 사진 업로드 관련 함수 끝 부분

  @override
  Widget build(BuildContext context) {
    // 화면의 UI를 그리기 위한 build 메소드

    // 날짜 형식을 'yyyy년 MM월 dd일 HH시 MM분'로 지정함
    final dateFormat = DateFormat('yyyy년 MM월 dd일 HH시 MM분');

    // 숫자 형식을 '###,###'로 지정함
    final numberFormat = NumberFormat('###,###');

    // 결제 완료 날짜를 비동기로 가져오기 위해 AsyncValue로 저장
    final paymentCompleteDateAsyncValue = ref
        .watch(paymentCompleteDateProvider(widget.numberInfo['order_number']));

    // 배송 시작 날짜를 비동기로 가져오기 위해 AsyncValue로 저장
    final deliveryStartDateAsyncValue =
        ref.watch(deliveryStartDateProvider(widget.numberInfo['order_number']));

    // 발주 날짜를 가져와 DateTime으로 변환하거나 null을 할당
    final orderDate = widget.numberInfo['order_date'] != null
        ? (widget.numberInfo['order_date'] as Timestamp).toDate()
        : null;

    // 상품 상세 화면으로 이동하는 기능을 위한 navigator 인스턴스
    final navigatorProductDetailScreen = ProductInfoDetailScreenNavigation(ref);

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 리뷰 관리 화면 내 리뷰 작성 탭에서 카드뷰 섹션의 가로와 세로 비율 계산
    final double reviewDtInfo1CardViewWidth =
        screenSize.width * (393 / referenceWidth); // 가로 비율 계산
    final double reviewDtInfo1CardViewHeight =
        screenSize.height * (380 / referenceHeight); // 세로 비율 계산
    final double reviewDtInfo2CardViewWidth =
        screenSize.width * (393 / referenceWidth); // 가로 비율 계산
    final double reviewDtInfo2CardViewHeight =
        screenSize.height * (130 / referenceHeight); // 세로 비율 계산

    // body 부분 전체 패딩 수치 계산
    final double reviewDtInfoCardViewPaddingX =
        screenSize.width * (5 / referenceWidth); // 좌우 패딩 계산
    final double reviewDtInfoCardViewPadding1Y =
        screenSize.height * (5 / referenceHeight); // 상하 패딩 계산

    // 텍스트 크기 계산
    final double reviewDtInfoTitleFontSize =
        screenSize.height * (18 / referenceHeight); // 텍스트 크기 비율 계산
    final double reviewDtInfoOrderDateDataFontSize =
        screenSize.height * (18 / referenceHeight); // 텍스트 크기 비율 계산
    final double reviewDtInfoOrderNumberDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double reviewDtInfoBriefIntroDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double reviewDtInfoProdNumberDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double reviewDtInfoOriginalPriceDataFontSize =
        screenSize.height * (12 / referenceHeight); // 텍스트 크기 비율 계산
    final double reviewDtInfoDiscountPriceDataFontSize =
        screenSize.height * (13 / referenceHeight); // 텍스트 크기 비율 계산
    final double reviewDtInfoDiscountPercentDataFontSize =
        screenSize.height * (13 / referenceHeight); // 텍스트 크기 비율 계산
    final double reviewDtInfoColorImageDataWidth =
        screenSize.width * (13 / referenceWidth); // 색상 이미지 가로 크기 설정함
    final double reviewDtInfoColorImageDataHeight =
        screenSize.width * (13 / referenceWidth); // 색상 이미지 세로 크기 설정함
    final double reviewDtInfoColorTextDataFontSize =
        screenSize.height * (13 / referenceHeight); // 텍스트 크기 비율 계산
    final double reviewDtInfoSizeTextDataFontSize =
        screenSize.height * (13 / referenceHeight); // 텍스트 크기 비율 계산
    final double reviewDtInfoCountTextDataFontSize =
        screenSize.height * (13 / referenceHeight); // 텍스트 크기 비율 계산
    final double reviewDtInfoDateTextDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double reviewDtInfoGuideTextFontSize =
        screenSize.height * (12 / referenceHeight); // 텍스트 크기 비율 계산

    // 리뷰 작성 버튼 수치
    final double reviewWriteBtnHeight =
        screenSize.height * (40 / referenceHeight);
    final double reviewWriteBtnWidth =
        screenSize.width * (100 / referenceWidth);
    final double reviewWriteBtnPaddingY =
        screenSize.height * (2 / referenceHeight);
    final double reviewWriteBtnPaddingX =
        screenSize.width * (4 / referenceWidth);
    final double reviewWriteBtnFontSize =
        screenSize.height * (14 / referenceHeight);

    // 발주내역 카드뷰 섹션 내 컨텐츠 사이의 간격 계산
    final double interval1Y =
        screenSize.height * (2 / referenceHeight); // 세로 간격 1 계산
    final double interval2Y =
        screenSize.height * (8 / referenceHeight); // 세로 간격 2 계산
    final double interval3Y =
        screenSize.height * (20 / referenceHeight); // 세로 간격 3 계산
    final double interval4Y =
        screenSize.height * (10 / referenceHeight); // 세로 간격 4 계산
    final double interval1X =
        screenSize.width * (20 / referenceWidth); // 가로 간격 1 계산
    final double interval2X =
        screenSize.width * (19 / referenceWidth); // 가로 간격 2 계산
    final double interval3X =
        screenSize.width * (8 / referenceWidth); // 가로 간격 3 계산
    final double interval4X =
        screenSize.width * (10 / referenceWidth); // 가로 간격 4 계산
    final double interval5X =
        screenSize.width * (50 / referenceWidth); // 가로 간격 4 계산

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: interval4Y),
        Container(
          padding: EdgeInsets.only(left: interval4X),
          child: Text(
            '리뷰 상품 내용',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'NanumGothic',
              fontSize: reviewDtInfoTitleFontSize,
              color: BLACK_COLOR,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 지정함
            ),
          ),
          child: CommonCardView(
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
            elevation: 0, // 그림자 깊이 설정
            content: Padding(
              padding: EdgeInsets.zero, // 패딩을 없앰
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 발주번호를 표시하는 행을 빌드함
                  _buildProductInfoRow(
                      context,
                      '발주번호: ',
                      widget.numberInfo['order_number']
                                  ?.toString()
                                  .isNotEmpty ==
                              true
                          ? widget.numberInfo['order_number']
                          : '',
                      bold: true,
                      fontSize: reviewDtInfoOrderNumberDataFontSize),
                  // 상품번호를 표시하는 행을 빌드함
                  _buildProductInfoRow(
                      context,
                      '상품번호: ',
                      widget.productInfo['product_number']
                                  ?.toString()
                                  .isNotEmpty ==
                              true
                          ? widget.productInfo['product_number']
                          : '',
                      bold: true,
                      fontSize: reviewDtInfoProdNumberDataFontSize),
                  SizedBox(height: interval2Y), // 요소 간의 간격을 추가
                  // 상품 간단 소개를 표시하는 행을 빌드함
                  _buildProductInfoRow(
                      context,
                      widget.productInfo['brief_introduction']
                                  ?.toString()
                                  .isNotEmpty ==
                              true
                          ? widget.productInfo['brief_introduction']
                          : '',
                      '',
                      bold: true,
                      fontSize: reviewDtInfoBriefIntroDataFontSize),
                  SizedBox(height: interval1Y), // 요소 간의 간격을 추가
                  // 상품 이미지를 클릭했을 때 상품 상세 화면으로 이동하는 기능을 추가함
                  GestureDetector(
                    onTap: () {
                      final product = ProductContent(
                        docId: widget.productInfo['product_id'] ?? '',
                        category:
                            widget.productInfo['category']?.toString() ?? '',
                        productNumber:
                            widget.productInfo['product_number']?.toString() ??
                                '',
                        thumbnail:
                            widget.productInfo['thumbnails']?.toString() ?? '',
                        briefIntroduction: widget
                                .productInfo['brief_introduction']
                                ?.toString() ??
                            '',
                        originalPrice:
                            widget.productInfo['original_price'] ?? 0,
                        discountPrice:
                            widget.productInfo['discount_price'] ?? 0,
                        discountPercent:
                            widget.productInfo['discount_percent'] ?? 0,
                      );
                      // 상품 상세 화면으로 이동
                      navigatorProductDetailScreen.navigateToDetailScreen(
                          context, product);
                    },
                    // 상품 정보를 표시하는 카드뷰 생성
                    child: CommonCardView(
                      backgroundColor: Theme.of(context)
                          .scaffoldBackgroundColor, // 앱 기본 배경색,
                      elevation: 0, // 그림자 깊이 설정
                      // padding: EdgeInsets.zero, // 패딩을 없앰
                      content: Padding(
                        padding: EdgeInsets.zero, // 패딩을 없앰
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  // 상품 썸네일 이미지를 표시하고, 이미지가 없을 경우 대체 아이콘을 표시함
                                  child: widget.productInfo['thumbnails']
                                              ?.toString()
                                              .isNotEmpty ==
                                          true
                                      ? Image.network(
                                          widget.productInfo['thumbnails'],
                                          fit: BoxFit.cover,
                                          // 이미지 로드 실패 시 아이콘 표시
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(
                                            Icons.image_not_supported,
                                            color: GRAY88_COLOR,
                                            size: interval5X,
                                          ),
                                        )
                                      : Icon(
                                          Icons.image_not_supported,
                                          color: GRAY88_COLOR,
                                          size: interval5X,
                                        ),
                                ),
                                SizedBox(width: interval1X), // 요소 간의 간격을 추가
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 원래 가격을 표시하는 텍스트
                                      Text(
                                        '${numberFormat.format(widget.productInfo['original_price']?.toString().isNotEmpty == true ? widget.productInfo['original_price'] : '')} 원',
                                        style: TextStyle(
                                          color: GRAY60_COLOR,
                                          // 텍스트 색상 설정
                                          fontSize:
                                              reviewDtInfoOriginalPriceDataFontSize,
                                          fontFamily: 'NanumGothic',
                                          decoration: TextDecoration
                                              .lineThrough, // 취소선 추가
                                        ),
                                      ),
                                      // 할인된 가격과 할인율을 표시하는 행을 빌드함
                                      Row(
                                        children: [
                                          Text(
                                            '${numberFormat.format(widget.productInfo['discount_price']?.toString().isNotEmpty == true ? widget.productInfo['discount_price'] : '')} 원',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: BLACK_COLOR,
                                              // 텍스트 색상 설정
                                              fontSize:
                                                  reviewDtInfoDiscountPriceDataFontSize,
                                              fontFamily: 'NanumGothic',
                                            ),
                                          ),
                                          SizedBox(width: interval2X),
                                          // 요소 간의 간격을 추가
                                          Text(
                                            '${numberFormat.format(widget.productInfo['discount_percent']?.toString().isNotEmpty == true ? widget.productInfo['discount_percent'] : '')}%',
                                            style: TextStyle(
                                              color: RED46_COLOR,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  reviewDtInfoDiscountPercentDataFontSize,
                                              fontFamily: 'NanumGothic',
                                            ),
                                          ),
                                        ],
                                      ),
                                      // 선택한 색상 이미지를 표시하고, 이미지가 없을 경우 대체 아이콘을 표시함
                                      Row(
                                        children: [
                                          widget.productInfo[
                                                          'selected_color_image']
                                                      ?.toString()
                                                      .isNotEmpty ==
                                                  true
                                              ? Image.network(
                                                  widget.productInfo[
                                                      'selected_color_image'],
                                                  height:
                                                      reviewDtInfoColorImageDataWidth,
                                                  width:
                                                      reviewDtInfoColorImageDataHeight,
                                                  fit: BoxFit.cover,
                                                  // 이미지 로드 실패 시 아이콘 표시
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Icon(
                                                    Icons.image_not_supported,
                                                    color: GRAY88_COLOR,
                                                    size:
                                                        reviewDtInfoColorImageDataHeight,
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.image_not_supported,
                                                  color: GRAY88_COLOR,
                                                  size:
                                                      reviewDtInfoColorImageDataHeight,
                                                ),
                                          SizedBox(width: interval3X),
                                          // 요소 간의 간격을 추가
                                          // 선택한 색상 텍스트를 표시함
                                          Text(
                                            widget.productInfo[
                                                            'selected_color_text']
                                                        ?.toString()
                                                        .isNotEmpty ==
                                                    true
                                                ? widget.productInfo[
                                                    'selected_color_text']
                                                : '',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize:
                                                  reviewDtInfoColorTextDataFontSize,
                                              fontFamily: 'NanumGothic',
                                              fontWeight: FontWeight.bold,
                                              color: BLACK_COLOR,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // 선택한 사이즈와 수량을 표시하는 텍스트
                                      Text(
                                        '${widget.productInfo['selected_size']?.toString().isNotEmpty == true ? widget.productInfo['selected_size'] : ''}',
                                        style: TextStyle(
                                          fontSize:
                                              reviewDtInfoSizeTextDataFontSize,
                                          fontFamily: 'NanumGothic',
                                          fontWeight: FontWeight.bold,
                                          color: BLACK_COLOR,
                                        ),
                                      ),
                                      Text(
                                        '${widget.productInfo['selected_count']?.toString().isNotEmpty == true ? widget.productInfo['selected_count'] : ''}개',
                                        style: TextStyle(
                                          fontSize:
                                              reviewDtInfoCountTextDataFontSize,
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
                  SizedBox(height: interval4Y), // 요소 간의 간격을 추가
                  // 발주 일자를 표시하는 행을 빌드함
                  _buildProductInfoRow(context, '발주일시: ',
                      orderDate != null ? dateFormat.format(orderDate) : '',
                      bold: true, fontSize: reviewDtInfoDateTextDataFontSize),
                  // 결제 완료 일자를 표시하거나 로딩 중 표시 또는 오류 메시지를 표시함
                  paymentCompleteDateAsyncValue.when(
                    data: (date) {
                      if (date != null) {
                        return Text(
                          '결제완료일시: ${date != null ? dateFormat.format(date) : ''}',
                          style: TextStyle(
                            fontSize: reviewDtInfoDateTextDataFontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NanumGothic',
                            color: BLACK_COLOR,
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                    // 데이터가 로딩 중인 경우
                    loading: () => buildCommonLoadingIndicator(),
                    // 에러가 발생한 경우
                    error: (e, stack) =>
                        const Center(child: Text('에러가 발생했으니, 앱을 재실행해주세요.')),
                  ),
                  // 배송 시작 일자를 표시하거나 로딩 중 표시 또는 오류 메시지를 표시함
                  deliveryStartDateAsyncValue.when(
                    data: (date) {
                      if (date != null) {
                        return Text(
                          '배송시작일시: ${date != null ? dateFormat.format(date) : ''}',
                          style: TextStyle(
                            fontSize: reviewDtInfoDateTextDataFontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NanumGothic',
                            color: BLACK_COLOR,
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                    // 데이터가 로딩 중인 경우
                    loading: () => buildCommonLoadingIndicator(),
                    // 에러가 발생한 경우
                    error: (e, stack) =>
                        const Center(child: Text('에러가 발생했으니, 앱을 재실행해주세요.')),
                  ),
                  // 추가적인 상품 정보 표시 또는 기타 UI 요소
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: interval3Y), // 요소 간의 간격을 추가
        Container(
          padding: EdgeInsets.only(left: interval4X),
          child: Text(
            '리뷰 작성 내용',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'NanumGothic',
              fontSize: reviewDtInfoTitleFontSize,
              color: BLACK_COLOR,
            ),
          ),
        ),
        SizedBox(height: interval4Y), // 요소 간의 간격을 추가
        // 리뷰 제목을 입력할 수 있는 입력 필드를 빌드하는 함수 호출
        _buildTitleRow(
            context, '리뷰 제목', widget.titleController, '50자 이내로 작성 가능합니다.'),
        SizedBox(height: interval2Y), // 요소 간의 간격을 추가
        // 작성자 정보를 표시하는 행을 빌드하는 함수 호출
        _buildUserRow(ref, '작성자', widget.userEmail),
        SizedBox(height: interval2Y), // 요소 간의 간격을 추가
        // 사진 업로드 버튼을 빌드하는 함수 호출
        _buildPhotoUploadRow('리뷰 사진', context),
        SizedBox(height: interval2Y), // 요소 간의 간격을 추가
        // 리뷰 내용을 입력할 수 있는 입력 필드를 빌드하는 함수 호출
        _buildContentsRow(
            context, '리뷰 내용', widget.contentController, '300자 이내로 작성 가능합니다.'),
        SizedBox(height: interval2Y), // 요소 간의 간격을 추가
        Container(
          // 패딩을 추가하여 요소 주위에 여백을 줌
          padding: EdgeInsets.symmetric(
              horizontal: interval4X, vertical: interval1Y),
          child: Center(
            child: Text(
              '리뷰 등록 시, 해당 발주 상품 관련 리뷰는 재작성이 불가능합니다.',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'NanumGothic',
                fontSize: reviewDtInfoGuideTextFontSize,
                color: GRAY35_COLOR,
              ),
            ),
          ),
        ),
        SizedBox(height: interval4Y), // 제출 버튼과의 간격을 위해 여백 추가
        // 제출 버튼을 빌드하는 함수 호출
        _buildSubmitButton(context),
        SizedBox(height: interval3Y), // 요소 간의 간격을 추가
      ],
    );
  }

  // 상품 정보를 표시하는 행을 구성하는 함수
  Widget _buildProductInfoRow(BuildContext context, String label, String value,
      {bool bold = false, double fontSize = 16}) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 컨텐츠 사이의 간격 수치
    final double interval1X = screenSize.width * (4 / referenceWidth);
    final double interval1Y = screenSize.height * (2 / referenceHeight);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 라벨을 표시하는 텍스트
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'NanumGothic',
          ),
        ),
        // 라벨과 값 사이의 공간을 제거
        SizedBox(width: interval1X), // 필요에 따라 사이즈 조정 가능
        // 값을 표시하는 텍스트 (말줄임 표시와 줄바꿈 가능)
        Expanded(
          child: Text(
            value ?? '',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'NanumGothic',
              color: BLACK_COLOR,
            ),
            textAlign: TextAlign.start, // 텍스트를 시작 부분에 맞춤
            softWrap: true, // 텍스트가 한 줄을 넘길 때 자동으로 줄바꿈이 되도록 설정
            overflow: TextOverflow.ellipsis, // 텍스트가 길 경우 말줄임 표시
          ),
        ),
      ],
      // ),
    );
  }

  // 제목 행을 생성하는 함수
  Widget _buildTitleRow(
    BuildContext context,
    String label,
    TextEditingController controller,
    String hintText,
  ) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 컨텐츠 사이의 간격 수치
    final double interval1X = screenSize.width * (4 / referenceWidth);
    final double interval1Y = screenSize.height * (2 / referenceHeight);
    final double interval2Y = screenSize.height * (4 / referenceHeight);
    final double interval2X = screenSize.width * (8 / referenceWidth);
    final double interval3X = screenSize.width * (10 / referenceWidth);
    final double reviewInfoRowTextFontSize =
        screenSize.height * (14 / referenceHeight);
    final double reviewInfoRowWidth = screenSize.width * (70 / referenceWidth);
    final double reviewInfoRowHeight =
        screenSize.width * (90 / referenceHeight);

    return Padding(
      // 패딩을 추가하여 요소 주위에 여백을 줌
      padding: EdgeInsets.symmetric(horizontal: interval3X, vertical: interval1Y),
      // 행의 상하단에 2.0 픽셀의 여백 추가
      child: Column(
        // 요소들을 세로로 배치하기 위해 Column 사용
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 요소들을 왼쪽 정렬
        children: [
          IntrinsicHeight(
            // 왼쪽 Container와 오른쪽 TextField의 높이를 동일하게 맞추기 위해 사용
            child: Row(
              // 요소들을 가로로 배치하기 위해 Row 사용
              crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
              children: [
                Container(
                  // 제목 라벨을 위한 컨테이너 생성
                  width: reviewInfoRowWidth,
                  height: reviewInfoRowHeight,
                  // 왼쪽 라벨 부분의 너비 설정
                  decoration: BoxDecoration(
                    // color: GRAY96_COLOR,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    // 앱 기본 배경색
                    border: Border.all(color: GRAY83_COLOR, width: 1),
                    // 윤곽선
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  // 텍스트를 왼쪽 정렬
                  child: Text(
                    label, // 셀에 표시될 텍스트
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NanumGothic',
                      fontSize: reviewInfoRowTextFontSize,
                      color: BLACK_COLOR,
                    ), // 텍스트를 굵게 설정
                  ),
                ),
                SizedBox(width: interval1X), // 라벨과 텍스트 필드 사이의 간격
                Expanded(
                  // 오른쪽 TextField가 남은 공간을 채우도록 설정
                  child: TextField(
                    // 사용자로부터 텍스트를 입력받기 위한 필드
                    controller: controller, // 텍스트 필드 컨트롤러 설정
                    maxLength: 50, // 최대 글자 수 설정
                    maxLines: null, // 텍스트가 길어질 때 자동으로 줄바꿈 되도록 설정
                    decoration: InputDecoration(
                      // 텍스트 필드의 외관을 설정
                      hintText: hintText, // 힌트 텍스트 설정
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: GRAY83_COLOR, width: 1.0),
                        borderRadius: BorderRadius.circular(6), // 모서리 각도를 제목 라벨과 동일하게 설정
                      ), // 입력 경계선 설정
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: GRAY83_COLOR, width: 1.0), // 비활성 상태의 테두리 설정
                        borderRadius: BorderRadius.circular(6), // 모서리 각도를 제목 라벨과 동일하게 설정
                      ),
                      focusedBorder: OutlineInputBorder(
                        // 활성화 상태의 테두리 설정
                        borderSide: BorderSide(
                          color: ORANGE56_COLOR,
                          width: 1.0,
                        ), // 활성화 상태의 테두리 색상을 BUTTON_COLOR로 설정
                        borderRadius: BorderRadius.circular(6), // 모서리 각도를 제목 라벨과 동일하게 설정
                      ),
                      counterText: '', // 글자수 표시를 비워둠 (아래에 별도로 표시)
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: interval2Y), // TextField와 글자 수 표시 사이의 여백
          Align(
            // 글자 수 표시를 오른쪽에 맞춤
            alignment: Alignment.centerRight, // 오른쪽에 글자 수 표시
            child: ValueListenableBuilder<TextEditingValue>(
              // 텍스트 입력 시마다 변경사항을 반영
              valueListenable: controller, // 텍스트 필드의 변경사항을 모니터링
              builder: (context, value, child) {
                return Text(
                  // 입력된 글자 수를 표시
                  '${value.text.length}/50', // 글자 수를 반영
                  style: TextStyle(
                    color: GRAY62_COLOR,
                    fontFamily: 'NanumGothic',
                    fontSize: reviewInfoRowTextFontSize,
                  ), // 글자 수 표시 스타일
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 사용자 정보를 표시하는 행을 생성하는 함수
  Widget _buildUserRow(WidgetRef ref, String label, String email) {
    final userNameAsyncValue =
        ref.watch(userNameProvider(email)); // 사용자 이름을 비동기적으로 가져오기 위해 프로바이더를 사용

    return userNameAsyncValue.when(
      // 비동기 상태에 따라 위젯을 생성
      data: (userName) {
        // 데이터가 성공적으로 로드된 경우
        String obscuredName = userName[0] +
            '*' * (userName.length - 1); // 사용자 이름을 첫 글자만 남기고 나머지는 *로 표시
        return _buildFixedValueRow(label, obscuredName); // 이름을 표시하는 행을 생성
      },
      // 데이터가 로딩 중인 경우
      loading: () => buildCommonLoadingIndicator(),
      // 에러가 발생한 경우
      error: (e, stack) => const Center(child: Text('에러가 발생했으니, 앱을 재실행해주세요.')),
    );
  }

  // 고정된 값을 표시하는 행을 생성하는 함수
  Widget _buildFixedValueRow(String label, String value) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 컨텐츠 사이의 간격 수치
    final double interval1X = screenSize.width * (4 / referenceWidth);
    final double interval1Y = screenSize.height * (2 / referenceHeight);
    final double interval2Y = screenSize.height * (4 / referenceHeight);
    final double interval2X = screenSize.width * (8 / referenceWidth);
    final double interval3X = screenSize.width * (10 / referenceWidth);
    final double reviewInfoRowTextFontSize =
        screenSize.height * (14 / referenceHeight);
    final double reviewInfoRowWidth = screenSize.width * (70 / referenceWidth);
    final double reviewInfoRowHeight =
        screenSize.width * (90 / referenceHeight);

    return Padding(
      // 패딩을 추가하여 요소 주위에 여백을 줌
      padding:
          EdgeInsets.symmetric(horizontal: interval3X, vertical: interval1Y),
      // 행의 상하단에 2.0 픽셀의 여백 추가
      child: Column(
        // 요소들을 세로로 배치하기 위해 Column 사용
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 요소들을 왼쪽 정렬
        children: [
          IntrinsicHeight(
            // 왼쪽 Container와 오른쪽 TextField의 높이를 동일하게 맞추기 위해 사용
            child: Row(
              // 요소들을 가로로 배치하기 위해 Row 사용
              crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
              children: [
                Container(
                  // 제목 라벨을 위한 컨테이너 생성
                  width: reviewInfoRowWidth,
                  height: reviewInfoRowHeight,
                  // 왼쪽 라벨 부분의 너비 설정
                  decoration: BoxDecoration(
                    // color: GRAY96_COLOR,
                    color:
                        Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                    border: Border.all(color: GRAY83_COLOR, width: 1), // 윤곽선
                    borderRadius: BorderRadius.circular(6),
                  ),
                  // 셀 내부 여백 설정
                  alignment: Alignment.center,
                  // 텍스트를 왼쪽 정렬
                  child: Text(
                    label, // 셀에 표시될 텍스트
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NanumGothic',
                      fontSize: reviewInfoRowTextFontSize,
                      color: BLACK_COLOR,
                    ), // 텍스트를 굵게 설정
                  ),
                ),
                SizedBox(width: interval1X), // 라벨과 고정된 값 사이의 간격
                Expanded(
                  // 오른쪽 Container가 남은 공간을 채우도록 설정
                  child: Container(
                    // 데이터 셀의 너비 설정
                    decoration: BoxDecoration(
                      // color: GRAY96_COLOR,
                      color:
                          Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                      border: Border.all(color: GRAY83_COLOR, width: 1), // 윤곽선
                      borderRadius: BorderRadius.circular(6),
                    ),
                    // 고정된 값을 표시하기 위한 컨테이너
                    padding: EdgeInsets.symmetric(horizontal: interval2X),
                    // 컨테이너 내부 여백 설정
                    alignment: Alignment.centerLeft, // 텍스트 정렬
                    child: Text(
                      value ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: BLACK_COLOR,
                        fontFamily: 'NanumGothic',
                        fontSize: reviewInfoRowTextFontSize,
                      ),
                    ), // 고정된 값을 텍스트로 표시
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 내용 입력 필드를 생성하는 함수
  Widget _buildContentsRow(
    BuildContext context,
    String label,
    TextEditingController controller,
    String hintText,
  ) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 컨텐츠 사이의 간격 수치
    final double interval1X = screenSize.width * (4 / referenceWidth);
    final double interval1Y = screenSize.height * (2 / referenceHeight);
    final double interval2Y = screenSize.height * (4 / referenceHeight);
    final double interval2X = screenSize.width * (8 / referenceWidth);
    final double interval3X = screenSize.width * (10 / referenceWidth);
    final double reviewInfoRowTextFontSize =
        screenSize.height * (14 / referenceHeight);
    final double reviewInfoRowWidth = screenSize.width * (70 / referenceWidth);
    final double reviewInfoRowHeight =
        screenSize.width * (90 / referenceHeight);

    return Padding(
      // 패딩을 추가하여 요소 주위에 여백을 줌
      padding:
          EdgeInsets.symmetric(horizontal: interval3X, vertical: interval1Y),
      // 행의 상하단에 2.0 픽셀의 여백 추가
      child: Column(
        // 요소들을 세로로 배치하기 위해 Column 사용
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 요소들을 왼쪽 정렬
        children: [
          IntrinsicHeight(
            // 왼쪽 Container와 오른쪽 TextField의 높이를 동일하게 맞추기 위해 사용
            child: Row(
              // 요소들을 가로로 배치하기 위해 Row 사용
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // 자식 위젯들을 위아래로 늘림
              children: [
                Container(
                  // 제목 라벨을 위한 컨테이너 생성
                  width: reviewInfoRowWidth,
                  height: reviewInfoRowHeight,
                  // 왼쪽 라벨 부분의 너비 설정
                  decoration: BoxDecoration(
                    // color: GRAY96_COLOR,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    // 앱 기본 배경색
                    border: Border.all(color: GRAY83_COLOR, width: 1),
                    // 윤곽선
                    borderRadius: BorderRadius.circular(6),
                  ),
                  // 셀 내부 여백 설정
                  alignment: Alignment.center,
                  // 텍스트를 왼쪽 정렬
                  child: Text(
                    label, // 셀에 표시될 텍스트
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NanumGothic',
                      fontSize: reviewInfoRowTextFontSize,
                      color: BLACK_COLOR,
                    ), // 텍스트를 굵게 설정
                  ),
                ),
                SizedBox(width: interval1X), // 라벨과 텍스트 필드 사이의 간격
                Expanded(
                  // 오른쪽 TextField가 남은 공간을 채우도록 설정
                  child: TextField(
                    // 사용자로부터 텍스트를 입력받기 위한 필드
                    controller: controller, // 텍스트 필드 컨트롤러 설정
                    maxLength: 300, // 최대 글자 수 설정
                    maxLines: null, // 텍스트가 길어질 때 자동으로 줄바꿈 되도록 설정
                    decoration: InputDecoration(
                      // 텍스트 필드의 외관을 설정
                      hintText: hintText, // 힌트 텍스트 설정
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: GRAY83_COLOR, width: 1.0),
                          borderRadius: BorderRadius.circular(6), // 모서리 각도를 제목 라벨과 동일하게 설정
                      ), // 입력 경계선 설정
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: GRAY83_COLOR, width: 1.0), // 비활성 상태의 테두리 설정
                        borderRadius: BorderRadius.circular(6), // 모서리 각도를 제목 라벨과 동일하게 설정
                      ),
                      focusedBorder: OutlineInputBorder(
                        // 활성화 상태의 테두리 설정
                        borderSide: BorderSide(
                            color: ORANGE56_COLOR,
                            width: 1.0,
                        ), // 활성화 상태의 테두리 색상을 BUTTON_COLOR로 설정
                          borderRadius: BorderRadius.circular(6), // 모서리 각도를 제목 라벨과 동일하게 설정
                      ),
                      counterText: '', // 글자수 표시를 비워둠 (아래에 별도로 표시)
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: interval2Y), // TextField와 글자 수 표시 사이의 여백
          Align(
            // 글자 수 표시를 오른쪽에 맞춤
            alignment: Alignment.centerRight, // 오른쪽에 글자 수 표시
            child: ValueListenableBuilder<TextEditingValue>(
              // 텍스트 입력 시마다 변경사항을 반영
              valueListenable: controller, // 텍스트 필드의 변경사항을 모니터링
              builder: (context, value, child) {
                return Text(
                  // 입력된 글자 수를 표시
                  '${value.text.length}/300', // 글자 수를 반영
                  style: TextStyle(
                    color: GRAY62_COLOR,
                    fontFamily: 'NanumGothic',
                    fontSize: reviewInfoRowTextFontSize,
                  ), // 글자 수 표시 스타일
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 사진 업로드 버튼을 생성하는 함수
  Widget _buildPhotoUploadRow(String label, BuildContext context) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 컨텐츠 사이의 간격 수치
    final double interval1X = screenSize.width * (4 / referenceWidth);
    final double interval2X = screenSize.width * (8 / referenceWidth);
    final double interval3X = screenSize.width * (2 / referenceWidth);
    final double interval4X = screenSize.width * (10 / referenceWidth);
    final double interval1Y = screenSize.height * (2 / referenceHeight);
    final double interval2Y = screenSize.height * (10 / referenceHeight);
    final double interval3Y = screenSize.height * (30 / referenceHeight);
    final double interval4Y = screenSize.height * (4 / referenceHeight);
    final double reviewInfoRowTextFontSize =
        screenSize.height * (14 / referenceHeight);
    final double reviewInfoGuideTextFontSize =
        screenSize.height * (11 / referenceHeight);
    final double reviewInfoRowBtnImageSize =
        screenSize.height * (25 / referenceHeight);
    final double reviewPhotoRowWidth =
        screenSize.width * (210 / referenceWidth);
    final double reviewPhotoBtnWidth = screenSize.width * (60 / referenceWidth);
    final double reviewPhotoRowHeight =
        screenSize.height * (30 / referenceHeight);
    final double reviewInfoImageWidth =
        screenSize.width * (60 / referenceWidth);
    final double reviewInfoImageHeight =
        screenSize.width * (60 / referenceHeight);
    final double reviewInfoImageX = screenSize.width * (10 / referenceWidth);
    final double reviewInfoImageY = screenSize.width * (10 / referenceHeight);

    final double dynamicContainerWidth =
        screenSize.width * (373 / referenceWidth); // 새 컨테이너 너비
    final double dynamicContainerHeight = dynamicContainerWidth / 4; // 높이 설정

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: interval4X, vertical: interval1Y),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 수평 방향에서 왼쪽 정렬
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, // 세로 방향 중앙 정렬
            children: [
              Container(
                width: reviewPhotoRowWidth,
                // '리뷰 사진' 컨테이너 너비
                height: reviewPhotoRowHeight,
                // '리뷰 사진' 컨테이너 높이
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(color: GRAY83_COLOR, width: 1), // 윤곽선
                  borderRadius: BorderRadius.circular(6), // 모서리 둥글게
                ),
                alignment: Alignment.center,
                // 텍스트 중앙 정렬
                child: Text(
                  label, // '리뷰 사진' 텍스트
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NanumGothic',
                    fontSize: reviewInfoRowTextFontSize,
                    color: BLACK_COLOR,
                  ),
                ),
              ),
              SizedBox(width: interval2X), // 컨테이너와 버튼 사이 간격
              Container(
                width: reviewPhotoBtnWidth, // 버튼 너비 고정
                height: reviewPhotoRowHeight, // 버튼 높이를 컨테이너 높이에 맞춤
                child: ElevatedButton(
                  onPressed: () async {
                    await _pickImage(context); // 이미지 업로드 함수 호출
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundColor: ORANGE56_COLOR,
                    padding: EdgeInsets.symmetric(
                      vertical: interval1Y,
                      horizontal: interval3X,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child:
                      Icon(Icons.camera_alt, size: reviewInfoRowBtnImageSize),
                ),
              ),
              SizedBox(width: interval2X), // 컨테이너와 버튼 사이 간격
              Container(
                width: reviewPhotoBtnWidth, // 버튼 너비 고정
                height: reviewPhotoRowHeight, // 버튼 높이를 컨테이너 높이에 맞춤
                child: ElevatedButton(
                  onPressed: () async {
                    await _requestPermission(context); // 권한 요청 함수 호출
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundColor: ORANGE56_COLOR,
                    padding: EdgeInsets.symmetric(
                      vertical: interval1Y,
                      horizontal: interval3X,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Icon(Icons.settings, size: reviewInfoRowBtnImageSize),
                ),
              ),
            ],
          ),
          SizedBox(height: interval4Y), // 행과 경고 메시지 사이 간격 추가
          RichText(
            // 다양한 스타일을 조합하기 위해 RichText 사용
            text: TextSpan(
              children: [
                TextSpan(
                  text: "초기 설정 후 사진 업로드 해주세요.", // 빨간색으로 강조된 부분
                  style: TextStyle(
                    color: BLACK_COLOR, // 텍스트 색상 검은색
                    fontWeight: FontWeight.bold, // 굵은 글씨
                    fontSize: reviewInfoGuideTextFontSize,
                    fontFamily: 'NanumGothic',
                  ),
                ),
                TextSpan(
                  text: "  ( [설정] 버튼 클릭 -> 사진 앱 권한 허용 )",
                  // 검은색으로 강조된 부분
                  style: TextStyle(
                    color: RED46_COLOR, // 텍스트 색상 빨간색
                    fontWeight: FontWeight.bold, // 굵은 글씨
                    fontSize: reviewInfoGuideTextFontSize,
                    fontFamily: 'NanumGothic',
                  ),
                ),
              ],
            ),
          ),
          if (_images.isNotEmpty) // 이미지가 있을 때만 컨테이너 표시
            Padding(
              padding: EdgeInsets.only(top: interval4Y),
              child: Container(
                width: dynamicContainerWidth, // 동적 너비
                height: dynamicContainerHeight, // 높이: 너비의 1/4
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  // border: Border.all(color: GRAY83_COLOR, width: 1), // 윤곽선
                  // borderRadius: BorderRadius.circular(6), // 모서리 둥글게
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
                  children: _images.asMap().entries.map((entry) {
                    int index = entry.key; // 이미지 인덱스
                    File image = entry.value; // 이미지 파일
                    final double imageSize =
                        dynamicContainerWidth / 4; // 이미지 크기
                    return Padding(
                      padding: EdgeInsets.only(right: interval2X),
                      child: Stack(
                        children: [
                          Image.file(
                            image,
                            width: imageSize,
                            height: imageSize, // 너비와 동일
                            fit: BoxFit.cover, // 이미지 맞춤
                          ),
                          Positioned(
                            right: -interval4X,
                            top: -interval2Y,
                            child: IconButton(
                              icon: Icon(Icons.cancel, color: Colors.white),
                              onPressed: () => _removeImage(index), // 이미지 삭제
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // '리뷰 작성 완료' 버튼을 생성하는 함수
  // _buildSubmitButton: 리뷰 작성 완료 버튼을 생성하는 함수
  Widget _buildSubmitButton(BuildContext context) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 컨텐츠 사이의 간격 수치
    final double interval1X = screenSize.width * (30 / referenceWidth);
    final double interval2X = screenSize.width * (8 / referenceWidth);
    final double interval3X = screenSize.width * (20 / referenceWidth);
    final double interval1Y = screenSize.height * (10 / referenceHeight);
    final double reviewWriteBtnTextFontSize =
        screenSize.height * (16 / referenceHeight);

    return Center(
      // Center 위젯을 사용하여 버튼을 중앙에 배치함
      child: ElevatedButton(
        // ElevatedButton을 사용하여 '리뷰 작성 완료' 버튼을 생성함
        onPressed: () async {
          // 버튼 클릭 시 실행되는 비동기 함수
          // 필수 항목 검증 (리뷰 제목, 리뷰 내용을 작성해야만 저장되도록 설정)
          if (widget.titleController.text.isEmpty ||
              widget.contentController.text.isEmpty) {
            showCustomSnackBar(context, '리뷰 제목과 리뷰 내용을 기입한 후 등록해주세요.');
            return;
          }
          await showSubmitAlertDialog(
            context,
            title: '[리뷰 등록]',
            // 팝업의 제목을 '리뷰 등록'으로 설정함
            content: '리뷰를 등록하면 수정하실 수 없습니다.\n작성하신 리뷰를 등록하시겠습니까?',
            // 팝업의 내용을 설정함
            actions: buildAlertActions(
              context,
              noText: '아니요',
              // '아니요' 버튼의 텍스트를 설정함
              yesText: '예',
              // '예' 버튼의 텍스트를 설정함
              noTextStyle: TextStyle(
                // '아니요' 버튼의 스타일을 검은색 Bold로 설정함
                color: BLACK_COLOR,
                fontWeight: FontWeight.bold,
              ),
              yesTextStyle: TextStyle(
                // '예' 버튼의 스타일을 빨간색 Bold로 설정함
                color: RED46_COLOR,
                fontWeight: FontWeight.bold,
              ),
              onYesPressed: () async {
                // '예' 버튼이 눌렸을 때 실행되는 비동기 함수
                try {
                  // 리뷰를 제출하는 로직을 실행함
                  await ref.read(submitPrivateReviewProvider)(
                    userEmail: widget.userEmail,
                    // 사용자의 이메일을 전달함
                    orderNumber: widget.numberInfo['order_number'],
                    // 주문 번호를 전달함
                    reviewTitle: widget.titleController.text,
                    // 리뷰 제목을 전달함
                    reviewContents: widget.contentController.text,
                    // 리뷰 내용을 전달함
                    images: _images,
                    // 첨부된 이미지를 전달함
                    productInfo: widget.productInfo,
                    // 제품 정보를 전달함
                    numberInfo: widget.numberInfo,
                    // 주문 관련 정보를 전달함
                    userName: await ref
                        .read(userNameProvider(widget.userEmail).future),
                    // 사용자의 이름을 비동기로 가져와 전달함
                    paymentCompleteDate: await ref.read(
                        paymentCompleteDateProvider(
                                widget.numberInfo['order_number'])
                            .future),
                    // 결제 완료 날짜를 비동기로 가져와 전달함
                    deliveryStartDate: await ref.read(deliveryStartDateProvider(
                            widget.numberInfo['order_number'])
                        .future), // 배송 시작 날짜를 비동기로 가져와 전달함
                  );

                  ref.invalidate(
                      privateReviewItmesListNotifierProvider); // 리뷰 목록 초기화

                  navigateToScreenAndRemoveUntil(
                    context,
                    ref,
                    PrivateReviewMainScreen(navigateToListTab: true),
                    // 리뷰 메인 화면으로 이동함
                    4, // 하단 탭바의 인덱스를 초기화함 (필요시 변경)
                  );

                  // 리뷰 작성 완료 메시지를 표시함
                  showCustomSnackBar(context, '리뷰가 작성되었습니다.');
                } catch (e) {
                  // 리뷰 작성 중 오류가 발생한 경우 오류 메시지를 표시함
                  showCustomSnackBar(context, '리뷰 작성 중 오류가 발생했습니다: $e');
                }
              },
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          // ElevatedButton의 스타일을 설정함
          foregroundColor: ORANGE56_COLOR, // 텍스트 색상 설정
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor, // 버튼 배경색을 앱 배경색으로 설정
          side: BorderSide(
            color: ORANGE56_COLOR,
          ), // 버튼 테두리 색상 설정
          padding: EdgeInsets.symmetric(
              vertical: interval1Y, horizontal: interval1X), // 버튼의 패딩을 설정함
        ),
        // 버튼의 텍스트를 설정하고, 크기와 두께를 지정함
        child: Text(
          '리뷰 등록',
          style: TextStyle(
            fontFamily: 'NanumGothic',
            color: ORANGE56_COLOR, // 텍스트 색상 설정
            fontWeight: FontWeight.bold, // 텍스트를 Bold로 설정함
            fontSize: reviewWriteBtnTextFontSize, // 텍스트 크기를 16으로 설정함
          ),
        ),
      ),
    );
  }
}
// ------ 리뷰 작성 상세 화면 관련 UI 내용인 PrivateReviewCreateDetailFormScreen 클래스 내용 끝 부분

// ------ 리뷰 목록 화면 관련 UI 내용인 PrivateReviewListScreen 클래스 내용 시작 부분
class PrivateReviewItemsList extends ConsumerStatefulWidget {
  @override
  _PrivateReviewItemsListState createState() => _PrivateReviewItemsListState();
}

class _PrivateReviewItemsListState
    extends ConsumerState<PrivateReviewItemsList> {
  Map<int, bool> _expandedReviews = {};

  @override
  Widget build(BuildContext context) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    final double reviewTitleFontSize =
        screenSize.height * (18 / referenceHeight); //  크기 설정함
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

    // 리뷰 제목 등의 텍스트 데이터 크기 설정
    final double reviewTitleTextFontSize =
        screenSize.height * (14 / referenceHeight); // 리뷰 제목 텍스트 글꼴 크기 설정함
    final double reviewContentsTextFontSize =
        screenSize.height * (14 / referenceHeight); // 리뷰 내용 텍스트 글꼴 크기 설정함
    final double reviewWriteDateTextFontSize =
        screenSize.height * (14 / referenceHeight); // 리뷰 작성일자 텍스트 글꼴 크기 설정함

    // 펼치기 및 닫기 버튼 수치
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

    // 숫자 형식을 '###,###'로 지정함
    final numberFormat = NumberFormat('###,###');

    // 날짜 형식을 'yyyy년 MM월 dd일 HH시 MM분'로 지정함
    final dateFormat = DateFormat('yyyy년 MM월 dd일 HH시 MM분');

    final reviewItems = ref.watch(privateReviewItmesListNotifierProvider);

    // ——— 리뷰 목록 데이터를 UI로 렌더링하는 위젯
    if (reviewItems.isEmpty) {
      // 리뷰 목록이 비어있을 경우 "리뷰 목록 내 리뷰가 없습니다." 메시지 표시
      return Container(
        width: reviewEmptyTextWidth,
        // "리뷰 없음" 메시지의 가로 길이
        height: reviewEmptyTextHeight,
        // "리뷰 없음" 메시지의 세로 길이
        margin: EdgeInsets.only(top: reviewEmptyTextY),
        // 텍스트를 중앙에 위치하도록 설정함.
        alignment: Alignment.center,
        // "리뷰 없음" 메시지의 위치 설정
        child: Text(
          '현재 리뷰 목록 내 리뷰가 없습니다.', // 리뷰가 없을 때 표시할 메시지
          style: TextStyle(
            fontSize: reviewEmptyTextFontSize, // 텍스트의 폰트 크기
            fontFamily: 'NanumGothic', // 텍스트의 폰트 패밀리
            fontWeight: FontWeight.bold, // 텍스트의 굵기
            color: BLACK_COLOR, // 텍스트의 색상
          ),
        ),
      );
    }

    // 리뷰 목록이 있을 경우, 스크롤 가능한 뷰를 생성
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 열의 정렬을 시작 지점으로 설정
        children: reviewItems.asMap().entries.map((entry) {
          final index = entry.key; // 현재 리뷰의 인덱스
          final review = entry.value; // 현재 리뷰의 데이터
          final reviewImages = [
            review['review_image1'], // 첫 번째 리뷰 이미지
            review['review_image2'], // 두 번째 리뷰 이미지
            review['review_image3'], // 세 번째 리뷰 이미지
          ]
              .where((image) => image != null) // 이미지가 null이 아닌 경우 필터링
              .map((image) => image.toString() ?? '') // 이미지 URL을 문자열로 변환
              .toList(); // 리스트로 변환

          // 각 리뷰에 첨부된 이미지를 리스트로 저장함.
          // 이미지가 null이 아닌 경우에만 리스트에 포함시키고,
          // 이미지를 문자열로 변환하여 리스트에 추가함.

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
                  children: [
                    Row(
                      children: [
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
                        // 상품 내용 제목과 삭제 버튼 사이의 공간을 차지하여 삭제 버튼이 오른쪽 끝에 위치하도록 함
                        Expanded(
                          child: Container(),
                        ),
                        // 삭제 버튼을 오른쪽 끝에 배치함
                        Container(
                          width: deleteBtnWidth,
                          height: deleteBtnHeight,
                          margin: EdgeInsets.only(right: intervalX),
                          // 오른쪽 여백 설정
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: GRAY44_COLOR,
                              // 텍스트 색상 설정
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
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
                                // 다이얼로그의 제목을 설정함
                                title: '[리뷰 삭제]',
                                // 다이얼로그의 내용을 설정함
                                content:
                                    '삭제 시, 해당 리뷰는 영구적으로 삭제됩니다.\n해당 리뷰를 삭제하시겠습니까?',
                                // 다이얼로그에 표시할 버튼들을 생성함
                                actions: buildAlertActions(
                                  context,
                                  // '아니요' 버튼 텍스트를 설정함
                                  noText: '아니요',
                                  // '예' 버튼 텍스트를 설정함
                                  yesText: '예',
                                  // '아니요' 버튼 텍스트 스타일을 설정함
                                  noTextStyle: TextStyle(
                                    color: BLACK_COLOR,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  // '예' 버튼 텍스트 스타일을 설정함
                                  yesTextStyle: TextStyle(
                                    color: RED46_COLOR,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  // '예' 버튼이 눌렸을 때 실행되는 비동기 함수
                                  onYesPressed: () async {
                                    try {
                                      final separatorKey =
                                          review['separator_key'];
                                      await ref
                                          .read(
                                              privateReviewItmesListNotifierProvider
                                                  .notifier)
                                          .deleteReview(separatorKey);
                                      Navigator.of(context).pop();
                                      showCustomSnackBar(
                                          context, '리뷰가 삭제되었습니다.');
                                    } catch (e) {
                                      showCustomSnackBar(
                                          context, '리뷰 삭제 중 오류가 발생했습니다: $e');
                                    }
                                  },
                                ),
                              );
                            },
                            // 삭제 버튼의 텍스트를 설정함
                            child: Text(
                              '삭제',
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

                    _buildReviewInfoRow(
                        '발주번호: ',
                        review['order_number']?.toString().isNotEmpty == true
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
                    GestureDetector(
                      onTap: () {
                        final product = ProductContent(
                          docId: review['product_id'] ?? '',
                          category: review['category']?.toString() ?? '',
                          productNumber:
                              review['product_number']?.toString() ?? '',
                          thumbnail: review['thumbnails']?.toString() ?? '',
                          briefIntroduction:
                              review['brief_introduction']?.toString() ?? '',
                          originalPrice: review['original_price'] ?? 0,
                          discountPrice: review['discount_price'] ?? 0,
                          discountPercent: review['discount_percent'] ?? 0,
                        );
                        final navigatorProductDetailScreen =
                            ProductInfoDetailScreenNavigation(ref);
                        navigatorProductDetailScreen.navigateToDetailScreen(
                            context, product);
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }

  // _buildReviewInfoRow 함수는 리뷰의 정보 항목을 텍스트 형태로 표시하는 행(Row)을 생성함.
  // 리뷰 정보의 라벨과 값은 파라미터로 전달되며, 필요에 따라 굵은 텍스트로 표시할 수 있음.
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

            SizedBox(width: interval1X),
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

  // _buildReviewImagesRow 함수는 리뷰에 첨부된 이미지들을 가로로 나열하여 표시함.
  // 이미지의 크기는 화면의 너비를 기준으로 설정되며,
  // 사용자가 이미지를 클릭할 경우 원본 이미지 상세 화면으로 이동함.
  Widget _buildReviewImagesRow(List<String> images, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final imageWidth = width / 4;
    // 화면의 가로 너비를 기준으로 각 이미지의 크기를 설정함.
    // 이미지 하나의 너비는 화면 너비의 1/4로 설정됨.

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
                  images: images,
                  initialPage: images.indexOf(image),
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
// ------ 리뷰 목록 탭 화면 관련 UI 내용인 PrivateReviewListScreen 클래스 내용 끝 부분
