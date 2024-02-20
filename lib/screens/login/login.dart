import 'package:day1/widgets/atoms/login_button.dart';
import 'package:flutter/material.dart';
import 'package:day1/services/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  final String? initialUrl;

  LoginScreen({Key? key, this.initialUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                KakaoLoginButton(
                  onPressed: () async {
                    // 로그인 로직만 여기서 호출하기. 나머지 메서드들은 필요한 곳에서 호출하기.
                    await AuthService().signInWithKakao();
                  },
                ),
                TextButton(onPressed: (){
                  Navigator
                      .pushNamed(context, '/main');
                }, child: Text("move to main"))
              ],
            )
        ),
      ),
    );
  }
}
