import 'package:day1/screens/community/user_calendar_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:day1/constants/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/community_model.dart';
import '../../services/community_service.dart';
import '../../widgets/molecules/report_dialogs.dart';
import 'community_card.dart';
import '../report_screen.dart';
import '../../providers/calendar_title_provider.dart'; // 프로바이더 import 추가

class CommunityScreen extends ConsumerStatefulWidget {
  final List<Community> communities;

  CommunityScreen({required this.communities});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  List<Community> _calendars = [];
  bool _hasNext = true;
  DateTime? _lastUpdatedAt;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _calendars = widget.communities; // 초기 데이터를 설정
    _hasNext = _calendars.isNotEmpty;
    if (_calendars.isNotEmpty) {
      _lastUpdatedAt = DateTime.parse(_calendars.last.updatedAt);
    }
  }

  Future<void> _fetchCalendars() async {
    if (_isLoading || !_hasNext) return;
    _isLoading = true;

    try {
      final result = await CommunityService().fetchCalendars(time: _lastUpdatedAt);
      List<Community> fetchedCalendars = result['communities'];
      setState(() {
        _calendars.addAll(fetchedCalendars);
        _hasNext = result['hasNext'];
        if (fetchedCalendars.isNotEmpty) {
          _lastUpdatedAt = DateTime.parse(fetchedCalendars.last.updatedAt);
        }
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
    }
  }

  void _navigateToUserCalendar(Community community) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserCalendarScreen(
          otherMemberId: community.id.toString(),
          profileImage: community.profileImage,
          memberName: community.memberName,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final calendarTitle = ref.watch(calendarTitleProvider) ?? 'calendarName'; // 캘린더 제목 가져오기

    return Scaffold(
      backgroundColor: backGroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'DAY1',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  TextSpan(
                    text: ' 캘린더 모아보기',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: gray900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && _hasNext) {
                  _fetchCalendars();
                }
                return true;
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: _calendars.length + 1,
                itemBuilder: (context, index) {
                  if (index == _calendars.length) {
                    return _isLoading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink();
                  }
                  return CommunityCard(
                    community: _calendars[index],
                    calendarTitle: calendarTitle, // 캘린더 제목 전달
                    onTap: () {
                      _navigateToUserCalendar(_calendars[index]);
                    },
                    onMoreOptionsTap: () {
                      showMoreOptionsDialog(context);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}