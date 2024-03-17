import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
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
  }
}
