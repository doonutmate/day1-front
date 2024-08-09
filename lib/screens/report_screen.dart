import 'dart:convert';

import 'package:day1/constants/colors.dart';
import 'package:day1/services/app_database.dart';
import 'package:day1/services/auth_service.dart';
import 'package:day1/services/dio.dart';
import 'package:day1/widgets/molecules/show_Error_Popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:day1/providers/submit_reason_provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../constants/size.dart';
import '../../models/token_information.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool showTextField = false;
  String otherReason = '';
  bool isValidOtherReason = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final reason = ref.watch(reasonProvider);

      return Scaffold(
        appBar: AppBar(
          toolbarHeight: appBarHeight,
          title: Text(
            '신고하기',
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
                        '신고하는 이유가 무엇인가요?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _buildReasonTile(context, ref, '유해정보 및 음란성 사진이에요'),
                    _buildReasonTile(context, ref, '불법정보를 포함하고 있어요'),
                    _buildReasonTile(context, ref, '욕설/혐오/차별적 표현이 있어요'),
                    _buildReasonTile(context, ref, '개인정보 노출 사진이에요'),
                    ListTile(
                      title: Text('기타',
                          style: TextStyle(
                              color: reason == '기타' ? primary : null)),
                      onTap: () {
                        ref.read(reasonProvider.notifier).state = '기타';
                        setState(() {
                          showTextField = true;
                          isValidOtherReason = otherReason.length >= 10 && otherReason.length <= 200;
                        });
                      },
                    ),
                    if (showTextField)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          height: 130,
                          width: 358,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                otherReason = value;
                                isValidOtherReason = value.length >= 10 && value.length <= 200;
                              });
                            },
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: '신고 내용을 입력해주세요.',
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
                    onPressed: (reason != null && (reason != '기타' || isValidOtherReason))
                        ? () async {
                      final submitReasonText = reason == '기타' ? otherReason : reason;

                      String? token = await AppDataBase.getToken();

                      if (token != null) {
                        Map<String, dynamic> tokenMap = jsonDecode(token);
                        TokenInformation tokenInfo = TokenInformation.fromJson(tokenMap);

                        String? response;
                        if (tokenInfo.oauthType == "KAKAO") {
                          response = await DioService.reportIssue(tokenInfo.oauthType, "", tokenInfo.accessToken, submitReasonText);
                        } else {
                          AuthorizationCredentialAppleID? appleToken = await AuthService.signInWithApple();
                          if (appleToken != null && appleToken.authorizationCode != null) {
                            response = await DioService.reportIssue(tokenInfo.oauthType, appleToken.authorizationCode, tokenInfo.accessToken, submitReasonText);
                          }
                        }

                        if (response != null) {
                          showErrorPopup(context, response);
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(
                              child: Text("신고가 정상적으로 완료되었어요", style: TextStyle(fontSize: 16),),),
                            duration: Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(bottom: 20, left: 60, right: 60),
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10), // padding을 줄여서 크기 조정
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        );
                        Navigator.popAndPushNamed(context, '/main');
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Error"),
                            content: Text("Cannot perform sign out. Missing OAuth type or token."),
                          ),
                        );
                      }
                    }
                        : null,
                    child: Text('신고하기', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: reason != null && (reason != '기타' || isValidOtherReason) ? primary : gray300,
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
          style: TextStyle(color: reason == title ? primary : null)),
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