import 'package:day1/services/device_size_provider.dart';
import 'package:day1/services/dio.dart';
import 'package:day1/widgets/atoms/calendar_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../constants/size.dart';
import '../models/calendar_image_model.dart';
import '../widgets/organisms/CustomTableCalendar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  Map<int, CalendarImage> imageMap = {};
  bool isGetFinish = false;
  late int _year;
  late int _month;
  @override
  void initState() {
    super.initState();

    int year = DateTime.now().year;
    int month = DateTime.now().month;
    getCalendarImage(year, month);
  }

  Future<void> getCalendarImage(int year, int month) async {
    _year = year;
    _month = month;
    imageMap.clear();

    List<dynamic> responseList = await DioService.getImageList(year, month);
    responseList.forEach((element) {
      imageMap[element['day']] = CalendarImage(thumbNailUrl: element['thumbNailUrl'], defaultUrl: element['defaultUrl']);
    });
    setState(() {
      isGetFinish = true;
      print("response success");
    });
  }

  @override
  Widget build(BuildContext context) {
    // provider에서 실제 화면 width get
    double deviceWidth = ref.watch(deviceSizeProvider.notifier).getDeviceWidth();
    // calendar headermargin 크기
    double headerMargin = (deviceWidth - 213) / 2;

    return Padding(
      padding: screenHorizontalMargin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
          ),
          CalendarRichText(recordNum: imageMap.length,),
          // dio 통신 응답 받기전 예외 처리
          isGetFinish == false ? Center(child: CircularProgressIndicator()) :
          CustomTableCalendar(year: _year, month: _month, headerMargin: headerMargin, imageMap: imageMap, shifhtMonth: getCalendarImage,),
        ],
      ),
    );
  }
}


