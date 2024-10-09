import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      backgroundColor: Colors.transparent,
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
              child: Container(),
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Image.network(imageMap[day]!.defaultUrl, loadingBuilder: (context, child, loadingProgress){
                  // 만약에 로딩이 끝났다면 (loadingProgress == null)
                  // 아래의 위젯을 반환한다.
                  if (loadingProgress == null) {
                    return child;
                  }
                  // 만약에 로딩중이라면 (loadingProgress != null)
                  // 아래의 위젯을 반환한다.
                  else {
                    return AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        color: Color(0xFFD9D9D9),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/icons/skeleton_img.png",width: 60, height: 60,),
                            SizedBox(height: 20,),
                            Text(
                              "이미지를 못 불러왔어요\n잠시 후 다시 시도해주세요",
                              style: TextStyle(
                                color: gray600,
                                fontSize: 18,
                              ),

                            )
                          ],
                        ),
                      ),
                    );
                  }
                }),
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
                Positioned(
                  left: 10,
                  top: 10,
                  child: CloseButton(
                    color: white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
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
