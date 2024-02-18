import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/size.dart';
import '../../screens/camera/camera.dart';
import '../../services/dio.dart';

class StoreTextButton extends StatelessWidget {
  const StoreTextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final parent = context.findAncestorStateOfType<CameraScreenState>();
    return TextButton(
      onPressed: (){
        if(parent != null && parent.responseImage != null)
        DioService.uploadImage(parent!.responseImage!);
      },
      child: Text(
        "저장",
        style: TextStyle(
            fontSize: cameraScreenTextSize,
            color: textButtonColor
        ),
      ),
    );
  }
}