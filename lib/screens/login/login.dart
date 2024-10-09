import 'dart:convert';
import 'package:day1/constants/colors.dart';
import 'package:day1/models/token_information.dart';
import 'package:day1/services/app_database.dart';
import 'package:day1/services/dio.dart';
import 'package:day1/widgets/atoms/appleLogin_button.dart';
import 'package:day1/widgets/atoms/kakaoLogin_button.dart';
import 'package:day1/widgets/molecules/show_Error_Popup.dart';
import 'package:flutter/material.dart';
import 'package:day1/services/auth_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../services/server_token_provider.dart';

class LoginScreen extends ConsumerWidget {
  final String? initialUrl;

  LoginScreen({Key? key, this.initialUrl}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final oauthProvider = ref.watch(ServerTokenProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // 양쪽 여백 추가
        child: Column(
          children: <Widget>[
            SizedBox(height: 147),  // 상단 여백
            // 텍스트 섹션
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.29,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: "지금 "),
                      TextSpan(
                        text: "데이원",
                        style: TextStyle(
                          color: primary,
                          fontFamily: 'Pretendard',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.29,
                        ),
                      ),
                      TextSpan(text: "과 함께\n사진으로 "),
                      TextSpan(
                        text: "이야기",
                        style: TextStyle(
                          color: primary,
                          fontFamily: 'Pretendard',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.29,
                        ),
                      ),
                      TextSpan(text: "를 담아보세요"),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "일상의 새로운 도전, 데이원과 함께해요",
                  style: TextStyle(color: gray600, fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 60), // 텍스트와 이미지 사이 간격
            // 카메라 이미지 추가 (이미지 크기 조정)
            Container(
              height: 272,
              width: 272,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/camera.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 113), // 이미지와 버튼 사이 간격
            // "3초만에 시작하기" 버튼
            ElevatedButton(
              child: Text(
                '3초만에 시작하기 😍',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: gray900,
                ),
              ),
              onPressed: () {},
              style: ButtonStyle(
                surfaceTintColor: WidgetStateProperty.all(Colors.white),
                padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(vertical: 16, horizontal: 100)),
                elevation: WidgetStateProperty.all(5),
                shadowColor: WidgetStateProperty.all(Colors.white70),
              ),
            ),
            SizedBox(height: 24), // 버튼 사이 간격
            // 카카오 로그인 버튼
            Container(
              width: 358,
              height: 56, // Figma에서 제공된 크기
              child: KakaoLoginButton(
                onPressed: () async {
                  OAuthToken? token = await AuthService.signInWithKakao(context);
                  if (token != null) {
                    String? response = await AuthService.sendTokenToServer(
                        token.accessToken);
                    if (response != null) {
                      if (response.contains("Error")) {
                        DioService.showErrorPopup(context,
                            response.replaceFirst("Error", ""));
                      } else {
                        AppDataBase.setToken(response);
                        oauthProvider.setServerToken(response);
                        Navigator.pushNamed(context, '/camera');
                      }
                    }
                  }
                },
              ),
            ),
            SizedBox(height: 14),
            // 애플 로그인 버튼
            Container(
              width: 358,
              height: 56, // 카카오 로그인 버튼과 동일한 크기
              child: appleLoginButton(
                onPressed: () async {
                  AuthorizationCredentialAppleID? appleToken =
                  await AuthService.signInWithApple();
                  if (appleToken?.identityToken != null) {
                    dynamic response = await DioService.sendAppleTokenToServer(
                        appleToken!.identityToken!);
                    if (response.toString().contains("Error")) {
                      DioService.showErrorPopup(
                          context,
                          response.toString().replaceFirst("Error", ""),
                          navigate: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          });
                    } else {
                      TokenInformation tokenInfo = new TokenInformation(
                          accessToken: response["accessToken"],
                          oauthType: response["oauthType"]);
                      String json = jsonEncode(tokenInfo);
                      AppDataBase.setToken(json);
                      oauthProvider.setServerToken(json);
                      Navigator.pushNamed(context, '/camera');
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}