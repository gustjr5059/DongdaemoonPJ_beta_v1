import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/announce_all_provider.dart';
import 'package:http/http.dart' as http;
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

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 공지사항이 비어있는 경우의 알림 부분 수치
    final double announcementlistEmptyTextWidth =
        screenSize.width * (170 / referenceWidth); // 가로 비율
    final double announcementlistEmptyTextHeight =
        screenSize.height * (22 / referenceHeight); // 세로 비율
    final double announcementlistEmptyTextX =
        screenSize.width * (110 / referenceWidth); // 가로 비율
    final double announcementlistEmptyTextY =
        screenSize.height * (300 / referenceHeight); // 세로 비율
    final double announcementlistEmptyTextFontSize =
        screenSize.height * (16 / referenceHeight);

    print("AnnounceBodyPartsLayout build 시작"); // 빌드 함수 시작 시 로그 출력

    final asyncAnnouncements = ref.watch(announcementsProvider); // announcementsProvider를 감시하여 비동기 데이터를 가져옴

    return asyncAnnouncements.when(
      data: (announcements) { // 데이터가 성공적으로 로드되었을 때의 처리
        print("데이터 로드 성공: ${announcements.length}개의 공지사항이 있습니다"); // 로드 성공 시 로그 출력

        // 공지사항 데이터가 없는 경우 '현재 공지사항이 없습니다.' 메세지 표시하는 로직
        if (announcements.isEmpty) {
          return Container(
              width: announcementlistEmptyTextWidth,
              height: announcementlistEmptyTextHeight,
              margin: EdgeInsets.only(left: announcementlistEmptyTextX, top: announcementlistEmptyTextY),
              child: Text('현재 공지사항이 없습니다.',
                style: TextStyle(
                  fontSize: announcementlistEmptyTextFontSize,
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
          ); // 공지사항이 없을 때의 UI 처리
        }

        return SingleChildScrollView( // 스크롤 가능한 레이아웃 제공
          child: Padding(
            padding: const EdgeInsets.all(8.0), // 모든 방향으로 8.0의 패딩 적용
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 컬럼 내에서 왼쪽 정렬
              children: announcements.map((announcement) {
                final title = (announcement['title'] as String?) ?? 'No Title'; // 공지사항 제목을 가져오며, 없을 경우 'No Title'로 대체함
                final documentId = (announcement['document_id'] as String?) ?? ''; // 공지사항의 document_id를 가져옴
                final timestamp = announcement['time'] as Timestamp?; // 공지사항의 시간 정보를 가져옴
                final timeString = timestamp != null // 시간 정보를 문자열로 변환함
                    ? "${timestamp.toDate().year}-${timestamp.toDate().month.toString().padLeft(2, '0')}-${timestamp.toDate().day.toString().padLeft(2, '0')} ${timestamp.toDate().hour.toString().padLeft(2, '0')}:${timestamp.toDate().minute.toString().padLeft(2, '0')}"
                    : 'No Date';

                print("공지사항 로드: title=$title, documentId=$documentId"); // 개별 공지사항 로드 시 로그 출력

                return GestureDetector( // 터치 이벤트 처리를 위한 GestureDetector 사용
                  onTap: () {
                    if (documentId.isNotEmpty) {
                      print("공지사항 클릭: documentId=$documentId"); // 공지사항 클릭 시 로그 출력
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnnounceDetailScreen(documentId: documentId), // 공지사항 상세 화면으로 이동함
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0), // 상하 방향으로 8.0의 패딩 적용
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 컬럼 내에서 왼쪽 정렬
                      children: [
                        Text(
                          title,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), // 제목 텍스트 스타일 설정
                        ),
                        SizedBox(height: 4), // 제목과 시간 사이 간격 설정
                        Text(
                          timeString,
                          style: TextStyle(fontSize: 14, color: Colors.grey), // 시간 텍스트 스타일 설정
                        ),
                        Divider(), // 구분선 삽입
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
      loading: () { // 데이터 로딩 중일 때의 처리
        print("데이터 로드 중..."); // 로딩 중 로그 출력
        return Center(child: CircularProgressIndicator()); // 로딩 인디케이터 표시
      },
      error: (err, stack) { // 데이터 로드 실패 시의 처리
        print("데이터 로드 실패: $err"); // 에러 발생 시 로그 출력
        return Center(child: Text('Error: $err')); // 에러 메시지 표시
      },
    );
  }
}
// ------ 공지사항 화면 내 UI를 구현하는 AnnounceBodyPartsLayout 클래스 내용 끝 부분

// ------ 공지사항 상세 화면 내 UI를 구현하는 AnnounceDetailBodyPartsLayout 클래스 내용 시작 부분
class AnnounceDetailBodyPartsLayout extends ConsumerWidget {
  final String documentId; // 공지사항의 고유 ID를 저장하는 변수 선언

  AnnounceDetailBodyPartsLayout({required this.documentId}); // documentId를 받아오는 생성자 정의

  Future<String> fetchTextFromUrl(String url) async { // 주어진 URL로부터 텍스트 데이터를 가져오는 함수 정의
    print('텍스트 파일 로드 시도: $url'); // URL 로드 시도 로그 출력
    final response = await http.get(Uri.parse(url)); // HTTP GET 요청 수행
    if (response.statusCode == 200) { // 요청 성공 시
      print('텍스트 파일 로드 성공'); // 로드 성공 로그 출력

      // 텍스트가 특정 인코딩으로 저장되었을 경우, 해당 인코딩을 사용해 디코딩 시도
      return const Utf8Decoder(allowMalformed: true).convert(response.bodyBytes);
    } else { // 요청 실패 시
      print('텍스트 파일 로드 실패: ${response.statusCode}'); // 실패 로그 출력
      throw Exception('Failed to load text from URL'); // 예외 발생
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('AnnounceDetailBodyPartsLayout build 시작: documentId=$documentId'); // 빌드 함수 시작 시 로그 출력
    final asyncAnnouncement = ref.watch(announcementDetailProvider(documentId)); // documentId를 사용하여 공지사항 상세 정보를 가져옴

    return asyncAnnouncement.when(
      data: (announcement) { // 데이터가 성공적으로 로드되었을 때의 처리
        print('공지사항 상세 로드 성공: $announcement'); // 로드 성공 시 로그 출력
        final title = (announcement['title'] as String?) ?? 'No Title'; // 공지사항 제목을 가져오며, 없을 경우 'No Title'로 대체함
        final timestamp = announcement['time'] as Timestamp?; // 공지사항의 시간 정보를 가져옴
        final timeString = timestamp != null // 시간 정보를 문자열로 변환함
            ? "${timestamp.toDate().year}-${timestamp.toDate().month.toString().padLeft(2, '0')}-${timestamp.toDate().day.toString().padLeft(2, '0')} ${timestamp.toDate().hour.toString().padLeft(2, '0')}:${timestamp.toDate().minute.toString().padLeft(2, '0')}"
            : 'No Date';
        final contentsTextUrl = (announcement['contents_text'] as String?) ?? ''; // 텍스트 콘텐츠 URL을 가져옴
        final contentsWebLink = (announcement['contents_web_link'] as String?) ?? ''; // 웹 링크를 가져옴
        final contentsImageUrl = (announcement['contents_image'] as String?) ?? ''; // 이미지 URL을 가져옴
        final contentsWebLinkText = (announcement['contents_web_link_text'] as String?) ?? ''; // 웹 링크 텍스트를 가져옴

        return SingleChildScrollView( // 스크롤 가능한 레이아웃 제공
          child: Padding(
            padding: const EdgeInsets.all(16.0), // 모든 방향으로 16.0의 패딩 적용
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 컬럼 내에서 왼쪽 정렬
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), // 제목 텍스트 스타일 설정
                ),
                SizedBox(height: 8), // 제목과 시간 사이 간격 설정
                Text(
                  timeString,
                  style: TextStyle(fontSize: 14, color: Colors.grey), // 시간 텍스트 스타일 설정
                ),
                Divider(color: Colors.grey), // 구분선 삽입
                if (contentsTextUrl.isNotEmpty)
                  FutureBuilder<String>(
                    future: fetchTextFromUrl(contentsTextUrl), // 텍스트 파일 로드 함수 호출
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) { // 로딩 중일 때
                        return CircularProgressIndicator(); // 로딩 인디케이터 표시
                      } else if (snapshot.hasError) { // 에러 발생 시
                        return Text('Error loading content'); // 에러 메시지 표시
                      } else { // 로드 성공 시
                        return Text(
                          snapshot.data ?? '', // 로드된 텍스트 표시
                          style: TextStyle(fontSize: 16, color: Colors.black), // 텍스트 스타일 설정
                        );
                      }
                    },
                  ),
                SizedBox(height: 16), // 텍스트와 웹 링크 사이 간격 설정
                if (contentsWebLink.isNotEmpty)
                  GestureDetector( // 터치 이벤트 처리를 위한 GestureDetector 사용
                    onTap: () {
                      _launchURL(contentsWebLink); // 웹 링크 열기 함수 호출
                    },
                    child: Text(
                      contentsWebLinkText,
                      style: TextStyle(fontSize: 16, color: Colors.blue), // 웹 링크 텍스트 스타일 설정
                    ),
                  ),
                SizedBox(height: 16), // 웹 링크와 이미지 사이 간격 설정
                if (contentsImageUrl.isNotEmpty)
                  Image.network(
                    contentsImageUrl,
                    fit: BoxFit.contain, // 이미지 크기 조절 설정
                    width: MediaQuery.of(context).size.width / 3, // 이미지 너비 설정
                  ),
              ],
            ),
          ),
        );
      },
      loading: () { // 데이터 로딩 중일 때의 처리
        print('공지사항 상세 로드 중...'); // 로딩 중 로그 출력
        return Center(child: CircularProgressIndicator()); // 로딩 인디케이터 표시
      },
      error: (err, stack) { // 데이터 로드 실패 시의 처리
        print('공지사항 상세 로드 실패: $err'); // 에러 발생 시 로그 출력
        return Center(child: Text('Error: $err')); // 에러 메시지 표시
      },
    );
  }

  void _launchURL(String url) async { // 웹 링크를 실행하는 함수 정의
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) { // 링크 실행 가능 여부 확인
      print('웹 링크 실행: $url'); // 링크 실행 성공 로그 출력
      await launchUrl(uri); // 링크 실행
    } else {
      print('웹 링크 실행 실패: $url'); // 링크 실행 실패 로그 출력
      throw 'Could not launch $url'; // 예외 발생
    }
  }
}
// ------ 공지사항 상세 화면 내 UI를 구현하는 AnnounceDetailBodyPartsLayout 클래스 내용 끝 부분