import 'dart:convert';
import 'package:day1/services/app_database.dart';
import 'package:day1/services/device_size_provider.dart';
import 'package:day1/services/dio.dart';
import 'package:day1/services/server_token_provider.dart';
import 'package:day1/widgets/atoms/calendar_rich_text.dart';
import 'package:day1/widgets/molecules/show_Error_Popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../constants/size.dart';
import '../../models/calendar_image_model.dart';
import '../../models/token_information.dart';
import '../../widgets/molecules/report_dialogs.dart';
import '../../widgets/organisms/custom_table_calendar.dart';
import '../../widgets/molecules/custom_bottom_navigation_bar.dart'; // 네비게이션 바 import 추가

class UserCalendarScreen extends ConsumerStatefulWidget {
  final String otherMemberId;
  final String profileImage;
  final String memberName;
  final String calendarName; // 캘린더 이름 추가

  UserCalendarScreen({
    required this.otherMemberId,
    required this.profileImage,
    required this.memberName,
    required this.calendarName, // 캘린더 이름 추가
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserCalendarScreenState();
}

class _UserCalendarScreenState extends ConsumerState<UserCalendarScreen> {
  Map<DateTime, CalendarImage> imageMap = {};
  bool isGetFinish = false;
  late int _year;
  late int _month;
  String? calendarTitle;

  @override
  void initState() {
    super.initState();
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    getCalendarImage(year, month);
  }

  // 서버에서 캘린더 이미지를 불러오는 함수
  Future<void> getCalendarImage(int year, int month) async {
    String? token = ref.read(ServerTokenProvider.notifier).getServerToken();
    List<dynamic>? responseList;

    _year = year;
    _month = month;
    imageMap.clear();

    if (token != null) {
      Map<String, dynamic> tokenMap = jsonDecode(token);
      TokenInformation tokenInfo = TokenInformation.fromJson(tokenMap);

      var response = await DioService.getUserCalendarImageList(year, month, tokenInfo.accessToken, widget.otherMemberId);
      if (response.toString().contains("Error")) {
        showErrorPopup(context, response.replaceFirst("Error", ""));
      } else {
        responseList = response;
      }
      if (responseList == null) {
        showErrorPopup(context, "캘린더 이미지를 불러오는 데 실패했습니다.");
        return;
      }
      for (var item in responseList) {
        CalendarImage calendarImage = CalendarImage.fromJson(item);
        DateTime date = DateTime(_year, _month, item['day']);
        imageMap[date] = calendarImage;
      }
      setState(() {
        isGetFinish = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = ref.watch(deviceSizeProvider.notifier).getDeviceWidth();
    double headerMargin = (deviceWidth - 225) / 2;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.calendarName, // 캘린더 이름을 앱바 제목으로 사용
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => showMoreOptionsDialog(context),
          ),
        ],
      ),
      body: isGetFinish
          ? Padding(
        padding: screenHorizontalMargin,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: calendarTopMargin),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(widget.profileImage),
                ),
                SizedBox(width: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${widget.memberName}',
                        style: TextStyle(color: gray900, fontWeight: FontWeight.bold, fontSize: calendarRichTextSize),
                      ),
                      TextSpan(
                        text: ' 님은',
                        style: TextStyle(color: gray900, fontSize: calendarRichTextSize),
                      ),
                      TextSpan(
                        text: '\n총 ',
                        style: TextStyle(color: gray900, fontSize: calendarRichTextSize),
                      ),
                      TextSpan(
                        text: '${imageMap.length}번',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primary,
                          fontSize: calendarRichTextSize,
                        ),
                      ),
                      TextSpan(
                        text: '을 기록했어요!',
                        style: TextStyle(color: gray900, fontSize: calendarRichTextSize),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            CustomTableCalendar(
              year: _year,
              month: _month,
              headerMargin: headerMargin,
              imageMap: imageMap,
              shifhtMonth: getCalendarImage,
            ),
          ],
        ),
      )
          : Center(child: CircularProgressIndicator())
    );
  }
}