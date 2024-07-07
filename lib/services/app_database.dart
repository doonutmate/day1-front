import 'package:shared_preferences/shared_preferences.dart';

//앱 내부 저장소 관리 클래스
class AppDataBase{

  // 저장 함수
  static Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
    print('토큰 저장: $token');  // 토큰 저장 확인 로그
  }

  // 불러오는 함수
  static Future<String?> getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    print('불러온 토큰: $token');  // 토큰 불러오기 확인 로그
    return token;
  }

  // 초기화 함수
  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    print('토큰 초기화');
  }
}