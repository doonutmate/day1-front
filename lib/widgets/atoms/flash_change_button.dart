import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlashChangeButton extends StatefulWidget {
  CameraController controller;
  FlashChangeButton({required this.controller, super.key});

  @override
  State<FlashChangeButton> createState() => _FlashChangeButtonState();
}

class _FlashChangeButtonState extends State<FlashChangeButton> {
  bool _isFlashOn = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
        setState(() {
          _isFlashOn = !_isFlashOn;
          widget.controller.setFlashMode(
              _isFlashOn ? FlashMode.always : FlashMode.off);
        });
      },
      icon:_isFlashOn ? SvgPicture.asset("assets/icons/flash.svg") : Icon(Icons.flash_off_outlined),
    );
  }
}
