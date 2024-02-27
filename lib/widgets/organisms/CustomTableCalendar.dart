import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../constants/colors.dart';
import '../../models/calendar_image_model.dart';

class CustomTableCalendar extends StatelessWidget {
  CustomTableCalendar({
    super.key,
    required this.year,
    required this.month,
    required this.headerMargin,
    required this.imageMap,
    required this.shifhtMonth
  });

  int year;
  int month;
  final double headerMargin;
  final Map<int, CalendarImage> imageMap;
  Future<void> Function(int year, int month) shifhtMonth;


  //원본 이미지 보여주는 함수
  Future<void> showImage(BuildContext context, int day) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        // builder 에서 생성할 위젯
        return Dialog.fullscreen(
          backgroundColor: barrierColor,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: CloseButton(
                  color: white,
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ),
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(imageMap[day]!.defaultUrl),
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
      calendarStyle: const CalendarStyle(
        isTodayHighlighted: false,
        defaultTextStyle: TextStyle(fontSize: 16),
        weekendTextStyle: TextStyle(fontSize: 16),
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        headerMargin: EdgeInsets.symmetric(horizontal: headerMargin),
        leftChevronMargin: const EdgeInsets.all(0),
        rightChevronMargin: const EdgeInsets.all(0),
        leftChevronPadding: const EdgeInsets.all(0),
        rightChevronPadding: const EdgeInsets.all(0),
      ),
      onPageChanged: (date){
        shifhtMonth(date.year,date.month);
        print("${date.year}/${date.month}");
      },
      onDaySelected: (selectedDay, focusedDay){
        if(imageMap[selectedDay.day]?.defaultUrl != null){
          showImage(context, selectedDay.day);
        }
      },
      calendarBuilders:
      CalendarBuilders(defaultBuilder: (context, day, focusedDay) {
        if (imageMap[(day.day)]?.thumbNailUrl != null ) {
          return Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(imageMap[day.day]!.thumbNailUrl)),
            ),
            child: Text(
              day.day.toString(),
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          );
        }
        else {
          return Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            child: Text(
              day.day.toString(),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          );
        }
      }),
      locale: 'ko-KR',
      startingDayOfWeek: StartingDayOfWeek.monday,
      focusedDay: DateTime(year, month),
      firstDay: DateTime(2024, 1, 1),
      lastDay: DateTime(2034, 12, 31),
    );
  }
}