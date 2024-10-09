import 'dart:io';

import 'package:day1/constants/size.dart';
import 'package:day1/widgets/atoms/radio_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants/colors.dart';

class ShutterButton extends StatelessWidget {
  void Function() shutterFunc;
  File? responseImage;
  late FToast fToast;


  ShutterButton({required this.shutterFunc,
    required this.responseImage,
    super.key});

  void showToast(double width) {
    double leftpadding = (width / 2) - 154;
    fToast.showToast(
      toastDuration: Duration(seconds: 3),
      gravity: ToastGravity.CENTER,
      positionedToastBuilder: (context, child) {
        return Positioned(
          child: child,
          bottom: 74.0,
          left: leftpadding,
        );
      },
      child: RadiusTextButton(
          width: 308,
          height: 39,
          backgroudColor:AlertBackGroudColor,
          radius: 6,
          text: '사진이 맘에 드신다면 저장을 눌러주세요 🙌🏻',
          textColor: Colors.white,
          fontSize: cameraScreenAppBarTextSize
      ),
    );
    /*Fluttertoast.showToast(
      msg: '사진이 맘에 드신다면 저장을 눌러주세요 🙌🏻',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AlertBackGroudColor,
      timeInSecForIosWeb: 3,
      fontSize: cameraScreenAppBarTextSize,
    );*/
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    fToast = FToast();
    fToast.init(context);

    return IconButton(
      iconSize: 72,
      onPressed: responseImage != null
          ? null
          : () {
        shutterFunc();
        //showCameraDialog(context);
        showToast(width);
      },
      icon: SvgPicture.asset("assets/icons/shutter.svg"),
    );
  }
}
