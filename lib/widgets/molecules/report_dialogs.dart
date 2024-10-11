import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../screens/report_screen.dart';

void showMoreOptionsDialog(BuildContext context) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: [
          SizedBox(
            height: 61,
            child: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportScreen(),
                  ),
                );
              },
              child: Container(
                width: 377,
                height: 61,
                alignment: Alignment.center,
                child: Text(
                  '신고하기',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
        cancelButton: SizedBox(
          height: 61,
          child: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 377,
              height: 61,
              alignment: Alignment.center,
              child: Text(
                '닫기',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      );
    },
    barrierColor: Colors.black.withOpacity(0.5),
  );
}