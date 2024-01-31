import 'package:day1/screens/camera/camera.dart';
import 'package:day1/screens/login/login.dart';
import 'package:day1/screens/s_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/main': (context) => MainScreen(),
          '/camera': (context) => CameraScreen(),
        });;
  }
}

