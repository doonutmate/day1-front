import 'dart:convert';
import 'package:day1/constants/colors.dart';
import 'package:day1/models/token_information.dart';
import 'package:day1/services/app_database.dart';
import 'package:day1/services/dio.dart';
import 'package:day1/widgets/atoms/appleLogin_button.dart';
import 'package:day1/widgets/atoms/kakaoLogin_button.dart';
import 'package:flutter/material.dart';
import 'package:day1/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../services/server_token_provider.dart';

class LoginScreen extends ConsumerWidget {
  final String? initialUrl;

  LoginScreen({Key? key, this.initialUrl}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final oauthProvider = ref.watch(ServerTokenProvider.notifier);
    return Scaffold(
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 2, child: SizedBox()),
          // 이미지와 "데이원과 함께해요" 텍스트를 왼쪽 정렬된 별도의 Column으로 묶기
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // SvgPicture.asset('assets/icons/day1Text.svg'),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: "지금 "),
                    TextSpan(text: "데이원", style: TextStyle(color: primary)),
                    TextSpan(text: "과 함께\n사진으로 "),
                    TextSpan(text: "이야기", style: TextStyle(color: primary)),
                    TextSpan(text: "를 담아보세요"),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text(
                "일상의 새로운 도전, 데이원과 함께해요",
                style: TextStyle(color: gray600, fontSize: 18),
              ),
            ],
          ),
          Expanded(flex: 3, child: SizedBox()),
          // "3초만에 시작하기" 버튼
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text(
                  '3초만에 시작하기 😍',
                  style: TextStyle(
                    color: gray900,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {},
                style: ButtonStyle(
                  // backgroundColor: MaterialStateProperty.all(Colors.white),
                  surfaceTintColor: MaterialStateProperty.all(Colors.white),
                  // ElevatedButton은 배경색을 적용하여도 tint값과 섞인 색상이 나오게 된다.
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 2, horizontal: 10)),
                  elevation: MaterialStateProperty.all(5),
                  // 그림자 높이 설정
                  shadowColor:
                      MaterialStateProperty.all(Colors.white70), // 그림자 색상 설정
                ),
              ),
              SizedBox(height: 15),
              // 카카오 로그인 버튼
              Container(
                alignment: Alignment.center,
                child: KakaoLoginButton(
                  onPressed: () async {
                    OAuthToken? token =
                        await AuthService.signInWithKakao(context);
                    if (token != null) {
                      String? response = await AuthService.sendTokenToServer(
                          token.accessToken);
                      if (response != null) {
                        //서버 토큰을 앱 내부 저장소에 저장
                        AppDataBase.setToken(response);
                        //provider에 서버 토큰 저장
                        oauthProvider.setServerToken(response);
                        Navigator.pushNamed(context, '/camera');
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: 15),
              // 애플 로그인 버튼
              Container(
                alignment: Alignment.center,
                child: appleLoginButton(onPressed: () async {
                  AuthorizationCredentialAppleID? appleToken =
                      await AuthService.signInWithApple();
                  if (appleToken?.identityToken != null) {
                    dynamic response = await DioService.sendAppleTokenToServer(
                        appleToken!.identityToken!);
                    //response map 데이터를 TokenInformation 모델 클래스로 변환
                    TokenInformation tokenInfo = new TokenInformation(
                        accessToken: response["accessToken"],
                        oauthType: response["oauthType"]);
                    //acesstoken, oauthType map 자료 json string으로 인코딩
                    String json = jsonEncode(tokenInfo);
                    //서버 토큰을 앱 내부 저장소에 저장
                    AppDataBase.setToken(json);
                    //provider에 서버 토큰 저장
                    oauthProvider.setServerToken(json);
                    Navigator.pushNamed(context, '/camera');
                  }
                }),
              ),
            ],
          ),
          Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}
