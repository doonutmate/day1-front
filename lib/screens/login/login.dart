import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("login"),
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
