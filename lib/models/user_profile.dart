import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_url.dart';



// 사용자 정보를 담을 모델
class UserProfile {
  final String nickname;
  final String profileImageUrl;

  UserProfile({required this.nickname, required this.profileImageUrl});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nickname: json['nickname'] ?? '게스트',
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }
}

Future<dynamic> fetchUserProfile(String token) async {

  final response = await http.get(
    Uri.parse(baseUrl + 'member/mypage'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    // 서버에서 응답받은 데이터를 JSON 형태로 디코딩
    // 한글은 깨지는 현상이 발생해서 먼저 byte에서 string으로 컨버팅 하고 그뒤로 json으로 컨버팅
    final data = json.decode(utf8.decode(response.bodyBytes));

    // JSON 데이터를 UserProfile 객체로 변환
    return UserProfile.fromJson(data);

  } else {
    String errorMessage;
    // 에러 처리
    if(response.statusCode >= 500){
      errorMessage = "Error서버가 불안정해 정보를 불러올 수 없어요";
    }
    else{
      errorMessage = "Error" + response.body;
    }
    return errorMessage;
  }

}