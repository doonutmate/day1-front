import 'dart:io';
import 'package:flutter/material.dart';
import 'package:day1/services/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class appleLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  appleLoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SvgPicture.asset('assets/icons/apple_login.svg'),
    );
  }
}
