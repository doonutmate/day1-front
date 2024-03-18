import 'package:day1/providers/user_profile_provider.dart';
import 'package:day1/screens/mypage/withdraw_screen.dart';
import 'package:day1/services/auth_service.dart';
import 'package:day1/widgets/atoms/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:day1/models/user_profile.dart';
import 'package:day1/widgets/atoms/logout_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:day1/constants/colors.dart';


class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  void initState() {
    super.initState();
    // 프레임이 렌더링된 후에 실행된 작업을 스케줄링
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      final userProfile = await fetchUserProfile();
      ref.read(userProfileProvider.notifier).state = userProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider); // 사용자 프로필 상태 구독

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 17, top: 35, bottom: 30),
          child: Row(
            children: [
              if (userProfile != null) ...[
                CircleAvatar(
                  backgroundImage: NetworkImage(userProfile.profileImageUrl),
                  radius: 54,
                ),
                SizedBox(
                  width: 14,
                ),
                Text(
                  userProfile.nickname,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                )
              ],
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 17),
          child: Text(
            '서비스 정보',
            style: TextStyle(
              color: gray500,
              fontSize: 14,
            ),
          ),
        ),
        ListTile(
          title: Text('서비스 이용약관',style: TextStyle(
            fontSize: 16
          ),),
          onTap: () async{
            final url= Uri.parse(
                'https://gkswnsgur.notion.site/Day1-8b4b1f86f61c4cc0a5bc8a83c8543479?pvs=4'
            );
            if(await canLaunchUrl(url)) {
              launchUrl(url);
            } else {
              print("Can't lanch $url");
            }
          },
        ),
        ListTile(
          title: Text('개인정보 처리방침',style: TextStyle(
              fontSize: 16
          ),),
          onTap: () async{
            final url= Uri.parse(
                'https://gkswnsgur.notion.site/Day1-1621c491c6c94b8180fe321659a08803?pvs=4'
            );
            if(await canLaunchUrl(url)) {
              launchUrl(url);
            } else {
              print("Can't lanch $url");
            }
          },
        ),
        ListTile(
          title: Text('로그아웃',style: TextStyle(
              fontSize: 16
          ),),
          onTap: () {
            LogoutDialog(context, () {
              AuthService.logout();
            });
          },
        ),
        ListTile(
          title: Text('탈퇴하기',style: TextStyle(
              fontSize: 16
          ),),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WithdrawScreen()),);
          },
        )
      ],
    );
  }
}
