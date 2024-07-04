import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../screens/report_screen.dart';


void showMoreOptionsDialog(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportScreen(),
                ),
              );
            },
            child: Text(
              '신고하기',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            '닫기',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      );
    },
  );
}