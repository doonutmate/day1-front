import 'package:day1/widgets/atoms/appleLogin_button.dart';
import 'package:day1/widgets/atoms/kakaoLogin_button.dart';
import 'package:flutter/material.dart';
import 'package:day1/services/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart'; // 기기마다 다른 화면 사이즈에 맞춰 Flexible하게 변환하는 방법


class LoginScreen extends StatelessWidget {
  final String? initialUrl;

  LoginScreen({Key? key, this.initialUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(flex: 2, child: SizedBox()),
              // 이미지와 "데이원과 함께해요" 텍스트를 왼쪽 정렬된 별도의 Column으로 묶기
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SvgPicture.asset('assets/icons/day1Text.svg'),
                  SizedBox(height: 15),
                  Text(
                    "일상의 새로운 도전, 데이원과 함께해요",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
              Expanded(flex: 3, child: SizedBox()),
              // "3초만에 시작하기" 버튼
              ElevatedButton(
                child: Text(
                  '3초만에 시작하기 😍',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {},
                style: ButtonStyle(
                  // backgroundColor: MaterialStateProperty.all(Colors.white),
                  surfaceTintColor: MaterialStateProperty.all(Colors.white), // ElevatedButton은 배경색을 적용하여도 tint값과 섞인 색상이 나오게 된다.
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 2, horizontal: 10)),
                  elevation: MaterialStateProperty.all(5), // 그림자 높이 설정
                  shadowColor: MaterialStateProperty.all(Colors.white70), // 그림자 색상 설정
                ),
              ),
              SizedBox(height: 15),
              // 카카오 로그인 버튼
              KakaoLoginButton(
                onPressed: () async {
                  AuthService authService = AuthService();
                  OAuthToken? token = await AuthService().signInWithKakao(context);
                  if (token != null) {
                    await authService.sendTokenToServer(token.accessToken);
                  }
                },
              ),
              SizedBox(height: 15),
              // 애플 로그인 버튼
              appleLoginButton(onPressed: () async {}),
              Expanded(flex: 1, child: SizedBox()),
            ],
          ),
        ),
    );
  }
}