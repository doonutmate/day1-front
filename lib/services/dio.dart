import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';

// GET http://43.201.170.13:8081/challenge?year=2024&month=10
// http://43.201.170.13:8081/oauth/login?oauthType=KAKAO
// Dio라이브러리를 통한 HTTP 통신용 클래스
class DioService{
  //기본 주소
  static const String baseUri = "https://prod.doonut.site/";

  static Future<void> signOutDay1(String oauthType, String token, String reason) async{
    try{
      var dio = Dio();
      Map<String, dynamic> _data = {
        "oauthType" : oauthType,
        "code" : token,
        "reason" : reason
      };
      var response = await dio.delete(baseUri + "",data:_data);
      if(response.statusCode != 200){
        print("서버통신 에러");
      }
    }
    catch(e){
      print(e);
    }
  }

  static Future<dynamic> sendAppleTokenToServer(String token) async {
    try{
      var dio = Dio();
      //
      var response = await dio.post(baseUri + "oauth/login?oauthType=APPLE",data: {"accessToken": "${token}"});

      if(response.statusCode != null){
        if(response.statusCode! >= 200 && response.statusCode! < 300){
          return response.data;
        }
        else{
          return null;
        }
      }
    }
    catch (e){
      print(e);
    }

  }

  //서버로 이미지 업로드 하는 함수
  static Future<bool> uploadImage(File file, String token) async {
    try {

      // 파일 크기 확인 코드
      Uint8List? byteList = await file.readAsBytes();
      int? byte = byteList?.lengthInBytes;
      if(byte != null)
        print("전송전 이미지 크기 : ${(byte / 1048576)}");

      // 파일 경로를 통해 formData 생성
      var dio = Dio();
      dio.options.contentType = 'multipart/form-data';
      dio.options.headers = {
        "Authorization": "Bearer $token"
      };
      dio.options.maxRedirects.isFinite;
      var formData = FormData.fromMap(
          {'multipartFile': await MultipartFile.fromFile(file.path)});

      // 업로드 요청
      final response = await dio.post(baseUri + 'image-upload', data: formData);
      if (response.statusCode != 200) {
        print(await response.statusMessage);
        return false;
      }

      return true;
    } catch (e) {
      print('Error taking picture: $e');
      return false;
    }
  }

  //서버에서 캘린더에 표시할 이미지 받는 함수
  static Future<List<dynamic>?> getImageList(int year, int month, String token) async {
    try{
      var dio = Dio();
      //get header 설정
      dio.options.headers ={
        "Authorization": "Bearer $token"
      };
      Response response = await dio.get(
        baseUri + "challenge?year=${year}&month=${month}",
      );
      if (response.statusCode != 200) {
        print(await response.statusMessage);
        return null;
      }
      List<dynamic> responseList = response.data;
      return responseList;
    }
    catch(e){
      print(e);
      return null;
    }
  }
}