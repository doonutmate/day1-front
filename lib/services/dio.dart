import 'dart:io';

import 'package:dio/dio.dart';

class DioService{
  static const String baseUri = "http://43.201.170.13:8081/";

  static Future<void> uploadImage(File file) async {
    try {
      // 파일 경로를 통해 formData 생성
      var dio = Dio();
      var formData = FormData.fromMap(
          {'multipartFile': await MultipartFile.fromFile(file.path)});

      // 업로드 요청
      final response =
      await dio.post(baseUri + 'image-upload', data: formData);
      if (response.statusCode != 200) {
        print(await response.statusMessage);
      }
      //print(response.data.toString());

      return;
    } catch (e) {
      print('Error taking picture: $e');
    }
  }
}