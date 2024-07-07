import 'dart:convert';

import 'package:day1/constants/colors.dart';
import 'package:day1/services/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../constants/size.dart';
import '../../models/token_information.dart';
import '../../services/server_token_provider.dart';

class SetNotificationScreen extends ConsumerStatefulWidget {
  const SetNotificationScreen({super.key});

  @override
  ConsumerState<SetNotificationScreen> createState() =>
      _SetNotificationScreenState();
}

class _SetNotificationScreenState extends ConsumerState<SetNotificationScreen> {
  bool isService = false;
  bool isNight = false;
  bool isMarketing = false;
  String? token;
  late String accessToken;
  String changeDate = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      token = ref.read(ServerTokenProvider.notifier).getServerToken();
      if (token != null) {
        Map<String, dynamic> tokenMap = jsonDecode(token!);
        TokenInformation tokenInfo = TokenInformation.fromJson(tokenMap);
        accessToken = tokenInfo.accessToken;
        var response = await DioService.getAlarmConfig(tokenInfo.accessToken);
        if (response.toString().contains("Error")) {
          DioService.showErrorPopup(
              context, response.replaceFirst("Error", ""));
        } else {
          changeDate = response.data["marketingReceiveConsentUpdatedAt"] == ""
              ? DateFormat("yyyy.MM.dd").format(DateTime.now())
              : response.data["marketingReceiveConsentUpdatedAt"];
          isService = response.data["serviceAlarm"];
          isNight = response.data["lateNightAlarm"];
          isMarketing = response.data["marketingReceiveConsent"];
        }
      }
      setState(() {});
    });
  }

  void showToast() {
    Fluttertoast.showToast(
      msg:
          "마케팅 정보 수신 " + (isMarketing == true ? "동의" : "해제") + " " + changeDate,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AlertBackGroudColor,
      timeInSecForIosWeb: 3,
      fontSize: cameraScreenAppBarTextSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        title: Text(
          "알림 설정",
          style: TextStyle(
            fontSize: appBarTitleFontSize,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: mypageHorizontalMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              minVerticalPadding: 10,
              title: Text(
                "서비스 알림",
                style: TextStyle(fontSize: 16, color: gray900),
              ),
              trailing: CupertinoSwitch(
                activeColor: primary,
                value: isService,
                onChanged: (value) async {
                  isService = value;
                  String? response =
                      await DioService.setServiceAlarm(isService, accessToken);
                  if (response != null) {
                    DioService.showErrorPopup(context, response);
                  } else {
                    if (value == false) {
                      isNight = value;
                      isMarketing = value;
                      String? responseLate = await DioService.setLateNightAlarm(
                          isNight, accessToken);
                      if (responseLate != null) {
                        DioService.showErrorPopup(context, responseLate);
                      }
                      String? responseMarketing =
                          await DioService.setMarketingAlarm(
                              isMarketing, accessToken);
                      if (responseMarketing != null) {
                        DioService.showErrorPopup(context, responseMarketing);
                      }
                    }
                  }
                  setState(() {});
                },
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              minVerticalPadding: 16,
              title: Text(
                "심야 시간 알림",
                style: TextStyle(
                  fontSize: 16,
                  color: isService == true ? gray900 : gray600,
                ),
              ),
              subtitle: Text(
                "21시~8시에도 알림 수신",
                style: TextStyle(
                  fontSize: 14,
                  color: isService == true ? gray600 : gray300,
                ),
              ),
              trailing: CupertinoSwitch(
                activeColor: primary,
                value: isNight,
                onChanged: (value) async {
                  if (isService == true) {
                    isNight = value;
                    String? response = await DioService.setLateNightAlarm(
                        isNight, accessToken);
                    if (response != null) {
                      DioService.showErrorPopup(context, response);
                    }
                  }
                  setState(() {});
                },
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              minVerticalPadding: 16,
              title: Text(
                "마케팅 수신 동의",
                style: TextStyle(
                  fontSize: 16,
                  color: isService == true ? gray900 : gray600,
                ),
              ),
              subtitle: Text(
                "마케팅 정보 수신 " +
                    (isMarketing == true ? "동의" : "해제") +
                    " : " +
                    changeDate,
                style: TextStyle(
                  fontSize: 14,
                  color: isService == true ? gray600 : gray300,
                ),
              ),
              trailing: CupertinoSwitch(
                activeColor: primary,
                value: isMarketing,
                onChanged: (value) async {
                  if (isService == true) {
                    isMarketing = value;
                    String? response = await DioService.setMarketingAlarm(isMarketing, accessToken);
                    if (response != null) {
                      DioService.showErrorPopup(context, response);
                    }
                    else{
                      changeDate =
                          DateFormat("yyyy.MM.dd").format(DateTime.now());
                      showToast();
                    }
                  }
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
