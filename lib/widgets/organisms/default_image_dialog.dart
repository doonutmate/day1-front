import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../models/calendar_image_model.dart';

class DefaultImageDialog extends StatelessWidget {
  DefaultImageDialog({
    super.key,
    required this.imageMap,
    required this.day
  });

  final Map<DateTime, CalendarImage> imageMap;
  DateTime day;
  String pictureDay = "";
  String pictureDayOfWeek = "";
  String pictureTime = "";
  String pictureAMPM = "";

  void convertTime(){
    DateTime date = DateTime.parse(imageMap[day]!.date);
    pictureDay = DateFormat("yyyy.MM.dd").format(date) + "일";
    pictureDayOfWeek = "(" + DateFormat('E', 'ko_KR').format(date) + ")";
    pictureAMPM =
    DateFormat('aa', 'ko_KR').format(date) == "AM" ? "오전" : "오후";
    pictureTime = DateFormat('hh:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    convertTime();
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
            child: Stack(
              children: [
                Image.network(imageMap[day]!.defaultUrl),
                Positioned(
                  left: 30,
                  bottom: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pictureDay + " " + pictureDayOfWeek,
                        style: TextStyle(
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: gray600,
                                offset: Offset(0, 3),
                              ),
                            ],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: white),
                      ),
                      Text(
                        pictureAMPM + " " + pictureTime,
                        style: TextStyle(
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: gray600,
                                offset: Offset(0, 3),
                              ),
                            ],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: white),
                      )
                    ],
                  ),
                ),
              ],
            ),
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
  }
}
