import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../common/const/colors.dart';
import '../../product/model/product_model.dart';
import '../provider/order_all_providers.dart';
import '../view/order_postcode_search_screen.dart';

// 발주 화면 내 구매자정보 관련 UI 내용을 구현하는 UserInfoWidget 클래스 내용 시작
class UserInfoWidget extends ConsumerWidget {
  final String email;

  UserInfoWidget({required this.email}); // 생성자에서 이메일을 받아옴

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoAsyncValue = ref.watch(userInfoProvider(email)); // Riverpod을 사용하여 사용자 정보 프로바이더를 구독

    return userInfoAsyncValue.when(
      data: (userInfo) {
        // userInfo가 null인 경우에도 표를 유지하고, 데이터 필드에 '-'를 표시
        final name = userInfo?['name'] ?? '-';
        final email = userInfo?['email'] ?? '-';
        final phoneNumber = userInfo?['phone_number'] ?? '-';

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '구매자정보',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(color: Colors.grey.shade300),
                ),
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                children: [
                  _buildTableRow('이름', name), // 이름 행 생성
                  _buildTableRow('이메일', email), // 이메일 행 생성
                  _buildTableRow('휴대폰 번호', phoneNumber), // 휴대폰 번호 행 생성
                ],
              ),
              SizedBox(height: 8),
              Text(
                '* 해당 정보의 변경이 필요할 시, 로그인 화면 내 회원가입 절차를 통해 변경된 내용으로 재전송 해주세요.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()), // 로딩 상태 처리
      error: (error, stack) => Center(child: Text('Error: $error')), // 에러 상태 처리
    );
  }

  // 표의 행을 빌드하는 함수
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Container(
          color: Colors.grey.shade200,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8.0),
          child: value == '-'
              ? Center(child: Text(value))
              : Align(alignment: Alignment.centerLeft, child: Text(value)),
        ),
      ],
    );
  }
}
// 발주 화면 내 구매자정보 관련 UI 내용을 구현하는 UserInfoWidget 클래스 내용 끝

// 발주 화면 내 받는사람정보 관련 UI 내용을 구현하는 RecipientInfoWidget 클래스 내용 시작
class RecipientInfoWidget extends StatefulWidget {
  final String email;

  RecipientInfoWidget({required this.email}); // 생성자에서 이메일을 받아옴

  @override
  _RecipientInfoWidgetState createState() => _RecipientInfoWidgetState();
}

class _RecipientInfoWidgetState extends State<RecipientInfoWidget> {
  // 텍스트 입력 컨트롤러 선언
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController(text: '없음');
  TextEditingController _postalCodeController = TextEditingController(text: '없음');
  TextEditingController _detailAddressController = TextEditingController();
  TextEditingController _customMemoController = TextEditingController();

  // 포커스 노드 선언
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _postalCodeFocusNode = FocusNode();
  FocusNode _detailAddressFocusNode = FocusNode();
  FocusNode _customMemoFocusNode = FocusNode();

  String _selectedMemo = "기사님께 보여지는 메모입니다."; // 선택된 메모 초기값 설정
  bool _isCustomMemo = false; // 사용자 지정 메모 사용 여부

  @override
  void dispose() {
    // 컨트롤러와 포커스 노드 해제
    _nameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _detailAddressController.dispose();
    _customMemoController.dispose();
    _nameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _addressFocusNode.dispose();
    _postalCodeFocusNode.dispose();
    _detailAddressFocusNode.dispose();
    _customMemoFocusNode.dispose();
    super.dispose();
  }

  // 우편번호 검색 화면을 여는 함수
  Future<void> _openPostcodeSearch() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderPostcodeSearchScreen()),
    );

    if (result != null && result is List<String>) {
      setState(() {
        _addressController.text = result[0];
        _postalCodeController.text = result[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 화면을 탭할 때 키보드 숨기기
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '받는사람정보',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Column(
              children: [
                _buildDropdownRow('배송지', '배송지를 선택해주세요'), // 드롭다운 행 생성
                _buildEditableRow('이름', _nameController, _nameFocusNode, "'성'을 붙여서 이름을 기입해주세요."), // 수정 가능한 이름 행 생성
                _buildEditableRow('연락처', _phoneNumberController, _phoneNumberFocusNode, "'-'를 붙여서 연락처를 기입해주세요."), // 수정 가능한 연락처 행 생성
                _buildFixedValueRowWithButton('우편번호', _postalCodeController, '우편번호 찾기'), // 우편번호 찾기 버튼이 포함된 행 생성
                _buildFixedValueRow('주소', _addressController), // 고정된 값이 있는 주소 행 생성
                _buildEditableRow(
                  '상세주소',
                  _detailAddressController,
                  _detailAddressFocusNode,
                  "우편번호 및 주소를 선택 후 기입해주세요.",
                  isEnabled: _addressController.text != '없음' && _postalCodeController.text != '없음', // 우편번호와 주소가 없을 때는 비활성화
                ),
                _buildDropdownMemoRow(), // 드롭다운 메모 행 생성
                if (_isCustomMemo) _buildEditableRow('배송메모', _customMemoController, _customMemoFocusNode, '메모를 직접 기입해주세요.'), // 사용자 지정 메모가 활성화된 경우 수정 가능한 배송 메모 행 생성
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 드롭다운 행을 빌드하는 함수
  Widget _buildDropdownRow(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 80,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: hint,
                    onChanged: (String? newValue) {},
                    items: <String>[hint].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 수정 가능한 행을 빌드하는 함수
  Widget _buildEditableRow(String label, TextEditingController controller, FocusNode focusNode, String hintText, {bool isEnabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 80,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: isEnabled
                      ? () {
                    FocusScope.of(context).requestFocus(focusNode); // 행을 탭할 때 포커스를 설정
                  }
                      : null,
                  child: AbsorbPointer(
                    absorbing: !isEnabled, // isEnabled가 false일 때 입력 차단
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        hintMaxLines: 2,
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 고정된 값을 가진 행을 빌드하는 함수
  Widget _buildFixedValueRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 80,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Text(controller.text), // 고정된 값을 텍스트로 표시
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 버튼을 포함한 고정된 값을 가진 행을 빌드하는 함수
  Widget _buildFixedValueRowWithButton(String label, TextEditingController controller, String buttonText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 80,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(child: Text(controller.text)), // 고정된 값을 텍스트로 표시
                    ElevatedButton(
                      onPressed: _openPostcodeSearch, // 우편번호 찾기 버튼을 눌렀을 때 실행되는 함수
                      style: ElevatedButton.styleFrom(
                        foregroundColor: BUTTON_COLOR,
                        backgroundColor: BACKGROUND_COLOR,
                        side: BorderSide(color: BUTTON_COLOR),
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text('우편번호 찾기', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 드롭다운 메모 행을 빌드하는 함수
  Widget _buildDropdownMemoRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 80,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                '배송메모',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedMemo,
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == '직접입력') {
                          _isCustomMemo = true;
                          _selectedMemo = newValue!;
                        } else {
                          _isCustomMemo = false;
                          _selectedMemo = newValue!;
                        }
                      });
                    },
                    items: <String>[
                      '기사님께 보여지는 메모입니다.',
                      '경비실에 맡겨주세요',
                      '벨은 누르지 말아주세요',
                      '무인택배함에 넣어주세요',
                      '직접입력',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(), // 드롭다운 메뉴 항목 설정
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// 발주 화면 내 받는사람정보 관련 UI 내용을 구현하는 RecipientInfoWidget 클래스 내용 끝


// TotalPaymentWidget 클래스 정의
class TotalPaymentWidget extends StatelessWidget {
  final double totalPaymentAmount;
  final double totalProductAmount;
  final double productDiscount;

  TotalPaymentWidget({
    required this.totalPaymentAmount,
    required this.totalProductAmount,
    required this.productDiscount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '총 결제금액',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Table(
            border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.grey.shade300),
            ),
            columnWidths: {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            children: [
              _buildTableRow('총 상품금액', totalProductAmount.toStringAsFixed(0) + '원'),
              _buildTableRow('상품 할인', '-' + productDiscount.toStringAsFixed(0) + '원'),
              _buildTableRow('총 결제금액', totalPaymentAmount.toStringAsFixed(0) + '원', isTotal: true),
            ],
          ),
        ],
      ),
    );
  }

  // 표의 행을 빌드하는 함수
  TableRow _buildTableRow(String label, String value, {bool isTotal = false}) {
    return TableRow(
      children: [
        Container(
          color: Colors.grey.shade200,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerRight,
          child: Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.red : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  final ProductContent product;

  OrderItemWidget({required this.product});

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('###,###');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.briefIntroduction != null)
            Text(
              product.briefIntroduction!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // 제품 번호를 표시함.
            if (product.productNumber != null) // productNumber가 null이 아닌 경우에만 표시
            Text(
                  '상품번호: ${product.productNumber}', // productNumber 내용을 표시
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // 글자 크기를 18로 설정
                ),
            SizedBox(height: 8),
            Row(
              children: [
                if (product.thumbnail != null)
                  Image.network(
                    product.thumbnail!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${numberFormat.format(product.originalPrice)}원',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      '${numberFormat.format(product.discountPrice)}원',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${product.discountPercent?.round()}%',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('수량: ${product.selectedCount}'),
                    if (product.selectedColorImage != null)
                      Image.network(
                        product.selectedColorImage!,
                        height: 20,
                        width: 20,
                        fit: BoxFit.cover,
                      ),
                    Text('색상: ${product.selectedColorText}'),
                    Text('사이즈: ${product.selectedSize}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



// 카카오 API를 가져와서 주소검색 서비스 UI 내용을 구현하는 AddressSearchWidget 클래스 내용 시작
class AddressSearchWidget extends ConsumerStatefulWidget {
  @override
  _AddressSearchWidgetState createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends ConsumerState<AddressSearchWidget> {
  final TextEditingController _controller = TextEditingController(); // 주소 입력 컨트롤러
  String _query = ''; // 검색 쿼리
  bool _isFirstLoad = true; // 첫 로드 여부

  // 주소 검색 함수
  void _search() {
    setState(() {
      _query = _controller.text; // 검색 쿼리 설정
      _isFirstLoad = false; // 첫 로드 여부 설정
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressSearchResult = ref.watch(addressSearchProvider(_query)); // Riverpod을 사용하여 주소 검색 프로바이더를 구독

    return Column(
      mainAxisSize: MainAxisSize.min, // 부모의 제약 조건을 준수하도록 변경
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller, // 텍스트 필드 컨트롤러 설정
            decoration: InputDecoration(
              labelText: '주소 검색',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: _search, // 검색 버튼을 눌렀을 때 실행되는 함수
              ),
            ),
          ),
        ),
        if (_query.isNotEmpty && !_isFirstLoad) // 빈 쿼리와 첫 로드를 처리
          Flexible( // Expanded 대신 Flexible 사용
            child: addressSearchResult.when(
              data: (addresses) => ListView.builder(
                shrinkWrap: true,
                itemCount: addresses.length, // 검색 결과 개수
                itemBuilder: (context, index) {
                  final address = addresses[index]; // 주소 정보
                  final roadAddress = address['road_address']; // 도로명 주소
                  final zoneNo = roadAddress != null ? roadAddress['zone_no'] : ''; // 우편번호
                  final fullAddress = roadAddress != null ? roadAddress['address_name'] : address['address_name']; // 전체 주소
                  final displayAddress = zoneNo.isNotEmpty ? '$fullAddress [$zoneNo]' : fullAddress; // 표시할 주소
                  return ListTile(
                    title: Text(displayAddress),
                    onTap: () {
                      Navigator.pop(context, displayAddress); // 주소를 선택했을 때 이전 화면으로 반환
                    },
                  );
                },
              ),
              loading: () => Center(child: CircularProgressIndicator()), // 로딩 상태 처리
              error: (error, stack) => Center(child: Text('Error: $error')), // 에러 상태 처리
            ),
          ),
      ],
    );
  }
}
// 카카오 API를 가져와서 주소검색 서비스 UI 내용을 구현하는 AddressSearchWidget 클래스 내용 끝
