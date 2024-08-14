import 'package:day1/widgets/molecules/custom_bottom_navigation_bar.dart';
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
import 'user_calendar_screen.dart'; // 추가

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
    if (_calendars.isNotEmpty) {
      _lastUpdatedAt = DateTime.parse(_calendars.last.updatedAt as String); // 초기화 시 마지막 게시물의 updatedAt 저장
    }

    //이러면 api에서 반환하는 hasNext 값에 상관없이 무조건 true가 저장된다. 08/09
    //s_main 파일에서 CommunityScreen생성자를 호출할 때 hasNext값도 넘겨줘야 한다.
    _hasNext = _calendars.isNotEmpty;
  }

  Future<void> _fetchCalendars() async {
    if (_isLoading || !_hasNext) return;
    _isLoading = true;

    try {
      final result = await CommunityService().fetchCalendars(context, _lastUpdatedAt); // _lastUpdatedAt 전달
      List<Community> fetchedCalendars = result['communities'];

      setState(() {
        // 중복 항목 제거
        _calendars.addAll(fetchedCalendars.where((newCalendar) => !_calendars.any((existingCalendar) => existingCalendar.id == newCalendar.id)));
        _hasNext = result['hasNext'];
        // hasNext 값으로 다음 리스트가 있을경우 다음 리스트를 불러오기위해 lastupdatedat 변수 업데이트 08/09
        if (_hasNext) {
          _lastUpdatedAt = DateTime.parse(fetchedCalendars.last.updatedAt as String); // 새로운 마지막 게시물의 updatedAt 저장
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
          lastUploadedAt: community.lastUploadedAt, // 캘린더 이름 전달
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