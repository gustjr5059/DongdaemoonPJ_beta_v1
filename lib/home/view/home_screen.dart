import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 200, // 스크롤 영역의 높이 설정
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // 수평 스크롤 활성화
              itemCount: 5, // 페이지/아이템 수
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width, // 각 페이지의 너비
                  color: Colors.grey[300], // 시각적 구분을 위한 배경색
                  child: Center(
                    child: Text(
                      '페이지 ${index + 1}',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
            ),
          ),
          // HomeScreen의 다른 위젯들은 여기에 추가할 수 있습니다
        ],
      ),
    );
  }
}
