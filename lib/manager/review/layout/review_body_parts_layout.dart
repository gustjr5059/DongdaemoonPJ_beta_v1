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
    Future.microtask(() => _resetForm()); // 초기화 작업을 비동기로 수행하는 코드
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() => _resetForm()); // 의존성 변경 시 초기화 작업을 비동기로 수행하는 코드
  }

  void _resetForm() {
    setState(() {
      // 데이터를 실시간으로 반영하는 화면에서는 데이터를 불러오는 provider 초기화 로직이 화면마다의 initState()에는 필요없음!!
      // - 이게 다른 화면으로 이동 후 사용하는 로직이므로..
      ref.read(adminSelectedUserEmailProvider.notifier).state = null; // 선택된 사용자 이메일 초기화
      ref.invalidate(adminDeleteReviewProvider); // 리뷰 삭제 관련 데이터 초기화
    });
  }

  // review_delete_time 필드의 데이터 타입이 Timestamp로 되어 있어, 이를 DateTime으로 변환한 후, 문자열로 포맷팅하는 함수
  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate(); // Timestamp를 DateTime으로 변환하는 코드
      return DateFormat('[yyyy년 MM월 dd일 HH시 mm분] ').format(dateTime); // 변환된 DateTime을 포맷팅하여 문자열로 반환하는 코드
    } else {
      return ''; // timestamp가 Timestamp 타입이 아닌 경우 빈 문자열 반환
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedUserEmail = ref.watch(adminSelectedUserEmailProvider); // 선택된 사용자 이메일을 구독하는 코드
    final usersEmail = ref.watch(adminUsersEmailProvider); // 모든 사용자 이메일 목록을 구독하는 코드
    final reviews = ref.watch(adminReviewListProvider(selectedUserEmail)); // 선택된 사용자의 리뷰 목록을 구독하는 코드

    return Column(
      children: [
        usersEmail.when(
          data: (usersEmailList) {
            return DropdownButton<String>(
              hint: Text('리뷰 작성자 선택'), // 드롭다운 버튼의 힌트 텍스트 설정
              value: selectedUserEmail, // 선택된 이메일 값을 드롭다운 버튼에 반영하는 코드
              onChanged: (value) {
                ref.read(adminSelectedUserEmailProvider.notifier).state = value; // 선택된 이메일 값을 변경하는 코드
              },
              items: usersEmailList.map((email) {
                return DropdownMenuItem<String>(
                  value: email, // 각 이메일을 드롭다운의 항목으로 설정하는 코드
                  child: Text(email), // 드롭다운 항목에 표시할 텍스트 설정
                );
              }).toList(),
            );
          },
          loading: () => CircularProgressIndicator(), // 데이터 로딩 중에 표시할 로딩 스피너
          error: (error, stack) => Text('오류가 발생했습니다: $error'), // 오류 발생 시 표시할 텍스트
        ),
        SizedBox(height: 20), // 드롭다운 버튼과 리뷰 목록 사이의 간격을 설정하는 코드
        reviews.when(
          data: (reviewList) {
            if (reviewList.isEmpty) {
              return Center(child: Text('리뷰가 없습니다.')); // 리뷰 목록이 비어 있을 경우 표시할 텍스트
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: reviewList.asMap().entries.map((entry) {
                  final index = entry.key; // 현재 리뷰 항목의 인덱스
                  final review = entry.value; // 현재 리뷰 항목의 데이터
                  final reviewImages = [
                    review['review_image1'],
                    review['review_image2'],
                    review['review_image3']
                  ]
                      .where((image) => image != null)
                      .map((image) => image.toString())
                      .toList(); // 리뷰에 포함된 이미지들을 리스트로 저장하는 코드

                  // private_review_closed_button 필드값에 따라 '[O]' 또는 '[X]' 표시
                  String statusIcon = review['private_review_closed_button'] == true ? '[삭제 O]' : '[삭제 X]'; // private_review_closed_button 값에 따라 상태 아이콘 설정
                  String deleteTime = '';

                  // 'review_delete_time' 필드값이 존재 유무에 따라 해당 필드값을 노출
                  if (review.containsKey('review_delete_time')) {
                    deleteTime = formatTimestamp(review['review_delete_time']); // 리뷰 삭제 시간을 포맷팅하여 저장하는 코드
                  }

                  return CommonCardView(
                    backgroundColor: BEIGE_COLOR, // 카드 뷰의 배경색 설정
                    content: Padding(
                      padding: const EdgeInsets.all(8.0), // 카드 뷰 내용의 패딩 설정
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // 내용물을 왼쪽 정렬
                        children: [
                          if (deleteTime.isNotEmpty)
                            Text(
                              deleteTime, // 삭제 시간이 있을 경우 표시
                              style: TextStyle(
                                fontSize: 14, // 텍스트 크기 설정
                                fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                              ),
                            )
                          else
                            Container(),  // deleteTime이 없을 경우 빈 컨테이너로 공간 확보
                          Text(
                            statusIcon, // 리뷰 상태 아이콘 표시
                            style: TextStyle(
                                fontSize: 14, // 텍스트 크기 설정
                                fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                color: review['private_review_closed_button'] == true ? Colors.red : Colors.black // 상태에 따라 텍스트 색상 변경
                            ),
                          ),
                          SizedBox(height: 4.0), // 상태 아이콘과 다음 항목 사이의 간격 설정
                          if (review['product_number'] != null)
                            _buildReviewInfoRow('상품번호: ', review['product_number'], bold: true), // 상품번호가 있을 경우 표시
                          SizedBox(height: 2.0), // 상품번호와 다음 항목 사이의 간격 설정
                          if (review['brief_introduction'] != null)
                            _buildReviewInfoRow(review['brief_introduction'], '', bold: true), // 간단한 소개가 있을 경우 표시
                          SizedBox(height: 2.0), // 간단한 소개와 다음 항목 사이의 간격 설정
                          GestureDetector(
                            onTap: () {
                              final product = ProductContent(
                                docId: review['product_id'] ?? '', // 제품 ID 설정
                                category: review['category']?.toString() ?? '에러 발생', // 제품 카테고리 설정
                                productNumber: review['product_number']?.toString() ?? '에러 발생', // 제품 번호 설정
                                thumbnail: review['thumbnails']?.toString() ?? '', // 썸네일 이미지 설정
                                briefIntroduction: review['brief_introduction']?.toString() ?? '에러 발생', // 간단한 소개 설정
                                originalPrice: review['original_price'] ?? 0, // 원가 설정
                                discountPrice: review['discount_price'] ?? 0, // 할인된 가격 설정
                                discountPercent: review['discount_percent'] ?? 0, // 할인율 설정
                              );
                              final navigatorProductDetailScreen = ProductInfoDetailScreenNavigation(ref); // 제품 상세 화면으로의 네비게이터 설정
                              navigatorProductDetailScreen.navigateToDetailScreen(context, product); // 제품 상세 화면으로 이동하는 코드
                              // 사용자가 리뷰 항목을 클릭했을 때 제품 상세 화면으로 이동함.
                              // 리뷰에 포함된 제품 정보를 기반으로 ProductContent 객체를 생성하여,
                              // 상세 화면으로 해당 데이터를 전달함.
                            },
                            child: CommonCardView(
                              backgroundColor: Colors.white, // 카드 뷰의 배경색 설정
                              content: Padding(
                                padding: const EdgeInsets.all(2.0), // 카드 뷰 내용의 패딩 설정
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // 내용물을 왼쪽 정렬
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: review['thumbnails']?.toString().isNotEmpty == true
                                              ? Image.network(review['thumbnails'], fit: BoxFit.cover) // 썸네일 이미지 표시
                                              : Icon(Icons.image_not_supported), // 썸네일이 없을 경우 아이콘 표시
                                        ),
                                        SizedBox(width: 8), // 이미지와 텍스트 사이의 간격 설정
                                        Expanded(
                                          flex: 7,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
                                            children: [
                                              if (review['original_price'] != null)
                                                Text(
                                                  '${NumberFormat('###,###').format(review['original_price'])} 원', // 원가를 포맷팅하여 표시
                                                  style: TextStyle(
                                                    color: Colors.grey[500], // 텍스트 색상 설정
                                                    fontSize: 14, // 텍스트 크기 설정
                                                    decoration: TextDecoration.lineThrough, // 텍스트에 취소선 추가
                                                  ),
                                                ),
                                              if (review['discount_price'] != null)
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${NumberFormat('###,###').format(review['discount_price'])} 원', // 할인된 가격을 포맷팅하여 표시
                                                      style: TextStyle(fontWeight: FontWeight.bold), // 텍스트 굵기 설정
                                                    ),
                                                    SizedBox(width: 8), // 가격과 할인율 사이의 간격 설정
                                                    if (review['discount_percent'] != null)
                                                      Text(
                                                        '${(review['discount_percent']).toInt()}%', // 할인율을 포맷팅하여 표시
                                                        style: TextStyle(
                                                          color: Colors.red, // 텍스트 색상 설정
                                                          fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              if (review['selected_color_text'] != null)
                                                Row(
                                                  children: [
                                                    review['selected_color_image']?.toString().isNotEmpty == true
                                                        ? Image.network(
                                                      review['selected_color_image'], // 선택한 색상 이미지 표시
                                                      height: 18, // 이미지 높이 설정
                                                      width: 18, // 이미지 너비 설정
                                                      fit: BoxFit.cover, // 이미지 비율 유지
                                                    )
                                                        : Icon(Icons.image_not_supported, size: 20), // 이미지가 없을 경우 아이콘 표시
                                                    SizedBox(width: 8), // 이미지와 텍스트 사이의 간격 설정
                                                    Text(
                                                      review['selected_color_text'] ?? '에러 발생', // 선택한 색상 텍스트 표시
                                                      overflow: TextOverflow.ellipsis, // 텍스트가 길 경우 생략 부호 추가
                                                    ),
                                                  ],
                                                ),
                                              if (review['selected_size'] != null)
                                                Text('사이즈: ${review['selected_size']}'), // 선택한 사이즈 표시
                                              if (review['selected_count'] != null)
                                                Text('수량: ${review['selected_count']} 개'), // 선택한 수량 표시
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
                          SizedBox(height: 8.0), // 리뷰 정보와 버튼 사이의 간격 설정
                          if (_expandedReviews[index] == true) ...[
                            if (review['review_title'] != null)
                              _buildReviewInfoRow('제목: ', review['review_title'], bold: true), // 리뷰 제목 표시
                            SizedBox(height: 2.0), // 제목과 다음 항목 사이의 간격 설정
                            if (review['review_contents'] != null)
                              _buildReviewInfoRow('내용: ', review['review_contents'], bold: true), // 리뷰 내용 표시
                            SizedBox(height: 2.0), // 내용과 다음 항목 사이의 간격 설정
                            if (reviewImages.isNotEmpty) _buildReviewImagesRow(reviewImages, context), // 리뷰 이미지 표시
                            SizedBox(height: 4.0), // 이미지와 작성일 사이의 간격 설정
                            if (review['review_write_time'] != null)
                              _buildReviewInfoRow(
                                '작성일자: ',
                                DateFormat('yyyy-MM-dd').format(
                                  (review['review_write_time'] as Timestamp).toDate(), // 작성일자를 포맷팅하여 표시
                                ),
                                bold: true,
                              ),
                            SizedBox(height: 2.0), // 작성일과 다음 항목 사이의 간격 설정
                          ],
                          Center(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _expandedReviews[index] = !(_expandedReviews[index] ?? false); // 펼치기/닫기 상태 변경
                                        });
                                      },
                                      child: Text(
                                        _expandedReviews[index] == true ? '[닫기]' : '[펼치기]', // 펼치기/닫기 버튼 텍스트 설정
                                        style: TextStyle(
                                          fontSize: 18, // 버튼 텍스트 크기 설정
                                          fontWeight: FontWeight.bold, // 버튼 텍스트 굵기 설정
                                          color: Colors.blue, // 버튼 텍스트 색상 설정
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: BUTTON_COLOR, // 버튼 텍스트 색상 설정
                                    backgroundColor: BACKGROUND_COLOR, // 버튼 배경색 설정
                                    side: BorderSide(color: BUTTON_COLOR), // 버튼 테두리 색상 설정
                                    padding: EdgeInsets.symmetric(vertical: 8), // 버튼 패딩 설정
                                  ),
                                  onPressed: () async {
                                    // 리뷰 삭제 버튼 클릭 시 확인 다이얼로그를 표시함
                                    await showSubmitAlertDialog(
                                      context,
                                      title: '리뷰 삭제', // 다이얼로그 제목 설정
                                      content: '리뷰를 삭제하면 데이터베이스에서 영구적으로 삭제됩니다.\n해당 리뷰를 삭제하시겠습니까?', // 다이얼로그 내용 설정
                                      actions: buildAlertActions(
                                        context,
                                        noText: '아니요', // 아니요 버튼 텍스트 설정
                                        yesText: '예', // 예 버튼 텍스트 설정
                                        noTextStyle: TextStyle(
                                          color: Colors.black, // 아니요 버튼 텍스트 색상 설정
                                          fontWeight: FontWeight.bold, // 아니요 버튼 텍스트 굵기 설정
                                        ),
                                        yesTextStyle: TextStyle(
                                          color: Colors.red, // 예 버튼 텍스트 색상 설정
                                          fontWeight: FontWeight.bold, // 예 버튼 텍스트 굵기 설정
                                        ),
                                        onYesPressed: () async {
                                          try {
                                            await ref.read(adminDeleteReviewProvider({
                                              'userEmail': selectedUserEmail!, // 선택된 사용자 이메일 전달
                                              'separatorKey': review['separator_key'], // 리뷰의 고유 키 전달
                                            }).future);
                                            Navigator.of(context).pop(); // 다이얼로그 닫기
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('리뷰가 삭제되었습니다.')), // 리뷰 삭제 완료 메시지 표시
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('리뷰 삭제 중 오류가 발생했습니다: $e')), // 오류 메시지 표시
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    '삭제', // 버튼 텍스트 설정
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                                      fontSize: 16, // 텍스트 크기 설정
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
          loading: () => Center(child: CircularProgressIndicator()), // 리뷰 로딩 중에 표시할 로딩 스피너
          error: (error, stack) => Center(child: Text('리뷰를 불러오는 중 오류가 발생했습니다.')), // 리뷰 로딩 중 오류 발생 시 표시할 텍스트
        ),
      ],
    );
  }

  // 리뷰 정보 항목을 표시하는 위젯
  Widget _buildReviewInfoRow(String label, String value, {bool bold = false}) {
    return Row(
      children: [
        Text(
          label, // 라벨 텍스트 설정
          style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal), // 텍스트 굵기 설정
        ),
        SizedBox(width: 4), // 라벨과 값 사이의 간격 설정
        Expanded(
          child: Text(
            value, // 값 텍스트 설정
            style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal), // 텍스트 굵기 설정
            overflow: TextOverflow.ellipsis, // 텍스트가 길 경우 생략 부호 추가
          ),
        ),
      ],
    );
  }

  // 리뷰 이미지 목록을 표시하는 위젯
  Widget _buildReviewImagesRow(List<String> images, BuildContext context) {
    final width = MediaQuery.of(context).size.width; // 화면 너비 가져오기
    final imageWidth = width / 4; // 이미지 너비 설정

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
            width: imageWidth, // 이미지 컨테이너 너비 설정
            height: imageWidth, // 이미지 컨테이너 높이 설정
            margin: const EdgeInsets.only(right: 8.0), // 이미지 사이의 간격 설정
            child: Image.network(image, fit: BoxFit.cover), // 이미지를 네트워크에서 가져와 표시
          ),
        );
      }).toList(),
    );
  }
}
// ------- 관리자용 리뷰 관리 화면 UI를 구현하는 AdminReviewListScreen 클래스 내용 끝 부분