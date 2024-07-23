import 'package:day1/constants/colors.dart';
import 'package:day1/models/community_model.dart';
import 'package:day1/screens/calendar_screen.dart';
import 'package:day1/screens/camera/camera.dart';
import 'package:day1/screens/community/community_screen.dart';
import 'package:day1/screens/community/community_lock_screen.dart';
import 'package:day1/screens/mypage/my_page_screen.dart';
import 'package:day1/services/device_size_provider.dart';
import 'package:day1/services/community_service.dart';
import 'package:day1/widgets/molecules/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../widgets/molecules/show_Error_Popup.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;
  final CommunityService communityService = CommunityService();
  bool _showCommunityLock = false;

  final List<Widget> _widgetOptions = <Widget>[
    CalendarScreen(),
    CameraScreen(cameras),
    Container(), // 커뮤니티 화면을 위한 빈 컨테이너
    MyPageScreen()
  ];

  @override
  void initState() {
    super.initState();
    // 초기에 커뮤니티 탭을 로드하지 않음
  }

  Future<void> _fetchCommunityData() async {
    try {
      final result = await communityService.fetchCalendars(context, null); // null을 lastUpdatedAt으로 전달
      final status = result['status'];
      final message = result['message'];
      final errorCode = result['errorCode'];
      print('Status code: $status'); // 상태 코드 출력
      print('Result data: ${result.toString()}'); // 결과 데이터 출력

      if (status == 200) {
        final List<Community> communities = result['communities'];
        setState(() {
          _widgetOptions[2] = CommunityScreen(communities: communities);
          _showCommunityLock = false;
        });
      } else if (status == 400 && errorCode == null) {
        setState(() {
          _showCommunityLock = true;
        });
      } else {
        print('Error: $message');
        showErrorPopup(context, 'Failed to load calendars: $message');
      }
    } catch (e) {
      print('Error: $e');
      showErrorPopup(context, 'Failed to load calendars: $e');
    }
  }

  void _onItemTapped(int index) async {
    if (index == 2) { // 커뮤니티 탭의 인덱스
      await _fetchCommunityData();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToCalendar() {
    setState(() {
      _selectedIndex = 0; // 캘린더 화면 인덱스로 설정
      _showCommunityLock = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ref.watch(deviceSizeProvider.notifier).setDeviceWidth(width);
    ref.watch(deviceSizeProvider.notifier).setDeviceHeight(height);

    return Scaffold(
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: _showCommunityLock && _selectedIndex == 2
            ? CommunityLockScreen(onTap: _navigateToCalendar)
            : _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}