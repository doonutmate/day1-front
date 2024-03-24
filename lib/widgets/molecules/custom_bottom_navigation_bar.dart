import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  const CustomBottomNavigationBar({this.selectedIndex = 0, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: selectedIndex == 0 ? SvgPicture.asset("assets/icons/active_calendar_tab.svg") : SvgPicture.asset("assets/icons/inactive_calendar_tab.svg"),
                  label: '캘린더',
                ),
                BottomNavigationBarItem(
                  icon: selectedIndex == 1 ? SvgPicture.asset("assets/icons/active_profile_tab.svg") : SvgPicture.asset("assets/icons/inactive_profile_tab.svg"),
                  label: '마이페이지',
                ),
              ],
              backgroundColor: backGroundColor,
              currentIndex: selectedIndex, // 지정 인덱스로 이동
              selectedItemColor: gray900,
              unselectedItemColor: gray500,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              onTap: onTap, // 선언했던 onItemTapped
            ),
          ),
        ),
        Positioned(
          top: -32,
          child: GestureDetector(
            onTap: (){
              Navigator.of(context, rootNavigator: true)
                  .pushNamed("/camera");
            },
            child: SvgPicture.asset("assets/icons/camera.svg"),
          ),
        ),
      ],
    );
  }
}
