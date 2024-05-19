import 'package:day1/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/size.dart';

class SetNotificationScreen extends StatefulWidget {
  const SetNotificationScreen({super.key});

  @override
  State<SetNotificationScreen> createState() => _SetNotificationScreenState();
}

class _SetNotificationScreenState extends State<SetNotificationScreen> {
  bool isService = false;
  bool isNight = false;
  bool isMarketing = false;
  late String changeDate;

  @override
  void initState() {
    super.initState();
    //추후에 앱데이터베이스에 저장된 값이 있으면 저장된 값 저장하고, 없으면 오늘 날짜 집어넣는 로직 추가
    changeDate = DateFormat("yyyy.MM.dd").format(DateTime.now());
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
                style: TextStyle(
                  fontSize: 16,
                  color: gray900
                ),
              ),
              trailing: CupertinoSwitch(
                activeColor: primary,
                value: isService,
                onChanged: (value){
                  setState(() {
                    isService = value;
                    if(value == false){
                      isNight = value;
                      isMarketing =value;
                    }
                  });
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
                onChanged: (value){
                  setState(() {
                    if(isService == true)
                      isNight = value;
                  });
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
                "마케팅 정보 수신 " + (isMarketing == true ? "동의" : "해제") + " : " + changeDate,
                style: TextStyle(
                  fontSize: 14,
                  color: isService == true ? gray600 : gray300,
                ),
              ),
              trailing: CupertinoSwitch(
                activeColor: primary,
                value: isMarketing,
                onChanged: (value){
                  setState(() {
                    if(isService == true)
                      {
                        isMarketing = value;
                        //추후에 앱데이터베이스에 동의 유무 및 날짜 저장하는 로직 추가
                        changeDate = DateFormat("yyyy.MM.dd").format(DateTime.now());
                      }

                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
