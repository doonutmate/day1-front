import 'dart:convert';

import 'package:day1/constants/colors.dart';
import 'package:day1/services/app_database.dart';
import 'package:day1/services/auth_service.dart';
import 'package:day1/services/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:day1/providers/submit_reason_provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../constants/size.dart';
import '../../models/token_information.dart';


class WithdrawScreen extends StatefulWidget {
  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  bool showTextField = false;
  String otherReason = '';

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final reason = ref.watch(reasonProvider);

      return Scaffold(
        appBar: AppBar(
          toolbarHeight: appBarHeight,
          title: Text(
            '탈퇴하기',
            style: TextStyle(
              fontSize: appBarTitleFontSize,
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            // 현재 포커스를 해제하여 키보드를 숨깁니다.
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 60), // 버튼 높이만큼 여백을 줍니다.
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 17, top: 20),
                      child: Text(
                        '탈퇴하는 이유가 무엇인가요?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _buildReasonTile(context, ref, '쓰지 않는 앱이에요', ),
                    _buildReasonTile(context, ref, '오류가 생겨서 쓸 수 없어요'),
                    _buildReasonTile(context, ref, '보안이 걱정돼요'),
                    _buildReasonTile(context, ref, '앱 사용법을 모르겠어요'),
                    _buildReasonTile(context, ref, '마음에 안들어요'),
                    ListTile(
                      title: Text('기타',
                          style: TextStyle(
                              color: reason == '기타' ? primary : null)),
                      onTap: () {
                        ref.read(reasonProvider.notifier).state = '기타';
                        setState(() {
                          showTextField = true;
                        });
                      },
                    ),
                    if (showTextField)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          height: 130,
                          width: 358,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                otherReason = value;
                              });
                            },
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: '더 나은 데이원이 될 수 있도록 의견을 들려주세요.',
                              labelStyle: TextStyle(fontSize: 14),
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: gray500),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: (reason != null &&
                            (reason != '기타' || otherReason.isNotEmpty))
                        ? () async {
                            final submitReasonText =
                                reason == '기타' ? otherReason : reason;

                            String? token = await AppDataBase.getToken();

                            if (token != null) {

                              //token 정보 json string 디코딩
                              Map<String, dynamic> tokenMap = jsonDecode(token);
                              //Map 데이터를 모델클래스로 컨버팅
                              TokenInformation tokenInfo = TokenInformation.fromJson(tokenMap);

                              if(tokenInfo.oauthType == "KAKAO"){
                                // 서버에 회원 탈퇴 이유 전송
                                String? response = await DioService.signOutDay1(
                                    tokenInfo.oauthType, "", tokenInfo.accessToken, submitReasonText);
                                if(response != null){
                                  DioService.showErrorPopup(context, response);
                                  return;
                                }
                              }
                              else{
                                AuthorizationCredentialAppleID? appleToken = await AuthService.signInWithApple();
                                if(appleToken != null){
                                  if(appleToken.authorizationCode != null){

                                    // 서버에 회원 탈퇴 이유 전송
                                    String? response = await DioService.signOutDay1(
                                        tokenInfo.oauthType, appleToken.authorizationCode, tokenInfo.accessToken, submitReasonText);
                                    if(response != null){
                                      DioService.showErrorPopup(context, response);
                                      return;
                                    }
                                  }
                                }
                              }
                              AppDataBase.clearToken();
                              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);


                            } else {
                              // 오류 처리, 예: 사용자에게 오류 메시지 표시
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Error"),
                                        content: Text(
                                            "Cannot perform sign out. Missing OAuth type or token."),
                                      ));
                            }
                          }
                        : null,
                    child: Text('탈퇴하기', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: reason != null &&
                              (reason != '기타' || otherReason.isNotEmpty)
                          ? primary
                          : gray300,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  ListTile _buildReasonTile(BuildContext context, WidgetRef ref, String title) {
    final reason = ref.watch(reasonProvider);
    return ListTile(
      title: Text(title,
          style: TextStyle(color: reason == title ? Colors.purple : null)),
      onTap: () {
        ref.read(reasonProvider.notifier).state = title;
        if (title != '기타') {
          setState(() {
            showTextField = false;
            otherReason = '';
          });
        }
      },
    );
  }
}
