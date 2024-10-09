import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/colors.dart';

class CommunityLockScreen extends StatelessWidget {
  final VoidCallback onTap;

  const CommunityLockScreen({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    // 상태 표시줄을 검정색 텍스트로 설정
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 147),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '캘린더 제목',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        color: primary,
                        fontSize: 28,
                        height: 1.29,
                      ),
                    ),
                    TextSpan(
                      text: '을 설정하고,\n기록을 ',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        color: gray900,
                        fontSize: 28,
                        height: 1.29,
                      ),
                    ),
                    TextSpan(
                      text: '3개 이상',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        color: primary,
                        fontSize: 28,
                        height: 1.29,
                      ),
                    ),
                    TextSpan(
                      text: ' 해보세요!',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        color: gray900,
                        fontSize: 28,
                        height: 1.29,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                '다른 사람들의 기록도 확인할 수 있어요',
                style: TextStyle(
                  color: gray600,
                  fontSize: 18,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 100),
              Center(
                child: Image.asset(
                  'assets/icons/lock.png',
                  height: 150,
                  width: 150,
                ),
              ),
              SizedBox(height: 159),
              Center(
                child: ElevatedButton(
                  onPressed: onTap,
                  child: Text(
                    '확인',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    minimumSize: Size(358,48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40,),
            ],
          ),
        ),
      ),
    );
  }
}