import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Future<void> LogoutDialog(BuildContext context, VoidCallback onLogout) async {
  return showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(
          '로그아웃',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            fontFamily: 'Pretendard',
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '정말 로그아웃 하시겠습니까?',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Pretendard',
              color: Color(0xFF222222).withOpacity(0.5),
            ),
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
              '취소',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text(
              '로그아웃',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () {
              onLogout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          )
        ],
      );
    },
  );
}