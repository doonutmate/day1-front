import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/size.dart';
import '../../screens/camera/camera.dart';

class ReshootTextButton extends StatelessWidget {
  void Function() func;
  ReshootTextButton({
    required this.func,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final parent = context.findAncestorStateOfType<CameraScreenState>();
    return TextButton(
      onPressed: (){
        func();
      },
      child: Text(
        "다시찍기",
        style: TextStyle(
            fontSize: cameraScreenTextSize,
            color: textButtonColor
        ),
      ),
    );
  }
}