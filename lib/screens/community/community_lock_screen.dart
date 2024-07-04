import 'package:day1/screens/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/colors.dart';

class CommunityLockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            RichText(
              textAlign: TextAlign.left, // 왼쪽 정렬
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '캘린더 제목',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primary,
                      fontSize: 27,
                    ),
                  ),
                  TextSpan(
                    text: '을 설정하고,\n기록을 ',
                    style: TextStyle(
                      color: gray900,
                      fontSize: 27,
                    ),
                  ),
                  TextSpan(
                    text: '3개 이상',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primary,
                      fontSize: 27,
                    ),
                  ),
                  TextSpan(
                    text: ' 해보세요!',
                    style: TextStyle(
                      color: gray900,
                      fontSize: 27,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '다른 사람들의 기록도 확인할 수 있어요',
              style: TextStyle(
                color: gray600,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 40.0),
            Center(
              child: SvgPicture.asset(
                'assets/images/lock.svg',
                height: 150,
                width: 150,
              ),
            ),
            SizedBox(height: 40.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalendarScreen(), // CalendarScreen으로 변경
                    ),
                  );
                },
                child: Text(
                  '확인',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '캘린더',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: '카메라',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}