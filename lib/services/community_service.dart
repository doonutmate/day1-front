import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import '../models/community_model.dart';
import 'package:day1/services/app_database.dart';

class CommunityService {
  final String baseUrl = 'https://dev.doonut.site';
  final Dio dio = Dio();

  Future<Map<String, dynamic>> fetchCalendars(BuildContext context, DateTime? lastUpdatedAt) async {
    String? accessTokenJson = await AppDataBase.getToken();

    if (accessTokenJson == null) {
      throw Exception('No access token found');
    }

    Map<String, dynamic> accessTokenMap = json.decode(accessTokenJson);
    String accessToken = accessTokenMap['accessToken'];

    if (accessToken == null) {
      throw Exception('Access token is null');
    }

    try {
      String uri = '$baseUrl/calendars?size=10';
      if (lastUpdatedAt != null) {
        uri += '&updated_at=${lastUpdatedAt.toIso8601String()}';
      }

      print('Request URI: $uri');
      final response = await dio.get(
        uri,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      print('Request Headers: ${response.requestOptions.headers}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = response.data;
        List<dynamic> communityJsonList = jsonResponse['values'];
        List<Community> communities = communityJsonList.map((json) => Community.fromJson(json)).toList();
        bool hasNext = jsonResponse['hasNext'];
        return {
          'status': 200,
          'communities': communities,
          'hasNext': hasNext,
        };
      } else if (response.statusCode == 400) {
        return {
          'status': response.data['httpStatus'],
          'message': response.data['message'],
          'errorCode': response.data['errorCode']
        };
      } else {
        if (response.statusCode! >= 500) {
          return {
            'status': response.statusCode,
            'message': "서버가 불안정해 정보를 불러올 수 없어요",
          };
        } else {
          return {
            'status': response.statusCode,
            'message': response.data["message"],
          };
        }
      }
    } on DioException catch (e) {
      String errorMessage;
      if (e.response != null) {
        if (e.response!.statusCode! >= 500) {
          errorMessage = "서버가 불안정해 정보를 불러올 수 없어요";
        } else {
          errorMessage = e.response!.data["message"];
        }
        return {
          'status': e.response?.statusCode,
          'message': errorMessage,
        };
      } else {
        throw Exception('서버가 불안정해 정보를 불러올 수 없어요');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('서버가 불안정해 정보를 불러올 수 없어요');
    }
  }
}