import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import '../repository/message_repository.dart';

// PrivateMessageRepository를 사용하기 위한 인스턴스를 불러오는 프로바이더를 정의.
final privateMessageRepositoryProvider = Provider((ref) => PrivateMessageRepository(firestore: FirebaseFirestore.instance));

// 로그인한 사용자의 이메일 계정을 가져오는 프로바이더 currentUserEmailProvider를 정의.
// FirebaseAuth의 현재 사용자 스트림을 통해 이메일을 반환.
final currentUserEmailProvider = StreamProvider<String?>((ref) async* {
  // FirebaseAuth 인스턴스를 통해 현재 사용자 정보를 가져옴.
  final user = FirebaseAuth.instance.currentUser;
  // 현재 사용자의 이메일을 반환.
  yield user?.email;
});

// 특정 발주번호에 해당하는 결제완료일을 가져오는 함수를 불러와서 사용 가능하도록 하는 paymentCompleteDateProvider
// FutureProvider.family를 사용하여 비동기적으로 데이터(DateTime?)를 제공하는 provider를 생성하며, String 타입의 인자를 받도록 했음.
final paymentCompleteDateProvider = FutureProvider.family<DateTime?, String>((ref, orderNumber) async {
  // 현재 로그인된 사용자의 이메일을 가져오기 위해 currentUserEmailProvider를 호출하고, 그 결과를 기다리도록 했음.
  final email = await ref.watch(currentUserEmailProvider.future);
  // 이메일이 null일 경우(사용자가 로그인되지 않은 경우) null을 반환하여 결제완료일을 가져오지 않도록 했음.
  if (email == null) return null;

  // 결제완료일을 가져오기 위해 privateMessageRepository 인스턴스를 읽어오도록 했음.
  final privateMessageRepository = ref.read(privateMessageRepositoryProvider);
  // privateMessageRepository의 fetchPaymentCompleteDate 함수를 호출하여 결제완료일을 가져오고 반환하도록 했음.
  return privateMessageRepository.fetchPaymentCompleteDate(email, orderNumber);
});

// 특정 발주번호에 해당하는 배송시작일을 가져오는 함수를 불러와서 사용 가능하도록 하는 deliveryStartDateProvider
// FutureProvider.family를 사용하여 orderNumber를 인자로 받아 DateTime? 타입의 비동기 데이터를 제공하는 final deliveryStartDateProvider 변수를 선언
final deliveryStartDateProvider = FutureProvider.family<DateTime?, String>((ref, orderNumber) async {

  // currentUserEmailProvider를 통해 현재 사용자의 이메일을 비동기적으로 가져와 email 변수에 저장.
  final email = await ref.watch(currentUserEmailProvider.future);

  // 이메일이 null이면(즉, 사용자가 로그아웃 상태이거나 이메일이 없는 경우) null을 반환.
  if (email == null) return null;

  // privateMessageRepositoryProvider를 통해 privateMessageRepository 인스턴스를 가져옴.
  final privateMessageRepository = ref.read(privateMessageRepositoryProvider);

  // privateMessageRepository의 fetchDeliveryStartDate 메서드를 호출하여 배송 시작 날짜를 가져오고, 이를 반환.
  return privateMessageRepository.fetchDeliveryStartDate(email, orderNumber);
});

// ----- 발주 내역 상세(관리자) 화면 관련 결제완료일, 배송시작일 데이터를 불러오는 로직 시작 부분
// 특정 발주번호에 해당하는 결제완료일을 선택한 이메일 계정 기준으로 가져오는 Provider
// FutureProvider.family를 사용하여, 이메일과 발주번호를 tuple 형태로 받아 해당 결제완료일 데이터를 DateTime?로 반환
final paymentCompleteDateForSelectedEmailProvider = FutureProvider.family<DateTime?, Tuple2<String, String>>((ref, tuple) async {
  // tuple에 담긴 값들을 각각 선택된 발주자 이메일(selectedUserEmail), 발주번호(orderNumber)에 매핑
  final String selectedUserEmail = tuple.item1;
  final String orderNumber = tuple.item2;

  // 선택한 이메일 계정이나 발주번호가 유효하지 않을 경우 null 처리
  if (selectedUserEmail.isEmpty || orderNumber.isEmpty) {
    return null;
  }

  // privateMessageRepository 인스턴스를 가져옴
  final privateMessageRepository = ref.read(privateMessageRepositoryProvider);

  // 선택한 이메일 계정과 해당 발주번호에 대한 결제완료일을 비동기로 조회
  return privateMessageRepository.fetchPaymentCompleteDate(selectedUserEmail, orderNumber);
});

// 특정 발주번호에 해당하는 배송시작일을 선택한 이메일 계정 기준으로 가져오는 Provider
// FutureProvider.family를 사용하여, 이메일과 발주번호를 tuple 형태로 받아 해당 배송시작일 데이터를 DateTime?로 반환
final deliveryStartDateForSelectedEmailProvider = FutureProvider.family<DateTime?, Tuple2<String, String>>((ref, tuple) async {
  // tuple에 담긴 값들을 각각 선택된 발주자 이메일(selectedUserEmail), 발주번호(orderNumber)에 매핑
  final String selectedUserEmail = tuple.item1;
  final String orderNumber = tuple.item2;

  // 선택한 이메일 계정이나 발주번호가 유효하지 않을 경우 null 처리
  if (selectedUserEmail.isEmpty || orderNumber.isEmpty) {
    return null;
  }

  // privateMessageRepository 인스턴스를 가져옴
  final privateMessageRepository = ref.read(privateMessageRepositoryProvider);

  // 선택한 이메일 계정과 해당 발주번호에 대한 배송시작일을 비동기로 조회
  return privateMessageRepository.fetchDeliveryStartDate(selectedUserEmail, orderNumber);
});

// ----- 발주 내역 상세(관리자) 화면 관련 결제완료일, 배송시작일 데이터를 불러오는 로직 끝 부분
