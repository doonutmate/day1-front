import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants/colors.dart';

class ShutterButton extends StatelessWidget {
  void Function() shutterFunc;
  File? responseImage;


  ShutterButton(
      {required this.shutterFunc, required this.responseImage, super.key});


  void showToast() {
    Fluttertoast.showToast(
      msg: '사진이 맘에 드신다면 저장을 눌러주세요 🙌🏻',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AlertBackGroudColor,
      timeInSecForIosWeb: 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: responseImage != null ? null : () {
          shutterFunc();
          showToast();
      },
      icon: SvgPicture.asset("assets/icons/shutter.svg"),
    );
  }
}
