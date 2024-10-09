import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:camera/camera.dart';
import 'package:day1/providers/calendar_title_provider.dart';
import 'package:day1/screens/calendar_screen.dart';
import 'package:day1/screens/camera/camera.dart';
import 'package:day1/screens/community/community_screen.dart';
import 'package:day1/screens/login/login.dart';
import 'package:day1/screens/login/permision.dart';
import 'package:day1/screens/mypage/change_profile_screen.dart';
import 'package:day1/screens/mypage/my_page_screen.dart';
import 'package:day1/screens/mypage/set_calendar_screen.dart';
import 'package:day1/screens/mypage/set_notification_screen.dart';
import 'package:day1/screens/mypage/withdraw_screen.dart';
import 'package:day1/screens/mypage/withdraw_screen2.dart';
import 'package:day1/screens/s_main.dart';
import 'package:day1/services/app_database.dart';
import 'package:day1/services/auth_provider.dart';
import 'package:day1/services/auth_service.dart';
import 'package:day1/services/dio.dart';
import 'package:day1/services/pushnotification.dart';
import 'package:day1/services/server_token_provider.dart';
import 'package:day1/widgets/organisms/error_popup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_common.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uni_links/uni_links.dart';
import 'constants/colors.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    print(message.notification!.title);
  }
}

Future<void> setupInteractedMessage() async {
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

void _handleMessage(RemoteMessage message) {
  Future.delayed(const Duration(seconds: 1), () {
    navigatorKey.currentState!.pushNamed("/camera");
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

final navigatorKey = GlobalKey<NavigatorState>();

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();
  await initializeDateFormatting();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  cameras = await availableCameras();

  String? initialUrl;
  try {
    initialUrl = await getInitialLink();
  } catch (e) {
    print("Failed to get initial link: $e");
  }

  KakaoSdk.init(
    nativeAppKey: '96d13b457170f00f736d874770b66f84',
    javaScriptAppKey: '27d258fa70f6d2fd19c92fe135ed0bda',
  );

  PushNotification.init();
  PushNotification.localNotiInit();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(ProviderScope(child: MyApp(initialUrl: initialUrl)));
}

class MyApp extends ConsumerWidget {
  final String? initialUrl;

  MyApp({super.key, this.initialUrl});

  Future<bool> getToken(ServerTokenStateNotifier provider) async {
    bool isKaKao = await AuthService.isLoggedIn();
    String? token = await AppDataBase.getToken();
    bool isServerToken = token != null;

    if (isKaKao || isServerToken) {
      provider.setServerToken(token);
      return true;
    } else {
      AppDataBase.clearToken();
      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isSignedOut = ref.watch(authProvider);

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Pretendard",
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.black.withOpacity(0),
        ),
      ),
      home: Consumer(
        builder: (context, ref, child) {
          if (isSignedOut) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WithdrawScreen2(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false,
                      );
                    },key: Key('withdraw_screen2'),
                  ),
                ),
              );
            });
          }

          return FutureBuilder<bool>(
            future: getToken(ref.read(ServerTokenProvider.notifier)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data == true) {

                return CameraScreen(cameras);
              } else {
                return Permision();
              }
            },
          );
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/permision': (context) => Permision(),
        '/main': (context) => MainScreen(),
        '/camera': (context) => CameraScreen(cameras),
        '/withdraw': (context) => WithdrawScreen(),
        '/changeprofile': (context) => ChangeProfileScreen(),
        '/setcalendar': (context) => SetCalendarScreen(),
        '/setnotification': (context) => SetNotificationScreen(),
        '/mypage': (context) => MyPageScreen(),
        '/withdraw_screen2': (context) => WithdrawScreen2(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
            );
          }, key: Key('withdraw_screen2'),
        ),
      },
    );
  }
}