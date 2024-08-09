import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class CommunityLockScreen extends StatelessWidget {
  final VoidCallback onTap; // onTap 콜백 정의

  const CommunityLockScreen({Key? key, required this.onTap}) : super(key: key); // 생성자에 onTap 콜백 추가

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              textAlign: TextAlign.left,
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
              child: Image.asset(
                'assets/icons/lock.png',
                height: 150,
                width: 150,
              ),
            ),
            SizedBox(height: 90.0),
            Center(
              child: ElevatedButton(
                onPressed: onTap,
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
    );
  }
}