import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/size.dart';

class CalendarRichText extends StatelessWidget {
  final int recordNum;
  final String? calendarTitle;

  CalendarRichText({
    required this.recordNum,
    required this.calendarTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String displayTitle = (calendarTitle == null || calendarTitle!.isEmpty) ? '한달동안' : '${calendarTitle}';

    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: '$displayTitle',
          style: TextStyle(color: gray900, fontWeight: FontWeight.bold, fontSize: calendarRichTextSize),
        ),
        TextSpan(
          text: '에',
          style: TextStyle(color: gray900, fontSize: calendarRichTextSize),
        ),
        TextSpan(
          text: '\n총',
          style: TextStyle(color: gray900, fontSize: calendarRichTextSize),
        ),
        TextSpan(
          text: ' $recordNum번',
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
          ),
        ),
      ]),
    );
  }
}