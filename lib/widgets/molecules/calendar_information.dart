import 'package:day1/constants/colors.dart';
import 'package:day1/constants/size.dart';
import 'package:day1/widgets/atoms/mypage_listtile.dart';
import 'package:flutter/material.dart';

class CalendarInformation extends StatelessWidget {
  const CalendarInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "캘린더 정보",
          style: TextStyle(
            fontSize: mypageGroupTitle,
            color: gray500,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed("/setcalendar");
          },
          child: MypageListTile(text: "캘린더 설정"),
        ),
        GestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed("/setnotification");
          },
          child: MypageListTile(text: "알림 설정"),
        ),
      ],
    );
  }
}
