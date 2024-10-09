import 'dart:convert';
import 'package:day1/constants/colors.dart';
import 'package:day1/constants/size.dart';
import 'package:day1/models/calendar_image_model.dart';
import 'package:day1/models/token_information.dart';
import 'package:day1/services/app_database.dart';
import 'package:day1/services/device_size_provider.dart';
import 'package:day1/services/dio.dart';
import 'package:day1/services/server_token_provider.dart';
import 'package:day1/widgets/atoms/calendar_rich_text.dart';
import 'package:day1/widgets/molecules/report_dialogs.dart';
import 'package:day1/widgets/molecules/show_Error_Popup.dart';
import 'package:day1/widgets/organisms/custom_table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UserCalendarScreen extends ConsumerStatefulWidget {
  final int memberId;
  final String profileImage;
  final String memberName;
  final String calendarName;
  final int totalCount;
  final String lastUploadedAt;

  UserCalendarScreen({
    required this.memberId,
    required this.profileImage,
    required this.memberName,
    required this.calendarName,
    required this.totalCount,
    required this.lastUploadedAt,
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

  @override
  void initState() {
    super.initState();
    _year = DateTime.now().year;
    _month = DateTime.now().month;

    if (widget.lastUploadedAt.isNotEmpty) {
      try {
        DateTime lastDate =
            DateFormat('yyyy.MM.dd').parse(widget.lastUploadedAt);
        _year = lastDate.year;
        _month = lastDate.month;
      } catch (e) {
        // 날짜 형식이 잘못되었거나 파싱에 실패한 경우 기본값 사용
        _year = DateTime.now().year;
        _month = DateTime.now().month;
      }
    } else {
      _year = DateTime.now().year;
      _month = DateTime.now().month;
    }

    getCalendarImage(_year, _month);
  }

  Future<void> getCalendarImage(int year, int month) async {
    String? token = ref.read(ServerTokenProvider.notifier).getServerToken();

    if (token == null) {
      showErrorPopup(context, "토큰을 불러오는 데 실패했습니다.");
      return;
    }

    List<dynamic>? responseList;

    _year = year;
    _month = month;
    imageMap.clear();

    Map<String, dynamic> tokenMap = jsonDecode(token);
    TokenInformation tokenInfo = TokenInformation.fromJson(tokenMap);

    print(
        "Fetching calendar images for year: $year, month: $month, member: ${widget.memberId}");

    var response = await DioService.getUserCalendarImageList(
        year, month, tokenInfo.accessToken, widget.memberId.toString());
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
      try{
        CalendarImage calendarImage = CalendarImage.fromJson(item);
        DateTime date =
        DateTime(_year, _month, int.parse(item['day'].toString()));
        imageMap[date] = calendarImage;
      }
      catch(e){
        DioService.showErrorPopup(context, e.toString());
      }
    }

    setState(() {
      isGetFinish = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth =
        ref.watch(deviceSizeProvider.notifier).getDeviceWidth();
    double headerMargin = (deviceWidth - 231) / 2;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: Text(
          widget.calendarName,
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
                        backgroundImage: widget.profileImage != "null" ? NetworkImage(widget.profileImage) : AssetImage("assets/icons/mypage_profile.png") as ImageProvider,
                      ),
                      SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${widget.memberName}',
                              style: TextStyle(
                                  color: gray900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: calendarRichTextSize),
                            ),
                            TextSpan(
                              text: ' 님은',
                              style: TextStyle(
                                  color: gray900,
                                  fontSize: calendarRichTextSize),
                            ),
                            TextSpan(
                              text: '\n총 ',
                              style: TextStyle(
                                  color: gray900,
                                  fontSize: calendarRichTextSize),
                            ),
                            TextSpan(
                              text: '${widget.totalCount}번', // totalCount 사용
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primary,
                                  fontSize: calendarRichTextSize),
                            ),
                            TextSpan(
                              text: '을 기록했어요!',
                              style: TextStyle(
                                  color: gray900,
                                  fontSize: calendarRichTextSize),
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
          : Center(child: CircularProgressIndicator()),
    );
  }
}
