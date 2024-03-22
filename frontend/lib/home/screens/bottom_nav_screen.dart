import 'package:flutter/material.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/home/screens/home_screen.dart';
import 'package:frontend/card/widgets/registration_modal.dart';
import 'package:frontend/chart/screens/expense_analytics_screen.dart';
import 'package:frontend/card/screens/card_screen.dart';

enum NavigationTab { home, myCards, expenses }

Widget _getPageForTab(NavigationTab tab) {
  switch (tab) {
    case NavigationTab.home:
      return HomeScreen(); // 홈화면으로 이동
    case NavigationTab.myCards:
      return CardScreen(myCardFlag: 0); // 지금은 카드가 없을 때 모달 화면으로 이동, 임시입니다.
    case NavigationTab.expenses:
      return ExpenseAnalyticsScreen(); // 내 소비 통계 페이지로 이동
    default:
      return HomeScreen(); // 기본값으로 홈화면 설정
  }
}

/// 앱 전반 네비게이션을 관리하는 화면
class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  NavigationTab _selectedTab = NavigationTab.home;

  void _onItemTapped(int index) {
    setState(() {
      _selectedTab = NavigationTab.values[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedTab.index,
        children:
            NavigationTab.values.map((tab) => _getPageForTab(tab)).toList(),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '홈'),
            BottomNavigationBarItem(
                icon: Icon(Icons.credit_card), label: '내카드'),
            BottomNavigationBarItem(icon: Icon(Icons.donut_small), label: '소비'),
          ],
          currentIndex: _selectedTab.index,
          onTap: _onItemTapped,
          backgroundColor: AppColors.bottomGrey,
          selectedItemColor: AppColors.mainBlue,
          unselectedItemColor: AppColors.lightGrey,
          selectedLabelStyle: AppFonts.scDream(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: AppFonts.scDream(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
