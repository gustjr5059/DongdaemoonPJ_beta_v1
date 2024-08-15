/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

//const {onRequest} = require("firebase-functions/v2/https");
//const logger = require("firebase-functions/logger");
//const functions = require('firebase-functions');
//const nodemailer = require('nodemailer');
//const {onCall} = require("firebase-functions/v2/https");

// ------ 파이어베이스 기반 백엔드 로직으로 이메일 전송 기능 구현한 내용 시작 부분
const functions = require('firebase-functions'); // Firebase Functions 모듈을 불러옴.
const admin = require('firebase-admin'); // Firebase Admin SDK 모듈을 불러옴.
const nodemailer = require('nodemailer'); // Nodemailer 모듈을 불러옴.

admin.initializeApp(); // Firebase Admin SDK를 초기화함.

// Gmail 설정 가져오기
const gmailEmail = functions.config().gmail.email; // Firebase Functions 설정에서 Gmail 이메일 주소를 가져옴.
const gmailPassword = functions.config().gmail.password; // Firebase Functions 설정에서 Gmail 비밀번호를 가져옴.
const mailTransport = nodemailer.createTransport({ // Nodemailer를 사용하여 이메일 전송을 위한 트랜스포트를 생성함.
  service: 'gmail', // 이메일 서비스로 Gmail을 사용함.
  auth: {
    user: gmailEmail, // Gmail 이메일 주소를 인증 정보로 사용함.
    pass: gmailPassword, // Gmail 비밀번호를 인증 정보로 사용함.
  },
});

// 숫자 포맷 함수
function formatNumber(number) { // 숫자를 포맷팅하는 함수.
  return new Intl.NumberFormat('ko-KR').format(number); // 한국어 형식으로 숫자를 포맷팅함.
}

// Firestore 문서 생성 시 이메일 발송 함수
exports.sendOrderEmailV2 = functions.firestore
  .document('order_list/{userId}/orders/{orderId}') // Firestore의 order_list/{userId}/orders/{orderId} 문서 생성 시 트리거됨.
  .onCreate(async (snap, context) => { // 문서 생성 이벤트 핸들러를 비동기로 정의.
    const userId = context.params.userId; // URL 파라미터에서 userId를 가져옴.
    const orderId = context.params.orderId; // URL 파라미터에서 orderId를 가져옴.

    const ordererInfoDoc = await admin.firestore().collection('order_list').doc(userId).collection('orders').doc(orderId).collection('orderer_info').doc('info').get();
    // Firestore에서 orderer_info 컬렉션의 info 문서를 가져옴.
    const recipientInfoDoc = await admin.firestore().collection('order_list').doc(userId).collection('orders').doc(orderId).collection('recipient_info').doc('info').get();
    // Firestore에서 recipient_info 컬렉션의 info 문서를 가져옴.
    const amountInfoDoc = await admin.firestore().collection('order_list').doc(userId).collection('orders').doc(orderId).collection('amount_info').doc('info').get();
    // Firestore에서 amount_info 컬렉션의 info 문서를 가져옴.
    const numberInfoDoc = await admin.firestore().collection('order_list').doc(userId).collection('orders').doc(orderId).collection('number_info').doc('info').get();
    // Firestore에서 number_info 컬렉션의 info 문서를 가져옴.
    const productInfoQuery = await admin.firestore().collection('order_list').doc(userId).collection('orders').doc(orderId).collection('product_info').get();
    // Firestore에서 product_info 컬렉션의 모든 문서를 가져옴.

    if (!ordererInfoDoc.exists || !recipientInfoDoc.exists || !amountInfoDoc.exists || !numberInfoDoc.exists) {
      // 필요한 정보가 하나라도 없을 경우 로그를 출력하고 함수를 종료함.
      console.log('Missing order information.');
      return null;
    }

    const ordererInfo = ordererInfoDoc.data(); // 주문자 정보를 가져옴.
    const recipientInfo = recipientInfoDoc.data(); // 수령자 정보를 가져옴.
    const amountInfo = amountInfoDoc.data(); // 금액 정보를 가져옴.
    const numberInfo = numberInfoDoc.data(); // 주문 번호 정보를 가져옴.
    const productInfo = productInfoQuery.docs.map(doc => doc.data()); // 상품 정보를 배열로 가져옴.

    const mailOptions = { // 이메일 옵션을 설정함.
      from: gmailEmail, // 발신자 이메일 주소를 설정함.
      to: 'stonehead0627@gmail.com', // 수신자 이메일 주소를 설정함.
      subject: `신규 발주 내역: [${numberInfo.order_number}] ${ordererInfo.email}`, // 이메일 제목을 설정함.
      html: generateOrderEmailBody(ordererInfo, recipientInfo, amountInfo, productInfo, numberInfo.order_number) // 이메일 본문을 설정함.
    };

    try {
      await mailTransport.sendMail(mailOptions); // 이메일을 전송함.
      console.log('Email sent successfully'); // 이메일 전송 성공 메시지를 로그에 출력함.
    } catch (error) {
      console.error('Error sending email:', error); // 이메일 전송 실패 메시지를 로그에 출력함.
    }

    return null; // 함수 종료를 명시함.
  });

// 이메일 본문 생성 함수
function generateOrderEmailBody(ordererInfo, recipientInfo, amountInfo, productInfo, orderNumber) {
  // 이메일 본문을 생성하는 함수.
  let body = `<html><body>`;
  body += `<h2>발주자 정보</h2>`;
  body += `<table border="1" cellpadding="5" cellspacing="0">`;
  body += `<tr><td><b>이름</b></td><td>${ordererInfo.name}</td></tr>`;
  body += `<tr><td><b>이메일</b></td><td>${ordererInfo.email}</td></tr>`;
  body += `<tr><td><b>휴대폰 번호</b></td><td>${ordererInfo.phone_number}</td></tr>`;
  body += `</table><br>`;

  body += `<h2>수령자 정보</h2>`;
  body += `<table border="1" cellpadding="5" cellspacing="0">`;
  body += `<tr><td><b>이름</b></td><td>${recipientInfo.name}</td></tr>`;
  body += `<tr><td><b>휴대폰 번호</b></td><td>${recipientInfo.phone_number}</td></tr>`;
  body += `<tr><td><b>우편번호</b></td><td>${recipientInfo.postal_code}</td></tr>`;
  body += `<tr><td><b>주소</b></td><td>${recipientInfo.address}</td></tr>`;
  body += `<tr><td><b>상세 주소</b></td><td>${recipientInfo.detail_address}</td></tr>`;
  body += `<tr><td><b>메모</b></td><td>${recipientInfo.memo}</td></tr>`;
  body += `<tr><td><b>추가 메모</b></td><td>${recipientInfo.extra_memo}</td></tr>`;
  body += `</table><br>`;

  body += `<h2>금액 정보</h2>`;
  body += `<table border="1" cellpadding="5" cellspacing="0">`;
  body += `<tr><td><b>총 상품금액</b></td><td>${formatNumber(amountInfo.total_product_price)}원</td></tr>`;
  body += `<tr><td><b>상품 할인금액</b></td><td>${formatNumber(amountInfo.product_discount_price)}원</td></tr>`;
  body += `<tr><td><b>총 결제금액</b></td><td>${formatNumber(amountInfo.total_payment_price)}원</td></tr>`;
  body += `</table><br>`;

  body += `<h2>상품 정보</h2>`;
  productInfo.forEach(item => {
    body += `<table border="1" cellpadding="5" cellspacing="0">`;
    body += `<tr><td><b>상품</b></td><td>${item.brief_introduction}</td></tr>`;
    body += `<tr><td><b>상품 번호</b></td><td>${item.product_number}</td></tr>`;
    body += `<tr><td><b>원래 가격</b></td><td>${formatNumber(item.original_price)}원</td></tr>`;
    body += `<tr><td><b>할인 가격</b></td><td>${formatNumber(item.discount_price)}원</td></tr>`;
    body += `<tr><td><b>할인 퍼센트</b></td><td>${item.discount_percent}%</td></tr>`;
    body += `<tr><td><b>선택한 수량</b></td><td>${item.selected_count}개</td></tr>`;
    body += `<tr><td><b>선택한 색상</b></td><td>${item.selected_color_text}</td></tr>`;
    body += `<tr><td><b>선택한 사이즈</b></td><td>${item.selected_size}</td></tr>`;
    body += `</table><br>`;
  });

  body += `</body></html>`;
  return body;
}
// ------ 파이어베이스 기반 백엔드 로직으로 이메일 전송 기능 구현한 내용 끝 부분

// ------ "배송 중 메세지" 발송 후 3일 후에 발주 상태를 업데이트하는 함수 내용 시작 부분
// Firestore에 새로운 문서가 생성될 때, 특정 "배송 중 메세지"를 감지하고 발주 상태를 자동으로 업데이트
exports.orderlistOrderStatusAutoUpdate = functions.firestore
  .document('message_list/{recipientId}/message/{messageId}')  // message_list 컬렉션 안의 특정 recipientId와 messageId에 해당하는 문서 경로를 지정
  .onCreate(async (snap, context) => {  // 지정된 경로에 문서가 생성될 때 트리거되는 이벤트 리스너 함수 정의
    const messageData = snap.data();  // 생성된 문서의 데이터를 가져옴

    // 메세지 내용이 "해당 발주 건은 배송이 진행되었습니다."인 경우에만 상태 업데이트 예약
    if (messageData.contents === '해당 발주 건은 배송이 진행되었습니다.') {
      const recipientId = context.params.recipientId;  // 문서 경로에서 recipientId를 가져옴
      const order_number = messageData.order_number;  // 메세지 데이터에서 order_number를 가져옴

      // 3일 후 상태를 "배송 완료"로 업데이트
      const daysToMilliseconds = 3 * 24 * 60 * 60 * 1000; // 3일을 밀리초로 변환 (3일 x 24시간 x 60분 x 60초 x 1000ms)
//      const daysToMilliseconds = 30000; // 3일을 밀리초로 변환 (3일 x 24시간 x 60분 x 60초 x 1000ms)
      setTimeout(async () => {  // setTimeout을 사용하여 3일 후에 실행되도록 설정
        try {
          const orderDocRef = admin.firestore()  // Firestore에 접근하기 위한 참조 생성
            .collection('order_list')  // order_list 컬렉션 참조
            .doc(recipientId)  // recipientId에 해당하는 문서 참조
            .collection('orders')  // orders 하위 컬렉션 참조
            .where('numberInfo.order_number', '==', order_number);  // order_number가 해당 order_number와 일치하는 문서를 찾기 위한 쿼리

          const orderDocSnapshot = await orderDocRef.get();  // 쿼리 실행 결과 가져오기
          if (!orderDocSnapshot.empty) {  // 쿼리 결과가 비어 있지 않은 경우
            const orderDoc = orderDocSnapshot.docs[0];  // 첫 번째 결과 문서를 가져옴
            await orderDoc.ref.collection('order_status_info').doc('info').update({  // 해당 문서의 order_status_info 하위 컬렉션의 info 문서를 업데이트
              'order_status': '배송 완료'  // order_status 필드를 "배송 완료"로 업데이트
            });
            console.log(`Order ${order_number} status updated to 배송 완료`);  // 상태 업데이트 성공 시 콘솔에 로그 출력
          }
        } catch (error) {  // 에러 발생 시 에러 처리
          console.error('Error updating order status:', error);  // 에러 내용을 콘솔에 출력
        }
      }, daysToMilliseconds);  // 3일 후에 실행되도록 설정
    }
  });
// ------ 메시지 발송 후 3일 후에 발주 상태를 업데이트하는 함수 내용 끝 부분

// ------ Firestore에서 '배송 중 메세지' 메시지가 생성될 때 버튼 상태를 업데이트하는 함수 내용 시작 부분
exports.updateButtonStatusOnMessage = functions.firestore
    .document('message_list/{recipientId}/message/{messageId}')
    .onCreate(async (snap, context) => {
        const messageData = snap.data();

        if (messageData.contents === '해당 발주 건은 배송이 진행되었습니다.') {
            const recipientId = context.params.recipientId;
            const orderNumber = messageData.order_number;
            const messageSendingTime = messageData.message_sendingTime.toDate(); // message_sendingTime을 Date 객체로 변환
            const currentTime = new Date();

            // 메시지 생성 시간과 현재 시간을 비교 (예: 1분 이내의 메시지만 버튼 활성화)
            if (currentTime - messageSendingTime <= 60000) { // 1분 이내
                const ordersSnapshot = await admin.firestore()
                    .collection('order_list')
                    .doc(recipientId)
                    .collection('orders')
                    .where('numberInfo.order_number', '==', orderNumber)
                    .get();

                if (!ordersSnapshot.empty) {
                    const orderDoc = ordersSnapshot.docs[0];
                    const buttonInfoRef = orderDoc.ref.collection('button_info').doc('info');

                    // 버튼 활성화 상태로 업데이트
                    await buttonInfoRef.update({
                        'boolRefundBtn': true,
                        'boolReviewBtn': true,
                    });

                    // 추가적인 조건에 따라 버튼 비활성화
                    setTimeout(async () => {
                        await buttonInfoRef.update({
                            'boolRefundBtn': false,
                            'boolReviewBtn': false,
                        });
                    }, 60000); // 1분 후 비활성화
                }
            }
        }
    });
// ------ Firestore에서 '배송 중 메세지' 메시지가 생성될 때 버튼 상태를 업데이트하는 함수 내용 끝 부분