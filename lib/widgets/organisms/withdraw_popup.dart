import 'dart:convert';
import 'package:day1/constants/colors.dart';
import 'package:day1/services/app_database.dart';
import 'package:day1/services/auth_service.dart';
import 'package:day1/services/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../models/token_information.dart';
import 'package:day1/widgets/atoms/radius_text_button.dart';
import 'package:day1/services/auth_provider.dart';
class WithdrawPopup extends ConsumerWidget {
  final String submitReasonText;
  WithdrawPopup({required this.submitReasonText, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final authNotifier = ref.read(authProvider.notifier);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Container(
      width: 312,
      height: 188,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenWidth * 0.032),
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(height: 24),
          Text(
            '회원 탈퇴',
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(height: screenHeight * 0.018),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.042),
            child: Text(
              '회원 탈퇴 시 소중한 기록이 모두 삭제돼요. \n정말로 탈퇴하시겠어요?',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: RadiusTextButton(
                  width: screenWidth * 120,
                  height: screenHeight * 42,
                  backgroudColor: Colors.white,
                  radius: screenWidth * 0.013,
                  text: "더 써볼게요",
                  textColor: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  borderColor: Color(0xFFDEDEDE),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  String? token = await AppDataBase.getToken();
                  if (token != null) {
                    Map<String, dynamic> tokenMap = jsonDecode(token);
                    TokenInformation tokenInfo =
                    TokenInformation.fromJson(tokenMap);
                    if (tokenInfo.oauthType == "KAKAO") {
                      String? response = await DioService.signOutDay1(
                          tokenInfo.oauthType,
                          "",
                          tokenInfo.accessToken,
                          submitReasonText);
                      if (response != null) {
                        DioService.showErrorPopup(context, response);
                        return;
                      }
                      await AuthService.unlinkKakao();
                    } else {
                      AuthorizationCredentialAppleID? appleToken =
                      await AuthService.signInWithApple();
                      if (appleToken != null &&
                          appleToken.authorizationCode != null) {
                        String? response = await DioService.signOutDay1(
                            tokenInfo.oauthType,
                            appleToken.authorizationCode,
                            tokenInfo.accessToken,
                            submitReasonText);
                        if (response != null) {
                          DioService.showErrorPopup(context, response);
                          return;
                        }
                      }
                    }
                    await AppDataBase.clearToken();
                    // 상태 변경을 통한 화면 전환
                    authNotifier.signOut();  // 상태 변경 트리거
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Error"),
                          content: Text(
                              "Cannot perform sign out. Missing OAuth type or token."),
                        ));
                  }
                },
                child: RadiusTextButton(
                  width: screenWidth * 0.32,
                  height: screenHeight * 0.063,
                  backgroudColor: primary,
                  radius: screenWidth * 0.013,
                  text: "떠날게요",
                  textColor: Colors.white,
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}