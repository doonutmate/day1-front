import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:camera/camera.dart';
import 'package:day1/providers/calendar_title_provider.dart';
import 'package:day1/screens/calendar_screen.dart';
import 'package:day1/screens/camera/camera.dart';
import 'package:day1/screens/community/community_screen.dart'; //curl -sL https://firebase.tools | upgrade=true bash;
import 'package:day1/screens/login/login.dart';
import 'package:day1/screens/login/permision.dart';
import 'package:day1/screens/mypage/change_profile_screen.dart';
import 'package:day1/screens/mypage/my_page_screen.dart';
import 'package:day1/screens/mypage/set_calendar_screen.dart';
import 'package:day1/screens/mypage/set_notification_screen.dart';
import 'package:day1/screens/mypage/withdraw_screen.dart';
import 'package:day1/screens/s_main.dart';
import 'package:day1/services/app_database.dart';
import 'package:day1/services/auth_service.dart';
import 'package:day1/services/dio.dart';
import 'package:day1/services/pushnotification.dart';
import 'package:day1/services/server_token_provider.dart';
import 'package:day1/widgets/organisms/error_popup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_common.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';
import 'package:uni_links/uni_links.dart';
import 'firebase_options.dart';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if(message.notification != null){
    print(message.notification!.title);
  }
}

Future<void> setupInteractedMessage() async {
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  /*if(initialMessage != null){
    _handleMessage(initialMessage);
  }*/
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

void _handleMessage(RemoteMessage message){
  Future.delayed(const Duration(seconds: 1), (){
    navigatorKey.currentState!.pushNamed("/camera");
  });
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
final navigatorKey = GlobalKey<NavigatorState>();

late List<CameraDescription> cameras;

Future<void> main() async {
  String _authStatus = 'Unknown';

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

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  PushNotification.init();

  PushNotification.localNotiInit();

  //앱이 종료 상태일 때, 푸시 처리
  await FirebaseMessaging.instance.getInitialMessage();

  // 앱이 백그라운드 상태일 때, 푸시 처리
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      PushNotification.showSimpleNotification(title: message.notification!.title!, body: message.notification!.body!);
    }
  });

  Map<Permission, PermissionStatus> statuses = await [
    Permission.appTrackingTransparency,
  ].request();


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
    String? calendarTitle = ref.watch(calendarTitleProvider.notifier).state;
    VoidCallback? navigate;
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return Scaffold(
            body: AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: ErrorPopup(errorMassage: errorDetails.summary.toString(), navigate: navigate,),
            ),
          );
        };
        return widget!;
      },
      //기본 폰트 설정
      theme: ThemeData(
        fontFamily: "Pretendard",
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.black.withOpacity(0)),
      ),
      home: FutureBuilder(
          future: getToken(tokenProvider),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData && snapshot.data == true && calendarTitle != null) {
                return CameraScreen(cameras);
            } else {
              return Permision();
            }
          }),
      routes: {
        '/login': (context) => LoginScreen(),
        '/permision': (context) => Permision(),
        '/main': (context) => MainScreen(),
        '/camera': (context) => CameraScreen(cameras),
        '/withdraw' : (context) => WithdrawScreen(),
        '/changeprofile' : (context) => ChangeProfileScreen(),
        '/setcalendar' : (context) => SetCalendarScreen(),
        '/setnotification' : (context) => SetNotificationScreen(),
        '/mypage': (context) => MyPageScreen(),
      },
    );
  }
}

