import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class EditProfileImage extends StatelessWidget {
  ImageProvider profileImage;

  EditProfileImage(ImageProvider this.profileImage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.fill,
                  image: profileImage
              ),
              border: Border.all(color: editProfileBorder)
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: editCameraBorder),
                color: Colors.white
            ),
            child: Image.asset(
              'assets/icons/edit_camera.png',
              width: 20,
              height: 20,
            ),
          ),
        ),
      ],
    );
  }
}
