import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:day1/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/atoms/radius_text_button.dart';

class Permision extends StatefulWidget {
  const Permision({super.key});

  @override
  State<Permision> createState() => _PermisionState();
}

class _PermisionState extends State<Permision> {
  String _authStatus = 'Unknown';

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
                'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
                'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      );

  Future<void> initPlugin() async {
    try {
      final TrackingStatus status =
      await AppTrackingTransparency.trackingAuthorizationStatus;
      setState(() => _authStatus = '$status');
      if (status == TrackingStatus.notDetermined) {

        // Show a custom explainer dialog before the system dialog
        //await showCustomTrackingDialog(context);
        // Wait for dialog popping animation
        await Future.delayed(const Duration(milliseconds: 200));
        print("requestTracking1");
        // Request system's tracking authorization dialog

        final TrackingStatus status =
        await AppTrackingTransparency.requestTrackingAuthorization();
        setState(() => _authStatus = '$status');
      }
    } on PlatformException {
      setState(() {
        _authStatus = 'PlatformException was thrown';
      });
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initPlugin());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 79,
            ),
            Text(
              "원활한 Day1 이용을 위해\n아래의 접근 권한을 받고 있어요",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              "필수 접근 권한",
              style: TextStyle(
                color: primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 32),
              Text(
                "필수 접근 권한",
                style: TextStyle(
                  color: primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    child: SvgPicture.asset("assets/icons/icn_camera_28_on.svg"),
                    backgroundColor: gray200,
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "카메라",
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "기록 시 사진 첨부",
                        style: TextStyle(fontSize: 16, color: gray600),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 32),
              Text(
                "선택 접근 권한",
                style: TextStyle(fontSize: 18, color: gray500),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    child: SvgPicture.asset("assets/icons/icn_gallery_28.svg"),
                    backgroundColor: gray200,
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "갤러리",
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "프로필",
                        style: TextStyle(fontSize: 16, color: gray600),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    child: SvgPicture.asset("assets/icons/icn_alarm_28.svg"),
                    backgroundColor: gray200,
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "알림",
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "푸시 알림 수신",
                        style: TextStyle(fontSize: 16, color: gray600),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 64),
              Divider(color: Color(0xFFEDEDED)),
              SizedBox(height: 32),
              Text(
                "· 서비스 제공에 접근 권한이 필요한 경우에만 동의를 받고 있으며, 허용하지 않아도 Day1 이용이 가능해요.",
                style: TextStyle(fontSize: 14, color: gray600),
              ),
              SizedBox(height: 8),
              Text(
                "· 선택 항목은 관련 정보와 기능에 접근할 때, 권한 허용 및 거부를 할 수 있어요.",
                style: TextStyle(fontSize: 14, color: gray600),
              ),
              SizedBox(height: 50), // Spacer 대신 SizedBox 사용
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/login");
                },
                child: RadiusTextButton(
                  height: 48,
                  backgroudColor: primary,
                  radius: 4,
                  text: "확인",
                  textColor: white,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 50), // 아래 여백 추가
            ],
          ),
        ),
      ),
    );
  }
}