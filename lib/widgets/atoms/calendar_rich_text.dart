import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/size.dart';

class CalendarRichText extends StatelessWidget {
  int recordNum;

  CalendarRichText({
    required this.recordNum,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: '한 달 동안\n총',
        style: TextStyle(color: gray900, fontSize: calendarRichTextSize, fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: ' ${recordNum}번',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: primary,
          fontSize: calendarRichTextSize,
        ),
      ),
      TextSpan(
        text: '을 기록했어요!',
        style: TextStyle(
          color: gray900,
          fontSize: calendarRichTextSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]));
  }
}
