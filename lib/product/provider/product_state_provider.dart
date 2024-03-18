
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/provider/common_future_provider.dart';

// 색상 선택을 위한 상태 관리용 StateProvider
final colorSelectionIndexProvider = StateProvider<int?>((ref) => null);
// 사이즈 선택을 위한 상태 관리용 StateProvider
// 선택된 사이즈의 이름과 가격 정보를 모두 포함하도록 Map 형태로 변경합니다.
final sizeSelectionProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

// 선택된 수량을 관리하기 위한 StateProvider
final quantityProvider = StateProvider<int>((ref) => 1);

final totalPriceProvider = StateProvider.family<int, String>((ref, docId) {
  // Firestore에서 데이터를 로드합니다.
  final docDataAsyncValue = ref.watch(firestoreDataProvider(docId));
  // AsyncValue의 상태에 따라 다른 로직을 처리합니다.
  return docDataAsyncValue.when(
    data: (snapshot) {
      // snapshot.data() 호출 결과를 Map<String, dynamic> 타입으로 캐스팅합니다.
      final data = snapshot.data() as Map<String, dynamic>?;
      // 로그 출력으로 데이터 확인
      print("Firestore Data: $data");
      // String에서 double로 변환을 시도하고, 실패할 경우 0으로 처리합니다.
      final discountPrice = double.tryParse(data?['discount_price']?.toString() ?? '0')?.toInt() ?? 0;
      final quantity = ref.watch(quantityProvider);
      // 할인된 가격과 수량을 곱하여 총 결제 금액을 계산합니다.
      final totalPrice = discountPrice * quantity;
      // 로그 출력으로 최종 가격 확인
      print("Total Price: $totalPrice");
      return totalPrice;
    },
    loading: () => 0,  // 로딩 중이라면 0을 반환합니다.
    error: (_, __) => 0, // 에러가 발생했다면 0을 반환합니다.
  );
});



