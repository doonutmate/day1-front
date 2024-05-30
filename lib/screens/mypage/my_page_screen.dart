import 'dart:convert';
import 'package:day1/constants/size.dart';
import 'package:day1/providers/user_profile_provider.dart';
import 'package:day1/services/app_database.dart';
import 'package:day1/widgets/atoms/moreprofile_button.dart';
import 'package:day1/widgets/molecules/calendar_information.dart';
import 'package:day1/widgets/molecules/service_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:day1/models/user_profile.dart';


class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  void initState() {
    super.initState();
    // 프레임이 렌더링된 후에 실행된 작업을 스케줄링
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? token = await AppDataBase.getToken();

      if (token != null) {
        //token 정보 json string 디코딩
        Map<String, dynamic> tokenMap = jsonDecode(token);

        final userProfile = await fetchUserProfile(tokenMap["accessToken"]);
        ref.read(userProfileProvider.notifier).state = userProfile;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider); // 사용자 프로필 상태 구독

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: mypageHorizontalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: profileRowverticalMargin),
            child: Row(
              children: [
                if (userProfile != null) ...[
                  CircleAvatar(
                    backgroundImage: userProfile.profileImageUrl != ""
                        ? NetworkImage(userProfile.profileImageUrl)
                        : AssetImage('assets/icons/mypage_profile.png')
                            as ImageProvider,
                    radius: 27,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    userProfile.nickname,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  MoreProfileButton()
                ],
              ],
            ),
          ),
          CalendarInformation(),
          SizedBox(height: 32,),
          ServiceInformation(),
        ],
      ),
    );
  }
}
