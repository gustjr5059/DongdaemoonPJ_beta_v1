import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongdaemoon_beta_v1/common/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/layout/common_body_parts_layout.dart';
import 'package:http/http.dart' as http;
import '../provider/announce_state_provider.dart';
import '../view/announce_detail_screen.dart';

// ------ 공지사항 화면 내 UI를 구현하는 AnnounceBodyPartsLayout 클래스 내용 시작 부분
class AnnounceBodyPartsLayout extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려하지 않은 사이즈 시작 부분
    // // 비율을 기반으로 동적으로 크기와 위치를 설정함
    //
    // // body 부분 전체 패딩 수치 계산
    // final double announcelistPadding1Y = screenSize.height * (8 / referenceHeight); // 상하 패딩 계산
    //
    // // 텍스트 크기 계산
    // final double announcelistTitleDataFontSize =
    //     screenSize.height * (18 / referenceHeight); // 텍스트 크기 비율 계산
    // final double announcelistTimeDataFontSize =
    //     screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    //
    // // 컨텐츠 사이의 간격 계산
    // final double interval1Y = screenSize.height * (4 / referenceHeight); // 세로 간격 1 계산
    // final double errorTextFontSize = screenSize.height * (14 / referenceHeight); // 에러 메세지 폰트 크기
    // // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려하지 않은 사이즈 끝 부분

    // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려한 사이즈 시작 부분
    // 비율을 기반으로 동적으로 크기와 위치를 설정함

    // body 부분 전체 패딩 수치 계산
    final double announcelistPadding1Y = 8; // 상하 패딩 계산

    // 텍스트 크기 계산
    final double announcelistTitleDataFontSize = 18; // 텍스트 크기 비율 계산
    final double announcelistTimeDataFontSize = 14; // 텍스트 크기 비율 계산

    // 컨텐츠 사이의 간격 계산
    final double interval1Y = 4; // 세로 간격 1 계산
    final double errorTextFontSize = 14; // 에러 메세지 폰트 크기
    // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려한 사이즈 끝 부분

    // announceItemsProvider를 통해 공지사항 아이템 목록 상태를 가져옴
    final announceItems = ref.watch(announceItemsProvider);

    // 공지사항 목록이 비어있으면 '현재 공지사항이 없습니다.'라는 텍스트를 출력함
    // StateNotifierProvider를 사용한 로직에서는 AsyncValue를 사용하여 상태를 처리할 수 없으므로
    // loading: (), error: (err, stack)를 구분해서 구현 못함
    // 그래서, 이렇게 isEmpty 경우로 해서 구현하면 error와 동일하게 구현은 됨
    // 그대신 로딩 표시를 못 넣음...
    return announceItems.isEmpty
        ? Center(
            child:
            Text('현재 공지사항이 없습니다.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'NanumGothic',
                fontSize: errorTextFontSize,
                color: BLACK_COLOR,
              ),
            ),
          )
      // 공지사항이 있으면 Column 위젯을 사용해 공지사항 목록을 보여줌
        : Column(
      // 공지사항 아이템을 반복하여 UI를 생성함
      children: announceItems.map((announceItem) {
        // 공지사항 제목을 가져오며, 없을 경우 'No Title'로 대체함
        final title = (announceItem['title'] as String?) ?? '';
        // 공지사항의 document_id를 가져옴
        final documentId = (announceItem['document_id'] as String?) ?? '';
        // 공지사항의 시간 정보를 가져옴
        final timestamp = announceItem['time'] as Timestamp?;
        // 시간 정보를 문자열로 변환함
        final timeString = timestamp != null
            ? "${timestamp.toDate().year}년 ${timestamp.toDate().month.toString().padLeft(2, '0')}월 ${timestamp.toDate().day.toString().padLeft(2, '0')}일 ${timestamp.toDate().hour.toString().padLeft(2, '0')}시 ${timestamp.toDate().minute.toString().padLeft(2, '0')}분"
            : '';

        // 공지사항 항목을 터치할 수 있도록 GestureDetector 사용함
        return GestureDetector(
          // 터치 시 공지사항 상세 화면으로 이동함
          onTap: () {
            if (documentId.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AnnounceDetailScreen(documentId: documentId), // 공지사항 상세 화면으로 이동함
                ),
              );
            }
          },
          // 공지사항 항목을 패딩으로 감싸서 간격을 줌
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: announcelistPadding1Y), // 상하 방향으로 announcelistPadding1Y의 패딩을 적용함
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 컬럼 내에서 왼쪽 정렬을 설정함
              children: [
                // 공지사항 제목을 보여주는 텍스트 위젯임
                Text(
                  title,
                  style: TextStyle(
                    fontSize: announcelistTitleDataFontSize, // 텍스트 크기 설정
                    fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                    fontFamily: 'NanumGothic', // 글꼴 설정
                    color: BLACK_COLOR, // 텍스트 색상 설정
                  ), // 텍스트 스타일을 설정함
                ),
                SizedBox(height: interval1Y), // 제목과 시간 사이에 간격을 줌
                // 공지사항 시간을 보여주는 텍스트 위젯임
                Text(
                  timeString,
                  style: TextStyle(
                    fontSize: announcelistTimeDataFontSize, // 텍스트 크기 설정
                    fontWeight: FontWeight.normal, // 텍스트 굵기 설정
                    fontFamily: 'NanumGothic', // 글꼴 설정
                    color: GRAY60_COLOR, // 텍스트 색상 설정
                  ),  // 시간 텍스트의 스타일을 설정함
                ),
                Divider(), // 항목 간에 구분선을 삽입함
              ],
            ),
          ),
        );
      }).toList(), // map 함수 결과를 리스트로 변환하여 반환함
    );
  }
}
// ------ 공지사항 화면 내 UI를 구현하는 AnnounceBodyPartsLayout 클래스 내용 끝 부분

// ------ 공지사항 상세 화면 내 UI를 구현하는 AnnounceDetailBodyPartsLayout 클래스 내용 시작 부분
class AnnounceDetailBodyPartsLayout extends ConsumerWidget {
  final String documentId; // 공지사항의 고유 ID를 저장하는 변수임

  AnnounceDetailBodyPartsLayout({required this.documentId}); // documentId를 받아오는 생성자임

  // 주어진 URL로부터 텍스트 데이터를 가져오는 함수임
  Future<String> fetchTextFromUrl(String url) async {
    final response = await http.get(Uri.parse(url)); // HTTP GET 요청을 보냄
    print("HTTP 응답 상태 코드: ${response.statusCode}"); // 응답 상태 코드를 출력함

    if (response.statusCode == 200) { // 요청이 성공한 경우
      return const Utf8Decoder(allowMalformed: true).convert(response.bodyBytes); // UTF-8로 인코딩된 텍스트 데이터를 반환함
    } else { // 요청이 실패한 경우
      throw Exception('URL에서 텍스트 로드에 실패했습니다'); // 예외를 발생시킴
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려하지 않은 사이즈 시작 부분
    // // 비율을 기반으로 동적으로 크기와 위치를 설정함
    //
    // // body 부분 전체 패딩 수치 계산
    // final double announceDtlistPadding1Y = screenSize.height * (8 / referenceHeight); // 상하 패딩 계산
    //
    // // 텍스트 크기 계산
    // final double announceDtlistTitleDataFontSize =
    //     screenSize.height * (18 / referenceHeight); // 텍스트 크기 비율 계산
    // final double announceDtlistTimeDataFontSize =
    //     screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    // final double announceDtlistTextDataFontSize =
    //     screenSize.height * (16 / referenceHeight); // 텍스트 크기 비율 계산
    // final double announceDtlistWeblinkDataFontSize =
    //     screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    //
    // // 컨텐츠 사이의 간격 계산
    // final double interval1Y = screenSize.height * (8 / referenceHeight); // 세로 간격 1 계산
    // final double interval2Y = screenSize.height * (16 / referenceHeight); // 세로 간격 1 계산
    // final double errorTextFontSize = screenSize.height * (14 / referenceHeight); // 에러 메세지 폰트 크기
    // // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려하지 않은 사이즈 끝 부분

    // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려한 사이즈 시작 부분
    // 비율을 기반으로 동적으로 크기와 위치를 설정함

    // body 부분 전체 패딩 수치 계산
    final double announceDtlistPadding1Y = 8; // 상하 패딩 계산

    // 텍스트 크기 계산
    final double announceDtlistTitleDataFontSize = 18; // 텍스트 크기 비율 계산
    final double announceDtlistTimeDataFontSize = 14; // 텍스트 크기 비율 계산
    final double announceDtlistTextDataFontSize = 16; // 텍스트 크기 비율 계산
    final double announceDtlistWeblinkDataFontSize = 14; // 텍스트 크기 비율 계산

    // 컨텐츠 사이의 간격 계산
    final double interval1Y = 8; // 세로 간격 1 계산
    final double interval2Y = 16; // 세로 간격 1 계산
    final double errorTextFontSize = 14; // 에러 메세지 폰트 크기
    // ---  갤럭시 Z플립 화면 분할 케이스(화면 세로 길이가 줄어드는 형태) 고려한 사이즈 끝 부분

    // 공지사항 상세 데이터를 가져옴
    final announceDetailItem = ref.watch(announceDetailItemProvider(documentId));

    // 공지사항 상세 데이터가 없을 경우
    // StateNotifierProvider를 사용한 로직에서는 AsyncValue를 사용하여 상태를 처리할 수 없으므로
    // loading: (), error: (err, stack)를 구분해서 구현 못함
    // 그래서, 이렇게 isEmpty 경우로 해서 구현하면 error와 동일하게 구현은 됨
    // 그대신 로딩 표시를 못 넣음...
    if (announceDetailItem.isEmpty) {
      return Center(
              child:
                Text('에러가 발생했으니, 앱을 재실행해주세요.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NanumGothic',
                    fontSize: errorTextFontSize,
                    color: BLACK_COLOR,
                  ),
                ),
              ); // 데이터가 없을 때 표시할 텍스트임
            }

    // 공지사항 상세 데이터를 변수에 저장함
    final title = (announceDetailItem['title'] as String?) ?? ''; // 공지사항 제목을 가져오며 없을 경우 'No Title'로 설정함
    final timestamp = announceDetailItem['time'] as Timestamp?; // 공지사항의 시간 정보를 가져옴
    // 시간 정보를 문자열로 변환함
    final timeString = timestamp != null
        ? "${timestamp.toDate().year}년 ${timestamp.toDate().month.toString().padLeft(2, '0')}월 ${timestamp.toDate().day.toString().padLeft(2, '0')}일 ${timestamp.toDate().hour.toString().padLeft(2, '0')}시 ${timestamp.toDate().minute.toString().padLeft(2, '0')}분"
        : ''; // 시간 정보를 포맷팅함

    // URL을 통해 가져오는 텍스트 데이터임
    final contentsTextUrl = (announceDetailItem['contents_text'] as String?) ?? ''; // 텍스트 콘텐츠 URL을 가져옴
    final contentsWebLink = (announceDetailItem['contents_web_link'] as String?) ?? ''; // 웹 링크 URL을 가져옴
    final contentsImageUrl = (announceDetailItem['contents_image'] as String?) ?? ''; // 이미지 URL을 가져옴
    final contentsWebLinkText = (announceDetailItem['contents_web_link_text'] as String?) ?? ''; // 웹 링크에 대한 텍스트를 가져옴

    return Padding(
      padding: EdgeInsets.symmetric(vertical: announceDtlistPadding1Y), // 상하로 announceDtlistPadding1Y의 패딩을 적용함
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 컬럼 내에서 왼쪽 정렬을 설정함
        children: [
          // 공지사항 제목을 표시하는 텍스트임
          Text(
            title,
            style: TextStyle(
              fontSize: announceDtlistTitleDataFontSize, // 텍스트 크기 설정
              fontWeight: FontWeight.bold, // 텍스트 굵기 설정
              fontFamily: 'NanumGothic', // 글꼴 설정
              color: BLACK_COLOR, // 텍스트 색상 설정
            ),  // 제목의 텍스트 스타일을 설정함
          ),
          SizedBox(height: interval1Y), // 제목과 시간 사이의 간격을 설정함
          // 공지사항 시간을 표시하는 텍스트임
          Text(
            timeString,
            style: TextStyle(
              fontSize: announceDtlistTimeDataFontSize, // 텍스트 크기 설정
              fontWeight: FontWeight.normal, // 텍스트 굵기 설정
              fontFamily: 'NanumGothic', // 글꼴 설정
              color: GRAY60_COLOR, // 텍스트 색상 설정
            ),  // 시간 텍스트의 스타일을 설정함
          ),
          Divider(color: GRAY69_COLOR), // 구분선을 삽입함
          if (contentsTextUrl.isNotEmpty)
          // 텍스트 파일을 비동기로 로드하여 표시하는 FutureBuilder임
            FutureBuilder<String>(
              future: fetchTextFromUrl(contentsTextUrl), // 텍스트 파일을 URL에서 가져옴
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: screenSize.height * 0.6, // 화면 높이의 60%로 설정함
                    alignment: Alignment.center, // 컨테이너 안의 내용물을 중앙 정렬함
                    child: buildCommonLoadingIndicator(), // 로딩 인디케이터를 표시함
                  ); // 로딩 중일 때 로딩 표시를 보여줌
                } else if (snapshot.hasError) {
                  return Text(
                      '콘텐츠 로드 중 오류 발생: ${snapshot.error}'); // 에러 발생 시 에러 메시지를 출력함
                  //     } else {
                  //       // 성공적으로 로드된 경우
                  //       return Text(
                  //         snapshot.data ?? '', // 로드된 텍스트를 표시함
                  //         style: TextStyle(
                  //           fontSize: announceDtlistTextDataFontSize, // 텍스트 크기 설정
                  //           fontWeight: FontWeight.normal, // 텍스트 굵기 설정
                  //           fontFamily: 'NanumGothic', // 글꼴 설정
                  //           color: BLACK_COLOR, // 텍스트 색상 설정
                  //         ), // 텍스트 스타일을 설정함
                  //       );
                  //     }
                  //   },
                  // ),
                  // 파이어베이스 내 html로 구현된 txt 파일 -> html로 전환하여 보여주는 UI 구현 로직 부분 (flutter_html 라이브러리 사용)
                } else {
                  // 여기서 flutter_html 사용
                  return Html(
                    data: snapshot.data ?? '',
                    style: {
                      // body 태그 전체에 대한 스타일
                      "body": Style(
                        fontFamily: 'NanumGothic',
                        fontSize: FontSize(announceDtlistTextDataFontSize),
                        color: BLACK_COLOR,
                      ),
                      // 예: <h1> 태그 스타일, <p> 태그 스타일 따로 적용 가능
                      // "h1": Style(fontSize: FontSize(20.0)),
                      // "p": Style(fontSize: FontSize(16.0)),
                    },
                  );
                }
              },
            ),
          SizedBox(height: interval2Y), // 텍스트와 웹 링크 사이의 간격을 설정함
          if (contentsWebLink.isNotEmpty)
            GestureDetector( // 터치 이벤트 처리를 위한 GestureDetector 사용
              onTap: () async {
                // 웹 링크를 열기 위한 launchURL 함수를 호출함
                try {
                  final bool launched = await launchUrl(Uri.parse(contentsWebLink), mode: LaunchMode.externalApplication); // 외부 브라우저에서 URL 열기
                  if (!launched) {
                    // 웹 페이지를 열지 못할 경우 스낵바로 알림
                    showCustomSnackBar(context, '웹 페이지를 열 수 없습니다.');
                  }
                } catch (e) {
                  // 예외 발생 시 스낵바로 에러 메시지 출력
                  showCustomSnackBar(context, '에러가 발생했습니다.\n앱을 재실행해주세요.');
                }
              },
              child: Text(
                contentsWebLinkText,
                style: TextStyle(
                  fontSize: announceDtlistWeblinkDataFontSize, // 텍스트 크기 설정
                  fontWeight: FontWeight.normal, // 텍스트 굵기 설정
                  fontFamily: 'NanumGothic', // 글꼴 설정
                  color: BLUE49_COLOR, // 텍스트 색상 설정
                ),  // 웹 링크 텍스트 스타일을 설정함
              ),
            ),
          SizedBox(height: interval2Y), // 웹 링크와 이미지 사이의 간격을 설정함
          // 데이터가 null이거나 빈 값인 경우
          contentsImageUrl != null && contentsImageUrl != ''
              ? Image.network(
                contentsImageUrl, // 이미지를 네트워크에서 가져옴
                fit: BoxFit.contain, // 이미지 크기를 적절히 조절함
                width: MediaQuery.of(context).size.width, // 화면 너비에 맞게 이미지 너비를 설정함
                errorBuilder: (context, error, stackTrace) => Container(), // 이미지 로드 실패 시 빈 컨테이너를 표시
          )
              : Container(), // 데이터가 없을 경우 빈 컨테이너를 표시
        ],
      ),
    );
  }
}
// ------ 공지사항 상세 화면 내 UI를 구현하는 AnnounceDetailBodyPartsLayout 클래스 내용 끝 부분