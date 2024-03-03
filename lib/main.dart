import 'package:camera/camera.dart';
import 'package:day1/screens/camera/camera.dart';
import 'package:day1/screens/login/login.dart';
import 'package:day1/screens/s_main.dart';
import 'package:day1/services/app_database.dart';
import 'package:day1/services/auth_service.dart';
import 'package:day1/services/server_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_common.dart';
import 'dart:async';
import 'package:uni_links/uni_links.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  // 다음에 호출되는 함수 모두 실행 끝날 때까지 기다림
  WidgetsFlutterBinding.ensureInitialized();

  //언어 설정을 위한 함수 실행
  await initializeDateFormatting();


  // 기기에서 사용 가능한 카메라 목록 불러오기
  cameras = await availableCameras();

  // 초기 URL 받기
  String? initialUrl;
  try {
    initialUrl = await getInitialLink();
  } catch (e) {
    // 초기 URL 받기 실패 처리
    print("Failed to get initial link: $e");
  }

  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '96d13b457170f00f736d874770b66f84',
    javaScriptAppKey: '27d258fa70f6d2fd19c92fe135ed0bda',
  );


  // ProviderScope 이하의 위젯에서 provider 사용 가능
  runApp(ProviderScope(child : MyApp(initialUrl: initialUrl)));
}

class MyApp extends ConsumerWidget {
  final String? initialUrl;
  String? token;
  MyApp({super.key, this.initialUrl});

  // 앱내 저장소에서 저장된 토큰을 가져오고 프로바이더에 저장 후 카카오 로그인 유효한지 확인
  Future<bool> getToken(ServerTokenStateNotifier provider) async{
    token = await AppDataBase.getToken();
    provider.setServerToken(token);
    bool result = await AuthService.isLoggedIn();
    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ServerTokenStateNotifier tokenProvider = ref.read(ServerTokenProvider.notifier);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: getToken(tokenProvider),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData && snapshot.data == true && token != null) {
                return CameraScreen(cameras);
            } else {
              return LoginScreen();
            }
          }),
      routes: {
        '/login': (context) => LoginScreen(),
        '/main': (context) => MainScreen(),
        '/camera': (context) => CameraScreen(cameras),
      },
    );
  }
}

