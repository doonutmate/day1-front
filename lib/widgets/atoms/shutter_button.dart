import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShutterButton extends StatelessWidget {
  void Function () func;
  ShutterButton({required this.func, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
        func();
      },
      icon: SvgPicture.asset("assets/icons/shutter.svg"),
    );
  }
}
