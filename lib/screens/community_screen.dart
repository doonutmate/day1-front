import 'package:flutter/material.dart';
import '../services/community_service.dart';
import '../models/community_model.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late Future<List<Community>> futureCalendars;

  @override
  void initState() {
    super.initState();
    futureCalendars = CommunityService().fetchCalendars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: FutureBuilder<List<Community>>(
        future: futureCalendars,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            return ListView(
              children: snapshot.data!.map((community) => CommunityCard(community: community)).toList(),
            );
          }
        },
      ),
    );
  }
}

class CommunityCard extends StatelessWidget {
  final Community community;

  CommunityCard({required this.community});

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
                Image.network(community.userProfileUrl, height: 50, width: 50, fit: BoxFit.cover),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(community.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('by ${community.userName}', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Registration Period: ${community.registrationPeriod}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4.0),
            Text('Total Registrations: ${community.registrationCount}'),
          ],
        ),
      ),
    );
  }
}