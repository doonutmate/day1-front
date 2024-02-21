import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:day1/services/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KakaoLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  KakaoLoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SvgPicture.asset('assets/icons/kakao_login.svg'),
    );
  }
}
