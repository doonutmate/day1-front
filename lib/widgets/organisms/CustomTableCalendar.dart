import 'package:day1/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../constants/colors.dart';
import '../../models/calendar_image_model.dart';

class CustomTableCalendar extends StatelessWidget {
  CustomTableCalendar(
      {super.key,
      required this.year,
      required this.month,
      required this.headerMargin,
      required this.imageMap,
      required this.shifhtMonth});

  int year;
  int month;
  final double headerMargin;
  final Map<int, CalendarImage> imageMap;
  Future<void> Function(int year, int month) shifhtMonth;

  //원본 이미지 보여주는 함수
  Future<void> showImage(BuildContext context, int day) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        // builder 에서 생성할 위젯
        return Dialog.fullscreen(
          backgroundColor: barrierColor,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CloseButton(
                        color: white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(imageMap[day]!.defaultUrl),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      rowHeight: 66,
      // 한국어 설정
      locale: 'ko-KR',
      //시작 요일을 월요일로 설정
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(fontSize: calendarWeekSize),
          weekendStyle: TextStyle(fontSize: calendarWeekSize)),
      daysOfWeekHeight: 50,
      focusedDay: DateTime(year, month),
      firstDay: DateTime(2024, 1, 1),
      lastDay: DateTime(2034, 12, 31),
      //캘린더 일자영역 스타일 설정
      calendarStyle: const CalendarStyle(
          //당일 날짜 표시하지 않게 설정
          isTodayHighlighted: false,
          //그달에 속하지 않은 날자는 안보이게 처리
          outsideDaysVisible: false,
          cellMargin: EdgeInsets.symmetric(horizontal: 3, vertical: 0)),
      // 캘린더 헤더 영역 스타일 설정
      headerStyle: HeaderStyle(
        titleTextStyle:
            const TextStyle(fontSize: calendarHeaderSize, color: gray900),
        formatButtonVisible: false,
        titleCentered: true,
        headerMargin: EdgeInsets.symmetric(horizontal: headerMargin),
        headerPadding: EdgeInsets.zero,
        leftChevronMargin: const EdgeInsets.all(0),
        rightChevronMargin: const EdgeInsets.all(0),
        leftChevronPadding: const EdgeInsets.all(0),
        rightChevronPadding: const EdgeInsets.all(0),
        leftChevronIcon: SvgPicture.asset("assets/icons/left_arrow.svg"),
        rightChevronIcon: SvgPicture.asset("assets/icons/right_arrow.svg"),
      ),
      onPageChanged: (date) {
        shifhtMonth(date.year, date.month);
        print("${date.year}/${date.month}");
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (imageMap[selectedDay.day]?.defaultUrl != null) {
          showImage(context, selectedDay.day);
        }
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          if (imageMap[(day.day)]?.thumbNailUrl != null) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
              width: thumbnailWidth,
              height: thumbnailWidth,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(imageMap[day.day]!.thumbNailUrl)),
              ),
              child: Text(
                day.day.toString(),
                style: const TextStyle(
                    fontSize: calendarDayFontSize, color: white),
              ),
            );
          } else {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
              width: thumbnailWidth,
              height: thumbnailWidth,
              alignment: Alignment.center,
              child: Text(
                day.day.toString(),
                style: TextStyle(
                  fontSize: calendarDayFontSize,
                ),
              ),
            );
          }
        },

      ),
    );
  }
}
