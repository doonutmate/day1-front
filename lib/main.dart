import 'package:camera/camera.dart';
import 'package:day1/screens/camera/camera.dart';
import 'package:day1/screens/login/login.dart';
import 'package:day1/screens/s_main.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late List<CameraDescription> cameras;

Future<void> main() async{
  // 다음에 호출되는 함수 모두 실행 끝날 때까지 기다림
  WidgetsFlutterBinding.ensureInitialized();

  //언어 설정을 위한 함수 실행
  await initializeDateFormatting();


  // 기기에서 사용 가능한 카메라 목록 불러오기
  cameras = await availableCameras();

  runApp(ProviderScope(child : const MyApp()));
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
          '/camera': (context) => CameraScreen(cameras),
        });;
  }
}

