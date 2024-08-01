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
    body += `<tr><td><b>상품</b></td><td>${item.briefIntroduction}</td></tr>`;
    body += `<tr><td><b>상품 번호</b></td><td>${item.productNumber}</td></tr>`;
    body += `<tr><td><b>원래 가격</b></td><td>${formatNumber(item.originalPrice)}원</td></tr>`;
    body += `<tr><td><b>할인 가격</b></td><td>${formatNumber(item.discountPrice)}원</td></tr>`;
    body += `<tr><td><b>할인 퍼센트</b></td><td>${item.discountPercent}%</td></tr>`;
    body += `<tr><td><b>선택한 수량</b></td><td>${item.selectedCount}개</td></tr>`;
    body += `<tr><td><b>선택한 색상</b></td><td>${item.selectedColorText}</td></tr>`;
    body += `<tr><td><b>선택한 사이즈</b></td><td>${item.selectedSize}</td></tr>`;
    body += `</table><br>`;
  });

  body += `</body></html>`;
  return body;
}
// ------ 파이어베이스 기반 백엔드 로직으로 이메일 전송 기능 구현한 내용 끝 부분

