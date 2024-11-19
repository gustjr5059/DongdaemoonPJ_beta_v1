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
//const serviceAccount = require('./wearcano-firebase-adminsdk-file.json'); // Firebase Admin 인증 파일 불러옴.
//
//// Firebase Admin SDK 초기화
//admin.initializeApp({
//  credential: admin.credential.cert(serviceAccount), // 서비스 계정 인증을 사용하여 Firebase 초기화
////  databaseURL: "https://your-firebase-database-url.firebaseio.com" // Firebase 실시간 데이터베이스 URL
//// 해당 설정은 Firebase Realtime Database를 사용하는 경우에 추가해야하는 코드!!
//});

// **Firebase Admin SDK 초기화**
admin.initializeApp(); // 기본 초기화

const firestore = admin.firestore();
const fcm = admin.messaging(); // FCM(Firebase Cloud Messaging)을 사용하기 위한 설정


//admin.initializeApp(); // Firebase Admin SDK를 초기화함.

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
exports.sendOrderEmail = functions.region('asia-northeast3').firestore
  .document('order_list/{userId}/orders/{order_number}') // Firestore의 order_list/{userId}/orders/{order_number} 문서 생성 시 트리거됨.
  .onCreate(async (snap, context) => { // 문서 생성 이벤트 핸들러를 비동기로 정의.
    const userId = context.params.userId; // URL 파라미터에서 userId를 가져옴.
    const orderNumber = context.params.order_number; // URL 파라미터에서 order_number를 가져옴.

    const ordererInfoDoc = await admin.firestore().collection('order_list').doc(userId).collection('orders').doc(orderNumber).collection('orderer_info').doc('info').get();
    // Firestore에서 orderer_info 컬렉션의 info 문서를 가져옴.
    const recipientInfoDoc = await admin.firestore().collection('order_list').doc(userId).collection('orders').doc(orderNumber).collection('recipient_info').doc('info').get();
    // Firestore에서 recipient_info 컬렉션의 info 문서를 가져옴.
    const amountInfoDoc = await admin.firestore().collection('order_list').doc(userId).collection('orders').doc(orderNumber).collection('amount_info').doc('info').get();
    // Firestore에서 amount_info 컬렉션의 info 문서를 가져옴.
    const numberInfoDoc = await admin.firestore().collection('order_list').doc(userId).collection('orders').doc(orderNumber).collection('number_info').doc('info').get();
    // Firestore에서 number_info 컬렉션의 info 문서를 가져옴.
    const productInfoQuery = await admin.firestore().collection('order_list').doc(userId).collection('orders').doc(orderNumber).collection('product_info').get();
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
      console.log('성공적으로 이메일 전송이 되었습니다.'); // 이메일 전송 성공 메시지를 로그에 출력함.
    } catch (error) {
      console.error('이메일 전송에 실패했습니다.:', error); // 이메일 전송 실패 메시지를 로그에 출력함.
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
  body += `<tr><td><b>선택된 배송비</b></td><td>${formatNumber(amountInfo.delivery_fee)}원</td></tr>`;
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

// ------ FCM 알림 전송 기능 구현 내용 시작 ------

// Firestore에서 읽지 않은 메시지의 개수 계산
async function getUnreadMessagesCount(recipientId) {
  try {
    const unreadMessagesSnapshot = await firestore
      .collection('message_list')
      .doc(recipientId)
      .collection('message')
      .where('read', '==', false)  // 읽지 않은 메시지만 필터링
      .get();

    console.log(`읽지 않은 메시지 개수 계산 성공: ${unreadMessagesSnapshot.size}`);
    return unreadMessagesSnapshot.size;
  } catch (error) {
    console.error('읽지 않은 메시지 개수 계산 중 오류 발생:', error);
    return 0;
  }
}

//// 새로운 Firestore 문서가 생성되면 알림을 수신자에게 전송하는 함수
//exports.sendMessageWithNotification = functions.firestore
//  .document('message_list/{recipientId}/message/{messageId}') // message_list/{recipientId}/message/{messageId} 경로에서 문서 생성 시 트리거
//  .onCreate(async (snap, context) => {
//    const messageData = snap.data();
//    const recipientId = context.params.recipientId;
//    const orderNumber = messageData.order_number;
//
//    try {
//      console.log(`메시지 생성: recipientId: ${recipientId}, messageId: ${context.params.messageId}`);
//      // 수신자의 FCM 토큰 배열 가져오기
//      const recipientSnapshot = await firestore.collection('users').doc(recipientId).get();
//      const recipientData = recipientSnapshot.data();
//      console.log(`수신자 데이터: ${JSON.stringify(recipientData)}`);
//      const recipientFcmTokens = recipientData.fcmTokens; // 수신자의 모든 FCM 토큰 배열
//
//      if (!recipientFcmTokens || recipientFcmTokens.length === 0) {
//        console.error(`FCM 토큰이 없습니다: recipientId: ${recipientId}`);
//        return;
//      }
//
//      console.log(`수신자의 FCM 토큰 개수: ${recipientFcmTokens.length}`);
//
//      // 읽지 않은 메시지 개수 계산
//      const unreadCount = await getUnreadMessagesCount(recipientId);
//
//      // FCM 메시지를 각각의 토큰에 맞게 생성
//      const messages = recipientFcmTokens.map(token => ({
//        notification: {
//          title: '새로운 쪽지가 도착했습니다',  // 알림 제목
//          body: `${messageData.contents}`,        // 알림 내용
//        },
//        data: {
//          screen: 'PrivateMessageMainScreen',      // 알림 클릭 시 이동할 화면
//          messageId: context.params.messageId,     // 메시지 ID
//          recipientId: context.params.recipientId, // 수신자 ID
//        },
//        token: token, // 각 토큰에 맞는 메시지를 설정
//
//        // Android 알림 설정
//        android: {
//          notification: {
//            sound: 'default',                      // Android 기기에서 사용할 소리
//          }
//        },
//
//        // iOS 알림 설정
//        apns: {
//          payload: {
//            aps: {
//              sound: 'default',                     // iOS 기기에서 사용할 소리
//              badge: unreadCount,                   // iOS에서 배지 숫자 설정
//            }
//          }
//        }
//      }));
//
////      // 각 메시지의 크기를 확인
////      messages.forEach((message, idx) => {
////        const jsonString = JSON.stringify(message);
////        const byteSize = Buffer.byteLength(jsonString, 'utf8');
////        console.log(`FCM 메시지 크기 (토큰 ${idx + 1}): ${byteSize} 바이트`);
////        if (byteSize > 4096) {
////          console.warn(`경고: FCM 메시지 크기가 4096 바이트를 초과합니다 (크기: ${byteSize} 바이트).`);
////        }
////      });
//
//      // 모든 FCM 메시지를 한 번에 전송
//      const response = await fcm.sendAll(messages);
//
//      // 실패한 메시지 처리
//      response.responses.forEach((res, idx) => {
//        if (!res.success) {
//          console.error(`토큰 ${recipientFcmTokens[idx]}로 메시지 전송 실패: ${res.error.message}`);
//
//          // 토큰이 유효하지 않으면 Firestore에서 해당 토큰 삭제
//          if (res.error.code === 'messaging/registration-token-not-registered') {
//            console.log(`유효하지 않은 FCM 토큰 삭제: ${recipientFcmTokens[idx]}`);
//            // Firestore에서 해당 토큰 삭제하는 로직 추가
//            const tokenToRemove = recipientFcmTokens[idx];
//            firestore.collection('users').doc(recipientId).update({
//              fcmTokens: admin.firestore.FieldValue.arrayRemove(tokenToRemove)
//            });
//          }
//        }
//      });
//
//      console.log(`알림 전송 성공: ${response.successCount}개의 메시지가 성공적으로 전송됨`);
//      console.log(`알림 전송 실패: ${response.failureCount}개의 메시지 전송 실패`);
//
//    } catch (error) {
//      console.error('알림 전송 중 오류 발생:', error);
//    }
//  });

exports.sendMessageWithNotification = functions.region('asia-northeast3').firestore
  .document('message_list/{recipientId}/message/{messageId}')
  .onCreate(async (snap, context) => {
    const messageData = snap.data();
    const recipientId = context.params.recipientId;

    console.log('FCM 알림 전송 시작'); // 디버그 메시지
    console.log(`수신자 ID: ${recipientId}`);
    console.log(`메시지 데이터: ${JSON.stringify(messageData)}`);

    // 수신자의 FCM 토큰 획득
    const recipientSnapshot = await admin.firestore().collection('users').doc(recipientId).get();
    const recipientData = recipientSnapshot.data();
    const recipientFcmTokens = recipientData.fcmTokens;

    if (!recipientFcmTokens || recipientFcmTokens.length === 0) {
      console.log('수신자에게 FCM 토큰이 없습니다.');
      return;
    }

    console.log(`수신자 FCM 토큰 수: ${recipientFcmTokens.length}`);

    // FCM 메시지 생성
    const message = {
      tokens: recipientFcmTokens,
      notification: {
        title: '새로운 쪽지가 도착했습니다',
        body: messageData.contents,
      },
      data: {
        screen: 'PrivateMessageMainScreen',
        messageId: context.params.messageId,
        recipientId: recipientId,
      },
    };

    console.log('FCM 메시지 생성 완료');

    // FCM 알림 발송
    try {
      const response = await fcm.sendMulticast(message);
      console.log(`FCM 메시지 전송 성공: ${response.successCount}개, 실패: ${response.failureCount}개`);
      if (response.failureCount > 0) {
        await Promise.all(
          response.responses.map(async (resp, idx) => {
            if (!resp.success) {
              console.error(`토큰(${recipientFcmTokens[idx]})으로 메시지 전송 실패: ${resp.error}`);
              // 유효하지 않은 토큰은 Firestore에서 제거
              if (resp.error.code === 'messaging/registration-token-not-registered') {
                await firestore.collection('users').doc(recipientId).update({
                  fcmTokens: admin.firestore.FieldValue.arrayRemove(recipientFcmTokens[idx])
                });
                console.log(`유효하지 않은 토큰 삭제: ${recipientFcmTokens[idx]}`);
              }
            }
          })
        );
      }
    } catch (error) {
      console.error('FCM 메시지 전송 중 오류 발생:', error);
    }
  });



//      // FCM 메시지 작성
//      const payload = {
////        notification: {
////          title: '새로운 쪽지가 도착했습니다',  // 알림 제목
////          body: `${messageData.contents}`,        // 알림 내용
////          sound: 'default',                      // 알림 소리 (기본 소리 사용)
////          badge: unreadCount.toString(),         // 앱 아이콘에 표시될 배지 숫자
////        },
//          data: {
//            title: '새로운 쪽지가 도착했습니다',  // 알림 제목
//            body: `${messageData.contents}`,        // 알림 내용
//            sound: 'default',                      // 알림 소리 (기본 소리 사용)
//            badge: unreadCount.toString(),         // 앱 아이콘에 표시될 배지 숫자
//            screen: 'PrivateMessageMainScreen',      // 알림 클릭 시 이동할 화면 지정
//            messageId: context.params.messageId,     // 메시지 ID
//            recipientId: context.params.recipientId, // 수신자 ID
//            orderNumber: orderNumber,                // 주문 번호 추가 (추가된 데이터)
//          }
////        android: {  // Android 기기용 설정
////          priority: 'high',                      // Android 기기의 경우 즉시 전송
////        }
//      };
//
////      // 수신자의 모든 FCM 토큰으로 메시지 전송
////      if (recipientFcmTokens && recipientFcmTokens.length > 0) {
////        await fcm.sendToDevice(recipientFcmTokens, payload);
////        console.log(`알림이 ${recipientFcmTokens.length}개의 기기에 성공적으로 전송되었습니다.`);
////      } else {
////        console.log(`수신자 ${recipientId}의 FCM 토큰을 찾을 수 없습니다.`);
////      }
////    } catch (error) {
////      console.error('알림 전송 중 오류 발생:', error);
////    }
//
//      const response = await fcm.sendToDevice(recipientFcmTokens, payload);
//      console.log(`알림 전송 성공: ${JSON.stringify(response.results)}`);
//
//    } catch (error) {
//      console.error('알림 전송 중 오류 발생:', error);
//    }
//  });
// ------ FCM 알림 전송 기능 구현 내용 끝 ------

// ------ "배송 중 메세지" 발송 후 3일 후에 발주 상태를 업데이트하는 함수 내용 시작 부분
// Firestore에 새로운 문서가 생성될 때, 특정 "배송 중 메세지"를 감지하고 발주 상태를 자동으로 업데이트
exports.orderlistOrderStatusAutoUpdate = functions.region('asia-northeast3').firestore
  .document('message_list/{recipientId}/message/{messageId}')  // message_list 컬렉션 안의 특정 recipientId와 messageId에 해당하는 문서 경로를 지정
  .onCreate(async (snap, context) => {  // 지정된 경로에 문서가 생성될 때 트리거되는 이벤트 리스너 함수 정의
    const messageData = snap.data();  // 생성된 문서의 데이터를 가져옴

    // 메세지 내용이 "해당 발주 건은 배송이 진행되었습니다."인 경우에만 상태 업데이트 예약
    if (messageData.contents === '해당 발주 건은 배송이 진행되었습니다.') {
      const recipientId = context.params.recipientId;  // 문서 경로에서 recipientId를 가져옴
      const orderNumber = messageData.order_number;  // 메세지 데이터에서 order_number를 가져옴

      // 3일 후 상태를 "배송 완료"로 업데이트
      const daysToMilliseconds = 3 * 24 * 60 * 60 * 1000; // 3일을 밀리초로 변환 (3일 x 24시간 x 60분 x 60초 x 1000ms)
//      const daysToMilliseconds = 30000; // 3일을 밀리초로 변환 (3일 x 24시간 x 60분 x 60초 x 1000ms)
      setTimeout(async () => {  // setTimeout을 사용하여 3일 후에 실행되도록 설정
        try {
          const orderDocRef = admin.firestore()  // Firestore에 접근하기 위한 참조 생성
            .collection('order_list')  // order_list 컬렉션 참조
            .doc(recipientId)  // recipientId에 해당하는 문서 참조
            .collection('orders')  // orders 하위 컬렉션 참조
            .where('numberInfo.order_number', '==', orderNumber);  // order_number가 해당 order_number와 일치하는 문서를 찾기 위한 쿼리

          const orderDocSnapshot = await orderDocRef.get();  // 쿼리 실행 결과 가져오기
          if (!orderDocSnapshot.empty) {  // 쿼리 결과가 비어 있지 않은 경우
            const orderDoc = orderDocSnapshot.docs[0];  // 첫 번째 결과 문서를 가져옴
            await orderDoc.ref.collection('order_status_info').doc('info').update({  // 해당 문서의 order_status_info 하위 컬렉션의 info 문서를 업데이트
              'order_status': '배송 완료'  // order_status 필드를 "배송 완료"로 업데이트
            });
            console.log(`Order ${orderNumber} status updated to 배송 완료`);  // 상태 업데이트 성공 시 콘솔에 로그 출력
          }
        } catch (error) {  // 에러 발생 시 에러 처리
          console.error('Error updating order status:', error);  // 에러 내용을 콘솔에 출력
        }
      }, daysToMilliseconds);  // 3일 후에 실행되도록 설정
    }
  });
// ------ 메시지 발송 후 3일 후에 발주 상태를 업데이트하는 함수 내용 끝 부분

// ------ Firestore에서 '배송 중 메세지' 메시지가 생성될 때 버튼 상태를 업데이트하는 함수 내용 시작 부분
exports.updateButtonStatusOnMessage = functions.region('asia-northeast3').firestore
    .document('message_list/{recipientId}/message/{messageId}')
    .onCreate(async (snap, context) => {
        const messageData = snap.data();

        if (messageData.contents === '해당 발주 건은 배송이 진행되었습니다.') {
            const recipientId = context.params.recipientId;
            const orderNumber = messageData.order_number;
            const messageSendingTime = messageData.message_sendingTime.toDate(); // message_sendingTime을 Date 객체로 변환
            const currentTime = new Date();

            // 메시지 생성 시간과 현재 시간을 비교 (예: 10일 이내의 메시지만 버튼 활성화)
            if (currentTime - messageSendingTime <= 864000000) { // (10일 = 10 * 24 * 60 * 60 * 1000밀리초)
                const ordersSnapshot = await admin.firestore()
                    .collection('order_list')
                    .doc(recipientId)
                    .collection('orders')
                    .where('numberInfo.order_number', '==', orderNumber)
                    .get();

                if (!ordersSnapshot.empty) {
                    const orderDoc = ordersSnapshot.docs[0];
                    const buttonInfoRef = orderDoc.ref.collection('button_info').doc('info');
                    const productInfoRef = orderDoc.ref.collection('product_info');

                    // 버튼 활성화 상태로 업데이트
                    await buttonInfoRef.update({
                        'boolRefundBtn': true,
                        'boolReviewWriteBtn': true,
                    });

                    // 추가적인 조건에 따라 버튼 비활성화
                    setTimeout(async () => {
                        await buttonInfoRef.update({
                            'boolRefundBtn': false,
                            'boolReviewWriteBtn': false,
                        });

                        // product_info 하위 컬렉션의 모든 문서에서 'boolReviewCompleteBtn' 필드를 true로 업데이트
                        const productDocs = await productInfoRef.get();
                        productDocs.forEach(async (doc) => {
                            await doc.ref.update({
                                'boolReviewCompleteBtn': true,
                            });
                        });

                    }, 864000000); // 10일(10일 = 10 * 24 * 60 * 60 * 1000밀리초) 후 비활성화 864000000
                }
            }
        }
    });
// ------ Firestore에서 '배송 중 메세지' 메시지가 생성될 때 버튼 상태를 업데이트하는 함수 내용 끝 부분

// ------ Firestore에서 '환불 메세지' 메시지가 생성될 때 버튼 상태를 업데이트하는 함수 내용 시작 부분
exports.updateButtonStatusOnRefundMessage = functions.region('asia-northeast3').firestore
    .document('message_list/{recipientId}/message/{messageId}')
    .onCreate(async (snap, context) => {
        const messageData = snap.data();
        // Firestore의 새 문서가 생성되었을 때 실행되는 함수임. 생성된 문서의 데이터를 가져옴.

        if (messageData.contents === '해당 발주 건은 환불 처리 되었습니다.') {
            const recipientId = context.params.recipientId;
            const orderNumber = messageData.order_number;
            const selectedSeparatorKey = messageData.selected_separator_key;
            // 메시지의 내용이 특정 문구와 일치할 경우 실행됨. 메시지에 포함된 수신자 ID, 주문 번호, 선택된 separator_key를 가져옴.

            const ordersSnapshot = await admin.firestore()
                .collection('order_list')
                .doc(recipientId)
                .collection('orders')
                .where('numberInfo.order_number', '==', orderNumber)
                .get();
            // Firestore에서 해당 수신자 ID의 주문 목록을 가져옴. 주문 번호와 일치하는 주문을 조회함.

            if (!ordersSnapshot.empty) {
                const orderDoc = ordersSnapshot.docs[0];
                const productInfoRef = orderDoc.ref.collection('product_info');
                // 주문이 존재할 경우 해당 주문 문서를 가져오고, 그 주문의 product_info 하위 컬렉션을 참조함.

                const productDocs = await productInfoRef.where('separator_key', '==', selectedSeparatorKey).get();
                // 선택된 separator_key와 일치하는 product_info 문서를 조회함.

                if (!productDocs.empty) {
                    const productDoc = productDocs.docs[0];
                    await productDoc.ref.update({
                        'boolRefundCompleteBtn': true,
                    });
                    // 일치하는 문서가 존재하면, 해당 문서의 'boolRefundCompleteBtn' 필드를 'true'로 업데이트함.
                }
            }
        }
    });
// ------ Firestore에서 '환불 메세지' 메시지가 생성될 때 버튼 상태를 업데이트하는 함수 내용 끝 부분

// Firestore 문서 생성 시 이메일 발송 함수
exports.sendOrderEmailV2 = functions.region('asia-northeast3').firestore
  .document('wearcano_order_list/{userId}/orders/{order_number}') // Firestore의 order_list/{userId}/orders/{order_number} 문서 생성 시 트리거됨.
  .onCreate(async (snap, context) => { // 문서 생성 이벤트 핸들러를 비동기로 정의.
    const userId = context.params.userId; // URL 파라미터에서 userId를 가져옴.
    const orderNumber = context.params.order_number; // URL 파라미터에서 order_number를 가져옴.

    const ordererInfoDoc = await admin.firestore().collection('wearcano_order_list').doc(userId).collection('orders').doc(orderNumber).collection('orderer_info').doc('info').get();
    // Firestore에서 orderer_info 컬렉션의 info 문서를 가져옴.
    const recipientInfoDoc = await admin.firestore().collection('wearcano_order_list').doc(userId).collection('orders').doc(orderNumber).collection('recipient_info').doc('info').get();
    // Firestore에서 recipient_info 컬렉션의 info 문서를 가져옴.
    const amountInfoDoc = await admin.firestore().collection('wearcano_order_list').doc(userId).collection('orders').doc(orderNumber).collection('amount_info').doc('info').get();
    // Firestore에서 amount_info 컬렉션의 info 문서를 가져옴.
    const numberInfoDoc = await admin.firestore().collection('wearcano_order_list').doc(userId).collection('orders').doc(orderNumber).collection('number_info').doc('info').get();
    // Firestore에서 number_info 컬렉션의 info 문서를 가져옴.
    const productInfoQuery = await admin.firestore().collection('wearcano_order_list').doc(userId).collection('orders').doc(orderNumber).collection('product_info').get();
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
      console.log('성공적으로 이메일 전송이 되었습니다.'); // 이메일 전송 성공 메시지를 로그에 출력함.
    } catch (error) {
      console.error('이메일 전송에 실패했습니다.:', error); // 이메일 전송 실패 메시지를 로그에 출력함.
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
  body += `<tr><td><b>선택된 배송비</b></td><td>${formatNumber(amountInfo.delivery_fee)}원</td></tr>`;
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
exports.orderlistOrderStatusAutoUpdate_V2 = functions.region('asia-northeast3').firestore
  .document('wearcano_message_list/{recipientId}/message/{messageId}')  // message_list 컬렉션 안의 특정 recipientId와 messageId에 해당하는 문서 경로를 지정
  .onCreate(async (snap, context) => {  // 지정된 경로에 문서가 생성될 때 트리거되는 이벤트 리스너 함수 정의
    const messageData = snap.data();  // 생성된 문서의 데이터를 가져옴

    // 메세지 내용이 "해당 발주 건은 배송이 진행되었습니다."인 경우에만 상태 업데이트 예약
    if (messageData.contents === '해당 발주 건은 배송이 진행되었습니다.') {
      const recipientId = context.params.recipientId;  // 문서 경로에서 recipientId를 가져옴
      const orderNumber = messageData.order_number;  // 메세지 데이터에서 order_number를 가져옴

      // 3일 후 상태를 "배송 완료"로 업데이트
      const daysToMilliseconds = 3 * 24 * 60 * 60 * 1000; // 3일을 밀리초로 변환 (3일 x 24시간 x 60분 x 60초 x 1000ms)
//      const daysToMilliseconds = 30000; // 3일을 밀리초로 변환 (3일 x 24시간 x 60분 x 60초 x 1000ms)
      setTimeout(async () => {  // setTimeout을 사용하여 3일 후에 실행되도록 설정
        try {
          const orderDocRef = admin.firestore()  // Firestore에 접근하기 위한 참조 생성
            .collection('wearcano_order_list')  // order_list 컬렉션 참조
            .doc(recipientId)  // recipientId에 해당하는 문서 참조
            .collection('orders')  // orders 하위 컬렉션 참조
            .where('numberInfo.order_number', '==', orderNumber);  // order_number가 해당 order_number와 일치하는 문서를 찾기 위한 쿼리

          const orderDocSnapshot = await orderDocRef.get();  // 쿼리 실행 결과 가져오기
          if (!orderDocSnapshot.empty) {  // 쿼리 결과가 비어 있지 않은 경우
            const orderDoc = orderDocSnapshot.docs[0];  // 첫 번째 결과 문서를 가져옴
            await orderDoc.ref.collection('order_status_info').doc('info').update({  // 해당 문서의 order_status_info 하위 컬렉션의 info 문서를 업데이트
              'order_status': '배송 완료'  // order_status 필드를 "배송 완료"로 업데이트
            });
            console.log(`Order ${orderNumber} status updated to 배송 완료`);  // 상태 업데이트 성공 시 콘솔에 로그 출력
          }
        } catch (error) {  // 에러 발생 시 에러 처리
          console.error('Error updating order status:', error);  // 에러 내용을 콘솔에 출력
        }
      }, daysToMilliseconds);  // 3일 후에 실행되도록 설정
    }
  });
// ------ 메시지 발송 후 3일 후에 발주 상태를 업데이트하는 함수 내용 끝 부분

// ------ Firestore에서 '배송 중 메세지' 메시지가 생성될 때 버튼 상태를 업데이트하는 함수 내용 시작 부분
exports.updateButtonStatusOnMessage_V2 = functions.region('asia-northeast3').firestore
    .document('wearcano_message_list/{recipientId}/message/{messageId}')
    .onCreate(async (snap, context) => {
        const messageData = snap.data();

        if (messageData.contents === '해당 발주 건은 배송이 진행되었습니다.') {
            const recipientId = context.params.recipientId;
            const orderNumber = messageData.order_number;
            const messageSendingTime = messageData.message_sendingTime.toDate(); // message_sendingTime을 Date 객체로 변환
            const currentTime = new Date();

            // 메시지 생성 시간과 현재 시간을 비교 (예: 10일 이내의 메시지만 버튼 활성화)
            if (currentTime - messageSendingTime <= 864000000) { // (10일 = 10 * 24 * 60 * 60 * 1000밀리초)
                const ordersSnapshot = await admin.firestore()
                    .collection('wearcano_order_list')
                    .doc(recipientId)
                    .collection('orders')
                    .where('numberInfo.order_number', '==', orderNumber)
                    .get();

                if (!ordersSnapshot.empty) {
                    const orderDoc = ordersSnapshot.docs[0];
                    const buttonInfoRef = orderDoc.ref.collection('button_info').doc('info');
                    const productInfoRef = orderDoc.ref.collection('product_info');

                    // 버튼 활성화 상태로 업데이트
                    await buttonInfoRef.update({
                        'boolRefundBtn': true,
                        'boolReviewWriteBtn': true,
                    });

                    // 추가적인 조건에 따라 버튼 비활성화
                    setTimeout(async () => {
                        await buttonInfoRef.update({
                            'boolRefundBtn': false,
                            'boolReviewWriteBtn': false,
                        });

                        // product_info 하위 컬렉션의 모든 문서에서 'boolReviewCompleteBtn' 필드를 true로 업데이트
                        const productDocs = await productInfoRef.get();
                        productDocs.forEach(async (doc) => {
                            await doc.ref.update({
                                'boolReviewCompleteBtn': true,
                            });
                        });

                    }, 864000000); // 10일(10일 = 10 * 24 * 60 * 60 * 1000밀리초) 후 비활성화 864000000
                }
            }
        }
    });
// ------ Firestore에서 '배송 중 메세지' 메시지가 생성될 때 버튼 상태를 업데이트하는 함수 내용 끝 부분

// ------ Firestore에서 '환불 메세지' 메시지가 생성될 때 버튼 상태를 업데이트하는 함수 내용 시작 부분
exports.updateButtonStatusOnRefundMessage_V2 = functions.region('asia-northeast3').firestore
    .document('wearcano_message_list/{recipientId}/message/{messageId}')
    .onCreate(async (snap, context) => {
        const messageData = snap.data();
        // Firestore의 새 문서가 생성되었을 때 실행되는 함수임. 생성된 문서의 데이터를 가져옴.

        if (messageData.contents === '해당 발주 건은 환불 처리 되었습니다.') {
            const recipientId = context.params.recipientId;
            const orderNumber = messageData.order_number;
            const selectedSeparatorKey = messageData.selected_separator_key;
            // 메시지의 내용이 특정 문구와 일치할 경우 실행됨. 메시지에 포함된 수신자 ID, 주문 번호, 선택된 separator_key를 가져옴.

            const ordersSnapshot = await admin.firestore()
                .collection('wearcano_order_list')
                .doc(recipientId)
                .collection('orders')
                .where('numberInfo.order_number', '==', orderNumber)
                .get();
            // Firestore에서 해당 수신자 ID의 주문 목록을 가져옴. 주문 번호와 일치하는 주문을 조회함.

            if (!ordersSnapshot.empty) {
                const orderDoc = ordersSnapshot.docs[0];
                const productInfoRef = orderDoc.ref.collection('product_info');
                // 주문이 존재할 경우 해당 주문 문서를 가져오고, 그 주문의 product_info 하위 컬렉션을 참조함.

                const productDocs = await productInfoRef.where('separator_key', '==', selectedSeparatorKey).get();
                // 선택된 separator_key와 일치하는 product_info 문서를 조회함.

                if (!productDocs.empty) {
                    const productDoc = productDocs.docs[0];
                    await productDoc.ref.update({
                        'boolRefundCompleteBtn': true,
                    });
                    // 일치하는 문서가 존재하면, 해당 문서의 'boolRefundCompleteBtn' 필드를 'true'로 업데이트함.
                }
            }
        }
    });
// ------ Firestore에서 '환불 메세지' 메시지가 생성될 때 버튼 상태를 업데이트하는 함수 내용 끝 부분