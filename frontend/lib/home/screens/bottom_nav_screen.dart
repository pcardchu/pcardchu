import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/home/screens/home_screen.dart';
import 'package:frontend/card/widgets/card_screen/registration_modal.dart';
import 'package:frontend/chart/screens/expense_analytics_screen.dart';
import 'package:frontend/card/screens/card_screen.dart';
import 'package:frontend/providers/card_list_provider.dart';

enum NavigationTab { home, myCards, expenses }

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

  Widget _getPageForTab(NavigationTab tab) {
    switch (tab) {
      case NavigationTab.home:
        return HomeScreen(); // 홈화면으로 이동
      case NavigationTab.myCards:
        final isCardRegistered = Provider.of<CardListProvider>(context, listen: false).isCardRegistered;
        return CardScreen(myCardFlag: isCardRegistered ? 1 : 0); // 카드가 있으면 1, 없으면 0
      case NavigationTab.expenses:
        return ExpenseAnalyticsScreen(); // 내 소비 통계 페이지로 이동
      default:
        return HomeScreen(); // 기본값으로 홈화면 설정
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _getPageForTab(_selectedTab),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: '내카드'),
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
