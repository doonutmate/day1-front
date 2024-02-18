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
        Navigator.of(context, rootNavigator: true).pop();
      },
      child: Text(
        "취소",
        style: TextStyle(
            fontSize: cameraScreenTextSize,
            color: textButtonColor
        ),
      ),
    );
  }
}