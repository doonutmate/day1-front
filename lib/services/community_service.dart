import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/community_model.dart';

class CommunityService {
  final String baseUrl = 'https://dev.doonut.site';

  Future<List<Community>> fetchCalendars() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/calendars?size=10'));
      if (response.statusCode == 200) {
        List<dynamic> communityJsonList = json.decode(response.body);
        return communityJsonList.map((json) => Community.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load community');
      }
    } catch (e) {
      throw Exception('Failed to load calendars: $e');
    }

  }
}

//  if (response.statusCode == 200) {
//         List<dynamic> calendarsJson = json.decode(response.body);
//         return calendarsJson.map((json) => Calendar.fromJson(json)).toList();
