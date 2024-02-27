import 'dart:io';
import 'package:dio/dio.dart';

// GET http://43.201.170.13:8081/challenge?year=2024&month=10

// Dio라이브러리를 통한 HTTP 통신용 클래스
class DioService{
  //기본 주소
  static const String baseUri = "http://43.201.170.13:8081/";

  //서버로 이미지 업로드 하는 함수
  static Future<void> uploadImage(File file) async {
    try {
      // 파일 경로를 통해 formData 생성
      var dio = Dio();
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;
      var formData = FormData.fromMap(
          {'multipartFile': await MultipartFile.fromFile(file.path)});

      // 업로드 요청
      final response = await dio.post(baseUri + 'image-upload', data: formData);
      if (response.statusCode != 200) {
        print(await response.statusMessage);
      }

      return;
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  //서버에서 캘린더에 표시할 이미지 받는 함수
  static Future<List<dynamic>> getImageList(int year, int month) async {
    var dio = Dio();
    Response response = await dio.get(baseUri + "challenge-mock?year=${year}&month=${month}");
    if (response.statusCode != 200) {
      print(await response.statusMessage);
    }

    List<dynamic> responseList = response.data;
    return responseList;
  }
}