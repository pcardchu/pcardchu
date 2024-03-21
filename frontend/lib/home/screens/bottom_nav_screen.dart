import 'package:flutter/material.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
// import 'home_page.dart';
// import 'my_cards_page.dart';
// import 'expenses_page.dart';

// enum NavigationTab { home, myCards, expenses }
// //
// Widget _getPageForTab(NavigationTab tab) {
//   switch (tab) {
//     case NavigationTab.home:
//       return HomePage();
//     case NavigationTab.myCards:
//       return MyCardsPage();
//     case NavigationTab.expenses:
//       return ExpensesPage();
//     default:
//       return HomePage(); // 기본값으로 홈 페이지 반환
//   }
// }
//
// /// 앱 전반 네비게이션을 관리하는 화면
// class BottomNavScreen extends StatefulWidget {
//   const BottomNavScreen({super.key});
//
//   @override
//   State<BottomNavScreen> createState() => _BottomNavScreenState();
// }
//
// class _BottomNavScreenState extends State<BottomNavScreen> {
//   NavigationTab _selectedTab = NavigationTab.home;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedTab = NavigationTab.values[index];
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedTab.index,
//         children: NavigationTab.values.map((tab) => _getPageForTab(tab)).toList(),
//       ),
//       bottomNavigationBar: ClipRRect(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//         child: BottomAppBar(
//           child: BottomNavigationBar(
//             items: const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//               BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'My Cards'),
//               BottomNavigationBarItem(icon: Icon(Icons.money_off), label: 'Expenses'),
//             ],
//             currentIndex: _selectedTab.index,
//             onTap: _onItemTapped,
//             backgroundColor: AppColors.bottomGrey, // Optional: Change background color
//             selectedItemColor: AppColors.mainBlue, // Optional: Change selected item color
//             unselectedItemColor: AppColors.lightGrey, // Optional: Change unselected item color
//           ),
//         ),
//       ),
//     );
//   }
//  }