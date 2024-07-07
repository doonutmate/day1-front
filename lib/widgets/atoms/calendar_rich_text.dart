import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/size.dart';

class CalendarRichText extends StatelessWidget {
  int recordNum;
  String? title;

  CalendarRichText({
    required this.recordNum,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: title!,
        style: TextStyle(
            color: gray900,
            fontSize: calendarRichTextSize,
            fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: '에\n총',
        style: TextStyle(
          color: gray900,
          fontSize: calendarRichTextSize,
        ),
      ),
      TextSpan(
        text: ' ${recordNum}번',
        style: TextStyle(
          color: primary,
          fontSize: calendarRichTextSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: '을 기록했어요!',
        style: TextStyle(
          color: gray900,
          fontSize: calendarRichTextSize,
        ),
      ),
    ]));
  }
}
