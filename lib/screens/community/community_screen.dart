import 'package:day1/widgets/molecules/custom_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:day1/constants/colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/community_model.dart';
import '../../services/community_service.dart';
import '../../widgets/molecules/report_dialogs.dart';
import 'community_card.dart';
import '../report_screen.dart';
import '../../providers/calendar_title_provider.dart';
import 'user_calendar_screen.dart';

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
    _calendars = widget.communities;
    if (_calendars.isNotEmpty) {
      _lastUpdatedAt = DateTime.parse(_calendars.last.updatedAt as String);
    }

    _hasNext = _calendars.isNotEmpty;
  }

  Future<void> _fetchCalendars() async {
    if (_isLoading || !_hasNext) return;
    _isLoading = true;

    try {
      final result = await CommunityService().fetchCalendars(context, _lastUpdatedAt);
      List<Community> fetchedCalendars = result['communities'];

      setState(() {
        _calendars.addAll(fetchedCalendars.where((newCalendar) => !_calendars.any((existingCalendar) => existingCalendar.id == newCalendar.id)));
        _hasNext = result['hasNext'];
        if (_hasNext) {
          _lastUpdatedAt = DateTime.parse(fetchedCalendars.last.updatedAt as String);
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
          profileImage: community.profileImage,
          memberName: community.memberName,
          calendarName: community.calendarName,
          totalCount: community.totalCount,
          memberId: community.memberId,
          lastUploadedAt: community.lastUploadedAt,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final calendarTitle = ref.watch(calendarTitleProvider) ?? 'calendarName';

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 79.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'DAY1',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w800,
                      color: primary,
                    ),
                  ),
                  TextSpan(
                    text: ' 캘린더 모아보기',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      color: gray900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.0),
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
                    calendarTitle: calendarTitle,
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