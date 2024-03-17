import 'package:day1/services/device_size_provider.dart';
import 'package:day1/services/dio.dart';
import 'package:day1/services/server_token_provider.dart';
import 'package:day1/widgets/atoms/calendar_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../constants/size.dart';
import '../models/calendar_image_model.dart';
import '../services/auth_service.dart';
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

  // 서버에서 캘린더 이미지를 불러오는 함수
  Future<void> getCalendarImage(int year, int month) async {
    //provider에서 서버 토큰 get
    String? token = ref.read(ServerTokenProvider.notifier).getServerToken();

    _year = year;
    _month = month;
    imageMap.clear();

    if(token != null){
      // 캘린더 api 함수
      List<dynamic> responseList = await DioService.getImageList(year, month, token);
      // day는 imageMap<Map>의 키로 사용하고 value로는 썸네일 이미지와 원본이미지를 멤버로 갖고 있는 CalendarImage 모델 클래스로 사용
      responseList.forEach((element) {
        imageMap[element['day']] = CalendarImage(thumbNailUrl: element['thumbNailUrl'], defaultUrl: element['defaultUrl']);
      });
      setState(() {
        // 통신이 끝났는지 플래그값 설정
        isGetFinish = true;
        print("response success");
      });
    }
    else{
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }

  }

  @override
  Widget build(BuildContext context) {

    void initState() {
      super.initState();
      // 프레임이 렌더링된 후에 실행된 작업을 스케줄링
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AuthService.requestUserInfo(ref);
      });
    }

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
          //서버에서 사진을 저장한 일자대로 리스트를 넘겨주므로 리스트의 길이를 매개변수로 넘겨준다
          CalendarRichText(recordNum: imageMap.length,),
          // dio 통신 응답 받기전 예외 처리
          isGetFinish == false ? Center(child: CircularProgressIndicator()) :
          CustomTableCalendar(year: _year, month: _month, headerMargin: headerMargin, imageMap: imageMap, shifhtMonth: getCalendarImage,),
        ],
      ),
    );
  }
}


