import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Future<void> LogoutDialog(BuildContext context, VoidCallback onLogout) async {
  return showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(
          '로그아웃',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Text('정말 로그아웃 하시겠습니까?'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
              '취소',
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text(
              '로그아웃',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              onLogout();
              //stack에 쌓여있는 page들을 다 지우고 login 화면 push
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          )
        ],
      );
    },
  );
}
