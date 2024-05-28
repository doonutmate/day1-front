import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CommunityPage(),
    );
  }
}

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<Calendar> _calendars = [];

  @override
  void initState() {
    super.initState();
    _fetchCalendars();
  }

  Future<void> _fetchCalendars() async {
    final response = await http.get(Uri.parse('http://yourserver.com/api/calendars'));

    if (response.statusCode == 200) {
      final List<dynamic> calendarJson = json.decode(response.body);
      setState(() {
        _calendars = calendarJson.map((json) => Calendar.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load calendars');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: _calendars.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
        children: _calendars.map((calendar) => CalendarCard(calendar: calendar)).toList(),
      ),
    );
  }
}

class Calendar {
  final String profileImage;
  final String date;
  final String name;
  final String nickname;
  final int totalPhotos;
  final String firstPhotoDate;
  final String lastPhotoDate;

  Calendar({
    required this.profileImage,
    required this.date,
    required this.name,
    required this.nickname,
    required this.totalPhotos,
    required this.firstPhotoDate,
    required this.lastPhotoDate,
  });

  factory Calendar.fromJson(Map<String, dynamic> json) {
    return Calendar(
      profileImage: json['profileImage'],
      date: json['date'],
      name: json['name'],
      nickname: json['nickname'],
      totalPhotos: json['totalPhotos'],
      firstPhotoDate: json['firstPhotoDate'],
      lastPhotoDate: json['lastPhotoDate'],
    );
  }
}

class CalendarCard extends StatelessWidget {
  final Calendar calendar;

  CalendarCard({required this.calendar});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(calendar.profileImage, height: 50, width: 50, fit: BoxFit.cover),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(calendar.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('by ${calendar.nickname}', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Date: ${calendar.date}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4.0),
            Text('Total Photos: ${calendar.totalPhotos}'),
            Text('From: ${calendar.firstPhotoDate}'),
            Text('To: ${calendar.lastPhotoDate}'),
          ],
        ),
      ),
    );
  }
}
