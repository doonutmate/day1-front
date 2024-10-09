import 'dart:convert';
import 'package:day1/constants/colors.dart';
import 'package:day1/services/app_database.dart';
import 'package:day1/services/auth_service.dart';
import 'package:day1/services/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:day1/providers/submit_reason_provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../constants/size.dart';
import '../../models/token_information.dart';
import '../../widgets/organisms/withdraw_popup.dart';

class WithdrawScreen extends StatefulWidget {
  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  bool showTextField = false;
  String otherReason = '';

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Consumer(builder: (context, ref, _) {
      final reason = ref.watch(reasonProvider);

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: backGroundColor,
          toolbarHeight: appBarHeight,
          title: Text(
            '탈퇴하기',
            style: TextStyle(
              fontSize: 18,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500
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
                padding: EdgeInsets.only(bottom: 60),
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
                    _buildReasonTile(context, ref, '쓰지 않는 앱이에요'),
                    _buildReasonTile(context, ref, '오류가 생겨서 쓸 수 없어요'),
                    _buildReasonTile(context, ref, '보안이 걱정돼요'),
                    _buildReasonTile(context, ref, '앱 사용법을 모르겠어요'),
                    _buildReasonTile(context, ref, '마음에 안들어요'),
                    ListTile(
                      title: Text('기타',
                          style: TextStyle(
                              color: reason == '기타' ? primary : null,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            height: 1.5,)),
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
                    SizedBox(height: 289),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: (reason != null && (reason != '기타' || otherReason.isNotEmpty))
                        ? () {
                      final submitReasonText = reason == '기타' ? otherReason : reason;

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.transparent,
                          contentPadding: EdgeInsets.zero,
                          content: WithdrawPopup(submitReasonText: submitReasonText),
                        ),
                      );
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