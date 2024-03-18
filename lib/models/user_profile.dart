import 'dart:convert';
import 'package:http/http.dart' as http;

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

Future<UserProfile> fetchUserProfile() async {
  final response = await http.get(Uri.parse('https://dev.doonut.site/member/mypage'));

  if (response.statusCode == 200) {
    // 서버에서 응답받은 데이터를 JSON 형태로 디코딩
    final data = json.decode(response.body);
    // JSON 데이터를 UserProfile 객체로 변환
    return UserProfile.fromJson(data);
  } else {
    // 요청이 실패한 경우 에러를 던짐
    throw Exception('Failed to load user profile');
  }
}