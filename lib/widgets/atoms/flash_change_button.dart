import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlashChangeButton extends StatefulWidget {
  CameraController controller;
  File? responseImage;
  FlashChangeButton({required this.controller, required this.responseImage, super.key});

  @override
  State<FlashChangeButton> createState() => _FlashChangeButtonState();
}

class _FlashChangeButtonState extends State<FlashChangeButton> {
  bool _isFlashOn = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.responseImage != null ? null : (){
          setState(() {
            _isFlashOn = !_isFlashOn;
            widget.controller.setFlashMode(
                _isFlashOn ? FlashMode.always : FlashMode.off);
          });
      },
      icon:_isFlashOn ? SvgPicture.asset("assets/icons/flash.svg") : SvgPicture.asset("assets/icons/flash_off.svg"),
    );
  }
}
