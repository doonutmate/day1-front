import 'package:day1/screens/camera/camera.dart';
import 'package:day1/screens/login/login.dart';
import 'package:day1/services/app_database.dart';
import 'package:day1/services/auth_service.dart';
import 'package:day1/services/oauth_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../main.dart';

class SplashScreen extends ConsumerStatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3)); // 스플래시 화면 지속 시간 설정
    bool isLoggedIn = await AuthService().isLoggedIn(); // 로그인 상태 확인
    String? token = await AppDataBase.getToken(); // 앱 내부 저장소에서 서버 토큰 가져오기

    //카카오 로그인이 유효하고, 앱내부 저장소에 저장한 서버 토큰이 null이 아닐때 카메라 화면으로 전환
    if (isLoggedIn && token != null) {
      //서버 토큰을 provider에 저장
      ref.read(ServerTokenProvider.notifier).setServerToken(token);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => CameraScreen(cameras)));
    } else {
      // 카카오 로그인 무효호 되었거나, 앱내부저장소 토큰이 null일 경우 앱 내부 저장소 초기화 후 로그인 화면으로 전환
      await AppDataBase.clearToken();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              SvgPicture.asset('assets/icons/DAY1.svg'), // 여기에 앱 로고나 이름을 표시
          ],
        ),
      ),
    );
  }
}