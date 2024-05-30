import 'package:day1/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/app_database.dart';
import '../atoms/logout_dialog.dart';
import '../atoms/mypage_listtile.dart';

class ServiceInformation extends StatelessWidget {
  const ServiceInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "서비스 정보",
          style: TextStyle(
            fontSize: 14,
            color: gray500,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        MypageListTile(
          text: '서비스 이용약관',
          func: () async {
            final url = Uri.parse(
                'https://gkswnsgur.notion.site/Day1-8b4b1f86f61c4cc0a5bc8a83c8543479?pvs=4');
            if (await canLaunchUrl(url)) {
              launchUrl(url);
            } else {
              print("Can't lanch $url");
            }
          },
        ),
        MypageListTile(
          text: '개인정보 처리방침',
          func: () async {
            final url = Uri.parse(
                'https://gkswnsgur.notion.site/Day1-1621c491c6c94b8180fe321659a08803?pvs=4');
            if (await canLaunchUrl(url)) {
              launchUrl(url);
            } else {
              print("Can't lanch $url");
            }
          },
        ),
        MypageListTile(
          text: '로그아웃',
          func: () {
            LogoutDialog(context, () {
              AppDataBase.clearToken();
            });
          },
        ),
        MypageListTile(
          text: '탈퇴하기',
          func: () {
            Navigator.of(context).pushNamed("/withdraw");
          },
        ),
      ],
    );
  }
}
