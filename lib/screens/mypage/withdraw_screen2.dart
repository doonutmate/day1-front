import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/colors.dart';

class WithdrawScreen2 extends StatelessWidget {
  final VoidCallback onTap;

  const WithdrawScreen2({required this.onTap, required super.key});

  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height; //797
    final screenWidth = MediaQuery.of(context).size.width; // 390

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
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 207, // 207, 160
              ),
              Center(
                child: Image.asset(
                  'assets/icons/check1.png', // 이미지 경로를 check2.png로 변경
                  height: 70,
                  width: 70,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, size: screenHeight * 0.19);
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Text(
                  '회원탈퇴가 완료되었어요',
                  style: TextStyle(fontSize: 24,fontFamily: 'Pretendard', fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Center(
                child: Text(
                  '지금까지 DAY1을 이용해 주셔서 감사해요. \n더욱더 노력하고 발전하는 DAY1이 될게요!',
                  style: TextStyle(fontSize: 18,fontFamily: 'Pretendard',fontWeight: FontWeight.w400, color: gray600),
                ),
              ),
              SizedBox(height: 333,),
              Center(
                child: ElevatedButton(
                  onPressed: onTap,
                  child: Text(
                    '확인',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    minimumSize: Size(358, 48), //0.954, 0.128
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}