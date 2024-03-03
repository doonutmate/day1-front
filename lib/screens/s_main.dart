import 'package:day1/constants/colors.dart';
import 'package:day1/screens/calendar_screen.dart';
import 'package:day1/screens/my_page_screen.dart';
import 'package:day1/services/device_size_provider.dart';
import 'package:day1/widgets/molecules/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_file.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();

}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    CalendarScreen(),
    MyPageScreen()
  ]; // 2개의 페이지를 연결할 예정이므로 2개의 페이지를 여기서 지정해준다. 탭 레이아웃은 2개.

  @override
  void initState() {
    super.initState();
    //initializeDateFormatting(Localizations.localeOf(context).languageCode,"");
  }

  void _onItemTapped(int index) {
    // 탭을 클릭했을떄 지정한 페이지로 이동
    setState(() {
      _selectedIndex = index;
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
      body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
