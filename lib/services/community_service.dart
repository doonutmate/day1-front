import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/community_model.dart';
import 'package:day1/services/app_database.dart';

class CommunityService {
  final String baseUrl = 'https://dev.doonut.site';

  Future<List<Community>> fetchCalendars() async {
    String? accessToken = await AppDataBase.getToken();

    if (accessToken == null) {
      throw Exception('No access token found');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/calendars?size=10'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      print('Request URL: ${response.request!.url}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> communityJsonList = json.decode(response.body);
        return communityJsonList.map((json) => Community.fromJson(json)).toList();
      } else {
        print('Failed to load community: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load community');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load calendars: $e');
    }
  }
}