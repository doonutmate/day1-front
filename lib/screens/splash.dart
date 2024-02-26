import 'package:day1/screens/camera/camera.dart';
import 'package:day1/screens/login/login.dart';
import 'package:day1/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3)); // 스플래시 화면 지속 시간 설정
    bool isLoggedIn = await AuthService().isLoggedIn(); // 로그인 상태 확인

    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => CameraScreen(cameras)));
    } else {
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
            Text('Day1'), // 여기에 앱 로고나 이름을 표시
            // CircularProgressIndicator(), // 로딩 인디케이터
          ],
        ),
      ),
    );
  }
}