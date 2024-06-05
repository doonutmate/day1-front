import 'dart:io';

import 'package:camera/camera.dart';
import 'package:day1/screens/camera/camera.dart';
import 'package:day1/screens/login/login.dart';
import 'package:day1/screens/mypage/change_profile_screen.dart';
import 'package:day1/screens/mypage/set_calendar_screen.dart';
import 'package:day1/screens/mypage/set_notification_screen.dart';
import 'package:day1/screens/mypage/withdraw_screen.dart';
import 'package:day1/screens/s_main.dart';
import 'package:day1/services/app_database.dart';
import 'package:day1/services/auth_service.dart';
import 'package:day1/services/server_token_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_common.dart';
import 'dart:async';
import 'package:uni_links/uni_links.dart';
import 'firebase_options.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

late List<CameraDescription> cameras;

Future<void> main() async {
  // 다음에 호출되는 함수 모두 실행 끝날 때까지 기다림
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  //언어 설정을 위한 함수 실행
  await initializeDateFormatting();

  //firbase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


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
    bool isKaKao = false;
    bool isServerToken = false;
    bool result = false;

    //카카오 로그인이 유효한지 확인
    isKaKao = await AuthService.isLoggedIn();
    //앱내부에 저장된 token 정보 가져오기
    token = await AppDataBase.getToken();
    //토큰이 있는지 확인하고 플래그값 설정
    isServerToken = token != null ? true : false;

    // 카카오 로그인 확인은 부차적으로 확인해주고 사실상 서버 토큰이 있는지가 중요
    result = isKaKao || isServerToken;

    if(result == true){
      provider.setServerToken(token);
    }
    else{
      AppDataBase.clearToken();
    }

    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ServerTokenStateNotifier tokenProvider = ref.read(ServerTokenProvider.notifier);
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      //기본 폰트 설정
      theme: ThemeData(
        fontFamily: "Pretendard",
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.black.withOpacity(0)),
      ),
      home: FutureBuilder(
          future: getToken(tokenProvider),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
                return CameraScreen(cameras);
            } else {
              return LoginScreen();
            }
          }),
      routes: {
        '/login': (context) => LoginScreen(),
        '/main': (context) => MainScreen(),
        '/camera': (context) => CameraScreen(cameras),
        '/withdraw' : (context) => WithdrawScreen(),
        '/changeprofile' : (context) => ChangeProfileScreen(),
        '/setcalendar' : (context) => SetCalendarScreen(),
        '/setnotification' : (context) => SetNotificationScreen(),
      },
    );
  }
}

