import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
