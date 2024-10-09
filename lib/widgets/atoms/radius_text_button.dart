import 'package:flutter/material.dart';

class RadiusTextButton extends StatelessWidget {
  double width;
  double height;
  Color backgroudColor;
  double radius;
  String text;
  Color textColor;
  double fontSize;
  FontWeight fontWeight;
  Color borderColor;

  RadiusTextButton({
    this.width = double.infinity,
    required this.height,
    required this.backgroudColor,
    required this.radius,
    required this.text,
    required this.textColor,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    super.key,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: backgroudColor,
          border: Border.all(color: borderColor, width: 1.0)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
