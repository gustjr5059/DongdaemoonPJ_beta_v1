import 'package:flutter/material.dart';

import '../../common/const/colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 페이지 컨트롤러 초기화
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      // 페이지가 변경될 때마다 현재 페이지를 업데이트
      setState(() {
        _currentPage = _controller.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 200, // 페이지 뷰의 높이를 200으로 설정
            // PageView.builder를 사용하여 스크롤 가능한 페이지 뷰 생성
            child: PageView.builder(
              controller: _controller, // 컨트롤러 할당
              scrollDirection: Axis.horizontal, // 수평 스크롤 설정
              itemCount: 5, // 총 페이지 수
              itemBuilder: (context, index) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // 각 페이지의 컨텐츠
                    Container(
                      color: Colors.grey[300],
                      child: Center(child: Text('페이지 ${index + 1}', style: TextStyle(fontSize: 24))),
                    ),
                    // 왼쪽 화살표 버튼 (비활성화 상태로 표시)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        color: index > 0 ? Colors.black : Colors.grey, // 비활성화 색상
                        onPressed: index > 0 ? () => _controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn) : null,
                      ),
                    ),
                    // 오른쪽 화살표 버튼 (비활성화 상태로 표시)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        color: index < 4 ? Colors.black : Colors.grey, // 비활성화 색상
                        onPressed: index < 4 ? () => _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn) : null,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
            // 페이지 번호 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4), // 좌우 여백 설정
                child: Text(
                '${index + 1}',
                style: TextStyle(
                fontSize: 16,
                color: _currentPage == index ? PRIMARY_COLOR : BODY_TEXT_COLOR,
                // 현재 페이지는 PRIMARY_COLOR, 아니면 BODY_TEXT_COLOR
                ),
               ),
              );
             }),
           ),
        ],
      ),
    );
  }
}
