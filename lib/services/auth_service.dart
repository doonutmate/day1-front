import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  // 카카오톡 실행 가능 여부 확인
  // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
  Future<OAuthToken?> signInWithKakao(BuildContext context) async {
    bool isInstalled = await isKakaoTalkInstalled();
    OAuthToken? token;

    if (isInstalled) {
      try {
        token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
        Navigator.pushNamed(context, '/camera');
        // 백엔드로 토큰 전송
        return token; // 토큰 반환
        // await sendTokenToServer(token.accessToken);
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return null;
        } else {
          // 다른 오류인 경우 null 반환
          return null;
        }
      }
    } else {
      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
      try {
        token = await UserApi.instance.loginWithKakaoAccount();
        // OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        // await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
        Navigator.pushNamed(context, '/camera');
        return token;
        // 백엔드로 토큰 전송
        // await sendTokenToServer(token.accessToken);
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        // 다른 오류인 경우 null 반환
        return null;
      }
    }
  }


  Future<void> kakaoToken() async {
    if (await AuthApi.instance.hasToken()) {
      try {
        // 현재 토큰의 유효성 체크
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        int id1 = tokenInfo.appId;
        print('토큰 유효성 체크 성공'
            '\n회원정보: ${tokenInfo.id}'
            '\n만료시간: ${tokenInfo.expiresIn} 초'
            '\n토큰 스트링: ${tokenInfo.toString()}');
        // 여기서는 유효한 토큰이 있으므로 추가 로그인 없이 필요한 작업을 진행하면 됩니다.
      } catch (error) {
        // 토큰 만료 또는 유효하지 않은 경우
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 또는 유효하지 않음 $error');
          // 여기서 사용자를 다시 로그인하게 하는 대신, 필요한 경우 로그인 화면으로 유도하는 로직을 추가할 수 있습니다.
          try {
            OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
            print('로그인 성공 ${token.accessToken}');
            // 백엔드로 토큰 전송
            await sendTokenToServer(token.accessToken);
          } catch (error) {
            print('로그인 실패 $error');
          }
        } else {
          print('토큰 정보 조회 실패 $error');
        }
      }
    } else {
      print('발급된 토큰 없음. 사용자 로그인 필요.');
      // 여기서 사용자를 로그인 화면으로 유도할 수 있습니다.
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('로그인 성공 ${token.accessToken}');
        // 백엔드로 토큰 전송
        await sendTokenToServer(token.accessToken);
      } catch (error) {
        print('로그인 실패 $error');
      }
    }
  }


  Future<String?> sendTokenToServer(String token) async {
    print('서버로 전송할 토큰: $token'); // 요청 데이터 로깅
    try {
      var response = await http.post(
        Uri.parse('http://43.201.170.13:8081/oauth/login?oauthType=KAKAO'),
        // 백엔드 서버의 토큰 검증 엔드포인트
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'accessToken': token,
        }),
      );

      // print('서버 응답 상태 코드: ${response.statusCode}'); // 응답 상태 코드 로깅
      // print('서버 응답 본문: ${response.body}'); // 응답 본문 로깅

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // 서버로부터의 응답 처리
        print('토큰 서버 전송 성공: ${response.body}');
        return response.body;
      } else {
        // 에러 처리
        print('토큰 서버 전송 실패: ${response.body}');
        return null;
      }
    } catch (e) {
      print('서버 전송 중 에러 발생: $e');
    }
  }

  Future<void> requestUserInfo() async {
    try {
      User user = await UserApi.instance.me();
      print('사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${user.kakaoAccount?.email}');
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      return await AuthApi.instance.hasToken();
    } catch (e) {
      print('로그인 상태 확인 중 에러 발생: $e');
      return false;
    }
  }

  Future<void> logoutKakao() async {
    try {
      await UserApi.instance.logout();
      print('로그아웃 성공, SDK에서 토큰 삭제');
    } catch (error) {
      print('로그아웃 실패, SDK에서 토큰 삭제 $error');
    }
  }

  Future<void> unlinkKakao() async {
    try {
      await UserApi.instance.unlink();
      print('연결 끊기 성공, SDK에서 토큰 삭제');
    } catch (error) {
      print('연결 끊기 실패 $error');
    }
  }
}
