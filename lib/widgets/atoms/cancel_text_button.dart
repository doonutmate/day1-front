import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/size.dart';

class CancelTextButton extends StatelessWidget {
  const CancelTextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (){
        //Navigator.of(context, rootNavigator: true).pop();
        //Navigator.pushNamedAndRemoveUntil(context ,'/calendar', ModalRoute.withName('/'));
        Navigator.pushNamedAndRemoveUntil(context ,'/main', ModalRoute.withName('/login'));
      },
      child: Text(
        "취소",
        style: TextStyle(
            fontSize: cameraScreenAppBarTextSize,
            color: textButtonColor
        ),
      ),
    );
  }
}