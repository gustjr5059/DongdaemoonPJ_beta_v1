
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../provider/sign_up_document_state_provider.dart';


// ------ 회원가입 화면 내 동의서 상세 화면 내 UI를 구현하는 SignUpDocumentDetailBodyPartsLayout 클래스 내용 시작 부분
class SignUpDocumentDetailBodyPartsLayout extends ConsumerWidget {
  final String documentId; // 동의서의 고유 ID를 저장하는 변수임

  const SignUpDocumentDetailBodyPartsLayout({
    required this.documentId,
    Key? key,
  }) : super(key: key);

  // 주어진 URL로부터 텍스트 데이터를 가져오는 함수임
  Future<String> fetchTextFromUrl(String url) async {
    final response = await http.get(Uri.parse(url)); // HTTP GET 요청을 보냄
    print("HTTP 응답 상태 코드: ${response.statusCode}"); // 응답 상태 코드를 출력함

    if (response.statusCode == 200) {
      // 요청이 성공한 경우
      return const Utf8Decoder(allowMalformed: true)
          .convert(response.bodyBytes); // UTF-8로 인코딩된 텍스트 데이터를 반환함
    } else {
      // 요청이 실패한 경우
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

    // 비율을 기반으로 동적으로 크기와 위치를 설정함

    // body 부분 전체 패딩 수치 계산
    final double documentDtlistPadding1Y =
        screenSize.height * (8 / referenceHeight); // 상하 패딩 계산

    // 텍스트 크기 계산
    final double documentDtlistTitleDataFontSize =
        screenSize.height * (18 / referenceHeight); // 텍스트 크기 비율 계산
    final double documentDtlistTimeDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double documentDtlistTextDataFontSize =
        screenSize.height * (16 / referenceHeight); // 텍스트 크기 비율 계산
    final double documentDtlistWeblinkDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산

    // 컨텐츠 사이의 간격 계산
    final double interval1Y =
        screenSize.height * (4 / referenceHeight); // 세로 간격 1 계산
    final double interval2Y =
        screenSize.height * (16 / referenceHeight); // 세로 간격 2 계산
    final double interval3Y =
        screenSize.height * (10 / referenceHeight); // 세로 간격 3 계산

    final double errorTextFontSize =
        screenSize.height * (14 / referenceHeight); // 에러 메세지 폰트 크기

    // 동의서 상세 데이터를 가져옴
    final documentDetailItem =
    ref.watch(signUpDocumentDetailItemProvider(documentId));

    // 동의서 상세 데이터가 없을 경우
    // StateNotifierProvider를 사용한 로직에서는 AsyncValue를 사용하여 상태를 처리할 수 없으므로
    // loading: (), error: (err, stack)를 구분해서 구현 못함
    // 그래서, 이렇게 isEmpty 경우로 해서 구현하면 error와 동일하게 구현은 됨
    // 그대신 로딩 표시를 못 넣음...
    if (documentDetailItem.isEmpty) {
      return Center(
        child: Text(
          '에러가 발생했으니, 앱을 재실행해주세요.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'NanumGothic',
            fontSize: errorTextFontSize,
            color: BLACK_COLOR,
          ),
        ),
      ); // 데이터가 없을 때 표시할 텍스트임
    }

    // 동의서 상세 데이터를 변수에 저장함
    final title = (documentDetailItem['title'] as String?) ??
        ''; // 동의서 제목을 가져오며 없을 경우 ''로 설정함
    // URL을 통해 가져오는 텍스트 데이터임
    final contentsTextUrl = (documentDetailItem['contents_text'] as String?) ??
        ''; // 텍스트 콘텐츠 URL을 가져옴

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: documentDtlistPadding1Y),
      // 상하로 announceDtlistPadding1Y의 패딩을 적용함
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 컬럼 내에서 왼쪽 정렬을 설정함
        children: [
          // 동의서 제목을 표시하는 텍스트임
          Text(
            title,
            style: TextStyle(
              fontSize: documentDtlistTitleDataFontSize, // 텍스트 크기 설정
              fontWeight: FontWeight.bold, // 텍스트 굵기 설정
              fontFamily: 'NanumGothic', // 글꼴 설정
              color: BLACK_COLOR, // 텍스트 색상 설정
            ), // 제목의 텍스트 스타일을 설정함
          ),
          SizedBox(height: interval1Y),
          Divider(color: GRAY69_COLOR), // 구분선을 삽입함
          SizedBox(height: interval3Y),
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
            //           fontSize: documentDtlistTextDataFontSize, // 텍스트 크기 설정
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
                        fontSize: FontSize(documentDtlistTextDataFontSize),
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
        ],
      ),
    );
  }
}
// ------ 회원가입 화면 내 동의서 상세 화면 내 UI를 구현하는 AnnounceDetailBodyPartsLayout 클래스 내용 끝 부분