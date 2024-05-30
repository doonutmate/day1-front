import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class MoreProfileButton extends StatelessWidget {
  const MoreProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context)
            .pushNamed("/changeprofile");
      },
      child: Container(
        width: 72,
        height: 34,
        decoration: BoxDecoration(
          color: profileMoreButton,
          borderRadius: BorderRadius.circular(4)
        ),
        alignment: Alignment.center,
        child: Text(
          "프로필 수정",
          style: TextStyle(
            fontSize: 12,
            color: primary,
          ),
        ),
      ),
    );
  }
}
