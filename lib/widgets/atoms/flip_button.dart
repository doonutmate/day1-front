import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlipButton extends StatefulWidget {
  void Function (bool) func;

  FlipButton({required this.func, super.key});

  @override
  State<FlipButton> createState() => _FlipButtonState();
}

class _FlipButtonState extends State<FlipButton> {
  bool _isFrontCamera = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
        setState(() {
          _isFrontCamera = !_isFrontCamera;
          widget.func(_isFrontCamera);
        });
      },
      icon: SvgPicture.asset("assets/icons/flip.svg"),
    );
  }
}
