import 'package:shared_preferences/shared_preferences.dart';

//앱 내부 저장소 관리 클래스
class AppDataBase{

  // 저장 함수
  static Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', token);
  }

  // 불러오는 함수
  static Future<String?> getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    return token;
  }

  // 초기화 함수
  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}