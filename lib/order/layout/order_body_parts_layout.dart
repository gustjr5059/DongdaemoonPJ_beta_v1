import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/const/colors.dart';
import '../provider/order_all_providers.dart';

class UserInfoWidget extends ConsumerWidget {
  final String email;

  UserInfoWidget({required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoAsyncValue = ref.watch(userInfoProvider(email));

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
                  _buildTableRow('이름', name),
                  _buildTableRow('이메일', email),
                  _buildTableRow('휴대폰 번호', phoneNumber),
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
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

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

class RecipientInfoWidget extends ConsumerStatefulWidget {
  final String email;

  RecipientInfoWidget({required this.email});

  @override
  _RecipientInfoWidgetState createState() => _RecipientInfoWidgetState();
}

class _RecipientInfoWidgetState extends ConsumerState<RecipientInfoWidget> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController(text: '없음');
  TextEditingController _postalCodeController = TextEditingController(text: '없음');
  TextEditingController _detailAddressController = TextEditingController();
  TextEditingController _customMemoController = TextEditingController();

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _postalCodeFocusNode = FocusNode();
  FocusNode _detailAddressFocusNode = FocusNode();
  FocusNode _customMemoFocusNode = FocusNode();

  String _selectedMemo = "기사님께 보여지는 메모입니다.";
  bool _isCustomMemo = false;

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 입력 필드 외부를 클릭하면 모든 입력 필드의 포커스를 해제
        FocusScope.of(context).unfocus();
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
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: [
                _buildDropdownRow('배송지', '배송지를 선택해주세요'),
                _buildEditableRow('이름', _nameController, _nameFocusNode, "'성'을 붙여서 이름을 기입해주세요."),
                _buildEditableRow('연락처', _phoneNumberController, _phoneNumberFocusNode, "'-'를 붙여서 연락처를 기입해주세요."),
                _buildFixedValueRowWithButton('우편번호', _postalCodeController, '우편번호 찾기'),
                _buildFixedValueRow('주소', _addressController),
                _buildEditableRow(
                  '상세주소',
                  _detailAddressController,
                  _detailAddressFocusNode,
                  "우편번호 및 주소를 선택 후 기입해주세요.",
                  isEnabled: _addressController.text != '없음' && _postalCodeController.text != '없음',
                ),
                _buildDropdownMemoRow(),
                if (_isCustomMemo) _buildEditableRow('배송메모', _customMemoController, _customMemoFocusNode, '메모를 직접 기입해주세요.'),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
                    FocusScope.of(context).requestFocus(focusNode);
                  }
                      : null,
                  child: AbsorbPointer(
                    absorbing: !isEnabled,
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
                child: Text(controller.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                    Expanded(child: Text(controller.text)),
                    ElevatedButton(
                      onPressed: () {
                        // 우편번호 찾기 기능 구현
                        setState(() {
                          // 예시로 데이터가 불러와지는 것을 가정
                          _addressController.text = "서울특별시 강남구 테헤란로 123";
                          _postalCodeController.text = "12345";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: BUTTON_COLOR,
                        backgroundColor: BACKGROUND_COLOR,
                        side: BorderSide(color: BUTTON_COLOR),
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        textStyle: TextStyle(fontSize: 10),
                      ),
                      child: Text(buttonText, style: TextStyle(fontWeight: FontWeight.bold)),
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
}



class AddressSearchWidget extends ConsumerStatefulWidget {
  @override
  _AddressSearchWidgetState createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends ConsumerState<AddressSearchWidget> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  bool _isFirstLoad = true;

  void _search() {
    setState(() {
      _query = _controller.text;
      _isFirstLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressSearchResult = ref.watch(addressSearchProvider(_query));

    return Column(
      mainAxisSize: MainAxisSize.min, // 부모의 제약 조건을 준수하도록 변경
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: '주소 검색',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: _search,
              ),
            ),
          ),
        ),
        if (_query.isNotEmpty && !_isFirstLoad) // 빈 쿼리와 첫 로드를 처리
          Flexible( // Expanded 대신 Flexible 사용
            child: addressSearchResult.when(
              data: (addresses) => ListView.builder(
                shrinkWrap: true,
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  final roadAddress = address['road_address'];
                  final zoneNo = roadAddress != null ? roadAddress['zone_no'] : '';
                  final fullAddress = roadAddress != null ? roadAddress['address_name'] : address['address_name'];
                  final displayAddress = zoneNo.isNotEmpty ? '$fullAddress [$zoneNo]' : fullAddress;
                  return ListTile(
                    title: Text(displayAddress),
                    onTap: () {
                      Navigator.pop(context, displayAddress);
                    },
                  );
                },
              ),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
      ],
    );
  }
}
